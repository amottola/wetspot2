' SETUP.BAS
' The WetSpot 2 configuration setup program
' by Enhanced Creations 1997-98
' version 1.0
'
DEFINT A-Z
TYPE JoyStick
  detected AS INTEGER
  but AS INTEGER
  x AS INTEGER
  y AS INTEGER
  xc AS INTEGER
  yc AS INTEGER
  res AS INTEGER
END TYPE

DECLARE SUB SelUp (MaxSel)
DECLARE SUB SelDown (MaxSel)
DECLARE SUB UpdateMenu ()
DECLARE SUB Init ()
DECLARE SUB Center (y, Text$, ForeCol, BackCol)
DECLARE SUB DrawWindow (x1, y1, x2, y2, Title$, ForeCol, BackCol, Style)
DECLARE SUB ReadJoy (J)
DECLARE SUB WriteReg (Reg, Value)
DECLARE SUB GetIntVector (IntNum%, segment%, offset%)
DECLARE FUNCTION SBMIDIloaded ()
DECLARE FUNCTION DetectCard ()
DECLARE FUNCTION EMSpages (func)
DECLARE FUNCTION pageframe ()
DECLARE FUNCTION EMSstatus ()
DECLARE FUNCTION SelectMenu (MaxSel)

CONST FALSE = 0, TRUE = NOT FALSE, NUMSOUNDS = 18

ON ERROR GOTO ErrorHandler

DIM SHARED Joy(1) AS JoyStick, Mask(1, 4), Keys(1, 4)
DIM SHARED CardOK, BasePort, Channel, Volume, Soundon, MusicOn, Control(1)
DIM SHARED MenuText$(3), MenuMessage$(3), MenuAvailable(3), Sel, fxSwitch

