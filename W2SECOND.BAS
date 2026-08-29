' W2SECOND.BAS
' by Enhanced Creations 1997-98
' Secondary module for WETSPOT II
'
' - Load WETSPOT2.BAS to run! -
'
' This module contains extra SUBs, FUNCTIONs and other game data
' shared with WETSPOT2.BAS.

'$INCLUDE: 'WETSPOT2.BI'

' ASM routines length
DATA 19,16,17,32,14,14,12,30,35,44,238,63,102,51,27,6,33

' dX,dY: axis increase/decrease in each direction
' direction can be: 0 = right, 1 = up, 2 = left, 3 = down, 4 = nowhere
DATA 0,1,-1,0,0,-1,1,0,0,0

' Keyboard handler asm routine data
KeyboardRoutineData:
DATA &HE9,&H1D,&H00,&HE9,&H3C,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
DATA &H00,&H00,&H00,&H00,&H1E,&H31,&HC0,&H8E,&HD8,&HBE,&H24,&H00,&H0E,&H07
DATA &HBF,&H14,&H00,&HFC,&HA5,&HA5,&H8C,&HC3,&H8E,&HC0,&HBF,&H24,&H00,&HB8
DATA &H56,&H00,&HFA,&HAB,&H89,&HD8,&HAB,&HFB,&H1F,&HCB,&H1E,&H31,&HC0,&H8E
DATA &HC0,&HBF,&H24,&H00,&HBE,&H14,&H00,&H0E,&H1F,&HFC,&HFA,&HA5,&HA5,&HFB
DATA &H1F,&HCB,&HFB,&H9C,&H50,&H53,&H51,&H52,&H1E,&H56,&H06,&H57,&HE4,&H60
DATA &HB4,&H01,&HA8,&H80,&H74,&H04,&HB4,&H00,&H24,&H7F,&HD0,&HE0,&H88,&HC3
DATA &HB7,&H00,&HB0,&H00,&H2E,&H03,&H1E,&H12,&H00,&H2E,&H8E,&H1E,&H10,&H00
DATA &H86,&HE0,&H89,&H07,&HE4,&H61,&H0C,&H82,&HE6,&H61,&H24,&H7F,&HE6,&H61
DATA &HB0,&H20,&HE6,&H20,&H5F,&H07,&H5E,&H1F,&H5A,&H59,&H5B,&H58,&H9D,&HCF

' SBMIDI driver data for identification
SBMIDIdata:
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

'DMA Channel specifications
DMAdata:
DATA &H87,&H00,&H01,&H48,&H83,&H02,&H03,&H49,&H81,&H04,&H05,&H4A,&H82,&H06
DATA &H07,&H4B

' Sounds length
SoundLength:
DATA 1470,1714,6386,9456,9488,7824,3674,12338,3256,28864,26816,18048,3690
DATA 15822,4694,1754,10020,5782,9584

' Keyboard scancodes for direct keyboard input
ScanCodes:
DATA &H1E,&H30,&H2E,&H20,&H12,&H21,&H22,&H23,&H17,&H24,&H25,&H26,&H32,&H31
DATA &H18,&H19,&H10,&H13,&H1F,&H14,&H16,&H2F,&H11,&H2D,&H15,&H2C,&H0B,&H02
DATA &H03,&H04,&H05,&H06,&H07,&H08,&H09,&H0A,&H28,&H02,&H28,&H05,&H06,&H08
DATA &H35,&H0A,&H0B,&H4A,&H4E,&H04,&H03,&HFF,&H0E,&HFF,&H39

SUB Center (Text$, y, fcol, bcol)
' Outs Text$ at the center of the screen.
COLOR fcol, bcol: LOCATE y, (81 - LEN(Text$)) \ 2
PRINT Text$;

END SUB

SUB ChangePal (PalNum)
' Changes enemy palette to specified one
IF PalNum = -1 THEN
  FOR s = 0 TO 79
    PalSet (64 + s), ASC(MID$(pal, 192 + (s * 3) + 1, 1)), ASC(MID$(pal, 192 + (s * 3) + 2, 1)), ASC(MID$(pal, 192 + (s * 3) + 3, 1))
  NEXT s
ELSE
  FOR s = 0 TO 79
    PalSet (64 + s), ASC(MID$(EnemyPal(PalNum), (s * 3) + 1, 1)), ASC(MID$(EnemyPal(PalNum), (s * 3) + 2, 1)), ASC(MID$(EnemyPal(PalNum), (s * 3) + 3, 1))
  NEXT s
END IF

END SUB

SUB CheckStatus
' Checks game status and other minor game features
' Finds if all the players are dead; in that case, ends the game loop
IF Game.players = 0 THEN
  IF Player(0).dead = TRUE THEN Game.status = 400: Player(0).dead = 2
ELSE
  IF Player(0).dead = TRUE THEN
    Player(0).dead = 2
    IF Player(0).dead >= 2 AND Player(1).dead >= 2 THEN Game.status = 400
  END IF
  IF Player(1).dead = TRUE THEN
    Player(1).dead = 2
    IF Player(0).dead >= 2 AND Player(1).dead >= 2 THEN Game.status = 400
  END IF
END IF
' Randomly adds a bonus object on the screen (if possible)
IF Game.objects < 3 AND Game.status <> -501 THEN
  IF Game.status < 1 AND Game.time > 15 THEN
    IF INT(RND(1) * 100) = 0 THEN
      FOR i = 0 TO MAXOBJS
        IF Object(i).typ = 0 THEN EXIT FOR
      NEXT i
      Object(i).x = INT(RND(1) * 20)
      Object(i).y = INT(RND(1) * 12)
      GetBlockInfo Cel(Object(i).x, Object(i).y)
      IF st = 0 THEN
        Object(i).typ = 26 + INT(RND(1) * 8)
        Object(i).time = 0
        IF INT(RND(1) * 3) = 0 THEN
          xi = INT(RND(1) * 20): yi = INT(RND(1) * 12)
          GetBlockInfo Cel(xi, yi)
          IF rd > 0 THEN Object(i).typ = rd
          IF Game.mode = DEMO AND Object(i).typ = 14 THEN Object(i).typ = 0
        END IF
        IF INT(RND(1) * 3) = 0 THEN Object(i).typ = INT(RND(1) * 33) + 1
        Game.objects = Game.objects + 1
      END IF
    END IF
  END IF
END IF
SELECT CASE Game.status
CASE -500 TO -3
  ' The enemies are blocked by the clock
  Game.status = Game.status + 1
  IF Game.status = -2 THEN
    ' Resumes the enemies
    Game.status = 0
    IF Game.time < 16 THEN
      ChangePal 0
    ELSE
      ChangePal -1
    END IF
  END IF
CASE -2
  ' Do the lightnings
  FOR i = 0 TO 80
    DrawScreen
  NEXT i
  Game.status = 0
  FOR i = 0 TO MAXENEMIES
    IF Enemy(i).typ > 0 THEN KillEnemy i
  NEXT i
  ChangePal -1
CASE -1
  ' Do the earthquake
  Game.status = 0
  FOR i = 0 TO 100
    WAIT &H3DA, 8, 8: WAIT &H3DA, 8
    BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, ((i MOD 3) * 320)
  NEXT i
  FOR i = 0 TO MAXENEMIES
    IF Enemy(i).typ > 0 THEN KillEnemy i
  NEXT i
CASE IS > 0
  Game.status = Game.status + 1
