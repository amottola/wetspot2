' W2THIRD.BAS
' by Enhanced Creations 1997-98
' Tertiary module for WETSPOT II
'
' - Load WETSPOT2.BAS to run! -
'
' This module contains extra SUBs, FUNCTIONs and other game data
' shared with WETSPOT2.BAS.

'$INCLUDE: 'WETSPOT2.BI'

' Menu data
MainMenu:
DATA "rr MAIN MENU ss",110,255
DATA "START ONE PLAYER GAME",125,254
DATA "START TWO PLAYERS GAME",135,254
DATA "ENTER PASSWORD",145,254
DATA "LOAD EXTERNAL WORLD",155,254
DATA "OPTIONS",165,254
DATA "SHOW CREDITS",175,254
DATA "QUIT",185,254
QuitMenu:
DATA "rr QUIT GAME ss",110,255
DATA "",140,254
DATA "DON'T QUIT",150,254
DATA "",0,0
DATA "",0,0
DATA "",0,0
DATA "",0,0
DATA "",0,0
OptionsMenu:
DATA "rr OPTIONS MENU ss",110,255
DATA "",130,254
DATA "",140,254
DATA "CUSTOMIZE KEYS",150,254
DATA "MUSIC/FX VOLUME",160,254
DATA "EXIT MENU",170,254
DATA "",0,0
DATA "",0,0
CustomizeKeys:
DATA "DOWN","LEFT","UP","RIGHT","FIRE"

' Intro messages
IntroText:
DATA "A GAME BY ANGELO MOTTOLA"
DATA "CUBY & COBY ARE BACK..."
DATA "...AND THEY CLAIM..."

' Credits text
Credits:
DATA "WETSPOT 2"
DATA "VERSION "
DATA "BY ENHANCED CREATIONS 1997-98"
DATA ""
DATA "CODING BY ANGELO MOTTOLA"
DATA ""
DATA "GRAPHICS BY ANGELO MOTTOLA"
DATA ""
DATA "SPRITES HANDLING ROUTINES BY"
DATA "ANDREW L. AYERS (BLAST! LIBRARY)"
DATA "PETTER HOLMBERG (GET AND PUT)"
DATA ""
DATA "EMS MEMORY ROUTINES BY"
DATA "JONATHAN LEGER"
DATA ""
DATA "DMAPLAY ROUTINE BY"
DATA "TOSHIHIRO HORIE"
DATA ""
DATA "MIDI MUSIC ROUTINES BY"
DATA "JESSE DORLAND (QMIDI 3.0)"
DATA ""
DATA "KEYBOARD HANDLING ROUTINE BY"
DATA "MILO SEDLACEK"
DATA ""
DATA "BMP SAVING ROUTINE BY"
DATA "THOMAS NYBERG"
DATA ""
DATA "THANKS TO"
DATA ""
DATA "PETTER HOLMBERG"
DATA "MILO SEDLACEK"
DATA "INGMAR NEUWIRTH"
DATA "WALTER Má ARRIGHETTI"
DATA "AND EVERYONE ELSE WHO BROUGHT"
DATA "ME TO CODE THIS HARD WORK!"
DATA ""
DATA "WETSPOT 2 IS NOT A COPYRIGHTED"
DATA "PROGRAM. IT'S FREEWARE. ANYWAY,"
DATA "IF YOU WANT TO MODIFY ANYTHING"
DATA "OF IT, PLEASE TELL ME FIRST."
DATA ""
DATA "MY E-MAIL ADDRESS IS:"
DATA ""
DATA "ANGELILLO@GEOCITIES.COM"
DATA ""
DATA "AND MY HOME PAGE IS LOCATED AT:"
DATA ""
DATA "HTTP://WWW.GEOCITIES.COM/"
DATA "SILICONVALLEY/LAKES/7303"
DATA "(QB ENHANCED PROGRAMMING PAGE)"
DATA ""
DATA "THANKS FOR PLAYING WETSPOT 2!!"
DATA ""
DATA ""
DATA ""
DATA ""
DATA ""
DATA ""
DATA ""
DATA ""
DATA ""
DATA ""

SUB BlastCopy (fsegment, foffset, tsegment, toffset)
' Copies a 64K page into another
DEF SEG = VARSEG(AsmCode(7))
CALL ABSOLUTE(BYVAL fsegment, BYVAL foffset, BYVAL tsegment, BYVAL toffset, SADD(AsmCode(7)))
DEF SEG

END SUB

SUB BlastLine (dsegment, doffset, x1, y1, x2, y2, colr)
' Draws a line on specified page
DEF SEG = VARSEG(AsmCode(10))
CALL ABSOLUTE(BYVAL dsegment, BYVAL doffset, BYVAL x1, BYVAL y1, BYVAL x2, BYVAL y2, BYVAL colr, SADD(AsmCode(10)))
DEF SEG

END SUB

SUB BlastPset (Segment, Offset, xPos, yPos, col)
' Plots a pixel on specified page
DEF SEG = VARSEG(AsmCode(9))
CALL ABSOLUTE(BYVAL Segment, BYVAL Offset, BYVAL xPos, BYVAL yPos, BYVAL col, SADD(AsmCode(9)))
DEF SEG

END SUB

SUB CheckForRecord
' Checks if a player has made a high score.
DIM Record(9) AS RecordType, Blink(1)
' Opens the records file
RecordFile$ = LEFT$(DataFile$, INSTR(DataFile$, ".") - 1) + ".REC"
OPEN RecordFile$ FOR BINARY AS #2
IF LOF(2) <> 240 THEN
  ' Bad record file; creates a new one
  FOR i = 0 TO 9
    Record(i).nam = "NOBODY"
    Record(i).score = 10000
    Record(i).area = 1
    Record(i).level = 1
  NEXT i
  FOR i = 0 TO 9: PUT #2, , Record(i): NEXT i
ELSE
  ' Gets records
  FOR i = 0 TO 9: GET #2, , Record(i): NEXT i
END IF
CLOSE #2
FOR i = 0 TO 1: Blink(i) = -1: NEXT i
' Find if players have made an high score
FOR i = 0 TO Game.players
  FOR ii = 0 TO 9
    IF Player(i).score > Record(ii).score THEN Blink(i) = ii: EXIT FOR
  NEXT ii
NEXT i
' Adjusts players positions in the high score list
IF Blink(0) > -1 AND Blink(1) > -1 THEN
  IF Player(0).score > Player(1).score THEN Blink(1) = Blink(1) + 1 ELSE Blink(0) = Blink(0) + 1
END IF
IF Blink(0) > 9 THEN Blink(0) = -1
IF Blink(1) > 9 THEN Blink(1) = -1
IF Game.mode <> NORMAL THEN Blink(0) = -1: Blink(1) = -1
FOR i = 0 TO Game.players
  IF Blink(i) > -1 THEN
    ' Player 'i' has made an high score; gets his name for the top 10!
    s$ = GetText$("PLAYER" + STR$(i + 1) + ", YOU MADE A HIT! YOUR NAME:", 16)
    ' Shifts the other records...
    IF Blink(i) <> 9 THEN
      FOR ii = 9 TO Blink(i) + 1 STEP -1
        Record(ii).nam = Record(ii - 1).nam
        Record(ii).score = Record(ii - 1).score
        Record(ii).area = Record(ii - 1).area
        Record(ii).level = Record(ii - 1).level
      NEXT ii
    END IF
    ' ...and inserts the new champion
    Record(Blink(i)).nam = s$
    Record(Blink(i)).score = Player(i).score
    Record(Blink(i)).area = ((Player(i).levelreached - 1) \ 5) + 1
    Record(Blink(i)).level = ((Player(i).levelreached - 1) MOD 5) + 1
  END IF
NEXT i
' Stores the new world record file
OPEN RecordFile$ FOR BINARY AS #2
FOR i = 0 TO 9: PUT #2, , Record(i): NEXT i
CLOSE #2
' Shows the updated top 10 players list
ShowTop10 Blink(0), Blink(1)

END SUB

SUB CheckScore (PlayerNum)
' Checks if the player has gained enough points for an extra life
IF Player(PlayerNum).score >= Player(PlayerNum).nextextra THEN
  IF Player(PlayerNum).nextextra = 30000 THEN Player(PlayerNum).nextextra = 0
  Player(PlayerNum).nextextra = Player(PlayerNum).nextextra + 100000
  Player(PlayerNum).lives = Player(PlayerNum).lives + 1
  PlaySound 7
END IF

END SUB

FUNCTION DMAdone%
' Checks if the DMA transfer is complete
count% = INP((Channel% * 2) + 1)
Count2% = INP((Channel% * 2) + 1)
count& = CLNG(count% + 1) * CLNG(Count2% + 1)
IF (count& - 1) >= &HFFFF& THEN junk% = INP(DSPDataAvail%): DMAdone% = -1
END FUNCTION

