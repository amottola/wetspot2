'
'                                WETSPOT II
'
'                       version 1.3 - June, 27th 1998
'                       by Enhanced Creations 1997-98
'
'                            - Primary module -
'
'              ATTENTION: THIS PROGRAM REQUIRES QuickBasic 4.5
'                     LOADED WITH THE /L OPTION TO RUN!
'
'                           Press <SHIFT-F5> now!
'
' See README.TXT for game requirements, instructions and other informations.
' If you want to compile this game (strongly recommended), remember to change
' the COMPILED constant from FALSE to TRUE on the WETSPOT2.BI include file.
' Comments, suggestions and bug reports are to be sent to:
'
'                              Angelo Mottola
'                          angelillo@geocities.com
'
' Also, visit my site, the QuickBasic Enhanced Programming Page, which has a
' lot of extra info, worlds and materials about this game! It's located at:
'
'             http://www.geocities.com/SiliconValley/Lakes/7303
'
' Have fun with WetSpot 2!!

DEFINT A-Z
'$DYNAMIC
'$INCLUDE: 'WETSPOT2.BI'

CLEAR , , 4096

ON ERROR GOTO ErrorHandler

DIM SHARED AsmCode(16) AS STRING, EnemyPal(2) AS STRING * 240
DIM SHARED Cel(19, 11) AS INTEGER, Shape(127) AS INTEGER
DIM SHARED Player(1) AS PlayerType, Enemy(MAXENEMIES) AS EnemyType
DIM SHARED Shot(MAXSHOTS) AS ShotType
DIM SHARED Block(MAXBLOCKS) AS BlockType, Object(MAXOBJS) AS ObjectType
DIM SHARED Death(1) AS DeathType
DIM SHARED dx(4) AS INTEGER, dy(4) AS INTEGER, Keys(1, 4) AS INTEGER
DIM SHARED Joy(1) AS Joystick, Mask(1, 4) AS INTEGER
DIM SHARED kbcontrol(128) AS INTEGER, kbmatrix(128) AS INTEGER
DIM SHARED MenuText(MAXMENU) AS MenuTextType, ControlName(3) AS STRING
DIM SHARED SoundLen(MAXSOUNDS) AS LONG
DIM SHARED Buffer(31999) AS INTEGER, mBuffer(15999) AS INTEGER

ON TIMER(1) GOSUB TimePass
TIMER OFF

result = InitGame
IF result <> 0 THEN
  DEF SEG : PRINT "error!": PRINT
  SELECT CASE result
  CASE 1: PRINT "A game data file is missing, program aborted. Please install again."
  CASE 2: PRINT "This program requires" + STR$((8 + ((MAXSOUNDS + 1) * 4)) * 16) + " Kbytes of free EMS memory to run!"
  CASE 3: PRINT "Game configuration not set, please run SETUP first."
  CASE 4: PRINT "Bad game settings, please run SETUP again.": KILL "WETSPOT2.CFG"
  CASE 5: PRINT "Unable to detect the SBMIDI driver; load it or disable musics in SETUP."
  CASE 6: PRINT "Int 80h is not being used by SBMIDI; free it or disable musics in SETUP."
  CASE 7: PRINT "Failed to reset sound card DSP, run SETUP again."
  END SELECT
  IF EMShdl <> 0 THEN
    DEF SEG = VARSEG(AsmCode(6))
    CALL ABSOLUTE(BYVAL EMShdl, SADD(AsmCode(6)))
    DEF SEG
  END IF
  END
END IF

Logo
Intro
Menu
CLOSE
EndingText
DEF SEG = VARSEG(AsmCode(6))
CALL ABSOLUTE(BYVAL EMShdl, SADD(AsmCode(6)))
DEF SEG
WHILE INKEY$ <> "": WEND
END

ErrorHandler:
SCREEN 0: WIDTH 80
IF keyboardonflag% = TRUE THEN
  keyboardonflag% = FALSE
  DEF SEG = VARSEG(kbcontrol(0))
  CALL ABSOLUTE(3)
  DEF SEG
END IF
SELECT CASE ERR
CASE 1, 52, 53: PRINT "A game data file is missing, program aborted. Please install again."
CASE 6, 7, 14: PRINT "Not enough memory to run WetSpot 2; see README.TXT for game requirements."
CASE IS > 53: PRINT "There was a general disk error while attempting to access a game file; see": PRINT "README.TXT for details."
CASE ELSE
  PRINT "ERROR: Unexpected program error code #" + LTRIM$(STR$(ERR)) + ", game aborted. Please inform me on how"
  PRINT "this error has occured; see also README.TXT for known bugs resolution."
END SELECT
IF EMShdl THEN
  DEF SEG = VARSEG(AsmCode(6))
  CALL ABSOLUTE(BYVAL EMShdl, SADD(AsmCode(6)))
  DEF SEG
END IF
StopMIDI
END

TimePass:
Game.framerate = Game.framecount
Game.framecount = 0
IF Game.status < 1 THEN
  Game.time = Game.time - 1
  IF Game.time < 0 THEN
    FOR h = 0 TO Game.players
      Death(h).speed = Death(h).speed + .02
    NEXT h
  END IF
  IF Game.time = 0 THEN
    IF Game.status <> -501 THEN
      PlaySound 5
      RANDOMIZE TIMER
      FOR h = 0 TO Game.players
        A! = RND(1) * 6.28
        Death(h).x = 160 + (COS(A!) * 200)
        Death(h).y = 100 + (SIN(A!) * 200)
        Death(h).frame = INT(RND(1) * 3)
        Death(h).speed = .5
      NEXT h
    ELSE
      DrawScreen
      SPrint "POTION BONUS", 112, 50, Game.textcol
      BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 110, 59, 208, 59, Game.textcol
      SPrint "NO BONUS!", 124, 83, Game.textcol
      BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), 110, 115, 208, 115, Game.textcol
      BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
      FOR h = 0 TO 400: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT h
      Game.status = 501
    END IF
  END IF
  IF Game.time = 15 THEN
    IF Game.status > -501 AND Game.status < 1 THEN
      TIMER OFF
      DrawScreen
      FOR o = 0 TO 2
        IF Game.soundon THEN
          MapEMS EMShdl, 24
          DMAplay EMSseg, 0, SoundLen(4), 11025&
        END IF
        Done = TRUE
        DO
          SPrint "HURRY UP!!", 120, 90, Game.textcol
          BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
          FOR oo = 0 TO 15
            WAIT &H3DA, 8, 8: WAIT &H3DA, 8
            IF Game.soundon AND DMAdone THEN EXIT DO
          NEXT oo
          DrawScreen
          FOR oo = 0 TO 15
            WAIT &H3DA, 8, 8: WAIT &H3DA, 8
            IF Game.soundon AND DMAdone THEN EXIT DO
          NEXT oo
          IF Game.soundon THEN
            Done = FALSE
            IF DMAdone% THEN Done = TRUE
          END IF
        LOOP WHILE Done = FALSE
      NEXT o
      IF Game.status > -1 THEN ChangePal 0
      TIMER ON
    END IF
  END IF
END IF
RETURN

REM $STATIC
SUB DrawScreen
' Updates Buffer and copy it to the screen
MapEMS EMShdl, 4
BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
MapEMS EMShdl, 0

