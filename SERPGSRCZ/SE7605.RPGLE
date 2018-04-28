     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Tax paid by basket detail')
      *****************************************************************
      *                                                               *
      *  Midas  - Securities Trading Module                           *
      *                                                               *
      *  SE7605 - Midas SE Tax Paid by Basket Detail Report           *
      *                                                               *
      *  Function:  This module will list by depot/tax basket all     *
      *             income received, it should contain the security,  *
      *             date, gross amount, tax paid, net amount and      *
      *             exemption code.                                   *
      *                                                               *
      *  Component of: SEC7610 - Midas SE treaty Withholding Tax      *
      *                          Extract and Report Generation        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189201             Date 25Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185997             Date 08Nov00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  189201 - Additional selection fields                         *
      *  185997 - Report break change.                                *
      *           (CSE023 - Treaty Withholding Tax)                   *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    37         Multibranching ON                               *
      *                                                               *
      *    02         End of file - SDCUINL1                          *
      *    03         Error on read of SDCUINL1                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PsSR        - Error processing                              *
      *  *InzSR       - Initialise                                    *
      *  SRInit       - Subroutine to do program initialisation       *
      *  SRProces     - Detail processing                             *
      *  SRFormat     - Format fields for output to printer file      *
      *  SRFmtAmt     - Format amount for output                      *
      *  SRFmtDat     - Format date for output                        *
      *  SRReport     - Process Report Lines                          *
      *  SRWP1Rec     - Write Detail record to the Report             *
      *  SRWP1End     - Write End of Report                           *
      *  SRAudit      - Subroutine to Output Audit report             *
      *  SRRcfAu      - RCF Processing for SE7605AU                   *
      *                                                               *
      *    The *InzSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD Tax Paid by Basket detail
     FSDCUINL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Tax Paid by Basket Printer File - Detail
     FSE7605P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Tax Paid by Basket Printer File - Audit
     FSE7605AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PsSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D PParm           DS           100
     D  FromDate               1      5  0
     D  ToDate                 6     10  0
     D  SecName               11     20                                                       189201
      *
      ** File Information Data Structure for SE7605P1.
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
      *
      ** File Information Data Structure for SE7605AU.
     D SPOOLU          DS
     D  PSFileU               83     92
     D  SFNumU               123    124B 0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WCtr            S              1A
     D WOpen           S              1A   INZ('N')
     D WTxPd           S             15  0
     D WTTXPD          S             15  0
     D WTGRDI          S             15  0
     D WTNTDV          S             15  0
     D W_TTXPD         S             15  0
     D W_TGRDI         S             15  0
     D W_TNTDV         S             15  0
     D WVSELEC         S              1A   INZ(*BLANKS)
     D WSHead          S              1A   INZ('N')
     D WTOTAL          S              1A   INZ('N')
     D WDTail          S              1A   INZ('N')
 
     D PSeqs           S              5A
     D PSEnty          S              3A
     D PZSErr          S              1A
     D PZSNum          S              6P 0
     D PZSNumU         S              6P 0
 
     D PMode           S              1A
 
     D PRtcd           S              7A
     D PBRCH           S              3A
     D POptn           S              7A
     D PCurr           S              3A
      *
      ** Parameter list for ZSEDITF
     D ZFld15          S             15P 0
     D ZDecs           S              1P 0
     D ZECode          S              1A
     D ZEChar          S              1A
     D ZOut21          S             21A
 
     D OldPBCA         S              3A
     D OldCRTT         S              2A
     D OldCcy          S              3A
     D OldDPTN         S              6A
     D OldTXBS         S              2A
     D*OldEXCD**       S              2A                                        185997
     D OldINCD         S              2A                                        185997
      *
      ** Parameter list for ZDATE2
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
 
     D RqdLn1          S              3P 0
     D DifLn1          S              3P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *InzSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Perform initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Perform detail processing.
      *
     C                   EXSR      SRProces
      *
      ** End Program
      *
     C                   EVAL      *INLR = True
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *  SRInit - Subroutine to do Program Initialisation.            *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RqdLn1
     C                   Z-ADD     0             DifLn1
      *                                                                                       189201
      ** If report to be generated is COB mandatory: Security = blank                         189201
      ** From date = rundate, To date = next working day                                      189201
      *                                                                                       189201
     C                   IF        PMode = '2'                                                189201
     C                   Z-ADD     BJRDNB        FromDate                                     189201
     C                   Z-ADD     BJDNWD        ToDate                                       189201
     C                   EVAL      SecName = *BLANKS                                          189201
     C                   ENDIF                                                                189201
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRProces - Subroutine to do the Detail Processing.           *
      *****************************************************************
      *
     C     SRProces      BEGSR
      *
     C     *LOVAL        SETLL     SDCUINL1
 
     C                   EXSR      SRReadR
      *
      ** Database error
      *
     C                   IF        *IN03
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDCUINL1'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WCtr = 'N'
 
     C                   IF        *IN02
     C                   EXSR      SRAudit
     C                   ELSE
     C                   EVAL      WCtr = 'Y'
     C                   EVAL      OldPBCA = CUPBCA
     C                   EVAL      OldCRTT = CUCRTT
     C                   EVAL      OldCcy = CUNCY
     C                   EVAL      OldDPTN = CUDPTN
     C                   EVAL      OldTXBs = CUTXBS
     C*****              EVAL      OldEXCD = CUEXCD                             185997
     C                   EVAL      OldINCD = CUINCD                             185997
     C                   EVAL      WSHead = 'Y'
     C                   EVAL      WDTail = 'Y'
     C                   ENDIF
      *
      ** Do Until End of File.
      *
     C                   DOU       *IN02
      *
      ** Format fields for output.
     C                   EXSR      SRFormat
      *
      ** Process report lines.
     C                   EXSR      SRReport
 
     C                   EXSR      SRReadR
      *
      ** If error reading file, write error message then exit.
      *
     C                   IF        *IN03
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*NEXT  '
     C                   EVAL      DBFILE = 'SDCUINL1'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
      *
     C                   IF        NOT *IN02
     C                   EVAL      WDTail = 'Y'
     C                   ELSE
     C                   EVAL      WDTail = 'N'
     C                   EVAL      WTOTAL = 'Y'
     C                   ENDIF
      *
      ***If*Depot,*tax*basket*or*exemption*code*changes,***************         185997
      ** If Depot, tax basket or income code changes.                           185997
      ** then print sub-heading
      *
     C                   IF        OldDPTN <> CUDPTN OR
     C                             OldTXBS <> CUTXBS OR
     C*****                        OldEXCD <> CUEXCD                            185997
     C                             OldINCD <> CUINCD                            185997
     C                   EVAL      OldTXBS = CUTXBS
     C*****              EVAL      OldEXCD = CUEXCD                             185997
     C                   EVAL      OldINCD = CUINCD                             185997
     C                   EVAL      OldDPTN = CUDPTN
     C                   EVAL      WTOTAL = 'Y'
     C                   EVAL      WSHead = 'Y'
     C                   Z-ADD     W_TGRDI       WTGRDI
     C                   Z-ADD     W_TTXPD       WTTXPD
     C                   Z-ADD     W_TNTDV       WTNTDV
     C                   EVAL      W_TGRDI = *ZEROS
     C                   EVAL      W_TTXPD = *ZEROS
     C                   EVAL      W_TNTDV = *ZEROS
     C                   ENDIF
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
      *
      ** Write final records and/or totals to report.
      *
     C                   Z-ADD     W_TGRDI       WTGRDI
     C                   Z-ADD     W_TTXPD       WTTXPD
     C                   Z-ADD     W_TNTDV       WTNTDV
      *
     C                   EXSR      SRReport
     C                   EXSR      SRWP1End
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFormat - Format fields for output to printer file.         *
      *****************************************************************
      *
     C     SRFormat      BEGSR
      *
      ** Country of tax treaty
      *
     C                   EVAL      RCRTY = CUCRTT
      *
      ** Nominal currency
      *
     C                   EVAL      RCCY  = CUNCY
      *
      ** Depot
      *
     C                   EVAL      RDPTN = CUDPTN
      *
      ** Tax basket and rate
      *
     C                   EVAL      RTXBS = CUTXBS
 
     C                   MOVE      *BLANKS       ZFld15
     C                   MOVE      CUTXRT        ZFld15
     C                   EVAL      ZDecs = 4
     C                   EVAL      ZECode = ' '
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTXRT
      *
      ***Exemption*Code************************************************         185997
      ** Income Code                                                            185997
      *
     C                   EVAL      REXCD = CUEXCD
     C                   EVAL      RINCD = CUINCD                               185997
      *
      ** Security shortname
      *
     C                   EVAL      RSCTY = CUSECS
     C                   EVAL      RPSTP = CUPSTP
     C                   EVAL      RINCD = CUINCD
      *
      ** Format date for output
      *
     C                   Z-ADD     CUVALD        PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVE      PDateOut      RVALD
      *
      ** Access currency details to get the currency decimal places
      *
     C                   EVAL      PCurr = RCCY
     C                   EXSR      SRCurr
      *
      ** Format Gross dividend
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   IF        CUPSTP = 'MT'
     C                   EVAL      W_TGRDI = W_TGRDI + CUDAMT
     C                   MOVE      CUDAMT        ZFld15
     C                   ELSE
     C                   EVAL      W_TGRDI = W_TGRDI + CUGRDI
     C                   MOVE      CUGRDI        ZFld15
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RGRDI
      *
      ** Format Tax Paid
      *
     C                   EVAL      WTXPD = 0
     C                   EVAL      WTXPD = CUTXWS + CUTXWU
     C                   EVAL      W_TTXPD = W_TTXPD + WTXPD
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WTXPD         ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTXPD
      *
      ** Format Net amount
      *
     C                   EVAL      W_TNTDV = W_TNTDV + CUNTDV
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      CUNTDV        ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RNTAM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFormTO - Format total for output to printer file.          *
      *****************************************************************
      *
     C     SRFormTO      BEGSR
      *
      ** Format Gross dividend total
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WTGRDI        ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTGRDI
      *
      ** Format Tax Paid total
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WTTXPD        ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTTXPD
      *
      ** Format Net amount total
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WTNTDV        ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTNTAM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFmtAmt  - Format amount for output.                        *
      *****************************************************************
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFld15
     C                   PARM                    ZDecs
     C                   PARM                    ZECode
     C                   PARM      *Blanks       ZEChar
     C                   PARM      *Blanks       ZOut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDat - Format date for output.                           *
      *                                                               *
      *****************************************************************
     C     SRFmtDat      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCurr - Get currency details                                *
      *****************************************************************
     C     SRCurr        BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCurr
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRReport - Process Report Lines.                             *
      *****************************************************************
      *
     C     SRReport      BEGSR
      *
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SE7605P1
      *
      ** Ensure Detail Spool File recorded by RCF.
     C                   EVAL      PZSNum = PSFNum1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeqs
     C                   PARM      *BLANKS       PSEnty
     C                   PARM                    PSFile1
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write out the record.
      *
     C                   EXSR      SRWP1Rec
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWP1Rec - Subroutine to Write a Detail record to the Report.*
      *****************************************************************
      *
     C     SRWP1Rec      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     12            RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
 
     C     DifLn1        IFLE      RqdLn1
     C                   EXSR      SRRtvBrDt
     C                   WRITE     HEAD1
     C                   EVAL      WSHEAD = 'Y'
     C                   ENDIF
      *
      ** Write out sub-total for every change of depot/tax basket
      *
     C                   IF        WTOTAL = 'Y'
     C                   EXSR      SRFormTO
     C                   WRITE     DTOTAL1
     C                   EVAL      WTOTAL = 'N'
     C                   EVAL      WTGRDI = *ZEROS
     C                   EVAL      WTTXPD = *ZEROS
     C                   EVAL      WTNTDV = *ZEROS
     C                   ENDIF
      *
     C     OldPBCA       IFNE      CUPBCA
     C     *IN02         ANDEQ     *OFF                                                       189201
     C     OldCRTT       ORNE      CUCRTT
     C     *IN02         ANDEQ     *OFF                                                       189201
     C     OldCcy        ORNE      CUNCY
     C     *IN02         ANDEQ     *OFF                                                       189201
     C                   EVAL      OldPBCA = CUPBCA
     C                   EVAL      OldCRTT = CUCRTT
     C                   EVAL      OldCcy = CUNCY
     C                   EXSR      SRRtvBrDt
     C                   WRITE     HEAD1
     C                   EVAL      WSHEAD = 'Y'
     C                   ENDIF
      *
      ** Write out sub-heading for every change of depot/tax basket
      *
     C                   IF        WSHead = 'Y' AND NOT *IN02
     C                   WRITE     HEADD1
     C                   EVAL      WSHead = 'N'
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   IF        WDTail = 'Y'
     C                   WRITE     DETAIL1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWP1End - Subroutine to Write End of Report.                *
      *****************************************************************
      *
     C     SRWP1End      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
     C     DifLn1        IFLE      RqdLn1
     C                   EXSR      SRRtvBrDt
     C                   WRITE     HEAD1
     C                   ENDIF
      *
      ** Write out ending format.
      *
     C                   WRITE     TRAIL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAudit - Subroutine to Output Audit report and End Program. *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
     C                   OPEN      SE7605AU
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      SRRcfAu
      *
      ** Output Report Header
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = True
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
     C                   IF        WCtr = 'N'
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   EVAL      *INLR = True
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRcfAu - Subroutine to register the AU Printer File via RCF.*
      *****************************************************************
      *
     C     SRRcfAu       BEGSR                                                   *** RCFAU  ***
      *
      ***  Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNumU        PZSNumU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeqs
     C                   PARM      *BLANKS       PSEnty
     C                   PARM                    PSFileU
     C                   PARM                    PZSNumU
     C                   PARM      *BLANK        PZSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = True
     C                   EVAL      *INU8 = True
     C                   EVAL      *INLR = True
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *  SRReadR - Subroutine to read detail record from file.        *
      *****************************************************************
      *
     C     SRReadR       BEGSR                                                   *** RCFAU  ***
 
     C***********        SELECT                                                               189201
     C***********        WHEN      PMode = '1'                                                189201
      *                                                                                       189201
     C                   DOU       WVSelec = 'Y' OR *IN02 = *ON
     C                   READ      SDCUINL1                             0302
      *
      ***Keep*track*of*number*of*records*being*read.                                          189201
      ** Select record for printing if date is within From/To dates and                       189201
      ** if security is not blank, select on all securities                                   189201
      *                                                                                       189201
     C***********        IF        CUVALD >= FromDate AND CUVALD <= Todate                    189201
     C                   IF        ((CUVALD >= FromDate AND                                   189201
     C                             CUVALD <= Todate AND                                       189201
     C                             SecName = *BLANKS) OR                                      189201
     C                             (CUVALD >= FromDate AND                                    189201
     C                             CUVALD <= Todate AND                                       189201
     C                             SecName <> *BLANKS AND                                     189201
     C                             CUSECS = SecName))                                         189201
     C                   EVAL      WVSelec = 'Y'
     C                   ELSE
     C                   EVAL      WVSelec = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
     C***********        OTHER                                                                189201
      ***********                                                                             189201
     C***********        READ      SDCUINL1                             0302                  189201
      ***********                                                                             189201
     C***********        ENDSL                                                                189201
 
     C                   ENDSR                                                   *** RCFAU  ***
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvBrDt - Retrieve branch name.                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvBrDt     BEGSR
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM                    PRtCd
     C                   PARM      '*KEY     '   POptn
     C                   PARM      CUPBCA        PBrch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = CUPBCA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *InzSR - Program initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *****************************************************************
      *
     C     *InzSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSeqs
     C                   PARM                    PMode
     C                   PARM                    PParm
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
      *
      ** Check multi-branching.
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EVAL      *IN37 = *Off
     C                   ELSE
     C                   EVAL      *IN37 = *On
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      * *PsSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *********************************************************************
      *
     C     *PsSR         BEGSR
      *
      ** Check to see that *PsSR has not already been called.
      *
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = True
     C                   EVAL      *INU8 = True
     C                   EVAL      *INLR = True
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
      ** If *PsSR already run, then just end the program here.
      *
     C                   EVAL      *INU7 = True
     C                   EVAL      *INU8 = True
     C                   EVAL      *INLR = True
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