SUB DMAplay (Segment, Offset, Length&, Freq&)
' Plays a sound via the DMA transfer.
Length& = Length& - 1: Page% = 0
MemLoc& = Segment * 16& + Offset
OUT &HA, &H4 + Channel%
OUT &HC, &H0
OUT &HB, ModeReg%
OUT AddPort%, MemLoc& AND &HFF
OUT AddPort%, (MemLoc& AND &HFFFF&) \ &H100
IF (MemLoc& AND 65536) THEN Page% = Page% + 1
IF (MemLoc& AND 131072) THEN Page% = Page% + 2
IF (MemLoc& AND 262144) THEN Page% = Page% + 4
IF (MemLoc& AND 524288) THEN Page% = Page% + 8
OUT PgPort%, Page%
OUT LenPort%, Length& AND &HFF
OUT LenPort%, (Length& AND &HFFFF&) \ &H100
OUT &HA, Channel%
TimeConst% = 256 - 1000000 \ Freq&
WriteDSP &H40
WriteDSP TimeConst%
WriteDSP &H14
WriteDSP (Length& AND &HFF)
WriteDSP ((Length& AND &HFFFF&) \ &H100)

END SUB

SUB DrawMenu (Sel)
' Draws the game menu together with the selection box
DIM factor AS SINGLE
' Copies the background into the buffer
BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
IF Sel > -1 THEN
  IF Sel MOD 10 = 0 THEN
    ' Put stopped selection box
    x1 = ((320 - (LEN(RTRIM$(MenuText((Sel \ 10) + 1).Text)) * 8)) \ 2) - 8
    y1 = MenuText(1).y + Sel - 2
    x2 = x1 + (LEN(RTRIM$(MenuText((Sel \ 10) + 1).Text)) * 8) + 15
    y2 = y1 + 10
    GOSUB PutBox
  ELSE
    ' The selection box is moving; calculates its new dimensions
    prevsel = (Sel \ 10) + 1: nextsel = prevsel + 1: factor = (Sel MOD 10) / 10
    prevx1 = ((320 - (LEN(RTRIM$(MenuText(prevsel).Text)) * 8)) \ 2) - 8
    prevx2 = prevx1 + (LEN(RTRIM$(MenuText(prevsel).Text)) * 8) + 15
    nextx1 = ((320 - (LEN(RTRIM$(MenuText(nextsel).Text)) * 8)) \ 2) - 8
    nextx2 = nextx1 + (LEN(RTRIM$(MenuText(nextsel).Text)) * 8) + 15
    x1 = prevx1 + ((nextx1 - prevx1) * factor)
    y1 = MenuText(prevsel).y + (Sel MOD 10) - 2
    x2 = prevx2 + ((nextx2 - prevx2) * factor)
    y2 = y1 + 10
    GOSUB PutBox
  END IF
END IF
' Updates the screen
WAIT &H3DA, 8, 8: WAIT &H3DA, 8
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
EXIT SUB

PutBox:
' Draws the box!
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), x1, y1, x2, y1, 83
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), x1, y2, x2, y2, 83
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), x1, y1, x1, y2, 83
BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), x2, y1, x2, y2, 83
RETURN

END SUB

SUB GetAction (PlayerNum)
' Gets player input from selected control method and sets the right action.
DIM FindDir, pd(3)
IF Player(PlayerNum).dead <> FALSE THEN EXIT SUB
IF Game.mode = NORMAL OR Game.mode = POTIONBONUS THEN
  ' Process player input
  SELECT CASE Player(PlayerNum).control
  ' Keyboard control method
  CASE KEYBOARD1, KEYBOARD2
    IF kbmatrix(Keys(Player(PlayerNum).control, 4)) THEN
      ' Fire button pressed
      Player(PlayerNum).action = 2
    ELSEIF kbmatrix(Keys(Player(PlayerNum).control, 0)) THEN
      ' Going down
      Player(PlayerNum).dir = 0
      GetBlockInfo Cel(Player(PlayerNum).x \ 16, (Player(PlayerNum).y \ 16) + 1)
      IF st = 0 THEN Player(PlayerNum).action = 1
    ELSEIF kbmatrix(Keys(Player(PlayerNum).control, 1)) THEN
      ' Going left
      Player(PlayerNum).dir = 1
      GetBlockInfo Cel((Player(PlayerNum).x \ 16) - 1, Player(PlayerNum).y \ 16)
      IF st = 0 THEN Player(PlayerNum).action = 1
    ELSEIF kbmatrix(Keys(Player(PlayerNum).control, 2)) THEN
      ' Going up
      Player(PlayerNum).dir = 2
      GetBlockInfo Cel(Player(PlayerNum).x \ 16, (Player(PlayerNum).y \ 16) - 1)
      IF st = 0 THEN Player(PlayerNum).action = 1
    ELSEIF kbmatrix(Keys(Player(PlayerNum).control, 3)) THEN
      ' Going right
      Player(PlayerNum).dir = 3
      GetBlockInfo Cel((Player(PlayerNum).x \ 16) + 1, Player(PlayerNum).y \ 16)
      IF st = 0 THEN Player(PlayerNum).action = 1
    ELSE
      Player(PlayerNum).frame = 2
    END IF
  ' Joystick control method
  CASE JOY1, JOY2
    ' Reads joystick data
    jNum = Player(PlayerNum).control - 2
    TIMER OFF
    ReadJoy jNum
    IF Game.monsters > 0 THEN TIMER ON
    IF Joy(jNum).but THEN
      ' Fire button pressed
      Player(PlayerNum).action = 2
    ELSEIF Joy(jNum).y > Joy(jNum).res THEN
      ' Going down
      Player(PlayerNum).dir = 0
      GetBlockInfo Cel(Player(PlayerNum).x \ 16, (Player(PlayerNum).y \ 16) + 1)
      IF st = 0 THEN Player(PlayerNum).action = 1
    ELSEIF Joy(jNum).x < -Joy(jNum).res THEN
      ' Going left
      Player(PlayerNum).dir = 1
      GetBlockInfo Cel((Player(PlayerNum).x \ 16) - 1, Player(PlayerNum).y \ 16)
      IF st = 0 THEN Player(PlayerNum).action = 1
    ELSEIF Joy(jNum).y < -Joy(jNum).res THEN
      ' Going up
      Player(PlayerNum).dir = 2
      GetBlockInfo Cel(Player(PlayerNum).x \ 16, (Player(PlayerNum).y \ 16) - 1)
      IF st = 0 THEN Player(PlayerNum).action = 1
    ELSEIF Joy(jNum).x > Joy(jNum).res THEN
      ' Going right
      Player(PlayerNum).dir = 3
      GetBlockInfo Cel((Player(PlayerNum).x \ 16) + 1, Player(PlayerNum).y \ 16)
      IF st = 0 THEN Player(PlayerNum).action = 1
    ELSE
      Player(PlayerNum).frame = 2
    END IF
  END SELECT
ELSE
  ' The computer moves the player in demo mode
  RANDOMIZE TIMER
  ' Gets info on surrounding blocks
  FOR d = 0 TO 3
    GetBlockInfo Cel((Player(PlayerNum).x \ 16) + dx(d), (Player(PlayerNum).y \ 16) + dy(d))
    pd(d) = st
  NEXT d
  Player(PlayerNum).action = 0
  ' Gets info on the cell the crab is moving onto
  GetBlockInfo Cel((Player(PlayerNum).x \ 16) + dx(Player(PlayerNum).dir), (Player(PlayerNum).y \ 16) + dy(Player(PlayerNum).dir))
  IF st <> 0 THEN
    ' Way blocked!
    FindDir = FALSE
    IF st = 2 THEN
      ' If the block can be moved, sometimes it's pushed!
      IF INT(RND(1) * 3) = 0 THEN Player(PlayerNum).action = 2 ELSE FindDir = TRUE
    END IF
    IF st = 1 OR FindDir = TRUE THEN
      ' tries to find a way out
      FOR d = 0 TO 15
        dd = INT(RND(1) * 4)
        IF pd(dd) = 0 THEN Player(PlayerNum).dir = dd: Player(PlayerNum).action = 1: EXIT FOR
      NEXT d
    END IF
  ELSE
    IF INT(RND(1) * 3) = 0 THEN
      ' Moves the crab
      FOR d = 0 TO 15
        dd = INT(RND(1) * 4)
        IF pd(dd) = 0 THEN
          Player(PlayerNum).dir = dd: Player(PlayerNum).action = 1: EXIT FOR
        ELSEIF pd(dd) = 2 THEN
          Player(PlayerNum).dir = dd: Player(PlayerNum).action = 2: EXIT FOR
        END IF
      NEXT d
    ELSE
      Player(PlayerNum).action = 1
    END IF
  END IF