' Draws the shots
FOR i = 0 TO MAXSHOTS
  IF Shot(i).typ > 0 THEN
    SELECT CASE Shot(i).typ
    CASE 1
      SELECT CASE Shot(i).time
      CASE 0 TO 1: F = 164
      CASE 2: F = 165
      CASE 3: F = 166
      CASE 4: F = 167
      CASE ELSE
        F = 168 + ((Shot(i).time \ 3) MOD 3)
      END SELECT
    CASE 2
      F = 176 + (Shot(i).time MOD 4)
    CASE 3
      F = 180 + (Shot(i).time MOD 4)
    CASE 4
      F = 173 + (Shot(i).time \ 2)
    CASE 5
      F = 184 + (Shot(i).time \ 2)
    END SELECT
    PutShape F, Shot(i).x, Shot(i).y
  END IF
NEXT i

' Objects
FOR i = 0 TO MAXOBJS
  IF Object(i).typ > 0 THEN
    SELECT CASE Object(i).typ
    CASE 1 TO 33
      PutShape (189 + Object(i).typ), (Object(i).x * 16), (Object(i).y * 16)
    CASE 97
      PutShape (223 + (Object(i).time \ 4)), (Object(i).x * 16), (Object(i).y * 16)
    CASE 98
      PutShape (187 + (Object(i).time \ 4)), (Object(i).x * 16), (Object(i).y * 16)
    CASE 99
      PutShape (230 + (Object(i).time \ 3)), (Object(i).x * 16), (Object(i).y * 16)
    CASE IS > 99
      IF Object(i).typ > 10000 THEN
        Points = Object(i).typ - 10000
        c = 44
      ELSE
        Points = Object(i).typ
        c = 12
      END IF
      IF Object(i).time < 7 THEN
        PutScore Points, (Object(i).x * 16), ((Object(i).y * 16) - Object(i).time), c
      ELSE
        PutScore Points, (Object(i).x * 16), ((Object(i).y * 16) - 6), c
      END IF
    END SELECT
  END IF
NEXT i

' Draws the lightnings over each enemy whenever the player has taken the bonus
IF Game.status = -2 THEN
  FOR i = 0 TO MAXENEMIES
    RANDOMIZE TIMER
    IF Enemy(i).typ > 0 THEN
      FOR ii = 0 TO 2
        Oldx = INT(RND(1) * 8)
        FOR iii = 0 TO (Enemy(i).y - 2) STEP 12 - (ii * 2)
          Newx = INT(RND(1) * 8)
          BlastLine VARSEG(Buffer(0)), VARPTR(Buffer(0)), (Enemy(i).x + 4 + Oldx), iii, (Enemy(i).x + 4 + Newx), (iii + (16 - (ii * 4))), (48 - (ii * 2))
          Oldx = Newx
        NEXT iii
      NEXT ii
    END IF
  NEXT i
END IF

' Draws enemies
FOR i = 0 TO MAXENEMIES
  IF Enemy(i).typ > 0 THEN
    SELECT CASE Enemy(i).typ
    CASE 1
      zd = 3
      F = 40 + (Enemy(i).dir * 3) + Enemy(i).frame
      IF Enemy(i).dir = 4 THEN F = 40 + Enemy(i).frame
    CASE 2
      zd = 1
      IF Enemy(i).dir = 0 OR Enemy(i).dir = 2 THEN F = 52 + Enemy(i).frame ELSE F = 60 + Enemy(i).frame
      IF Enemy(i).dir = 4 THEN F = 60
    CASE 3
      zd = 1
      F = 68 + (Enemy(i).dir * 3) + (Enemy(i).frame \ 3)
      IF Enemy(i).dir = 4 THEN F = 68 + (Enemy(i).frame \ 3)
    CASE 4
      zd = 4
      F = 80 + (Enemy(i).dir * 3)
      IF Enemy(i).action > 0 THEN F = 80 + (Enemy(i).dir * 3) + (Enemy(i).action \ 4)
      IF Enemy(i).dir = 4 THEN F = 80
    CASE 5
      zd = 1
      F = 92 + (Enemy(i).dir * 3) + (Enemy(i).frame \ 2)
      IF Enemy(i).action > 0 THEN F = 104 + (Enemy(i).dir)
      IF Enemy(i).dir = 4 THEN F = 92 + (Enemy(i).frame \ 2)
    CASE 6
      zd = 1
      F = 108 + (Enemy(i).dir * 3) + (Enemy(i).frame \ 2)
      IF Enemy(i).dir = 4 THEN F = 109
    CASE 7
      zd = 1
      F = 120 + (Enemy(i).dir * 3) + (Enemy(i).frame \ 2)
      IF Enemy(i).action > 0 THEN F = 132 + (Enemy(i).dir)
      IF Enemy(i).dir = 4 THEN F = 121
    END SELECT
    IF Game.status = -2 THEN
      PutShape F, Enemy(i).x, Enemy(i).y - INT(RND(1) * 2)
    ELSE
      PutShape F, Enemy(i).x, Enemy(i).y + (Enemy(i).z \ zd) - 1
    END IF
  ELSEIF Enemy(i).typ < 0 THEN
    F = 135 + ABS(Enemy(i).typ) + ((Enemy(i).frame \ ((2 + (Enemy(i).action = FALSE)))) * 7)
    PutShape F, Enemy(i).x, Enemy(i).y
  END IF
NEXT i

' Draws moving blocks only
FOR i = 0 TO MAXBLOCKS
  IF Block(i).x > -1 THEN
    PutShape 236, (Block(i).x * 16), (Block(i).y * 16)
    GetBlockInfo Cel(Block(i).x, Block(i).y + 1)
    IF st = 0 THEN PutShape 234, (Block(i).x * 16), ((Block(i).y * 16) + 16)
  END IF
NEXT i

' And finally draws the players
FOR i = 0 TO Game.players
  IF Player(i).dead = FALSE OR Player(i).dead = 2 THEN
    SELECT CASE Player(i).action
    CASE 0, 1
      F = (i * 20) + (Player(i).dir * 4) + (Player(i).frame \ 2)
    CASE 3, 11
      F = (i * 20) + (Player(i).dir * 4) + 1
    CASE ELSE
      F = (i * 20) + (Player(i).dir * 4) + 3
    END SELECT
    IF Player(i).status <> 0 THEN
      SELECT CASE Player(i).status
      CASE IS < 0
        IF (ABS(Player(i).status) \ 3) MOD 2 = 0 THEN PutShape F, Player(i).x, Player(i).y
      CASE 1 TO 189
        F = 172 - i
        PutShape F, Player(i).x, Player(i).y + ((Player(i).status \ 8) MOD 2) - 1
      CASE 190 TO 195
        PutShape ((i * 20) + 18), Player(i).x, Player(i).y
      CASE 196 TO 197
        PutShape ((i * 20) + 17), Player(i).x, Player(i).y
      CASE 198 TO 199
        PutShape ((i * 20) + 16), Player(i).x, Player(i).y
      CASE 201
        PutShape ((i * 20) + 19), Player(i).x, Player(i).y
      END SELECT
    ELSE
      IF Game.status < 501 THEN
        PutShape F, Player(i).x, Player(i).y
      ELSE
        PutShape ((i * 20) + 16 + ((Game.status - 500) \ 8)), Player(i).x, Player(i).y
      END IF
    END IF
  END IF