END SELECT
' F12 saves a screenshot to SHOTxxxx.BMP where xxxx is the number of the
' saved screenshot since the beginning of the program.
IF kbmatrix(88) THEN
  TIMER OFF
  n$ = LTRIM$(STR$(ScreenShot)): IF LEN(n$) < 4 THEN n$ = STRING$((4 - LEN(n$)), "0") + n$
  IF ScreenShot < 9999 THEN ScreenShot = ScreenShot + 1
  n$ = "SHOT" + n$ + ".BMP"
  DIM regs AS RegTypeX, bmpheader AS bmpinfo
  FOR h = 0 TO 255
    PalGet h, r, g, b
    MID$(bmpheader.pal, (h * 4) + 1, 4) = CHR$(b * 4) + CHR$(g * 4) + CHR$(r * 4) + CHR$(0)
  NEXT h
  bmpheader.bm = "BM": bmpheader.size = 65078: bmpheader.r1 = 0
  bmpheader.r2 = 0: bmpheader.offsdata = 1078: bmpheader.hsize = 40
  bmpheader.wid = 320: bmpheader.hei = 200: bmpheader.planes = 1
  bmpheader.bpp = 8: bmpheader.comp = 0: bmpheader.isize = 64000
  bmpheader.xpm = 3790: bmpheader.ypm = 3780: bmpheader.colus = 0
  bmpheader.impcol = 0
  OPEN n$ FOR BINARY AS #10
  IF LOF(10) > 0 THEN
    CLOSE #10: KILL n$: OPEN n$ FOR BINARY AS #10
  END IF
  PUT #10, , bmpheader
  CLOSE #10: n$ = n$ + CHR$(0)
  regs.ax = &H3D01
  regs.ds = VARSEG(n$)
  regs.dx = SADD(n$)
  CALL InterruptX(&H21, regs, regs)
  regs.bx = regs.ax
  regs.ax = &H4200
  regs.cx = 0
  regs.dx = &H436
  CALL InterruptX(&H21, regs, regs)
  FOR d = 199 TO 0 STEP -1
    regs.ax = &H4000
    regs.cx = 320
    regs.ds = &HA000
    regs.dx = VAL("&H" + HEX$(d * 320&))
    CALL InterruptX(&H21, regs, regs)
  NEXT d
  regs.ax = &H3E00
  CALL InterruptX(&H21, regs, regs)
  DO: LOOP WHILE kbmatrix(88) = TRUE
  IF Game.monsters > 0 THEN TIMER ON
END IF
IF Game.mode = HIDDEN OR Game.mode = DEMO THEN EXIT SUB
IF kbmatrix(25) THEN
  ' the P key is pressed; the game is paused
  TIMER OFF
  PlaySound 1
  SPrint "PAUSE!", 136, 96, Game.textcol
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  DO: LOOP WHILE kbmatrix(25)
  DO
    IF kbmatrix(25) THEN EXIT DO
  LOOP
  DO: LOOP WHILE kbmatrix(25)
  PlaySound 2
  IF Game.monsters > 0 THEN TIMER ON
END IF
IF kbmatrix(29) AND kbmatrix(56) THEN
  ' CTRL-ALT-F5
  IF kbmatrix(63) THEN
    Player(0).lives = Player(0).lives + 1
    PalSet 0, 63, 63, 63
    DO: LOOP WHILE kbmatrix(63)
    PalSet 0, 0, 0, 0
  END IF
  ' CTRL-ALT-F6
  IF kbmatrix(64) THEN
    IF Game.players = 1 THEN
      Player(1).lives = Player(1).lives + 1
      PalSet 0, 63, 63, 63
      DO: LOOP WHILE kbmatrix(64)
      PalSet 0, 0, 0, 0
    END IF
  END IF
  ' CTRL-ALT-F7
  IF kbmatrix(65) THEN
    IF Blocked = FALSE THEN
      Blocked = TRUE
    ELSE
      Blocked = FALSE
    END IF
    PalSet 0, 63, 63, 63
    DO: LOOP WHILE kbmatrix(65)
    PalSet 0, 0, 0, 0
  END IF
  ' CTRL-ALT-F8
  IF kbmatrix(66) THEN
    PalSet 0, 63, 63, 63
    DO: LOOP WHILE kbmatrix(66)
    PalSet 0, 0, 0, 0
    FOR i = 0 TO MAXENEMIES
      IF Enemy(i).typ > 0 THEN KillEnemy i
    NEXT i
  END IF
  ' CTRL-ALT-F9
  IF kbmatrix(67) THEN
    PalSet 0, 63, 63, 63
    DO: LOOP WHILE kbmatrix(67)
    PalSet 0, 0, 0, 0
    Game.level = 5
    FOR i = 0 TO MAXENEMIES
      IF Enemy(i).typ > 0 THEN KillEnemy i
    NEXT i
  END IF
  ' CTRL-ALT-F10
  IF kbmatrix(68) THEN
    PalSet 0, 63, 63, 63
    DO: LOOP WHILE kbmatrix(67)
    PalSet 0, 0, 0, 0
    Game.level = 5: Game.area = Game.numareas
    FOR i = 0 TO MAXENEMIES
      IF Enemy(i).typ > 0 THEN KillEnemy i
    NEXT i
  END IF
END IF

END SUB

FUNCTION Collide (xPos, yPos)
' Returns -1 if the object at xPos,yPos doesn't collide with a player,
' otherwise returns player's number (0 or 1)
result = -1
FOR c = 0 TO Game.players
  IF Player(c).dead = FALSE THEN
    IF Player(c).status > -1 AND Player(c).status < 201 THEN
      IF xPos > Player(c).x - 12 AND xPos < Player(c).x + 12 THEN
        IF yPos > Player(c).y - 12 AND yPos < Player(c).y + 12 THEN
          result = c
        END IF
      END IF
    END IF
  END IF
NEXT c
Collide = result

END FUNCTION

SUB EndingText
' Displays final words before ending program
SCREEN 0: WIDTH 80
COLOR 15, 1: PRINT SPACE$(160)
Center ("WetSpot 2 - version " + VERSION$), 1, 15, 1
Center "by Enhanced Creations 1997-98", 2, 15, 1
Center "°±²                           ²±°", 4, 7, 0
Center " written by Angelo Mottola ", 4, 0, 7
Center "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿", 6, 10, 2
Center "³    THIS PROGRAM IS FREEWARE; this means you are encouraged to give    ³", 7, 10, 2
Center "³  it to your friends. No money goes to the author, who is anyway not   ³", 8, 10, 2
Center "³     liable for any damages caused by a bad use of this software.      ³", 9, 10, 2
Center "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ", 10, 10, 2
Center "For game instructions, hints and known bugs, see README.TXT.", 12, 15, 0
Center "WetSpot 2 has been written thinking about future expansions: new worlds", 13, 7, 0
Center "can be loaded instead of the standard one, and you are encouraged to create", 14, 7, 0
Center "them with my world editor. Once created, you can send me your work, and", 15, 7, 0
Center "I'll be glad to put it up on my page. My E-Mail addresses are:", 16, 7, 0
Center "angelillo@geocities.com", 17, 14, 0
Center "angelillo@usa.net", 18, 14, 0
Center "And my home page (The QuickBasic Enhanced Programming Page) is located at:", 19, 7, 0
Center "http://www.geocities.com/SiliconValley/Lakes/7303", 20, 14, 0
Center "Messages about hints, comments or bug reports are welcomed too.", 21, 7, 0
Center "Thanks for playing WetSpot 2, and remember: QB lives!!", 23, 7, 0
LOCATE 24, 1
END SUB

