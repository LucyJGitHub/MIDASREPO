     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas FRS Transaction/Acct Extraction Audit Rprt')
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting Interface               *
      *                                                               *
      *  RPGLE/RN000100 - Transaction/Account Extraction Audit Report *
      *                                                               *
      *  Function:  This module will read RNAUPNPD file and print     *
      *             each record on the extraction audit report.       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10699           Date 24Feb06               *
      *                 CRN001  *CREATE    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG10699 - Access GPFRSPPD using extended key.               *
      *  CRN001 - FRS Regulatory Reporting Interface                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *
      * RN Audit file
     FRNAUPNL0  IF   E           K DISK    INFSR(*PSSR)
      *
      * FRS Regulatory Authorities
     FGPREGAPD  IF   E           K DISK    INFSR(*PSSR)
      *
      * FRS Amount Types
     FRNAMTTPD  IF   E           K DISK    INFSR(*PSSR)
      *
      * FRS Product Codes
     FGPFRSPPD  IF   E           K DISK    INFSR(*PSSR)
      *
     FRN000100AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      *
     FRN000100P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *    59 - Print second line of product descriptiion             *
      *    60 - SDCURRL0 opened                                       *
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
      *  MAIN      - Main subroutine                                  *
      *  WRTHEADER - Write header                                     *
      *  WRTSUBHED - Write sub-header                                 *
      *  WRTDETAIL - Write detail line                                *
      *  CHKSUBTOT1- Check what subtotals to be printed               *
      *  CHKSUBTOT - Check what subtotals to be printed               *
      *  SetRqdLn  - Set the value for RqdLn to avoid overflow        *
      *  WRTSUBTOT - Write sub totals                                 *
      *  WRTTOTALS - Write Totals                                     *
      *  INITTOT   - Initialize work fields for totals                *
      *  SETPRVTOT - Set work fields for previous totals              *
      *  GETCCY    - Retrieve currency details                        *
      *  CHKOVRFLW - Check overflow                                   *
      *  AUDIT     - Produce Audit Report and End Program             *
      *  CLOSEDOWN - Return to Calling Program                        *
      *  *INZSR    - Subroutine to do Program Initialisation          *
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
      ***  File Information Data Structure for RN000100P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ***  File Information Data Structure for RN000100AU.
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
      ***  Work fields
     D FIRST           S              1
     D TOT             S                   LIKE(AURCAAMT)
     D TOT2            S                   LIKE(AURCAAMT)
     D TOT3            S                   LIKE(AURCAAMT)
     D TOT4            S                   LIKE(AURCAAMT)
     D TOT5            S                   LIKE(AURCAAMT)
     D TOT6            S                   LIKE(AURCAAMT)
     D TOTA            S                   LIKE(AURCAAMT)
     D TOTR            S                   LIKE(AURCAAMT)
     D CURTOT1         S              1
     D CURTOT2         S              1
     D CURTOT3         S              1
     D CURTOT4         S              1
     D CURTOT5         S              1
     D CURTOT6         S              1
     D PRVTOT1         S              1
     D PRVTOT2         S              1
     D PRVTOT3         S              1
     D PRVTOT4         S              1
     D PRVTOT5         S              1
     D PRVTOT6         S              1
     D LASTREC         S              1
     D LASTPRNT        S              1  0
     D TENS            S                   LIKE(AURCAAMT)
     D HUNDRED         S                   LIKE(AURCAAMT)
     D THOUSAND        S                   LIKE(AURCAAMT)
     D TENTHOU         S                   LIKE(AURCAAMT)
      *
     D PAUAMTTYP       S                   LIKE(AUAMTTYP)
     D PAUREGAUT       S                   LIKE(AUREGAUT)
     D PCOUNT          S              5  0
     D PRNTTOT2        S              1
     D PRNTTOT3        S              1
     D PRNTTOT4        S              1
     D PRNTTOT5        S              1
     D PRNTTOT6        S              1
     D STRING10        S             10
     D PRTNCOD         S              7
     D POPTION         S              7
     D RqdLn           S              2  0                                      Required lines 2 prt
     D FPDescLen       S              3  0                                      Prod. Desc code len
     D KFldRuleSet     S                   LIKE(FPRULESET)                                  BUG10699
     D KFldProdId      S                   LIKE(FPPRODID)                                   BUG10699
      *
     C     kProdCode     klist                                                              BUG10699
     C                   kfld                    KFldRuleSet                                BUG10699
     C                   kfld                    KFldProdId                                 BUG10699
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
     C                   EXSR      MAIN
      *
     C                   EXSR      CLOSEDOWN
      *
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
     C                   EXSR      INITTOT
      *
     C                   READ      RNAUPNL0
      *
     C                   DOW       NOT %EOF
      *
     C                   ADD       1             PCOUNT
      *
      ** On change of regulatory authority id or amount type, write new header
      *
     C                   SELECT
     C                   WHEN      PAUREGAUT  <> AUREGAUT
     C                             OR  PAUAMTTYP  <> AUAMTTYP
     C                   IF        FIRST = 'Y'
     C                   EVAL      FIRST = 'N'
     C                   ELSE
     C                   EXSR      CHKSUBTOT1
     C                   EXSR      WRTSUBTOT
     C                   EXSR      WRTTOTALS
     C                   ENDIF
     C                   EVALR     REGAUT  = %TRIMR(AUREGAUT)
     C                   EVAL      AMTTYP  = AUAMTTYP
     C                   EXSR      WRTHEADER
     C                   EXSR      WRTSUBHED
     C                   EXSR      SETPRVTOT
      *
      ** On change of product code, write previous total, retrieve product code
      ** description, write column heading.
      *
     C                   WHEN      PAUPRDCOD  <>  AUPRDCOD
     C                   EXSR      CHKSUBTOT
     C                   EXSR      WRTSUBTOT
     C                   EXSR      WRTSUBHED
      *
     C                   ENDSL
      *
      ** Details line
      *
     C                   EXSR      WRTDETAIL
      *
     C                   READ      RNAUPNL0
      *
     C                   ENDDO
      *
      ** If records printed, write Totals.
      *
     C                   IF        PCount > 0
     C                   EVAL      LASTREC = 'Y'
     C                   EXSR      CHKSUBTOT1
     C                   EXSR      WRTSUBTOT
     C                   EXSR      WRTTOTALS
      *
      ** Else if no record printed, write '*** NO DETAILS TO REPORT ***'
      *
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     NODTLS
     C                   ENDIF
      *
      ** Write Trailer
      *
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= 3
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     TRAILP1
      *
     C                   EXSR      AUDIT
      *
     C                   ENDSR
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      /TITLE SR/WRTHEADER
      *****************************************************************
      *                                                               *
      *  WRTHEADER  - Write Header                                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WRTHEADER     BEGSR
      *
     C                   WRITE     HEADP1
      *
      ** Retrieve regulatory authority description
      *
     C     AUREGAUT      CHAIN     GPREGAPD
     C                   IF        %FOUND
     C                   EVAL      REGNAME = RANAME
     C                   ELSE
     C                   EVAL      wDbFile  = 'GPREGAPD'
     C                   EVAL      wDBase   = 4
     C                   EVAL      wDbKey   = AUREGAUT
     c                   EVAL      wDbMod   = ' '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve amount type description
      *
     C                   EVAL      AMTTYP  = AUAMTTYP
     C     AUAMTTYP      CHAIN     RNAMTTPD
     C                   IF        %FOUND
     C                   EVAL      AMTYNME = AMTTYDES
     C                   ELSE
     C                   EVAL      AMTYNME = *BLANKS
     C                   ENDIF
      *
      ** Retrieve currency details
      *
     C                   EVAL      RPTCCY  = RARPTCCY
     C                   EXSR      GETCCY
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
     C                   EVAL      *IN48 = *OFF
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   MOVE      *ON           *IN45
     C                   WHEN      A6NBDP = 1
     C                   MOVE      *ON           *IN46
     C                   WHEN      A6NBDP = 2
     C                   MOVE      *ON           *IN47
     C                   WHEN      A6NBDP = 3
     C                   MOVE      *ON           *IN48
     C                   ENDSL
      *
      ** Write Header
      *
     C                   WRITE     HEADP2
      *
      ** Save previous regulatory authority, amount type and currency
      *
     C                   EVAL      PAUREGAUT   =  AUREGAUT
     C                   EVAL      PAUAMTTYP   =  AUAMTTYP
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/WRTSUBHED                                             *
      *****************************************************************
      *                                                               *
      *  WRTSUBHED - Write Subheading                                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WRTSUBHED     BEGSR
      *
      ** Retrieve product code description
      *
     C                   EVAL      PRDCOD   = AUPRDCOD
     C                   EVAL      CODNAME  = *BLANKS
     C                   EVAL      CODNAME2 = *BLANKS
     C*****AUPRDCOD***** CHAIN     GPFRSPPD                                                 BUG10699
      ** chain to file GPFRSPPD for the product code rule set.                              BUG10699
     C                   EVAL      KFldRuleSet = 1                                          BUG10699
     C                   EVAL      KFldProdId  = AUPRDCOD                                   BUG10699
     C     KProdCode     CHAIN     GPFRSPPD                                                 BUG10699
      ** if not found, try for the US product code rule set.                                BUG10699
     C                   IF        not %FOUND                                               BUG10699
     C                   EVAL      KFldRuleSet = 2                                          BUG10699
     C     KProdCode     CHAIN     GPFRSPPD                                                 BUG10699
     C                   ENDIF                                                              BUG10699
      *                                                                                     BUG10699
     C                   IF        %FOUND
      *
      ** Since the length of the field FPDESC is varying, need to get the length.
     C                   EVAL      FPDescLen = %Len(FPDESC)
     C                   IF        FPDescLen <= 93
     C                   EVAL      CODNAME  = %SUBST(FPDESC: 1:FPDescLen)
     C                   EVAL      *IN59    = '0'
     C                   ELSE
     C                   EVAL      CODNAME  = %SUBST(FPDESC: 1:93)
     C                   EVAL      CODNAME2 = %SUBST(FPDESC:94:FPDescLen-93)
     C                   EVAL      *IN59    = '1'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      RqdLn = 7
     C                   EXSR      ChkOvrFlw
     C                   WRITE     SUBHEAD1
     C                   EVAL      PAUPRDCOD  =   AUPRDCOD
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/WRTDETAIL
      *****************************************************************
      *                                                               *
      *  WRTDETAIL - Write Detail                                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WRTDETAIL     BEGSR
      *
      ** Edit amount
      *
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RAMT0 = AURCAAMT
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RAMT1 = AURCAAMT
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RAMT2 = AURCAAMT
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RAMT3 = AURCAAMT
     C                   ENDSL
      *
      ** Write credit or debit to the amount
      *
     C                   IF        AUDCI = 'C'
     C                   EVAL      *IN49 = *ON
     C                   ELSE
     C                   EVAL      *IN49 = *OFF
     C                   ENDIF
      *
      ** Write details
      *
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= 1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   WRITE     SubHead1
     C                   ENDIF
     C                   WRITE     DETAIL
      *
      ** Add amount to work fields for total
      *
     C                   IF        AUDCI    = 'C'
     C                   EVAL      TOT   = TOT  - AURCAAMT
     C                   ELSE
     C                   EVAL      TOT   = TOT  + AURCAAMT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/CHKSUBTOT1
      *****************************************************************
      *                                                               *
      *  CHKSUBTOT1 - Check What Subtotals To Be Printed              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     CHKSUBTOT1    BEGSR
      *
      ** Convert product code to character
      *
     C                   MOVE      PAUPRDCOD     STRING10
     C                   EVAL      CURTOT2 = %SUBST(STRING10:9:1)
     C                   EVAL      CURTOT3 = %SUBST(STRING10:8:1)
     C                   EVAL      CURTOT4 = %SUBST(STRING10:7:1)
     C                   EVAL      CURTOT5 = %SUBST(STRING10:6:1)
     C                   EVAL      CURTOT6 = %SUBST(STRING10:5:1)
      *
      ** Check what totals are to be printed
      *
     C                   EVAL      PRNTTOT2 = 'N'
     C                   EVAL      PRNTTOT3 = 'N'
     C                   EVAL      PRNTTOT4 = 'N'
     C                   EVAL      PRNTTOT5 = 'N'
     C                   EVAL      PRNTTOT6 = 'N'
     C                   SELECT
     C                   WHEN      CURTOT6 <> '0'
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      PRNTTOT3 = 'Y'
     C                   EVAL      PRNTTOT4 = 'Y'
     C                   EVAL      PRNTTOT5 = 'Y'
     C                   EVAL      PRNTTOT6 = 'Y'
     C                   EVAL      LASTPRNT = 6
     C                   WHEN      CURTOT5 <> '0'
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      PRNTTOT3 = 'Y'
     C                   EVAL      PRNTTOT4 = 'Y'
     C                   EVAL      PRNTTOT5 = 'Y'
     C                   EVAL      LASTPRNT = 5
     C                   WHEN      CURTOT4 <> '0'
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      PRNTTOT3 = 'Y'
     C                   EVAL      PRNTTOT4 = 'Y'
     C                   EVAL      LASTPRNT = 4
     C                   WHEN      CURTOT3 <> '0'
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      PRNTTOT3 = 'Y'
     C                   EVAL      LASTPRNT = 3
     C                   WHEN      CURTOT2 <> '0'
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      LASTPRNT = 2
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/CHKSUBTOT
      *****************************************************************
      *                                                               *
      *  CHKSUBTOT - Check What Subtotals To Be Printed               *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     CHKSUBTOT     BEGSR
      *
      ** Convert product code to character
      *
     C                   MOVE      AUPRDCOD      STRING10
     C                   EVAL      CURTOT2 = %SUBST(STRING10:9:1)
     C                   EVAL      CURTOT3 = %SUBST(STRING10:8:1)
     C                   EVAL      CURTOT4 = %SUBST(STRING10:7:1)
     C                   EVAL      CURTOT5 = %SUBST(STRING10:6:1)
     C                   EVAL      CURTOT6 = %SUBST(STRING10:5:1)
      *
      ** Check what totals are to be printed
      *
     C                   EVAL      PRNTTOT2 = 'N'
     C                   EVAL      PRNTTOT3 = 'N'
     C                   EVAL      PRNTTOT4 = 'N'
     C                   EVAL      PRNTTOT5 = 'N'
     C                   EVAL      PRNTTOT6 = 'N'
     C                   SELECT
     C                   WHEN      CURTOT6 <> PRVTOT6
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      PRNTTOT3 = 'Y'
     C                   EVAL      PRNTTOT4 = 'Y'
     C                   EVAL      PRNTTOT5 = 'Y'
     C                   EVAL      PRNTTOT6 = 'Y'
     C                   EVAL      LASTPRNT = 6
     C                   WHEN      CURTOT5 <> PRVTOT5
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      PRNTTOT3 = 'Y'
     C                   EVAL      PRNTTOT4 = 'Y'
     C                   EVAL      PRNTTOT5 = 'Y'
     C                   EVAL      LASTPRNT = 5
     C                   WHEN      CURTOT4 <> PRVTOT4
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      PRNTTOT3 = 'Y'
     C                   EVAL      PRNTTOT4 = 'Y'
     C                   EVAL      LASTPRNT = 4
     C                   WHEN      CURTOT3 <> PRVTOT3
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      PRNTTOT3 = 'Y'
     C                   EVAL      LASTPRNT = 3
     C                   WHEN      CURTOT2 <> PRVTOT2
     C                   EVAL      PRNTTOT2 = 'Y'
     C                   EVAL      LASTPRNT = 2
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SetRqdLn
      *****************************************************************
      *                                                               *
      *  SetRqdLn  - Set the value for RqdLn to avoid overflow when   *
      *              printing subtotal or total and keep the subtotals*
      *              or totals on the same page.                      *
      *                                                               *
      *  Called By: WrtSubTot                                         *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SetRqdLn      BEGSR
      *
     C                   SELECT
     C                   WHEN      PAUREGAUT  <> AUREGAUT OR
     C                             LASTREC     = 'Y'
     C                   EVAL      RqdLn = 14
     C                   WHEN      PAUAMTTYP  <> AUAMTTYP
     C                   EVAL      RqdLn = 12
     C                   OTHER
     C                   EVAL      RqdLn = (LastPrnt - 1) * 2
     C                   ENDSL
      *
     C     SeqRqdLnE     ENDSR
      *****************************************************************
      /TITLE SR/WRTSUBTOT
      *****************************************************************
      *                                                               *
      *  WRTSUBTOT - Write Sub-totals                                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WRTSUBTOT     BEGSR
      *
      ** Add total amount for previous product code to other totals
      *
     C                   EVAL      TOT2  = TOT2 + TOT
     C                   EVAL      TOT3  = TOT3 + TOT
     C                   EVAL      TOT4  = TOT4 + TOT
     C                   EVAL      TOT5  = TOT5 + TOT
     C                   EVAL      TOT6  = TOT6 + TOT
      *
      ** Total for previous product code
      *
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL00 = TOT
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL01 = TOT
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL02 = TOT
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL03 = TOT
     C                   ENDSL
     C                   IF        TOT >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   EVAL      RqdLn = 2
     C                   EXSR      CHKOVRFLW
     C                   WRITE     TOTAL
     C                   EVAL      TOT    = 0
      *
      ** Set the number of lines required to print the whole set of subtotals/totals
      *
     C                   EXSR      SetRqdLn
     C                   EXSR      CHKOVRFLW
      *
      ** Print sub-totals
      *
      ** Total for 0000X0
      *
     C                   IF        PRNTTOT2 = 'Y'
     C                   MOVEL     PAUPRDCOD     PRODCOD2
     C                   MOVE      '*'           PRODCOD2
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL20 = TOT2
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL21 = TOT2
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL22 = TOT2
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL23 = TOT2
     C                   ENDSL
     C                   IF        TOT2 >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTAL2
     C                   EVAL      TENS     = TENS  + TOT2
     C                   EVAL      TOT2     = 0
     C                   EVAL      PRVTOT2  = CURTOT2
     C                   ENDIF
      *
      ** Total for 000X00
      *
     C                   IF        PRNTTOT3 = 'Y'
     C                   MOVEL     PAUPRDCOD     PRODCOD3
     C                   MOVE      '**'          PRODCOD3
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL30 = TOT3
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL31 = TOT3
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL32 = TOT3
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL33 = TOT3
     C                   ENDSL
     C                   IF        TOT3 >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTAL3
     C                   EVAL      HUNDRED  = HUNDRED + TOT3
     C                   EVAL      TOT3     = 0
     C                   EVAL      PRVTOT3  = CURTOT3
     C                   ENDIF
      *
      ** Total for 00X000
      *
     C                   IF        PRNTTOT4 = 'Y'
     C                   MOVEL     PAUPRDCOD     PRODCOD4
     C                   MOVE      '***'         PRODCOD4
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL40 = TOT4
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL41 = TOT4
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL42 = TOT4
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL43 = TOT4
     C                   ENDSL
     C                   IF        TOT4 >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTAL4
     C                   EVAL      THOUSAND = THOUSAND + TOT4
     C                   EVAL      TOT4     = 0
     C                   EVAL      PRVTOT4  = CURTOT4
     C                   ENDIF
      *
      ** Total for 0X0000
      *
     C                   IF        PRNTTOT5 = 'Y'
     C                   MOVEL     PAUPRDCOD     PRODCOD5
     C                   MOVE      '****'        PRODCOD5
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL50 = TOT5
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL51 = TOT5
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL52 = TOT5
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL53 = TOT5
     C                   ENDSL
     C                   IF        TOT5 >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTAL5
     C                   EVAL      TENTHOU  = TENTHOU + TOT5
     C                   EVAL      TOT5     = 0
     C                   EVAL      PRVTOT5  = CURTOT5
     C                   ENDIF
      *
      ** Total for X00000
      *
     C                   IF        PRNTTOT6 = 'Y'
     C                   MOVEL     PAUPRDCOD     PRODCOD6
     C                   MOVE      '*****'       PRODCOD6
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL60 = TOT6
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL61 = TOT6
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL62 = TOT6
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL63 = TOT6
     C                   ENDSL
     C                   IF        TOT6 >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTAL6
     C                   EVAL      TOTA    = TOTA    + TOT6
     C                   EVAL      TOT6     = 0
     C                   EVAL      PRVTOT6  = CURTOT6
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/WRTTOTALS
      *****************************************************************
      *                                                               *
      *  WRTTOTALS - Write Totals                                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WRTTOTALS     BEGSR
      *
     C                   IF        LASTPRNT = 2
     C                   EVAL      PRODCOD3 = '00000000**'
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL30 = TENS
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL31 = TENS
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL32 = TENS
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL33 = TENS
     C                   ENDSL
     C                   IF        TENS >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTAL3
     C                   ENDIF
      *
     C                   IF        LASTPRNT = 3
     C                             OR  LASTPRNT = 2
     C                   EVAL      PRODCOD4 = '0000000***'
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL40 = HUNDRED
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL41 = HUNDRED
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL42 = HUNDRED
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL43 = HUNDRED
     C                   ENDSL
     C                   IF        HUNDRED >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTAL4
     C                   ENDIF
      *
     C                   IF        LASTPRNT = 4
     C                             OR  LASTPRNT = 3
     C                             OR  LASTPRNT = 2
     C                   EVAL      PRODCOD5 = '000000****'
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL50 = THOUSAND
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL51 = THOUSAND
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL52 = THOUSAND
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL53 = THOUSAND
     C                   ENDSL
     C                   IF        THOUSAND >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTAL5
     C                   ENDIF
      *
     C                   IF        LASTPRNT = 5
     C                             OR  LASTPRNT = 4
     C                             OR  LASTPRNT = 3
     C                             OR  LASTPRNT = 2
     C                   EVAL      PRODCOD6 = '00000*****'
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTAL60 = TENTHOU
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTAL61 = TENTHOU
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTAL62 = TENTHOU
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTAL63 = TENTHOU
     C                   ENDSL
     C                   IF        TENTHOU  >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTAL6
     C                   ENDIF
      *
      ** Grand total for amount type
      *
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTALA0 = TOTA
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTALA1 = TOTA
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTALA2 = TOTA
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTALA3 = TOTA
     C                   ENDSL
     C                   IF        TOTA     >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   WRITE     TOTALAMT
     C                   EVAL      TOTR   = TOTR + TOTA
      *
      ** Grand total for regulatory authority
     C                   IF        PAUREGAUT  <> AUREGAUT
     C                             OR  LASTREC  = 'Y'
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      RTOTALR0 = TOTR
     C                   WHEN      A6NBDP = 1
     C                   EVAL      RTOTALR1 = TOTR
     C                   WHEN      A6NBDP = 2
     C                   EVAL      RTOTALR2 = TOTR
     C                   WHEN      A6NBDP = 3
     C                   EVAL      RTOTALR3 = TOTR
     C                   ENDSL
     C                   IF        TOTR     >= 0
     C                   EVAL      *IN49 = *OFF
     C                   ELSE
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   EVAL      TREGAUT = PAUREGAUT
     C                   WRITE     TOTALREG
     C                   EVAL      TOTR   = TOTR + TOTA
     C                   EVAL      TOTR   = 0
     C                   ENDIF
      *
      ** Reset work fields for totals
      *
     C                   EVAL      TENS     = 0
     C                   EVAL      HUNDRED  = 0
     C                   EVAL      THOUSAND = 0
     C                   EVAL      TENTHOU  = 0
     C                   EVAL      TOTA     = 0
     C                   EVAL      LASTPRNT = 0
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/INITTOT
      *****************************************************************
      *                                                               *
      *  INITTOT   - Initialize Workfields for totals                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     INITTOT       BEGSR
      *
     C                   EVAL      TOT2     = 0
     C                   EVAL      TOT3     = 0
     C                   EVAL      TOT4     = 0
     C                   EVAL      TOT5     = 0
     C                   EVAL      TOT6     = 0
      *
     C                   EVAL      TENS     = 0
     C                   EVAL      HUNDRED  = 0
     C                   EVAL      THOUSAND = 0
     C                   EVAL      TENTHOU  = 0
     C                   EVAL      TOTA     = 0
     C                   EVAL      TOTR     = 0
      *
     C                   EVAL      LASTREC  = 'N'
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SETPRVTOT
      *****************************************************************
      *                                                               *
      *  SETPRVTOT  - Initialize Workfields for Previous Totals       *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SETPRVTOT     BEGSR
      *
     C                   MOVE      AUPRDCOD      STRING10
     C                   EVAL      PRVTOT2 = %SUBST(STRING10:9:1)
     C                   EVAL      PRVTOT3 = %SUBST(STRING10:8:1)
     C                   EVAL      PRVTOT4 = %SUBST(STRING10:7:1)
     C                   EVAL      PRVTOT5 = %SUBST(STRING10:6:1)
     C                   EVAL      PRVTOT6 = %SUBST(STRING10:5:1)
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/GETCCY
      *****************************************************************
      *                                                               *
      *  GETCCY   - Retrieve Currency Details                         *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     GETCCY        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        pRtnCod           7
     C                   PARM      '*KEY'        POPTION
     C                   PARM                    RPTCCY
     C     SDCURR        PARM                    DSSDY
      *
     C                   IF        pRtnCod <> *blank
     C                   EVAL      wDbFile  = 'SDCURRL1'
     C                   EVAL      wDBase   = 2
     C                   EVAL      wDbKey   = RPTCCY
     c                   EVAL      wDbMod   = 'AOCURRR0'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set on SDCURRL1 opened indicator.
     C  N60              SETON                                        60
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/CHKOVRFLW
      *****************************************************************
      *                                                               *
      *  CHKOVRFLW  - Check overflow                                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *             WrtSubHed                                         *
      *             WrtSubTol                                         *
      *                                                               *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     CHKOVRFLW     BEGSR
      *
     C     OFLLN1        SUB       PRTLN1        DIFLN1            3 0
     C     DIFLN1        IFLE      RqdLn
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/AUDIT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     AUDIT         BEGSR
      *
      ***  RCF Processing for Audit File.
     C                   EXSR      RCFAU
      *
      ***  Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ***  If there is a DB Error, Output the DB Error Information.
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ENDIF
      *
     C                   WRITE     TRAILAU
      *
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/CLOSEDOWN
      *****************************************************************
      *                                                               *
      *  CLOSEDOWN -  Return to Calling Program                       *
      *                                                               *
      *****************************************************************
     C     CLOSEDOWN     BEGSR
      *
      ** Close SDCURRL1 which has been opened.
     C                   IF        *IN60 = *ON
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        pRtnCod
     C                   PARM      '*FREE'       Poption
     C                   PARM      *BLANK        RptCcy
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
      *
     C                   ENDSR
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
     C                   MOVEL     'RN000100'    DBPGM
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
     C                   PARM      '*FIRST'      POPTION
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
     C                   ENDSR
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
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      *BLANKS       SENTY             3
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
     C                   ENDSR
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
     C                   ENDSR
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