NEXT i

' If the time has passed, draws the flame-thingies
IF Game.time < 1 THEN
  IF Game.status > -501 AND Game.status < 1 THEN
    FOR i = 0 TO Game.players
      IF Player(i).dead = FALSE THEN PutShape (226 + Death(i).frame), INT(Death(i).x), INT(Death(i).y)
    NEXT i
  END IF
END IF

' Prints the players stuff on the bottom of the screen
IF Game.mode = DEMO THEN
  SPrint "rr DEMO MODE ss", 100, 192, 56
ELSE
  IF Game.status = -501 THEN
    SPrint ("COLLECT ALL ITEMS! - TIME:" + STR$(Game.time)), 28, 192, 56
  ELSE
    FOR i = 0 TO Game.players
      IF Player(i).lives > 9 THEN
        s$ = "e9"
      ELSEIF Player(i).lives > -1 THEN
        s$ = "e" + LTRIM$(STR$(Player(i).lives))
      ELSE
        s$ = "e-"
      END IF
      s$ = s$ + " "
      IF LEN(LTRIM$(STR$(Player(i).score))) = 1 THEN
        s$ = s$ + "     00 "
      ELSE
        IF Player(i).score > 9999999 THEN
          Player(i).score = 9999999: s1$ = "9999999"
        ELSE
          s1$ = LTRIM$(STR$(Player(i).score))
          IF LEN(s1$) < 7 THEN s1$ = SPACE$(7 - LEN(s1$)) + s1$
        END IF
        s$ = s$ + s1$ + " "
      END IF
      s$ = s$ + Player(i).bonus
      SPrint s$, (i * 192), 192, ((i * 32) + 8)
    NEXT i
    s$ = "fg " + LTRIM$(STR$(Game.area)) + "-" + LTRIM$(STR$(Game.level)) + " "
    SPrint s$, ((320 - (LEN(s$) * 8) + 8) \ 2), 192, 56
  END IF
END IF

' if the F1 key is being hold down, shows the framerate
IF kbmatrix(59) THEN SPrint LTRIM$(STR$(Game.framerate)), 4, 4, Game.textcol

' The buffer is ready to be copied to the screen...
WAIT &H3DA, 8, 8: WAIT &H3DA, 8
BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0

END SUB

SUB MoveBlocks
' Check if a block is in motion and moves it.
FOR i = 0 TO MAXBLOCKS
  ' The block is moving
  IF Block(i).x > -1 THEN
    ' Finds the content of the cell the block is moving onto
    GetBlockInfo Cel(Block(i).x + Block(i).ax, Block(i).y + Block(i).ay)
    nst = st: nnd = nd: nrd = rd
    ' Checks if the block strikes an enemy
    FOR E = 0 TO 1
      FOR ii = 0 TO MAXENEMIES
        IF Enemy(ii).typ > 0 THEN
          IF Enemy(ii).typ = 3 THEN range = 18 ELSE range = 16
          IF E = 1 THEN range = 15
          IF ((Block(i).x + (Block(i).ax * E)) * 16) > Enemy(ii).x + dx(Enemy(ii).dir) - range AND ((Block(i).x + (Block(i).ax * E)) * 16) < Enemy(ii).x + dx(Enemy(ii).dir) + range THEN
            IF ((Block(i).y + (Block(i).ay * E)) * 16) > Enemy(ii).y + dy(Enemy(ii).dir) - range AND ((Block(i).y + (Block(i).ay * E)) * 16) < Enemy(ii).y + dy(Enemy(ii).dir) + range THEN
              ' An enemy is gone!
              IF Game.mode = NORMAL THEN Player(Block(i).by).score = Player(Block(i).by).score + Block(i).hitscore
              CheckScore Block(i).by
              FOR iii = 0 TO MAXOBJS
                IF Object(iii).typ = 0 THEN EXIT FOR
              NEXT iii
              ' Creates a score object and erases the enemy
              Object(iii).typ = Block(i).hitscore + (Block(i).by * 10000)
              Object(iii).time = 0
              Object(iii).x = Block(i).x
              Object(iii).y = Block(i).y
              KillEnemy ii
              Block(i).hitscore = Block(i).hitscore * 2
              IF Block(i).hitscore > 6400 THEN Block(i).hitscore = 6400
            END IF
          END IF
        END IF
      NEXT ii
      ' Erases each shot that hits the block
      FOR ii = 0 TO MAXSHOTS
        IF Shot(ii).typ > 0 THEN
          IF Shot(ii).typ < 4 THEN
            IF ((Block(i).x + (Block(i).ax * E)) * 16) > Shot(ii).x - 12 AND ((Block(i).x + (Block(i).ax * E)) * 16) < Shot(ii).x + 12 THEN
              IF ((Block(i).y + (Block(i).ay * E)) * 16) > Shot(ii).y - 12 AND ((Block(i).y + (Block(i).ay * E)) * 16) < Shot(ii).y + 12 THEN
                SELECT CASE Shot(ii).typ
                CASE 1: Shot(ii).typ = 4: Shot(ii).time = 0
                CASE 2: Shot(ii).typ = 0
                CASE 3: Shot(ii).typ = 5: Shot(ii).time = 0: PlaySound 12
                END SELECT
              END IF
            END IF
          END IF
        END IF
      NEXT ii
      ' Finds if a player is being hit by the block
      Collision = Collide((Block(i).x + (Block(i).ax * E)) * 16, (Block(i).y + (Block(i).ay * E)) * 16)
      IF Collision <> -1 THEN
        ' The player is hit and dies
        Player(Collision).status = 201: Player(Collision).dir = -8
        Player(Collision).speed = 2: Player(Collision).dead = TRUE
        IF Game.mode <> HIDDEN THEN Player(Collision).lives = Player(Collision).lives - 1
        IF Player(Collision).lives = -1 THEN Player(Collision).levelreached = ((Game.area - 1) * 5) + Game.level
        PlaySound 16
      END IF
    NEXT E
    IF st = 0 THEN
      ' The cell the block is moving onto is empty; the block can move
      GetBlockInfo Cel(Block(i).x, Block(i).y)
      Cel(Block(i).x, Block(i).y) = nd * 100
      Block(i).x = Block(i).x + Block(i).ax
      Block(i).y = Block(i).y + Block(i).ay
      Cel(Block(i).x, Block(i).y) = 2000 + (nnd * 100) + Block(i).bonus
    ELSE
      ' The block can't move; it stops its run.
      MapEMS EMShdl, 4
      BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
      MapEMS EMShdl, 0
      PutShape 236, (Block(i).x * 16), (Block(i).y * 16)
      GetBlockInfo Cel(Block(i).x, Block(i).y + 1)
      IF st = 0 THEN PutShape 234, (Block(i).x * 16), ((Block(i).y * 16) + 16)
      MapEMS EMShdl, 4
      BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
      MapEMS EMShdl, 0
      ' If the block stops over an object, the object is erased
      FOR ii = 0 TO MAXOBJS
        IF Object(ii).typ > 0 THEN
          IF Object(ii).x = Block(i).x AND Object(ii).y = Block(i).y THEN Object(ii).typ = 0
        END IF
      NEXT ii
      ' The current block is deleted from the moving block queue
      Block(i).x = -1
    END IF
  END IF
