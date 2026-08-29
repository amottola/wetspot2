' WETSPOT2.BI
' by Enhanced Creations 1997-98
' WetSpot II declaration include file
'
' This file contains SUB and FUNCTION declarations, TYPES and
' COMMON variables for multiple modules programming.
'
DEFINT A-Z
'$DYNAMIC

TYPE DeadEnemyType        ' Used on the ending scene only
  speed AS SINGLE         ' speed of each falling enemy
  x AS INTEGER            ' x coordinate
  y AS SINGLE             ' y coordinate
  typ AS INTEGER          ' type of enemy...
  frame AS INTEGER        ' ...and its current frame
END TYPE

TYPE MenuTextType         ' Used to store menu options data
  Text AS STRING * 30     ' option text
  y AS INTEGER            ' y coordinate of the text
  col AS INTEGER          ' text color
END TYPE

TYPE Joystick             ' Joystick status data type
  detected AS INTEGER     ' have the joystick been detected?
  but AS INTEGER          ' TRUE if a button is pressed, otherwise FALSE
  x AS INTEGER            ' x coordinate
  y AS INTEGER            ' y coordinate
  xc AS INTEGER           ' centered x position
  yc AS INTEGER           ' centered y position
  res AS INTEGER          ' joystick resolution (see README.TXT)
END TYPE

TYPE PlayerType           ' Data type to store the variables of each player
  dead AS INTEGER         ' is the player dead?
  control AS INTEGER      ' player control method
  x AS INTEGER            ' crab x coordinate
  y AS INTEGER            ' crab y coordinate
  dir AS INTEGER          ' crab direction (0=down, 1=left, 2=up, 3=right)
  action AS INTEGER       ' current action (0=stop, 1=moving, >1=firing)
  frame AS INTEGER        ' sprite frame number
  aframe AS INTEGER       ' frame increase/decrease flag
  speed AS INTEGER        ' crab speed
  status AS INTEGER       ' player status
  score AS LONG           ' player score
  nextextra AS LONG       ' points needed for the next extra life
  lives AS INTEGER        ' number of lives
  bonus AS STRING * 5     ' BONUS letters data
  potion AS INTEGER       ' number of bonuses taken in the potion bonus mode
  levelreached AS INTEGER ' last level reached by the player
END TYPE

TYPE EnemyType            ' Data type to store the variables of each enemy
  x AS INTEGER            ' x position
  y AS INTEGER            ' y position
  ox AS INTEGER           ' old x position (shark uses ox for movements)
  oy AS INTEGER           ' old y position (shark uses oy for movements)
  z AS INTEGER            ' z position for flying enemies
  az AS INTEGER           ' z increase/decrease flag
  typ AS INTEGER          ' enemy type
  dir AS INTEGER          ' enemy direction (look at player's direction)
  action AS INTEGER       ' current action (depending on the enemy type)
  frame AS INTEGER        ' sprite frame number
  aframe AS INTEGER       ' frame increase/decrease flag
  change AS INTEGER       ' enemy change flag
END TYPE

TYPE DeathType            ' Flame-like unbeatable enemies data type
  x AS SINGLE             ' x position
  y AS SINGLE             ' y position
  frame AS INTEGER        ' sprite frame number
  speed AS SINGLE         ' speed: it's increases at each cycle
END TYPE

TYPE ShotType             ' Data type of the shots fired by the enemies
  x AS INTEGER            ' x position
  y AS INTEGER            ' y position
  ax AS INTEGER           ' x increase/decrease value
  ay AS INTEGER           ' y increase/decrease value
  typ AS INTEGER          ' shot type
  time AS INTEGER         ' multiple purposes variable
END TYPE

TYPE BlockType            ' Moving block data type
  x AS INTEGER            ' x position
  y AS INTEGER            ' y position
  ax AS INTEGER           ' x increase/decrease value
  ay AS INTEGER           ' y increase/decrease value
  by AS INTEGER           ' which player hit the block?
  hitscore AS INTEGER     ' increases each time the block hits an enemy
  bonus AS INTEGER        ' bonus hidden within the block
END TYPE

TYPE ObjectType           ' Object data type
  x AS INTEGER            ' x position
  y AS INTEGER            ' y position
  typ AS INTEGER          ' object type
  time AS INTEGER         ' time left before the object is erased
END TYPE