SUB Fade (Where)
' Fades in (Where=1) or out (Where=0) the current palette
DIM PalRe(255), PalGr(255), PalBl(255), AlreadyHandled(255)
IF Where = 1 THEN
  FOR i = 0 TO 255
    PalRe(i) = ASC(MID$(pal, (i * 3) + 1, 1))
    PalGr(i) = ASC(MID$(pal, (i * 3) + 2, 1))
    PalBl(i) = ASC(MID$(pal, (i * 3) + 3, 1))
  NEXT i
  complete = 0: Count = 0
  FOR i = 0 TO 255: AlreadyHandled(i) = FALSE: NEXT i
  DO
    Done = TRUE
    IF AlreadyHandled(Count) <> FALSE THEN
      DO
        Count = (Count + 1) MOD 256
      LOOP UNTIL AlreadyHandled(Count) = FALSE
    END IF
    PalGet Count, r, g, b
    IF r < PalRe(Count) THEN r = r + 1: Done = FALSE
    IF g < PalGr(Count) THEN g = g + 1: Done = FALSE
    IF b < PalBl(Count) THEN b = b + 1: Done = FALSE
    PalSet Count, r, g, b
    IF Done THEN complete = complete + 1: AlreadyHandled(Count) = TRUE
    Count = Count + 1: IF Count > 255 THEN Count = 0
  LOOP UNTIL complete = 255
ELSE
  complete = 0: Count = 0
  FOR i = 0 TO 255: AlreadyHandled(i) = FALSE: NEXT i
  DO
    Done = TRUE
    IF AlreadyHandled(Count) = TRUE THEN
      DO
        Count = (Count + 1) MOD 256
      LOOP UNTIL AlreadyHandled(Count) = FALSE
    END IF
    PalGet Count, r, g, b
    IF r > 0 THEN r = r - 1: Done = FALSE
    IF g > 0 THEN g = g - 1: Done = FALSE
    IF b > 0 THEN b = b - 1: Done = FALSE
    PalSet Count, r, g, b
    IF Done THEN complete = complete + 1: AlreadyHandled(Count) = TRUE
    Count = Count + 1: IF Count > 255 THEN Count = 0
  LOOP UNTIL complete = 255
END IF

END SUB

FUNCTION FindTarget (xPos, yPos)
' Finds which player is nearest to the given enemy position
IF Game.players = 0 THEN FindTarget = 0: EXIT FUNCTION
dist1 = ((((Player(0).x \ 16) - xPos) ^ 2) + ((Player(0).y \ 16) - yPos) ^ 2)
dist2 = ((((Player(1).x \ 16) - xPos) ^ 2) + ((Player(1).y \ 16) - yPos) ^ 2)
IF dist1 < dist2 THEN result = 0 ELSE result = 1
IF Player(result).dead = TRUE OR Player(result).dead >= 2 THEN result = result XOR 1
FindTarget = result

END FUNCTION

SUB GetBlockInfo (CelCode)
' Gets informations from a specified Cel value and extracts:
' st=Block                            (0:none,1:fixed,2:moveable)
' nd=Background                       (1,2,3)
' rd=Object (if a block is present)   (object code number)
st = (CelCode \ 1000)
nd = ((CelCode - (st * 1000)) \ 100)
rd = CelCode MOD ((st * 1000) + (nd * 100))

END SUB

FUNCTION GetText$ (TitleText$, TextLen)
' Gets a line of text from the user. Used to get a password or to insert
' the player name in the high score table.
'
' Initializes the screen
MapEMS EMShdl, 4
DEF SEG = VARSEG(Buffer(0)): BLOAD "TITLE.BIN", VARPTR(Buffer(0))
MPrint TitleText$, 110, 255, 252
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), (((314 - (TextLen * 8)) \ 2) - 4), 158, (((314 - (TextLen * 8)) \ 2) + (TextLen * 8) + 9), 158, 83
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), (((314 - (TextLen * 8)) \ 2) - 4), 169, (((314 - (TextLen * 8)) \ 2) + (TextLen * 8) + 9), 169, 83
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), (((314 - (TextLen * 8)) \ 2) - 4), 158, (((314 - (TextLen * 8)) \ 2) - 4), 169, 83
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), (((314 - (TextLen * 8)) \ 2) + (TextLen * 8) + 9), 158, (((314 - (TextLen * 8)) \ 2) + (TextLen * 8) + 9), 169, 83
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
' 53 available characters
Letter$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'!" + CHR$(34) + "$%&/()-+#@etu "
Letter$ = Letter$ + LEFT$(Letter$, 37)
CurLetter = 54: Text$ = "": MoveSel = 0
BlastCopy &HA000, 0, EMSseg, 0
Fade 1
GOSUB DrawText
DO: LOOP WHILE kbmatrix(28)
' Begins loop
DO
  IF MoveSel = 0 THEN
    ' Handles keyboard input
    IF kbmatrix(77) THEN MoveSel = 8: PlaySound 0
    IF kbmatrix(75) THEN MoveSel = -8: PlaySound 0
    IF kbmatrix(28) THEN
      ' The user selected a character
      Char$ = MID$(Letter$, CurLetter, 1)
      ' "ED" (End) confirms and exits the function
      IF Char$ = "u" THEN EXIT DO
      ' "BK" (Back) acts like a backspace
      IF Char$ = "t" THEN
        IF LEN(Text$) > 0 THEN
          Text$ = LEFT$(Text$, LEN(Text$) - 1): PlaySound 1
        ELSE
          PlaySound 14
        END IF
      ELSE
        IF LEN(Text$) < TextLen THEN
          ' Add the selected character to the text
          Text$ = Text$ + Char$: PlaySound 1
        ELSE
          ' The text length exceed its limit; sets the selection box on ED
          CurLetter = 52: PlaySound 14
        END IF
      END IF
      ' Draws the screen
      GOSUB DrawText
      DO: LOOP WHILE kbmatrix(28)
    END IF
    IF MoveSel = 0 THEN
      RESTORE ScanCodes
      FOR s = 1 TO 53
        READ sCode
        IF sCode <> &HFF THEN IF kbmatrix(sCode) THEN EXIT FOR
        sCode = &HFF
      NEXT s
      IF sCode <> &HFF THEN
        DO: LOOP WHILE kbmatrix(sCode)
        CurLetter = s
        IF CurLetter < 18 THEN CurLetter = CurLetter + 53
        IF sCode = &HE THEN
          IF LEN(Text$) > 0 THEN
            Text$ = LEFT$(Text$, LEN(Text$) - 1): PlaySound 1
          ELSE
            PlaySound 14
          END IF
        ELSE
          IF LEN(Text$) < TextLen THEN
            Text$ = Text$ + MID$(Letter$, CurLetter, 1): PlaySound 1
          ELSE
            CurLetter = 52: PlaySound 14
          END IF
        END IF
        GOSUB DrawText
      END IF
    END IF
  ELSE
    GOSUB DrawText
  END IF
LOOP
IF LEN(Text$) < TextLen THEN Text$ = Text$ + SPACE$(TextLen - LEN(Text$))
GetText$ = Text$
EXIT FUNCTION

DrawText:
t! = TIMER
BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
' The selection box is moving right
IF MoveSel > 0 THEN
  MoveSel = MoveSel - 4
  IF MoveSel = 0 THEN
    CurLetter = CurLetter + 1
    IF CurLetter > 70 THEN CurLetter = CurLetter - 53
  END IF
END IF
' The selection box is moving left
IF MoveSel < 0 THEN
  MoveSel = MoveSel + 4
  IF MoveSel = 0 THEN
    CurLetter = CurLetter - 1
    IF CurLetter < 18 THEN CurLetter = CurLetter + 53
  END IF
