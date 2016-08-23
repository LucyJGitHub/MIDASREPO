     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas COB Extraction of Teller Transactions')
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF004609 - Midas COB Extraction of Teller Transactions       *
      *                                                               *
      *  Function:  This program will extract all teller transaction  *
      *             records at RATM and OPAY for today                *
      *                                                               *
      *  Called By: BFC004609 - COB Extraction of Teller Transaction  *
      *                         Records Control                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CRE072  *CREATE    Date 30Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE072 - BankFusion Midas Teller Related Changes             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SrStmSQLR - Subroutine to get the transaction records in     *
      *              GLATMIPD with I,A or D status and for today      *
      *  SQLFetchR - Subroutine to fetch next record from recordset   *
      *              of ETR (RATM data set)                           *
      *  SrFtDtlR  - Subroutine to format GLATMIPD records and        *
      *              move the details to printer fields               *
      *  SrTableR  - Subroutine to format and move the records of     *
      *              GLATMIPD to table BFCBEXPD                       *
      *  SrCloseR  - Subroutine to close the cursor for ETR           *
      *  SrStmSQLO - Subroutine to get the transaction records in     *
      *              OTPAYDD with I,A or D status and for today       *
      *  SQLFetchO - Subroutine to fetch next record from recordset   *
      *              of ETO (OPAY data set)                           *
      *  SrFtDtlO  - Subroutine to format OTPAYDD records and         *
      *              move the details to printer fields               *
      *  SrTableO  - Subroutine to format and move the records of     *
      *              OTPAYDD to table BFCBEXPD                        *
      *  SrCloseO  - Subroutine to close the cursor for ETO           *
      *  SrStmSQLT - Subroutine to get the teller transaction         *
      *              reference from MITB_JRNEX for OPAY               *
      *  SrStmSQLF - Subroutine to get the FOID from OTPAYDQD         *
      *  SrGetDate - Subroutine to get the current date today         *
      *  SrFmtIAD  - Subroutine to format the I,A, or D status into   *
      *              INSERT, AMEND, or DELETE words                   *
      *  SrCloseT  - Subroutine to close the cursor for ET            *
      *  SrCloseF  - Subroutine to close the cursor for EF            *
      *  SrEndP1   - Subroutine to write End of Report for BF004609P1 *
      *  SrExAud   - Subroutine to write to audit report BF004609AU   *
      *  *INZSR    - Program initialisation                           *
      *  *PSSR     - Error handling subroutine                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas COB Extraction of Teller Transactions
 
     FBF004609P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F
 
      ** Midas COB Extraction of Teller Transactions Audit
 
     FBF004609AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
     F
 
      ** Midas COB Extraction of Teller Transactions File
 
     FBFCBEXPD  O    E           K DISK    INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D
      ** Short DS for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D
      ** File information DS for BF004609P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
     D
      ** File information DS for BF004609AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D
      ** DS for SQL cursor ETR
     D dsETR           DS
     D RMidasTxnRef            1     15
     D RFrontOfficeID         16     35
     D RTxnType               36     37
     D RTxnSubtype            38     42
     D RChangeType            43     43
     D RTimeStamp             44     69
     D RWipStatus             70     70
     D
      ** DS for SQL cursor ETO
     D dsETO           DS
     D OMidasTxnRef            1     15
     D OFrontOfficeID         16     35
     D OTxnType               36     37
     D OTxnSubtype            38     42
     D OChangeType            43     43
     D OTimeStamp             44     69
     D OAuthInd               70     70
     D
      ** DS for SQL cursor ET
     D dsET            DS
     D MTelTxnRef              1     20
     D
      ** DS for SQL cursor EF
     D dsEF            DS
     D MOpayFoid               1     20
     D
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D
      ** Parameters for ZSFILE
     D PSENTY          S              3
     D PSFILE          S             10
     D PZSNUM          S              6  0
     D PZSERR          S              1
     D PSEQ            S              5A
     D
     D RetCode         S              7A
     D Option          S              7A
     D WRun            S              1A
     D WCount          S              3P 0
     D StmSQLR         S           2000A
     D StmSQLO         S           2000A
     D StmSQLT         S           2000A
     D StmSQLF         S           2000A
     D SQLStmR         S           2000A
     D SQLStmO         S           2000A
     D WRTMCtr         S              5  0 INZ(*ZEROS)
     D WOPYCtr         S              5  0 INZ(*ZEROS)
     D CurTMST         S             26A
     D CurDate         S             10A
     D VarCHTP         S              1A
     D FmtCHTP         S              6A
     D ChkAUTR         S              1A
     D ChkAUTO         S              1A
     D ChkDate         S             10A
     D LenTxnRef       S              2  0
     D FinTxnRef       S              2  0
     D MTREF           S             20A
     D VarMREF         S             20A
     D ConApos         C                   CONST('''')
     D VarApos         S              1A
     D FinMREF         S             22A
     D
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
     C
     C                   EXSR      SrGetDate
     C                   EXSR      SrStmSQLR
     C
     C                   DOW       SQLCODE = *ZEROS
     C                   EXSR      SQLFetchR
     C                   IF        SQLCODE = *ZEROS
     C                   MOVEL     RTimeStamp    ChkDate
     C                   MOVE      RWipStatus    ChkAUTR
     C                   IF        CurDate = ChkDate AND
     C                             ChkAUTR <> 'X'
     C                   EXSR      SrFtDtlR
     C                   EXSR      SrTableR
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C
     C                   EXSR      SrCloseR
     C                   EXSR      SrStmSQLO
     C
     C                   DOW       SQLCODE = *ZEROS
     C                   EXSR      SQLFetchO
     C                   IF        SQLCODE = *ZEROS
     C                   MOVEL     OTimeStamp    ChkDate
     C                   MOVE      OAuthInd      ChkAUTO
     C                   IF        CurDate = ChkDate AND
     C                             ChkAUTO <> 'Y'
     C                   EXSR      SrFtDtlO
     C                   EXSR      SrTableO
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C
     C                   EXSR      SrCloseO
     C                   EXSR      SrEndP1
     C                   EXSR      SrExAud
     C
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetDate - Subroutine to get the current date today         *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrGetDate     BEGSR
     C
     C/EXEC SQL
     C+ SET : CurTMST = CURRENT TIMESTAMP
     C/END-EXEC
     C                   MOVEL     CurTMST       CurDate
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrStmSQLT - Subroutine to get the teller transaction         *
      *              reference from MITB_JRNEX for OPAY               *
      *                                                               *
      *  Called by: SrFtDtlO                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrStmSQLT     BEGSR
     C
     C                   EVAL      FinMREF = *BLANKS
     C                   MOVEL     ConApos       VarApos
     C                   MOVEL     VarApos       FinMREF
     C     FinMREF       CAT       VarMREF:0     FinMREF
     C                   EVAL      FinMREF = %TRIM(FinMREF) + VarApos
     C
     C                   EVAL      StmSQLT = 'SELECT MITTRE ' +
     C                             'FROM MITB_JRNEX ' +
     C                             'WHERE MIHREF = ' + FinMREF
     C
     C/EXEC SQL
     C+ PREPARE STATEMENTT
     C+   FROM :StmSQLT
     C/END-EXEC
     C
     C/EXEC SQL
     C+ DECLARE ET CURSOR
     C+   FOR STATEMENTT
     C/END-EXEC
     C
     C/EXEC SQL
     C+  OPEN ET
     C/END-EXEC
     C
     C/EXEC SQL
     C+  FETCH NEXT FROM ET INTO :dsET
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrStmSQLF - Subroutine to get the FOID from OTPAYDQD         *
      *                                                               *
      *  Called by: SrFtDtlO                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrStmSQLF     BEGSR
     C
     C                   EVAL      StmSQLF = 'SELECT OTFRID FROM ' +
     C                             'OTPAYDQD WHERE OTPREF = ' + FinMREF
     C
     C/EXEC SQL
     C+ PREPARE STATEMENTF
     C+   FROM :StmSQLF
     C/END-EXEC
     C
     C/EXEC SQL
     C+ DECLARE EF CURSOR
     C+   FOR STATEMENTF
     C/END-EXEC
     C
     C/EXEC SQL
     C+  OPEN EF
     C/END-EXEC
     C
     C/EXEC SQL
     C+  FETCH NEXT FROM EF INTO :dsEF
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrStmSQLR - Subroutine to get the transaction records in     *
      *              GLATMIPD with I,A or D status and for today      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrStmSQLR     BEGSR
     C                   EVAL      StmSQLR = 'SELECT R1TREF, R1FRNT, ' +
     C                             'R1TRTY, R1TRST, ' +
     C                             'R1CHTP, R1TMST, R1STAT FROM ' +
     C                             'GLATMIPD' +
     C                             ' WHERE EXISTS(SELECT * FROM ' +
     C                             'MITB_JRNEX' + ' WHERE ' +
     C                             'MITB_JRNEX.MIHREF = ' +
     C                             'GLATMIPD.R1TREF)'
     C
     C/EXEC SQL
     C+ PREPARE STATEMENT1
     C+   FROM :StmSQLR
     C/END-EXEC
     C
     C/EXEC SQL
     C+ DECLARE ETR CURSOR
     C+   FOR STATEMENT1
     C/END-EXEC
     C
     C/EXEC SQL
     C+  OPEN ETR
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrStmSQLO - Subroutine to get the transaction records in     *
      *              OTPAYDD with I,A or D status and for today       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrStmSQLO     BEGSR
     C
     C                   EVAL      StmSQLO = 'SELECT PREF, FRNT, ' +
     C                             'PYTP, PYST, CHTP, ' +
     C                             'TMST, AUIN FROM ' +
     C                             'OTPAYDD' +
     C                             ' WHERE EXISTS(SELECT * FROM ' +
     C                             'MITB_JRNEX' + ' WHERE ' +
     C                             'MITB_JRNEX.MIHREF = ' +
     C                             'OTPAYDD.PREF)'
     C
     C/EXEC SQL
     C+ PREPARE STATEMENT2
     C+   FROM :StmSQLO
     C/END-EXEC
     C
     C/EXEC SQL
     C+ DECLARE ETO CURSOR
     C+   FOR STATEMENT2
     C/END-EXEC
     C
     C/EXEC SQL
     C+  OPEN ETO
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SQLFetchR - Subroutine to fetch next record from recordset   *
      *              of ETR (RATM data set)                           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SQLFetchR     BEGSR
     C
     C/EXEC SQL
     C+  FETCH NEXT FROM ETR INTO :dsETR
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SQLFetchO - Subroutine to fetch next record from recordset   *
      *              of ETO (OPAY data set)                           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SQLFetchO     BEGSR
     C
     C/EXEC SQL
     C+  FETCH NEXT FROM ETO INTO :dsETO
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFtDtlR - Subroutine to format GLATMIPD records and         *
      *             move the details to printer fields                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SrRCFP1, SrFmtIAD                                     *
      *                                                               *
      *****************************************************************
     C     SrFtDtlR      BEGSR
     C
      ** Open and register P1 report via RCF
     C
     C                   IF        NOT %OPEN(BF004609P1)
     C                   OPEN      BF004609P1
     C                   EXSR      SrRCFP1
     C                   WRITE     HEADP1
     C                   ENDIF
     C
     C                   EVAL      RMREF   =  RMidasTxnRef
     C
     C                   EVAL      LenTxnRef = %LEN(RFrontOfficeID)
     C     ' '           CHECKR    RFrontOfficeIDFinTxnRef
     C                   EVAL      LenTxnRef = FinTxnRef - 2
     C                   EVAL      MTREF = %SUBST(RFrontOfficeID:1:LenTxnRef)
     C
     C                   EVAL      RTREF   =  MTREF
     C                   EVAL      RFRNT   =  RFrontOfficeID
     C                   EVAL      RAPI    =  'ACCOUNT TRANSFER'
     C                   EVAL      RTTYP   =  RTxnType
     C                   EVAL      RSTYP   =  RTxnSubtype
     C
     C                   EVAL      VarCHTP =  RChangeType
     C                   EXSR      SrFmtIAD
     C
     C                   EVAL      RCHTP   =  FmtCHTP
     C                   EVAL      RTMST   =  RTimeStamp
     C
     C                   IF        OFLLN1 <= PRTLN1 + 4
     C                   WRITE     HEADP1
     C                   ENDIF
     C
     C                   WRITE     DETAIL1
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFtDtlO - Subroutine to format OTPAYDD records and          *
      *             move the details to printer fields                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SrRCFP1, SrStmSQLT, SrStmSQLF, SrFmtIAD               *
      *                                                               *
      *****************************************************************
     C     SrFtDtlO      BEGSR
     C
      ** Open and register P1 report via RCF
     C
     C                   IF        NOT %OPEN(BF004609P1)
     C                   OPEN      BF004609P1
     C                   EXSR      SrRCFP1
     C                   WRITE     HEADP1
     C                   ENDIF
     C
     C                   EVAL      RMREF   =  OMidasTxnRef
     C
     C                   EVAL      VarMREF =  OMidasTxnRef
     C
     C                   EXSR      SrStmSQLT
     C                   EXSR      SrCloseT
     C                   EXSR      SrStmSQLF
     C                   EXSR      SrCloseF
     C
     C                   EVAL      RTREF   =  MTelTxnRef
     C                   EVAL      RFRNT   =  MOpayFoid
     C                   EVAL      RAPI    =  'OUTGOING PAYMENT'
     C                   EVAL      RTTYP   =  OTxnType
     C                   EVAL      RSTYP   =  OTxnSubtype
     C
     C                   EVAL      VarCHTP =  OChangeType
     C                   EXSR      SrFmtIAD
     C
     C                   EVAL      RCHTP   =  FmtCHTP
     C                   EVAL      RTMST   =  OTimeStamp
     C
     C                   IF        OFLLN1 <= PRTLN1 + 4
     C                   WRITE     HEADP1
     C                   ENDIF
     C
     C                   WRITE     DETAIL1
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFmtIAD - Subroutine to format the I,A, or D status into    *
      *             INSERT, AMEND, or DELETE words                    *
      *                                                               *
      *  Called by: SrFtDtlR, SrFtDtlO                                *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrFmtIAD      BEGSR
     C
     C                   IF        VarCHTP = 'I'
     C                   EVAL      FmtCHTP = 'INSERT'
     C                   ELSEIF    VarCHTP = 'A'
     C                   EVAL      FmtCHTP = 'AMEND'
     C                   ELSEIF    VarCHTP = 'D'
     C                   EVAL      FmtCHTP = 'DELETE'
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTableR - Subroutine to format and move the records of      *
      *             GLATMIPD to table BFCBEXPD                        *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrTableR      BEGSR
     C
     C                   EVAL      WRTMCtr = WRTMCtr + 1
     C
     C                   EVAL      REMREF   =  RMidasTxnRef
     C                   EVAL      RETREF   =  MTREF
     C                   EVAL      REFRNT   =  RFrontOfficeID
     C                   EVAL      REAPI    =  'ACCOUNT TRANSFER'
     C                   EVAL      RETTYP   =  RTxnType
     C                   EVAL      RESTYP   =  RTxnSubtype
     C                   EVAL      RECHTP   =  FmtCHTP
     C                   EVAL      RETMST   =  RTimeStamp
     C
     C                   WRITE     BFCBEXD0
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTableO - Subroutine to format and move the records of      *
      *             OTPAYDD to table BFCBEXPD                         *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrTableO      BEGSR
     C
     C                   EVAL      WOPYCtr = WOPYCtr + 1
     C
     C                   EVAL      REMREF   =  OMidasTxnRef
     C                   EVAL      RETREF   =  MTelTxnRef
     C                   EVAL      REFRNT   =  MOpayFoid
     C                   EVAL      REAPI    =  'OUTGOING PAYMENT'
     C                   EVAL      RETTYP   =  OTxnType
     C                   EVAL      RESTYP   =  OTxnSubtype
     C                   EVAL      RECHTP   =  FmtCHTP
     C                   EVAL      RETMST   =  OTimeStamp
     C
     C                   WRITE     BFCBEXD0
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCloseR - Subroutine to close the cursor for ETR            *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrCloseR      BEGSR
     C
     C/EXEC SQL
     C+  CLOSE ETR
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCloseO - Subroutine to close the cursor for ETO            *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrCloseO      BEGSR
     C
     C/EXEC SQL
     C+  CLOSE ETO
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCloseT - Subroutine to close the cursor for ET             *
      *                                                               *
      *  Called by: SrFtDtlO                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrCloseT      BEGSR
     C
     C/EXEC SQL
     C+  CLOSE ET
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCloseF - Subroutine to close the cursor for EF             *
      *                                                               *
      *  Called by: SrFtDtlO                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrCloseF      BEGSR
     C
     C/EXEC SQL
     C+  CLOSE EF
     C/END-EXEC
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEndP1 - Subroutine to write End of Report for BF004609P1    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrEndP1       BEGSR
     C
     C                   IF        %OPEN(BF004609P1)
     C
     C                   IF        OFLLN1 <= PRTLN1 + 3
     C                   WRITE     HEADP1
     C                   ENDIF
     C
     C                   WRITE     TRAILP1
     C                   CLOSE     BF004609P1
     C
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExAud - Subroutine to write to audit report BF004609AU      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrRCFAU                                                *
      *                                                               *
      *****************************************************************
     C     SrExAud       BEGSR
     C
     C                   EXSR      SrRCFAU
     C                   WRITE     HEADAU
     C                   IF        (WRTMCtr = 0) AND (WOPYCtr = 0)
     C                             AND (*INU7 = *OFF)
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RBFRTM = WRTMCtr
     C                   EVAL      RBFOPY = WOPYCtr
     C                   WRITE     CONTROL
     C                   ENDIF
     C
     C                   IF        (*INU7)
     C                   WRITE     DBERROR
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFP1 - Register the P1 Printer File via RCF                *
      *                                                               *
      * Called by: SrFtDtlR, SrFtDtlO                                 *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BEGSR
     C
     C                   Z-ADD     SFNUM1        PZSNUM
     C
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
     C
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFAU - Subroutine to register BF004609AU via RCF           *
      *                                                               *
      * Called by: SrExAud                                            *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
     C     SrRCFAU       BEGSR
     C
     C                   Z-ADD     SFNUMU        PZSNUM
     C
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
     C
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
     C
      ** Initialize program name
     C                   EVAL      DBPGM = 'BF004609'
     C
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       RetCode
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY
     C
      ** Database Error
     C                   IF        RetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = Option
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
     C
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
     C
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