TYPE GameType             ' Holds all the main game variables
  players AS INTEGER      ' number of players of current game
  mode AS INTEGER         ' game more (NORMAL, DEMO or HIDDEN)
  time AS INTEGER         ' level time left
  monsters AS INTEGER     ' number of monsters still alive on the level
  status AS INTEGER       ' game status (has different purposes)
  objects AS INTEGER      ' number of objects on the screen
  special AS INTEGER      ' present bonus flag
  numareas AS INTEGER     ' number of total areas of the current world
  area AS INTEGER         ' current area
  level AS INTEGER        ' current level
  textcol AS INTEGER      ' area text color
  delay AS LONG           ' game delay; different on each computer
  soundon AS INTEGER      ' TRUE if sounds are on, otherwise FALSE
  musicon AS INTEGER      ' TRUE if musics are on, otherwise FALSE
  framecount AS INTEGER   ' framerate internal counter
  framerate AS INTEGER    ' framerate
END TYPE

TYPE RecordType           ' Record data type for the top 10
  nam AS STRING * 16      ' player's name
  score AS LONG           ' high score
  area AS INTEGER         ' area reached
  level AS INTEGER        ' level reached
END TYPE

TYPE FireWorkType         ' Used only in the top 10
  x AS SINGLE             ' x position
  y AS SINGLE             ' y position
  ax AS SINGLE            ' x increase/decrease value
  ay AS SINGLE            ' y increase/decrease value
  time AS INTEGER         ' firework countdown
  col AS INTEGER          ' firework color index
END TYPE

TYPE RegTypeX             ' CPU registers data type (self explanatory)
  ax AS INTEGER
  bx AS INTEGER
  cx AS INTEGER
  dx AS INTEGER
  bp AS INTEGER
  si AS INTEGER
  di AS INTEGER
  flags AS INTEGER
  ds AS INTEGER
  es AS INTEGER
END TYPE


TYPE bmpinfo              ' Header for a 320*200*256 bmp image file format
  bm AS STRING * 2        ' should be "BM"
  size AS LONG            ' file size (width*height+1078=65078)
  r1 AS INTEGER           ' =0
  r2 AS INTEGER           ' =0
  offsdata AS LONG        ' =1078
  hsize AS LONG           ' =40
  wid AS LONG             ' =320
  hei AS LONG             ' =200
  planes AS INTEGER       ' =1
  bpp AS INTEGER          ' =8
  comp AS LONG            ' =0
  isize AS LONG           ' =64000
  xpm AS LONG             ' =3790
  ypm AS LONG             ' =3780
  colus AS LONG           ' =0
  impcol AS LONG          ' =0
  pal AS STRING * 1024    ' stored as blue, green, red, 0
END TYPE