END IF

END SUB

SUB HandleObjects
' Checks for objects
FOR i = 0 TO MAXOBJS
  IF Object(i).typ > 0 THEN
    ' We've an object on the screen
    Object(i).time = Object(i).time + 1
    ' If the object is on the screen for a long time, deletes it
    IF Object(i).time > 500 THEN Object(i).typ = 98: Object(i).time = 0
    SELECT CASE Object(i).typ
    CASE 97
      ' Enemy change effect
      IF Object(i).time = 12 THEN Object(i).typ = 0
    CASE 98
      ' The object is disappearing
      IF Object(i).time = 12 THEN Object(i).typ = 0: Game.objects = Game.objects - 1
    CASE 99
      ' Explosion
      IF Object(i).time = 9 THEN Object(i).typ = 0
    CASE IS > 99
      ' Deletes score objects after a little time
      IF Object(i).time = 40 THEN Object(i).typ = 0: Game.objects = Game.objects - 1
    END SELECT
    FOR ii = 0 TO Game.players
      IF Player(ii).dead = FALSE THEN
        ' Checks is a player has got the object
        IF (Player(ii).x \ 16) = Object(i).x AND (Player(ii).y \ 16) = Object(i).y THEN
          IF Player(ii).x MOD 16 = 0 AND Player(ii).y MOD 16 = 0 THEN
            Points = 0
            SELECT CASE Object(i).typ
            CASE 1 TO 5
              ' BONUS letters
              PlaySound 10
              MID$(Player(ii).bonus, Object(i).typ, 1) = MID$("BONUS", Object(i).typ, 1)
              Points = 100
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
              IF Player(ii).bonus = "BONUS" THEN
                Player(ii).lives = Player(ii).lives + 1
                Player(ii).bonus = "hhhhh"
                PlaySound 7
              END IF
            CASE 6
              ' Invulnerability
              PlaySound 9
              Points = 500
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
              Player(ii).status = -600
            CASE 7
              ' Player speed up
              PlaySound 9
              Points = 500
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
              Player(ii).speed = 4
            CASE 8
              ' Earthquake shock
              Points = 500
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
              Game.status = -1
              TIMER OFF
            CASE 9
              ' Lightning shock
              Points = 500
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
              ChangePal 1
              Game.status = -2
              TIMER OFF
            CASE 10
              ' Stop clock
              PlaySound 3
              Points = 500
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
              ChangePal 2
              Game.status = -500
            CASE 11
              ' Extra life
              PlaySound 7
              Points = 1000
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
              Player(ii).lives = Player(ii).lives + 1
            CASE 12
              ' Level Warp
              PlaySound 9
              FOR e = 0 TO 4
                PalSet 0, 63, 0, 0
                FOR ee = 0 TO 15: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT ee
                PalSet 0, 0, 0, 0
                FOR ee = 0 TO 15: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT ee
              NEXT e
              Game.special = TRUE
              Game.status = 500
            CASE 13
              ' Dynamite
              Points = 100
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
              ' Updates screen bacground
              FOR xi = 1 TO 18
                FOR yi = 1 TO 10
                  IF (((Object(i).x - xi) ^ 2) + ((Object(i).y - yi) ^ 2)) < 17 THEN
                    GetBlockInfo Cel(xi, yi)
                    IF st = 2 THEN
                      bonus = rd
                      MapEMS EMShdl, 4
                      BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
                      MapEMS EMShdl, 0
                      PutShape (236 + nd), (xi * 16), (yi * 16)
                      Cel(xi, yi) = nd * 100
                      GetBlockInfo Cel(xi, yi - 1)
                      IF st > 0 THEN PutShape (232 + st), (xi * 16), (yi * 16)
                      GetBlockInfo Cel(xi, yi + 1)
                      IF st = 0 THEN PutShape (236 + nd), (xi * 16), ((yi + 1) * 16)
                      MapEMS EMShdl, 4
                      BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
                      MapEMS EMShdl, 0
                      FOR iii = 0 TO MAXOBJS
                        IF Object(iii).typ = 0 THEN EXIT FOR
                      NEXT iii
                      Object(iii).x = xi
                      Object(iii).y = yi
                      Object(iii).typ = 99
                      Object(iii).time = 0
                      IF bonus > 0 THEN
                        ' If a destroyed block has a hidden object, shows it
                        FOR iii = 0 TO MAXOBJS
                          IF Object(iii).typ = 0 THEN EXIT FOR
                        NEXT iii
                        Object(iii).x = xi
                        Object(iii).y = yi
                        Object(iii).typ = bonus
                        Object(iii).time = 220
                        Game.objects = Game.objects + 1
                      END IF
                    END IF
                  END IF
                NEXT yi
              NEXT xi
            CASE 14
              ' Potion bonus
              PlaySound 9
              TIMER OFF
              Game.status = -501
              FOR e = 0 TO MAXENEMIES: Enemy(e).typ = 0: NEXT e
              FOR e = 0 TO MAXSHOTS
                Shot(e).typ = 0
              NEXT e
              ' Changes all the moveable blocks into fixed ones and updates
              ' the screen background
              FOR xi = 1 TO 18
                FOR yi = 1 TO 10
                  GetBlockInfo Cel(xi, yi)
                  IF st = 2 THEN
                    MapEMS EMShdl, 4
                    BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
                    MapEMS EMShdl, 0
                    PutShape (236 + nd), (xi * 16), (yi * 16)
                    PutShape 235, (xi * 16), (yi * 16)
                    Cel(xi, yi) = 1100
                    MapEMS EMShdl, 4
                    BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
                    MapEMS EMShdl, 0
                  END IF
                NEXT yi
              NEXT xi
              ' Chooses a random bonus item
              bonus = 26 + INT(RND(1) * 8)
              FOR e = 0 TO MAXOBJS: Object(e).typ = 0: NEXT e
              NumPotions = MAXOBJS: IF NumPotions > 23 THEN NumPotions = 23
              ' Puts the special bonuses into the objects queue
              FOR e = 0 TO NumPotions
                DO
                  RANDOMIZE TIMER
                  xi = INT(RND(1) * 18) + 1
                  yi = INT(RND(1) * 10) + 1
                  GetBlockInfo Cel(xi, yi)
                  IF st = 0 AND rd = 0 THEN EXIT DO
                LOOP
                Cel(xi, yi) = (nd * 100) + 1
                Object(e).typ = bonus
                Object(e).x = xi
                Object(e).y = yi
              NEXT e
              ' Initializes potion bonus game mode variables
              Game.objects = NumPotions
              Game.time = 20 - ((Game.players <> 1) * 5)
              FOR e = 0 TO Game.players: Player(e).potion = 0: NEXT e
              Game.mode = POTIONBONUS
              TIMER ON
              EXIT SUB
            CASE 15
              ' Present
              PlaySound 9
              Points = 500
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
              Game.special = INT(RND(1) * 16) + 18
            CASE 16
              ' Extra points
              PlaySound 8
              Points = 9000
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
            CASE 17
              ' Chest (????)
              RANDOMIZE TIMER
              SELECT CASE INT(RND(1) * 4)
              CASE 0
                ' Extra points
                PlaySound 8
                Points = 5000
                Object(i).typ = Points + (ii * 10000)
                Object(i).time = 0
              CASE 1
                ' Player slow down
                PlaySound 9
                Points = 100
                Object(i).typ = Points + (ii * 10000)
                Object(i).time = 0
                Player(ii).speed = 1
              CASE 2
                ' Extra life
                PlaySound 7
                Points = 500
                Object(i).typ = Points + (ii * 10000)
                Object(i).time = 0
                Player(ii).lives = Player(ii).lives + 1
              CASE 3
                ' Monster change
                PlaySound 9
                Points = 500
                Object(i).typ = Points + (ii * 10000)
                Object(i).time = 0
                ChangeTo = INT(RND(1) * 5) + 1
                IF ChangeTo = 3 THEN ChangeTo = 7
                IF ChangeTo = 5 THEN ChangeTo = 6
                FOR e = 0 TO MAXENEMIES
                  IF Enemy(e).typ > 0 THEN Enemy(e).change = ChangeTo
                NEXT e
              END SELECT
            CASE 18 TO 33
              ' Normal bonuses
              PlaySound 8
              Points = (((Object(i).typ - 18) MOD 8) + 1) * 100
              Object(i).typ = Points + (ii * 10000)
              Object(i).time = 0
            END SELECT
            ' If we're in normal game mode, adds the score
            IF Game.mode < POTIONBONUS THEN Player(ii).score = Player(ii).score + Points
            CheckScore ii
            Game.objects = Game.objects - 1
          END IF
        END IF
      END IF
    NEXT ii
  END IF