Init
DO
  RESTORE MainMenu
  FOR i = 0 TO 3: READ MenuText$(i), MenuMessage$(i)
  MenuAvailable(i) = TRUE
  Sel = 0: IF CardOK = FALSE THEN MenuAvailable(0) = FALSE: Sel = 1
  NEXT i
  SELECT CASE SelectMenu(3)
  CASE 0
    Sel = 0
    DO
      RESTORE SoundMenu
      FOR i = 0 TO 3: READ MenuText$(i), MenuMessage$(i)
      MenuAvailable(i) = TRUE: NEXT i
      SELECT CASE fxSwitch
      CASE 0: MenuText$(2) = "        Musics are off        "
      CASE 1: MenuText$(2) = "        Sounds are off        "
      CASE 2: MenuText$(2) = "   Sounds and musics are off  "
      CASE 3: MenuText$(2) = "   Sounds and musics are on   "
      END SELECT
      SELECT CASE SelectMenu(3)
      CASE 0
        FOR i = 0 TO 3: MenuText$(i) = "             " + HEX$(528 + (i * 16)) + "h             "
        MenuMessage$(i) = "Select a new base port address": MenuAvailable(i) = TRUE: NEXT i
        Sel = (BasePort - 528) \ 16: BasePort = 528 + (SelectMenu(3) * 16): Sel = 0
        COLOR 15, 1: LOCATE 8, 44: PRINT "Sound card base address: " + HEX$(BasePort) + "h"
      CASE 1
        FOR i = 0 TO 3: MenuText$(i) = "              " + STR$(i) + "              "
        MenuMessage$(i) = "Select the new low DMA channel to be used": MenuAvailable(i) = TRUE: NEXT i
        Sel = Channel: Channel = SelectMenu(3): Sel = 0
        COLOR 15, 1: LOCATE 9, 44: PRINT "DMA channel:" + STR$(Channel)
      CASE 2
        fxSwitch = (fxSwitch + 1) MOD 4
        LOCATE 10, 44: COLOR 15, 1
        SELECT CASE fxSwitch
        CASE 0: PRINT "Musics are off           "
        CASE 1: PRINT "Sounds are off           "
        CASE 2: PRINT "Sounds and musics are off"
        CASE 3: PRINT "Sounds and musics are on "
        END SELECT
      CASE 3: EXIT DO
      END SELECT
    LOOP
  CASE 1
    Sel = 0
    DO
      RESTORE ControlMenu
      FOR i = 0 TO 3: READ MenuText$(i), MenuMessage$(i)
      MenuAvailable(i) = TRUE: NEXT i
      FOR i = 0 TO 1
        IF Joy(i).detected = FALSE THEN MenuAvailable(i + 1) = FALSE
      NEXT i
      SELECT CASE SelectMenu(3)
      CASE 0
        Keys(0, 0) = 80: Keys(0, 1) = 75: Keys(0, 2) = 72: Keys(0, 3) = 77
        Keys(0, 4) = 28: Keys(1, 0) = 31: Keys(1, 1) = 30: Keys(1, 2) = 17
        Keys(1, 3) = 32: Keys(1, 4) = 15
        PCOPY 0, 1
        DrawWindow 16, 10, 65, 14, "", 0, 3, 1
        Center 11, "Keys are now reset to their default values;", 0, 3
        Center 12, "see the README.TXT file for more info.     ", 0, 3
        Center 13, "<press any key to continue>", 0, 3
        WHILE INKEY$ = "": WEND
        PCOPY 1, 0
      CASE 1, 2
        CurJoy = Sel - 1
        RESTORE JoystickMenu
        FOR i = 0 TO 3: READ MenuText$(i), MenuMessage$(i)
        MenuAvailable(i) = TRUE: NEXT i
        Sel = 0
        DO
          SELECT CASE SelectMenu(3)
          CASE 0
            PCOPY 0, 1
            DrawWindow 6, 6, 75, 9, ("Testing joystick" + STR$(CurJoy + 1)), 0, 3, 1
            Center 7, "Move the joystick around; the cursor should go in all directions.", 0, 3
            Center 8, "Press <ESC> when done.", 0, 3
            DrawWindow 35, 11, 46, 17, "", 0, 7, 0
            COLOR 7, 0: LOCATE 14, 40: PRINT "  ": ox = 0: oy = 0
            Joy(CurJoy).xc = 0: Joy(CurJoy).yc = 0
            ReadJoy CurJoy
            Joy(CurJoy).xc = Joy(CurJoy).x: Joy(CurJoy).yc = Joy(CurJoy).y
            DO
              ReadJoy CurJoy
              jx = 0: jy = 0
              IF Joy(CurJoy).x < -Joy(CurJoy).res THEN jx = -1
              IF Joy(CurJoy).x > Joy(CurJoy).res THEN jx = 1
              IF Joy(CurJoy).y < -Joy(CurJoy).res THEN jy = -1
              IF Joy(CurJoy).y > Joy(CurJoy).res THEN jy = 1
              IF jx <> ox OR jy <> oy THEN
                COLOR 7, 0: LOCATE 14 + (oy * 2), 40 + (ox * 4): PRINT "ÛÛ"
              END IF
              ox = jx: oy = jy: LOCATE 14 + (oy * 2), 40 + (ox * 4)
              IF Joy(CurJoy).but THEN COLOR 14, 0: PRINT "ÛÛ" ELSE COLOR 7, 0: PRINT "  "
              k$ = INKEY$: IF k$ = CHR$(27) THEN EXIT DO
            LOOP
            PCOPY 1, 0
          CASE 1
            IF Joy(CurJoy).res < 99 THEN Joy(CurJoy).res = Joy(CurJoy).res + 1
            COLOR 15, 1: LOCATE 11 + CurJoy, 44
            PRINT "Joystick" + STR$(CurJoy + 1) + " resolution:" + STR$(Joy(CurJoy).res) + " "
          CASE 2
            IF Joy(CurJoy).res > 1 THEN Joy(CurJoy).res = Joy(CurJoy).res - 1
            COLOR 15, 1: LOCATE 11 + CurJoy, 44
            PRINT "Joystick" + STR$(CurJoy + 1) + " resolution:" + STR$(Joy(CurJoy).res) + " "
          CASE 3: EXIT DO
          END SELECT
        LOOP
      CASE 3: EXIT DO
      END SELECT
    LOOP
  CASE 2
    RESTORE QuitSaveMenu
    FOR i = 0 TO 3: READ MenuText$(i), MenuMessage$(i)
    MenuAvailable(i) = TRUE: NEXT i
    Sel = 0
    SELECT CASE SelectMenu(1)
    CASE 0
      SELECT CASE fxSwitch
      CASE 0: MusicOn = FALSE: Soundon = TRUE
      CASE 1: MusicOn = TRUE: Soundon = FALSE
      CASE 2: MusicOn = FALSE: Soundon = FALSE
      CASE 3: MusicOn = TRUE: Soundon = TRUE
      END SELECT
      OPEN "WETSPOT2.CFG" FOR BINARY AS #1: CLOSE #1: KILL "WETSPOT2.CFG"
      OPEN "WETSPOT2.CFG" FOR BINARY AS #1
      PUT #1, , BasePort: PUT #1, , Channel: PUT #1, , Volume
      PUT #1, , Soundon: PUT #1, , MusicOn
      FOR i = 0 TO 1: PUT #1, , Control(i): NEXT i
      FOR i = 0 TO 1: FOR ii = 0 TO 4: PUT #1, , Keys(i, ii): NEXT ii, i
      PUT #1, , Joy(0).res: PUT #1, , Joy(1).res
      CLOSE #1
      EXIT DO
    END SELECT
  CASE 3
    RESTORE QuitWithoutSaveMenu
    FOR i = 0 TO 3: READ MenuText$(i), MenuMessage$(i)
    MenuAvailable(i) = TRUE: NEXT i
    Sel = 0
    SELECT CASE SelectMenu(1)
    CASE 0
      EXIT DO
    END SELECT
  END SELECT