END IF
' Draws the characters on the screen
yPos = 135: xx = 20 - ((8 - ABS(MoveSel)) * SGN(MoveSel))
Visible$ = MID$(Letter$, CurLetter - 17, 36)
FOR L = 1 TO LEN(Visible$)
  Code = ASC(MID$(Visible$, L, 1)) - 32
  xx = xx + 8
  DEF SEG = VARSEG(FontData)
  FOR ll = 0 TO 7
    byte = PEEK(VARPTR(FontData) + (Code * 8) + ll)
    IF xx - 1 > 30 AND xx - 1 < 289 THEN
      IF byte AND 1 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 1), (yPos + ll), 255
    END IF
    IF xx - 2 > 30 AND xx - 2 < 289 THEN
      IF byte AND 2 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 2), (yPos + ll), 255
    END IF
    IF xx - 3 > 30 AND xx - 3 < 289 THEN
      IF byte AND 4 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 3), (yPos + ll), 255
    END IF
    IF xx - 4 > 30 AND xx - 4 < 289 THEN
      IF byte AND 8 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 4), (yPos + ll), 255
    END IF
    IF xx - 5 > 30 AND xx - 5 < 289 THEN
      IF byte AND 16 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 5), (yPos + ll), 255
    END IF
    IF xx - 6 > 30 AND xx - 6 < 289 THEN
      IF byte AND 32 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 6), (yPos + ll), 255
    END IF
    IF xx - 7 > 30 AND xx - 7 < 289 THEN
      IF byte AND 64 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 7), (yPos + ll), 255
    END IF
    IF xx - 8 > 30 AND xx - 8 < 289 THEN
      IF byte AND 128 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 8), (yPos + ll), 255
    END IF
  NEXT ll
NEXT L
' Draws the selection box
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 154, (yPos - 2), 154, (yPos + 8), 83
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 164, (yPos - 2), 164, (yPos + 8), 83
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 154, (yPos - 2), 164, (yPos - 2), 83
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 154, (yPos + 8), 164, (yPos + 8), 83
' Prints actual text
MPrint (Text$ + MID$(Letter$, CurLetter, 1)), 160, 255, 252
DO: LOOP WHILE TIMER < t! + .02
WAIT &H3DA, 8, 8: WAIT &H3DA, 8
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
RETURN

END FUNCTION

FUNCTION InFrontOf (EnemyNum, PlayerNum)
' Returns true if the specified enemy is in front of a player and the player
' is free.
result = FALSE
IF Player(PlayerNum).dead <> FALSE THEN EXIT FUNCTION
IF Enemy(EnemyNum).y = Player(PlayerNum).y THEN
  IF Enemy(EnemyNum).x > Player(PlayerNum).x THEN
    IF Enemy(EnemyNum).dir = 1 THEN result = TRUE
  END IF
  IF Enemy(EnemyNum).x < Player(PlayerNum).x THEN
    IF Enemy(EnemyNum).dir = 3 THEN result = TRUE
  END IF
END IF
IF Enemy(EnemyNum).x = Player(PlayerNum).x THEN
  IF Enemy(EnemyNum).y > Player(PlayerNum).y THEN
    IF Enemy(EnemyNum).dir = 2 THEN result = TRUE
  END IF
  IF Enemy(EnemyNum).y < Player(PlayerNum).y THEN
    IF Enemy(EnemyNum).dir = 0 THEN result = TRUE
  END IF
END IF
IF Player(PlayerNum).status <> 0 THEN result = FALSE
InFrontOf = result

END FUNCTION

FUNCTION InitGame
' Initializes the game
DIM byte AS STRING * 1, sbuf AS STRING * 2048
DIM info AS INTEGER, cx AS INTEGER, cy AS INTEGER
DIM INTsegment AS INTEGER, INToffset AS INTEGER
DIM InRegs AS RegTypeX, OutRegs AS RegTypeX
' Prints game version and loading message
PRINT
PRINT "WetSpot II - version " + VERSION$ + " by Enhanced Creations 1997-98"
IF COMPILED THEN
  PRINT "Running compiled version... ";
ELSE
  PRINT "Running under QB IDE... ";
END IF
cx = POS(0): cy = CSRLIN
' Gets game configuration
OPEN "WETSPOT2.CFG" FOR BINARY AS #1
IF LOF(1) = 0 THEN CLOSE : KILL "WETSPOT2.CFG": InitGame = 3: EXIT FUNCTION
GET #1, , BasePort%: GET #1, , Channel%: GET #1, , Volume
GET #1, , Game.soundon: GET #1, , Game.musicon
FOR i = 0 TO 1: GET #1, , Player(i).control: NEXT i
FOR i = 0 TO 1: FOR ii = 0 TO 4: GET #1, , Keys(i, ii): NEXT ii, i
FOR i = 0 TO 1: GET #1, , Joy(i).res: NEXT i: CLOSE #1
GOSUB PrintInfo
' Gets assembly routines code
OPEN "RESOURCE.BIN" FOR BINARY AS #3
IF LOF(3) = 0 THEN CLOSE : KILL "RESOURCE.BIN": InitGame = 1: EXIT FUNCTION
FOR i = 0 TO 12
  READ L: AsmCode(i) = SPACE$(L)
  GET #3, , AsmCode(i)
NEXT i
GOSUB PrintInfo
' Gets default palette and special palettes
GET #3, , pal
FOR i = 0 TO 2: GET #3, , EnemyPal(i): NEXT i
GOSUB PrintInfo
' Gets the font data
GET #3, , FontData
GOSUB PrintInfo
' Gets more assembly routines code
FOR i = 13 TO 16
  READ L: AsmCode(i) = SPACE$(L)
  GET #3, , AsmCode(i)
NEXT i: CLOSE #3
GOSUB PrintInfo
' Finds the memory address of interrupt 67h
DEF SEG = VARSEG(AsmCode(16))
CALL ABSOLUTE(&H67, INTsegment, INToffset, SADD(AsmCode(16)))
' If the "EMM" string is present, an expanded memory manager is available
DEF SEG = INTsegment
Emm$ = CHR$(PEEK(&HA)) + CHR$(PEEK(&HB)) + CHR$(PEEK(&HC))
IF Emm$ <> "EMM" THEN InitGame = 2: EXIT FUNCTION
' Finds EMS status
result = -1
DEF SEG = VARSEG(AsmCode(1))
   CALL ABSOLUTE(result, SADD(AsmCode(1)))
DEF SEG
IF result THEN InitGame = 2: EXIT FUNCTION
GOSUB PrintInfo
' Finds if enough free EMS memory is available...
TotalPages = 0: AvailablePages = 0
DEF SEG = VARSEG(AsmCode(0))
CALL ABSOLUTE(TotalPages, AvailablePages, SADD(AsmCode(0)))
DEF SEG
IF AvailablePages < (8 + ((MAXSOUNDS + 1) * 4)) THEN InitGame = 2: EXIT FUNCTION
GOSUB PrintInfo
' ...and if there's a free handle
NumHandles = 0
DEF SEG = VARSEG(AsmCode(4))
CALL ABSOLUTE(NumHandles, SADD(AsmCode(4)))
DEF SEG
IF NumHandles > 255 THEN InitGame = 2: EXIT FUNCTION
GOSUB PrintInfo
' Allocates required EMS memory
handle = 0: numpages = (8 + ((MAXSOUNDS + 1) * 4))
DEF SEG = VARSEG(AsmCode(2))
CALL ABSOLUTE(BYVAL numpages, handle, SADD(AsmCode(2)))
DEF SEG
GOSUB PrintInfo
' Gets the local pageframe address
EMShdl = handle
PageFrameAddr = 0
DEF SEG = VARSEG(AsmCode(5))
CALL ABSOLUTE(PageFrameAddr, SADD(AsmCode(5)))
DEF SEG
GOSUB PrintInfo
EMSseg = PageFrameAddr
' Check if the default world is available and opens it
DataFile$ = "WETSPOT2.WWD"
OPEN DataFile$ FOR BINARY AS #1
IF LOF(1) = 0 THEN CLOSE : KILL DataFile$: InitGame = 1: EXIT FUNCTION
id$ = SPACE$(5)
GET #1, , id$: GET #1, , Game.numareas
IF id$ <> "W2WDþ" THEN CLOSE : InitGame = 5: EXIT FUNCTION
GOSUB PrintInfo
' Loads the sprites into EMS
OPEN "SPRITES.BIN" FOR BINARY AS #2
IF LOF(2) = 0 THEN CLOSE : KILL "SPRITES.BIN": InitGame = 1: EXIT FUNCTION
CLOSE #2
MapEMS EMShdl, 0
DEF SEG = EMSseg: BLOAD "SPRITES.BIN", 0
GOSUB PrintInfo
' Gets axis dx/dy increase/decrease in each direction
FOR i = 0 TO 4
  READ dx(i), dy(i)