NEXT i

END SUB

SUB HandlePotion
' Handles potion bonus
FOR i = 0 TO MAXOBJS
  IF Object(i).typ > 0 THEN
    ' We've a bonus
    FOR ii = 0 TO Game.players
      ' Checks if a player has got it
      IF (Player(ii).x \ 16) = Object(i).x AND (Player(ii).y \ 16) = Object(i).y THEN
        IF Player(ii).x MOD 16 = 0 AND Player(ii).y MOD 16 = 0 THEN
          PlaySound 8
          Object(i).typ = 0
          Game.objects = Game.objects - 1
          Player(ii).potion = Player(ii).potion + 1
          IF Game.objects = -1 THEN
            ' No more bonuses on the screen
            TIMER OFF
            TotalBonus& = Game.time * 10000&
            ' Outs special bonus statistics
            SPrint "POTION BONUS", 112, 50, Game.textcol
            BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 110, 59, 208, 59, Game.textcol
            IF Game.players = 0 THEN
              ' If we're in one player mode, shows the PERFECT message only
              SPrint "PERFECT!", 128, 80, Game.textcol
              SPrint (LTRIM$(STR$(TotalBonus&)) + " PTS"), 124, 96, Game.textcol
              Player(0).score = Player(0).score + TotalBonus&
            ELSE
              FOR e = 0 TO 1
                ' We're in two players mode
                IF Player(e).dead = FALSE THEN
                  SPrint ("PLAYER" + STR$(e + 1)), (80 + (e * 96)), 72, Game.textcol
                  ' Calculates percentage of bonuses taken by each player
                  percent = (Player(e).potion / ((MAXOBJS + 1) \ 2)) * 100
                  IF percent = 0 THEN
                    ' No bonuses taken by current player!
                    s$ = "NO BONUS": t = 0
                  ELSEIF percent < 50 THEN
                    ' If the player has got less than 50% of the bonuses, he
                    ' gets half the total bonus.
                    s$ = "HALF BONUS": t = -8
                    Player(e).score = Player(e).score + (TotalBonus& \ 2)
                  ELSE
                    ' Otherwise he gains a PERFECT!
                    s$ = "PERFECT!": t = 0
                    Player(e).score = Player(e).score + TotalBonus&
                  END IF
                  perc$ = LTRIM$(STR$(percent)) + "%"
                  SPrint perc$, ((96 + ((4 - LEN(perc$)) * 8)) + (e * 96)), 80, Game.textcol
                  SPrint s$, (80 + (e * 96) + t), 88, Game.textcol
                  p$ = "  0 PTS  "
                  IF s$ = "PERFECT!" THEN p$ = LTRIM$(STR$(TotalBonus&)) + " PTS" ELSE IF s$ = "HALF BONUS" THEN p$ = LTRIM$(STR$(TotalBonus& \ 2)) + " PTS"
                  SPrint p$, (76 + (e * 96)), 100, Game.textcol
                END IF
              NEXT e
            END IF
            ' Updates buffer and copies it on the screen
            BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 110, 115, 208, 115, Game.textcol
            BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
            FOR e = 0 TO Game.players
              CheckScore e
            NEXT e
            FOR e = 0 TO 400
              WAIT &H3DA, 8, 8: WAIT &H3DA, 8
              IF kbmatrix(28) OR kbmatrix(1) THEN EXIT FOR
            NEXT e
            ' Once the potion bonus is completed, the level is passed
            Game.status = 501
          END IF
        END IF
      END IF
    NEXT ii
  END IF
NEXT i

END SUB

SUB Intro
' Shows a little game intro
Fade 0
WHILE INKEY$ <> "": WEND
' Restores game palette
OPEN "RESOURCE.BIN" FOR BINARY AS #2
GET #2, 637, pal: CLOSE #2
' Loads the sprites into EMS
MapEMS EMShdl, 0
DEF SEG = EMSseg: BLOAD "SPRITES.BIN", 0
' Displays the three intro messages
RESTORE IntroText
FOR i = 0 TO 2
  Fade 0
  CLS
  BlastCopy &HA000, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  READ iText$
  SPrint iText$, ((320 - (LEN(iText$) * 8)) \ 2), 96, 56
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  Fade 1
  IF i = 2 THEN EXIT FOR
  FOR ii = 0 TO 200
    WAIT &H3DA, 8, 8: WAIT &H3DA, 8
    IF INKEY$ <> "" THEN EXIT SUB
  NEXT ii
NEXT i
' At the last message, begins animating the crabs
MapEMS EMShdl, 4
BlastCopy &HA000, 0, EMSseg, 0
frame = 0: aframe = 1
FOR i = 0 TO 154 STEP 2
  MapEMS EMShdl, 4
  BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  MapEMS EMShdl, 0
  PutShape (12 + frame), (i - 16), 92
  PutShape (24 + frame), (320 - i), 92
  IF i MOD 4 = 0 THEN
    frame = frame + aframe
    IF frame = 0 OR frame = 2 THEN aframe = -aframe
  END IF
  FOR ii = 0 TO 2: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT ii
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  IF INKEY$ <> "" THEN EXIT SUB
NEXT i
' Makes the crabs do their victory gesture...
FOR i = 0 TO 2
  MapEMS EMShdl, 4
  BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  MapEMS EMShdl, 0
  PutShape (16 + i), 138, 92
  PutShape (36 + i), 166, 92
  FOR ii = 0 TO 7: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT ii
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  IF INKEY$ <> "" THEN EXIT SUB
NEXT i
' ...and let they say: "Revenge!"
IF Game.soundon = TRUE THEN
  MapEMS EMShdl, 76
  DEF SEG = EMSseg
  DMAplay EMSseg, 0, SoundLen(17), 11025&
END IF
SPrint "REVENGE!", 128, 80, 192
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
FOR i = 0 TO 150
  WAIT &H3DA, 8, 8: WAIT &H3DA, 8
  IF INKEY$ <> "" THEN EXIT FOR
NEXT i

END SUB

SUB Logo
' Displays animated Enhanced Creations logo
DIM SpotLight(30, 30) AS INTEGER, sy(2), ay(2)
SCREEN 13
' Initializes the spotlight array
FOR x = 0 TO 30
  FOR y = 0 TO 30
    SpotLight(x, y) = 56 - (SQR(((x - 15) ^ 2) + ((y - 15) ^ 2)) * 7)
  NEXT y
NEXT x
' Initializes logo palette
FOR i = 0 TO 63
  MID$(pal, (i * 3) + 1, 1) = CHR$(0)
  MID$(pal, (i * 3) + 2, 1) = CHR$(i)
  MID$(pal, (i * 3) + 3, 1) = CHR$(0)
  MID$(pal, (i * 3) + 193, 1) = CHR$(i)
  MID$(pal, (i * 3) + 194, 1) = CHR$(63)
  MID$(pal, (i * 3) + 195, 1) = CHR$(i)
NEXT i
MID$(pal, 385, 384) = STRING$(384, 0)
' Loads the logo into EMS
Fade 0
MapEMS EMShdl, 4
BlastCopy &HA000, 0, EMSseg, 0
DEF SEG = EMSseg: BLOAD "LOGO.BIN", 0
MapEMS EMShdl, 0
DEF SEG = EMSseg
BlastCopy &HA000, 0, EMSseg, 0
Fade 1
WHILE INKEY$ <> "": WEND
' Animates the spotlights
sy(0) = 60: sy(1) = 70: sy(2) = 96: ay(0) = 0: ay(1) = -4: ay(2) = -8
FOR i = -30 TO 382 STEP 3
  t! = TIMER
  FOR ii = 0 TO 2
    sy(ii) = sy(ii) + ay(ii): y = sy(ii): x = i - (ii * 31): GOSUB DrawLight
    IF sy(ii) > 115 THEN ay(ii) = -ay(ii) ELSE ay(ii) = ay(ii) + 1
  NEXT ii
  DO: LOOP WHILE TIMER < t! + .02
  WAIT &H3DA, 8, 8: WAIT &H3DA, 8
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  MapEMS EMShdl, 0
  BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  IF INKEY$ <> "" THEN EXIT SUB
NEXT i
' Flashes the screen by setting a white palette
FOR i = 1 TO 127
  PalSet i, 63, 63, 63
NEXT i
' Fades the colors to their original hues
MapEMS EMShdl, 4
BlastCopy EMSseg, 0, &HA000, 0
FOR i = 1 TO 127
  FOR ii = 1 TO 127
    PalGet ii, r, g, b
    IF r > ASC(MID$(pal, (ii * 3) + 1, 1)) THEN r = r - 1
    IF g > ASC(MID$(pal, (ii * 3) + 2, 1)) THEN g = g - 1
    IF b > ASC(MID$(pal, (ii * 3) + 3, 1)) THEN b = b - 1
    PalSet ii, r, g, b
  NEXT ii
  IF INKEY$ <> "" THEN EXIT SUB
  FOR ii = 0 TO 2: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT ii
