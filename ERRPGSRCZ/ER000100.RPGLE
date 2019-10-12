     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas @24 KWG data extraction')                        *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000100  - Midas @24 KWG workfile creation                  *
      *                                                               *
      *  Function : This program extracts the data needed for         *
      *             reporting according to @24 KWG and passes them to *
      *             the transmission file creation program via work   *
      *             files.                                            *
      *                                                               *
      *  Component of : ER000100                                      *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 263480             Date 25Nov14               *
      *                 MD029599           Date 25Nov14               *
      *                 CER070             Date 19Aug14               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 CGL132             Date 01May13               *
      *                 CER068             Date 25Feb14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 262700             Date 03Dec09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24209           Date 04Jun09               *
      *                 BUG24101           Date 27May09               *
      *                 BUG23995           Date 19May09               *
      *                 BUG23808           Date 27Apr09               *
      *                 BUG22521           Date 25Mar09               *
      *                 BUG22633           Date 09Mar09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  263480 - KWG 24c Reporting File Missing First Name. Date of  *
      *           Birth not included in the report. Corrected fix     *
      *           262700 in SR/SRSetFrmCust. Corrected the formatting *
      *           of Official field 18 and 20.                        *
      *         - Applied for MD030951.                               *
      *  MD029599 - KWG 24c Reporting File - Not all Authority Holders*
      *             Information are extracted                         *
      *           - add Data base error if the Authority holder does  *
      *             not exist in Non-Account holders file             *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CER068 - Upgrade CER047 to be compatible with BaFin 3.2.2    *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262700 - Various error in KWG extract, applied BUG25857A.    *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG24209 - Non Account Holders not captured correctly        *
      *  BUG24101 - KWG Extract does not capture non-account holders  *
      *  BUG23995 - Authority Holder/Retail account Link missinges    *
      *  BUG23808 - KWG Extract Report has Insufficient Data          *
      *  BUG22521 - Cannot navigate to Link Types Maintenance         *
      *  BUG22633 - Extraction process fail to extract data           *
      *           apply CCR for all subsequent records use            *
      *           creation date of reference record (found in history *
      *           file) instead of the deal / loan date (F12CDT)      *
      *  CER047 - German Features LF037-00 Reporting @24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *     70        Read to SDCUSTJ2 or ACCNTAB   - end of file     *
      *     75        Kind of check for the 'Retail' product group    *
      *               OFF = Customer Check, ON = Account Check        *
      *     80        Read to ERACEXL0 - end of file                  *
      *     88        Special processing for matured deals/accounts   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRFCrtDte - Subroutine to get final creation date            *                     BUG22633
      *  SRCrtNewRec - Create a new 'Institue Account Record'         *
      *  SRCusAutLink - Get authority holders via customer ->         *
      *               authority holder link                           *
      *  SRSetFrmCust - Set up fields from customer record            *
      *  SRSetFrmAuth - Set up fields from non-account holder record  *                     BUG24101
      *  SRLookupCty - Lookup country description                     *
      *  SRCheck - Subroutine to Check System Value KWGDeletionDays   *
      *  SRZDate10 - Subroutine to Convert YYYYMMDD Format Date to    *
      *              Midas Day No.                                    *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
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
      ** SDCUSTJ2 - Midas SD Join SDCUSTPD + Additional Details
      *
     FSDCUSTJ2  IF   E           K DISK    INFSR(*PSSR)
      *
      ** LBACCNL1 - Midas LB Accounts master file
      *
     FLBACCNL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(O)
      *
      ** DEALS    - MIDAS DL Deals file
      *
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDCF)
      *
      ** CLOAN    - MIDAS LE Loans file
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCLF)
      *
      ** FDDTSTL1 - MIDAS FD Deal type/subtype file
      *
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** SDLOANL1 - Midas SD Loan types/sub-types retrieval
      *
     FSDLOANL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** SDCUAHPD - MIDAS Customer to Authority Holder Link
      *
     F***SDCUAHL1**IF***E***********K*DISK*** INFSR(*PSSR)                                    262700
     FSDCUAHLA  IF   E           K DISK    INFSR(*PSSR)                                       262700
      *
      ** ERACEXL0 - Midas @24 KWG account record by account number
      *
     FERACEXL0  UF A E           K DISK    INFSR(*PSSR)
      *
      ** ERACEPL0 - Midas @24 KWG account record persons by account
      *
     FERACEPL0  UF A E           K DISK    INFSR(*PSSR)
      *                                                                                     BUG22633
      ** ERACEXL3 - Midas @24 KWG account record by creation date                           BUG22633
      *                                                                                     BUG22633
     FERACEXL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG22633
     F                                     RENAME(ERACEXD0: ERACEX3)                        BUG22633
     F                                     PREFIX(X)                                        BUG22633
      *                                                                                     BUG22521
      ** SDLINKPD - Midas SD Link Types Retrieval Index                                     BUG22521
      *                                                                                     BUG22521
     FSDLINKL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG22521
      *
      ** Midas SD Authority holder/Retail Account Link                                      BUG23995
      *                                                                                     BUG23995
     FSDACAHL0  IF   E           K DISK    INFSR(*PSSR)                                     BUG23995
      *                                                                                     BUG23995
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Declare constants for the call of 'AOSVALR0'
      *
     D  WSysvl         C                   CONST('KWGDeletionDays')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long Data Structure
      *
     D***DSSDY*        E DS                  EXTNAME(DSSDY)                                 BUG22633
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG22633
      *
      ** Data Structure for Additional Customer Details
      *
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(D)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structures for Country Details
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *                                                                                     BUG23808
      ** Customer Details                                                                   BUG23808
      *                                                                                     BUG23808
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG23808
     D                                     PREFIX(D)                                        BUG23808
      *                                                                                     BUG24101
      ** Non-account holder details                                                         BUG24101
      *                                                                                     BUG24101
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)                                BUG24101
     D                                     PREFIX(E)                                        BUG24101
      *
      ** Data structure to format separate dates into a 8N number
      *
     D WDFMT           DS
     D  WYEAR                  1      4  0
     D  WMNTH                  5      6  0
     D  WDAY                   7      8  0
     D  WDATE                  1      8  0
     D  WDAY2                  9     10  0
     D  WMNTH2                11     12  0
     D  WYEAR2                13     16  0
     D  WDATE2                 9     16  0
      *
      **  Data structure to compare last sent image with current image
      *
     D WLHIMG        E DS                  EXTNAME(ERACEXPD)
     D**WLHCMP**              36     70                                                       CER068
     D  WLHCMP                66    100                                                       CER068
      *
     D WLDIMG        E DS                  EXTNAME(ERACEPPD)
     D**WLDCMP**              47    865                                                       CER068
     D  WLDCMP                77    895                                                       CER068
      *
     D WCHIMG        E DS                  EXTNAME(ERACEXPD) PREFIX(D)
     D**WCHCMP**              36     70                                                       CER068
     D  WCHCMP                66    100                                                       CER068
      *
     D WCDIMG        E DS                  EXTNAME(ERACEPPD) PREFIX(D)
     D                                     OCCURS(100)
     D**WCDCMP**              47    865                                                       CER068
     D  WCDCMP                77    895                                                       CER068
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work Variables
      *
     D FACC            S                   LIKE(F12ACC)
     D FREF            S                   LIKE(F12REF)
     D FVDT            S                   LIKE(F12VDT)
     D FVTM            S                   LIKE(F12VTM)
     D FLinkType       S                   LIKE(CALTYP)
     D FLP             S              3P 0
     D FCP             S              3P 0
     D WWdayn          S              5P 0
     D DateOut         S              8S 0
     D FVTM1           S                   LIKE(F12VTM)
     D FTIME           S               T
     D FCurrentPass    S              1S 0
     D WDiffDays       S              5P 0
     D WWDelDays       S              5A
     D WDelDays        S              5P 0
     D CNUMA           S              6A
     D DLNOA           S              6A
     D LNRFA           S              6A
     D X               S              3P 0
     D WCtry           S              2A
     D WBkn            S              1A
     D WUtp            S              1A
     D WFnr            S              8P 0
     D PRtnCde         S              1P 0
     D FCNUMA          S              6P 0
     D FACCNTNO        S             10P 0
     D WWrtn           S              1A
     D WORDN           S              6A                                                    BUG22633
     D W12ACC          S                   LIKE(F12ACC)                                     BUG22633
     D W12REF          S                   LIKE(F12REF)                                     BUG22633
     D*WDLFLG***       S              1A                                             BUG22633 262700
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D PCustNo         S              6A
     D PCust           S             10A                                                    BUG23995
     D PNaho           S             10A                                                    BUG24101
     D PSvlk1          S             20A
     D PSVlk2          S             20A
     D PSVlk3          S             20A
     D PSVlk4          S             20A
     D PSVlk5          S             20A
     D PSVlk6          S             20A
     D PSVlk7          S             20A
     D PSVlk8          S             20A
     D PSVlk9          S             20A
     D PSvlk10         S             20A
      *
     D PSVl1           S            200A
     D PSVl2           S            200A
     D PSVl3           S            200A
     D PSVl4           S            200A
     D PSVl5           S            200A
     D PSVl6           S            200A
     D PSVl7           S            200A
     D PSVl8           S            200A
     D PSVl9           S            200A
     D PSVl10          S            200A
      *
     D PDateIn         S              8S 0
     D PDeldt          S              5P 0
     D PCnst           S              7A                                                    BUG23808
      *                                                                                     BUG23808
      ** Parameters for ZDATE9                                                              BUG23808
      *                                                                                     BUG23808
     D PZDayNo         S              5P 0                                                  BUG23808
     D PZDate1         S              8S 0                                                  BUG23808
     D PErrorFlag      S              1A                                                    BUG23808
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing ------------------------------+
      ** ¦                                                           ¦
      ** ¦ Initial processing is performed automatically: the *INZ   ¦
      ** ¦ executed at program activation.                           ¦
      ** ¦                                                           ¦
      ** +-----------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Extract data to be reported if file number is passed as *ZERO.
      ** A file number not equal *ZERO indicates recovery mode for
      ** the transmission file with that number. No data have to be
      ** extracted.
      *
     C                   IF        WFnr = 0
      *
      ** 1. PASS :
      ** Read through customer file
      *
     C                   DOU       *IN70
     C                   READ      @CUSTJ2                                70
     C                   IF        NOT(*IN70)
      *
      ** If this customer is not a subject to @24c then skip
      *
     C                   IF        E5S24C <> 'Y'
     C                   ITER
     C                   ENDIF
      *
      ** Logic has changed. Customers may not be reported as accounts
      ** anymore.
      ** To ensure that customers, that have been reported in the past,
      ** are 'closed' in the providers database,set a deletion date.
      ** This causes a FINAL record to be created and sent, if not
      ** already sent.
      *
     C                   EVAL      BBDTDL = BJRDNB
      *
      ** Get current image for this customer
      *
     C                   EVAL      FACC = '0000' + %TRIM(BBCUST)
     C**********         EVAL      FREF = 'Kundennummer'                                    BUG24101
     C                   EVAL      FREF = 'Cust Number'                                     BUG24101
     C                   CLEAR                   WCHIMG
      *
      ** Set Account number type to alphanumeric
      *
     C                   EVAL      DF12ATP = 'A'
      *
      ** Set Bankleitzahl and Reference
      *
     C                   EVAL      DF12BLZ = '00000000'
     C                   EVAL      DF12REF = FREF
      *
      ** Set creation date.
      *
     C                   CALLB     'ZDATE9'
     C                   PARM      BBORED        WWdayn
     C     DF12CDT       PARM                    DateOut
     C                   PARM                    WWrtn
      *
      ** Set deletion date, if appropriate.
      *
     C                   IF        BBDTDL <> 0
     C                   EVAL      BBDTDL = BJRDNB
     C                   CALLB     'ZDATE9'
     C                   PARM      BBDTDL        WWdayn
     C     DF12DDT       PARM                    DateOut
     C                   PARM                    WWrtn
     C                   ELSE
     C                   CLEAR                   DF12DDT
     C                   ENDIF
      *
      ** First person detail record. No address is reported for an
      ** account owner
      *
     C                   EVAL      FCP = 1
     C     FCP           OCCUR     WCDIMG
     C                   CLEAR                   WCDIMG
      *
      ** If this is not a 'Final' record then report the details about
      ** the person
      *
     C                   IF        BBDTDL = 0
     C                   EVAL      DF13CUS = BBCUST
     C                   EVAL      DF13PTP = 'K'
     C                   IF        E5TITL = *BLANKS                                           263480
     C                   EVAL      DF13SNM = E5CNA1
     C                   ELSE                                                                 263480
     C                   EVAL      DF13SNM = %TRIMR(E5TITL) + ' ' + E5CNA1                    263480
     C                   ENDIF                                                                263480
     C**********         EVAL      DF13FNM = E5TITL                                           263480
     C                   EVAL      DF13FNM = E5CNA2                                           263480
      *
      ** Set date of birth, if appropriate
      *
     C**********         IF        E5BRTH <> 0                                                262700
     C**********         Z-ADD     E5BRTH        WDATE2                                     BUG23808
     C**********         Z-ADD     WYEAR2        WYEAR                                      BUG23808
     C**********         Z-ADD     WMNTH2        WMNTH                                      BUG23808
     C**********         Z-ADD     WDAY2         WDAY                                       BUG23808
     C**********         Z-ADD     WDATE         DF13BDT                                    BUG23808
      *                                                                                     BUG23808
     C**********         EVAL      PZDayNo = E5BRTH                                  BUG23808 262700
     C**********         EXSR      SRZDate9                                          BUG23808 262700
      *                                                                                     BUG23808
     C**********         IF        PErrorFlag = '0'                                  BUG23808 262700
     C**********         Z-ADD     PZDate1       DF13BDT                             BUG23808 262700
     C**********         ENDIF                                                       BUG23808 262700
      *                                                                                     BUG23808
     C                   IF        E5DBTH <> *BLANKS                                          262700
     C                   MOVEL     E5DBTH        DF13BDT                                      262700
     C                   ELSE
     C                   CLEAR                   DF13BDT
     C                   ENDIF
      *
      ** If this is a 'Final' record then no details about a person
      ** are reported
      *
     C                   ELSE
     C                   EVAL      DF13PTP = 'A'
     C                   CLEAR                   DF13BDT
     C                   ENDIF
      *
      ** If this is not a 'Final' record then check for linked
      ** authority holders
      *
     C                   IF        BBDTDL = 0
     C                   EVAL      CACUST = BBCUST
     C                   EVAL      FCurrentPass = 1
     C                   EXSR      SRCusAutLink
     C                   ENDIF
      *
      ** Create new record
      *
     C                   EXSR      SRCrtNewRec
      *
     C                   ENDIF
     C                   ENDDO
      *
      ** 2. PASS :
      ** Read through account file
      *
     C                   DOU       *IN70
     C                   READ      ACCNTABF                               70
     C                   IF        NOT(*IN70)
      *
     C**********         MOVEL     CNUM          CNUMA                                      BUG23808
     C                   MOVEL     OCNUM         CNUMA                                      BUG23808
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CNUMA         PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG22633
     C*****SDACUS        PARM      SDACUS        DSSDY                                      BUG22633
      *
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = CNUMA
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   IF        PRtCd = *BLANKS
      *
     C                   IF        DE5S24C <> 'Y'
     C                   EVAL      OK24C = DE5S24C
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If this account is not a subject to @24c then skip
      *
     C                   IF        OK24C <> 'Y'
      *
      ** If this account is not a subject to @24c then it possible
      ** changed back to 'N', so assume that it is closed today
      *
     C                   EVAL      ODACC = BJRDNB
     C                   ENDIF
      *
      ** Get current image for this account
      *
     C**********         MOVEL(P)  OACNO         FACC                                         CER068
     C                   MOVEL(P)  OIBAN         FACC                                         CER068
     C                   CLEAR                   FREF
     C                   CLEAR                   WCHIMG
      *
      ** Set Account number type to numeric. Set currency
      *
     C**********         EVAL      DF12ATP = 'N'                                              CER068
     C                   EVAL      DF12ATP = 'A'                                              CER068
     C**********         EVAL      DF12CCY = CCY                                              262700
     C                   EVAL      DF12CCY = OCCY                                             262700
      *
      ** Set Bankleitzahl and Reference
      *
     C                   EVAL      DF12BLZ = '00000000'
     C                   EVAL      DF12REF = FREF
     C                   MOVEL     OACNO         DF12RFN                                      CER068
      *
      ** Set date account opened
      *
     C                   CALLB     'ZDATE9'
     C                   PARM      ODACO         WWdayn
     C     DF12CDT       PARM                    DateOut
     C                   PARM                    WWrtn
      *
      ** Set date account closed, if appropriate
      *
     C                   IF        ODACC <> 0
     C                   EVAL      ODACC = BJRDNB
      *
     C                   CALLB     'ZDATE9'
     C                   PARM      ODACC         WWdayn
     C     DF12DDT       PARM                    DateOut
     C                   PARM                    WWrtn
     C                   ELSE
     C                   CLEAR                   DF12DDT
      *
     C                   ENDIF
      *
      ** First person detail record. No address is reported for an
      ** account owner
      *
     C                   EVAL      FCP = 1
     C     FCP           OCCUR     WCDIMG
     C                   CLEAR                   WCDIMG
      *
      ** If this is not a 'Final' record then report the details about
      ** the person
      *
     C                   IF        ODACC = 0
     C**********         EVAL      DF13CUS = BBCUST                                         BUG23808
     C**********         EVAL      DF13CUS = DBBCUST                               BUG23808 BUG24101
     C                   EVAL      DF13CUS = DE5CUST                                        BUG24101
     C                   EVAL      DF13PTP = 'K'
     C**********         EVAL      DF13SNM = E5CNA1                                         BUG23808
     C**********         EVAL      DF13FNM = E5TITL                                         BUG23808
     C                   IF        DE5TITL = *BLANKS                                          263480
     C                   EVAL      DF13SNM = DE5CNA1                                        BUG23808
     C                   ELSE                                                                 263480
     C                   EVAL      DF13SNM = %TRIMR(DE5TITL) + ' ' + DE5CNA1                  263480
     C                   ENDIF                                                                263480
     C**********         EVAL      DF13FNM = DE5TITL                                 BUG23808 263480
     C                   EVAL      DF13FNM = DE5CNA2                                          263480
     C                   MOVEL     OACNO         DF13RFN                                      CER068
      *
      ** Set date of birth, if appropriate
      *
     C**********         IF        E5BRTH <> 0                                              BUG23808
     C**********         Z-ADD     E5BRTH        WDATE2                                     BUG23808
     C**********         Z-ADD     WYEAR2        WYEAR                                      BUG23808
     C**********         Z-ADD     WMNTH2        WMNTH                                      BUG23808
     C**********         Z-ADD     WDAY2         WDAY                                       BUG23808
     C**********         Z-ADD     WDATE         DF13BDT                                    BUG23808
      *                                                                                     BUG23808
     C**********         IF        DE5BRTH <> 0                                      BUG23808 262700
      *                                                                                     BUG23808
     C**********         EVAL      PZDayNo = DE5BRTH                                 BUG23808 262700
     C**********         EXSR      SRZDate9                                          BUG23808 262700
      *                                                                                     BUG23808
     C**********         IF        PErrorFlag = '0'                                  BUG23808 262700
     C**********         Z-ADD     PZDate1       DF13BDT                             BUG23808 262700
     C**********         ENDIF                                                       BUG23808 262700
      *                                                                                     BUG23808
     C                   IF        DE5DBTH  <> *BLANKS                                        262700
     C                   MOVEL     DE5DBTH       DF13BDT                                      262700
     C                   ELSE
     C                   CLEAR                   DF13BDT
     C                   ENDIF
      *
      ** If this is a 'Final' record then no details about a person
      ** are reported
      *
     C                   ELSE
     C                   EVAL      DF13PTP = 'A'
     C                   CLEAR                   DF13BDT
     C                   ENDIF
      *
      ** If this is not a 'Final' record then check for linked
      ** authority holders
      *
     C                   IF        ODACC = 0
     C**********         MOVEL(P)  CNUM          CACUST                                     BUG23808
     C                   MOVEL(P)  OCNUM         CACUST                                     BUG23808
     C                   EVAL      AAACNO = OACNO                                           BUG23995
     C                   EVAL      FCurrentPass = 2
     C                   EXSR      SRCusAutLink
     C                   EXSR      SRAccAutLink                                             BUG23995
     C                   ENDIF
      *
      ** If this account is not a subject to @24c set reason code for
      ** audit report
      *
     C                   IF        OK24C <> 'Y'
     C                   EVAL      DF12RCD = 'A'
     C                   ENDIF
      *
      ** Create new record
      *
     C                   EXSR      SRCrtNewRec
      *
     C                   ENDIF
     C                   ENDDO
      *
      ** 3. PASS :
      ** Read through deals file
      *
     C                   DOU       *IN70
     C                   READ      DEALSDCF                               70
     C                   IF        NOT(*IN70)
      *
      ** Check if this deal is a subject to @24c
      *
     C     KLdtst        CHAIN     FDDTSTPD
     C                   IF        NOT(%FOUND)
     C                   MOVEL     'FDDTSTX0'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     '*KEY   '     DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     BUG22633
      ** Keep original deal number to get initial creation date                             BUG22633
      *                                                                                     BUG22633
     C                   MOVEL     ORDN          WORDN                                      BUG22633
     C                   EVAL      W12ACC = '0000' + %TRIM(WORDN)                           BUG22633
     C                   EVAL      W12REF = 'Deal'                                          BUG22633
     C**********         EVAL      WDLFLG = 'Y'                                      BUG22633 262700
      *
      ** Check if customer of the deal is a subject to @24c
      *
     C                   MOVEL     CNUM          CNUMA
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CNUMA         PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG22633
     C*****SDACUS        PARM      SDACUS        DSSDY                                      BUG22633
      *
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = CNUMA
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   IF        DE5S24C <> 'Y'
     C                   EVAL      FSK24C = DE5S24C
     C                   ENDIF
      *
      ** Check if deal has matured today and was also entered today.
      ** If so, special processing must take place.
      ** An 'account open' must be created (done by setting maturity
      ** date to 0) followed by an 'account closure' (using todays date
      ** as maturity date and loop back to here)
      *
     C                   IF        MDAT = BJRDNB AND ORED = BJRDNB
     C                   EVAL      MDAT = 0
     C                   SETON                                        88
     C                   ELSE
     C     TagDeal1      TAG
     C                   SETOFF                                       88
     C                   ENDIF
      *
      ** Check if deal has been reversed/deleted, maturity is set to
      ** last change date
      *
     C                   IF        CHTP = 'R'
     C                   EVAL      MDAT = LCD
     C                   ENDIF
      *
      ** Check if deal has matured, that is if maturity date is not
      ** after today's date
      *
     C                   IF        MDAT > BJRDNB
     C                   EVAL      MDAT = 0
     C                   ENDIF
      *                                                                                     BUG22633
      ** Apply GEMS 256075 to make extract from DEALS similar to LOANS                      BUG22633
      **********                                                                            BUG22633
      ***Check*if deal has retail accounts as settlement accounts                           BUG22633
      ***(Settlement Typ 14)                                                                BUG22633
      **********                                                                            BUG22633
     C**********         IF        FSK24C = 'Y'                                             BUG22633
     C**********         IF        SDST = 14 AND MDST = 14                                  BUG22633
      **********                                                                            BUG22633
      ***Check*if retail accounts having the same customer as the deal                      BUG22633
      **********                                                                            BUG22633
     C**********         MOVEL     OSDA          FACCNTNO                                   BUG22633
     C**********         MOVEL     CNUMA         FCNUMA                                     BUG22633
     C*****KLaccnt       CHAIN     ACCNTABF                                                 BUG22633
      **********                                                                            BUG22633
     C**********         IF        NOT(%FOUND)                                              BUG22633
     C**********         EVAL      FSK24C = 'N'                                             BUG22633
     C**********         ENDIF                                                              BUG22633
      **********                                                                            BUG22633
     C**********         IF        OCNUM = CNUM AND FSK24C = 'Y'                            BUG22633
      **********                                                                            BUG22633
     C**********         MOVEL     OMDA          FACCNTNO                                   BUG22633
     C**********         MOVEL     CNUMA         FCNUMA                                     BUG22633
     C*****KLaccnt       CHAIN     ACCNTABF                                                 BUG22633
      **********                                                                            BUG22633
     C**********         IF        NOT(%FOUND)                                              BUG22633
     C**********         EVAL      FSK24C = 'N'                                             BUG22633
     C**********         ENDIF                                                              BUG22633
      **********                                                                            BUG22633
     C**********         IF        OCNUM = CNUM                                             BUG22633
     C**********         EVAL      FSK24C = 'N'                                             BUG22633
     C**********         ENDIF                                                              BUG22633
      **********                                                                            BUG22633
     C**********         ENDIF                                                              BUG22633
     C**********         ENDIF                                                              BUG22633
     C**********         ENDIF                                                              BUG22633
      *
      ** If this deal is not a subject to @24c then it possible changed
      ** back to 'N',so assume that it has matured today
      *
     C                   IF        FSK24C <> 'Y'
     C                   EVAL      MDAT = BJRDNB
     C                   ENDIF
      *
      ** Get current image for this deal
      *
     C                   MOVEL     DLNO          DLNOA
     C                   EVAL      FACC = '0000' + %TRIM(DLNOA)
     C                   EVAL      FREF = 'Deal'
     C                   CLEAR                   WCHIMG
      *
      ** Set Account number type to numeric. Set currency
      *
     C                   EVAL      DF12ATP = 'N'
     C                   EVAL      DF12CCY = CCY
      *
      ** Set Bankleitzahl and Reference
      *
     C                   EVAL      DF12BLZ = '00000000'
     C                   EVAL      DF12REF = FREF
      *
      ** Set date deal opened (deal date)
      *
     C                   CALLB     'ZDATE9'
     C                   PARM      DDAT          WWdayn
     C     DF12CDT       PARM                    DateOut
     C                   PARM                    WWrtn
      *
      ** Set date deal matured, if appropriate
      *
     C                   IF        MDAT <> 0
     C                   EVAL      MDAT = BJRDNB
      *
     C                   CALLB     'ZDATE9'
     C                   PARM      MDAT          WWdayn
     C     DF12DDT       PARM                    DateOut
     C                   PARM                    WWrtn
     C                   ELSE
     C                   CLEAR                   DF12DDT
     C                   ENDIF
      *
      ** First person detail record. No address is reported for an
      ** account owner
      *
     C                   EVAL      FCP = 1
     C     FCP           OCCUR     WCDIMG
     C                   CLEAR                   WCDIMG
      *
      ** If this is not a 'Final' record then report the details about
      ** the person
      *
     C                   IF        MDAT = 0
     C**********         EVAL      DF13CUS = BBCUST                                         BUG23808
     C**********         EVAL      DF13CUS = DBBCUST                               BUG23808 BUG24209
     C                   EVAL      DF13CUS = DE5CUST                                        BUG24209
     C                   EVAL      DF13PTP = 'K'
     C**********         EVAL      DF13SNM = E5CNA1                                         BUG23808
     C**********         EVAL      DF13FNM = E5TITL                                         BUG23808
     C                   IF        DE5TITL = *BLANKS                                          263480
     C                   EVAL      DF13SNM = DE5CNA1                                        BUG23808
     C                   ELSE                                                                 263480
     C                   EVAL      DF13SNM = %TRIMR(DE5TITL) + ' ' + DE5CNA1                  263480
     C                   ENDIF                                                                263480
     C**********         EVAL      DF13FNM = DE5TITL                                 BUG23808 263480
     C                   EVAL      DF13FNM = DE5CNA2                                          263480
      *
      ** Set date of birth, if appropriate
      *
     C**********         IF        E5BRTH  <> 0                                             BUG23808
     C**********         Z-ADD     E5BRTH        WDATE2                                     BUG23808
     C**********         Z-ADD     WYEAR2        WYEAR                                      BUG23808
     C**********         Z-ADD     WMNTH2        WMNTH                                      BUG23808
     C**********         Z-ADD     WDAY2         WDAY                                       BUG23808
     C**********         Z-ADD     WDATE         DF13BDT                                    BUG23808
      *                                                                                     BUG23808
     C**********         IF        DE5BRTH <> 0                                      BUG23808 262700
      *                                                                                     BUG23808
     C**********         EVAL      PZDayNo = DE5BRTH                                 BUG23808 262700
     C**********         EXSR      SRZDate9                                          BUG23808 262700
      *                                                                                     BUG23808
     C**********         IF        PErrorFlag = '0'                                  BUG23808 262700
     C**********         Z-ADD     PZDate1       DF13BDT                             BUG23808 262700
     C**********         ENDIF                                                       BUG23808 262700
      *                                                                                     BUG23808
     C                   IF        DE5DBTH <> *BLANKS                                         262700
     C                   MOVEL     DE5DBTH       DF13BDT                                      262700
     C                   ELSE
     C                   CLEAR                   DF13BDT
     C                   ENDIF
      *
      ** If this is a 'Final' record then no details about a person are
      ** reported
      *
     C                   ELSE
     C                   EVAL      DF13PTP = 'A'
     C                   CLEAR                   DF13BDT
     C                   ENDIF
      *
      ** If this is not a 'Final' record then check for linked
      ** authority holders
      *
     C                   IF        MDAT = 0
     C                   MOVEL(P)  CNUM          CACUST
     C                   EVAL      FCurrentPass = 3
     C                   EXSR      SRCusAutLink
     C                   ENDIF
      *
      ** If this deal is not a subject to @24c set reason code for
      ** audit report
      *
     C                   IF        FSK24C <> 'Y'
     C                   EVAL      DF12RCD = 'A'
     C                   ENDIF
      *
      ** Create new record
      *
     C                   EXSR      SRCrtNewRec
      *
      ** If special processing enabled, loop back
      *
     C                   IF        *IN88 AND MDAT = 0
     C                   EVAL      MDAT = BJRDNB
     C                   GOTO      TagDeal1
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
      ** 4. PASS :
      ** Read through loans file
      *
     C                   DOU       *IN70
     C                   READ      CLOANCLF                               70
     C                   IF        NOT(*IN70)
      *
      ** Check if this loan is a subject to @24c
      *
     C     KLOAN         CHAIN     @AYRECL
     C                   IF        NOT(%FOUND)
     C                   MOVEL     'SDLOANX0'    DBFILE
     C                   MOVEL     '008'         DBASE
     C                   MOVEL     '*KEY   '     DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if customer of the loan is a subject to @24c
      *
     C                   MOVEL     CNUM          CNUMA
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CNUMA         PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG22633
     C*****SDACUS        PARM      SDACUS        DSSDY                                      BUG22633
      *
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = CNUMA
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBASE = 009
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   IF        DE5S24C <> 'Y'
     C                   EVAL      AYK24C = DE5S24C
     C                   ENDIF
      *
      ** Check if loan has matured today and was also entered today.
      ** If so, special processing must take place. An 'account open'
      ** must be created (done by setting maturity date to 0) followed
      ** by an 'account closure' (using todays date as maturity date
      ** and loop back to here).
      *
     C                   IF        MDAT = BJRDNB AND ORED = BJRDNB
     C                   EVAL      MDAT = 0
     C                   SETON                                        88
     C                   ELSE
     C     TagLoan1      TAG
     C                   SETOFF                                       88
     C                   ENDIF
      *
      ** Check if loan has been reversed/deleted, maturity is set to
      ** last change date
      *
     C                   IF        CHTP = 'R'
     C                   EVAL      MDAT = LCD
     C                   ENDIF
      *
      ** Check if loan has matured, that is if maturity date is not
      ** after today's date
      *
     C                   IF        MDAT > BJRDNB
     C                   EVAL      MDAT = 0
     C                   ENDIF
      *
      ** If this loan is not a subject to @24c then it possible changed
      ** back to 'N', so assume that it has matured today
      *
     C                   IF        AYK24C <> 'Y'
     C                   EVAL      MDAT = BJRDNB
     C                   ENDIF
      *
      ** Get current image for this loan
      *
     C                   MOVEL     LNRF          LNRFA
     C                   EVAL      FACC = '0000' + %TRIM(LNRFA)
     C                   EVAL      FREF = 'Loan'
     C                   CLEAR                   WCHIMG
      *
      ** Set Account number type to numeric. Set currency
      *
     C                   EVAL      DF12ATP = 'N'
     C                   EVAL      DF12CCY = CCY
      *
      ** Set Bankleitzahl and Reference
      *
     C                   EVAL      DF12BLZ = '00000000'
     C                   EVAL      DF12REF = FREF
      *
      ** Set date loan opened (deal date)
      *
     C                   CALLB     'ZDATE9'
     C                   PARM      DDAT          WWdayn
     C     DF12CDT       PARM                    DateOut
     C                   PARM                    WWrtn
      *
      ** Set date loan matured, if appropriate
      *
     C                   IF        MDAT <> 0
     C                   EVAL      MDAT = BJRDNB
     C                   CALLB     'ZDATE9'
     C                   PARM      MDAT          WWdayn
     C     DF12DDT       PARM                    DateOut
     C                   PARM                    WWrtn
     C                   ELSE
     C                   CLEAR                   DF12DDT
     C                   ENDIF
      *
      ** First person detail record. No address is reported for an
      ** account owner
      *
     C                   EVAL      FCP = 1
     C     FCP           OCCUR     WCDIMG
     C                   CLEAR                   WCDIMG
      *
      ** If this is not a 'Final' record then report the details about
      ** the person
      *
     C                   IF        MDAT = 0
     C**********         EVAL      DF13CUS = BBCUST                                         BUG23808
     C**********         EVAL      DF13CUS = DBBCUST                               BUG23808 BUG24209
     C                   EVAL      DF13CUS = DE5CUST                                        BUG24209
     C                   EVAL      DF13PTP = 'K'
     C**********         EVAL      DF13SNM = E5CNA1                                         BUG23808
     C**********         EVAL      DF13FNM = E5TITL                                         BUG23808
     C                   IF        DE5TITL = *BLANKS                                          263480
     C                   EVAL      DF13SNM = DE5CNA1                                        BUG23808
     C                   ELSE                                                                 263480
     C                   EVAL      DF13SNM = %TRIMR(DE5TITL) + ' ' + DE5CNA1                  263480
     C                   ENDIF                                                                263480
     C**********         EVAL      DF13FNM = DE5TITL                                 BUG23808 263480
     C                   EVAL      DF13FNM = DE5CNA2                                          263480
      *
      ** Set date of birth, if appropriate
      *
     C**********         IF        E5BRTH  <> 0                                             BUG23808
     C**********         Z-ADD     E5BRTH        WDATE2                                     BUG23808
     C**********         Z-ADD     WYEAR2        WYEAR                                      BUG23808
     C**********         Z-ADD     WMNTH2        WMNTH                                      BUG23808
     C**********         Z-ADD     WDAY2         WDAY                                       BUG23808
     C**********         Z-ADD     WDATE         DF13BDT                                    BUG23808
      *                                                                                     BUG23808
     C**********         IF        DE5BRTH <> 0                                      BUG23808 262700
      *                                                                                     BUG23808
     C**********         EVAL      PZDayNo = DE5BRTH                                 BUG23808 262700
     C**********         EXSR      SRZDate9                                          BUG23808 262700
      *                                                                                     BUG23808
     C**********         IF        PErrorFlag = '0'                                  BUG23808 262700
     C**********         Z-ADD     PZDate1       DF13BDT                             BUG23808 262700
     C**********         ENDIF                                                       BUG23808 262700
      *                                                                                     BUG23808
     C                   IF        DE5DBTH <> *BLANKS                                         262700
     C                   MOVEL     DE5DBTH       DF13BDT                                      262700
     C                   ELSE
     C                   CLEAR                   DF13BDT
     C                   ENDIF
      *
      ** If this is a 'Final' record then no details about a person are
      ** reported
      *
     C                   ELSE
     C                   EVAL      DF13PTP = 'A'
     C                   CLEAR                   DF13BDT
     C                   ENDIF
      *
      ** If this is not a 'Final' record then check for linked
      ** authority holders
      *
     C                   IF        MDAT = 0
     C                   MOVEL(P)  CNUM          CACUST
     C                   EVAL      FCurrentPass = 4
     C                   EXSR      SRCusAutLink
     C                   ENDIF
      *
      ** If this loan is not a subject to @24c set reason code for
      ** audit report
      *
     C                   IF        AYK24C <> 'Y'
     C                   EVAL      DF12RCD = 'A'
     C                   ENDIF
      *
      ** Create new record
      *
     C                   EXSR      SRCrtNewRec
      *
      ** If special processing enabled loop back
      *
     C                   IF        *IN88 AND MDAT = 0
     C                   EVAL      MDAT = BJRDNB
     C                   GOTO      TagLoan1
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *                                                                                       262700
      ** Delete KWG history file                                                              262700
      *                                                                                       262700
     C                   EXSR      SRDelete                                                   262700
      *
      ** Call workfile creation program
      *
     C                   CALLB     'ER000101'
     C                   PARM                    WBkn
     C                   PARM                    WUtp
     C                   PARM                    WFnr
     C                   PARM                    PRtnCde
      *
      ** End the program
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCrtNewRec - Create a new 'Institue Account Record'         *
      *                                                               *
      *  Called By : MAIN Processing                                  *
      *                                                               *
      *  Calls : SRCheck, SRZDate10, *PSSR                            *
      *                                                               *
      *****************************************************************
      *
     C     SRCrtNewRec   BEGSR
      *
      ** Check if this record was sent in the past
      *
     C     KL1210        SETGT     ERACEXL0
     C     PrevRec       TAG
     C     KL1210        READPE(N) ERACEXD0                               80
      *
      ** If found, but flagged as 'in error' then ignore and read
      ** previous record
      *
     C                   IF        NOT(*IN80) AND F12SNT = 'E'
     C                   GOTO      PrevRec
     C                   ENDIF
      *
      ** If in update mode and record was found, get last image and
      ** compare with current image. If both match, ignore
      *
     C                   IF        NOT(*IN80) AND WUtp = 'U'
      *
     C                   IF        WLHCMP = WCHCMP
     C                   CLEAR                   FLP
      *
     C     KLerac        SETLL     ERACEPL0
     C     KLerac        READE(N)  ERACEPD0
      *
     C                   DOW       NOT(%EOF)
     C                   EVAL      FLP = FLP + 1
     C     FLP           OCCUR     WCDIMG
      *
     C                   IF        WLDCMP <> WCDCMP
     C                   LEAVE
     C                   ENDIF
      *
     C     KLerac        READE(N)  ERACEPD0
     C                   ENDDO
      *
     C                   IF        %EOF AND FLP = FCP
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Create a new 'Institute Account Record'
      *
     C                   MOVEL     WCHIMG        WLHIMG
     C                   EVAL      F12ACC = FACC
      *
      ** Set 'Valid from Date' and 'Valid from Time'
      *
     C                   EVAL      F12VDT = FVDT
     C                   EVAL      F13VDT = FVDT
     C                   EVAL      F12VTM = FVTM
     C                   EVAL      F13VTM = FVTM
      *
      ** If special processing is enabled, set other 'Valid from Time'
      *
     C                   IF        *IN88
     C                   EVAL      F12VTM = FVTM1
     C                   EVAL      F13VTM = FVTM1
     C                   ENDIF
      *
     C                   SELECT
      *
      ** Initial record (not yet sent, not deleted and not added today)
      *
     C                   WHEN      *IN80 AND F12DDT = 0 AND
     C                             F12CDT <> FVDT
      *
     C                   SELECT
      *
     C                   WHEN      WBkn = 'B'
     C                   EVAL      F12DTP = 'I'
      *
     C                   WHEN      WBkn = 'T'
     C                   EVAL      F12DTP = 'N'
     C                   EVAL      F12VDT = F12CDT
     C                   EVAL      F13VDT = F12CDT
      *
     C                   ENDSL
      *
      ** Final record (previously sent and deleted)
      *
     C                   WHEN      NOT(*IN80) AND F12DDT <> 0
      *
      ***Instead*of*deal/loan*date*used*creation*date*from*reference*record          BUG22633 262700
      **********                                                                     BUG22633 262700
     C**********         IF        WDLFLG = 'Y'                                      BUG22633 262700
     C**********         EXSR      SRFCrtDte                                         BUG22633 262700
     C**********         ENDIF                                                       BUG22633 262700
      *                                                                                     BUG22633
     C                   SELECT
      *
     C                   WHEN      WBkn = 'B'
     C                   EVAL      F12DTP = 'F'
      *
     C                   WHEN      WBkn = 'T'
     C                   EVAL      F12DTP = 'E'
      *
     C                   ENDSL
      *
      ** New record (not yet sent and added today)
      *
     C                   WHEN      *IN80 AND F12CDT = FVDT AND
     C                             F12DDT = 0
     C                   EVAL      F12DTP = 'N'
      *
      ** Changed record (previously sent)
      *
     C                   WHEN      NOT(*IN80)
      *
      ***Instead*of*deal/loan*date*used*creation*date*from*reference*record          BUG22633 262700
      **********                                                                     BUG22633 262700
     C**********         IF        WDLFLG = 'Y'                                      BUG22633 262700
     C**********         EXSR      SRFCrtDte                                         BUG22633 262700
     C**********         ENDIF                                                       BUG22633 262700
      *                                                                                     BUG22633
     C                   SELECT
      *
     C                   WHEN      WBkn = 'B'
     C                   EVAL      F12DTP = 'C'
      *
     C                   WHEN      WBkn = 'T'
     C                   EVAL      F12DTP = 'U'
      *
     C                   ENDSL
      *
      ** Ignore record
      *
     C                   OTHER
     C                   LEAVESR
     C                   ENDSL
      *
      ** Add new account header record for report
      *
     C                   CLEAR                   F12SNT
     C                   CLEAR                   F12FNR
     C                   WRITE     ERACEXD0
      *
      ** Add new account detail record for report
      *
     C                   DO        FCP           X
     C     X             OCCUR     WCDIMG
     C                   MOVEL     WCDIMG        WLDIMG
     C                   EVAL      F13ACC = F12ACC
     C                   EVAL      F13REF = F12REF
     C                   EVAL      F13VDT = F12VDT
     C                   EVAL      F13VTM = F12VTM
     C                   WRITE     ERACEPD0
     C                   ENDDO
      *
     C**********         EXSR      SRCheck                                                    262700
     C**********         IF        WDelDays <> 0                                              262700
      **********                                                                              262700
     C******LOVAL        SETLL     ERACEXD0                                                   262700
     C**********         READ      ERACEXD0                                                   262700
     C**********         DOW       NOT %EOF(ERACEXL0)                                         262700
      **********                                                                              262700
     C**********         IF        F12DDT <> 0                                       BUG22633 262700
     C**********         EVAL      PDateIn = F12DDT                                           262700
      **********                                                                              262700
     C**********         EXSR      SRZDate10                                                  262700
      **********                                                                              262700
     C**********         EVAL      WDiffDays  = BJRDNB - PDeldt                               262700
     C**********         IF        WDiffDays  > WDelDays                                      262700
     C**********         DELETE    ERACEXD0                                                   262700
      **********                                                                              262700
     C     KLerac        CHAIN     ERACEPL0
      **********                                                                              262700
     C**********         IF        NOT(%FOUND)                                                262700
     C**********         EVAL      DBFILE = 'ERACEPL0'                                        262700
     C**********         EVAL      DBASE = 010                                                262700
     C**********         EVAL      DBKEY = '*KEY   '                                          262700
     C**********         EXSR      *PSSR                                                      262700
     C**********         ENDIF                                                                262700
      **********                                                                              262700
     C**********         DELETE    ERACEPD0                                                   262700
      **********                                                                              262700
     C**********         ENDIF                                                                262700
     C**********         ENDIF                                                       BUG22633 262700
     C**********         READ      ERACEXD0                                                   262700
      **********                                                                              262700
     C**********         ENDDO                                                                262700
      *
     C**********         ENDIF                                                                262700
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCusAutLink - Get authority holders via customer ->         *
      *               authority holder link                           *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRSetFrmCust                                          *
      *         SRSetFrmAuth                                          *                     BUG24101
      *                                                               *
      *****************************************************************
      *
     C     SRCusAutLink  BEGSR
      *
      ** Read through customer -> authority link
      *
     C*****CACUST        SETLL     SDCUAHL1                                                   262700
     C*****CACUST        READE     SDCUAHL1                                                   262700
     C     CACUST        SETLL     SDCUAHLA                                                   262700
     C     CACUST        READE     SDCUAHLA                                                   262700
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        CALTYP = 'VB' OR CALTYP = 'WB' OR                        BUG22521
     C**********                   CALTYP = 'OW'                                            BUG22521
     C     CALTYP        CHAIN     SDLINKL1                                                 BUG22521
     C                   IF        %FOUND(SDLINKL1)                                         BUG22521
      *                                                                                     BUG22521
     C                   EVAL      FLinkType = CALTYP
      *
      ** WCurrentPass determines the kind of check:
      ** If PASS is 1 (customer check) then check if 'RE' is entered
      ** AND all other fields are *BLANK.
      ** In that case DO NOT link the authority holder to the customer.
      ** If PASS is 2 (account check) then check if 'RE' or 'AL' is
      ** entered somewhere. If so, link the authority holder to the
      ** account. If PASS is 3 (deal check) then check if 'TD' or 'AL'
      ** is entered somewhere. If so, link the authority holder to the
      ** deal.If PASS is 4 (loan check) then check if 'LO' or 'AL' is
      ** entered somewhere. If so, link the authority
      ** holder to the loan.
      *
     C                   IF        (FCurrentPass = 1 AND NOT(
     C                             (CAPRG1 = 'RE' AND CAPRG2 = '  ' AND
     C                             CAPRG3 = '  ' AND CAPRG4 = '  ') OR
     C                             (CAPRG1 = '  ' AND CAPRG2 = 'RE' AND
     C                             CAPRG3 = '  ' AND CAPRG4 = '  ') OR
     C                             (CAPRG1 = '  ' and CAPRG2 = '  ' AND
     C                             CAPRG3 = 'RE' AND CAPRG4 = '  ') OR
     C                             (CAPRG1 = '  ' AND CAPRG2 = '  ' AND
     C                             CAPRG3 = '  ' AND CAPRG4 = 'RE')))
     C                             OR
     C                             (FCurrentPass = 2 AND (
     C                             (CAPRG1 = 'RE' OR CAPRG2 = 'RE' OR
     C                             CAPRG3 = 'RE' OR CAPRG4 = 'RE' OR
     C                             CAPRG1 = 'AL' OR CAPRG2 = 'AL' OR
     C                             CAPRG3 = 'AL' OR CAPRG4 = 'AL')))
     C                             OR
     C                             (FCurrentPass = 3 AND (
     C                             (CAPRG1 = 'TD' OR CAPRG2 = 'TD' OR
     C                             CAPRG3 = 'TD' OR CAPRG4 = 'TD' OR
     C                             CAPRG1 = 'AL' OR CAPRG2 = 'AL' OR
     C                             CAPRG3 = 'AL' or CAPRG4 = 'AL')))
     C                             OR
     C                             (FCurrentPass = 4 AND (
     C                             (CAPRG1 = 'LO' OR CAPRG2 = 'LO' OR
     C                             CAPRG3 = 'LO' OR CAPRG4 = 'LO' OR
     C                             CAPRG1 = 'AL' OR CAPRG2 = 'AL' OR
     C                             CAPRG3 = 'AL' OR CAPRG4 = 'AL')))
      *
     C     ' '           SCAN      CAAUTH                                                   BUG24101
     C                   IF        NOT(%FOUND)                                              BUG24101
     C                   MOVEL     CAAUTH        PNaho                                      BUG24101
      *                                                                                     BUG24101
      ** Call Access Object for Non-Account Holder                                          BUG24101
      *                                                                                     BUG24101
     C                   CALL      'AONAHOR0'                                               BUG24101
     C                   PARM      *BLANKS       PRtcd                                      BUG24101
     C                   PARM      '*KEY   '     POptn                                      BUG24101
     C                   PARM                    PNaho                                      BUG24101
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24101
      *                                                                                     BUG24101
     C                   IF        PRtCd = *BLANKS                                          BUG24101
     C                   EXSR      SRSetFrmAuth                                             BUG24101
     C                   ELSE                                                               MD029599
     C                   EVAL      DBFILE = 'SDNAHOPD'                                      MD029599
     C                   EVAL      DBASE =  015                                             MD029599
     C                   EVAL      DBKEY = PNaho                                            MD029599
     C                   EXSR      *PSSR                                                    MD029599
     C                   ENDIF                                                              BUG24101
      *                                                                                     BUG24101
     C                   ELSE                                                               BUG24101
      *                                                                                     BUG24101
     C                   MOVEL     CAAUTH        PCustNo
     C                   MOVEL     CAAUTH        PCust                                      BUG23995
      *                                                                                     BUG23808
      ** Call Access Object for Customer                                                    BUG23808
      *                                                                                     BUG23808
     C                   CALL      'AOCUSTR1'                                               BUG23808
     C                   PARM      *BLANKS       PRtcd                                      BUG23808
     C                   PARM      '*KEY   '     POptn                                      BUG23808
     C**********         PARM                    PCustNo                           BUG23808 BUG23995
     C                   PARM                    PCust                                      BUG23995
     C                   PARM                    PCnst                                      BUG23808
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG23808
      *                                                                                     BUG23808
     C**********         IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'            BUG23808 BUG24101
     C******LOCK         IN        LDA                                             BUG23808 BUG24101
     C**********         EVAL      DBKEY = CNUMA                                   BUG23808 BUG24101
     C**********         EVAL      DBFILE = 'SDCUSTPD'                             BUG23808 BUG24101
     C**********         EVAL      DBASE = 011                                     BUG23808 BUG24101
     C**********         OUT       LDA                                             BUG23808 BUG24101
     C**********         ENDIF                                                     BUG23808 BUG24101
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG22633
     C*****SDACUS        PARM      SDACUS        DSSDY                                      BUG22633
      *
     C**********         IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'                     BUG24101
     C******LOCK         IN        LDA                                                      BUG24101
     C**********         EVAL      DBKEY = CNUMA                                            BUG24101
     C**********         EVAL      DBFILE = 'SDACUSPD'                                      BUG24101
     C**********         EVAL      DBASE = 007                                              BUG24101
     C**********         OUT       LDA                                                      BUG24101
     C**********         ENDIF                                                              BUG24101
      *
     C                   IF        PRtCd = *BLANKS
     C                   EXSR      SRSetFrmCust
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG24101
     C                   ENDIF
     C                   ENDIF
      *
      ** Read next customer -> authority link
      *
     C     CACUST        READE     SDCUAHD0
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************                     BUG23995
      /EJECT                                                                                BUG23995
      *****************************************************************                     BUG23995
      *                                                               *                     BUG23995
      *  SRAccAutLink - Get authority holders via account ->          *                     BUG23995
      *                 authority holder link                         *                     BUG23995
      *                                                               *                     BUG23995
      *  Called By: MAIN Processing                                   *                     BUG23995
      *                                                               *                     BUG23995
      *  Calls: SetFrmCust                                            *                     BUG23995
      *         SrSetFrmAuth                                          *                     BUG24101
      *                                                               *                     BUG23995
      *****************************************************************                     BUG23995
      *                                                                                     BUG23995
     C     SRAccAutLink  BEGSR                                                              BUG23995
      *                                                                                     BUG23995
      ** Read through customer -> authority link                                            BUG23995
      *                                                                                     BUG23995
     C                                                                                      BUG23995
     C     AAACNO        SETLL     SDACAHL0                                                 BUG23995
     C     AAACNO        READE     SDACAHD0                                                 BUG23995
      *                                                                                     BUG23995
     C                   DOW       NOT(%EOF)                                                BUG23995
      *                                                                                     BUG23995
     C     AALTYP        CHAIN     SDLINKL1                                                 BUG23995
     C                   IF        %FOUND(SDLINKL1)                                         BUG23995
      *                                                                                     BUG23995
     C                   EVAL      FLinkType = AALTYP                                       BUG23995
      *                                                                                     BUG23995
     C     ' '           SCAN      AAAUTH                                                   BUG24101
     C                   IF        NOT(%FOUND)                                              BUG24101
     C                   MOVEL     AAAUTH        PNaho                                      BUG24101
      *                                                                                     BUG24101
      ** Call Access Object for Non-Account Holder                                          BUG24101
      *                                                                                     BUG24101
     C                   CALL      'AONAHOR0'                                               BUG24101
     C                   PARM      *BLANKS       PRtcd                                      BUG24101
     C                   PARM      '*KEY   '     POptn                                      BUG24101
     C                   PARM                    PNaho                                      BUG24101
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24101
      *                                                                                     BUG24101
     C                   IF        PRtCd = *BLANKS                                          BUG24101
     C                   EXSR      SRSetFrmAuth                                             BUG24101
     C                   ELSE                                                               MD029599
     C                   EVAL      DBFILE = 'SDNAHOPD'                                      MD029599
     C                   EVAL      DBASE =  016                                             MD029599
     C                   EVAL      DBKEY = PNaho                                            MD029599
     C                   EXSR      *PSSR                                                    MD029599
     C                   ENDIF                                                              BUG24101
      *                                                                                     BUG24101
     C                   ELSE                                                               BUG24101
      *                                                                                     BUG24101
     C                   MOVEL     AAAUTH        PCustNo                                    BUG23995
     C                   MOVEL     AAAUTH        PCust                                      BUG23995
      *                                                                                     BUG23995
      ** Call Access Object for Customer                                                    BUG23995
      *                                                                                     BUG23995
     C                   CALL      'AOCUSTR1'                                               BUG23995
     C                   PARM      *BLANKS       PRtcd                                      BUG23995
     C                   PARM      '*KEY   '     POptn                                      BUG23995
     C                   PARM                    PCust                                      BUG23995
     C                   PARM                    PCnst                                      BUG23995
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG23995
      *                                                                                     BUG23995
     C**********         IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'            BUG23995 BUG24101
     C******LOCK         IN        LDA                                             BUG23995 BUG24101
     C**********         EVAL      DBKEY = PCustNo                                 BUG23995 BUG24101
     C**********         EVAL      DBFILE = 'SDCUSTPD'                             BUG23995 BUG24101
     C**********         EVAL      DBASE = 011                                     BUG23995 BUG24101
     C**********         OUT       LDA                                             BUG23995 BUG24101
     C**********         ENDIF                                                     BUG23995 BUG24101
      *                                                                                     BUG23995
     C                   CALL      'AOACUSR0'                                               BUG23995
     C                   PARM      *BLANKS       PRtCd                                      BUG23995
     C                   PARM      '*KEY   '     POptn                                      BUG23995
     C                   PARM                    PCustNo                                    BUG23995
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG23995
      *                                                                                     BUG23995
     C**********         IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'            BUG23995 BUG24101
     C******LOCK         IN        LDA                                             BUG23995 BUG24101
     C**********         EVAL      DBKEY = CNUMA                                   BUG23995 BUG24101
     C**********         EVAL      DBFILE = 'SDACUSPD'                             BUG23995 BUG24101
     C**********         EVAL      DBASE = 007                                     BUG23995 BUG24101
     C**********         OUT       LDA                                             BUG23995 BUG24101
     C**********         ENDIF                                                     BUG23995 BUG24101
      *                                                                                     BUG23995
     C                   IF        PRtCd = *BLANKS                                          BUG23995
     C                   EXSR      SRSetFrmCust                                             BUG23995
     C                   ENDIF                                                              BUG23995
      *                                                                                     BUG23995
     C                   ENDIF                                                              BUG23995
     C                   ENDIF                                                              BUG24101
      *                                                                                     BUG23995
      ** Read next account -> authority link                                                BUG23995
      *                                                                                     BUG23995
     C     AAACNO        READE     SDACAHD0                                                 BUG23995
     C                   ENDDO                                                              BUG23995
      *                                                                                     BUG23995
     C                   ENDSR                                                              BUG23995
      *****************************************************************                     BUG23995
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetFrmCust - Set up fields from customer record            *
      *                                                               *
      *  Called By: SRCusAutLink                                      *
      *                                                               *
      *  Calls: SRLookupCty                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRSetFrmCust  BEGSR
      *
     C                   EVAL      FCP = FCP + 1
      *
     C                   IF        FCP <= 100
     C     FCP           OCCUR     WCDIMG
     C                   CLEAR                   WCDIMG
     C**********         EVAL      DF13CUS = BBCUST                                         BUG23808
     C**********         EVAL      DF13SNM = E5CNA1                                         BUG23808
     C**********         EVAL      DF13FNM = E5TITL                                         BUG23808
     C**********         EVAL      DF13CUS = DBBCUST                               BUG23808 BUG24209
     C                   EVAL      DF13CUS = DE5CUST                                        BUG24209
     C                   IF        DE5TITL = *BLANKS                                          263480
     C                   EVAL      DF13SNM = DE5CNA1                                        BUG23808
     C                   ELSE                                                                 263480
     C                   EVAL      DF13SNM = %TRIMR(DE5TITL) + ' ' + DE5CNA1                  263480
     C                   ENDIF                                                                263480
     C**********         EVAL      DF13FNM = DE5TITL                                 BUG23808 263480
     C                   EVAL      DF13FNM = DE5CNA2                                          263480
      *
      ** If type 'WB' (wirtschaftliche Berechtigter) report address.
      *
     C                   IF        FLinkType = 'WB'
     C                   EVAL      DF13PTP = 'W'
     C**********         EVAL      DF13STR = BBCNA1                                         BUG23808
     C**********         EVAL      DF13TWN = BBCRTN                                         BUG23808
     C**********         EVAL      DF13ZIP = E5ZIPC                                         BUG23808
     C**********         EVAL      WCtry = BBCOLC                                           BUG23808
     C                   EVAL      DF13STR = DBBCNA1                                        BUG23808
     C                   EVAL      DF13TWN = DBBCRTN                                        BUG23808
     C                   EVAL      DF13ZIP = DE5ZIPC                                        BUG23808
     C                   EVAL      WCtry = DBBCOLC                                          BUG23808
     C                   EXSR      SRLookupCty
     C                   CLEAR                   DF13BDT
      *
      ** Other types.
      *
     C                   ELSE
     C                   IF        FLinkType = 'VB'
     C                   EVAL      DF13PTP = 'V'
     C                   ELSE
     C                   EVAL      DF13PTP = 'K'
     C                   ENDIF
     C                   CLEAR                   DF13STR
     C                   CLEAR                   DF13TWN
     C                   CLEAR                   DF13ZIP
     C                   CLEAR                   DF13CTY
      *
      ** Set date of birth, if appropriate.
      *
     C**********         IF        E5BRTH  <> 0                                             BUG23808
     C**********         Z-ADD     E5BRTH        WDATE2                                     BUG23808
     C**********         Z-ADD     WYEAR2        WYEAR                                      BUG23808
     C**********         Z-ADD     WMNTH2        WMNTH                                      BUG23808
     C**********         Z-ADD     WDAY2         WDAY                                       BUG23808
     C**********         Z-ADD     WDATE         DF13BDT                                    BUG23808
      *                                                                                     BUG23808
     C**********         IF        DE5BRTH  <> 0                                     BUG23808 262700
      *                                                                                     BUG23808
     C**********         EVAL      PZDayNo = DE5BRTH                                 BUG23808 262700
     C**********         EXSR      SRZDate9                                          BUG23808 262700
      *                                                                                     BUG23808
     C**********         IF        PErrorFlag = '0'                                  BUG23808 262700
     C**********         Z-ADD     PZDate1       DF13BDT                             BUG23808 262700
     C**********         ENDIF                                                       BUG23808 262700
      *                                                                                     BUG23808
     C**********         IF        E5DBTH <> *BLANKS                                   262700 263480
     C**********         MOVEL     E5DBTH        DF13BDT                               262700 263480
     C                   IF        DE5DBTH <> *BLANKS                                         263480
     C                   MOVEL     DE5DBTH       DF13BDT                                      263480
     C                   ELSE
     C                   CLEAR                   DF13BDT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     'WCDIMG  '    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     '> 100  '     DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************                     BUG24101
      /EJECT                                                                                BUG24101
      *****************************************************************                     BUG24101
      *                                                               *                     BUG24101
      *  SRSetFrmAuth - Set up fields from non-account holder record  *                     BUG24101
      *                                                               *                     BUG24101
      *  Called By: SRCusAutLink                                      *                     BUG24101
      *                                                               *                     BUG24101
      *  Calls: SRLookupCty                                           *                     BUG24101
      *                                                               *                     BUG24101
      *****************************************************************                     BUG24101
      *                                                                                     BUG24101
     C     SRSetFrmAuth  BEGSR                                                              BUG24101
      *                                                                                     BUG24101
     C                   EVAL      FCP = FCP + 1                                            BUG24101
      *                                                                                     BUG24101
     C                   IF        FCP <= 100                                               BUG24101
     C     FCP           OCCUR     WCDIMG                                                   BUG24101
     C                   CLEAR                   WCDIMG                                     BUG24101
     C                   EVAL      DF13CUS = ENHNAHO                                        BUG24101
     C                   EVAL      DF13SNM = ENHIDE1                                        BUG24101
     C                   EVAL      DF13FNM = ENHIDE2                                        BUG24101
      *                                                                                     BUG24101
      ** If type 'WB' (wirtschaftliche Berechtigter) report address.                        BUG24101
      *                                                                                     BUG24101
     C                   IF        FLinkType = 'WB'                                         BUG24101
     C                   EVAL      DF13PTP = 'W'                                            BUG24101
     C                   EVAL      DF13STR = ENHIDE3                                        BUG24101
     C                   EVAL      DF13TWN = ENHCITY                                        BUG24101
     C                   EVAL      DF13ZIP = ENHZIPC                                        BUG24101
     C                   EVAL      WCtry = ENHCOLC                                          BUG24101
     C                   EXSR      SRLookupCty                                              BUG24101
     C                   CLEAR                   DF13BDT                                    BUG24101
      *                                                                                     BUG24101
      ** Other types                                                                        BUG24101
      *                                                                                     BUG24101
     C                   ELSE                                                               BUG24101
     C                   IF        FLinkType = 'VB'                                         BUG24101
     C                   EVAL      DF13PTP = 'V'                                            BUG24101
     C                   ELSE                                                               BUG24101
     C                   EVAL      DF13PTP = 'K'                                            BUG24101
     C                   ENDIF                                                              BUG24101
     C                   CLEAR                   DF13STR                                    BUG24101
     C                   CLEAR                   DF13TWN                                    BUG24101
     C                   CLEAR                   DF13ZIP                                    BUG24101
     C                   CLEAR                   DF13CTY                                    BUG24101
      *                                                                                     BUG24101
      ** Set date of birth, if appropriate                                                  BUG24101
      *                                                                                     BUG24101
     C                   IF        ENHDBTH  <> *BLANKS                                      BUG24101
     C                   MOVE      ENHDBTH       DF13BDT                                    BUG24101
      *                                                                                     BUG24101
     C                   ELSE                                                               BUG24101
     C                   CLEAR                   DF13BDT                                    BUG24101
     C                   ENDIF                                                              BUG24101
      *                                                                                     BUG24101
     C                   ENDIF                                                              BUG24101
      *                                                                                     BUG24101
     C                   ELSE                                                               BUG24101
      *                                                                                     BUG24101
     C                   MOVEL     'WCDIMG  '    DBFILE                                     BUG24101
     C                   MOVEL     '014'         DBASE                                      BUG24101
     C                   MOVEL     '> 100  '     DBKEY                                      BUG24101
     C                   EXSR      *PSSR                                                    BUG24101
     C                   ENDIF                                                              BUG24101
      *                                                                                     BUG24101
     C                   ENDSR                                                              BUG24101
      *                                                                                     BUG24101
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLookupCty - Lookup country description                     *
      *                                                               *
      *  Called By: SRSetFrmCust                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRLookupCty   BEGSR
      *
      ** Lookup country description.
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WCtry
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
     C                   MOVEL     'SDCTRYPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   SELECT
      *
     C                   WHEN      WBkn = 'B'
     C                   EVAL      DF13CTY = A4CNNM
      *
     C                   WHEN      WBkn = 'T'
     C                   EVAL      DF13CTY = A4ISOC
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       262700
     C     SRDelete      BEGSR                                                                262700
     C                   EXSR      SRCheck                                                    262700
     C                   IF        WDelDays <> 0                                              262700
      *                                                                                       262700
     C     *LOVAL        SETLL     ERACEXD0                                                   262700
     C                   READ      ERACEXD0                                                   262700
     C                   DOW       NOT %EOF(ERACEXL0)                                         262700
      *                                                                                       262700
     C                   IF        F12DDT <> 0                                                262700
     C                   EVAL      PDateIn = F12DDT                                           262700
      *                                                                                       262700
     C                   EXSR      SRZDate10                                                  262700
      *                                                                                       262700
     C                   EVAL      WDiffDays  = BJRDNB - PDeldt                               262700
     C                   IF        WDiffDays  > WDelDays                                      262700
     C                   DELETE    ERACEXD0                                                   262700
      *                                                                                       262700
     C     KLerac        CHAIN     ERACEPL0                                                   262700
      *                                                                                       262700
     C                   IF        NOT(%FOUND)                                                262700
     C                   EVAL      DBFILE = 'ERACEPL0'                                        262700
     C                   EVAL      DBASE = 010                                                262700
     C                   EVAL      DBKEY = '*KEY   '                                          262700
     C                   EXSR      *PSSR                                                      262700
     C                   ENDIF                                                                262700
      *                                                                                       262700
     C                   DELETE    ERACEPD0                                                   262700
      *                                                                                       262700
     C                   ENDIF                                                                262700
     C                   ENDIF                                                                262700
     C                   READ      ERACEXD0                                                   262700
      *                                                                                       262700
     C                   ENDDO                                                                262700
     C                   ENDIF                                                                262700
      *                                                                                       262700
     C                   ENDSR                                                                262700
      *****************************************************************                       262700
      /EJECT                                                                                  262700
      *****************************************************************
      *                                                               *
      *  SRCheck - Subroutine to Check System Value KWGDeletionDays   *
      *                                                               *
      *  Called By: SRCrtNewRec                                       *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCheck       BEGSR
      *
     C                   EVAL      PSvlk1 = WSysvl
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PSvlk1
     C                   PARM      *BLANKS       PSVl1
     C                   PARM      *BLANKS       PSVlk2
     C                   PARM      *BLANKS       PSVl2
     C                   PARM      *BLANKS       PSVlk3
     C                   PARM      *BLANKS       PSVl3
     C                   PARM      *BLANKS       PSVlk4
     C                   PARM      *BLANKS       PSVl4
     C                   PARM      *BLANKS       PSVlk5
     C                   PARM      *BLANKS       PSVl5
     C                   PARM      *BLANKS       PSVlk6
     C                   PARM      *BLANKS       PSVl6
     C                   PARM      *BLANKS       PSVlk7
     C                   PARM      *BLANKS       PSVl7
     C                   PARM      *BLANKS       PSVlk8
     C                   PARM      *BLANKS       PSVl8
     C                   PARM      *BLANKS       PSVlk9
     C                   PARM      *BLANKS       PSVl9
     C                   PARM      *BLANKS       PSvlk10
     C                   PARM      *BLANKS       PSVl10
      *
     C                   IF        PRtCd <> *BLANKS AND PSVl1 = '*NRF'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVALR     WWDelDays = %TRIM(PSVl1)
     C                   MOVE      WWDelDays     WDelDays
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate10 - Subroutine to Convert YYYYMMDD Format Date to    *
      *              Midas Day No.                                    *
      *                                                               *
      *  Called By: SRCrtNewRec                                       *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRZDate10     BEGSR
      *
     C                   CALLB     'ZDATE10'
     C                   PARM                    PDateIn
     C                   PARM                    PDeldt
      *
     C                   ENDSR
      *                                                                                     BUG22633
      *****************************************************************                     BUG22633
      /EJECT                                                                                BUG22633
      *****************************************************************                     BUG22633
      *                                                               *                     BUG22633
      *  SRFCrtDte - Subroutine to get final creation date            *                     BUG22633
      *                                                               *                     BUG22633
      *                                                               *                     BUG22633
      *  Called By: SRCrtNewRec                                       *                     BUG22633
      *                                                               *                     BUG22633
      *  Calls: None                                                  *                     BUG22633
      *                                                               *                     BUG22633
      *****************************************************************                     BUG22633
      *                                                                                     BUG22633
     C*****SRFCrtDte     BEGSR                                                       BUG22633 262700
      **********                                                                     BUG22633 262700
     C*****KFCrtDt       SETLL     ERACEX3                                           BUG22633 262700
     C**********         IF        %FOUND(ERACEXL3)                                  BUG22633 262700
     C**********         EVAL      F12CDT = XF12CDT                                  BUG22633 262700
     C**********         ENDIF                                                       BUG22633 262700
     C**********         EVAL      WDLFLG = 'N'                                      BUG22633 262700
      **********                                                                     BUG22633 262700
     C**********         ENDSR                                                       BUG22633 262700
      *****************************************************************                     BUG23808
      /EJECT                                                                                BUG23808
      *****************************************************************                     BUG23808
      *                                                               *                     BUG23808
      *  SRZDate9 - Convert day number to YYYYMMDD format             *                     BUG23808
      *                                                               *                     BUG23808
      *  Called by: SRLoadSfl                                         *                     BUG23808
      *                                                               *                     BUG23808
      *  Calls: None                                                  *                     BUG23808
      *                                                               *                     BUG23808
      *****************************************************************                     BUG23808
      *                                                                                     BUG23808
     C     SRZDate9      BEGSR                                                              BUG23808
      *                                                                                     BUG23808
     C                   CALLB     'ZDATE9'                                                 BUG23808
     C                   PARM                    PZDayNo                                    BUG23808
     C                   PARM      *ZEROS        PZDate1                                    BUG23808
     C                   PARM      *BLANKS       PErrorFlag                                 BUG23808
      *                                                                                     BUG23808
     C                   ENDSR                                                              BUG23808
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    WBkn
     C                   PARM                    WUtp
     C                   PARM                    WFnr
     C                   PARM                    PRtnCde
      *
      ** Valid values for WUTP are:
      ** K = Complete transmit of data, all records are transmitted
      ** U = Update transmit of data, only records that have changed
      ** since last sent
      ** Valid values for WFNR are:
      ** 0 = Normal processing. A new transmission file is created.
      ** n = Recovery mode. The transmission file with the number
      ** passed is recreated.
      *
     C     PLV10H1       PLIST
     C                   PARM                    WBkn
     C                   PARM                    WUtp
     C                   PARM                    WFnr
     C                   PARM                    PRtnCde
      *                                                                                     BUG22633
     C     KFCrtDt       KLIST                                                              BUG22633
     C                   KFLD                    W12ACC                                     BUG22633
     C                   KFLD                    W12REF                                     BUG22633
      *
     C     KLerac        KLIST
     C                   KFLD                    F12ACC
     C                   KFLD                    F12REF
     C                   KFLD                    F12VDT
     C                   KFLD                    F12VTM
      *
     C     KL1210        KLIST
     C                   KFLD                    FACC
     C                   KFLD                    FREF
      *
     C     KLdtst        KLIST
     C                   KFLD                    DTYP
     C                   KFLD                    DLST
      *
     C     KLOAN         KLIST
     C                   KFLD                    LTYP
     C                   KFLD                    SUTP
      *
     C     KLaccnt       KLIST
     C                   KFLD                    FCNUMA
     C                   KFLD                    FACCNTNO
      *
      ** Get current rundate from Bank Master file
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set the 'Valid from Date' for all records to todays rundate
      *
     C                   CALLB     'ZDATE9'
     C                   PARM      BJRDNB        WWdayn
     C     FVDT          PARM                    DateOut
     C                   PARM                    WWrtn
      *
      ** Set the 'Valid from Time' for all records to current program
      ** run time
      *
     C                   TIME                    FVTM
     C     *HMS          MOVE      FVTM          FTIME
     C                   SUBDUR    1:*SECONDS    FTIME
     C     *HMS          MOVE      FTIME         FVTM1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Program, module and procedure names for database error
      ** processing.
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
      *****************************************************************
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