NEXT i
' Loads the keyboard interrupt handler
RESTORE KeyboardRoutineData
DEF SEG = VARSEG(kbcontrol(0))
FOR i = 0 TO 153: READ q: POKE i, q: NEXT i
n& = VARSEG(kbmatrix(0))
POKE 16, (n& AND 255): POKE 17, ((n& AND &HFF00) \ 256)
n& = VARPTR(kbmatrix(0))
POKE 18, (n& AND 255): POKE 19, ((n& AND &HFF00) \ 256)
DEF SEG
GOSUB PrintInfo
FOR i = 0 TO 1
  ' Initializes joystick 'i' bit masks
  Mask(i, 3) = 1 - ((i <> 0) * 3)
  Mask(i, 4) = Mask(i, 3) * 2
  Mask(i, 0) = Mask(i, 3) * 16
  Mask(i, 1) = Mask(i, 4) * 16
  Mask(i, 2) = Mask(i, 3) + Mask(i, 4)
  Joy(i).xc = 0: Joy(i).yc = 0
  ' Finds if joystick 'i' is available
  ReadJoy i
  Joy(i).xc = Joy(i).x
  Joy(i).yc = Joy(i).y
  Joy(i).detected = FALSE: IF Joy(i).xc <> 255 THEN Joy(i).detected = TRUE
NEXT i
' If the control method of a player is a joystick, while it's not available,
' the game configuration is bad
FOR i = 0 TO 1
  IF Player(i).control >= JOY1 THEN
    IF Joy(Player(i).control - 2).detected = FALSE THEN InitGame = 4: EXIT FUNCTION
  END IF
NEXT i
GOSUB PrintInfo
' If sounds or musics are selected in the SETUP program, initializes them
IF Game.soundon OR Game.musicon THEN
  ' Initializes sound card
  IF ResetDSP% THEN
    ' Sets current volume and turns on speakers
    SetVolume
    WriteDSP &HD1
    IF Game.musicon = TRUE THEN
      ' If music is on, the SBMIDI driver must be loaded
      SBMIDIok = FALSE
      ' Finds the interrupt 80h vector
      DEF SEG = VARSEG(AsmCode(16))
      CALL ABSOLUTE(&H80, INTsegment, INToffset, SADD(AsmCode(16)))
      ' If int 80h is free, the SBMIDI driver cannot be loaded
      IF INTsegment = 0 AND INToffset = 0 THEN
        InitGame = 5: EXIT FUNCTION
      ELSE
        ' Int 80h is occupied; let's see if it's occupied by the SBMIDI driver
        DEF SEG = INTsegment
        RESTORE SBMIDIdata
        ' Compares the data in memory with the normal SBMIDI data
        FOR i = 0 TO 255
          READ ByteTable
          IF PEEK(INToffset + i) = ByteTable THEN
            SBMIDIok = TRUE
          ELSE
            SELECT CASE i
            CASE 14, 15, 113, 114, 235, 236
            CASE ELSE
              SBMIDIok = FALSE: EXIT FOR
            END SELECT
          END IF
        NEXT i
        IF SBMIDIok = FALSE THEN
          ' Int 80h is occupied by another driver, not by SBMIDI
          InitGame = 6: EXIT FUNCTION
        END IF
      END IF
    END IF
    ' Loads the selected DMA channel data
    RESTORE DMAdata
    FOR i = 0 TO Channel%
      READ PgPort%, AddPort%, LenPort%, ModeReg%
    NEXT i
  ELSE
    InitGame = 7: EXIT FUNCTION
  END IF
END IF
GOSUB PrintInfo
' Loads the sounds into EMS (using interrupts for faster loading)
RESTORE SoundLength
ResFile$ = "RESOURCE.BIN" + CHR$(0)
InRegs.ax = &H3D00
InRegs.ds = VARSEG(ResFile$)
InRegs.dx = SADD(ResFile$)
InterruptX &H21, InRegs, OutRegs
filehandle% = OutRegs.ax
InRegs.ax = &H4200
InRegs.bx = filehandle%
InRegs.cx = 0
InRegs.dx = &H12C2
InterruptX &H21, InRegs, OutRegs
FOR i = 0 TO MAXSOUNDS
  READ readlen%: SoundLen(i) = readlen%
  filepos& = filepos& + readlen%
  MapEMS EMShdl, (8 + (i * 4))
  InRegs.ax = &H3F00
  InRegs.bx = filehandle%
  InRegs.cx = readlen%
  InRegs.ds = EMSseg
  InRegs.dx = 0
  InterruptX &H21, InRegs, OutRegs
  GOSUB PrintInfo
NEXT i
InRegs.ax = &H3E00
InRegs.bx = filehandle%
InterruptX &H21, InRegs, OutRegs
' Sets control names and exits initialization
ControlName(0) = "KEYBOARD 1"
ControlName(1) = "KEYBOARD 2"
ControlName(2) = "JOYSTICK 1"
ControlName(3) = "JOYSTICK 2"
ScreenShot = 0: PRINT "done!";
FOR i = 0 TO 63
  WAIT &H3DA, 8, 8: WAIT &H3DA, 8
  FOR ii = 0 TO 63
    PalGet ii, r, g, b
    IF r > 0 THEN r = r - 1
    IF g > 0 THEN g = g - 1
    IF b > 0 THEN b = b - 1
    PalSet ii, r, g, b
  NEXT ii
NEXT i
EXIT FUNCTION

PrintInfo:
' Prints some info on the loading process
info = (info + 1) MOD 4
LOCATE cy, cx
SELECT CASE info
CASE 0: PRINT "\";
CASE 1: PRINT "|";
CASE 2: PRINT "/";
CASE 3: PRINT "-";
END SELECT
LOCATE cy, cx
RETURN

END FUNCTION

SUB KillEnemy (EnemyNum)
' kills the enemy (it'll release a bonus!)
PlaySound 11
' Turns the enemy into a bouncing one
Enemy(EnemyNum).typ = -Enemy(EnemyNum).typ
Enemy(EnemyNum).x = (Enemy(EnemyNum).x \ 4) * 4
Enemy(EnemyNum).action = FALSE
Enemy(EnemyNum).change = 0
SELECT CASE INT(RND(1) * 4)
CASE 0: Enemy(EnemyNum).ox = -4
CASE 1: Enemy(EnemyNum).ox = -2
CASE 2: Enemy(EnemyNum).ox = 2
CASE 3: Enemy(EnemyNum).ox = 4
END SELECT
Enemy(EnemyNum).oy = -12
Enemy(EnemyNum).z = 8
Enemy(EnemyNum).frame = 0
' Decreases monsters number
Game.monsters = Game.monsters - 1
IF Game.monsters = 0 THEN
  ' No more enemies on the current level!
  TIMER OFF
  ' Delete all the special bonuses from the screen
  FOR e = 0 TO MAXOBJS
    IF Object(e).typ > 0 AND Object(e).typ < 18 THEN Object(e).typ = 98: Object(e).time = 0
  NEXT e
  IF Game.special = FALSE THEN
    ' Allows the players to collect some bonuses for a little time before
    ' ending the level
    Game.status = 200
  ELSE
    ' The "present" bonus has been taken; puts lots of bonuses randomly on
    ' the screen
    FOR e = 0 TO MAXOBJS \ 3
      DO
        RANDOMIZE TIMER
        xi = INT(RND(1) * 18) + 1
        yi = INT(RND(1) * 10) + 1
        GetBlockInfo Cel(xi, yi)
        IF st = 0 AND rd = 0 THEN EXIT DO
      LOOP
      Cel(xi, yi) = (nd * 100) + 1
      Object(e).typ = Game.special
      Object(e).time = 0
      Object(e).x = xi
      Object(e).y = yi
    NEXT e
    ' Gives the players more time to collect them
    Game.status = 1
  END IF