LOOP
COLOR 7, 0: CLS
END

ErrorHandler:
SCREEN 0: WIDTH 80: CLS
IF ERR > 52 THEN
  PRINT "There was an error accessing disk; it may be full or not ready."
ELSE
  PRINT "General program error occured."
END IF
PRINT "Setup aborted."
END

MainMenu:
DATA "          Sound menu          "
DATA "Allows to change the sound settings"
DATA "         Control menu         "
DATA "Edits the player input controls"
DATA "    Save settings and exit    "
DATA "Writes configuration on WETSPOT2.CFG and exits the program"
DATA "      Exit without saving     "
DATA "Exits the program without saving changes"
QuitWithoutSaveMenu:
DATA "   Yes, quit without saving   "
DATA "Confirms to exit the program without saving changes"
DATA "       Back to main menu      "
DATA "Doesn't quit the program"
DATA "                              "
DATA ""
DATA "                              "
DATA ""
QuitSaveMenu:
DATA "   Yes, quit saving changes   "
DATA "Confirms to exit the program saving changes"
DATA "       Back to main menu      "
DATA "Doesn't quit the program"
DATA "                              "
DATA ""
DATA "                              "
DATA ""
SoundMenu:
DATA "     Base port address...     "
DATA "Allows to change the base port address of your sound card"
DATA "        DMA channel...        "
DATA "Allows to change the low DMA channel used by your sound card"
DATA "   Sounds and musics are on   "
DATA "Switches musics and sounds on and off"
DATA "      Back to main menu       "
DATA "Ends sounds customization"
ControlMenu:
DATA "     Reset keys to default    "
DATA "Sets the default key settings for both KEYBOARD 1 and 2 (see README.TXT)"
DATA "    Joystick one settings...  "
DATA "Allows to change joystick one resolution and to test it"
DATA "    Joystick two settings...  "
DATA "Allows to change joystick two resolution and to test it"
DATA "       Back to main menu      "
DATA "Ends controls customization"
JoystickMenu:
DATA "         Test joystick        "
DATA "Opens the joystick test container box"
DATA "      Increase resolution     "
DATA "Increase joystick resolution"
DATA "      Decrease resolution     "
DATA "Decrease joystick resolution"
DATA "       Back to main menu      "
DATA "Ends joystick customization"

