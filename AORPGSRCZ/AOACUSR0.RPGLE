     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Additional Cust Details Access Object')       *
      *****************************************************************
      *                                                               *
      *  Midas  Access Object                                         *
      *                                                               *
      *  AOACUSR0  - Read Access to Additional Customer File          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 20Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************

     FSDACUSL1  IF   E           K DISK    USROPN

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
     D PGMDS          SDS
      ** Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0

     D D@FMT         E DS                  EXTNAME(SDACUSPD)
      ** Customer Details by Country of Tax

     D*P@FMT****     E DS                  EXTNAME(DSSDY)                                     CSW207
     D P@FMT         E DS                  EXTNAME(DSLDY)                                     CSW207
      ** External Data structure to hold the outgoing record format of
      ** the file.

     D P@ACUS          DS
      ** Country of residence key definition
     D  W@ACUS                 1      6

     D A@CPY           DS
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM                    P@ACUS            6
     C                   PARM                    P@FMT

      ** Access Option *SAME input

     C                   IF        P@OPTN = '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   ENDIF

      ** Reset error indicators

     C                   SETOFF                                       909192
     C                   SETOFF                                       939495
     C                   SETOFF                                       969798
     C                   EVAL      *IN80 = *OFF                                             BUG23518
     C                   EVAL      *IN81 = *OFF                                             BUG23518

      ** First call - open file :

     C                   IF        *IN01 = '0'
     C                   SETON                                        01
     C                   OPEN      SDACUSL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF

      ** Last call - close file and terminate program :

     C                   IF        P@OPTN = '*FREE  '
     C                   CLOSE     SDACUSL1                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   ENDIF

      ** Caller requests first record :

     C                   IF        P@OPTN = '*FIRST '
     C     *LOVAL        SETLL     @ACUSL1                            9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*NEXT  '     P@OPTN
     C                   ENDIF

      ** Caller requests next record :

     C                   IF        P@OPTN = '*NEXT  '
     C                   READ      @ACUSL1                              9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF

      ** Caller requests last record :

     C                   IF        P@OPTN = '*LAST  '
     C     *HIVAL        SETGT     @ACUSL1                              90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*PREV  '     P@OPTN
     C                   ENDIF

      ** Caller requests previous record :

     C                   IF        P@OPTN = '*PREV  '
     C                   READP     @ACUSL1                              9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF

      ** Caller requests record indicated by key :

     C                   IF        P@OPTN = '*KEY   ' or
     C                             P@OPTN = '*VERIFY'
     C     P@ACUS        CHAIN     @ACUSL1                            9590
      *                                                                                     BUG23518
      ** Check if the Customer is Closed or Deleted                                         BUG23518
      *                                                                                     BUG23518
     C                   IF        *IN95 = *OFF                                             BUG23518
      *                                                                                     BUG23518
     C                   IF        E5TYLC = 'C'                                             BUG23518
     C                   EVAL      *IN80 = *ON                                              BUG23518
     C                   ELSEIF    E5TYLC = 'D'                                             BUG23518
     C                   EVAL      *IN81 = *ON                                              BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C     *IN95         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF

     C                   IF        P@OPTN <> '*KEY   ' and
     C                             P@OPTN <> '*NEXT  ' and
     C                             P@OPTN <> '*PREV  ' and
     C                             P@OPTN <> '*VERIFY' and
     C                             P@OPTN <> '*FREE  '
     C                   SETON                                          96
     C                   ENDIF                                                  FI 9

      ** No record found or End of file - return error code :

     C     T@SKIP        TAG

     C                   EVAL      P@RTCD = *BLANK                              No Errors
     C   90              EVAL      P@RTCD = '*ERROR '                           File error
     C   91              EVAL      P@RTCD = '*OPEN  '                           Open error
     C   92              EVAL      P@RTCD = '*CLOSE '                           Close error
     C   93              EVAL      P@RTCD = '*EMPTY '                           Empty file
     C   94              EVAL      P@RTCD = '*EOF   '                           End of file
     C   95              EVAL      P@RTCD = '*NRF   '                           No record found
     C   96              EVAL      P@RTCD = '*OPTION'                           Option error
     C   97              EVAL      P@RTCD = '*NOSEL '                           No selection
     C   80              EVAL      P@RTCD = '*CUSCLO'                                       BUG23518
     C   81              EVAL      P@RTCD = '*CUSDEL'                                       BUG23518

      * Caller requests message sent to program queue :

     C                   IF        W@RTCD = '*MSG   ' and
     C                             P@RTCD = *BLANK
     C   90              EVAL      P@MGID = 'ACO1001'                             File error
     C   91              EVAL      P@MGID = 'ACO1002'                             Open error
     C   92              EVAL      P@MGID = 'ACO1003'                             Close error
     C   93              EVAL      P@MGID = 'ACO1004'                             Empty file
     C   94              EVAL      P@MGID = 'ACO1005'                             End of file
     C   95              EVAL      P@MGID = 'ACO1006'                             No record
     C   96              EVAL      P@MGID = 'ACO1007'                             Option error
     C   97              EVAL      P@MGID = 'ACO1009'                             No selection

     C                   CALL      'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program nme
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message fle
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message dta
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message tpe
     C                   ENDIF

      ** Caller Requests DB Error Handling

     C                   IF        W@RTCD = '*DBERR' and
     C                             P@RTCD = *BLANK
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   IF        P@OPTN <> '*VERIFY' and
     C                             P@OPTN <> '*FREE'   and
     C                             P@RTCD <> '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   ENDIF

      ** Return to caller :

     C                   RETURN

      *****************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
**
SDACUSPD  AOACUSR0  Additional Customer