' Here follows the SUBs and FUNCTIONs declarations
DECLARE SUB Intro ()
DECLARE SUB TheEnd ()
DECLARE SUB ShowTop10 (Blink1, Blink2)
DECLARE SUB CheckForRecord ()
DECLARE SUB Center (Text$, y, fcol, bcol)
DECLARE SUB EndingText ()
DECLARE SUB ShowCredits ()
DECLARE SUB DrawMenu (Sel)
DECLARE SUB MPrint (Text$, yPos, MCol, Shadow)
DECLARE SUB GetAction (PlayerNum)
DECLARE SUB ReadJoy (JoyNum)
DECLARE SUB HandlePotion ()
DECLARE SUB KillEnemy (EnemyNum)
DECLARE SUB PutScore (sc, xPos, yPos, sCol)
DECLARE SUB HandleObjects ()
DECLARE SUB MoveShots ()
DECLARE SUB MoveEnemies ()
DECLARE SUB MoveBlocks ()
DECLARE SUB MoveDeath ()
DECLARE SUB MovePlayers ()
DECLARE SUB DrawScreen ()
DECLARE SUB GetBlockInfo (CelCode)
DECLARE SUB SPrint (Text$, xPos, yPos, col)
DECLARE SUB NewArea ()
DECLARE SUB PalGet (col%, r%, g%, b%)
DECLARE SUB PalSet (col%, r%, g%, b%)
DECLARE SUB Fade (Where%)
DECLARE SUB ChangePal (PalNum)
DECLARE SUB LoadLevel ()
DECLARE SUB PutShape (num, xPos, yPos)
DECLARE SUB Menu ()
DECLARE SUB PlayGame ()
DECLARE SUB CheckScore (PlayerNum)
DECLARE SUB SpriteGet (xPos, yPos, ssegment, soffset)
DECLARE SUB SpritePut (xPos, yPos, dsegment, doffset)
DECLARE SUB BlastPset (Segment, Offset, xPos, yPos, col)
DECLARE SUB BlastCopy (fsegment, foffset, tsegment, toffset)
DECLARE SUB BlastLine (dsegment, doffset, x1, y1, x2, y2, colr)
DECLARE SUB MapEMS (handle, Block)
DECLARE SUB CheckStatus ()
DECLARE SUB Interrupt (interr AS INTEGER, iregs AS RegTypeX, oregs AS RegTypeX)
DECLARE SUB InterruptX (interr AS INTEGER, iregs AS RegTypeX, oregs AS RegTypeX)
DECLARE SUB SetVolume ()
DECLARE SUB WriteDSP (byte)
DECLARE SUB DMAplay (Segment, Offset, Length&, Freq&)
DECLARE SUB PlaySound (SoundNum)
DECLARE SUB Logo ()
DECLARE SUB LoadMIDI (Filename$, MIDISegment%, MIDIOffset%)
DECLARE SUB PlayMIDI (MIDISegment%, MIDIOffset%)
DECLARE SUB StopMIDI ()
DECLARE FUNCTION ResetDSP ()
DECLARE FUNCTION ReadDSP ()
DECLARE FUNCTION DMAdone ()
DECLARE FUNCTION SelectMenu (MaxSel)
DECLARE FUNCTION SelectWorld$ ()
DECLARE FUNCTION InFrontOf (EnemyNum, PlayerNum)
DECLARE FUNCTION Collide (xPos, yPos)
DECLARE FUNCTION FindTarget (xPos, yPos)
DECLARE FUNCTION InitGame ()
DECLARE FUNCTION GetText$ (TitleText$, TextLen)

' Common variables shared between modules and subroutines
COMMON SHARED AsmCode() AS STRING, EMShdl AS INTEGER, EMSseg AS INTEGER
COMMON SHARED DataFile AS STRING, FontData AS STRING * 1792
COMMON SHARED EnemyPal() AS STRING * 240, pal AS STRING * 768
COMMON SHARED Buffer() AS INTEGER, mBuffer() AS INTEGER
COMMON SHARED Shape() AS INTEGER, Cel() AS INTEGER
COMMON SHARED Player() AS PlayerType, Enemy() AS EnemyType
COMMON SHARED Shot() AS ShotType, Block() AS BlockType
COMMON SHARED Object() AS ObjectType, Death() AS DeathType
COMMON SHARED Game AS GameType, MusicFile$, Blocked AS INTEGER
COMMON SHARED st AS INTEGER, nd AS INTEGER, rd AS INTEGER
COMMON SHARED dx() AS INTEGER, dy() AS INTEGER, Keys() AS INTEGER
COMMON SHARED Joy() AS Joystick, Mask() AS INTEGER
COMMON SHARED kbcontrol() AS INTEGER, keyboardonflag AS INTEGER
COMMON SHARED kbmatrix() AS INTEGER, MenuText() AS MenuTextType
COMMON SHARED ControlName() AS STRING, ScreenShot AS INTEGER
COMMON SHARED r AS INTEGER, g AS INTEGER, b AS INTEGER
COMMON SHARED LenPort%, PgPort%, AddPort%, ModeReg%
COMMON SHARED BasePort%, Channel%, Volume AS INTEGER
COMMON SHARED SoundLen() AS LONG, SBMIDIok AS INTEGER
COMMON SHARED MIDI.PLAYTIME AS SINGLE, MIDI.ERROR AS INTEGER

' Game constants
CONST FALSE = 0, TRUE = NOT FALSE
CONST NORMAL = 0, DEMO = 1, POTIONBONUS = 2, HIDDEN = 3
CONST KEYBOARD1 = 0, KEYBOARD2 = 1, JOY1 = 2, JOY2 = 3
CONST MAXMENU = 7, MAXENEMIES = 15, MAXSHOTS = 15, MAXBLOCKS = 7
CONST MAXOBJS = 47, MAXSOUNDS = 18, MAXFIREWORKS = 3
' Game version string
CONST VERSION$ = "1.3"
' Compiled flag
CONST COMPILED = FALSE        ' WARNING: change the value of this constant to
                              ' TRUE when compiling; this will slow down the
                              ' game because an EXE is faster than the
                              ' interpreted code.

