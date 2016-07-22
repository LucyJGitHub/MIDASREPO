000100000000     H DEBUG
000200000000     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
000300000000      *****************************************************************
000400000000/*STD *  RPGBASEMOD                                                   *
000500000000/*EXI *  TEXT('Midas SD Validate Legal Form Code')                    *
000600000000      *****************************************************************
000700000000      *                                                               *
000800000000      *  Midas - Standing Data ILE Module                             *
000900000000      *                                                               *
001000000000      *  SDVRECH SD Validate Legal Form Code                          *
001100000000      *                                                               *
001200000000      *  Function:  This module validates the field Legal             *
001300000000      *             Form Code                                         *
001400000000      *                                                               *
001500000000      *  (c) Misys International Banking Systems Ltd. 2016            *
001600000000      *                                                               *
001700160707      *  Last Amend No. CER071   *CREATE   Date 01Aug16               *
001800000000      *                                                               *
001900000000      *---------------------------------------------------------------*
002000000000      *                                                               *
002100000000      *  CER071 - BAIS - Legal Form Code                              *
002200000000      *                                                               *
002300000000      *****************************************************************
002400000000      *                                                               *
002500000000      *  S U B R O U T I N E  I N D E X                               *
002600000000      *                                                               *
002700000000      *  VALRECH - Validate Legal Form Code                           *
002800000000      *                                                               *
002900000000      *  *INZSR - Program initialisation routine                      *
003000000000      *    The *INZSR subroutine will only get called automatically   *
003100000000      *    on entry to the module the first time it is run            *
003200000000      *    (unless you end the program with LR on).  Similarly        *
003300000000      *    D-spec initialisation only happens the first time.  Use    *
003400000000      *    RESET for subsequent passes.                               *
003500000000      *                                                               *
003600000000      *****************************************************************
003700000000     FSDPDWNL1  IF   E           K DISK
003800000000      * RTV : Midas SD Midas system pulldown lists
003900000000      *
004000000000      ** +--------------------------------------+
004100000000      ** ¦ Automatically included D-specs       ¦
004200000000      ** ¦ ==============================       ¦
004300000000      ** +--------------------------------------+
004400000000      **
004500000000      *
004600000000      ** The following /COPY line include (among others) the LDA layout
004700000000      ** and the copyright array definition:
004800000000     D/COPY ZACPYSRC,STD_D_SPEC
004900000000      *
005000000000      ** The following /COPY includes the MM standard declares:
005100000000     D/COPY ZACPYSRC,STDDECLARE
005200000000      *
005300000000      ** The following /COPY line includes all the defined fields in
005400000000      ** the Program Status Data Structures.  They have meaningful
005500000000      ** names, prefixed by 'PS'.
005600000000     D/COPY ZACPYSRC,PSDS
005700000000      *
005800000000      ** The following /COPY line include the definitions for error and
005900000000      ** warning message arrays.
006000000000     D/COPY ZACPYSRC,ERR_ARRAYS
006100000000      *
006200000000      ** The following /COPY line includes all the definitions of the
006300000000      ** appended error arrays, including the named constant giving the
006400000000      ** size of the arrays.
006500000000     D/COPY ZACPYSRC,ERR_XARRYS
006600000000      *
006700000000      ** +--------------------------------------+
006800000000      ** ¦ End of automatically included D-specs¦
006900000000      ** ¦ =====================================¦
007000000000      ** +--------------------------------------+
007100000000      *
007200000000      *****************************************************************
007300000000      /EJECT
007400000000      *****************************************************************
007500000000      *
007600000000      ** +--------------------------------------+
007700000000      ** ¦ Manually included D-specs            ¦
007800000000      ** ¦ =========================            ¦
007900000000      ** +--------------------------------------+
008000000000      *
008100000000      ** +--------------------------------------+
008200000000      ** ¦ Named constants                      ¦
008300000000      ** ¦ ===============                      ¦
008400000000      ** +--------------------------------------+
008500000000      *
008600000000      ** +--------------------------------------+
008700000000      ** ¦ Arrays and Data Structures           ¦
008800000000      ** ¦ ==========================           ¦
008900000000      ** +--------------------------------------+
009000000000      *
009100000000      ** +--------------------------------------+
009200000000      ** ¦ Declared variables                   ¦
009300000000      ** ¦ ==================                   ¦
009400000000      ** +--------------------------------------+
009500000000      *
009600000000     D DDBEXT          S              1A
009700000000     D DDRECH          S              2A
009800000000     D OKRECH          S              1A
009900000000     D Idx             S              3P 0
010000000000     D KGLHIND         S                   LIKE(GLHIND)
010100000000     D KGLVDTA         S                   LIKE(GLVDTA)
010200000000      *
010300000000      ** +--------------------------------------+
010400000000      ** ¦ End of D-specs                       ¦
010500000000      ** ¦ ==============                       ¦
010600000000      ** +--------------------------------------+
010700000000      *
010800000000      *****************************************************************
010900000000      /EJECT
011000000000      *****************************************************************
011100000000      *
011200000000      ** +--- Start of Main processing -------------------------------+
011300000000      ** ¦                                                            ¦
011400000000      ** ¦ Initial processing is performed automatically: the *inzsr  ¦
011500000000      ** ¦ is executed at program activation.                         ¦
011600000000      ** ¦                                                            ¦
011700000000      ** +------------------------------------------------------------+
011800000000      *
011900000000      ** Validate Legal Form Code
012000000000      *
012100000000     C                   EXSR      VALRECH
012200000000      *
012300000000     C                   IF        OKRECH = 'N'
012400000000      *
012500000000     C                   EVAL      RetCodeIn = 'ERROR'
012600000000      *
012700000000     C                   ENDIF
012800000000      *
012900000000      ** Return from Program
013000000000      *
013100000000     C                   RETURN
013200000000      *****************************************************************
013300000000      /EJECT
013400000000      *****************************************************************
013500000000      *                                                               *
013600000000      *  VALRECH - Validate Legal Form Code                           *
013700000000      *                                                               *
013800000000      *  Called by: MAIN Processing                                   *
013900000000      *                                                               *
014000000000      *  Calls: None                                                  *
014100000000      *                                                               *
014200000000      *****************************************************************
014300000000     C     VALRECH       BEGSR
014400000000      *
014500000000     C                   IF        DDRECH = *BLANKS AND
014600000000     C                             DDBEXT = 'Y'
014700000000      *
014800000000     C                   EVAL      OKRECH = 'N'
014801160712     C                   EVAL      OKRECH = 'N'
014900000000     C                   EVAL      Idx = Idx + 1
015000000000     C                   EVAL      FldNamXAr(Idx) = 'E5RECH'
015100000000      *
015200000000      * Legal Form Code is required
015300000000      *
015400160712     C                   EVAL      MsgIdXAr(Idx) = '5048708'
015500000000      *
015600000000     C                   ENDIF
015700000000      *
015800000000     C                   IF        DDRECH <> *BLANKS
015900000000     C                   EVAL      KGLHIND = 676
016000000000     C                   EVAL      KGLVDTA = DDRECH
016100000000      *
016200000000     C     KPDWN         CHAIN(e)  SDPDWNL1
016300000000      *
016400000000      ** Access Legal Form Code Table
016500000000      *
016600000000     C                   IF        %error or not %found
016700000000      *
016800000000     C                   EVAL      OKRECH = 'N'
016900000000     C                   EVAL      Idx = Idx + 1
017000000000     C                   EVAL      FldNamXAr(Idx) = 'E5RECH'
017100000000      *
017200000000      * Legal Form Code is invalid
017300000000      *
017400160712     C                   EVAL      MsgIdXAr(Idx) = '5048707'
017500000000      *
017600000000     C                   ENDIF
017700000000      *
017800000000     C                   ENDIF
017900000000      *
018000000000     C                   IF        DDRECH <> *BLANKS AND
018100000000     C                             DDBEXT <> 'Y'
018200000000      *
018300000000     C                   EVAL      OKRECH = 'N'
018400000000     C                   EVAL      Idx = Idx + 1
018500000000     C                   EVAL      FldNamXAr(Idx) = 'E5RECH'
018600000000      *
018700000000      * ERC0032: Field should be blank if Customer Required for Bundesbank is 'N'
018800000000      *
018900000000     C                   EVAL      MsgIdXAr(Idx) = 'ERC0032'
019000000000     C                   EVAL      #MsgFile = 'GBSTUSRMSG'
019100000000      *
019200000000     C                   ENDIF
019300000000      *
019400000000      *
019500000000     C                   ENDSR
019600000000      *****************************************************************
019700000000      /EJECT
019800000000      *****************************************************************
019900000000      *                                                               *
020000000000      *  *INZSR - Program initialisation routine                      *
020100000000      *                                                               *
020200000000      *  Called by: Implicitly on program activation                  *
020300000000      *                                                               *
020400000000      *  Calls: None                                                  *
020500000000      *                                                               *
020600000000      *****************************************************************
020700000000     C     *INZSR        BEGSR
020800000000      *
020900000000     C     *ENTRY        PLIST
021000000000      *
021100000000      ** Inputs
021200000000      *
021300000000      ** Return Code
021400000000     C                   PARM                    RetCodeIn
021500000000      *
021600160708      ** Legal Form
021700000000      *
021800000000     C                   PARM                    DDRECH
021900000000      *
022000000000      ** Customer Required for Bundesbank Reporting
022100000000      *
022200000000     C                   PARM                    DDBEXT
022300000000      *
022400000000      ** Outputs
022500000000      *
022600000000      ** Error fields/message IDs/message data (arrays) from/to caller
022700000000      *
022800000000     C                   PARM                    Idx
022900000000     C                   PARM                    FldNamXAr
023000000000     C                   PARM                    MsgIdXAr
023100000000     C                   PARM                    MsgDtaXAr
023200000000      *
023300000000      ** Ok Flag for Legal Form Code
023400000000      *
023500000000     C                   PARM                    OKRECH
023600000000      *
023700000000      ** Define keylist for SDPDWNL1
023800000000      *
023900000000     C     KPDWN         KLIST
024000000000     C                   KFLD                    KGLHIND
024100000000     C                   KFLD                    KGLVDTA
024200000000      *
024300000000     C                   EVAL       RetCodeIn = *BLANKS
024400000000     C                   EVAL       Idx       = *ZEROS
024500000000     C                   EVAL       FldNamXAr = *BLANKS
024600000000     C                   EVAL       MsgIdXAr  = *BLANKS
024700000000     C                   EVAL       MsgDtaXAr = *BLANKS
024800000000      *
024900000000     C                   ENDSR
025000000000      *****************************************************************
025100000000      /EJECT
025200000000      *****************************************************************
025300000000      *
025400000000      ** The following /COPY contains the standard program status
025500000000      ** subroutine, including a bound call to the DBERRCTL module.
025600000000      *
025700000000     C/COPY ZACPYSRC,PSSR_ILE
025800000000      *****************************************************************
025900000000** CPY@
026000000000(c) Misys International Banking Systems Ltd. 2016