NEXT i
pPal$ = STRING$(24, 0)
' Changes the palette to animate the "presents" message
FOR i = 0 TO 15
  r = 64 - (i * 8): IF r < 0 THEN r = 0
  g = 160 - (i * 8): IF g > 63 THEN g = 63
  b = 64 - (i * 8): IF b < 0 THEN b = 0
  MID$(pPal$, 4, 21) = MID$(pPal$, 1, 21)
  MID$(pPal$, 1, 1) = CHR$(r)
  MID$(pPal$, 2, 1) = CHR$(g)
  MID$(pPal$, 3, 1) = CHR$(b)
  FOR ii = 0 TO 1: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT ii
  FOR ii = 0 TO 7
    PalSet (128 + ii), ASC(MID$(pPal$, (ii * 3) + 1, 1)), ASC(MID$(pPal$, (ii * 3) + 2, 1)), ASC(MID$(pPal$, (ii * 3) + 3))
  NEXT ii
  IF INKEY$ <> "" THEN EXIT SUB
NEXT i
FOR i = 0 TO 7
  MID$(pPal$, 4, 21) = MID$(pPal$, 1, 21)
  MID$(pPal$, 1, 1) = CHR$(0)
  MID$(pPal$, 2, 1) = CHR$(40)
  MID$(pPal$, 3, 1) = CHR$(0)
  FOR ii = 0 TO 1: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT ii
  FOR ii = 0 TO 7
    PalSet (128 + ii), ASC(MID$(pPal$, (ii * 3) + 1, 1)), ASC(MID$(pPal$, (ii * 3) + 2, 1)), ASC(MID$(pPal$, (ii * 3) + 3))
  NEXT ii
  IF INKEY$ <> "" THEN EXIT SUB
NEXT i
WHILE INKEY$ <> "": WEND
FOR i = 0 TO 200
  WAIT &H3DA, 8, 8: WAIT &H3DA, 8
  IF INKEY$ <> "" THEN EXIT FOR
NEXT i
EXIT SUB

DrawLight:
' Draws a spotlight at the given coordinates
MapEMS EMShdl, 4
addr& = (y * 320&) + x
FOR yy = 0 TO 30
  FOR xx = 0 TO 30
    IF x + xx > 1 AND x + xx < 318 THEN
      DEF SEG = EMSseg
      col = PEEK(addr& + xx) + SpotLight(xx, yy)
      IF col < 0 THEN col = 0
      IF col > 127 THEN col = 127
      BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), (x + xx), (y + yy), col
    END IF
  NEXT xx
  addr& = addr& + 320
NEXT yy
RETURN

END SUB

SUB Menu
' Handles all the game menu system
DIM aControl(3), AvailableControls
' Restores the screen
Fade 0
OPEN "RESOURCE.BIN" FOR BINARY AS #2: GET #2, 4034, pal: CLOSE #2
DEF SEG = &HA000: BLOAD "TITLE.BIN", 0
' Turns on the keyboard interrupt handler
IF keyboardonflag% = FALSE THEN
  keyboardonflag% = TRUE
  DEF SEG = VARSEG(kbcontrol(0))
  CALL ABSOLUTE(0)
  DEF SEG
END IF
' The main game loop begins here
DO
  ' Loads the title screen into EMS
  MapEMS EMShdl, 4
  DEF SEG = VARSEG(Buffer(0)): BLOAD "TITLE.BIN", VARPTR(Buffer(0))
  ' Gets data on the main menu options and prints them
  RESTORE MainMenu
  FOR i = 0 TO MAXMENU
    READ MenuText(i).Text, MenuText(i).y, MenuText(i).col
    MPrint RTRIM$(MenuText(i).Text), MenuText(i).y, MenuText(i).col, 252
  NEXT i
  ' Updates the screen
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
  BlastCopy EMSseg, 0, &HA000, 0
  Fade 1
  ' Allows the user to select an option
  Sel = SelectMenu(6)
  SELECT CASE Sel
  CASE 0, 1
    ' Starts a new game in one or two players mode
    Game.mode = NORMAL: Game.players = Sel: Game.area = 1: Game.level = 1
    PlayGame
    CheckForRecord
  CASE 2
    ' Allows the user to insert a password
    PassWord$ = GetText$("rr INSERT PASSWORD ss", 5)
    ' Checks if the password is valid in the current world datafile
    Found = -1
    FOR i = 0 TO 19
      s$ = SPACE$(4): GET #1, 58 + (i * 4), s$
      IF LEFT$(PassWord$, 4) = s$ THEN Found = i
    NEXT i
    IF LEFT$(PassWord$, 4) = SPACE$(4) THEN Found = -1
    IF RIGHT$(PassWord$, 1) <> "1" AND RIGHT$(PassWord$, 1) <> "2" THEN Found = -1
    IF Found = -1 THEN
      ' The given password is wrong!
      MPrint "INVALID PASSWORD!!", 180, 255, 252
      BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
      PlaySound 14
      FOR o = 0 TO 49: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT o
    ELSE
      ' Password is valid; starts the game from level one of the right area
      PlaySound 1
      Game.mode = NORMAL: Game.players = VAL(MID$(PassWord$, 5, 1)) - 1
      Game.area = Found + 1: Game.level = 1
      PlayGame
      CheckForRecord
    END IF
  CASE 3
    ' Allows the user to select a new world
    CLOSE #1: DataFile$ = SelectWorld$
    ' If no worlds are found, exits the program with error 1
    IF DataFile$ = "" THEN ERROR 1
    ' Opens the new world datafile and gets its number of areas
    OPEN DataFile$ FOR BINARY AS #1
    GET #1, 6, Game.numareas
  CASE 4
    ' The user selected the OPTIONS menu
    DO
      ' Reloads the title screen into the buffer
      DEF SEG = VARSEG(Buffer(0)): BLOAD "TITLE.BIN", VARPTR(Buffer(0))
      ' Gets data on the sub menu options
      RESTORE OptionsMenu
      FOR i = 0 TO MAXMENU
        READ MenuText(i).Text, MenuText(i).y, MenuText(i).col
      NEXT i
      ' Options 1 and 2 change according to the current control settings
      MenuText(1).Text = "PLAYER ONE: " + ControlName(Player(0).control)
      MenuText(2).Text = "PLAYER TWO: " + ControlName(Player(1).control)
      ' Prints the options on the buffer
      FOR i = 0 TO MAXMENU
        MPrint RTRIM$(MenuText(i).Text), MenuText(i).y, MenuText(i).col, 252
      NEXT i
      ' Updates the screen
      BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
      BlastCopy EMSseg, 0, &HA000, 0
      Fade 1
      ' Allows the user to select a new option
      Sel = SelectMenu(4)
      SELECT CASE Sel
      CASE 0, 1
        ' The user is changing control settings
        DEF SEG = VARSEG(Buffer(0)): BLOAD "TITLE.BIN", VARPTR(Buffer(0))
        MenuText(0).Text = "rr CHOOSE PLAYER" + STR$(Sel + 1) + " CONTROL ss"
        MenuText(0).y = 110: MenuText(0).col = 255
        numControls = 0: SelPlayer = Sel
        ' Checks for available control methods for selected player
        FOR i = 0 TO 3
          IF i < 2 THEN
            IF Player(ABS(NOT (-Sel))).control <> i THEN
              aControl(numControls) = i
              numControls = numControls + 1
            END IF
          ELSE
            IF Joy(i - 2).detected = TRUE THEN
              IF Player(ABS(NOT (-Sel))).control <> i THEN
                aControl(numControls) = i
                numControls = numControls + 1
              END IF
            END IF
          END IF
        NEXT i
        ' Once the available controls have been found, prints them
        FOR i = 0 TO MAXMENU - 1
          IF i < numControls THEN
            MenuText(i + 1).Text = ControlName(aControl(i))
            MenuText(i + 1).y = 130 + (i * 10): MenuText(i + 1).col = 254
          ELSE
            MenuText(i + 1).y = 0
          END IF
        NEXT i
        FOR i = 0 TO MAXMENU
          MPrint RTRIM$(MenuText(i).Text), MenuText(i).y, MenuText(i).col, 252
        NEXT i
        BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
        ' Allows to select the new control method
        Sel = SelectMenu(numControls - 1)
        IF Sel > -1 THEN Player(SelPlayer).control = aControl(Sel)
      CASE 2
        ' Customize keys
        FOR i = 0 TO 1: FOR ii = 0 TO 4: Keys(i, ii) = 0: NEXT ii, i
        FOR i = 0 TO 1
          ' Prompts the user for each key of each keyboard method
          RESTORE CustomizeKeys
          FOR ii = 0 TO 4
            ' Updates the screen with the new prompt
            DEF SEG = VARSEG(Buffer(0)): BLOAD "TITLE.BIN", VARPTR(Buffer(0))
            MPrint "rr CUSTOMIZE KEYS ss", 110, 255, 252
            READ s$: Found = FALSE
            MPrint ("PRESS " + CHR$(34) + s$ + CHR$(34) + " BUTTON FOR KEYBOARD" + STR$(i + 1)), 150, 254, 252
            BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
            BlastCopy &HA000, 0, EMSseg, 0
            FOR w = 0 TO 20: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT w
            DO
              Found = FALSE
              DO
                WAIT &H3DA, 8, 8: WAIT &H3DA, 8
                ' Checks if a key is pressed
                FOR k = 1 TO 127
                  IF k <> 42 AND kbmatrix(k) THEN Found = TRUE: EXIT FOR
                NEXT k
                IF alert > 0 THEN
                  ' if enough time has passed updates the screen
                  alert = alert - 1: IF alert = 0 THEN BlastCopy EMSseg, 0, &HA000, 0
                END IF
              LOOP WHILE NOT Found
              IF k = 1 OR k = 25 OR k = 88 OR k = 59 THEN
                ' The key is already used by the game
                PlaySound 14
                MPrint "KEY ALREADY USED!", 180, 255, 252
                BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
                alert = 50: Found = FALSE
              ELSE
                FOR t = 0 TO 1
                  FOR tt = 0 TO 4
                    IF k = Keys(t, tt) THEN
                      ' The key has been already selected for another task
                      PlaySound 14
                      MPrint "KEY ALREADY USED!", 180, 255, 252
                      BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
                      alert = 50: Found = FALSE
                    END IF
                  NEXT tt
                NEXT t
              END IF
            LOOP WHILE NOT Found
            ' The key was ok, so store it
            Keys(i, ii) = k
            PlaySound 1
          NEXT ii
        NEXT i
      CASE 3
        ' Changes the music/sound effects volume
        DEF SEG = VARSEG(Buffer(0)): BLOAD "TITLE.BIN", VARPTR(Buffer(0))
        MPrint ("rr MUSIC/FX VOLUME ss"), 110, 255, 252
        MPrint "PRESS l AND m TO CHANGE VOLUME", 130, 254, 252
        MPrint "<ENTER> TO CONTINUE", 140, 254, 252
        BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
        FOR i = 0 TO 20: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT i
        DO
          ' Gets user input
          IF kbmatrix(77) AND Volume < 15 THEN Volume = Volume + 1: SetVolume: PlaySound 0
          IF kbmatrix(75) AND Volume > 0 THEN Volume = Volume - 1: SetVolume: PlaySound 0
          IF kbmatrix(28) THEN EXIT DO
          ' Updates the screen
          BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
          MPrint ("OFF          MAX"), 160, 254, 252
          BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 129, 164, 189, 164, 253
          FOR i = 0 TO 4
            BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 129, (162 + i), (129 + (Volume * 4)), (162 + i), 255
          NEXT i
          FOR i = 0 TO 3: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT i
          BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
        LOOP
        PlaySound 1
      CASE 4: EXIT DO
      END SELECT
    LOOP
  CASE 5
    ' Shows the credits scroller
    ShowCredits
  CASE 6
    ' The user selected the quit option
    DEF SEG = VARSEG(Buffer(0)): BLOAD "TITLE.BIN", VARPTR(Buffer(0))
    ' Gets data on the sub menu options
    RESTORE QuitMenu
    FOR i = 0 TO MAXMENU
      READ MenuText(i).Text, MenuText(i).y, MenuText(i).col
    NEXT i
    ' Randomly chooses a quit option text
    RANDOMIZE TIMER
    SELECT CASE INT(RND(1) * 6)
    CASE 0: MenuText(1).Text = "LET ME QUIT NOW!"
    CASE 1: MenuText(1).Text = "LOOSERS CAN QUIT..."
    CASE 2: MenuText(1).Text = "THAT'S ENOUGH FOR NOW"
    CASE 3: MenuText(1).Text = "I'LL TRY THE NEXT TIME..."
    CASE 4: MenuText(1).Text = "FLEE AWAY"
    CASE 5: MenuText(1).Text = "ARRGGGHHHH!!!"
    END SELECT
    ' Updates the screen
    FOR i = 0 TO MAXMENU
      MPrint RTRIM$(MenuText(i).Text), MenuText(i).y, MenuText(i).col, 252
    NEXT i
    BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
    ' If the user quits, exit the main game loop
    IF SelectMenu(1) = 0 THEN EXIT DO
  END SELECT