END IF

END SUB

SUB LoadLevel
' Loads a level from world data file
Game.monsters = 0
' Loads the level shape
SEEK #1, 738& + ((Game.area - 1) * 5738&) + 1368& + ((Game.level - 1) * 874&)
FOR i = 0 TO 11: FOR ii = 0 TO 19: GET #1, , Cel(ii, i): NEXT ii, i
' Gets level time, enemies stuff and players starting positions
GET #1, , Game.time
FOR i = 0 TO 15
  GET #1, , Enemy(i)
  IF Enemy(i).typ > 0 THEN Game.monsters = Game.monsters + 1
NEXT i
FOR i = 0 TO 1: GET #1, , Player(i).x: GET #1, , Player(i).y: NEXT i
' Clears screen buffer and draws the new level on it
FOR i = 0 TO 31999: Buffer(i) = 0: NEXT i
MapEMS EMShdl, 0
FOR ii = 11 TO 0 STEP -1: FOR i = 0 TO 19
  GetBlockInfo Cel(i, ii)
  PutShape (236 + nd), (i * 16), (ii * 16)
  IF st > 0 THEN
    PutShape (234 + st), (i * 16), (ii * 16)
    nst = st
    IF ii < 11 THEN
      GetBlockInfo Cel(i, ii + 1)
      IF st = 0 THEN PutShape (232 + nst), (i * 16), ((ii + 1) * 16)
    END IF
  END IF
NEXT i, ii
MapEMS EMShdl, 4
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
' Initializes game variables
FOR i = 0 TO MAXBLOCKS: Block(i).x = -1: NEXT i
FOR i = 0 TO MAXOBJS: Object(i).typ = 0: NEXT i
FOR i = 0 TO MAXSHOTS: Shot(i).typ = 0: NEXT i
Game.objects = 0
Game.status = 0
Game.special = FALSE
IF Game.mode = POTIONBONUS THEN Game.mode = NORMAL
' Initializes enemies variables
FOR i = 0 TO 15
  IF Enemy(i).typ > 0 AND Enemy(i).typ <> 3 THEN
    Enemy(i).dir = 4
    Enemy(i).ox = Enemy(i).x \ 16
    Enemy(i).oy = Enemy(i).y \ 16
  END IF
  RANDOMIZE TIMER
  SELECT CASE Enemy(i).typ
  CASE 1
    Enemy(i).z = INT(RND(1) * 7)
    Enemy(i).az = 1
  CASE 4
    Enemy(i).z = INT(RND(1) * 10)
    Enemy(i).az = 1
  CASE ELSE
    Enemy(i).z = 1
    Enemy(i).az = 0
  END SELECT
NEXT i
' Also initializes players at their starting positions
FOR i = 0 TO 1: Player(i).dead = TRUE: NEXT i
FOR i = 0 TO Game.players
  Player(i).dead = FALSE
  IF Player(i).lives = -1 THEN Player(i).dead = 3
  Player(i).status = -120
  Player(i).dir = 0
  IF Player(i).speed = 1 THEN Player(i).speed = 2
  Player(i).frame = 2
  Player(i).action = 0
  Player(i).potion = 0
NEXT i
Blocked = FALSE

END SUB

SUB LoadMIDI (Filename$, MIDISegment%, MIDIOffset%)
' LoadMIDI - loads a MIDI file into memory
IF Game.musicon = FALSE OR SBMIDIok = FALSE THEN EXIT SUB
' Checks if the MIDI file is available and if it can be stored in memory
FF% = FREEFILE: OPEN Filename$ FOR BINARY AS #FF%
FileLen& = LOF(FF%): CLOSE #FF%
IF FileLen& = 0 THEN KILL Filename$: MIDI.ERROR = 1: EXIT SUB
' The MIDI file is too long and cannot be stored in memory
IF FileLen& > 32000 THEN MIDI.ERROR = 2: EXIT SUB
' Loads the MIDI file
FilenameZ$ = Filename$ + CHR$(0)
DEF SEG = VARSEG(AsmCode(13))
CALL ABSOLUTE(VARSEG(FilenameZ$), SADD(FilenameZ$), MIDISegment%, MIDIOffset%, &HFFFF, SADD(AsmCode(13)))
MIDI.ERROR = 0

END SUB

SUB MapEMS (handle, pageoffset)
' Maps the EMS pageframe at pageoffset
numpages = 4
DEF SEG = VARSEG(AsmCode(3))
CALL ABSOLUTE(BYVAL pageoffset, BYVAL handle, BYVAL numpages, SADD(AsmCode(3)))
DEF SEG

END SUB

SUB MPrint (Text$, yPos, MCol, Shadow)
' Outs text centered on the screen at the given y position. This sub is used
' to display menu texts only (the palette is not the same of the game)
IF Text$ = "" THEN EXIT SUB
xPos = (320 - (LEN(Text$) * 8)) \ 2
' If shadows are on, draws the text 3 times shifted and with different colors
FOR o = 0 TO (-(Shadow <> 255) * 2)
  SELECT CASE o
  CASE 0
    yPos = yPos + 1: xx = xPos: col = Shadow
    IF Shadow = 255 THEN yPos = yPos - 1
  CASE 1
    yPos = yPos - 1: xx = xPos + 1
  CASE 2
    xx = xPos: col = MCol
  END SELECT
  ' Draws each character of the string
  FOR L = 1 TO LEN(Text$)
    Code = ASC(MID$(Text$, L, 1)) - 32
    xx = xx + 8
    DEF SEG = VARSEG(FontData)
    FOR ll = 0 TO 7
      IF yPos + ll > 104 AND yPos + ll < 195 THEN
        byte = PEEK(VARPTR(FontData) + (Code * 8) + ll)
        IF byte AND 1 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 1), (yPos + ll), col
        IF byte AND 2 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 2), (yPos + ll), col
        IF byte AND 4 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 3), (yPos + ll), col
        IF byte AND 8 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 4), (yPos + ll), col
        IF byte AND 16 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 5), (yPos + ll), col
        IF byte AND 32 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 6), (yPos + ll), col
        IF byte AND 64 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 7), (yPos + ll), col
        IF byte AND 128 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 8), (yPos + ll), col
      END IF
    NEXT ll
  NEXT L
NEXT o

END SUB

SUB NewArea
' Loads a new area data from the world data file, displaying an animated
' message.
Fade 0
CLS
' Gets world and area informations
WTitle$ = SPACE$(30): GET #1, 8, WTitle$: WTitle$ = RTRIM$(WTitle$)
WTitle$ = CHR$(34) + WTitle$ + CHR$(34)
ATitle$ = SPACE$(30): GET #1, 738 + ((Game.area - 1) * 5738&), ATitle$: ATitle$ = RTRIM$(ATitle$)
PassWord$ = SPACE$(4): GET #1, 58 + ((Game.area - 1) * 4), PassWord$
' If in demo mode the password isn't shown
IF Game.mode = DEMO THEN PassWord$ = "????"
MapEMS EMShdl, 0
' Clears the buffer and prints area informations on it
FOR i = 0 TO 31999: Buffer(i) = 0: NEXT i
t$ = "ENTERING AREA" + STR$(Game.area) + "..."
SPrint t$, ((320 - (LEN(t$) * 8)) \ 2), 60, 56
' Draws the living crabs at the center of the screen
IF Game.players = 0 THEN
  PutShape 1, 152, 110
