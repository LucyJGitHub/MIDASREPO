     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Additional Cust Details Access Object')       *
      *****************************************************************
      *                                                               *
      *  Midas  Access Object                                         *
      *                                                               *
      *  AONAHOR0  - Read Access to Non-account Holder File           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL132             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24029           Date 19May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233207             Date 25Apr05               *
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *           (Recompile)                                         *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  233207 - Non-account Holders Selection Processing            *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
     FSDNAHOL1  IF   E           K DISK    USROPN
 
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
 
     D PZRtCd          S              7A                                                      233207
     D PZNAHo          S             10A                                                      233207
                                                                                              233207
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
 
     D D@FMT         E DS                  EXTNAME(SDNAHOPD)
      ** Non-account Holder Customers
 
     D*P@FMT***      E DS                  EXTNAME(DSSDY)                                   BUG24029
     D P@FMT         E DS                  EXTNAME(DSLDY)                                   BUG24029
      ** External Data structure to hold the outgoing record format of
      ** the file.
 
     D PqNAHO          DS
      ** Non-account Holder key definition
     D  W@NAHO                 1     10
 
     D A@CPY           DS
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM                    P@NAHO           10
     C                   PARM                    P@FMT
 
      **Access Option *SAME input
 
     C                   IF        P@OPTN = '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   ENDIF
 
      ** Reset error indicators
 
     C                   SETOFF                                       909192
     C                   SETOFF                                       939495
     C                   SETOFF                                       969798
 
      ** First call - open file :
 
     C                   IF        *IN01 = '0'
     C                   SETON                                        01
     C                   OPEN      SDNAHOL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
      ** Last call - close file and terminate program :
 
     C                   IF        P@OPTN = '*FREE  '
     C                   CLOSE     SDNAHOL1                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   ENDIF
 
      ** Caller requests first record :
 
     C                   IF        P@OPTN = '*FIRST '
     C     *LOVAL        SETLL     SDNAHOD0                           9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*NEXT  '     P@OPTN
     C                   ENDIF
 
      ** Caller requests next record :
 
     C                   IF        P@OPTN = '*NEXT  '
     C                   READ      SDNAHOD0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
      ** Caller requests last record :
 
     C                   IF        P@OPTN = '*LAST  '
     C     *HIVAL        SETGT     SDNAHOD0                             90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*PREV  '     P@OPTN
     C                   ENDIF
 
      ** Caller requests previous record :
 
     C                   IF        P@OPTN = '*PREV  '
     C                   READP     SDNAHOD0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
      ** Caller requests record indicated by key :
 
     C                   IF        P@OPTN = '*KEY   ' or
     C                             P@OPTN = '*VERIFY'
                                                                                              233207
     C                   IF        %SCAN('?':P@NAHO) <> *ZERO                                 233207
                                                                                              233207
     C                   CALL(E)   'SD000020S'                                                233207
     C                   PARM      *BLANKS       PZRtCd                                       233207
     C                   PARM      *BLANKS       PZNAHo                                       233207
                                                                                              233207
     C                   IF        %ERROR                                                     233207
     C                   EVAL      *IN98 = *ON                                                233207
     C                   GOTO      T@SKIP                                                     233207
     C                   ENDIF                                                                233207
                                                                                              233207
     C                   IF        PZRtCd <> *BLANKS                                          233207
     C                   EVAL      *IN97 = *ON                                                233207
     C                   GOTO      T@SKIP                                                     233207
     C                   ENDIF                                                                233207
                                                                                              233207
     C                   EVAL      P@NAHO = PZNAHo                                            233207
                                                                                              233207
     C                   ENDIF                                                                233207
                                                                                              233207
     C     P@NAHO        CHAIN     SDNAHOD0                           9590
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
     C                   IF        *IN98 = *ON                                                233207
     C                   EVAL      P@RTCD = '*CALL  '                                         233207
     C                   ENDIF                                                                233207
 
      ** Caller requests message sent to program queue :
 
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
     C                   IF        *IN98 = *ON                                                233207
     C                   EVAL      P@MGID = 'ACO1010'                                         233207
     C                   ENDIF                                                                233207
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
(c) Finastra International Limited 2004
**
SDNAHOPD  AONAHOR0  Non-Account Holder