LOOP
Fade 0
' Turns off the keyboard interrupt handler
IF keyboardonflag% = TRUE THEN
  keyboardonflag% = FALSE
  DEF SEG = VARSEG(kbcontrol(0))
  CALL ABSOLUTE(3)
  DEF SEG
END IF
' Writes current game configuration
OPEN "WETSPOT2.CFG" FOR BINARY AS #2
PUT #2, , BasePort%: PUT #2, , Channel%: PUT #2, , Volume
PUT #2, , Game.soundon: PUT #2, , Game.musicon
FOR i = 0 TO 1: PUT #2, , Player(i).control: NEXT i
FOR i = 0 TO 1: FOR ii = 0 TO 4: PUT #2, , Keys(i, ii): NEXT ii, i
FOR i = 0 TO 1: PUT #2, , Joy(i).res: NEXT i: CLOSE #2

END SUB

FUNCTION ReadDSP%
' Reads a byte from the DSP
DO
LOOP UNTIL INP(BasePort% + 14) AND &H80
ReadDSP% = INP(BasePort% + 10)
END FUNCTION

SUB ReadJoy (j)
' Read the status of a given joystick
OUT &H201, &HFF
c = INP(&H201)
b1 = NOT ((c AND Mask(j, 0)) <> 0)
b2 = NOT ((c AND Mask(j, 1)) <> 0)
Joy(j).but = b1 OR b2: k = 0
OUT &H201, &HFF
DO
  c = INP(&H201)
  IF (c AND Mask(j, 3)) <> 0 THEN Joy(j).x = k
  IF (c AND Mask(j, 4)) <> 0 THEN Joy(j).y = k
  k = k + 1
LOOP WHILE (c AND Mask(j, 2)) <> 0 AND k < 256
Joy(j).x = Joy(j).x - Joy(j).xc
Joy(j).y = Joy(j).y - Joy(j).yc

END SUB

FUNCTION ResetDSP%
' Resets the DSP
ct = 0: stat = 0: ready = &HAA
OUT BasePort% + &H6, 1
DO
  OUT BasePort% + &H6, 0
  stat = INP(BasePort% + &HE)
  stat = INP(BasePort% + &HA)
  IF stat = ready THEN EXIT DO
  ct = ct + 1
LOOP WHILE ct < 100 'wait about 100 ms
IF stat = ready THEN ResetDSP% = 1 ELSE ResetDSP% = 0

END FUNCTION

SUB ShowCredits
' Displays the credits scroller
DIM Credit(9) AS STRING * 32, yc(9), Lines, Done
Lines = 62: Done = FALSE
' Updates the screen
DEF SEG = VARSEG(Buffer(0)): BLOAD "TITLE.BIN", VARPTR(Buffer(0))
MapEMS EMShdl, 4
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
' Initializes credit messages
FOR c = 0 TO 9: Credit(c) = "": yc(c) = 96 + (c * 10): NEXT c
BlastCopy EMSseg, 0, &HA000, 0
' Animates the red lines
FOR c = 0 TO 4
  FOR cc = 0 TO 2: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT cc
  BlastLine &HA000, 0, (169 + (c * 10)), 103, (150 - (c * 10)), 103, (251 + c)
  BlastLine &HA000, 0, (169 + (c * 10)), 196, (150 - (c * 10)), 196, (251 + c)