NEXT i

END SUB

SUB MoveDeath
' Moves the unbeatable enemies and checks for them to hit players
IF Game.time > 0 THEN EXIT SUB
IF Game.status < -500 OR Game.status > 0 THEN EXIT SUB
FOR i = 0 TO Game.players
  ' Moves the flame
  IF Player(i).x < Death(i).x THEN Death(i).x = Death(i).x - Death(i).speed
  IF Player(i).x > Death(i).x THEN Death(i).x = Death(i).x + Death(i).speed
  IF Player(i).y < Death(i).y THEN Death(i).y = Death(i).y - Death(i).speed
  IF Player(i).y > Death(i).y THEN Death(i).y = Death(i).y + Death(i).speed
  Death(i).frame = ((Death(i).frame + 1) MOD 4)
  ' Checks if it hits the player
  IF Player(i).dead = FALSE THEN
    IF Death(i).x > Player(i).x - 12 AND Death(i).x < Player(i).x + 12 THEN
      IF Death(i).y > Player(i).y - 12 AND Death(i).y < Player(i).y + 12 THEN
        ' Kills the player
        Player(i).status = 201: Player(i).dir = -8: Player(i).speed = 2
        Player(i).dead = TRUE: Player(i).lives = Player(i).lives - 1
        IF Player(i).lives = -1 THEN Player(i).levelreached = ((Game.area - 1) * 5) + Game.level
        PlaySound 16
      END IF
    END IF
  END IF
NEXT i

END SUB

