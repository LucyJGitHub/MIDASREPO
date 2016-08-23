     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas FRS Movement Extraction Audit Report')
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting Interface               *
      *                                                               *
      *  RPGLE/RN000102 - Movement Extraction Audit Report            *
      *                                                               *
      *  Function:  This program will read RNAUMVPD file and print    *
      *             each record to the extraction audit report.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG10742           Date 08May06               *
      *  Prev Amend No. CRN001  *CREATE    Date 23Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG10742 - AC key in files RNAUMVPD and RNXCMVPD changed to  *
      *             20A due to CDL038. Recompile is needed.           *
      *  CRN001 - FRS Regulatory Reporting Interface                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      * RN Audit file
     FRNAUMVL0  IF   E           K DISK    INFSR(*PSSR)
      *
      * GP FRS Regulatory Authorities
     FGPREGAPD  IF   E           K DISK    INFSR(*PSSR)
      *
      * GP Midas system pulldown lists
     FGPPDWNL0  IF   E           K DISK    INFSR(*PSSR)  USROPN
      *
     FRN000102AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      *
     FRN000102P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN67)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *    35 - output format of event amount with 0 decimal place    *
      *    36 - output format of event amount with 1 decimal place    *
      *    37 - output format of event amount with 2 decimal places   *
      *    38 - output format of event amount with 3 decimal places   *
      *    45 - output format of report ccy amt with 0 decimal place  *
      *    46 - output format of report ccy amt with 1 decimal place  *
      *    47 - output format of report ccy amt with 2 decimal places *
      *    48 - output format of report ccy amt with 3 decimal places *
      *    60 - SDCURRL0 opened                                       *
      *    67 - Overflow indicator of P1 report                       *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main        - Main processing                                *
      *  WrtHeader   - Write header                                   *
      *  ChkOverFlow - Check if there will be overflow                *
      *  WrtMTHeader - Write sub-header                               *
      *  WrtDetail   - Write detail line                              *
      *  WrtMTTotal  - Write movement amount type total               *
      *  WrtTotals   - Write totals                                   *
      *  WrtTxTotal  - Write transaction identifier total             *
      *  WrtMoTotal  - Write module total                             *
      *  WrtRATotal  - Write regulatory authority total               *
      *  GetCcyDP    - Retrieve currency decimal places               *
      *  Audit       - Produce Audit Report and End Program           *
      *  *INZSR    - Program initialisation                           *
      *  CloseDown - Return to calling program                        *
      *  RCFP1     - RCF processing for P1 Report                     *
      *  RCFAU     - RCF processing for Audit Report                  *
      *  *PSSR     - Program Error processing Subroutine              *
      *                                                               *
      *****************************************************************
     D/EJECT
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      /COPY ZACPYSRC,PSDS
      /COPY RNCPYSRC,RNPSSRDFN
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      * Movement Type and Movement type Desription arrarys
     D @MovType        S              5  0 DIM(25)
     D @MovTyDesc      S             45    DIM(25)
 
      /SPACE 3
      *
      ***  File Information Data Structure for RN000102P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0                                      Lines printed
      *
     D SPOOLU          DS
      ***  File Information Data Structure for RN000102AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ***  Data structure for currency file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ***  Movement types from field GLDESC in GPPDWNPD
     D                 DS
     D  WrkMovTypA             1      2                                         in alpha
     D  WrkMovTypN             1      2  0                                      numeric
      *
      ***  Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS
      *
      ***  Work fields
     D FIRST           S              1
     D MTTotal         S                   LIKE(AMRCAMNT) INZ(0)                movement type total
     D TxTotal         S                   LIKE(AMRCAMNT) INZ(0)                Tx Id total
     D MoTotal         S                   LIKE(AMRCAMNT) INZ(0)                module total
     D RATotal         S                   LIKE(AMRCAMNT) INZ(0)                regulatory auth. ttl
     D PCount          S              5  0 INZ(0)                               records count
     D RemainLine      S              3  0                                      remaining lines
     D ReqRemLine      S              3  0                                      Required remain line
     D SaveRegAut      S                   LIKE(AMREGAUT) INZ(' ')              Save Authority
     D SaveCntRef      S                   LIKE(AMCNTREF) INZ(' ')              Save Tx identifier
     D SaveMovTyp      S                   LIKE(AMMOVTYP) INZ(0)                Save movement type
     D SaveRptCcy      S                   LIKE(RARPTCCY) INZ(' ')              Save Reporting Ccy
     D SaveOrgCcy      S                   LIKE(AMORGCCY) INZ(' ')              Save Event Ccy
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
     C                   EXSR      MAIN
 
     C                   EXSR      CloseDown
 
      *****************************************************************
      /TITLE SR/MAIN
      *****************************************************************
      *                                                               *
      *  MAIN   -  Main subroutine                                    *
      *                                                               *
      *****************************************************************
     C     MAIN          BEGSR
      *
     C                   EVAL      FIRST = 'Y'
      *
     C     *LOVAL        SETLL     RNAUMVL0
     C                   READ      RNAUMVL0
      *
     C                   DOW       NOT %EOF
      *
      * If first record, write subheadings and column heading.
     C                   IF        FIRST = 'Y'
     C                   EVAL      FIRST = 'N'
     C                   EXSR      WrtHeader
     C                   EXSR      WrtMTHeader
     C                   ENDIF
      *
      ** Details line
     C                   EXSR      WrtDetail
      *
      ** Increment record count
     C                   EVAL      PCount = PCount + 1
      *
     C                   READ      RNAUMVL0
      *
     C                   SELECT
      *
      ** If end of file, write all the total lines,
     C                   WHEN      %EOF
     C                   EXSR      WrtMTTotal
     C                   EXSR      WrtTotals
      *
      ** On change of regulatory authority id, module, or transaction type, write
      ** totals and start a new page for report heading
     C                   WHEN      SaveRegAut  <> AMREGAUT OR
     C                             HModule     <> AMMODULE OR
     C                             SaveCntRef  <> AMCNTREF
     C                   EXSR      WrtMTTotal
     C                   EXSR      WrtTotals
      *
     C                   WRITE     RPTHEAD
     C                   EXSR      WrtHeader
     C                   EXSR      WrtMTHeader
      *
      ** On change of movement amount type, write movement type total and movement type
      ** header.
     C                   WHEN      SaveMovTyp <> AMMOVTYP
     C                   EXSR      WrtMTTotal
     C                   EXSR      WrtMTHeader
      *
      ** If no change, check for any overflow for new page.
     C                   OTHER
     C                   IF        *IN67 = *ON
     C                   WRITE     RPTHEAD
     C                   EXSR      WrtHeader
     C                   EXSR      WrtMTHeader
     C                   ENDIF                                                  FI *IN67 = *ON
      *
     C                   ENDSL
      *
      ** Set off overflow indicator.
     C                   SETOFF                                       67
      *
     C                   ENDDO                                                  DOW not %EOF
      *
      ** If no record printed, write '*** NO DETAILS TO REPORT ***'
      *
     C                   IF        PCount = 0
     C                   WRITE     NODTLS
     C                   ENDIF
      *
      ** Write Trailer
     C                   EVAL      RemainLine = OFLLN1 - PRTLN1
     C                   IF        RemainLine < 3
     C                   WRITE     RPTHEAD
     C                   ENDIF
      *
     C                   WRITE     TRAILP1
      *
      ** Write Audit
     C                   EXSR      Audit
      *
     C                   ENDSR
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      /TITLE SR/WrtHeader
      *****************************************************************
      *                                                               *
      *  WrtHeader  - Write Header (Regulatory Authority, Module,     *
      *               Tx Identifier)                                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WrtHeader     BEGSR
      *
      ** If change on regulatory authority Id, get its description.
      *
     C                   IF        SaveRegAut <> AMREGAUT
      *
     C     AMREGAUT      CHAIN     GPREGAPD
     C                   IF        %FOUND
     C                   EVAL      HRANAME = RANAME
     C                   ELSE
     C                   EVAL      wDbFile  = 'GPREGAPD'
     C                   EVAL      wDBase   = 4
     C                   EVAL      wDbKey   = AMREGAUT
     c                   EVAL      wDbMod   = ' '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Output the regulatory authority id. and reporting currency.
     C                   EVALR     HREGAUT     = %TRIMR(AMREGAUT)
     C                   EVAL      HRPTCCY     = RARPTCCY
      *
      **  Save the regulatory authority id. as SaveRegAut.
     C                   EVAL      SaveRegAut  = AMREGAUT
      *
      **  If change on currency, retrieve currency details for the new regulatory authority.
     C                   If        SaveRptCcy <> RARPTCCY
     C                   EVAL      CCY      = RARPTCCY
     C                   EXSR      GetCcyDP
     C                   EVAL      SaveRptCcy = RARPTCCY
      *
      **  Set on indicator for the right decimal places of reporting ccy amount.
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
     C                   EVAL      *IN48 = *OFF
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      *IN45  = *ON
     C                   WHEN      A6NBDP = 1
     C                   EVAL      *IN46  = *ON
     C                   WHEN      A6NBDP = 2
     C                   EVAL      *IN47  = *ON
     C                   WHEN      A6NBDP = 3
     C                   EVAL      *IN48  = *ON
     C                   ENDSL
      *
     C                   ENDIF                                                  FI diff Rptccy
      *
     C                   ENDIF                                                  FI SaveRegAut
      *                                                                            <> AMREGAPD
      *
      ** If change on module, get its description from array @Module.
     C                   IF        HModule <> AMMODULE
      *
     C                   EVAL      HMODULE  = AMMODULE
      *
     C                   SELECT
     C                   WHEN      AMMODULE = 'DL'
     C                   EVAL      HMONAME  = 'Dealing'
     C                   WHEN      AMMODULE = 'LE'
     C                   EVAL      HMONAME  = 'Lending'
     C                   WHEN      AMMODULE = 'FT'
     C                   EVAL      HMONAME  = 'Fund Transfer'
     C                   OTHER
     C                   EVAL      HMONAME  = *BLANK
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** If change on transaction identifier, output new transaction identifier.
     C                   IF        SaveCntRef <> AMCNTREF
     C                   EVALR     HCNTREF = %TRIMR(AMCNTREF)
      *
      ** Save the new tx identifier as SaveCntRef.
     C                   EVAL      SaveCntRef = AMCNTREF
     C                   ENDIF
      *
      ** Write Header
     C                   WRITE     SUBHEAD
      *
     C     WrtHeaderE    ENDSR
      *
      *****************************************************************
      /TITLE SR/ChkOverFlow
      *****************************************************************
      *                                                               *
      *  ChkOverFlow - Check overflow                                 *
      *                                                               *
      *  Called By: WrtMTHeader                                       *
      *             WrtTotals                                         *
      *             WrtMTTotal                                        *
      *                                                               *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     ChkOverFlow   BEGSR
      *
     C                   EVAL      RemainLine = OFLLN1 - PRTLN1
     C                   IF        RemainLine < ReqRemLine
     C                   WRITE     RPTHEAD
     C                   WRITE     SUBHEAD
     C                   ENDIF
      *
     C     ChkOverFlowE  ENDSR
      *
      *****************************************************************
      /TITLE SR/WrtMTHeader
      *****************************************************************
      *                                                               *
      *  WrtMTHeader - Write Movement Amount Type Header and column   *
      *                header.  Check overflow first before any       *
      *                header.                                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:     ChkOverFlow                                       *
      *                                                               *
      *****************************************************************
      *
     C     WrtMTHeader   BEGSR
      *
      ** If change on movement amount type, retrieve movement amount type description.
     C                   IF        SaveMovTyp <> AMMOVTYP
      *
     C                   EVAL      HMOVTYP     = AMMOVTYP
     C                   EVAL      SaveMOVTYP  = AMMOVTYP
     C                   Z-ADD     1             Idx
     C     AMMOVTYP      LOOKUP    @MovType(Idx)                          99    Movement type found
     C   99              EVAL      HMOVTYD     = @MovTyDesc(Idx)
     C  N99              EVAL      HMOVTYD     = *BLANKS
 
     C                   ENDIF                                                  FI SaveMovTyp <>
      *                                                                            AMMOVTYP
      *
      ** Ensure enough lines for new Movement type heading and column headers.
     C                   EVAL      ReqRemLine = 6
     C                   EXSR      ChkOverFlow
      *
      ** Write Movement amount type header
     C                   WRITE     SUBHMOVTP
      *
      ** Write column heading
     C                   WRITE     COLHEAD
      *
     C     WrtMTHeaderE  ENDSR
      *
      *****************************************************************
      /TITLE SR/WRTDETAIL
      *****************************************************************
      *                                                               *
      *  WrtDetail - Write Detail                                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WrtDetail     BEGSR
      *
      ** If change on event ccy, retrieve currency decimal place for the event currency.
     C                   IF        SaveOrgCcy <> AMORGCCY
     C                   EVAL      CCY      = AMORGCCY
     C                   EXSR      GetCcyDP
     C                   EVAL      SaveOrgCcy = AMORGCCY
      *
      **  Set on indicator for the right decimal places of event amount.
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      *IN35  = *ON
     C                   WHEN      A6NBDP = 1
     C                   EVAL      *IN36  = *ON
     C                   WHEN      A6NBDP = 2
     C                   EVAL      *IN37  = *ON
     C                   WHEN      A6NBDP = 3
     C                   EVAL      *IN38  = *ON
     C                   ENDSL
      *
     C                   ENDIF                                                  FI SaveOrgCcy <>
      *                                                                            AMORGCCY
      *
      ** Edit event amount.
     C                   SELECT
     C                   WHEN      *IN35  = *ON
     C                   EVAL      OCAMT0 = AMOCAMNT
     C                   WHEN      *IN36  = *ON
     C                   EVAL      OCAMT1 = AMOCAMNT
     C                   WHEN      *IN37  = *ON
     C                   EVAL      OCAMT2 = AMOCAMNT
     C                   WHEN      *IN38  = *ON
     C                   EVAL      OCAMT3 = AMOCAMNT
     C                   ENDSL
      *
      *
      ** Print credit or debit of event amount.
     C                   IF        AMDCI = 'C'
     C                   EVAL      *IN39 = *ON
     C                   ELSE
     C                   EVAL      *IN39 = *OFF
     C                   ENDIF
      *
      ** Edit reporting current amount. (*IN45-48 have been set in SR. WrtHeader.)
     C                   SELECT
     C                   WHEN      *IN45  = *ON                                 o decimal place
     C                   EVAL      RCAMT0 = AMRCAMNT
     C                   WHEN      *IN46  = *ON                                 1 decimal places
     C                   EVAL      RCAMT1 = AMRCAMNT
     C                   WHEN      *IN47  = *ON                                 2 decimal places
     C                   EVAL      RCAMT2 = AMRCAMNT
     C                   WHEN      *IN48  = *ON                                 3 decimal places
     C                   EVAL      RCAMT3 = AMRCAMNT
     C                   ENDSL
      *
      ** Print credit or debit of reporting currency amount.
     C                   IF        AMDCI = 'C'
     C                   EVAL      *IN49 = *ON
     C                   ELSE
     C                   EVAL      *IN49 = *OFF
     C                   ENDIF
      *
      ** Write details
     C                   WRITE     DETAIL
      *
      ** Add amount to totals
     C                   IF        AMDCI    = 'C'
     C                   EVAL      MTTotal  = MTTotal - AMRCAMNT
     C                   ELSE
     C                   EVAL      MTTotal  = MTTotal + AMRCAMNT
     C                   ENDIF
      *
     C     WrtDetailE    ENDSR
      *
      *****************************************************************
      /TITLE SR/WrtMTTotal
      *****************************************************************
      *                                                               *
      *  WrtMTTotal - Write movement amount type total                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:     ChkOverFlow                                       *
      *                                                               *
      *****************************************************************
      *
     C     WrtMTTotal    BEGSR
      *
     C                   EVAL      TMovTyp = %editc(SaveMovTyp:'3')
     C                   EVAL      TMovTyp = %TRIML(TMovTyp)
      *
      ** Add movement amount type total to other totals
     C                   EVAL      TxTotal = TxTotal + MTTotal
     C                   EVAL      MoTotal = MoTotal + MTTotal
     C                   EVAL      RATotal = RATotal + MTTotal
      *
      ** Edit movemnet type total for output
     C                   SELECT
     C                   WHEN      *IN45  = *ON                                 o decimal place
     C                   EVAL      MTTotal0 = MTTotal
     C                   WHEN      *IN46  = *ON                                 1 decimal places
     C                   EVAL      MTTotal1 = MTTotal
     C                   WHEN      *IN47  = *ON                                 2 decimal places
     C                   EVAL      MTTotal2 = MTTotal
     C                   WHEN      *IN48  = *ON                                 3 decimal places
     C                   EVAL      MTTotal3 = MTTotal
     C                   ENDSL
      *
     C                   IF        MTTotal >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
      *
      ** Check remaining lines on the page for movement type total.
     C                   EVAL      ReqRemLine = 2
     C                   EXSR      ChkOverFlow
     C                   WRITE     MOVTYPTTL
     C                   EVAL      MTTotal = 0
      *
     C     WrtMTTotalE   ENDSR
      *
      *****************************************************************
      /TITLE SR/WrtTotals
      *****************************************************************
      *                                                               *
      *  WrtTotals - Write Totals (Tx identifier, module, regulatory  *
      *              authority totals)                                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WrtTotals     BEGSR
      *
     C                   SELECT
      ** If change on regulatory authority, write Tx id , module and Reg. authority totals.
      ** and initial totals to zero.
     C                   WHEN      SaveRegAut <> AMREGAUT OR
     C                             %EOF
     C                   EVAL      ReqRemLine = 6
     C                   EXSR      ChkOverFlow
     C                   EXSR      WrtTxTotal
     C                   EXSR      WrtMoTotal
     C                   EXSR      WrtRATotal
      *
      ** If change on module, write Tx id , module totals.
     C                   WHEN      HMODULE <> AMMODULE
     C                   EVAL      ReqRemLine = 4
     C                   EXSR      ChkOverFlow
     C                   EXSR      WrtTxTotal
     C                   EXSR      WrtMoTotal
      *
      ** ie, change on tx id, write Tx id. total.
     C                   Other
     C                   EVAL      ReqRemLine = 2
     C                   EXSR      ChkOverFlow
     C                   EXSR      WrtTxTotal
     C                   ENDSL
      *
     C     WrtTotalsE    ENDSR
      *
      *****************************************************************
      /TITLE SR/WrtTxTotal
      *****************************************************************
      *                                                               *
      *  WrtTxTotal - Write transaction identifer total               *
      *                                                               *
      *  Called By: WrtTotals                                         *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WrtTxTotal    BEGSR
      *
     C                   EVAL      TCntRef = SaveCntRef
      *
      ** Edit total for output
     C                   SELECT
     C                   WHEN      *IN45  = *ON                                 o decimal place
     C                   EVAL      TxTotal0 = TxTotal
     C                   WHEN      *IN46  = *ON                                 1 decimal places
     C                   EVAL      TxTotal1 = TxTotal
     C                   WHEN      *IN47  = *ON                                 2 decimal places
     C                   EVAL      TxTotal2 = TxTotal
     C                   WHEN      *IN48  = *ON                                 3 decimal places
     C                   EVAL      TxTotal3 = TxTotal
     C                   ENDSL
      *
     C                   IF        TxTotal >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
      *
     C                   WRITE     CNTREFTTL
     C                   EVAL      TxTotal = 0
      *
     C     WrtTxTotalE   ENDSR
      *
      *****************************************************************
      /TITLE SR/WrtMoTotal
      *****************************************************************
      *                                                               *
      *  WrtMoTotal - Write module total                              *
      *                                                               *
      *  Called By: WrtTotals                                         *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WrtMoTotal    BEGSR
      *
     C                   EVAL      TModule = HModule
      *
      ** Edit total for output
     C                   SELECT
     C                   WHEN      *IN45  = *ON                                 o decimal place
     C                   EVAL      MoTotal0 = MoTotal
     C                   WHEN      *IN46  = *ON                                 1 decimal places
     C                   EVAL      MoTotal1 = MoTotal
     C                   WHEN      *IN47  = *ON                                 2 decimal places
     C                   EVAL      MoTotal2 = MoTotal
     C                   WHEN      *IN48  = *ON                                 3 decimal places
     C                   EVAL      MoTotal3 = MoTotal
     C                   ENDSL
      *
     C                   IF        MoTotal >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
      *
     C                   WRITE     MODULTTL
     C                   EVAL      MoTotal = 0
      *
     C     WrtMoTotalE   ENDSR
      *
      *****************************************************************
      /TITLE SR/WrtRATotal
      *****************************************************************
      *                                                               *
      *  WrtRATotal - Write regulatory authority total                *
      *                                                               *
      *  Called By: WrtTotals                                         *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WrtRATotal    BEGSR
      *
     C                   EVAL      TRegAut = SaveRegAut
      *
      ** Edit total for output
     C                   SELECT
     C                   WHEN      *IN45  = *ON                                 o decimal place
     C                   EVAL      RATotal0 = RATotal
     C                   WHEN      *IN46  = *ON                                 1 decimal places
     C                   EVAL      RATotal1 = RATotal
     C                   WHEN      *IN47  = *ON                                 2 decimal places
     C                   EVAL      RATotal2 = RATotal
     C                   WHEN      *IN48  = *ON                                 3 decimal places
     C                   EVAL      RATotal3 = RATotal
     C                   ENDSL
      *
     C                   IF        RATotal >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
      *
     C                   WRITE     REGAUTTTL
     C                   EVAL      RATotal = 0
      *
     C     WrtRATotalE   ENDSR
      *
      *****************************************************************
      /TITLE SR/GetCcyDP
      *****************************************************************
      *                                                               *
      *  GetCcyDP - Retrieve currency decimal places                  *
      *                                                               *
      *  Called By:    WrtHeader                                      *
      *  Calls:        *PSSR                                          *
      *                                                               *
      *****************************************************************
      *
     C     GetCcyDP      BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        pRtnCod           7
     C                   PARM      '*KEY'        Poption           7
     C                   PARM                    Ccy               3
     C     SDCURR        PARM                    DSSDY
      *
     C                   IF        pRtnCod <> *blank
     C                   EVAL      wDbFile  = 'SDCURRL1'
     C                   EVAL      wDBase   = 2
     C                   EVAL      wDbKey   = CCY
     c                   EVAL      wDbMod   = 'AOCURRR0'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set on SDCURRL1 opened indicator.
     C  N60              SETON                                        60
      *
     C     GetCcyDPE     ENDSR
      *
      *****************************************************************
      /TITLE SR/Audit
      *****************************************************************
      *                                                               *
      *  Audit  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     Audit         BEGSR
      *
      ** RCF Processing for Audit File.
     C                   EXSR      RCFAU
      *
      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ENDIF
      *
     C                   WRITE     TRAILAU
      *
     C     AuditE        ENDSR
 
      *****************************************************************
      /TITLE SR/*INZSR
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Automatically                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE    LDA           @LDA            256
      *
      ** RCF processing for P1 Report
     C                   EXSR      RCFP1
      *
      ** Get bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *blank        pRtnCod
     C                   PARM      '*FIRST'      POption
     C     SDBANK        PARM                    DSFDY
      *
     C                   IF        pRtnCod <> *blank
     C                   EVAL      wDbFile  = 'SDBANKL1'
     C                   EVAL      wDBase   = 1
     C                   EVAL      wDbKey   = '*FIRST'
     C                   EVAL      wDbMod   = 'AOBANKR0'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Write Report Heading
     C                   WRITE     RPTHEAD
      *
     C                   OPEN      GPPDWNL0
      *
      ** Load Movement type array @MovType and @MovTyDesc from file GPPDWNL0.
      *
      ** Initialise movement type array @MovType to all 9s.
     C                   EVAL      @MovType        = 99999
      *
     C     PDWNKey       KLIST
     C                   KFLD                    KHIND
      *
     C                   Z-ADD     52            KHIND            10 0
     C                   Z-ADD     1             Idx               2 0
     C     PDWNKey       SETLL     SDPDWND0
     C     PDWNKey       READE     SDPDWND0                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      WrkMovTypA      = %SUBST(GLDESC:1:2)
     C                   EVAL      @MovType(Idx)   = WrkMovTypN
     C                   EVAL      @MovTyDesc(Idx) = %SUBST(GLDESC:4:45)
     C                   EVAL      Idx = Idx + 1
     C     PDWNKey       READE     SDPDWND0                               99
     C                   ENDDO
      *
     C                   CLOSE     GPPDWNL0
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/CloseDown
      *****************************************************************
      *                                                               *
      *  CloseDown -  Return to Calling Program                       *
      *                                                               *
      *****************************************************************
     C     CloseDown     BEGSR
 
      ** Close SDCURRL1 which has been opened.
     C                   IF        *IN60 = *ON
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        pRtnCod
     C                   PARM      '*FREE'       Poption
     C                   PARM      *BLANK        Ccy
     C     SDCURR        PARM                    DSSDY
      *
     C                   IF        pRtnCod <> *blank
     C                   EVAL      wDbFile  = 'SDCURRL1'
     C                   EVAL      wDBase   = 3
     C                   EVAL      wDbKey   = '*FREE'
     c                   EVAL      wDbMod   = 'AOCURRR0'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                  FI *IN60 = *ON
      *
     C                   EVAL      *INLR       = *ON
     C                   RETURN
 
     C     CloseDownE    ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR
      *
      ***  Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *blank        SEQ               5
     C                   PARM      *blank        SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ***  If Error occurs during ZSFILE Processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C     RCFP1E        ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR
      *
      ***  Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ***  If Error occurs during ZSFILE Processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C     RCFAUE        ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        not inPssr
     C                   EVAL      inPssr      = *on
     C                   SETON                                        U7U8
      *
     C     *lock         IN        LDA
     C                   EVAL      dbpgm       = PSProcPgm
     C                   EVAL      dbfile      = wDbfile
     C                   EVAL      dbkey       = wDbkey
     C                   EVAL      dbase       = wDbase
     C                   EVAL      dbmod       = wDbmod
     C                   EVAL      dbproc      = wDbproc
     C                   OUT       LDA
      *
     C                   DUMP
     C                   EXSR      Audit
      *
     C                   ENDIF                                                  FI not inPssr
      *
     C                   EXSR      Closedown
      *
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