ELSE
  IF Player(0).lives = -1 THEN
    PutShape 21, 152, 110
  ELSEIF Player(1).lives = -1 THEN
    PutShape 1, 152, 110
  ELSE
    PutShape 1, 132, 110
    PutShape 21, 172, 110
  END IF
END IF
SPrint WTitle$, ((320 - (LEN(WTitle$) * 8)) \ 2), 50, 56
SPrint (PassWord$ + LTRIM$(STR$(Game.players + 1))), 140, 140, 56
MapEMS EMShdl, 4
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
' Copies the buffer on the screen and displays it
BlastCopy EMSseg, 0, &HA000, 0
Fade 1
angle! = 0: t! = TIMER
DO
  t1! = TIMER
  BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  ' Draws the waving area title
  FOR i = 1 TO LEN(ATitle$)
    SPrint MID$(ATitle$, i, 1), (((320 - (LEN(ATitle$) * 8)) \ 2) + ((i - 1) * 8)), (86 + (SIN(angle! + (i / 2)) * 6)), 192
  NEXT i
  angle! = angle! + .3
  IF angle! > 6.28 THEN angle! = 0
  DO: LOOP WHILE TIMER < t1! + .02
  WAIT &H3DA, 8, 8: WAIT &H3DA, 8
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  IF TIMER > t! + 3 THEN EXIT DO
LOOP WHILE kbmatrix(Keys(0, 4)) = 0 AND kbmatrix(Keys(1, 4)) = 0 AND kbmatrix(1) = 0
' Gets area palette
FOR i = 0 TO 47
  s$ = SPACE$(1): GET #1, 738 + ((Game.area - 1) * 5738&) + 30 + i, s$
  MID$(pal, 721 + i, 1) = s$
NEXT i
' Loads game sprites again into EMS...
MapEMS EMShdl, 0
DEF SEG = EMSseg: BLOAD "SPRITES.BIN", 0
' ...and draws here the new area tiles
FOR i = 0 TO 4
  FOR ii = 0 TO 127
    GET #1, , Shape(ii)
  NEXT ii
  SpritePut (240 + (i * 16)), 176, EMSseg, 0
NEXT i
' Also draws the shadows of the blocks
DEF SEG = EMSseg
FOR i = 0 TO 31
  IF PEEK((191 * 320&) + 240 + i) > 0 THEN POKE ((176 * 320&) + 208 + i), 16: POKE ((177 * 320&) + 208 + i), 16
NEXT i
' Gets the area MIDI music file name...
MusicFile$ = SPACE$(8): GET #1, , MusicFile$
MusicFile$ = RTRIM$(MusicFile$) + ".MID"
' ...and checks if such a file is valid (its length must be <32K!)
OPEN MusicFile$ FOR BINARY AS #20: L& = LOF(20): CLOSE #20
IF L& = 0 THEN KILL MusicFile$
FOR i = 0 TO 31999: Buffer(i) = 0: NEXT i
IF L& > 32000 THEN
  ' MIDI file is too big: prompts a message!
  CLS
  SPrint "UNABLE TO LOAD MUSIC MIDI FILE", 40, 80, 56
  SPrint (CHR$(34) + MusicFile$ + CHR$(34)), ((336 - (LEN(MusicFile$) * 8)) \ 2), 90, 56
  SPrint "MIDI MUSIC FILES MUST BE <32K!", 40, 110, 56
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  FOR i = 0 TO 120: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT i
END IF
' Gets the default area text color
GET #1, , Game.textcol
Fade 0
CLS

END SUB

SUB PalGet (col, r, g, b)
' Gets the hues of given color index
OUT &H3C7, col
r = INP(&H3C9)
g = INP(&H3C9)
b = INP(&H3C9)

END SUB

SUB PalSet (col, r, g, b)
' Sets the hues of given color index
OUT &H3C8, col
OUT &H3C9, r
OUT &H3C9, g
OUT &H3C9, b

END SUB

SUB PlayMIDI (MIDISegment%, MIDIOffset%)
' PlayMIDI - Begins playing a MIDI file in the background.
IF Game.musicon = FALSE OR SBMIDIok = FALSE THEN EXIT SUB
IF MIDI.ERROR <> FALSE THEN EXIT SUB
' Begins to play the music
DEF SEG = VARSEG(AsmCode(14))
Offset% = SADD(AsmCode(14))
CALL ABSOLUTE(MIDISegment%, MIDIOffset%, Offset%)
' Start the MIDI timer.
MIDI.PLAYTIME = TIMER
MIDI.ERROR = 0
END SUB

SUB PlaySound (SoundNum)
' Plays a digital sound effect from EMS
IF Game.soundon = FALSE OR Game.mode = HIDDEN THEN EXIT SUB
' If another sound is playing, stop it
IF NOT DMAdone% THEN WriteDSP &HD4
' Maps the EMS pageframe to the page of the specified sound...
MapEMS EMShdl, (8 + (SoundNum * 4))
DEF SEG = EMSseg
' ...and does the DMA transfer
DMAplay EMSseg, 0, SoundLen(SoundNum), 11025&
MapEMS EMShdl, 4

END SUB

SUB PutScore (sc, xPos, yPos, sCol)
' Puts a score object on the screen
sc$ = LTRIM$(STR$(sc))
xPos = xPos + ((15 - (LEN(sc$) * 4)) \ 2) + (LEN(sc$) * 4)
' Draws each digit of the score number with the game font
FOR e = LEN(sc$) TO 1 STEP -1
  Code = ASC(MID$(sc$, e, 1)) + 11
  DEF SEG = VARSEG(FontData)
  FOR ee = 0 TO 4
    byte = PEEK(VARPTR(FontData) + (Code * 8) + ee)
    IF byte AND 8 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xPos), (yPos + ee), (sCol - ee - 4)
    IF byte AND 16 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xPos - 1), (yPos + ee), (sCol - ee - 3)
    IF byte AND 32 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xPos - 2), (yPos + ee), (sCol - ee - 2)
    IF byte AND 64 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xPos - 3), (yPos + ee), (sCol - ee - 1)
    IF byte AND 128 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xPos - 4), (yPos + ee), (sCol - ee)
  NEXT ee
  xPos = xPos - 4
NEXT e

END SUB

SUB PutShape (num, xPos, yPos)
' Puts a shape to the video buffer
SpriteGet ((num MOD 20) * 16), ((num \ 20) * 16), EMSseg, 0
SpritePut xPos, yPos, VARSEG(Buffer(0)), VARPTR(Buffer(0))

END SUB

FUNCTION SelectMenu (MaxSel)
' Returns the option selected in the menu, between MaxSel choices.
Game.mode = NORMAL
MoveSel = 0: Sel = 0
DrawMenu Sel
FOR i = 0 TO 20: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT i
TimeToDemo = 0
DO
  IF Sel MOD 10 = 0 THEN
    ' Stops the selection box
    MoveSel = 0
    ' Gets user input
    IF kbmatrix(72) AND Sel > 0 THEN MoveSel = -1: TimeToDemo = 0: PlaySound 0
    IF kbmatrix(80) AND Sel < (MaxSel * 10) THEN MoveSel = 1: TimeToDemo = 0: PlaySound 0
    IF kbmatrix(28) THEN
      ' The ENTER key is pressed
      PlaySound 1
      EXIT DO
    END IF
  END IF
  ' Moves the selection box
  Sel = Sel + MoveSel
  DrawMenu Sel
  TimeToDemo = TimeToDemo + 1
  IF TimeToDemo = 1000 THEN
    ' If no keys are pressed for a while, starts the demo
    Game.mode = DEMO: Game.players = INT(RND(1) * 2)
    PlayGame
    CLS : Fade 1
    ShowCredits
    ShowTop10 -1, -1
    Sel = -10: EXIT DO
  END IF
