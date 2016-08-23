     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Tax paid by basket summary')
      *****************************************************************
      *                                                               *
      *  Midas  - Securities Trading Module                           *
      *                                                               *
      *  SE7606 - Midas SE Tax Paid by Basket Summary Report          *
      *                                                               *
      *  Function:  This module will list by depot/tax a total of     *
      *             income received, it will contain the total gross  *
      *             amount, total tax paid, total net amount with     *
      *             subtotals code.                                   *
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
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
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
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  189201 - Additional selection fields                         *
      *  185997 - Report break change.                                *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         End of file - SDCUINL2                          *
      *    03         Error on read of SDCUINL2                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PsSR        - Error processing                              *
      *  *InzSR       - Initialise                                    *
      *  SRInit       - Subroutine to do program initialisation       *
      *  SRProces     - Detail processing                             *
      *  SRFRead      - Processing for first read of the record       *
      *  SRReport     - Process Report lines                          *
      *  SRFmtDet     - Format detail fieds for output to printer file*
      *  SRAcEx       - Accumulate amount values by exemption code    *
      *  SRAcDe       - Accumulate amount values by depot             *
      *  SRFmtTlr     - Format total line fields                      *
      *  SRResetEx    - Reset detail work fields for amount           *
      *  SRResetDe    - Reset trailer work fields for amount          *
      *  SRWP1End     - Subroutine to write end of report             *
      *  SRAudit      - Subroutine to output audit report and end pgm *
      *  SRRcfAu      - Subroutine to register audit prtf via RCF     *
      *  SRRtvCusd    - Subroutine to retrieve customer details       *
      *  SRCurr       - Get currency details                          *
      *  SRFmtAmt     - Format amount fields for output               *
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
     FSDCUINL2  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Tax Paid by Basket Printer File - Detail
     FSE7606P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Tax Paid by Basket Printer File - Audit
     FSE7606AU  O    E             PRINTER INFDS(SPOOLU)
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
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D   ##DFAC      E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D PParm           DS           100
     D  FromDate               1      5  0
     D  ToDate                 6     10  0
     D  SecName               11     20                                                       189201
      *
      ** File Information Data Structure for SE7606P1.
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
      *
      ** File Information Data Structure for SE7606AU.
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
      *
     D WExGRDI         S             15P 0 INZ(*ZERO)
     D WExTxPd         S             15P 0 INZ(*ZERO)
     D WExNTDV         S             15P 0 INZ(*ZERO)
 
     D WDeGRDI         S             15P 0 INZ(*ZERO)
     D WDeTxPd         S             15P 0 INZ(*ZERO)
     D WDeNTDV         S             15P 0 INZ(*ZERO)
 
     D WVSELEC         S              1A   INZ(*BLANKS)
 
     D WTXPD           S             15P 0 INZ(*ZERO)
     D PSeqs           S              5A
     D PMode           S              1A
     D PSEnty          S              3A
     D PZSErr          S              1A
     D PZSNum          S              6P 0
     D PZSNumU         S              6P 0
 
     D PRtcd           S              7A
     D PBRCH           S              3A
     D POptn           S              7A
     D PKeyC           S             10A
     D PKySt           S              7A
     D PCurr           S              3A
 
     D KCustNo         S              6A
 
     D OldCRTT         S              2A
     D OldPBCA         S              3A
     D OldCcy          S              3A
     D OldDPTN         S              6A
     D OldTXBS         S              2A
     D OldEXCD         S              2A
     D OldINCD         S              2A                                        185997
 
     D RqdLn1          S              3P 0
     D DifLn1          S              3P 0
      *
      ** Parameter list for ZSEDITF
     D ZFld15          S             15P 0
     D ZDecs           S              1P 0
     D ZECode          S              1A
     D ZEChar          S              1A
     D ZOut21          S             21A
 
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
     C     *LOVAL        SETLL     SDCUINL2
     C                   EXSR      SRReadR
      *
      ** Database error
      *
     C                   IF        *IN03
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDCUINL2'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WCtr = 'N'
 
     C                   IF        *IN02
     C                   EXSR      SRAudit
     C                   ELSE
      *
      ** Process first read of record
      *
     C                   EVAL      WCtr = 'Y'
     C                   EXSR      SRFRead
     C                   ENDIF
      *
      ** Do while not end of file
      *
     C                   DOW       NOT *IN02
      *
     C                   EXSR      SRReport
      *
     C                   EXSR      SRReadR
      *
      ** If error reading file, write error message then exit.
      *
     C                   IF        *IN03
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*NEXT  '
     C                   EVAL      DBFILE = 'SDCUINL2'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
     C                   EXSR      SRWP1End
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFRead  - Process for First read of the record              *
      *****************************************************************
      *
     C     SRFRead       BEGSR
      *
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SE7606P1
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
      ** Write header record for first read
      *
     C                   EVAL      RCRTY = CUCRTT
     C                   EVAL      RCRTY = CUCRTT
     C                   EVAL      RCCY = CUNCY
     C                   EXSR      SRRtvBrDt
     C                   WRITE     HEAD1
      *
      ** Access currency details of the nominal currency
      *
     C                   EVAL      PCurr = RCCY
     C                   EXSR      SRCurr
      *
      ** Save key fields for heading
      *
     C                   EVAL      OldPBCA = CUPBCA
     C                   EVAL      OldCRTT = CUCRTT
     C                   EVAL      OldCcy = CUNCY
      *
      ** Print sub-heading on the report line
      *
     C                   EVAL      RDPTN = CUDPTN
     C                   MOVEL     CUDPTN        KCustNo
     C                   EXSR      SRRtvCusD
     C                   EVAL      RDRNM = BBCRNM
     C                   WRITE     HEADD1
      *
      ** Save key fields for sub-heading
      *
     C                   EVAL      OldDPTN = CUDPTN
     C                   EVAL      OldTXBs = CUTXBS
     C                   EVAL      OldEXCD = CUEXCD
     C                   EVAL      OldINCD = CUINCD                             185997
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRReport - Process Report lines                              *
      *****************************************************************
      *
     C     SRReport      BEGSR
      *
      ***If*not*change*on*depot*tax*basket*and*exemption*code,*accumulate       185997
      ** If not change on depot tax basket and income code, accumulate          185997
      ** gross payment, Otherwise, print detail for accumulated total
      *
     C                   IF        OldCRTT = CUCRTT AND
     C                             OldCcy = CUNCY   AND
     C                             OldDPTN = CUDPTN AND
     C                             OldTXBs = CUTXBS AND
     C*****                        OldExCd = CUEXCD                             185997
     C                             OldINCD = CUINCD                             185997
     C                   EXSR      SRAcEx
     C                   ELSE
      *
      ** Format detail fields for output.
      *
     C                   EXSR      SRFmtDet
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     7             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
      *
     C     DifLn1        IFLE      RqdLn1
     C                   WRITE     HEAD1
     C                   WRITE     HEADD1
     C                   ENDIF
      *
      ** Write detail field
      *
     C                   WRITE     DETAIL1
      *
      ** Accumulate total fields for depot
      *
     C                   EXSR      SRAcDe
      *
      ** Reset total work fields for exemption code
      *
     C                   EXSR      SRResetEx
      *
      ** Accumulate total fields for the new key field
      *
     C                   EXSR      SRAcEx
      *
     C                   ENDIF
      *
      ** If change on depot, write accumulated total for the depot
      *
     C                   IF        OldDPTN <> CUDPTN OR
     C                             OldCRTT <> CUCRTT OR
     C                             OldCcy <> CUNCY
     C                   EXSR      SRFmtTlr
     C                   WRITE     TRAIL1
     C                   EXSR      SRResetDe
      *
     C                   IF        OldCcy = CUNCY AND
     C                             OldCRTT = CUCRTT
      *
     C                   Z-ADD     8             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
      *
     C     DifLn1        IFLE      RqdLn1
     C                   WRITE     HEAD1
     C                   ENDIF
      *
     C                   EVAL      RDPTN = CUDPTN
     C                   MOVEL     CUDPTN        KCustNo
     C                   EXSR      SRRtvCusD
     C                   EVAL      RDRNM = BBCRNM
     C                   WRITE     HEADD1
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** If change in country of tax treaty or currency, print heading
      *
     C                   IF        OldPBCA <> CUPBCA OR
     C                             OldCRTT <> CUCRTT OR
     C                             OldCcy <> CUNCY
     C                   EVAL      OldPBCA = CUPBCA
     C                   EVAL      RCRTY = CUCRTT
     C                   EVAL      RCCY = CUNCY
     C                   EXSR      SRRtvBrDt
     C                   WRITE     HEAD1
      *
      ** Access currency details of the nominal currency
      *
     C                   EVAL      PCurr = RCCY
     C                   EXSR      SRCurr
      *
      ** Print sub-heading on the report line
      *
     C                   EVAL      RDPTN = CUDPTN
     C                   MOVEL     CUDPTN        KCustNo
     C                   EXSR      SRRtvCusD
     C                   EVAL      RDRNM = BBCRNM
     C                   WRITE     HEADD1
     C                   ENDIF
      *
      ** Save key fields
      *
     C                   EVAL      OldCRTT = CUCRTT
     C                   EVAL      OldCcy  = CUNCY
     C                   EVAL      OldDPTN = CUDPTN
     C                   EVAL      OldTXBs = CUTXBS
     C                   EVAL      OldEXCD = CUEXCD
     C                   EVAL      OldINCD = CUINCD                             185997
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFmtDet - Format detail fields for output to printer file.  *
      *****************************************************************
      *
     C     SRFmtDet      BEGSR
      *
      ** Tax basket
      *
     C                   EVAL      RTXBS = OldTXBS
      *
      ** Exemption code
      ** Income Code                                                            185997
      *
     C                   EVAL      REXCD = OldEXCD
     C                   EVAL      RINCD = OldINCD                              185997
      *
      ** Format Gross dividend
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WExGRDI       ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTGRP
      *
      ** Format Tax Paid
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WExTXPD       ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTXPD
      *
      ** Format Net amount
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WExNTDV       ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTNTP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAcEx   - Accumulate values for detail line.                *
      *****************************************************************
      *
     C     SRAcEx        BEGSR
      *
      ** Gross dividend
      *
     C                   IF        CUPSTP = 'MT'
     C                   EVAL      WExGRDI = WExGRDI + CUDAMT
     C                   ELSE
     C                   EVAL      WExGRDI = WExGRDI + CUGRDI
     C                   ENDIF
      *
      ** Tax Withheld
      *
     C                   EVAL      WTXPD = CUTXWS + CUTXWU
     C                   EVAL      WExTxPd = WExTxPd + WTXPD
      *
      ** Net dividend.
      *
     C                   EVAL      WExNTDV = WExNTDV + CUNTDV
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAcDe   - Accumulate total values for depot                 *
      *****************************************************************
      *
     C     SRAcDe        BEGSR
      *
      ** Gross dividend
      *
     C                   EVAL      WDeGRDI = WDeGRDI + WExGRDI
      *
      ** Tax Withheld
      *
     C                   EVAL      WDeTXPD = WDeTXPD + WExTXPD
      *
      ** Net dividend.
      *
     C                   EVAL      WDeNTDV = WDeNTDV + WExNTDV
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFmtTlr - Format total line fields.                         *
      *****************************************************************
      *
     C     SRFmtTlr      BEGSR
      *
      ** Total gross dividend.
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WDeGRDI       ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTDGR
      *
      ** Total withholding tax.
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WDeTXPD       ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTDTX
      *
      ** Total net dividend.
      *
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVE      WDeNTDV       ZFld15
     C                   Z-ADD     A6NBDP        ZDecs
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RTDNT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRResetEx - Reset Detail work fields                         *
      *****************************************************************
     C     SRResetEx     BEGSR
      *
     C                   EVAL      WExGRDI = *ZERO
     C                   EVAL      WExTXPD = *ZERO
     C                   EVAL      WExNTDV = *ZERO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRResetDe - Reset Trailer work fields                        *
      *****************************************************************
     C     SRResetDe     BEGSR
      *
     C                   EVAL      WDeGRDI = *ZERO
     C                   EVAL      WDeTXPD = *ZERO
     C                   EVAL      WDeNTDV = *ZERO
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
      ** Format detail fields for output.
      *
     C                   EXSR      SRFmtDet
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     7             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
      *
     C     DifLn1        IFLE      RqdLn1
     C                   WRITE     HEAD1
     C                   WRITE     HEADD1
     C                   ENDIF
      *
      ** Write detail field
      *
     C                   WRITE     DETAIL1
      *
      ** Accumulate total fields for depot
      *
     C                   EXSR      SRAcDe
      *
      ** Format total lines, then write total fields for the depot
      *
     C                   EXSR      SRFmtTlr
     C                   WRITE     TRAIL1
      *
      ** Write out ending format.
      *
     C                   WRITE     TRAIL2
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
     C                   OPEN      SE7606AU
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvCusD - Subroutine to retrive customer details.          *
      *****************************************************************
      *
     C     SRRtvCusD     BEGSR
      *
      ** Access customer details.
      ** Customer must exist, standard DBError if customer is not found.
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      KCustNo       PKeyC
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PKeyC
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCurr - Get currency details                                *
      *****************************************************************
     C     SRCurr        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCurr
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
      *  SRReadR - Subroutine to read detail record from file.        *
      *****************************************************************
      *
     C     SRReadR       BEGSR                                                   *** RCFAU  ***
 
     C***********        SELECT                                                               189201
     C***********        WHEN      PMode = '1'                                                189201
      *                                                                                       189201
     C                   DOU       WVSelec = 'Y' OR *IN02 = *ON
     C                   READ      SDCUINL2                             0302
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
     C***********        READ      SDCUINL2                             0302                  189201
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
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSR - Program initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
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
      *                                                                   *
      * *PsSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
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