SBMIDIData:
DATA &H9C,&H1E,&H06,&H50,&H53,&H51,&H52,&H57,&H56,&H55,&H8B,&HEC,&H50,&HB8
DATA &H0E,&H10,&H8E,&HD8,&H8E,&HC0,&H58,&H83,&H4E,&H18,&H01,&HC7,&H46,&H0C
DATA &HFF,&HFF,&H80,&H3E,&H44,&H01,&H00,&H75,&H3B,&HC6,&H06,&H44,&H01,&H01
DATA &HFB,&HFC,&H0B,&HDB,&H78,&H15,&H81,&HFB,&H0D,&H00,&H73,&H25,&H83,&H66
DATA &H18,&HFE,&HD1,&HE3,&HFF,&H97,&H28,&H00,&H89,&H46,&H0C,&HEB,&H16,&HF7
DATA &HDB,&H4B,&H81,&HFB,&H03,&H00,&H73,&H0D,&H83,&H66,&H18,&HFE,&HD1,&HE3
DATA &HFF,&H97,&H22,&H00,&H89,&H46,&H0C,&HC6,&H06,&H44,&H01,&H00,&H5D,&H5E
DATA &H5F,&H5A,&H59,&H5B,&H58,&H07,&H1F,&H9D,&HCF,&H9C,&HFA,&H1E,&H06,&H50
DATA &HB8,&H0E,&H10,&H8E,&HD8,&H8E,&HC0,&HA1,&H91,&H01,&H01,&H06,&H1C,&H00
DATA &H72,&H06,&HB0,&H20,&HE6,&H20,&HEB,&H09,&HFF,&H06,&H1C,&H00,&H9C,&HFF
DATA &H1E,&H12,&H00,&H53,&H51,&H52,&H57,&H56,&H55,&H8B,&HEC,&HFA,&H80,&H3E
DATA &H43,&H01,&H00,&H75,&H36,&H8C,&H16,&H20,&H00,&H89,&H26,&H1E,&H00,&H8C
DATA &HD8,&H8E,&HD0,&HBC,&H42,&H01,&HC6,&H06,&H43,&H01,&H01,&HFB,&HFC,&H83
DATA &H3E,&H85,&H01,&H00,&H74,&H0A,&H80,&H3E,&H15,&H03,&H00,&H75,&H03,&HE8
DATA &H8F,&H04,&HFA,&H8B,&H26,&H1E,&H00,&H8E,&H16,&H20,&H00,&HC6,&H06,&H43
DATA &H01,&H00,&HFB,&H5D,&H5E,&H5F,&H5A,&H59,&H5B,&H58,&H07,&H1F,&H9D,&HCF
DATA &H1E,&H06,&H50,&H53,&H51,&H52,&H57,&H56,&H55,&H9C,&HB8,&H0E,&H10,&H8E
DATA &HD8,&H8E,&HC0,&HE4,&H60,&H0A,&HC0,&H78,&H12,&H3C,&H53,&H75,&H0E,&HB4
DATA &H02,&HCD,&H16,&H24


SUB Center (y, Text$, ForeCol, BackCol)
' Centers the text at the given y with the given color
COLOR ForeCol, BackCol
LOCATE y, ((81 - LEN(Text$)) \ 2) + 1: PRINT Text$;

END SUB

FUNCTION DetectCard
' Finds if a sound card is available
WriteReg &H4, &H60: WriteReg &H4, &H80
B = INP(&H388)
WriteReg &H2, &HFF: WriteReg &H4, &H21
FOR i = 0 TO 130: A = INP(&H388): NEXT i
C = INP(&H388)
WriteReg &H4, &H60: WriteReg &H4, &H80
Success = FALSE
IF (B AND &HE0) = &H0 THEN
  IF (C AND &HE0) = &HC0 THEN
    Success = TRUE
  END IF
END IF
DetectCard = Success

END FUNCTION

SUB DrawWindow (x1, y1, x2, y2, Title$, ForeCol, BackCol, Style)
' Draws a window with x1,y1 and x2,y2 as the upper-left and bottom-right
' corners, and with the given title and color. Style changes the appearence
COLOR ForeCol, BackCol
IF Style = 0 THEN
  First$ = "Ú" + STRING$(x2 - x1 - 1, "Ä") + "¿"
  Body$ = "³" + SPACE$(x2 - x1 - 1) + "³"
  Last$ = "À" + STRING$(x2 - x1 - 1, "Ä") + "Ù"
ELSE
  First$ = "É" + STRING$(x2 - x1 - 1, "Í") + "»"
  Body$ = "º" + SPACE$(x2 - x1 - 1) + "º"
  Last$ = "È" + STRING$(x2 - x1 - 1, "Í") + "¼"
END IF
FOR i = y1 TO y2
  LOCATE i, x1
  SELECT CASE i
  CASE y1: PRINT First$;
  CASE y2: PRINT Last$;
  CASE ELSE: PRINT Body$;
  END SELECT