NEXT c
RESTORE Credits
FOR c = 0 TO Lines - 1
  DO
    t! = TIMER
    ' Scrolls the text up
    FOR cc = 0 TO 9: yc(cc) = yc(cc) - 1: NEXT cc
    ' Clears the background and prints the scrolled text to the buffer
    BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
    FOR cc = 0 TO 9
      MPrint RTRIM$(Credit(cc)), yc(cc), 255, 255
    NEXT cc
    ' Also prints the red lines
    BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 110, 103, 209, 103, 255
    BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 110, 196, 209, 196, 255
    DO: LOOP WHILE TIMER < t! + .1
    WAIT &H3DA, 8, 8: WAIT &H3DA, 8
    ' Updates the screen
    BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
    ' If the upper line of text goes out of the red line, exits the loop
    IF yc(0) = 95 THEN EXIT DO
    IF kbmatrix(1) OR kbmatrix(28) THEN EXIT DO
  LOOP
  IF kbmatrix(1) OR kbmatrix(28) THEN EXIT FOR
  ' Shifts the credits text and reads a new line
  FOR cc = 0 TO 8: Credit(cc) = Credit(cc + 1): yc(cc) = yc(cc + 1): NEXT cc
  READ Credit(9): yc(9) = 195
  IF c = 1 THEN MID$(Credit(9), 9, 3) = VERSION$
NEXT c

END SUB

SUB ShowTop10 (Blink1, Blink2)
' Displays the current world top 10
DIM FireWork(MAXFIREWORKS) AS FireWorkType, fx!(49), fy!(49)
DIM Record(9) AS RecordType
Fade 0
' Gets the game palette
OPEN "RESOURCE.BIN" FOR BINARY AS #2
GET #2, 637, pal: CLOSE #2
' Opens the records file
RecordFile$ = LEFT$(DataFile$, INSTR(DataFile$, ".") - 1) + ".REC"
OPEN RecordFile$ FOR BINARY AS #2
IF LOF(2) <> 240 THEN
  ' Bad record file or record file does not exist; creates a new one
  FOR i = 0 TO 9
    Record(i).nam = "NOBODY"
    Record(i).score = 10000
    Record(i).area = 1
    Record(i).level = 1
  NEXT i
  CLOSE #2: KILL RecordFile$
  OPEN RecordFile$ FOR BINARY AS #2
  FOR i = 0 TO 9: PUT #2, , Record(i): NEXT i
ELSE
  ' Gets the records
  FOR i = 0 TO 9: GET #2, , Record(i): NEXT i
END IF
CLOSE #2
' Draws the screen
MapEMS EMShdl, 4
CLS : BlastCopy &HA000, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
Title$ = SPACE$(30): GET #1, 8, Title$: Title$ = RTRIM$(Title$)
Title$ = CHR$(34) + Title$ + CHR$(34)
SPrint Title$, ((320 - (LEN(Title$) * 8)) \ 2), 2, 56
SPrint "TOP 10 BEST PLAYERS", 84, 10, 56
SPrint "NAME                SCORE  AREA", 36, 24, 22
FOR i = 0 TO 9
  ' Prints each record data
  s$ = Record(i).nam + SPACE$(9 - LEN(STR$(Record(i).score))) + STR$(Record(i).score) + " "
  IF Record(i).area > Game.numareas THEN
    s$ = s$ + "  END"
  ELSE
    IF Record(i).area < 10 THEN s$ = s$ + " "
    s$ = s$ + STR$(Record(i).area) + "-" + LTRIM$(STR$(Record(i).level))
  END IF
  SPrint s$, 36, (40 + (i * 16)), (152 - (i \ 2))
NEXT i
' Updates the screen
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
' Prepares SIN/COS table for more speed
FOR i = 0 TO 39
  fx!(i) = COS((6.28 / 40) * i)
  fy!(i) = SIN((6.28 / 40) * i)
NEXT i
' Initializes variables and begins loop
Fade 1
NumFW = 0: TimeLeft = 1500
DO
  TimeLeft = TimeLeft - 1: IF TimeLeft = 0 THEN EXIT DO
  RANDOMIZE TIMER
  IF INT(RND(1) * ((MAXFIREWORKS + 1) * 220)) < (70 - (NumFW * 10)) THEN
    IF NumFW < MAXFIREWORKS + 1 THEN
      ' Creates a new firework object
      NumFW = NumFW + 1
      FOR i = 0 TO MAXFIREWORKS
        IF FireWork(i).time = 0 THEN EXIT FOR
      NEXT i
      RANDOMIZE TIMER
      ' Initializes the firework with random variables
      FireWork(i).x = INT(RND(1) * 100) + 110
      FireWork(i).y = 230
      FireWork(i).ax = (RND(1) * 2) - 1
      FireWork(i).ay = -(RND(1) * 1) - 3
      FireWork(i).time = 140 + INT(RND(1) * 60)
      FireWork(i).col = 240 + i
      ' Chooses its color
      SELECT CASE INT(RND(1) * 6)
      CASE 0: PalSet (240 + i), 63, 0, 0
      CASE 1: PalSet (240 + i), 0, 63, 0
      CASE 2: PalSet (240 + i), 0, 0, 63
      CASE 3: PalSet (240 + i), 63, 63, 0
      CASE 4: PalSet (240 + i), 0, 63, 63
      CASE 5: PalSet (240 + i), 63, 0, 63
      END SELECT
    END IF
  END IF
  ' Updates the buffer
  BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  FOR i = 0 TO MAXFIREWORKS
    IF FireWork(i).time > 0 THEN
      ' Move firework
      FireWork(i).x = FireWork(i).x + FireWork(i).ax
      FireWork(i).y = FireWork(i).y + FireWork(i).ay
      FireWork(i).ay = FireWork(i).ay + .03
      FireWork(i).time = FireWork(i).time - 1
      IF FireWork(i).time > 32 THEN
        ' The firework is not exploded yet
        IF FireWork(i).x > 0 AND FireWork(i).x < 318 THEN
          IF FireWork(i).y > 0 AND FireWork(i).y < 198 THEN
            ' It's still on the screen, so we can draw it
            DEF SEG = VARSEG(Buffer(0))
            IF PEEK(VARPTR(Buffer(0)) + (INT(FireWork(i).y) * 320&) + INT(FireWork(i).x)) = 0 THEN
              ' Draws it only if it's not over the text
              BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), INT(FireWork(i).x), INT(FireWork(i).y), FireWork(i).col
              BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), INT(FireWork(i).x + 1), INT(FireWork(i).y), FireWork(i).col
              BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), INT(FireWork(i).x), INT(FireWork(i).y + 1), FireWork(i).col
              BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), INT(FireWork(i).x + 1), INT(FireWork(i).y + 1), FireWork(i).col
            END IF
          END IF
        END IF
      ELSE
        ' The firework is exploding; fades its color to black
        PalGet FireWork(i).col, r, g, b
        IF r > 0 THEN r = r - 1
        IF g > 0 THEN g = g - 1
        IF b > 0 THEN b = b - 1
        PalSet FireWork(i).col, r, g, b
        ' Makes four rings of pixels as the expanding explosion
        FOR ii = 0 TO 3
          ' Chooses expanding factor and the number of pixels for each ring
          SELECT CASE ii
          CASE 0: s = 5: F! = .5
          CASE 1: s = 2: F! = 1.2
          CASE 2: s = 1: F! = 1.7
          CASE 3: s = 1: F! = 2
          END SELECT
          FOR iii = 0 TO 39 STEP s
            ' Calculates the coordinates of each pixel
            x = INT(FireWork(i).x + (fx!(iii) * ((32 - FireWork(i).time) * F!)))
            y = INT(FireWork(i).y + (fy!(iii) * ((32 - FireWork(i).time) * F!)))
            IF x > 0 AND x < 319 THEN
              IF y > 0 AND y < 199 THEN
                ' The pixel is on the screen; draws it
                BlastPset VARSEG(Buffer(0)), VARPTR(Buffer(0)), x, y, FireWork(i).col
              END IF
            END IF
          NEXT iii
        NEXT ii
      END IF
      ' The firework exists no more
      IF FireWork(i).time = 0 THEN NumFW = NumFW - 1
    END IF
  NEXT i
  IF (TimeLeft \ 20) MOD 2 = 0 THEN
    ' If the players have made high scores, their crabs blink near their names
    MapEMS EMShdl, 0
    IF Blink1 <> -1 THEN PutShape 18, 18, (36 + (Blink1 * 16))
    IF Blink2 <> -1 THEN PutShape 38, 18, (36 + (Blink2 * 16))
    MapEMS EMShdl, 4
  END IF
  WAIT &H3DA, 8, 8: WAIT &H3DA, 8
  ' Updates the screen
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  IF kbmatrix(28) OR kbmatrix(1) THEN EXIT DO
LOOP
Fade 0
' Restores menu palette
OPEN "RESOURCE.BIN" FOR BINARY AS #2: GET #2, 4034, pal: CLOSE #2
CLS

END SUB