SUB MoveEnemies
' Process a sort of AI to move monsters on the level.
DIM AI, pd(3), wayback
IF Blocked = TRUE THEN EXIT SUB
FOR i = 0 TO MAXENEMIES
  RANDOMIZE TIMER
  ' Are the monsters to be changed to a different type?
  IF Enemy(i).change > 0 AND Game.status > -3 THEN
    IF Enemy(i).x MOD 16 = 0 AND Enemy(i).y MOD 16 = 0 THEN
      Enemy(i).typ = Enemy(i).change: Enemy(i).change = 0
      ' Reinitialize the enemy variables according to its new type
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
      Enemy(i).ox = Enemy(i).x \ 16
      Enemy(i).oy = Enemy(i).y \ 16
      Enemy(i).dir = 4
      Enemy(i).frame = 0
      Enemy(i).aframe = 1
      Enemy(i).action = 0
      FOR ii = 0 TO MAXOBJS
        IF Object(ii).typ = 0 THEN EXIT FOR
      NEXT ii
      Object(ii).typ = 97
      Object(ii).time = 0
      Object(ii).x = Enemy(i).x \ 16
      Object(ii).y = Enemy(i).y \ 16
    END IF
  END IF
  IF Enemy(i).typ > 0 AND Game.status > -3 THEN
    ' Changes enemy's direction
    IF Enemy(i).x MOD 16 = 0 AND Enemy(i).y MOD 16 = 0 THEN
      OldDir = Enemy(i).dir
      IF Enemy(i).dir = 4 THEN Enemy(i).dir = INT(RND(1) * 4)
      ' Process shark enemy
      IF Enemy(i).typ = 3 THEN
        xc = Enemy(i).x \ 16: yc = Enemy(i).y \ 16
        FOR ii = 0 TO 3
          SELECT CASE Enemy(i).dir
          CASE 0
            IF Cel(xc - 1, yc) > 999 THEN Enemy(i).ox = 2
            IF Cel(xc, yc + 1) > 999 THEN Enemy(i).oy = -2
            IF Cel(xc - 1, yc + 1) > 999 AND Cel(xc - 1, yc) < 1000 AND Cel(xc, yc + 1) < 1000 THEN Enemy(i).ox = 2: Enemy(i).oy = -2
          CASE 1
            IF Cel(xc - 1, yc) > 999 THEN Enemy(i).ox = 2
            IF Cel(xc, yc - 1) > 999 THEN Enemy(i).oy = 2
            IF Cel(xc - 1, yc - 1) > 999 AND Cel(xc - 1, yc) < 1000 AND Cel(xc, yc - 1) < 1000 THEN Enemy(i).ox = 2: Enemy(i).oy = 2
          CASE 2
            IF Cel(xc + 1, yc) > 999 THEN Enemy(i).ox = -2
            IF Cel(xc, yc - 1) > 999 THEN Enemy(i).oy = 2
            IF Cel(xc + 1, yc - 1) > 999 AND Cel(xc + 1, yc) < 1000 AND Cel(xc, yc - 1) < 1000 THEN Enemy(i).ox = -2: Enemy(i).oy = 2
          CASE 3
            IF Cel(xc + 1, yc) > 999 THEN Enemy(i).ox = -2
            IF Cel(xc, yc + 1) > 999 THEN Enemy(i).oy = -2
            IF Cel(xc + 1, yc + 1) > 999 AND Cel(xc + 1, yc) < 1000 AND Cel(xc, yc + 1) < 1000 THEN Enemy(i).ox = -2: Enemy(i).oy = -2
          END SELECT
          IF Enemy(i).ox < 0 AND Enemy(i).oy > 0 THEN Enemy(i).dir = 0
          IF Enemy(i).ox < 0 AND Enemy(i).oy < 0 THEN Enemy(i).dir = 1
          IF Enemy(i).ox > 0 AND Enemy(i).oy < 0 THEN Enemy(i).dir = 2
          IF Enemy(i).ox > 0 AND Enemy(i).oy > 0 THEN Enemy(i).dir = 3
        NEXT ii
        IF Cel(xc - 1, yc) > 999 AND Cel(xc, yc - 1) > 999 AND Cel(xc + 1, yc) > 999 AND Cel(xc, yc + 1) > 999 THEN
          Enemy(i).dir = 4
        END IF
        IF Cel(xc - 1, yc - 1) > 999 AND Cel(xc + 1, yc - 1) > 999 AND Cel(xc + 1, yc + 1) > 999 AND Cel(xc - 1, yc + 1) > 999 THEN
          Enemy(i).dir = 4
        END IF
      ' Process other enemies when it's time to change direction
      ELSE
        ' Each enemy has its AI factor
        SELECT CASE Enemy(i).typ
        CASE 1: IF Enemy(i).action > 0 THEN AI = 9 ELSE AI = 4
        CASE 2: AI = 2
        CASE 4: AI = 5
        CASE 5: AI = 5
        CASE 6: AI = 6
        CASE 7: AI = 6
        END SELECT
        IF Game.time < 15 AND AI < 5 THEN AI = 5
        wayback = 4
        ' Finds the status of each block surrounding the enemy
        FOR ii = 0 TO 3
          GetBlockInfo Cel((Enemy(i).x \ 16) + dx(ii), (Enemy(i).y \ 16) + dy(ii))
          IF st = 0 THEN
            pd(ii) = 1
            IF Enemy(i).ox = (Enemy(i).x \ 16) + dx(ii) AND Enemy(i).oy = (Enemy(i).y \ 16) + dy(ii) THEN pd(ii) = 2: wayback = ii
          ELSE
            pd(ii) = 0
          END IF
        NEXT ii
        ' Try to choose a way
        Found = -1
        FOR ii = 0 TO 15
          RANDOMIZE TIMER
          d = INT(RND(1) * 4)
          IF pd(d) = 1 THEN Found = d: EXIT FOR
        NEXT ii
        ' Way found!
        IF Found > -1 THEN
          Enemy(i).dir = d
          ' If the enemy is enough smart, it seeks the player
          IF (INT(RND(1) * 10) + 1) < AI THEN
            p = FindTarget(Enemy(i).x \ 16, Enemy(i).y \ 16): ok = FALSE
            IF Player(p).y > Enemy(i).y AND pd(0) > 0 THEN Enemy(i).dir = 0: ok = TRUE
            IF NOT ok AND Player(p).x < Enemy(i).x AND pd(1) > 0 THEN Enemy(i).dir = 1: ok = TRUE
            IF NOT ok AND Player(p).y < Enemy(i).y AND pd(2) > 0 THEN Enemy(i).dir = 2: ok = TRUE
            IF NOT ok AND Player(p).x > Enemy(i).x AND pd(3) > 0 THEN Enemy(i).dir = 3: ok = TRUE
            IF NOT ok AND Player(p).y > Enemy(i).y AND pd(0) > 0 THEN Enemy(i).dir = 0: ok = TRUE
            IF NOT ok AND Player(p).x < Enemy(i).x AND pd(1) > 0 THEN Enemy(i).dir = 1
          END IF
        ELSE
          ' No way; the enemy tries to come back on its steps
          Enemy(i).dir = wayback: Enemy(i).action = 0
        END IF
        ' The enemy can't move in any direction!
        IF pd(0) = 0 AND pd(1) = 0 AND pd(2) = 0 AND pd(3) = 0 THEN Enemy(i).dir = 4: Enemy(i).action = 0
      END IF
      ' Special tasks
      IF Enemy(i).dir <> 4 THEN
        SELECT CASE Enemy(i).typ
        CASE 1
          IF Enemy(i).action > 0 THEN
            Enemy(i).action = Enemy(i).action - 1
          ELSE
            IF InFrontOf(i, FindTarget(Enemy(i).x \ 16, Enemy(i).y \ 16)) = TRUE THEN Enemy(i).action = INT(RND(1) * 10) + 5
          END IF
        CASE 2
          IF Enemy(i).dir = 0 OR Enemy(i).dir = 3 THEN Enemy(i).aframe = 1 ELSE Enemy(i).aframe = -1
        CASE 4, 5, 7
          IF Enemy(i).action > 0 THEN
            Enemy(i).dir = OldDir
            Enemy(i).action = Enemy(i).action - 1
            IF Enemy(i).action = 0 THEN
              FOR ii = 0 TO MAXSHOTS
                IF Shot(ii).typ = 0 THEN EXIT FOR
              NEXT ii
              SELECT CASE Enemy(i).typ
              CASE 4: Shot(ii).typ = 1: s = 8
              CASE 5: Shot(ii).typ = 2: s = 4
              CASE 7: Shot(ii).typ = 3: s = 4
              END SELECT
              Shot(ii).x = Enemy(i).x + (dx(Enemy(i).dir) * s)
              Shot(ii).y = Enemy(i).y + (dy(Enemy(i).dir) * s)
              Shot(ii).ax = dx(Enemy(i).dir) * s
              Shot(ii).ay = dy(Enemy(i).dir) * s
              Shot(ii).time = 0
            END IF
          ELSE
            IF InFrontOf(i, FindTarget(Enemy(i).x \ 16, Enemy(i).y \ 16)) = TRUE THEN
              SELECT CASE Enemy(i).typ
              CASE 4: FQ = 4
              CASE 5: FQ = 5
              CASE 7: FQ = 3
              END SELECT
              IF INT(RND(1) * FQ) < 2 THEN
                Enemy(i).action = 9
              END IF
            END IF
          END IF
        END SELECT
      END IF
      IF Enemy(i).typ <> 3 THEN
        Enemy(i).ox = (Enemy(i).x \ 16)
        Enemy(i).oy = (Enemy(i).y \ 16)
      END IF
    END IF
    ' Moves the enemy
    SELECT CASE Enemy(i).typ
    CASE 1
      ' Bee
      IF Enemy(i).dir <> 4 THEN
        IF Enemy(i).action > 0 THEN s = 2 ELSE s = 1
        Enemy(i).x = Enemy(i).x + (dx(Enemy(i).dir) * s)
        Enemy(i).y = Enemy(i).y + (dy(Enemy(i).dir) * s)
      END IF
      Enemy(i).frame = Enemy(i).frame + 1
      IF Enemy(i).frame = 3 THEN Enemy(i).frame = 0
      Enemy(i).z = Enemy(i).z + Enemy(i).az
      IF Enemy(i).z = 0 OR Enemy(i).z = 8 THEN Enemy(i).az = -Enemy(i).az
    CASE 2
      ' Worm
      IF Enemy(i).dir <> 4 THEN
        Enemy(i).x = Enemy(i).x + dx(Enemy(i).dir)
        Enemy(i).y = Enemy(i).y + dy(Enemy(i).dir)
        Enemy(i).frame = Enemy(i).frame + Enemy(i).aframe
        IF Enemy(i).aframe = 1 THEN
          IF Enemy(i).frame = 8 THEN Enemy(i).frame = 0
        ELSE
          IF Enemy(i).frame = -1 THEN Enemy(i).frame = 7
        END IF
      END IF
    CASE 3
      ' Shark
      IF Enemy(i).dir <> 4 THEN
        Enemy(i).x = Enemy(i).x + Enemy(i).ox
        Enemy(i).y = Enemy(i).y + Enemy(i).oy
      END IF
      Enemy(i).frame = Enemy(i).frame + Enemy(i).aframe
      IF Enemy(i).frame = 0 OR Enemy(i).frame = 8 THEN Enemy(i).aframe = -Enemy(i).aframe
    CASE 4
      ' Ghost
      IF Enemy(i).dir <> 4 THEN
        IF Enemy(i).action = 0 THEN
          Enemy(i).x = Enemy(i).x + dx(Enemy(i).dir)
          Enemy(i).y = Enemy(i).y + dy(Enemy(i).dir)
          Enemy(i).z = Enemy(i).z + Enemy(i).az
          IF Enemy(i).z = 0 OR Enemy(i).z = 11 THEN Enemy(i).az = -Enemy(i).az
        END IF
      ELSE
        Enemy(i).z = Enemy(i).z + Enemy(i).az
        IF Enemy(i).z = 0 OR Enemy(i).z = 11 THEN Enemy(i).az = -Enemy(i).az
      END IF
    CASE 5
      ' Putty
      IF Enemy(i).dir <> 4 THEN
        IF Enemy(i).action = 0 THEN
          Enemy(i).x = Enemy(i).x + (dx(Enemy(i).dir) * 2)
          Enemy(i).y = Enemy(i).y + (dy(Enemy(i).dir) * 2)
          Enemy(i).frame = Enemy(i).frame + Enemy(i).aframe
          IF Enemy(i).frame = 0 OR Enemy(i).frame = 5 THEN Enemy(i).aframe = -Enemy(i).aframe
        END IF
      ELSE
        Enemy(i).frame = Enemy(i).frame + Enemy(i).aframe
        IF Enemy(i).frame = 0 OR Enemy(i).frame = 5 THEN Enemy(i).aframe = -Enemy(i).aframe
      END IF
    CASE 6
      ' Mouse
      IF Enemy(i).dir <> 4 THEN
        Enemy(i).x = Enemy(i).x + (dx(Enemy(i).dir) * 2)
        Enemy(i).y = Enemy(i).y + (dy(Enemy(i).dir) * 2)
        Enemy(i).frame = Enemy(i).frame + Enemy(i).aframe
        IF Enemy(i).frame = 0 OR Enemy(i).frame = 5 THEN Enemy(i).aframe = -Enemy(i).aframe
      END IF
    CASE 7
      ' Penguin
      IF Enemy(i).dir <> 4 THEN
        IF Enemy(i).action = 0 THEN
          Enemy(i).x = Enemy(i).x + dx(Enemy(i).dir)
          Enemy(i).y = Enemy(i).y + dy(Enemy(i).dir)
          Enemy(i).frame = Enemy(i).frame + Enemy(i).aframe
          IF Enemy(i).frame = 0 OR Enemy(i).frame = 5 THEN Enemy(i).aframe = -Enemy(i).aframe
        END IF
      END IF
    END SELECT
    ' Has the enemy got any player?
    Collision = Collide(Enemy(i).x, Enemy(i).y)
    IF Collision > -1 THEN
      Player(Collision).status = 201: Player(Collision).dir = -8
      Player(Collision).speed = 2: Player(Collision).dead = TRUE
      IF Game.mode <> HIDDEN THEN Player(Collision).lives = Player(Collision).lives - 1
      IF Player(Collision).lives = -1 THEN Player(Collision).levelreached = ((Game.area - 1) * 5) + Game.level
      PlaySound 16
    END IF
  ' The enemy is dead and it's bouncing on the screen
  ELSEIF Enemy(i).typ < 0 THEN
    IF Enemy(i).x + Enemy(i).ox < 16 OR Enemy(i).x + Enemy(i).ox > 288 THEN Enemy(i).ox = -Enemy(i).ox
    Enemy(i).x = Enemy(i).x + Enemy(i).ox
    Enemy(i).y = Enemy(i).y + Enemy(i).oy
    IF Enemy(i).y > 199 THEN Enemy(i).y = -15
    IF Enemy(i).action = FALSE THEN
      IF Enemy(i).oy <= (ABS(Enemy(i).ox) * 2) THEN Enemy(i).oy = Enemy(i).oy + 1
      IF Enemy(i).oy > (ABS(Enemy(i).ox) * 2) AND Enemy(i).x MOD 16 = 0 THEN Enemy(i).ox = 0: Enemy(i).action = TRUE
      Enemy(i).frame = (Enemy(i).frame + 1) MOD 4
    ELSE
      IF Enemy(i).oy > 1 THEN Enemy(i).oy = Enemy(i).oy - 1
      IF Enemy(i).y > 0 AND Enemy(i).y < 176 THEN
        IF Enemy(i).y MOD 16 = 0 THEN
          IF Enemy(i).z > 0 THEN Enemy(i).z = Enemy(i).z - 1
          IF Enemy(i).z = 0 THEN
            Fall = TRUE
          ELSE
            IF INT(RND(1) * 3) = 0 THEN Fall = TRUE ELSE Fall = FALSE
          END IF
          GetBlockInfo Cel(Enemy(i).x \ 16, Enemy(i).y \ 16)
          IF st = 0 AND Fall THEN
            Enemy(i).typ = 0
            FOR ii = 0 TO MAXOBJS
              IF Object(ii).typ = 0 THEN EXIT FOR
            NEXT ii
            Object(ii).typ = 18 + INT(RND(1) * 8)
            Object(ii).x = (Enemy(i).x \ 16)
            Object(ii).y = (Enemy(i).y \ 16)
            Object(ii).time = 100
            Game.objects = Game.objects + 1
          END IF
        END IF
      END IF
      Enemy(i).frame = (Enemy(i).frame + 1) MOD 8
    END IF
  END IF