NEXT i
IF Title$ <> "" THEN LOCATE y1, (((x2 - x1) - LEN(Title$)) \ 2) + x1: PRINT " " + Title$ + " ";
COLOR 8, 0
FOR i = x1 + 2 TO x2 + 2
  LOCATE y2 + 1, i: PRINT CHR$(SCREEN(y2 + 1, i));
NEXT i
FOR i = x2 + 1 TO x2 + 2
  FOR ii = y1 + 1 TO y2
    LOCATE ii, i: PRINT CHR$(SCREEN(ii, i));
  NEXT ii
NEXT i

END SUB

FUNCTION EMSpages (func)
' Finds available EMS pages on the system
asm$ = ""
asm$ = asm$ + CHR$(85) + CHR$(137) + CHR$(229) + CHR$(180)
asm$ = asm$ + CHR$(66) + CHR$(205) + CHR$(103) + CHR$(139) + CHR$(126)
asm$ = asm$ + CHR$(6) + CHR$(137) + CHR$(29) + CHR$(139) + CHR$(126)
asm$ = asm$ + CHR$(8) + CHR$(137) + CHR$(21) + CHR$(93) + CHR$(203)
TotalPages = 0: AvailablePages = 0
DEF SEG = VARSEG(asm$)
CALL ABSOLUTE(TotalPages, AvailablePages, SADD(asm$))
DEF SEG
IF func = 0 THEN EMSpages = TotalPages ELSE EMSpages = AvailablePages

END FUNCTION

FUNCTION EMSstatus
' Finds the current EMS status
asm$ = ""
asm$ = asm$ + CHR$(85) + CHR$(137) + CHR$(229) + CHR$(180)
asm$ = asm$ + CHR$(64) + CHR$(205) + CHR$(103) + CHR$(176) + CHR$(0)
asm$ = asm$ + CHR$(139) + CHR$(94) + CHR$(6) + CHR$(137) + CHR$(7)
asm$ = asm$ + CHR$(93) + CHR$(203)
EMS = TRUE
DEF SEG = VARSEG(asm$)
CALL ABSOLUTE(EMS, SADD(asm$))
DEF SEG
IF EMS = FALSE THEN EMSstatus = TRUE ELSE EMSstatus = FALSE

END FUNCTION

SUB GetIntVector (IntNum%, segment%, offset%) STATIC
' Gets an interrupt vector
IF GetIntVCodeLoaded% = 0 THEN
    asm$ = asm$ + CHR$(&H55)
    asm$ = asm$ + CHR$(&H89) + CHR$(&HE5)
    asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA)
    asm$ = asm$ + CHR$(&H8A) + CHR$(&H7)
    asm$ = asm$ + CHR$(&HB4) + CHR$(&H35)
    asm$ = asm$ + CHR$(&HCD) + CHR$(&H21)
    asm$ = asm$ + CHR$(&H8C) + CHR$(&HC1)
    asm$ = asm$ + CHR$(&H89) + CHR$(&HDA)
    asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8)
    asm$ = asm$ + CHR$(&H89) + CHR$(&HF)
    asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6)
    asm$ = asm$ + CHR$(&H89) + CHR$(&H17)
    asm$ = asm$ + CHR$(&H5D)
    asm$ = asm$ + CHR$(&HCB)
    asm$ = asm$ + CHR$(&H34) + CHR$(&H0)
    asm$ = asm$ + CHR$(&H60)
    asm$ = asm$ + CHR$(&H23) + CHR$(&H0)
    GetIntVCodeLoaded% = 1
END IF
DEF SEG = VARSEG(asm$)
CALL ABSOLUTE(IntNum%, segment%, offset%, SADD(asm$))
END SUB

SUB Init
' Initializes program and finds if the EMS and SBMIDI drivers are available
OPEN "WETSPOT2.CFG" FOR BINARY AS #1
IF LOF(1) <> 0 THEN
  GET #1, , BasePort: GET #1, , Channel: GET #1, , Volume
  GET #1, , Soundon: GET #1, , MusicOn
  FOR i = 0 TO 1: GET #1, , Control(i): NEXT i
  FOR i = 0 TO 1: FOR ii = 0 TO 4: GET #1, , Keys(i, ii): NEXT ii, i
  GET #1, , Joy(0).res: GET #1, , Joy(1).res