SUB TheEnd
' Shows the end of the game (the same for all worlds, sorry!)
DIM frame(8), aframe(8), x(6), DeadEnemy(15) AS DeadEnemyType, Credit$(19)
Fade 0
' Loads and plays the ending song
LoadMIDI "THEEND.MID", VARSEG(mBuffer(0)), VARPTR(mBuffer(0))
PlayMIDI VARSEG(mBuffer(0)), VARPTR(mBuffer(0))
' Clears screen and buffer
CLS
BlastCopy &HA000, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
MapEMS EMShdl, 0
' Draws a "tunnel" like structure with the last area tiles
FOR i = 0 TO 19
  FOR ii = 0 TO 2
    PutShape 237, (i * 16), (76 + (ii * 16))
    IF ii = 0 OR ii = 2 THEN
      PutShape 235, (i * 16), (76 + (ii * 16))
    ELSE
      PutShape 233, (i * 16), (76 + (ii * 16))
    END IF
  NEXT ii
NEXT i
' Copies the buffer on the screen
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
MapEMS EMShdl, 4
BlastCopy &HA000, 0, EMSseg, 0
' Displays it
Fade 1
FOR i = 0 TO 8: frame(i) = 0: aframe(i) = 1: NEXT i
' Makes the crabs and the enemies to walk throught this tunnel
' The crabs are faster than the enemies, that walk all with the same speed
FOR i = 0 TO 340
  ' Updates the background
  MapEMS EMShdl, 4
  BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  MapEMS EMShdl, 0
  FOR ii = 0 TO 8
    IF ii > 1 AND frame(ii) > 9 THEN
      ' The enemy has been hit by the block and it's flying away
      frame(ii) = frame(ii) + 12
      IF 102 - frame(ii) > -16 THEN PutShape (136 + (((frame(ii) \ 10) MOD 4) * 7) + aframe(ii)), x(ii - 2), (102 - frame(ii))
    ELSE
      ' Handles both players and enemies movements and frames
      SELECT CASE ii
      CASE 0, 1, 4, 6, 7, 8
        frame(ii) = frame(ii) + aframe(ii)
        IF frame(ii) = 0 OR frame(ii) = 5 THEN aframe(ii) = -aframe(ii)
      CASE 2, 5
        frame(ii) = frame(ii) + aframe(ii)
        IF frame(ii) = 0 OR frame(ii) = 8 THEN aframe(ii) = -aframe(ii)
      CASE 3
        frame(ii) = frame(ii) - 1: IF frame(ii) < 0 THEN frame(ii) = 7
      END SELECT
      ' Draws each sprite on the buffer
      SELECT CASE ii
      CASE 0, 1
        PutShape (4 + (ii * 20) + (frame(ii) \ 2)), (320 + (ii * 24) - (i * 2)), 92
      CASE 2
        PutShape (43 + (frame(ii) MOD 3)), (392 - i), (91 + (frame(ii) \ 3))
      CASE 3
        PutShape (60 + frame(ii)), (416 - i), 92
      CASE 4
        PutShape (68 + (frame(ii) \ 2)), (440 - i), 92
      CASE 5
        PutShape 83, (464 - i), (91 + (frame(ii) \ 3))
      CASE 6
        PutShape (95 + (frame(ii) \ 2)), (488 - i), 92
      CASE 7
        PutShape (111 + (frame(ii) \ 2)), (512 - i), 92
      CASE 8
        PutShape (123 + (frame(ii) \ 2)), (536 - i), 92
      END SELECT
    END IF
  NEXT ii
  IF i > 290 THEN
    ' If enough time has passed, a block starts moving from left to right
    PutShape 236, ((i - 291) * 16), 92
    FOR ii = 2 TO 8
      IF frame(ii) < 10 THEN
        IF ((i - 291) * 16) > ((392 + ((ii - 2) * 24)) - i) THEN
          ' The block has hit an enemy; it begins flying away
          frame(ii) = 10: aframe(ii) = ii - 2: x(ii - 2) = ((392 + ((ii - 2) * 24)) - i)
          PlaySound 11
        END IF
      END IF
    NEXT ii
  END IF
  ' Copies the buffer to the screen
  FOR iii = 0 TO 2: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT iii
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
NEXT i
' Makes the crabs come back to the center of the tunnel...
FOR i = -40 TO 140 STEP 2
  MapEMS EMShdl, 4
  BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  MapEMS EMShdl, 0
  frame(0) = frame(0) + aframe(0)
  IF frame(0) = 0 OR frame(0) = 5 THEN aframe(0) = -aframe(0)
  PutShape (12 + (frame(0) \ 2)), i, 92
  PutShape (32 + (frame(0) \ 2)), (i + 24), 92
  FOR ii = 0 TO 2: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT ii
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
NEXT i
' ...and do their victory gesture
PlaySound 13
FOR i = 0 TO 2
  MapEMS EMShdl, 4
  BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  MapEMS EMShdl, 0
  PutShape (16 + i), 140, 92
  PutShape (36 + i), 164, 92
  FOR ii = 0 TO 7: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT ii
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
NEXT i
FOR i = 0 TO 150: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT i
' Quickly fades all the palette to white
FOR i = 0 TO 63
  FOR ii = 0 TO 255
    PalGet ii, r, g, b
    r = r - (r < 63)
    g = g - (g < 63)
    b = b - (b < 63)
    PalSet ii, r, g, b
  NEXT ii
NEXT i
FOR i = 0 TO 100: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT i
' Initializes the falling enemies with random variables
FOR i = 0 TO 15
  RANDOMIZE TIMER
  DeadEnemy(i).typ = INT(RND(1) * 7)
  DeadEnemy(i).speed = (RND * 2) + 1
  DeadEnemy(i).x = INT(RND(1) * 336) - 16
  DeadEnemy(i).y = INT(RND(1) * 216) - 16
  DeadEnemy(i).frame = INT(RND(1) * 4)
NEXT i
' Loads the ending background image to the buffer
DEF SEG = VARSEG(Buffer(0)): BLOAD "THEEND.BIN", VARPTR(Buffer(0))
FOR i = 240 TO 255
  MID$(pal, (i * 3) + 1, 1) = CHR$(0)
  MID$(pal, (i * 3) + 2, 1) = CHR$((i - 239) * 2)
  MID$(pal, (i * 3) + 3, 1) = CHR$(0)
NEXT i
' Gets the world credits and prints them on the buffer
SEEK #1, 138
FOR i = 0 TO 19
  Credit$(i) = SPACE$(30): GET #1, , Credit$(i)
  Credit$(i) = RTRIM$(LTRIM$(Credit$(i)))
  SPrint Credit$(i), ((320 - (LEN(Credit$(i)) * 8)) \ 2), (20 + (i * 8)), 208
NEXT i
' Stores the buffer into EMS
MapEMS EMShdl, 4
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
count = 0
DO
  ' Updates the buffer
  MapEMS EMShdl, 4
  BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
  MapEMS EMShdl, 0
  ' Handles the falling enemies
  FOR i = 0 TO 15
    PutShape (136 + ((DeadEnemy(i).frame \ 2) * 7) + DeadEnemy(i).typ), DeadEnemy(i).x, INT(DeadEnemy(i).y)
    DeadEnemy(i).y = DeadEnemy(i).y + DeadEnemy(i).speed
    DeadEnemy(i).frame = (DeadEnemy(i).frame + 1) MOD 8
    IF DeadEnemy(i).y > 199 THEN
      RANDOMIZE TIMER
      DeadEnemy(i).typ = INT(RND(1) * 7)
      DeadEnemy(i).speed = (RND * 2) + 1
      DeadEnemy(i).x = INT(RND(1) * 336) - 16
      DeadEnemy(i).y = -16
      DeadEnemy(i).frame = INT(RND(1) * 4)
    END IF
  NEXT i
  WAIT &H3DA, 8, 8: WAIT &H3DA, 8
  IF count < 193 AND count MOD 3 = 0 THEN
    ' On the first cycles, slowly fades the white palette to its original
    ' hues while the enemies are falling
    FOR i = 0 TO 255
      PalGet i, r, g, b
      IF r > ASC(MID$(pal, (i * 3) + 1, 1)) THEN r = r - 1
      IF g > ASC(MID$(pal, (i * 3) + 2, 1)) THEN g = g - 1
      IF b > ASC(MID$(pal, (i * 3) + 3, 1)) THEN b = b - 1
      PalSet i, r, g, b
    NEXT i
  END IF
  count = count + 1
  ' This cycle ends only when a key is pressed or when a lot of time has
  ' passed
  IF count > 32000 THEN EXIT DO
  WAIT &H3DA, 8, 8: WAIT &H3DA, 8
  ' Updates the screen
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  IF kbmatrix(1) OR kbmatrix(28) THEN EXIT DO
LOOP
StopMIDI
Fade 0

END SUB

SUB WriteDSP (byte%)
' Writes a byte to the DSP
DO
LOOP WHILE INP(BasePort% + 12) AND &H80
OUT BasePort% + 12, byte%
END SUB