NEXT i

END SUB

SUB MovePlayers
' Checks players input, moves characters and checks for actions
FOR i = 0 TO Game.players
  ' The player can act
  IF Player(i).status <= 0 THEN
    IF Player(i).action = 0 THEN
      GetAction i
    END IF
    ' The player is moving
    IF Player(i).action = 1 THEN
      Player(i).x = Player(i).x + (dx(Player(i).dir) * Player(i).speed)
      Player(i).y = Player(i).y + (dy(Player(i).dir) * Player(i).speed)
      Player(i).frame = Player(i).frame + Player(i).aframe
      IF Player(i).frame = 0 OR Player(i).frame = 5 THEN Player(i).aframe = -Player(i).aframe
      IF Player(i).x MOD 16 = 0 AND Player(i).y MOD 16 = 0 THEN Player(i).action = 0
    ' The player is pushing a block
    ELSEIF Player(i).action > 1 THEN
      Player(i).action = Player(i).action + 1
      IF Player(i).action = 12 THEN Player(i).action = 0
      IF Player(i).action = 6 THEN
        ' Push!
        GetBlockInfo Cel((Player(i).x \ 16) + dx(Player(i).dir), (Player(i).y \ 16) + dy(Player(i).dir))
        nnd = nd: nrd = rd
        ' The block can be moved...
        IF st = 2 THEN
          GetBlockInfo Cel((Player(i).x \ 16) + (dx(Player(i).dir) * 2), (Player(i).y \ 16) + (dy(Player(i).dir) * 2))
          ' ...but next to it there's another block; the first one is destroyed
          IF st > 0 THEN
            PlaySound 18
            ' Updates the background screen buffer
            MapEMS EMShdl, 4
            BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
            MapEMS EMShdl, 0
            PutShape (236 + nnd), (Player(i).x + (dx(Player(i).dir) * 16)), (Player(i).y + (dy(Player(i).dir) * 16))
            Cel((Player(i).x \ 16) + dx(Player(i).dir), (Player(i).y \ 16) + dy(Player(i).dir)) = nnd * 100
            GetBlockInfo Cel((Player(i).x \ 16) + dx(Player(i).dir), ((Player(i).y \ 16) + dy(Player(i).dir)) - 1)
            IF st > 0 THEN PutShape (232 + st), (Player(i).x + (dx(Player(i).dir) * 16)), (Player(i).y + (dy(Player(i).dir) * 16))
            GetBlockInfo Cel((Player(i).x \ 16) + dx(Player(i).dir), ((Player(i).y \ 16) + dy(Player(i).dir)) + 1)
            IF st = 0 THEN PutShape (236 + nd), (Player(i).x + (dx(Player(i).dir) * 16)), ((Player(i).y + (dy(Player(i).dir) * 16)) + 16)
            MapEMS EMShdl, 4
            BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
            MapEMS EMShdl, 0
            ' Eventually releases a bonus
            IF nrd > 0 AND Game.status < 1 THEN
              FOR ii = 0 TO MAXOBJS
                IF Object(ii).typ = 0 THEN EXIT FOR
              NEXT ii
              Object(ii).x = (Player(i).x \ 16) + dx(Player(i).dir)
              Object(ii).y = (Player(i).y \ 16) + dy(Player(i).dir)
              Object(ii).typ = nrd
              IF INT(RND(1) * 5) = 0 THEN Object(ii).typ = 0
              IF Game.mode = DEMO AND Object(ii).typ = 14 THEN Object(ii).typ = 0
              Object(ii).time = 420
              IF Object(ii).typ > 0 THEN Game.objects = Game.objects + 1
            END IF
            ' Adds an explosion object
            FOR ii = 0 TO MAXOBJS
              IF Object(ii).typ = 0 THEN EXIT FOR
            NEXT ii
            Object(ii).x = (Player(i).x \ 16) + dx(Player(i).dir)
            Object(ii).y = (Player(i).y \ 16) + dy(Player(i).dir)
            Object(ii).typ = 99
            Object(ii).time = 0
            IF Game.mode = NORMAL THEN Player(i).score = Player(i).score + 10
            CheckScore i
          ELSE
            ' Initializes the block and adds it to the moving block queue
            FOR ii = 0 TO MAXBLOCKS
              IF Block(ii).x = -1 THEN EXIT FOR
            NEXT ii
            Block(ii).x = (Player(i).x \ 16) + dx(Player(i).dir)
            Block(ii).y = (Player(i).y \ 16) + dy(Player(i).dir)
            Block(ii).ax = dx(Player(i).dir)
            Block(ii).ay = dy(Player(i).dir)
            Block(ii).by = i
            Block(ii).hitscore = 200
            Block(ii).bonus = nrd
            ' Updates the screen
            MapEMS EMShdl, 4
            BlastCopy EMSseg, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
            MapEMS EMShdl, 0
            PutShape (236 + nnd), (Block(ii).x * 16), (Block(ii).y * 16)
            GetBlockInfo Cel(Block(ii).x, Block(ii).y - 1)
            IF st > 0 THEN PutShape (232 + st), (Block(ii).x * 16), (Block(ii).y * 16)
            GetBlockInfo Cel(Block(ii).x, Block(ii).y + 1)
            IF st = 0 THEN PutShape (236 + nd), (Block(ii).x * 16), ((Block(ii).y * 16) + 16)
            MapEMS EMShdl, 4
            BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), EMSseg, 0
            MapEMS EMShdl, 0
            PlaySound 15
          END IF
        END IF
      END IF
    END IF
    ' The player is invulnerable until his status reaches 0
    IF Player(i).status < 0 THEN Player(i).status = Player(i).status + 1
  ELSE
    ' Other stuff
    SELECT CASE Player(i).status
    CASE 1 TO 200
      ' The player is trapped; he's free once his status reaches 200
      Player(i).status = Player(i).status + 1
      IF Player(i).status = 200 THEN Player(i).status = 0
    CASE 201
      ' The player has been killed
      IF Player(i).y < 200 THEN Player(i).y = Player(i).y + Player(i).dir
      IF Player(i).dir < 10 THEN Player(i).dir = Player(i).dir + 1
    END SELECT
  END IF