ELSE
  BasePort = &H220: Channel = 1: Volume = 9: MusicOn = FALSE: Soundon = FALSE
  Control(0) = 0: Control(1) = 1
  Keys(0, 0) = 80     ' Keyboard default keys:
  Keys(0, 1) = 75     ' Keys(0,1) represents the scancode for LEFT direction
  Keys(0, 2) = 72     ' of player one;
  Keys(0, 3) = 77     ' infact the first value is the player (0/1), and the
  Keys(0, 4) = 28     ' second is the key function:
  Keys(1, 0) = 31     ' 0=DOWN, 1=LEFT, 2=UP, 3=RIGHT, 4=FIRE
  Keys(1, 1) = 30     ' These default values are:
  Keys(1, 2) = 17     ' Player 1:
  Keys(1, 3) = 32     ' Down arrow/Left arrow/Up arrow/Right arrow/Enter
  Keys(1, 4) = 15     ' Player 2:
                      ' S/A/W/D/Tab
  Joy(0).res = 30
  Joy(1).res = 30
END IF
CLOSE #1
SCREEN 0, 0, 0
COLOR 7, 0, 0: CLS : LOCATE 1, 1
COLOR 8, 7
FOR i = 0 TO 25: PRINT STRING$(80, 177); : NEXT i
LOCATE 25, 1: COLOR 15, 3: PRINT SPACE$(80);
Center 25, "Analyzing system...", 0, 3
DrawWindow 4, 1, 77, 4, "", 15, 3, 1
Center 2, "WetSpot 2 Configuration Setup Program", 15, 3
Center 3, "version 1.0 by Enhanced Creations 1997-98", 15, 3
DrawWindow 5, 7, 76, 13, "System informations ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Current settings", 15, 1, 0
COLOR 15, 1
LOCATE 8, 8: PRINT "Free base memory:" + STR$(FRE(-1)) + " bytes"
GetIntVector &H67, EMMsegment%, EMMoffset%
DEF SEG = EMMsegment%
Emm$ = CHR$(PEEK(&HA)) + CHR$(PEEK(&HB)) + CHR$(PEEK(&HC))
IF Emm$ <> "EMM" THEN EMSavailable = FALSE ELSE EMSavailable = TRUE
EMSneeded = (8 + ((NUMSOUNDS + 1) * 4))
IF EMSavailable = TRUE THEN
  EMSavailable = EMSstatus
  IF EMSavailable = TRUE THEN
    LOCATE 9, 8: PRINT "Free EMS memory:" + STR$(EMSpages(1) * 16000&) + " bytes "
    LOCATE 10, 8: PRINT "EMS page frame located at " + HEX$(pageframe) + "h"
  ELSE
    LOCATE 9, 8: PRINT "Cannot access EMS memory"
    LOCATE 10, 8: PRINT "Cannot locate EMS pageframe"
  END IF
ELSE
  LOCATE 9, 8: PRINT "EMS memory not installed"
  LOCATE 10, 8: PRINT "Cannot locate EMS pageframe"
END IF
LOCATE 11, 8
FOR i = 0 TO 1
  Mask(i, 3) = 1 - ((i <> 0) * 3)
  Mask(i, 4) = Mask(i, 3) * 2
  Mask(i, 0) = Mask(i, 3) * 16
  Mask(i, 1) = Mask(i, 4) * 16
  Mask(i, 2) = Mask(i, 3) + Mask(i, 4)
  ReadJoy i
  Joy(i).xc = Joy(i).x
  Joy(i).yc = Joy(i).y
  Joy(i).detected = FALSE: IF Joy(i).xc <> 255 THEN Joy(i).detected = TRUE
NEXT i
IF Joy(0).detected OR Joy(1).detected THEN
  IF Joy(0).detected AND Joy(1).detected THEN
    PRINT "Joystick 1 and 2 detected"
  ELSE
    IF Joy(0).detected THEN PRINT "Joystick 1 detected" ELSE PRINT "Joystick 2 detected"
  END IF
ELSE
  PRINT "Joystick not detected"
