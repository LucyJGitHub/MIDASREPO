     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Withholding Tax Customer Details Report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0372P - SD Withholding Tax Customer Details Report.        *
      *                                                               *
      *  Function:  This module reports customer withholding tax      *
      *             details.  (On request during I/C)                 *
      *                                                               *
      *  Component of: SDC0372P                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079             Date 05Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186000             Date 08Nov00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  186000 - Tax Identification Number needs to be added to      *
      *           Customer Withholding Tax Details                    *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      * 21-23 - Display/non-display fields                            *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *                                                               *
      *   88  - Error occured accessing file                          *
      *   89  - End of file reached                                   *
      *                                                               *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit   - Program Initialisation                            *
      *  SRProces - Detail Processing                                 *
      *  SRReport - Process Report Lines                              *
      *                                                               *
      *  SRWP1Rec - Format and Write a Detail Record to the Report    *
      *  SRWP1End - Write End of Report                               *
      *                                                               *
      *  SRAudit  - Produce Audit Report and End Program              *
      *                                                               *
      * *PsSR - Error processing                                      *
      *                                                               *
      *  SRRCFAU  - RCF Processing for Audit Report                   *
      *                                                               *
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
      ** Withholding Tax Customer details by customer number and country tax
      ** treaty live records for retrieve.
     FSDWTCSL1  IF A E           K DISK    INFSR(*PsSR)
      *
      ** Control file retrieval index
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Withholding tax customer details printer file - Audit
     FSD0372PM  O    E             PRINTER INFSR(*PsSR)
     F                                     INFDS(SPOOLU)
      *
      ** Withholding tax customer details printer file - Detail
     FSD0372P1  O    E             PRINTER USROPN
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
      ** Data Area giving Installation Control Details
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for bank details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** DS for access programs - short data structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Program Status Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** File Information Data Structure for SD0372P1.
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
      *
      ** File Information Data Structure for SD0372PM.
     D SPOOLU          DS
     D  PSFileU               83     92
     D  SFNumU               123    124B 0
      *
      ** Withholding tax detail data structures.
     D DetailF         DS
     D  WHCRTT
     D  WHDCRC
     D  WHEXCD
     D  WHBCWA
     D  WHRPCD
     D  WHTXBS
     D  WHRFSI
     D  WHDBTT
     D  WHLCDT                13     19
     D  WHTIN                                                                                 186000
      *
     D Detail1         DS
     D  RCRTT1
     D  RDCRC1
     D  REXCD1
     D  RBCWA1
     D  RRPCD1
     D  RTXBS1
     D  RRFSI1
     D  RDBTT1
     D  RLCDT1
     D  RWTIN1                                                                                186000
      *
     D Detail2         DS
     D  RCRTT2
     D  RDCRC2
     D  REXCD2
     D  RBCWA2
     D  RRPCD2
     D  RTXBS2
     D  RRFSI2
     D  RDBTT2
     D  RLCDT2
     D  RWTIN2                                                                                186000
      *
     D Detail3         DS
     D  RCRTT3
     D  RDCRC3
     D  REXCD3
     D  RBCWA3
     D  RRPCD3
     D  RTXBS3
     D  RRFSI3
     D  RDBTT3
     D  RLCDT3
     D  RWTIN3                                                                                186000
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             55     55
     D  ErrorOnFl             88     88
     D  EndOfFile             89     89
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WOpen           S              1A   INZ('N')
     D WSHead          S              1A   INZ('Y')
     D WCount          S              1P 0 INZ(*ZERO)
 
     D KCustNo         S              6A
 
     D PRtcd           S              7A
     D PMode           S              1A
     D PSeqs           S              5A
     D PLevl           S              1A
     D PEnty           S              3A
 
     D PSEnty          S              3A
     D PZSErr          S              1A
     D PZSNum          S              6P 0
     D PZSNumU         S              6P 0
 
     D POptn           S              7A
     D PKeyC           S             10A
     D PKySt           S              7A
 
     D WFName          S             10A   INZ('SDWTCSPD')
 
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
 
     D RqdLn1          S              3P 0
     D DifLn1          S              3P 0
 
     D OldCSNO         S              6A
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
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  SRRCFAU - RCF Processing for Audit Report                    *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      SRRCFAU
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RqdLn1
     C                   Z-ADD     0             DifLn1
     C                   Z-ADD     0             RCount
 
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
     C     SRProces      BEGSR
      *
      ** Read first record from File.
      *
     C     *LOVAL        SETLL     SDWTCSL1
 
     C                   EXSR      SRReadRec
      *
      ** If error reading file, write error message then exit.
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDWTCSL1'
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
     C                   EVAL      WSHead = 'Y'
     C                   EVAL      OldCSNO = WHCSNO
     C                   ADD       1             WCount
     C                   ENDIF
      *
      ** Do Until End of File.
      *
     C                   DOU       EndOfFile = True
      *
     C                   SELECT
      *
      ** Record set 1 for line.
     C                   WHEN      WCount = 1
     C                   EXSR      SRFmtDatI
     C                   EVAL      Detail1 = DetailF
     C                   EVAL      KCustNo = WHCSNO
      *
      ** Record set 2 for line.
     C                   WHEN      WCount = 2
     C                   EXSR      SRFmtDatI
     C                   EVAL      Detail2 = DetailF
      *
      ** Record set 3 for line.
     C                   WHEN      WCount = 3
     C                   EXSR      SRFmtDatI
     C                   EVAL      Detail3 = DetailF
     C                   OTHER
      *
      ** Process Report Lines.
     C                   EXSR      SRReport
      *
      ** Initalize work variables for next record line.
     C                   EVAL      WCount = *ZERO
     C                   EVAL      Detail1 = *Blanks
     C                   EVAL      Detail2 = *Blanks
     C                   EVAL      Detail3 = *Blanks
     C                   ENDSL
      *
      ** If record can still be printed on line, read another.
     C                   IF        WCount < 3
     C                   EXSR      SRReadRec
     C                   ENDIF
      *
      ** Count records printed on each report line.
     C                   IF        EndOfFile = False
     C                   ADD       1             WCount
     C                   ENDIF
      *
      ** If customer number changed or set records full, then print.
     C                   IF        OldCSNO <> WHCSNO
     C                   EVAL      OldCSNO = WHCSNO
     C                   READP     SDWTCSL1                             8889
     C                   EVAL      RCount = RCount - 1
     C                   Z-ADD     4             WCount
     C                   ENDIF
      *
      ** If error reading file, write error message then exit.
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = *Blanks
     C                   EVAL      DBFile = 'SDWTCSL1'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
      *
      ** End of Do Until End of Valid Records.
     C                   ENDDO
      *
      ** Write final records and/or totals to report.
      *
     C                   EXSR      SRReport
     C                   EXSR      SRWP1End
 
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
     C     SRReport      BEGSR
      *
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD0372P1
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
      ** Setup record set to appear.
      *
     C                   IF        Detail1 <> *Blanks
     C                   EVAL      *IN21 = True
     C                   ELSE
     C                   EVAL      *IN21 = False
     C                   ENDIF
      *
     C                   IF        Detail2 <> *Blanks
     C                   EVAL      *IN22 = True
     C                   ELSE
     C                   EVAL      *IN22 = False
     C                   ENDIF
      *
     C                   IF        Detail3 <> *Blanks
     C                   EVAL      *IN23 = True
     C                   ELSE
     C                   EVAL      *IN23 = False
     C                   ENDIF
      *
      ** Write out the record if details exist.
      *
     C***********        IF        WCount <> 0                                                186000
     C                   IF        Detail1 <> *Blanks                                         186000
     C                   EXSR      SRWP1Rec
     C                   ENDIF
 
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
     C     SRWP1Rec      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C***********        Z-ADD     11            RqdLn1                                       186000
     C                   Z-ADD     13            RqdLn1                                       186000
     C     OflLn1        SUB       PrtLn1        DifLn1
     C     DifLn1        IFLE      RqdLn1
     C                   WRITE     HEADP1
     C                   EVAL      WSHead = 'Y'
     C                   ENDIF
      *
      ** Write out detail sub-heading for every change of customer.
      *
     C                   IF        WSHead = 'Y'
     C                   EXSR      SRRtvCusD
     C                   WRITE     SHEAD1
     C                   EVAL      WSHead = 'N'
     C                   ENDIF
      *
      ** Remember to print detail sub-heading on next pass.
      *
     C***********        IF        WCount > 4                                                 186000
     C                   IF        WCount >= 4                                                186000
     C                   EVAL      WSHead = 'Y'
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCusD - Subroutine to Write End of Report.               *
      *                                                               *
      *  Called By: SRWP1Rec                                          *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     SRRtvCusD     BEGSR
      *
      ** Access customer details.
      ** Customer must exist, standard DBError if customer is not found.
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      KCustNo       PKeyC
     C                   PARM      *Blanks       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = KCustNo
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PsSr
     C                   ENDIF
      *
     C                   EVAL      RCSNO = BBCUST
     C                   EVAL      RCSSN = BBCSSN
     C                   EVAL      RCRNM = BBCRNM
     C                   EVAL      RCRTN = BBCRTN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadRec - Read a record from file.                         *
      *                                                               *
      *****************************************************************
     C     SRReadRec     BEGSR
 
     C                   SELECT
     C                   WHEN      PMode = 'A'
     C                   DOU       WHLCD = BJRDNB OR EndOfFile = True
     C                   READ      SDWTCSL1                             8889
      *
      ** Keep track of number of records being read.
     C                   IF        EndOfFile = False
     C                   EVAL      RCount = RCount + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   OTHER
 
     C                   READ      SDWTCSL1                             8889
      *
      ** Keep track of number of records being read.
     C                   IF        EndOfFile = False
     C                   EVAL      RCount = RCount + 1
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDatI - Format date for display.                         *
      *                                                               *
      *****************************************************************
     C     SRFmtDatI     BEGSR
 
     C                   Z-ADD     WHLCD         PDateIn
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *Blanks       PADateOut
 
     C                   EVAL      WHLCDT = PADateOut
 
     C                   ENDSR
 
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
     C     SRWP1End      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RqdLn1
     C     OflLn1        SUB       PrtLn1        DifLn1
     C     DifLn1        IFLE      RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Total Format.
      *
     C                   WRITE     TRAILP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, SRProces, *PsSR                  *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
      ** Check control details.
      *
     C     WFName        CHAIN     SDFCTLL1                           55
      *
      ** Database error.
      *
     C                   IF        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WFName
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = True
     C                   WRITE     DBERROR
     C                   EVAL      PRtcd = '*ERROR '
     C                   ELSE
      *
     C                   IF        RCount <> 0
      *
      ** Determine if there is file out of balance
     C                   IF        RCount <> RAudit
     C                   EVAL      *IN25 = *On
     C                   ELSE
     C                   EVAL      *IN25 = *Off
     C                   ENDIF
      *
      ** Write audit control details
     C                   WRITE     CONTROL
 
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   EVAL      *INLR = True
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF.*
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR                                                   *** RCFAU  ***
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
 
     C                   ENDSR
 
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
     C     *InzSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PSeqs
     C                   PARM                    PLevl
     C                   PARM                    PEnty
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
     C                   IF        AGMBIN = 'M'
     C                   EVAL      *IN37 = True
     C                   ELSE
     C                   EVAL      *IN37 = False
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
      ** Determine which header tp print
      *
     C                   IF        PMode = 'A'
     C                   EVAL      *IN20 = *On
     C                   ELSE
     C                   EVAL      *IN20 = *Off
     C                   ENDIF
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *****************************************************************
      * *PsSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PsSR         BEGSR                                                  ** *PsSR **
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
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