NEXT i

END SUB

SUB MoveShots
' Moves shots and check collisions
FOR i = 0 TO MAXSHOTS
  ' There's a shot moving
  IF Shot(i).typ > 0 THEN
    SELECT CASE Shot(i).typ
    CASE 1, 3
      ' 1: Bubble
      ' 2: Egg
      ' Moves the shot
      Shot(i).x = Shot(i).x + Shot(i).ax
      Shot(i).y = Shot(i).y + Shot(i).ay
      IF Shot(i).typ = 1 THEN
        mul = 2: expl = 4
      ELSE
        mul = 4: expl = 5
      END IF
      ' If the shot hits a block, it's destroyed
      IF Shot(i).x MOD 16 = 0 AND Shot(i).y MOD 16 = 0 THEN
        IF Cel((Shot(i).x + (Shot(i).ax * mul)) \ 16, (Shot(i).y + (Shot(i).ay * mul)) \ 16) > 999 THEN
          IF Shot(i).typ = 3 THEN PlaySound 12
          Shot(i).typ = expl: Shot(i).time = 0
        END IF
      END IF
      Shot(i).time = Shot(i).time + 1
      IF Shot(i).typ = 1 THEN
        Collision = Collide(Shot(i).x, Shot(i).y)
        IF Collision <> -1 THEN
          ' A player has been trapped by a bubble
          IF Player(Collision).status = 0 THEN Player(Collision).status = 120: Shot(i).typ = 0
        END IF
      ELSE
        Collision = Collide(Shot(i).x, Shot(i).y)
        IF Collision <> -1 THEN
          ' A player has been hit by an egg; he's killed
          IF Player(Collision).status = 0 THEN
            Player(Collision).status = 201: Player(Collision).dir = -8
            Player(Collision).speed = 2: Player(Collision).dead = TRUE
            IF Game.mode <> HIDDEN THEN Player(Collision).lives = Player(Collision).lives - 1
            IF Player(Collision).lives = -1 THEN Player(Collision).levelreached = ((Game.area - 1) * 5) + Game.level
            Shot(i).typ = 0: PlaySound 16
          END IF
        END IF
      END IF
    CASE 2
      ' Green bouncing slime
      Shot(i).x = Shot(i).x + Shot(i).ax
      Shot(i).y = Shot(i).y + Shot(i).ay
      IF Shot(i).x MOD 16 = 0 AND Shot(i).y MOD 16 = 0 THEN
        ' If the shot hits a block, it bounces on it
        IF Cel((Shot(i).x + (Shot(i).ax * 4)) \ 16, (Shot(i).y + (Shot(i).ay * 4)) \ 16) > 999 THEN Shot(i).ax = -Shot(i).ax: Shot(i).ay = -Shot(i).ay: PlaySound 6
      END IF
      Shot(i).time = Shot(i).time + 1
      ' The shot can't move forever...
      IF Shot(i).time > 200 THEN Shot(i).typ = 0
      Collision = Collide(Shot(i).x, Shot(i).y)
      IF Collision <> -1 THEN
        IF Player(Collision).status = 0 THEN
          ' A player has been hit by the shot; he's killed
          Player(Collision).status = 201: Player(Collision).dir = -8
          Player(Collision).speed = 2: Player(Collision).dead = TRUE
          IF Game.mode <> HIDDEN THEN Player(Collision).lives = Player(Collision).lives - 1
          IF Player(Collision).lives = -1 THEN Player(Collision).levelreached = ((Game.area - 1) * 5) + Game.level
          Shot(i).typ = 0: PlaySound 16
        END IF
      END IF
    CASE 4, 5
      ' Each type of shot has its own explosion when it hits a block
      ' Only the green slime doesn't have an explosion!
      Shot(i).time = Shot(i).time + 1
      IF Shot(i).time = 6 THEN Shot(i).typ = 0
    END SELECT
  END IF
NEXT i

END SUB

SUB PlayGame
' Moves everything!
' Gets the default game palette
OPEN "RESOURCE.BIN" FOR BINARY AS #2
GET #2, 637, pal: CLOSE #2
MapEMS EMShdl, 0
' Initializes players variables
FOR i = 0 TO Game.players
  Player(i).frame = 2
  Player(i).aframe = 1
  Player(i).score = 0
  Player(i).nextextra = 30000
  Player(i).speed = 2
  Player(i).status = 0
  Player(i).lives = 3
  Player(i).bonus = "hhhhh"
  Player(i).dir = 0
  Player(i).levelreached = ((Game.area - 1) * 5) + Game.level
