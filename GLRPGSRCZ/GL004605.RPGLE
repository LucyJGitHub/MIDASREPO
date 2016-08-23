     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Forward Account Transfer Job')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004605 - Midas GL Forward Account Transfer Job             *
      *                                                               *
      *  Function:  This program will monitor the response from the   *
      *             specified reply queue of the submitted Forward    *
      *             Account Transfer Records                          *
      *                                                               *
      *  Called By: GLC004605 - Forward Account Transfer Job          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR1075388          Date 21Nov13               *
      *  Prev Amend No. CRE067             Date 05Oct10               *
      *                 BUG28036           Date 16Aug10               *
      *                 BUG27831B          Date 09Aug10               *
      *                 BUG27831A *CREATE  Date 03Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1075388 - Account transfer fees - net (Child:AR1075389)    *
      *              Applied for MD-23536 (Recompile)                 *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG28036 - Only send forward transfers with value date       *
      *             within the period of balances                     *
      *  BUG27831B - Define Messge Queue Manager and Forward          *
      *              ACcount transfer job run time                    *
      *  BUG27831A - Forward Account Transfer Processing              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    30         Printer Style Indicator                         *
      *    60         Scan Indicator for <RATM>                       *
      *    61         Scan Indicator for <R1TREF>                     *
      *    62         Scan Indicator for <R1EXDT>                     *
      *    63         Scan Indicator for <error>                      *
      *    64         Scan Indicator for <overridableError>           *
      *    80         No Details to Report Indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRInitChk    -  Initial processing check in GLFTRVPD          *
      * SRProcMsg    -  Process message from MQ                       *
      * SRDelayChk   -  Delay/Job run time check                      *
      * SRProcRpt    -  Report Processing                             *
      * SRFmtDate    -  Format Execution Date                         *
      * SRWriteDet   -  Write Details to File                         *
      * SRCallMQIO   -  Call to GPMQMIO                               *
      * SRError1     -  Subroutine to process error message           *
      * SRError2     -  Subroutine to process overridable errors      *
      * SRPutMQ      -  Return message to MQ during Error             *
      * SRReportDet1 -  Report details from file (P1)                 *
      * SRReportDet2 -  Report details from file (P2)                 *
      * SRPrtOvr     -  Subroutine to check for print overflow (P1)   *
      * SRPrtOvr2    -  Subroutine to check for print overflow (P2)   *
      * SRAudit      -  Audit processing                              *
      * SRRCFP1      -  Subroutine to register the P1 Printer File    *
      * SRRCFP2      -  Subroutine to register the P2 Printer File    *
      * SRRCFAU      -  Subroutine to register the AU Printer File    *
      * *PSSR        -  Error processing                              *
      * *INZSR       -  Initialise                                    *
      *                                                               *
      *****************************************************************
 
     FGLFTRVL0  IF   E           K DISK    INFSR(*PSSR)
      ** GL Forward Transfer List
 
     FGLFTRVL1  UF   E           K DISK    RENAME(GLFTRVD0:GLFTRVD1)
     F                                     PREFIX(A_)
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      ** GL Forward Transfer List
 
     FGLATMIL5  IF   E           K DISK    INFSR(*PSSR)
      ** GL Account Transfer Manual Input
 
     FSDABCIPD  IF   E           K DISK    INFSR(*PSSR)
      ** Retail Account Balance Check ICD File
 
     FGLFLTRL1  IF   E           K DISK    RENAME(GLFLTRD0:GLFLTR1) INFSR(*PSSR)
     F                                     PREFIX(I_)
      ** GL Failed Account Transfer Extract File
 
     FGLFLTRPD  O    E             DISK    RENAME(GLFLTRD0:GLFLTRF) INFSR(*PSSR)
     F                                     PREFIX(O_) COMMIT
      ** GL Failed Account Transfer Extract File
 
     FGL004605P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      ** GL Failed Account Transfer Report - with errors
 
     FGL004605P2O    E             PRINTER USROPN
     F                                     INFDS(SPOOL2)
      ** GL Failed Account Transfer Report - no response
 
     FGL004605AUO    E             PRINTER INFDS(SPOOLU)
      ** GL Failed Account Transfer Report - Audit
 
      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** File information data structure for GL004605AU
 
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** File information data structure for GL004605P1
 
     D SPOOL1          DS
     D  OPNIN1                 9      9
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File information data structure for GL004605P2
 
     D SPOOL2          DS
     D  OPNIN2                 9      9
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank ICD Details
 
     D GLFLTR        E DS                  EXTNAME(GLFLTRPD:*OUTPUT)
      **  External data structures for Forward Transfer List
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
 
     D                 DS
     D WDay7C                  1      2  0
     D WMonth7C                3      5
     D WYear7C                 6      7  0
     D WExdt7C                 1      7
 
     D                 DS
     D PDay                    1      2
     D PMonth                  3      4
     D PYear                   5      8
     D PExdt                   1      8
 
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRtcd           S              7A
     D POptn           S              7A
     D PErrMsg         S             30A
     D PRequest        S             10A
     D PQueueNm        S             48A
     D PMsgBuf         S          32000A
     D P@Key           S              4A
     D PWipQueue       S             48A
     D PMQMgr          S             48A                                                   BUG27831B
     D PCommand        S           2764A   INZ('DLYJOB DLY(30)')
     D PLength         S             15  5
     D PErrorFlag      S              1A
 
     D PSEQ            S              5A
     D PENTY           S              3A
     D PZSERR          S              1A
     D PZSNUM          S              6  0
     D PSFILE          S             10A
     D PZDAYN          S              5  0
     D PZDTE6          S              6  0
     D PZDTE7          S              7
 
     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          S             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200
 
     D UP              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D LO              C                   'abcdefghijklmnopqrstuvwxyz'
     D WTag1           C                   CONST('<RATM>')
     D WTag2           C                   CONST('<R1TREF>')
     D WTag3           C                   CONST('<R1EXDT>')
     D WTag4           C                   CONST('<error>')
     D WTag5           C                   CONST('<overridableError>')
     D WTag6           C                   CONST('<description>')
     D WTag7           C                   CONST('</description>')
 
     D WkTref          S             15A
     D WkDate          S              5P 0
     D WkNewTref       S             15A
     D WkNewExdt       S              5P 0
 
     D WExdt18C        S             18
     D WExdt6C         S              6
     D WMonthName      S              3
     D WMonthNum       S              2S 0
     D WTrefNum        S              5S 0
     D WExdtNum        S              5S 0
     D WErr1Num        S              5S 0
     D WErr2Num        S              5S 0
     D Wk1             S              5S 0
     D Wk2             S              5S 0
     D WCount1         S              5S 0
     D WCount2         S              5S 0
     D WCount3         S              5S 0
     D WRQDLN          S              3S 0
     D WDIFLN          S              3S 0
     D WkJobTime       S              5S 0
     D*WkEndTime       S               T                                                    BUG28036
     D*WkCurTime       S               T                                                    BUG28036
     D WkEndTime       S               Z                                                    BUG28036
     D WkCurTime       S               Z                                                    BUG28036
     D WkTmp2s0        S              2S 0                                                  BUG28036
 
     D WkBlankMsg      S              1
     D WkReturnMsg     S              1
     D WkLoopPgm       S              1
     D WRun            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SRInitChk
 
     C                   DOW       WkLoopPgm = 'Y'
     C                   EXSR      SRProcMsg
     C                   EXSR      SRDelayChk
     C                   ENDDO
 
     C                   EXSR      SRProcRpt
     C                   EXSR      SRAudit
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitChk - Check if there are records in GLFTRVPD           *
      *                                                               *
      *****************************************************************
     C     SRInitChk     BEGSR
 
     C                   EVAL      WkLoopPgm = 'Y'
     C                   EVAL      WCount1 = *ZERO
     C                   EVAL      WCount2 = *ZERO
     C                   EVAL      WCount3 = *ZERO
 
      ** Check if there are records to be processed in GLFTRVPD
 
     C     *LOVAL        SETLL     GLFTRVL0
     C                   READ      GLFTRVL0
     C                   IF        %EOF(GLFTRVL0)
     C                   EXSR      SRAudit
     C                   ELSE
     C                   DOW       NOT %EOF(GLFTRVL0)
     C                   EVAL      WCount1 = WCount1 + 1
     C                   READ      GLFTRVL0
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcMsg - Process message from MQ                          *
      *                                                               *
      *****************************************************************
     C     SRProcMsg     BEGSR
 
     C                   EVAL      WkBlankMsg = 'N'
     C                   EVAL      WkReturnMsg = 'N'
 
     C                   DOW       WkBlankMsg = 'N'
 
     C                   EVAL      PRequest = '*OPEN_GET'
     C                   EXSR      SRCallMQIO
 
     C                   EVAL      PRequest = '*GET'
     C                   EXSR      SRCallMQIO
 
      ** End program if no message is read
 
     C                   IF        PMsgBuf = *BLANKS
     C                   EVAL      WkBlankMsg = 'Y'
     C                   ENDIF
 
     C                   EVAL      PRequest = '*CLOSE'
     C                   EXSR      SRCallMQIO
     C                   EVAL      WkReturnMsg = 'Y'
 
     C                   IF        WkBlankMsg = 'N'
 
     C     WTag1         SCAN      PMsgBuf                                60
     C                   IF        *IN60 = *ON
 
      ** Transaction Reference
 
     C     WTag2         SCAN      PMsgBuf       WTrefNum                 61
 
     C                   IF        *IN61 = *OFF
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'MQ Mesg'
     C                   EVAL      DBKey = 'R1TREF'
     C                   EVAL      DBase = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WTrefNum = WTrefNum + 8
     C                   EVAL      WkTref = %SUBST(PMsgBuf:WTrefNum:15)
 
      ** Execution Date
 
     C     WTag3         SCAN      PMsgBuf       WExdtNum                 62
 
     C                   IF        *IN62 = *OFF
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'MQ Mesg'
     C                   EVAL      DBKey = 'R1EXDT'
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WExdtNum = WExdtNum + 8
     C                   EVAL      WExdt18C = %SUBST(PMsgBuf:WExdtNum:18)
     C                   EXSR      SRFmtDate
 
     C     KyTranEx      CHAIN     GLFTRVL1
     C                   IF        %FOUND(GLFTRVL1)
     C                   EVAL      A_TRRCVD = 'Y'
 
      ** Perfom additional processing if error is encountered
 
     C     WTag4         SCAN      PMsgBuf       WErr1Num                 63
     C     WTag5         SCAN      PMsgBuf       WErr2Num                 64
     C                   IF        *IN63 = *ON  OR
     C                             *IN64 = *ON
 
     C                   EVAL      A_TRRERR = 'Y'
     C                   EXSR      SRWriteDet
     C                   EXSR      SRError1
     C                   EXSR      SRError2
 
     C                   ENDIF
 
     C                   UPDATE    GLFTRVD1
 
     C                   ENDIF
     C                   COMMIT
 
     C                   ELSE
 
     C                   EVAL      WkReturnMsg = 'N'
     C                   EXSR      SRPutMQ
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelayChk - Issue a delay if not all records in GLFTRVPD    *
      *               were processed. If job run time exceeds system  *
      *               value, end job.                                 *
      *                                                               *
      *****************************************************************
     C     SRDelayChk    BEGSR
 
      ** Check if there are records to be processed in GLFTRVPD
 
     C     *LOVAL        SETLL     GLFTRVL1
     C                   READ      GLFTRVL1
 
     C                   IF        %EOF(GLFTRVL1)
     C                   EVAL      WkLoopPgm = 'N'
     C                   ELSE
 
     C                   TIME                    WkCurTime
     C                   EVAL      WkJobTime = %DIFF(WkCurTime:WkEndTime:*MN)
     C                   IF        WkJobTime >= 0
     C                   EVAL      WkLoopPgm = 'N'
     C                   ELSE
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCommand
     C                   PARM      80            PLength
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcRpt - Issue a report for all records written to file   *
      *              GLFLTRPD                                         *
      *                                                               *
      *****************************************************************
     C     SRProcRpt     BEGSR
 
      ** Processing for P1 Report
 
     C                   IF        OPNIN1  = '0'
     C                   EXSR      SRRCFP1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C     *LOVAL        SETLL     GLFLTRL1
     C                   READ      GLFLTRL1
     C                   IF        %EOF(GLFLTRL1)
     C                   EVAL      *IN80 = *OFF
     C                   WRITE     NODTLP1
     C                   ELSE
     C                   EVAL      *IN80 = *ON
     C                   EXSR      SRReportDet1
     C                   ENDIF
 
      ** Write final records and Totals to Report
 
     C                   IF        OPNIN1  <> '0'
     C                   IF        *IN80 = *ON
     C                   EVAL      WRQDLN = 3
     C                   EXSR      SRPrtOvr
     C                   WRITE     TRAILP1
     C                   ENDIF
     C                   CLOSE     GL004605P1
     C                   ENDIF
 
      ** Processing for P2 Report
 
     C                   IF        OPNIN2  = '0'
     C                   EXSR      SRRCFP2
     C                   WRITE     HEADP2
     C                   ENDIF
 
     C     *LOVAL        SETLL     GLFTRVL1
     C                   READ      GLFTRVL1
     C                   IF        %EOF(GLFTRVL1)
     C                   EVAL      *IN80 = *OFF
     C                   WRITE     NODTLP2
     C                   ELSE
     C                   EVAL      *IN80 = *ON
     C                   EXSR      SRReportDet2
     C                   ENDIF
 
      ** Write final records and Totals to Report
 
     C                   IF        OPNIN2  <> '0'
     C                   IF        *IN80 = *ON
     C                   EVAL      WRQDLN = 3
     C                   EXSR      SRPrtOvr2
     C                   WRITE     TRAILP2
     C                   CLOSE     GL004605P2
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDate - Format execution date to date number             *
      *                                                               *
      *****************************************************************
     C     SRFmtDate     BEGSR
 
     C                   IF        %SUBST (WExdt18C:3:1) = *BLANK
 
      ** Date is in DD Month YYYY format
 
     C                   EVAL      PDay   =  %SUBST (WExdt18C:1:2)
     C                   EVAL      WMonthName =  %SUBST (WExdt18C:4:3)
     C                   EVAL      WMonthName =  %XLATE (LO:UP:WMonthName)
     C                   EVAL      WMonthNum = ( %LOOKUP (WMonthName : ZMNM) )
     C                   MOVEL     WMonthNum     PMonth
     C     '<'           SCAN      WExdt18C      WExdtNum
     C                   EVAL      WExdtNum = WExdtNum - 4
     C                   EVAL      PYear = %SUBST(WExdt18C:WExdtNum:4)
 
     C                   ELSE
 
      ** Date is in DDMMMYY format
 
     C     '<'           SCAN      WExdt18C
     C                   IF        %FOUND
     C                   EVAL      WExdt6C = %SUBST(WExdt18C:1:6)
     C                   EVAL      WExdt7C = *BLANK
     C                   MOVE      WExdt6C       WExdt7C
     C                   ENDIF
 
     C                   MOVEL     WDay7C        PDay
     C                   EVAL      WMonthNum = ( %LOOKUP (WMonth7C : ZMNM) )
     C                   MOVEL     WMonthNum     PMonth
     C                   MOVE      WYear7C       Pyear
     C                   IF        WYear7C < 40
     C                   MOVEL     '20'          Pyear
     C                   ELSE
     C                   MOVEL     '19'          Pyear
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALL      'ZDATE11'
     C                   PARM                    PExdt
     C                   PARM      *ZERO         WkDate
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       PErrorFlag
 
     C                   IF        PErrorFlag = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ZDATE11'
     C                   EVAL      DBKey = PExdt
     C                   EVAL      DBase = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteDet - Write details to file                           *
      *                                                               *
      *****************************************************************
     C     SRWriteDet    BEGSR
 
     C     KyTranEx      CHAIN     GLATMIL5
 
     C                   IF        NOT %FOUND (GLATMIL5)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLATMIL5'
     C                   EVAL      DBKey = WkTref + ' ' + %CHAR(WkDate)
     C                   EVAL      DBase = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Populate file fields
 
     C                   EVAL      G1TREF = R1TREF
     C                   EVAL      G1TRTY = R1TRTY
     C                   EVAL      G1TRST = R1TRST
     C                   EVAL      G1BRCA = R1BRCA
     C                   EVAL      G1DBBR = R1DBBR
     C                   EVAL      G1DBCU = R1DBCU
     C                   EVAL      G1DBCY = R1DBCY
     C                   EVAL      G1DBAC = R1DBAC
     C                   EVAL      G1DBSQ = R1DBSQ
     C                   EVAL      G1CRBR = R1CRBR
     C                   EVAL      G1CRCU = R1CRCU
     C                   EVAL      G1CRCY = R1CRCY
     C                   EVAL      G1CRAC = R1CRAC
     C                   EVAL      G1CRSQ = R1CRSQ
     C                   EVAL      G1REJC = *BLANKS
     C                   EVAL      G1EXDT = R1EXDT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCallMQIO - Call GPMQMIO to process messages                *
      *                                                               *
      *****************************************************************
     C     SRCallMQIO    BEGSR
 
     C                   CALL      'GPMQMIO'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PErrMsg
     C                   PARM                    PRequest
     C                   PARM      PWIPQueue     PQueueNm
     C                   PARM                    PMsgBuf
     C                   PARM                    P@Key
     C                   PARM                    PMQMgr                                    BUG27831B
 
     C                   IF        PRtcd <> *BLANKS
     C                             AND WkReturnMsg = 'N'
     C                                    OR
     C                             PerrMsg <> *BLANKS
     C                             AND WkReturnMsg = 'N'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GPMQMIO'
     C                   EVAL      DBKey = PRequest + PErrMsg
     C                   EVAL      DBase = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRError1 - Subroutine to process error message               *
      *                                                               *
      *****************************************************************
     C     SRError1      BEGSR
 
     C                   DOW       *IN63 = *ON
     C                   EVAL      Wk1 = WErr1Num + 7
     C     WTag6         SCAN      PMsgBuf:Wk1   WErr1Num
     C                   EVAL      WErr1Num = WErr1Num + 13
     C     WTag7         SCAN      PMsgBuf:Wk1   Wk1
     C                   EVAL      Wk2 = Wk1 - WErr1Num
 
     C                   EVAL      G1ERRM = %SUBST(PMsgBuf:WErr1Num:Wk2)
     C                   WRITE     GLFLTRF       GLFLTR
 
     C     WTag4         SCAN      PMsgBuf:Wk1   WErr1Num                 63
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRError2 - Subroutine to process error message (Overridable) *
      *                                                               *
      *****************************************************************
     C     SRError2      BEGSR
 
     C                   DOW       *IN64 = *ON
     C                   EVAL      Wk1 = WErr2Num + 7
     C     WTag6         SCAN      PMsgBuf:Wk1   WErr2Num
     C                   EVAL      WErr2Num = WErr2Num + 13
     C     WTag7         SCAN      PMsgBuf:Wk1   Wk1
     C                   EVAL      Wk2 = Wk1 - WErr2Num
 
     C                   EVAL      G1ERRM = %SUBST(PMsgBuf:WErr2Num:Wk2)
     C                   WRITE     GLFLTRF       GLFLTR
 
     C     WTag5         SCAN      PMsgBuf:Wk1   WErr2Num                 64
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutMQ - Return message to MQ during Error                  *
      *                                                               *
      *****************************************************************
     C     SRPutMQ       BEGSR
 
     C                   EVAL      PRequest = '*OPEN_PUT'
     C                   EXSR      SRCallMQIO
     C
     C                   EVAL      PRequest = '*PUT'
     C                   EXSR      SRCallMQIO
     C
     C                   EVAL      PRequest = '*CLOSE'
     C                   EXSR      SRCallMQIO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReportDet1 - Report details from file (P1)                 *
      *                                                               *
      *****************************************************************
     C     SRReportDet1  BEGSR
 
     C                   EVAL      WkNewTref = *BLANKS
     C                   EVAL      WkNewExdt = *ZERO
     C                   DOW       NOT %EOF(GLFLTRL1)
 
     C                   EVAL      *IN30 = *OFF
     C                   IF        WkNewTref <> I_G1TREF OR
     C                             WkNewExdt <> I_G1EXDT
 
     C                   EVAL      WkNewTref = I_G1TREF
     C                   EVAL      WkNewExdt = I_G1EXDT
     C                   EVAL      *IN30 = *ON
     C                   EVAL      WCount2 = WCount2 + 1
 
      ** Populate report fields
 
     C                   EVAL      RTREF = I_G1TREF
 
      ** Reformat Execution Date to DDMMMYY
 
     C                   CALL      'ZDATE2'
     C                   PARM      I_G1EXDT      PZDAYN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PZDTE6
     C                   PARM      *BLANKS       PZDTE7
     C                   MOVEL     PZDTE7        REXDT
 
     C                   EVAL      RTRTY = I_G1TRTY
     C                   EVAL      RTRST = I_G1TRST
     C                   EVAL      RDBBR = I_G1DBBR
     C                   EVAL      RDBCU = I_G1DBCU
     C                   EVAL      RDBCY = I_G1DBCY
     C                   MOVEL     I_G1DBAC      RDBAC
     C                   MOVEL     I_G1DBSQ      RDBSQ
     C                   EVAL      RCRBR = I_G1CRBR
     C                   EVAL      RCRCU = I_G1CRCU
     C                   EVAL      RCRCY = I_G1CRCY
     C                   MOVEL     I_G1CRAC      RCRAC
     C                   MOVEL     I_G1CRSQ      RCRSQ
 
     C                   EVAL      WRQDLN = 3
     C                   EXSR      SRPrtOvr
     C                   WRITE     DETAIL1
     C                   ENDIF
 
     C                   EVAL      RERRM = I_G1ERRM
     C                   EVAL      WRQDLN = 2
     C                   EXSR      SRPrtOvr
     C                   WRITE     DETAILE
 
     C                   READ      GLFLTRL1
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReportDet2 - Report details from file (P2)                 *
      *                                                               *
      *****************************************************************
     C     SRReportDet2  BEGSR
 
     C                   EVAL      *IN30 = *ON
     C                   DOW       NOT %EOF(GLFTRVL1)
 
     C                   EVAL      WCount3 = WCount3 + 1
     C                   EVAL      WkTref = TRTREF
     C                   EVAL      WkDate = TREXDT
 
     C     KyTranEx      CHAIN     GLATMIL5
 
     C                   IF        NOT %FOUND (GLATMIL5)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLATMIL5'
     C                   EVAL      DBKey = WkTref + ' ' + %CHAR(WkDate)
     C                   EVAL      DBase = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Populate report fields
 
     C                   EVAL      RTREF2 = R1TREF
 
      ** Reformat Execution Date to DDMMMYY
 
     C                   CALL      'ZDATE2'
     C                   PARM      R1EXDT        PZDAYN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PZDTE6
     C                   PARM      *BLANKS       PZDTE7
 
     C                   MOVEL     PZDTE7        REXDT2
     C                   EVAL      RTRTY2 = R1TRTY
     C                   EVAL      RTRST2 = R1TRST
     C                   EVAL      RDBBR2 = R1DBBR
     C                   EVAL      RDBCU2 = R1DBCU
     C                   EVAL      RDBCY2 = R1DBCY
     C                   MOVEL     R1DBAC        RDBAC2
     C                   MOVEL     R1DBSQ        RDBSQ2
     C                   EVAL      RCRBR2 = R1CRBR
     C                   EVAL      RCRCU2 = R1CRCU
     C                   EVAL      RCRCY2 = R1CRCY
     C                   MOVEL     R1CRAC        RCRAC2
     C                   MOVEL     R1CRSQ        RCRSQ2
 
     C                   EVAL      WRQDLN = 3
     C                   EXSR      SRPrtOvr2
     C                   WRITE     DETAIL2
 
     C                   READ      GLFTRVL1
     C                   EVAL      *IN30 = *OFF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrtOvr - Subroutine to check for print overflow (P1)        *
      *                                                               *
      *****************************************************************
     C     SRPrtOvr      BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
 
     C                   EVAL      WDIFLN   =   OFLLN1 - PRTLN1
     C                   IF        WDIFLN   <=  WRQDLN
     C                   WRITE     HEADP1
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrtOvr2 - Subroutine to check for print overflow (P2)       *
      *                                                               *
      *****************************************************************
     C     SRPrtOvr2     BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
 
     C                   EVAL      WDIFLN   =   OFLLN2 - PRTLN2
     C                   IF        WDIFLN   <=  WRQDLN
     C                   WRITE     HEADP2
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program. *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   EVAL      RCOUNT1 = WCount1
     C                   EVAL      RCOUNT2 = WCount2
     C                   EVAL      RCOUNT3 = WCount3
     C                   EXSR      SRRCFAU
 
      ** Output Report Header
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** If no records read, Output "No Details" message
      ** else, write file control format
 
     C                   IF        RCOUNT1 = *ZEROS
     C                                  AND
     C                             RCOUNT2 = *ZEROS
     C                                  AND
     C                             RCOUNT3 = *ZEROS
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SRRCFP1       BEGSR
 
     C                   OPEN      GL004605P1
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   Z-ADD     SFNUM1        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANKS       PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP2 - Subroutine to register the P2 Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SRRCFP2       BEGSR
 
     C                   OPEN      GL004605P2
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   Z-ADD     SFNUM2        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PENTY
     C                   PARM      SFILE2        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANKS       PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   EVAL      PZSNUM    =   SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANKS       PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
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
 
     ** Initialise LDA field.
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBase = *ZERO
     C                   EVAL      DBFile = *BLANKS
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBMod = *BLANKS
     C                   EVAL      DBPgm = 'GL004605'
     C                   EVAL      DBProc = *BLANKS
     C                   OUT       LDA
 
      ** Access General Ledger details
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Use queue name defined in system values.
 
     C                   EVAL      P@OP01 = 'MQTransRcvrQueue'
     C                   EVAL      P@OP02 = 'MQQueueMgr'                                   BUG27831B
     C                   EVAL      P@OP03 = 'MQFwdAcctTransPeriod'                         BUG27831B
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C**********         PARM      *BLANKS       P@OP02                                    BUG27831B
     C                   PARM                    P@OP02                                    BUG27831B
     C                   PARM      *BLANKS       P@VL02
     C**********         PARM      *BLANKS       P@OP03                                    BUG27831B
     C                   PARM                    P@OP03                                    BUG27831B
     C                   PARM      *BLANKS       P@VL03
     C                   PARM      *BLANKS       P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM      *BLANKS       P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM      *BLANKS       P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM      *BLANKS       P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM      *BLANKS       P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM      *BLANKS       P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBKey = P@OP01
     C                   EVAL      DBase = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PWIPQueue = P@VL01
     C                   EVAL      PMQMgr    = P@VL02                                      BUG27831B
     C**********         EVAL      WkJobTime = 21600                                       BUG27831B
     C**********         MOVEL     P@VL03        WkJobTime                        BUG27831B BUG28036
     C                   MOVEL     P@VL03        WkTmp2s0                                   BUG28036
     C                   MOVE      WkTmp2s0      WkJobTime                                  BUG28036
     C                   TIME                    WkEndTime
     C**********         ADDDUR    WkJobtime:*S  WkEndtime                                 BUG27831B
     C                   ADDDUR    WkJobtime:*H  WkEndtime                                 BUG27831B
 
     C     KyTranEx      KLIST
     C                   KFLD                    WkTref
     C                   KFLD                    WkDate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