END IF
LOCATE 12, 8
CardOK = DetectCard
IF CardOK THEN
  PRINT "A sound card is available"
  LOCATE 8, 44: PRINT "Sound card base address: " + HEX$(BasePort) + "h"
  LOCATE 9, 44: PRINT "DMA channel:" + STR$(Channel)
  IF MusicOn = FALSE AND Soundon = TRUE THEN fxSwitch = 0
  IF MusicOn = TRUE AND Soundon = FALSE THEN fxSwitch = 1
  IF MusicOn = FALSE AND Soundon = FALSE THEN fxSwitch = 2
  IF MusicOn = TRUE AND Soundon = TRUE THEN fxSwitch = 3
  LOCATE 10, 44
  SELECT CASE fxSwitch
  CASE 0: PRINT "Musics are off           "
  CASE 1: PRINT "Sounds are off           "
  CASE 2: PRINT "Sounds and musics are off"
  CASE 3: PRINT "Sounds and musics are on "
  END SELECT
ELSE
  PRINT "Sound card not available"
  COLOR 7, 1
  LOCATE 8, 44: PRINT "Sound card base address: none"
  LOCATE 9, 44: PRINT "DMA channel: none"
  COLOR 15, 1
  LOCATE 10, 44: PRINT "Sounds and musics are off"
  BasePort = &H220: Channel = 1: Volume = 9: fxSwitch = 2
END IF
FOR i = 0 TO 1
  IF Joy(i).detected THEN COLOR 15, 1 ELSE COLOR 7, 1
  LOCATE 11 + i, 44: PRINT "Joystick" + STR$(i + 1) + " resolution:" + STR$(Joy(i).res)
NEXT i
DrawWindow 25, 16, 56, 23, "Select an option", 15, 1, 0
RESTORE MainMenu
FOR i = 0 TO 3: READ MenuText$(i), MenuMessage$(i)
MenuAvailable(i) = TRUE
Sel = 0: IF CardOK = FALSE THEN MenuAvailable(0) = FALSE: Sel = 1
NEXT i
UpdateMenu
LOCATE 25, 1: COLOR 0, 3: PRINT SPACE$(80);
Center 25, "Analyzing system...", 0, 3
EMSerr = TRUE
IF EMSavailable THEN
  IF EMSpages(1) >= EMSneeded THEN EMSerr = FALSE
END IF

IF EMSerr THEN
  PCOPY 0, 1
  DrawWindow 11, 8, 70, 17, "WARNING!", 15, 4, 1
  COLOR 14, 4
  LOCATE 10, 14: PRINT "There was an error checking for EMS memory. WetSpot 2"
  LOCATE 11, 14: PRINT "requires" + STR$(EMSneeded * 16) + " KBytes of free EMS memory in order to"
  LOCATE 12, 14: PRINT "run. Please refer to the " + CHR$(34) + "System requirements" + CHR$(34) + " and to"
  LOCATE 13, 14: PRINT "the " + CHR$(34) + "Installing the game" + CHR$(34) + " sections of the README.TXT"
  LOCATE 14, 14: PRINT "file provided with the game."
  Center 16, "<Press any key to continue>", 14, 4
  WHILE INKEY$ = "": WEND
  PCOPY 1, 0
END IF

IF CardOK THEN
  SBMIDIint = SBMIDIloaded
  IF SBMIDIint = 0 THEN
    PCOPY 0, 1
    DrawWindow 11, 8, 70, 17, "WARNING!", 15, 4, 1
    COLOR 14, 4
    LOCATE 10, 14: PRINT "Unable to detect the SBMIDI driver. In order to hear"
    LOCATE 11, 14: PRINT "the musics, you'll need to load this driver into"
    LOCATE 12, 14: PRINT "interrupt 80h; otherwise you must disable them in the"
    LOCATE 13, 14: PRINT "SOUND menu. Please refer to the README.TXT file, at"
    LOCATE 14, 14: PRINT "section " + CHR$(34) + "1.3 - Installing the game" + CHR$(34) + " for details."
    Center 16, "<Press any key to continue>", 14, 4
    WHILE INKEY$ = "": WEND
    PCOPY 1, 0
  ELSEIF SBMIDIint <> &H80 THEN
    PCOPY 0, 1
    DrawWindow 11, 8, 70, 16, "WARNING!", 15, 4, 1
    COLOR 14, 4
    LOCATE 10, 14: PRINT "The SBMIDI driver was found on interrupt " + HEX$(SBMIDIint) + "h, while it"
    LOCATE 11, 14: PRINT "must be resident on interrupt 80h. Please refer to the"
    LOCATE 12, 14: PRINT "README.TXT file at section " + CHR$(34) + "1.3 - Installing the game" + CHR$(34)
    LOCATE 13, 14: PRINT "for details."
    Center 15, "<Press any key to continue>", 14, 4
    WHILE INKEY$ = "": WEND
    PCOPY 1, 0
  END IF