NEXT i
Game.status = 0
' If we're in demo mode, choose a random level
IF Game.mode = DEMO THEN
  RANDOMIZE TIMER
  Game.area = INT(RND(1) * 3) + 1
  IF Game.area > Game.numareas THEN Game.area = Game.numareas
  Game.level = INT(RND(1) * 5) + 1
END IF
NewArea
DO
  ' Initializes current level
  LoadLevel
  ' Runs the game in hidden mode to calculate how much cycles are done in
  ' one second. This will help to find the speed of the computer.
  temp = Game.mode: Game.mode = HIDDEN
  delay& = 0: t! = TIMER
  DO
    MovePlayers
    MoveBlocks
    MoveEnemies
    MoveDeath
    MoveShots
    HandleObjects
    DrawScreen
    delay& = delay& + 1
  LOOP WHILE TIMER < t! + 1
  Game.delay = CINT(delay& / 10)
  delay& = 0: t! = TIMER
  ' Finds the how many empty cycles are done in a second
  DO
    delay& = delay& + 1
  LOOP WHILE TIMER < t! + 1
  ' Calculates the delay
  Game.delay = ((Game.delay + CINT(delay& / 10)) * 2) + 1
  ' If we're running the compiled version, increases the delay
  IF COMPILED THEN Game.delay = Game.delay * 3
  ' Two players at once require less delay!
  IF Game.players = 1 THEN Game.delay = (Game.delay \ 3) * 2
  ' Reinitialize the level and loads the music
  LoadLevel
  LoadMIDI MusicFile$, VARSEG(mBuffer(0)), VARPTR(mBuffer(0))
  Game.mode = temp
  DrawScreen
  Fade 1
  ' Ready to start!
  FOR o = 0 TO 3
    s$ = "AREA" + STR$(Game.area) + "-" + LTRIM$(STR$(Game.level))
    SPrint s$, ((320 - (LEN(s$) * 8)) \ 2), 88, Game.textcol
    SPrint "GET READY!", 120, 96, Game.textcol
    BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
    FOR h = 0 TO 15: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT h
    DrawScreen
    FOR h = 0 TO 15: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT h
  NEXT o
  ' Starts the game
  AbortFlag = FALSE
  PlayMIDI VARSEG(mBuffer(0)), VARPTR(mBuffer(0))
  TIMER ON
  ' Begins game loop
  DO
    MovePlayers
    MoveBlocks
    MoveEnemies
    MoveDeath
    MoveShots
    IF Game.status = -501 THEN
      ' We're in potion bonus
      HandlePotion
    ELSE
      ' Normal objects handling
      HandleObjects
    END IF
    CheckStatus
    IF kbmatrix(1) THEN
      ' The ESC key is pressed
      IF Game.mode = DEMO THEN AbortFlag = TRUE: EXIT DO
      TIMER OFF
      SPrint "ABORT CURRENT GAME (Y/N)?", 60, 96, Game.textcol
      BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
      PlaySound 14
      DO
        IF kbmatrix(21) OR kbmatrix(49) THEN EXIT DO
      LOOP
      IF kbmatrix(21) THEN AbortFlag = TRUE: EXIT DO
      IF Game.monsters > 0 THEN TIMER ON
    END IF
    ' delays the game
    delay& = 0
    DO
      delay& = delay& + 1
    LOOP WHILE delay& < Game.delay
    Game.framecount = Game.framecount + 1
    ' Draws the new screen and shows it
    DrawScreen
  LOOP WHILE Game.status < 500
  ' The game is halted
  TIMER OFF
  StopMIDI
  IF AbortFlag THEN
    ' If the ESC key has been pressed aborts the game
    Fade 0
    EXIT DO
  END IF
  ' Finds if the level has been finished
  LevelPass = TRUE
  IF Game.players = 0 THEN
    IF Player(0).lives = -1 THEN
      Fade 0
      EXIT DO
    END IF
    IF Player(0).dead <> FALSE THEN LevelPass = FALSE
  ELSE
    IF Player(0).lives = -1 AND Player(1).lives = -1 THEN
      Fade 0
      EXIT DO
    END IF
    IF Player(0).dead <> FALSE AND Player(1).dead <> FALSE THEN LevelPass = FALSE
  END IF
  IF LevelPass = TRUE THEN
    ' The level is finished; do the victory scene
    FOR i = 0 TO Game.players: Player(i).status = 0: NEXT i
    PlaySound 13
    DO
      Game.status = Game.status + 1
      DrawScreen
    LOOP WHILE Game.status < 516
    ' Checks if all the blocks have been destroyed
    SpecialBonus = TRUE
    FOR i = 0 TO 239
      GetBlockInfo Cel(i MOD 20, i \ 20)
      IF st = 2 THEN SpecialBonus = FALSE: EXIT FOR
    NEXT i
    IF SpecialBonus = TRUE AND Game.mode = NORMAL THEN
      ' All the blocks have been destroyed: gives the special bonus!
      PlaySound 9
      FOR i = 0 TO Game.players
        IF Player(i).lives > -1 THEN Player(i).score = Player(i).score + 50000: CheckScore i
      NEXT i
      DrawScreen
      SPrint "TOTAL DESTRUCTION BONUS", 68, 92, Game.textcol
      SPrint "50000 PTS", 124, 101, Game.textcol
      BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
      FOR i = 0 TO 100: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT i
    END IF
    FOR i = 0 TO 100: WAIT &H3DA, 8, 8: WAIT &H3DA, 8: NEXT i
    RANDOMIZE TIMER
    ' Increases the level
    Game.level = Game.level + 1
    IF Game.level > 5 THEN
      Game.level = 1: Game.area = Game.area + 1
      IF Game.area <= Game.numareas THEN
        NewArea
      ELSE
        ' No more areas available; shows the end of the game!
        FOR i = 0 TO Game.players
          IF Player(i).lives > -1 THEN Player(i).levelreached = ((Game.area - 1) * 5) + Game.level
        NEXT i
        TheEnd
        EXIT DO
      END IF
    END IF
  END IF
  Fade 0
  IF Game.mode = DEMO THEN
    ' If we're in demo mode, ends it
    Fade 0
    EXIT DO
  END IF
LOOP
' Game over!
CLS
BlastCopy &HA000, 0, VARSEG(Buffer(0)), VARPTR(Buffer(0))
IF Game.mode = NORMAL THEN
  SPrint "GAME OVER", 124, 96, 56
  BlastCopy VARSEG(Buffer(0)), VARPTR(Buffer(0)), &HA000, 0
  Fade 1
  FOR i = 0 TO 150
    WAIT &H3DA, 8, 8: WAIT &H3DA, 8
    IF kbmatrix(28) OR kbmatrix(1) THEN EXIT FOR
  NEXT i
  Fade 0
END IF
OPEN "RESOURCE.BIN" FOR BINARY AS #2
GET #2, 4034, pal: CLOSE #2
IF AbortFlag THEN Game.mode = HIDDEN

END SUB

