000100000000     H DEBUG
000200000000     H COPYRIGHT('(c) Finastra International Limited 2021')
000300000000      *****************************************************************
000400000000/*STD *  RPGBASEMOD                                                   *
000500000000/*EXI *  TEXT('Midas FN String end return 1st blank pos in string')   *
000600000000      *****************************************************************
000700000000      *                                                               *
000800000000      *  Midas - Standard routines                                    *
000900000000      *                                                               *
001000000000      *  A1008010 - Midas FN String end return 1st blank pos in string*
001100000000      *                                                               *
001200000000      *  Function:  This module receives a string (character field)   *
001300000000      *             of up to 8Kb, and returns the position of         *
001400000000      *             the first blank after any nonblank content: ie    *
001500000000      *             LAST blank, starting from the right.              *
001600000000      *                                                               *
001700000000      *  Possible return codes                                        *
001800000000      *  =====================                                        *
001900000000      *                                                               *
002000000000      *  ErrTooLong - The String Length parameter contains a value    *
002100000000      *               greater than the largest possible value for     *
002200000000      *               the string to be searched (4096)                *
002300000000      *                                                               *
002400000000      *  Component of: ZASTRING - ZA module string handling service   *
002500000000      *                           program                             *
002600000000      *                                                               *
002700000000      *  Calls by:  A1008009                                          *
002900000000      *                                                               *
003000000000      *  (c) Finastra International Limited 2021                      *
003100000000      *                                                               *
003200000000      *  Last Amend No. BA1008   *CREATE   Date 03Jun21               *
004200000000      *                                                               *
004300000000      *---------------------------------------------------------------*
004400000000      *                                                               *
004401000000      *  BA1008 - Replication of Trades to consolidated branches      *
005200000000      *                                                               *
005300000000      *****************************************************************
005400000000
005500000000      *****************************************************************
005600000000      ** +--------------------------------------+
005700000000      ** ¦ Automatically included D-specs       ¦
005800000000      ** ¦ ==============================       ¦
005900000000      ** +--------------------------------------+
006000000000      **
006100000000      ** Standard D-specs
006200000000      ** ================
006300000000      **
006400000000      ** The following /COPY line includes the LDA layout,
006500000000      ** the copyright array definition,
006600000000      ** and the following named constants:
006700000000      **    True       logical = *on (for indcator processing)
006800000000      **    False      logical = *off (for indcator processing)
006900000000      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
007000000000      **                                    handler)
007100000000      ** and the following variables:
007200000000      **    RunBefore  1A (for the PSSR)
007300000000
007400000000     D/COPY ZACPYSRC,STD_D_SPEC
007500000000
007600000000      ** Include the MM standard declares
007700000000     D/COPY ZACPYSRC,STDDECLARE
007800000000
007900000000      ** Program Status Data Structure
008000000000      ** =============================
008100000000      ** The following /COPY line includes all the defined fields in the
008200000000      ** PSDS.  They have meaningful names, prefixed by 'PS'.
008300000000
008400000000     D/COPY ZACPYSRC,PSDS
008500000000
008600000000      ** +--------------------------------------+
008700000000      ** ¦ End of automatically included D-specs¦
008800000000      ** ¦ =====================================¦
008900000000      ** +--------------------------------------+
009000000000
009100000000      *****************************************************************
009200000000      /EJECT
009300000000      *****************************************************************
009400000000
009500000000      ** +--------------------------------------+
009600000000      ** ¦ Manually included D-specs            ¦
009700000000      ** ¦ =========================            ¦
009800000000      ** +--------------------------------------+
009900000000
010000000000      ** +--------------------------------------+
010100000000      ** ¦ Arrays and Data Structures           ¦
010200000000      ** ¦ ==========================           ¦
010300000000      ** +--------------------------------------+
010400000000
010500000000      ** Array to scan string
010600000000     D StringArry      S              1A   DIM(8000)
010700000000
010800000000      ** +--------------------------------------+
010900000000      ** ¦ Named constants                      ¦
011000000000      ** ¦ ===============                      ¦
011100000000      ** +--------------------------------------+
011200000000
011300000000      ** +--------------------------------------+
011400000000      ** ¦ Declared variables                   ¦
011500000000      ** ¦ ==================                   ¦
011600000000      ** +--------------------------------------+
011700000000
011800000000      ** String
011900000000     D String          S           8000A
012000000000
012100000000      ** The length of the string being scanned
012200000000      ** (Integer variable could not be used because of compatibility
012300000000      ** problems with supporting earlier releases.  Possible reinstate at
012400000000      ** a later date.)
012500000000     D StringLen       S              5P 0
012600000000
012700000000      ** Position in string
012800000000      ** (Integer variable could not be used because of compatibility
012900000000      ** problems with supporting earlier releases.  Possible reinstate at
013000000000      ** a later date.)
013100000000     D Position        S              5P 0
013200000000
013300000000      ** Array index
013400000000     D Idx             S              5P 0
013500000000
013600000000      ** +--------------------------------------+
013700000000      ** ¦ End of D-specs                       ¦
013800000000      ** ¦ ==============                       ¦
013900000000      ** +--------------------------------------+
014000000000      *****************************************************************
014100000000      /EJECT
014200000000      *****************************************************************
014300000000
014400000000     C
014500000000      ** +--- Start of Main processing -----------------------------------+
014600000000      ** ¦                                                                ¦
014700000000      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
014800000000      ** ¦ executed at program activation.                                ¦
014900000000      ** ¦                                                                ¦
015000000000      ** +----------------------------------------------------------------+
015100000000
015200000000      ** If the received value of string length is greater than the
015300000000      ** maximum possible string length, end in error
015400000000     C                   IF        StringLen > 8000
015500000000     C                   EVAL      RetCodeIn = 'ErrTooLong'
015600000000     C                   EXSR      *pssr
015700000000     C                   ENDIF
015800000000
015900000000      ** +--- Note on implementation -------------------------------------+
016000000000      ** ¦                                                                ¦
016100000000      ** ¦ This function has been implemented using a search              ¦
016200000000      ** ¦ backwards through an array, rather than by use of RPG's        ¦
016300000000      ** ¦ built-in opcode CHECKR (Check right).  This is because CHECKR  ¦
016400000000      ** ¦ proved to be incredibly slow, and an array search is faster.   ¦
016500000000      ** ¦ It's possible that the array search could be replaced with a   ¦
016600000000      ** ¦ suitable built-in function at a later date.                    ¦
016700000000      ** ¦                                                                ¦
016800000000      ** +----------------------------------------------------------------+
016900000000
017000000000      ** Put the received field into the array
017100000000     C                   MOVEA     String        StringArry
017200000000
017300000000      ** Set the starting index to the received value of the string length
017400000000     C                   EVAL      Idx = StringLen
017500000000
017600000000      ** Find the first nonblank character, starting from the right
017700000000     C                   DOW       Idx > 0 AND StringArry(Idx) = *blank
017800000000
017900000000     C                   EVAL      Idx = Idx - 1
018000000000
018100000000     C                   ENDDO
018200000000
018300000000      ** Add one, to represent the position of the first significant blank
018400000000     C                   EVAL      Position = Idx + 1
018500000000
018600000000     C                   RETURN
018700000000
018800000000      *****************************************************************
018900000000      /EJECT
019000000000      *****************************************************************
019100000000      *                                                               *
019200000000      * *INZSR - Program Initialisation routine                       *
019300000000      *                                                               *
019400000000      * Called by: Implicitly on program activation                   *
019500000000      *                                                               *
019600000000      * Calls: None                                                   *
019700000000      *                                                               *
019800000000      *****************************************************************
019900000000
020000000000     C     *INZSR        BEGSR
020100000000
020200000000     C     *entry        PLIST
020300000000      ** Incoming return code (10A, returned to caller)
020400000000     C                   PARM                    RetCodeIn
020700000000      ** Position of first significant blank in string (5,0P, returned to
020800000000      ** caller)
020900000000     C                   PARM                    Position
021000000000      ** String (4096A, from caller)
021100000000     C                   PARM                    String
021300000000      ** Length of string (5,0P, from caller)
021400000000     C                   PARM                    StringLen
021500000000
021600000000      ** Program, module and procedure names for database error processing.
021700000000      ** =================================================================
021800000000      ** The following /COPY sets these values, and also defines LDA as
021900000000      ** an external data area
022000000000
022100000000     C/COPY ZACPYSRC,DBFIELDS
022200000000
022300000000     C                   ENDSR
022400000000
022500000000      *****************************************************************
022600000000      /EJECT
022700000000      *****************************************************************
022800000000     C/COPY ZACPYSRC,PSSR_ILE
022900000000      ********************************************************************
023000000000**  CPY@
023100000000(c) Finastra International Limited 2021