END IF
UpdateMenu

END SUB

FUNCTION pageframe
' Finds the EMS pageframe
asm$ = ""
asm$ = asm$ + CHR$(85) + CHR$(137) + CHR$(229) + CHR$(180)
asm$ = asm$ + CHR$(65) + CHR$(205) + CHR$(103) + CHR$(139) + CHR$(126)
asm$ = asm$ + CHR$(6) + CHR$(137) + CHR$(29) + CHR$(93) + CHR$(203)
PageFrameAddr = 0
DEF SEG = VARSEG(asm$)
CALL ABSOLUTE(PageFrameAddr, SADD(asm$))
DEF SEG
pageframe = PageFrameAddr

END FUNCTION

SUB ReadJoy (J)
' Reads joystick status and stores it into a Joystick type variable
OUT &H201, &HFF
C = INP(&H201)
b1 = NOT ((C AND Mask(J, 0)) <> 0)
b2 = NOT ((C AND Mask(J, 1)) <> 0)
Joy(J).but = b1 OR b2: k = 0
DO
  IF (C AND Mask(J, 3)) <> 0 THEN Joy(J).x = k
  IF (C AND Mask(J, 4)) <> 0 THEN Joy(J).y = k
  C = INP(&H201): k = k + 1
LOOP WHILE (C AND Mask(J, 2)) <> 0 AND k < 256
Joy(J).x = Joy(J).x - Joy(J).xc
Joy(J).y = Joy(J).y - Joy(J).yc

END SUB

FUNCTION SBMIDIloaded
' Finds if the SBMIDI driver has been loaded
result = 0
FOR i = &H80 TO &H8A
GetIntVector i, segment%, offset%
  IF segment% <> 0 AND offset% <> 0 THEN
    DEF SEG = segment%
    RESTORE SBMIDIData:
    FOR ii = 0 TO 255
      READ byte
      IF byte = PEEK(offset% + ii) THEN
        SBMIDIok = TRUE
      ELSE
        SELECT CASE ii
        CASE IS = 14, 15, 113, 114, 235, 236
        CASE ELSE
          SBMIDIok = FALSE: EXIT FOR
        END SELECT
      END IF
    NEXT ii
  END IF
  IF SBMIDIok = TRUE THEN result = i: EXIT FOR
NEXT i
SBMIDIloaded = result
END FUNCTION

SUB SelDown (MaxSel)
' Moves the selection box down
IF Sel = MaxSel THEN
  Sel = 0
ELSE
  Sel = Sel + 1
END IF
IF NOT MenuAvailable(Sel) THEN SelDown (MaxSel)

END SUB

FUNCTION SelectMenu (MaxSel)
' Returns the selected option from the current menu
UpdateMenu
DO
  k$ = INKEY$
  IF k$ = CHR$(0) + "H" THEN
    SelUp (MaxSel)
    UpdateMenu
  END IF
  IF k$ = CHR$(0) + "P" THEN
    SelDown (MaxSel)
    UpdateMenu
  END IF
  IF k$ = CHR$(13) THEN EXIT DO
LOOP
SelectMenu = Sel

END FUNCTION

SUB SelUp (MaxSel)
' Moves the selection box up
IF Sel = 0 THEN
  Sel = MaxSel
ELSE
  Sel = Sel - 1
END IF
IF NOT MenuAvailable(Sel) THEN SelUp (MaxSel)

END SUB

SUB UpdateMenu
' Prints the current menu on the screen
FOR i = 0 TO 3
  IF MenuAvailable(i) = FALSE THEN col = 7 ELSE col = 15
  Center (18 + i), MenuText$(i), col, 1
NEXT i
Center (18 + Sel), MenuText$(Sel), 0, 7
LOCATE 25, 1: COLOR 0, 3: PRINT SPACE$(80);
Center 25, MenuMessage$(Sel), 0, 3

END SUB

SUB WriteReg (Reg, Value)
' Writes data to the sound card address
OUT &H388, Reg
FOR i = 0 TO 5: dummy = INP(&H388): NEXT i
OUT &H389, Value
FOR i = 0 TO 34: dummy = INP(&H388): NEXT i

END SUB