LOOP
SelectMenu = (Sel \ 10)

END FUNCTION

FUNCTION SelectWorld$
' Allows the user to select a new world between those in the current
' directory.
DIM DTA AS STRING * 44, regs AS RegTypeX, NumWorlds
DIM WorldFile$(99), WorldName$(99), WorldAuthor$(99), WorldAreas(99)
DO: LOOP WHILE kbmatrix(28)
NumWorlds = 0
' Performs a DOS find first function call to find available world files on
' the current directory
regs.ax = &H1A00
regs.dx = VARPTR(DTA)
regs.ds = -1
InterruptX &H21, regs, regs
ToFind$ = "*.WWD" + CHR$(0)
regs.ax = &H4E00
regs.cx = &H20
regs.dx = SADD(ToFind$)
regs.ds = -1
InterruptX &H21, regs, regs
IF regs.flags AND 1 THEN
  ' No worlds found. This should never occur, because the standard world
  ' should be always available!
  SelectWorld$ = "": EXIT FUNCTION
ELSE
  ' Stores the first world file name
  WorldFile$(0) = MID$(DTA, 31, INSTR(31, DTA, CHR$(0)) - 30)
END IF
DO
  ' Performs DOS find next functions to find other world files
  NumWorlds = NumWorlds + 1
  regs.ax = &H1A00
  regs.dx = VARPTR(DTA)
  regs.ds = -1
  InterruptX &H21, regs, regs
  regs.ax = &H4F00
  InterruptX &H21, regs, regs
  IF regs.flags AND 1 THEN
    ' No more worlds found
    EXIT DO
  ELSE
    ' Stores the world file name
    WorldFile$(NumWorlds) = MID$(DTA, 31, INSTR(31, DTA, CHR$(0)) - 30)
  END IF
LOOP
NumWorlds = NumWorlds - 1
' Gets infos on each world found
FOR i = 0 TO NumWorlds
  WorldFile$(i) = LEFT$(WorldFile$(i), LEN(WorldFile$(i)) - 1)
  id$ = ""
  OPEN WorldFile$(i) FOR BINARY AS #2
  IF LOF(2) > 4 THEN id$ = SPACE$(5): GET #2, 1, id$
  IF id$ <> "W2WDþ" THEN
    WorldFile$(i) = ""
  ELSE
    WorldName$(i) = SPACE$(30): GET #2, 8, WorldName$(i)
    WorldName$(i) = CHR$(34) + LTRIM$(RTRIM$(WorldName$(i))) + CHR$(34)
    WorldAuthor$(i) = SPACE$(20): GET #2, 38, WorldAuthor$(i)
    WorldAuthor$(i) = CHR$(34) + LTRIM$(RTRIM$(WorldAuthor$(i))) + CHR$(34)
    GET #2, 6, WorldAreas(i)
  END IF
  CLOSE #2
NEXT i
' If one of the worlds found was not a WetSpot 2 world datafile, deletes it
' from the worlds list
FOR L = 0 TO 99
  FOR i = 0 TO NumWorlds
    IF WorldFile$(i) = "" THEN
      NumWorlds = NumWorlds - 1
      IF i < NumWorlds THEN
        FOR ii = i TO NumWorlds - 1
          WorldFile$(ii) = WorldFile$(ii + 1)
          WorldName$(ii) = WorldName$(ii + 1)
          WorldAuthor$(ii) = WorldAuthor$(ii + 1)
          WorldAreas(ii) = WorldAreas(ii + 1)
        NEXT ii
      END IF
    END IF
  NEXT i
NEXT L
CurSel = 0
' Allows the user to select the world
DO
  ' Updates screen with selected world informations
  DEF SEG = VARSEG(Buffer(0)): BLOAD "TITLE.BIN", VARPTR(Buffer(0))
  MPrint "rr LOAD EXTERNAL WORLD ss", 110, 255, 252
  MPrint ("TITLE: " + WorldName$(CurSel)), 130, 254, 252
  MPrint ("AUTHOR: " + WorldAuthor$(CurSel)), 140, 254, 252
  MPrint ("NUMBER OF AREAS:" + STR$(WorldAreas(CurSel))), 150, 254, 252
  MPrint "PRESS l AND m TO SELECT", 170, 255, 252
  MPrint "<ENTER> TO CONFIRM", 180, 255, 252
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  DO
    ' Gets user input
    IF kbmatrix(77) THEN
      DO: LOOP WHILE kbmatrix(77)
      IF CurSel < NumWorlds THEN
        CurSel = CurSel + 1: PlaySound 0
        EXIT DO
      ELSE
        PlaySound 14
      END IF
    END IF
    IF kbmatrix(75) THEN
      DO: LOOP WHILE kbmatrix(75)
      IF CurSel > 0 THEN
        CurSel = CurSel - 1: PlaySound 0
        EXIT DO
      ELSE
        PlaySound 14
      END IF
    END IF
    ' The world has been selected!
    IF kbmatrix(28) THEN EXIT DO
  LOOP
  IF kbmatrix(28) THEN EXIT DO
LOOP
DO: LOOP WHILE kbmatrix(28)
PlaySound 1
SelectWorld$ = WorldFile$(CurSel)

END FUNCTION

SUB SetVolume
' Sets the master volume
OUT BasePort% + 4, &H22
OUT BasePort% + 5, (Volume + Volume * 16) AND &HFF

END SUB

SUB SPrint (Text$, xPos, yPos, col)
' Prints text at specified location with col color
xx = xPos
' Draws each character of the string
FOR L = 1 TO LEN(Text$)
  Code = ASC(MID$(Text$, L, 1)) - 32
  xx = xx + 8
  DEF SEG = VARSEG(FontData)
  FOR ll = 0 TO 7
    byte = PEEK(VARPTR(FontData) + (Code * 8) + ll)
    IF byte AND 1 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 1), (yPos + ll), col
    IF byte AND 2 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 2), (yPos + ll), col
    IF byte AND 4 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 3), (yPos + ll), col
    IF byte AND 8 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 4), (yPos + ll), col
    IF byte AND 16 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 5), (yPos + ll), col
    IF byte AND 32 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 6), (yPos + ll), col
    IF byte AND 64 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 7), (yPos + ll), col
    IF byte AND 128 THEN BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (xx - 8), (yPos + ll), col
    ' Fades the text color
    col = col + 1
  NEXT ll
  col = col - 8
NEXT L

END SUB

SUB SpriteGet (xPos, yPos, ssegment, soffset)
' Gets a sprite from EMS and puts it into Shape()
DEF SEG = VARSEG(AsmCode(11))
CALL ABSOLUTE(BYVAL xPos, BYVAL yPos, BYVAL ssegment, BYVAL soffset, BYVAL VARSEG(Shape(0)), BYVAL VARPTR(Shape(0)), SADD(AsmCode(11)))
DEF SEG

END SUB

SUB SpritePut (xPos, yPos, dsegment, doffset)
' Puts the contents of Shape() on the given page
DEF SEG = VARSEG(AsmCode(12))
CALL ABSOLUTE(BYVAL xPos, BYVAL yPos, BYVAL VARSEG(Shape(0)), BYVAL VARPTR(Shape(0)), BYVAL dsegment, BYVAL doffset, SADD(AsmCode(12)))
DEF SEG

END SUB

SUB StopMIDI
' StopMIDI - Stops playing MIDI file
IF Game.musicon = FALSE OR SBMIDIok = FALSE THEN EXIT SUB
IF MIDI.ERROR <> FALSE THEN EXIT SUB
DEF SEG = VARSEG(AsmCode(15))
Offset% = SADD(AsmCode(15))
CALL ABSOLUTE(Offset%)
' No MIDI file is playing, so reset the timer
MIDI.PLAYTIME = 0
MIDI.ERROR = 0
END SUB

