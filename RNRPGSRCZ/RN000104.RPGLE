     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas FRS Cash Flow Extraction Audit Report')          *
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting Interface               *
      *                                                               *
      *  RPGLE/RN000104 - Cash Flow Extraction Audit Report           *
      *                                                               *
      *  Function:  This program will read RNAUCFPD file and print    *
      *             each record to the extraction audit report.       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRN001  *CREATE    Date 23Sep05               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CRN001 - FRS Regulatory Reporting Interface                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *
      * RN Audit file
     FRNAUCFL0  IF   E           K DISK    INFSR(*PSSR)
      *
      * GP FRS Regulatory Authorities
     FGPREGAPD  IF   E           K DISK    INFSR(*PSSR)
      *
      * SD Loan types/sub-types update
     FSDLOANL0  IF   E           K DISK    INFSR(*PSSR)
      *
      * FD Deal type/subtype filepdate
     FFDDTSTL0  IF   E           K DISK    INFSR(*PSSR)
      *
     FRN000104AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      *
     FRN000104P1O    E             PRINTER INFDS(SPOOL1)
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
      *  WrtTTHeader - Write transaction type header                  *
      *  WrtDetail   - Write detail line                              *
      *  WrtTTTotal  - Write transaction type total                   *
      *  WrtTotals   - Write totals                                   *
      *  WrtECTotal  - Write event currecy total                      *
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
      /SPACE 3
      *
      ***  File Information Data Structure for RN000104P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0                                      Lines printed
      *
     D SPOOLU          DS
      ***  File Information Data Structure for RN000104AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ***  Data structure for currency file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ***  Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS
      *
      ***  Data structure for transaction type
     D AUTRNTYP        DS
     D  LnDlType               1      2
     D  LnDlSType              4      5
      *
      ***  Work fields
     D FIRST           S              1
     D TTTotal         S                   LIKE(AURCAAMT) INZ(0)                Tx type total
     D ECTotal         S                   LIKE(AURCAAMT) INZ(0)                Event currency total
     D MoTotal         S                   LIKE(AURCAAMT) INZ(0)                module total
     D RATotal         S                   LIKE(AURCAAMT) INZ(0)                regulatory auth. ttl
     D PCount          S              5  0 INZ(0)                               records count
     D RemainLine      S              3  0                                      remaining lines
     D ReqRemLine      S              3  0                                      Required remain line
     D SaveRegAut      S                   LIKE(AUREGAUT) INZ(' ')              Save Authority
     D ChangeMod       S              1                                         'Y' if change on mod
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
      ** Set up key list to access SDLOANL0 or FDDTSTL0 for transaction type description.
     C     TSTKEy        KLIST
     C                   KFLD                    LnDlType
     C                   KFLD                    LnDlSType
      *
     C     *LOVAL        SETLL     RNAUCFL0
     C                   READ      RNAUCFL0
      *
     C                   DOW       NOT %EOF
      *
      * If first record, write subheadings and column heading.
     C                   IF        FIRST = 'Y'
     C                   EVAL      FIRST = 'N'
     C                   EXSR      WrtHeader
     C                   EXSR      WrtTTHeader
     C                   ENDIF
      *
      ** Details line
     C                   EXSR      WrtDetail
      *
      ** Increment record count
     C                   EVAL      PCount = PCount + 1
      *
     C                   READ      RNAUCFL0
      *
     C                   SELECT
      *
      ** If end of file, write all the total lines,
     C                   WHEN      %EOF
     C                   EXSR      WrtTTTotal
     C                   EXSR      WrtTotals
      *
      ** On change of regulatory authority id, module, or transaction type, write
      ** totals and start a new page for report heading
     C                   WHEN      SaveRegAut  <> AUREGAUT OR
     C                             HModule     <> AUMODULE OR
     C                             HEvtCcy     <> AUEVTCCY
     C                   EXSR      WrtTTTotal
     C                   EXSR      WrtTotals
      *
     C                   WRITE     RPTHEAD
     C                   EXSR      WrtHeader
     C                   EXSR      WrtTTHeader
      *
      ** On change of transaciton type, write transaction type total and transaction type
      ** header.
     C                   WHEN      HTRNTYP <> AUTRNTYP
     C                   EXSR      WrtTTTotal
     C                   EXSR      WrtTTHeader
      *
      ** If no change, check for any overflow for new page.
     C                   OTHER
     C                   IF        *IN67 = *ON
     C                   WRITE     RPTHEAD
     C                   EXSR      WrtHeader
     C                   EXSR      WrtTTHeader
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
     C                   IF        SaveRegAut <> AUREGAUT
      *
     C     AUREGAUT      CHAIN     GPREGAPD
     C                   IF        %FOUND
     C                   EVAL      HRANAmE = RANAME
     C                   ELSE
     C                   EVAL      wDbFile  = 'GPREGAPD'
     C                   EVAL      wDBase   = 4
     C                   EVAL      wDbKey   = AUREGAUT
     c                   EVAL      wDbMod   = ' '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Output the regulatory authority id. and reporting currency.
     C                   EVALR     HREGAUT     = %TRIMR(AUREGAUT)
      *
      **  Save the regulatory authority id. as SaveRegAut.
     C                   EVAL      SaveRegAut  = AUREGAUT
      *
      **  If change on currency, retrieve currency details for the new regulatory authority.
     C                   If        HRPTCcy    <> RARPTCCY
     C                   EVAL      CCY        = RARPTCCY
     C                   EXSR      GetCcyDP
     C                   EVAL      HRPTCCY    = RARPTCCY
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
      *                                                                            <> AUREGAPD
      *
      ** If change on module, get its description from array @Module.
     C                   IF        HModule <> AUMODULE
      *
      ** set 'Y' to ChangeMod flag so that retreival of tx type desc. is required.
     C                   EVAL      ChangeMod = 'Y'
     C                   EVAL      HMODULE  = AUMODULE
      *
     C                   SELECT
     C                   WHEN      AUMODULE = 'DL'
     C                   EVAL      HMONAME  = 'Dealing'
     C                   WHEN      AUMODULE = 'LE'
     C                   EVAL      HMONAME  = 'Lending'
     C                   OTHER
     C                   EVAL      HMONAME  = *BLANK
     C                   ENDSL
      *
     C                   ELSE
     C                   EVAL      ChangeMod = 'N'
      *
     C                   ENDIF
      *
      ** If change on event currency, output new event currency.
     C                   IF        HEVTCCY <> AUEVTCCY
     C                   EVAL      HEvtCcy = AUEVTCCY
      *
      **    Retrieve currency decimal place and currency name for the event currency.
     C                   EVAL      CCY      = AUEVTCCY
     C                   EXSR      GetCcyDP
     C                   EVAL      HEvtCcD  = A6CYNM
      *
      **    Set on indicator for the right decimal places of event amount.
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
     C                   ENDIF                                                  FI HEVTCCY<>AUEVTCCY
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
      *  Called By: WrtTTHeader                                       *
      *             WrtTotals                                         *
      *             WrtTTTotal                                        *
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
      /TITLE SR/WrtTTHeader
      *****************************************************************
      *                                                               *
      *  WrtTTHeader - Write Transaction Type Header and column       *
      *                header.  Check overflow first before any       *
      *                header.                                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:     ChkOverFlow                                       *
      *                                                               *
      *****************************************************************
      *
     C     WrtTTHeader   BEGSR
      *
      ** If change on transaction type or module, retrieve transaction type description.
     C                   IF        ChangeMod  = 'Y'       OR
     C                             HTRNTYP    <> AUTRNTYP
     C                   EVAL      HTRNTYP    =  AUTRNTYP
      *
     C                   SELECT
      *
      ** If module is DL, access FDDTSTL0 for description.
     C                   WHEN      AUMODULE    = 'DL'
     C     TSTKEy        CHAIN     FDDTSTL0
     C                   IF        %FOUND
     C                   EVAL      HTRNTYD     = NARR11
     C                   ELSE
     C                   EVAL      HTRNTYD     = *BLANKS
     C                   ENDIF
      *
      ** If module is LE, access SDLOANL0 for description.
     C                   WHEN      AUMODULE    = 'LE'
     C     TSTKEy        CHAIN     SDLOANL0
     C                   IF        %FOUND
     C                   EVAL      HTRNTYD     = AYLNTD
     C                   ELSE
     C                   EVAL      HTRNTYD     = *BLANKS
     C                   ENDIF
      *
     C                   OTHER
      ** Not LE, DL module, output blank to transaction type description.
     C                   EVAL      HTRNTYD     = *BLANKS
     C                   ENDSL
      *
     C                   ENDIF                                                  FI HTRNTYP<>AUTRNTYP
      *
      ** Ensure enough lines for new Transaction type heading and column headers.
     C                   EVAL      ReqRemLine = 6
     C                   EXSR      ChkOverFlow
      *
      ** Write Transaction type header
     C                   WRITE     SUBHTRNTP
      *
      ** Write column heading
     C                   WRITE     COLHEAD
      *
     C     WrtTTHeaderE  ENDSR
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
      *
      ** Edit event amount. (*IN35-38 have been set in SR. WrtHeader.)
     C                   SELECT
     C                   WHEN      *IN35  = *ON
     C                   EVAL      EVAMT0 = AUEVTAMT
     C                   WHEN      *IN36  = *ON
     C                   EVAL      EVAMT1 = AUEVTAMT
     C                   WHEN      *IN37  = *ON
     C                   EVAL      EVAMT2 = AUEVTAMT
     C                   WHEN      *IN38  = *ON
     C                   EVAL      EVAMT3 = AUEVTAMT
     C                   ENDSL
      *
      *
      ** Print credit or debit of event amount.
     C                   IF        AUDCI = 'C'
     C                   EVAL      *IN39 = *ON
     C                   ELSE
     C                   EVAL      *IN39 = *OFF
     C                   ENDIF
      *
      ** Edit reporting current amount. (*IN45-48 have been set in SR. WrtHeader.)
     C                   SELECT
     C                   WHEN      *IN45  = *ON                                 o decimal place
     C                   EVAL      RCAMT0 = AURCAAMT
     C                   WHEN      *IN46  = *ON                                 1 decimal places
     C                   EVAL      RCAMT1 = AURCAAMT
     C                   WHEN      *IN47  = *ON                                 2 decimal places
     C                   EVAL      RCAMT2 = AURCAAMT
     C                   WHEN      *IN48  = *ON                                 3 decimal places
     C                   EVAL      RCAMT3 = AURCAAMT
     C                   ENDSL
      *
      ** Print credit or debit of reporting currency amount.
     C                   IF        AUDCI = 'C'
     C                   EVAL      *IN49 = *ON
     C                   ELSE
     C                   EVAL      *IN49 = *OFF
     C                   ENDIF
      *
      ** Write details
     C                   WRITE     DETAIL
      *
      ** Add amount to totals
     C                   IF        AUDCI    = 'C'
     C                   EVAL      TTTotal  = TTTotal - AURCAAMT
     C                   ELSE
     C                   EVAL      TTTotal  = TTTotal + AURCAAMT
     C                   ENDIF
      *
     C     WrtDetailE    ENDSR
      *
      *****************************************************************
      /TITLE SR/WrtTTTotal
      *****************************************************************
      *                                                               *
      *  WrtTTTotal - Write transaction type total                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:     ChkOverFlow                                       *
      *                                                               *
      *****************************************************************
      *
     C     WrtTTTotal    BEGSR
      *
     C                   EVAL      TTRNTYP = HTRNTYP
      *
      ** Add transaction type total to other totals
     C                   EVAL      ECTotal = ECTotal + TTTotal
     C                   EVAL      MoTotal = MoTotal + TTTotal
     C                   EVAL      RATotal = RATotal + TTTotal
      *
      ** Edit transaction type total for output
     C                   SELECT
     C                   WHEN      *IN45  = *ON                                 o decimal place
     C                   EVAL      TTTotal0 = TTTotal
     C                   WHEN      *IN46  = *ON                                 1 decimal places
     C                   EVAL      TTTotal1 = TTTotal
     C                   WHEN      *IN47  = *ON                                 2 decimal places
     C                   EVAL      TTTotal2 = TTTotal
     C                   WHEN      *IN48  = *ON                                 3 decimal places
     C                   EVAL      TTTotal3 = TTTotal
     C                   ENDSL
      *
     C                   IF        TTTotal >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
      *
      ** Check remaining lines on the page for transaction type total.
     C                   EVAL      ReqRemLine = 2
     C                   EXSR      ChkOverFlow
      *
     C                   WRITE     TrnTypTtl
      *
     C                   EVAL      TTTotal = 0
      *
     C     WrtTTTotalE   ENDSR
      *
      *****************************************************************
      /TITLE SR/WrtTotals
      *****************************************************************
      *                                                               *
      *  WrtTotals - Write Totals (event currency, module, regulatory *
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
      ** If change on regulatory authority, write event currency, module and
      ** reg. authority totals and initial totals to zero.
     C                   WHEN      SaveRegAut <> AUREGAUT OR
     C                             %EOF
     C                   EVAL      ReqRemLine = 6
     C                   EXSR      ChkOverFlow
     C                   EXSR      WrtECTotal
     C                   EXSR      WrtMoTotal
     C                   EXSR      WrtRATotal
      *
      ** If change on module, write event currency, module totals.
     C                   WHEN      HMODULE <> AUMODULE
     C                   EVAL      ReqRemLine = 4
     C                   EXSR      ChkOverFlow
     C                   EXSR      WrtECTotal
     C                   EXSR      WrtMoTotal
      *
      ** ie, change on event currency, write event currnecy total.
     C                   Other
     C                   EVAL      ReqRemLine = 2
     C                   EXSR      ChkOverFlow
     C                   EXSR      WrtECTotal
     C                   ENDSL
      *
     C     WrtTotalsE    ENDSR
      *
      *****************************************************************
      /TITLE SR/WrtECTotal
      *****************************************************************
      *                                                               *
      *  WrtECTotal - Write event currency total                      *
      *                                                               *
      *  Called By: WrtTotals                                         *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WrtECTotal    BEGSR
      *
     C                   EVAL      TEvtCcy = HEvtCcy
      *
      ** Edit total for output
     C                   SELECT
     C                   WHEN      *IN45  = *ON                                 o decimal place
     C                   EVAL      ECTotal0 = ECTotal
     C                   WHEN      *IN46  = *ON                                 1 decimal places
     C                   EVAL      ECTotal1 = ECTotal
     C                   WHEN      *IN47  = *ON                                 2 decimal places
     C                   EVAL      ECTotal2 = ECTotal
     C                   WHEN      *IN48  = *ON                                 3 decimal places
     C                   EVAL      ECTotal3 = ECTotal
     C                   ENDSL
      *
     C                   IF        ECTotal >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
      *
     C                   WRITE     EvtCcyTtl
      *
     C                   EVAL      ECTotal = 0
      *
     C     WrtECTotalE   ENDSR
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
     C                   WRITE     ModulTtl
      *
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
      *
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
     C*                  PARM      PSEQ          SEQ               5
     C*                  PARM                    SENTY             3
     C                   PARM      *BLANK        SEQ               5
     C                   PARM      *BLANK        SENTY             3
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
(c) Finastra International Limited 2005
