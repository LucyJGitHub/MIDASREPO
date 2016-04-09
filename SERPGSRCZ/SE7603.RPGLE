     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Allocation per dividend payment full rprt')
      *****************************************************************
      *                                                               *
      *  Midas  - Securities Trading Module                           *
      *                                                               *
      *  SE7603 - SE Allocation per dividend payment full report.     *
      *                                                               *
      *  Function:  This program reports allocation for dividend      *
      *             payments by customer position.                    *
      *             (On request during I/C)                           *
      *                                                               *
      *  Component of: SEC7603                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL029             Date 01Sep03               *
      *                 197280             Date 18May01               *
      *                 193312             Date 18May01               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 194357             Date 11Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 190204             Date 31May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189201             Date 25Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186002             Date 11Nov00               *
      *                 185735             Date 25Oct00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  197280 - Fix 193312 must use PNMP not WTNMP which is a total *
      *  193312 - To avoid Database Error if if event is created      *
      *           by using position settelement I/C option            *
      *           In this case, evnet does not exist in file SEDEVD   *
      *  194357 - If overflow occurs and the last line to be printed  *
      *           is the Total line, retrieve the values of the       *
      *           previous record to display the sub-heading details  *
      *           correctly.                                          *
      *  190204 - Changed Dividend per Unit format from 9N0 to 13N8.  *
      *  189201 - Additional selection fields                         *
      *  186002 - Additional report break by 'Depot', and format      *
      *           total amounts with commas                           *
      *  185735 - Database error occured if position settlement has   *
      *           no tax basket attached to it                        *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PsSR - Error processing                                      *
      * *InzSR - Initialise                                           *
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
      ** SE Position settlements by customer and tax basket details
      ** for retrieve.
     FPOSETW3   IF   E           K DISK    INFSR(*PsSR)
     FSECED     IF   E           K DISK    INFSR(*PsSR)
     FSECORFLC  IF   E           K DISK    INFSR(*PsSR)
     FSECODVL2  IF   E           K DISK    INFSR(*PsSR)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                         193312
      *
      ** Allocation per dividend payment printer file - Audit
     FSE7603AU  O    E             PRINTER INFSR(*PsSR)
     F                                     INFDS(SPOOLU)
      *
      ** Allocation per dividend payment printer file - Detail
     FSE7603P1  O    E             PRINTER USROPN
     F                                     INFSR(*PsSR)
     F                                     INFDS(SPOOL1)
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** DS for access programs - short data structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DS for access programs - short data structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Program Status Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** File Information Data Structure for SE7603P1.
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
      *
      ** File Information Data Structure for SE7603AU.
     D SPOOLU          DS
     D  PSFileU               83     92
     D  SFNumU               123    124B 0
      *
     D PPARM           DS           100
     D  SecSName               1     10A
     D  DateOPay              11     15  0
     D  EvenType              16     17A
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  MultiBrch             37     37
     D  ErrorOnFl             88     88
     D  EndOfFile             89     89
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRun            S              1A   INZ(*BLANK)
     D WOpen           S              1A   INZ('N')
     D WSHead          S              1A   INZ('N')
     D WDHead          S              1A   INZ('N')
     D WDTail          S              1A   INZ('N')
     D WTotal          S              1A   INZ('N')
 
     D WTNMP           S             15P 0 INZ(*ZERO)
     D WTAMD           S             15P 0 INZ(*ZERO)
     D WTTAX           S             15P 0 INZ(*ZERO)
     D WTSAT           S             15P 0 INZ(*ZERO)
 
     D WPTAX           S             13P 0 INZ(*ZERO)
     D WNDIV           S             13P 0 INZ(*ZERO)
     D WCpRte          S             11P 7 INZ(*ZERO)
     D WCpRatA         S             13A   INZ(*BLANKS)
     D WPrtRec         S              1A   INZ('Y')
     D WRcPrted        S              1A   INZ('N')
     D WRqstNPag       S              1A   INZ(' ')
     D WPevt           S              2A
     D WDate           S              5A
 
     D WNBDP           S              1  0
 
     D PSeqs           S              5A
     D PMode           S              1A
     D PSEnty          S              3A
     D PZSErr          S              1A
     D PZSNum          S              6P 0
     D PZSNumU         S              6P 0
 
     D PRtcd           S              7A
     D POptn           S              7A
     D PKeyC           S             10A
     D PKySt           S              7A
     D PBrch           S              3A
     D PCurr           S              3A
 
     D OldTXBS         S              2A
     D OldPBCA         S              3A
     D OldPSSH         S             10A
     D OldPDUD         S              5  0
     D OldPEVT         S              2A
     D OldPNCY         S              3A                                                      194357
     D OldWCpRte       S             11P 7                                                    194357
     D OldCRTX         S              2A                                                      194357
     D PrvTXBS         S              2A                                                      194357
     D PrvPSSH         S             10A                                                      194357
     D PrvPDUD         S              5  0                                                    194357
     D PrvPEVT         S              2A                                                      194357
     D PrvPNCY         S              3A                                                      194357
     D PrvWCpRte       S             11P 7                                                    194357
     D PrvCRTX         S              2A                                                      194357
 
     D RqdLn1          S              3P 0
     D DifLn1          S              3P 0
      *
      ** Parameter list for ZSEDITF
     D ZFld15          S             15P 0
     D ZDecs           S              1P 0
     D ZECode          S              1A
     D ZEChar          S              1A
     D ZOut21          S             21A
      *
      ** Parameter list for ZDATE1 & ZDATE2
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameters for AOTXBSR0
     D PIRTCD          S              7A
     D PIOPTN          S              7A
     D PICRTT          S              2A
     D PITXBS          S              2A
     D PIDATE          S              5P 0
     D PINARR          S             15A
     D PIRATE          S              6P 4
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
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
      ** Output audit report and end program.
      *
     C                   EXSR      SRAudit
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  SRRcfAu - RCF Processing for Audit Report                    *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      SRRcfAu
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RqdLn1
     C                   Z-ADD     0             DifLn1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProces - Subroutine to do the Detail Processing.           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  SRAudit  - Produce Audit Report and End Program              *
      *  SRReport - Process Report Lines                              *
      *  SRWP1End - Write End of Report                               *
      *                                                               *
      *****************************************************************
      *
     C     SRProces      BEGSR
      *
      ** Read first record from File.
      *
     C     *LOVAL        SETLL     POSETW3
     C                   READ      POSETW3                              8889
      *
      ** If error reading file, write error message then exit.
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'POSETW3'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
      *
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records).
      *
     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ELSE
     C                   EVAL      RCount = RCount + 1
     C                   EXSR      SRChkPrc
     C                   EXSR      SRRtvBrDt
     C                   EVAL      OldPBCA = PBCA
     C                   EVAL      OldTXBS = TXBS
     C                   EVAL      OldPSSH = PSSH
     C                   EVAL      OldPDUD = PDUD
     C                   EVAL      OldPEVT = PEVT
     C                   EVAL      OldPNCY = PNCY                                             194357
     C                   EVAL      OldWCpRte = WCpRte                                         194357
     C                   EVAL      OldCRTX = CRTX                                             194357
     C                   EXSR      SRRtvTXRT
     C                   EVAL      WSHead = 'Y'
     C                   EVAL      WDHead = 'Y'
     C***********        EVAL      WDTail = 'Y'                                               189201
     C                   ENDIF
      *
      ** Do Until End of File.
      *
     C                   DOU       EndOfFile = True
      *
      ** If security was not processed for output, and mode is with
      ** selection, exit this loop
      *
     C                   IF        (WPrtRec <> 'N' AND PMODE = '1' AND
     C                             PSSH = SecSName AND PDUD = DateOPay AND
     C                             PEVT = EvenType) OR
     C***********                  (WPrtRec <> 'N' AND PMODE = '2')                           189201
     C                             (WPrtRec <> 'N' AND PMODE = '2' AND                        189201
     C                             PDUD = AGRDNB)                                             189201
      *
     C                   EVAL      WDTail = 'Y'                                               189201
     C                   EVAL      PCurr = PNCY
     C                   EXSR      SRCurr
      *
      ** Format fields for output.
     C                   EXSR      SRFormat
      *
      ** Process report lines.
     C                   EXSR      SRReport
     C                   EVAL      WNBDP = A6NBDP
      *
      ** Accumulate total lines.
     C                   EXSR      SRTotalL
     C                   ENDIF
 
     C                   READ      POSETW3                              8889
      *
      ** If error reading file, write error message then exit.
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = *Blanks
     C                   EVAL      DBFile = 'POSETW3'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
      *
     C                   IF        EndOfFile = False
     C                   EVAL      RCount = RCount + 1
     C                   EVAL      WDTail = 'Y'
     C                   ELSE
     C                   EVAL      WDTail = 'N'
     C                   EVAL      WTotal = 'Y'
     C                   ENDIF
      *
     C                   EVAL      WRqstNPag = 'N'
      *
      ** If security name or value date, or event type changes,
      ** print subheading
      *
     C                   IF        OldPSSH <> PSSH OR
     C                             OldPDUD <> PDUD OR
     C                             OldPEVT <> PEVT
     C                   EVAL      PrvPSSH = OldPSSH                                          194357
     C                   EVAL      PrvPDUD = OldPDUD                                          194357
     C                   EVAL      PrvPEVT = OldPEVT                                          194357
     C                   EVAL      PrvPNCY = OldPNCY                                          194357
     C                   EVAL      OldPSSH = PSSH
     C                   EVAL      OldPDUD = PDUD
     C                   EVAL      OldPEVT = PEVT
     C                   EVAL      OldPNCY = PNCY                                             194357
      *
      ** Check if security is to be processed for output
      *
     C                   EXSR      SRChkPrc
     C                   EVAL      PrvWCpRte = OldWCpRte                                      194357
     C                   EVAL      OldWCpRte = WCpRte                                         194357
     C                   EVAL      WTotal = 'Y'
     C                   EVAL      WSHead = 'Y'
     C                   EVAL      WDHead = 'Y'
     C                   EVAL      WRqstNPag = 'Y'
     C                   ENDIF
      *
      ** If tax basket changes, then print detail sub-heading.
     C                   IF        WPrtRec = 'Y'
     C                   IF        OldTXBS <> TXBS
     C                   EVAL      PrvTXBS = OldTXBS                                          194357
     C                   EVAL      PrvCRTX = OldCRTX                                          194357
     C                   EVAL      OldTXBS = TXBS
     C                   EVAL      OldCRTX = CRTX                                             194357
     C                   IF        WRqstNPag <> 'Y'                                           194357
     C                   EVAL      PrvPDUD = OldPDUD                                          194357
     C                   EVAL      OldPDUD = PDUD                                             194357
     C                   ENDIF                                                                194357
     C                   EXSR      SRRtvTXRT
     C                   EVAL      WTotal = 'Y'
     C                   EVAL      WDHead = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** If branch changes, then print heading.
     C                   IF        WPrtRec = 'Y' AND
     C                             OldPBCA <> PBCA
     C                   EVAL      WRqstNPag = 'Y'
     C                   EXSR      SRRtvBrDt
     C                   ENDIF
      *
      ** End of Do Until End of Valid Records.
     C                   ENDDO
      *
      ** Write final records and/or totals to report.
      *
     C                   EXSR      SRReport
     C                   EXSR      SRWP1End
      *
     C                   ENDSR
      *****************************************************************
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
     C                   PARM      PBCA          PBrch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 006
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBCA
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ELSE
     C                   EVAL      RBRCD = A8BRCD
     C                   EVAL      RBRNM = A8BRNM
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkPrc - Check if security read is to be reported.         *
      *                                                               *
      *****************************************************************
      *
     C     SRChkPrc      BEGSR
      *
      ** Amount of dividend/coupon.
      *
     C                   EVAL      WPrtRec = 'Y'
     C                   IF        PEVT = 'CP' OR
     C                             PEVT = 'DV'
      *                                                                         193312
      * Check if date generated is zero. In this case record does not exists    193312
      * in diary events file                                                    193312
      *                                                                         193312
     C     PDTG          IFEQ      0                                            193312
     C                   EXSR      SRpos                                        193312
      *                                                                         193312
     C                   EVAL      WPevt = PEVT                                 193312
      *                                                                         193312
     C                   ELSE                                                   193312
      *                                                                         193312
     C     SecsDKey      CHAIN     SECED                              91
      *
      ** If not found, use 'CG' event type
      *
     C                   IF        *IN91 AND
     C                             PEVT = 'CP'
     C                   EVAL      WPevt = PEVT
     C                   EVAL      PEVT = 'CG'
     C     SecsDKey      CHAIN     SECED                              91
     C                   EVAL      PEVT = WPevt
     C                   ENDIF
      *
      ** Issue database error if not found
      *
     C                   IF        *IN91
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PEVT
     C                   EVAL      DBFile = 'SECED'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ELSE
 
     C                   EVAL      WCpRte = *ZEROS
 
      ** Save coupon rate to be used for output
 
     C                   IF        PEVT = 'CP'
     C                   EVAL      WCpRte = SNCR
     C                   ELSE
     C                   EVAL      WCprte = SDVA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                193312
     C                   ELSE
      *
      ** If event type is not 'MT'
      *
     C                   IF        PEVT <> 'MT'
     C     SecsDKey      CHAIN     SECORFLC                           91
      *
      ** If record found on Corporate actions file - dividend, check on
      ** Corporate Actions dividend file, otherwise, do not process
      *
     C                   IF        NOT *IN91
     C     MACORF        CHAIN     SECODVL2                           91
      *
      ** If found, use dividend per unit amount for coupon rate,
      ** otherwise, do not process
      *
     C                   IF        NOT *IN91
     C**********         EVAL      WCpRte = MDDIVU                                            190204
     C                   EVAL      WCpRte = MDDIV1                                            190204
     C                   ELSE
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFormat - Format fields for output to printer file.         *
      *                                                               *
      *  Called By: SRProces                                          *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRFormat      BEGSR
      *
      ** Customer number
      *
     C                   EVAL      RCSNO = PCPY
      *
      ** Beneficial owner.
      *
     C                   EVAL      RBNFO = BNFO
      *                                                                                       186002
      ** Depot                                                                                186002
      *                                                                                       186002
     C                   EVAL      RDEPT = DEPT                                               186002
      *
      ** Shares held.
      *
     C                   EVAL      ZECode = 'J'
     C                   EVAL      ZFld15 = *ZEROS
     C                   EVAL      ZFld15 = PNMP
     C                   EVAL      ZDecs = *ZERO
     C                   EXSR      SRFmtAmtO
     C                   EVAL      RPNMP = ZOut21
      *
      ** Gross dividend.
      *
     C                   EVAL      ZFld15 = *ZEROS
 
     C                   IF        PEVT = 'MT'
     C                   EVAL      ZFLD15 = DAMT
     C                   ELSE
     C                   EVAL      ZFld15 = PAMD
     C                   ENDIF
 
     C                   EVAL      ZDecs = A6NBDP
     C                   EXSR      SRFmtAmtO
     C                   EVAL      RPAMD = ZOut21
      *
      ** Withholding tax.
      *
     C                   EVAL      WPTAX = TASO + TAUS
     C                   EVAL      ZFld15 = *ZEROS
     C                   EVAL      ZFld15 = WPTAX
     C                   EVAL      ZDecs = A6NBDP
     C                   EXSR      SRFmtAmtO
     C                   EVAL      RPTAX = ZOut21
      *
      ** Net dividend.
      *
     C                   IF        PEVT = 'MT'
     C                   EVAL      WNDIV = DAMT - WPTAX
     C                   ELSE
     C                   EVAL      WNDIV = PAMD - WPTAX
     C                   ENDIF
 
     C                   EVAL      ZFld15 = *ZEROS
     C                   EVAL      ZFld15 = WNDIV
     C                   EVAL      ZDecs = A6NBDP
     C                   EXSR      SRFmtAmtO
     C                   EVAL      RPSAT = ZOut21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmtO - Format amount for output.                        *
      *                                                               *
      *****************************************************************
     C     SRFmtAmtO     BEGSR
 
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
      *  SRTotalL - Accumulate values for total lines.                *
      *                                                               *
      *  Called By: SRProces                                          *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRTotalL      BEGSR
      *
      ** Shares held.
      *
     C                   EVAL      WTNMP = WTNMP + PNMP
      *
      ** Gross dividend.
      *
     C                   IF        PEVT = 'MT'
     C                   EVAL      WTAMD = WTAMD + DAMT
     C                   ELSE
     C                   EVAL      WTAMD = WTAMD + PAMD
     C                   ENDIF
      *
      ** Withholding tax.
      *
     C                   EVAL      WTTAX = WTTAX + WPTAX
      *
      ** Net dividend.
      *
     C                   EVAL      WTSAT = WTSAT + WNDIV
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Process Report Lines.                             *
      *                                                               *
      *  Called By: SRProces                                          *
      *  Calls:                                                       *
      *  SRWP1Rec - Format and Write a Detail Record to the Report    *
      *                                                               *
      *****************************************************************
      *
     C     SRReport      BEGSR
      *
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SE7603P1
      *
      ** Ensure Detail Spool File recorded by RCF.
     C                   EVAL      PZSNum = PSFNum1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeqs
     C                   PARM      *Blanks       PSEnty
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
     C                   EVAL      WRcPrted = 'Y'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWP1Rec - Subroutine to Write a Detail record to the Report.*
      *                                                               *
      *  Called By: SRProces                                          *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRWP1Rec      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     9             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
     C     DifLn1        IFLE      RqdLn1
     C                   WRITE     HEADP1
     C                   IF        WTotal = 'Y' And WRcPrted = 'Y'                            194357
     C                   EVAL      TXBS = PrvTXBS                                             194357
     C                   EVAL      CRTX = PrvCRTX                                             194357
     C                   EVAL      PDUD = PrvPDUD                                             194357
     C                   EXSR      SRRtvTXRT                                                  194357
     C                   EVAL      TXBS = OldTXBS                                             194357
     C                   EVAL      CRTX = OldCRTX                                             194357
     C                   EVAL      PDUD = OldPDUD                                             194357
     C                   IF        WRqstNPag = 'Y'                                            194357
     C                   EVAL      PSSH = PrvPSSH                                             194357
     C                   EVAL      PDUD = PrvPDUD                                             194357
     C                   EVAL      PEVT = PrvPEVT                                             194357
     C                   EVAL      PNCY = PrvPNCY                                             194357
     C                   EVAL      WCpRte = PrvWCpRte                                         194357
     C                   EXSR      SRFmtSec                                                   194357
     C                   EVAL      PSSH = OldPSSH                                             194357
     C                   EVAL      PDUD = OldPDUD                                             194357
     C                   EVAL      PEVT = OldPEVT                                             194357
     C                   EVAL      PNCY = OldPNCY                                             194357
     C                   EVAL      WCpRte = OldWCpRte                                         194357
     C                   ENDIF                                                                194357
     C                   ELSE                                                                 194357
     C                   EXSR      SRFmtSec
     C                   ENDIF                                                                194357
     C                   WRITE     SHEAD1
     C                   WRITE     DSHEAD
     C                   EVAL      WSHead = 'N'
     C                   EVAL      WDHead = 'N'
     C                   IF        WTotal = 'Y' And WRcPrted = 'Y'                            194357
     C                   EXSR      SRRtvTXRT                                                  194357
     C                   EVAL      WDHead = 'Y'                                               194357
     C                   ENDIF                                                                194357
     C                   ENDIF
      *
      ** Write out total lines for every change of customer and if
      ** previous record read was processed for output
      *
     C                   IF        WTotal = 'Y' And
     C                             WRcPrted = 'Y'
     C                   EXSR      SRFmtTot
     C                   WRITE     DTOTAL
     C                   EVAL      WTotal = 'N'
     C                   EXSR      SRResetAll
     C                   EVAL      WRcPrted = 'N'
     C                   ENDIF
      *
      ** If new page is required...
      *
     C     WRqstNPag     IFEQ      'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WSHEAD = 'Y'
     C                   EVAL      WDHEAD = 'Y'
     C                   ENDIF
      *
      ** Write out sub-heading for every change of security.
      *
     C                   IF        WSHead = 'Y' AND EndOfFile <> True
     C                   EXSR      SRFmtSec
     C                   WRITE     SHEAD1
     C                   EVAL      WSHead = 'N'
     C                   ENDIF
      *
      ** Write out detail sub-heading for every change of customer.
      *
     C                   IF        WDHead = 'Y' AND EndOfFile <> True
     C                   WRITE     DSHEAD
     C                   EVAL      WDHead = 'N'
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   IF        WDTail = 'Y'
     C                   WRITE     DETAIL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtSec - Format security line heading.                     *
      *                                                               *
      *  Called By: SRWP1Rec                                          *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtSec      BEGSR
      *
      ** Security short name.
      *
     C                   EVAL      RPSSH = PSSH
      *
      ** Date of payment.
      *
     C                   Z-ADD     PDUD          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      RPSVL
      *
      ** Event type.
      *
     C                   EVAL      RPEVT = PEVT
      *
      ** Currency.
      *
     C                   EVAL      RPNCY = PNCY
 
     C                   EVAL      ZECode = ' '
     C                   MOVE      WCpRte        ZFld15
     C                   EVAL      ZDecs = 7
     C                   EXSR      SRFmtAmtO
     C                   MOVE      ZOut21        WCpRatA
     C                   MOVEL     WCpRatA       RCPRT
 
     C                   IF        PEVT = 'MT'
     C                   MOVE      *BLANKS       RCPRT
     C                   ENDIF
      *
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
     C                   PARM      *Blanks       PADateOut
 
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
      *                                                               *
      *  SRFmtTot - Format total line fields.                         *
      *                                                               *
      *  Called By: SRWP1Rec                                          *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtTot      BEGSR
                                                                                              186002
     C                   EVAL      ZECode = 'J'                                               186002
      *
      ** Total shares held.
      *
     C                   EVAL      ZFld15 = *ZEROS
     C                   EVAL      ZFld15 = WTNMP
     C                   EVAL      ZDecs = *ZERO
     C                   EXSR      SRFmtAmtO
     C                   EVAL      RTNMP = ZOut21
      *
      ** Total gross dividend.
      *
     C                   EVAL      ZFld15 = *ZEROS
     C                   EVAL      ZFld15 = WTAMD
     C                   EVAL      ZDecs = WNBDP
     C                   EXSR      SRFmtAmtO
     C                   EVAL      RTAMD = ZOut21
      *
      ** Total withholding tax.
      *
     C                   EVAL      ZFld15 = *ZEROS
     C                   EVAL      ZFld15 = WTTAX
     C                   EVAL      ZDecs = WNBDP
     C                   EXSR      SRFmtAmtO
     C                   EVAL      RTTAX = ZOut21
      *
      ** Total net dividend.
      *
     C                   EVAL      ZFld15 = *ZEROS
     C                   EVAL      ZFld15 = WTSAT
     C                   EVAL      ZDecs = WNBDP
     C                   EXSR      SRFmtAmtO
     C                   EVAL      RTSAT = ZOut21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetAll - Reset all work fields.                          *
      *                                                               *
      *****************************************************************
     C     SRResetAll    BEGSR
      *
     C                   EVAL      WTNMP = *ZERO
     C                   EVAL      WTAMD = *ZERO
     C                   EVAL      WTTAX = *ZERO
     C                   EVAL      WTSAT = *ZERO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvTXRT - Subroutine to retrive tax rate.                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvTXRT     BEGSR
 
     C                   IF        TXBS <> *BLANKS                              185735
                                                                                185735
     C                   CALL      'AOTXBSR0'
     C                   PARM      *BLANKS       PIRTCD
     C                   PARM      '*KEY   '     PIOPTN
     C                   PARM      CRTX          PICRTT
     C                   PARM      TXBS          PITXBS
     C                   PARM      PDUD          PIDATE
     C                   PARM      *BLANKS       PINARR
     C                   PARM      *ZEROS        PIRATE
 
     C                   IF        PIRTCD <> *BLANKS AND
     C                             PIRTCD <> '*NRF   '
     C                   MOVEL     PDUD          WDate
     C                   EVAL      DBKEY  = CRTX + TXBS + WDate
     C                   EVAL      DBFILE = 'SDTXBSPD'
     C                   EVAL      DBASE  = 007
     C                   EXSR      *PSSR
     C                   ENDIF
     C                                                                          185735
     C                   ELSE                                                   185735
     C                   EVAL      PIRATE = 0                                   185735
     C                   ENDIF                                                  185735
 
     C                   MOVEL     *BLANKS       RTXBS
     C                   MOVE      *BLANKS       ZFld15
 
     C                   IF        PIRTCD = *BLANKS
     C                   MOVEL     TXBS          RTXBS
     C                   MOVE      PIRATE        ZFld15
     C                   ENDIF
 
     C                   EVAL      ZECode = ' '
     C                   EVAL      ZDecs = 4
     C                   EXSR      SRFmtAmtO
     C                   MOVE      ZOut21        RTXRT
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWP1End - Subroutine to Write End of Report.                *
      *                                                               *
      *  Called By: SRProces                                          *
      *  Calls    : None                                              *
      *                                                               *
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
     C     PrtLn1        OREQ      *ZERO                                                      189201
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out ending format.
      *
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, SRProces, *PsSR                  *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = True
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
     C                   IF        RCount = 0
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
      *                                                               *
      *  SRRcfAu - Subroutine to register the AU Printer File via RCF.*
      *                                                               *
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
     C                   PARM      *Blanks       PSEnty
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeqs
     C                   PARM                    PMode
     C                   PARM                    PParm
 
     C                   IF        Eventype = 'MA'
     C                   EVAL      Eventype = 'MT'
     C                   ENDIF
                                                                                              189201
     C                   Z-ADD     *Zero         PrtLn1                                       189201
      *
      ** Read in installation data.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      MultiBrch = True
     C                   ELSE
     C                   EVAL      MultiBrch = False
     C                   ENDIF
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
      *
      ** Key fields for securities diary events file.
      *
     C     SecsDKey      KLIST
     C                   KFLD                    PSSH
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT
 
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
      *********************************************************************     193312
      /EJECT                                                                    193312
      *********************************************************************     193312
      *                                                                   *     193312
      * SRpos  - Subroutine to retrieve values needed by pgm if           *     193312
      *          diary event does not exist                               *     193312
      *                                                                   *     193312
      * Called by:  SRChkPrc                                              *     193312
      *                                                                   *     193312
      * Calls: None                                                       *     193312
      *                                                                   *     193312
      *********************************************************************     193312
     C     SRpos         BEGSR                                                  193312
                                                                                193312
     C     PSSH          CHAIN     SECTY                              41        193312
     C                   IF        *IN41                                        193312
     C     *LOCK         IN        LDA                                          193312
     C                   EVAL      DBKEY = PSSH                                 193312
     C                   EVAL      DBFILE = 'SECTY'                             193312
     C                   EVAL      DBASE = 009                                  193312
     C                   OUT       LDA                                          193312
     C                   EVAL      *INU7 = '1'                                  193312
     C                   EVAL      *INU8 = '1'                                  193312
     C                   EXSR      *PSSR                                        193312
     C                   ELSE                                                   193312
     C                   IF        PEVT = 'CP'                                  193312
     C                   EVAL      CPNR = SNCR                                  193312
     C                   EVAL      WCpRte = SNCR                                193312
     C                   END                                                    193312
                                                                                193312
     C                   IF        PEVT = 'DV'                                  193312
     C**** PAMD          DIV       WTNMP         SDVA                    193312 197280
     C     PAMD          DIV       PNMP          SDVA                           197280
     C                   EVAL      WCpRte = SDVA                                193312
     C                   END                                                    193312
     C                   END                                                    193312
                                                                                193312
     C                   ENDSR                                                  193312
                                                                                193312
      *****************************************************************
      /EJECT
      *********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
