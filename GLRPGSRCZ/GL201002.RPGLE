     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL New FCCY IN/EX Transfer Init')                *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  RPGLE/GL201002 - Midas GL New FCCY IN/EX Transfer            *
      *                   Initialization                              *
      *                                                               *
      *  Called from: Program GLC201002                               *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. CGL201 *Create     Date 22Sep23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL201 - New Reports for Daily Transfer of Foreign Exchange  *
      *                                                               *
      *****************************************************************
      * Midas GL Accounts by branch
     FACBRC     IF   E           K DISK    INFSR(*PSSR)
      * Midas GL Account Postings
     FAPOST     IF   E           K DISK    INFSR(*PSSR) Prefix(A_)
      * Midas GL Month/Year to date Balances
     FGLMTDBL0  UF A E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS


      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      *****************************************************************

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID OUTGOING PAYMENT

     D SVBRCA          S                   LIKE(BRCA)
     D SVCCY           S                   LIKE(CCY)
     D SVACOD          S                   LIKE(ACOD)
     D OKRECI          S              1A   INZ('N')
     D @ACOD           S                   LIKE(A5ACCD)
     D WKYTDA          S                   LIKE(TMYTDA)
     D WKMTDA          S                   LIKE(TMMTDA)
     D ACMTDA          S                   LIKE(TMMTDA)
      *
     D Iso_BOM         S               D   DatFmt(*ISO)
     D Iso_Rundate     S               D   DatFmt(*ISO)
     D Str_MDay        S               D   DatFmt(*ISO) Inz(D'1971-12-31')
     D WK_Bom          S             10    Inz(*Blanks)
     D BOMDAT          S              5  0 Inz(*Zeros)

      ** Access Object parameter fields
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDACOD        E DS                  EXTNAME(SDACODPD)
      * External data structure for currency codes

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+

      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+

      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * Main Processing                                               *
      *                                                               *
      *---------------------------------------------------------------*

      *
      **  Initialise Branch/Currency/Account Code
      *
     C                   EVAL      SVBRCA = *Blanks
     C                   EVAL      SVCCY  = *Blanks
     C                   EVAL      SVACOD = *Zeros
      *
      ** Position file pointer to the beginning of the file
     C     *loval        Setll     ACBRC
      *
      ** Get valid Income/Expense Accounts form ACCNTAB
     C                   Exsr      SrValidRec
      *
      **  If an income/expense account, save the branch/currency/account code
     C                   If        OKRECI = 'Y'
     C                   EVAL      SVBRCA = BRCA
     C                   EVAL      SVCCY  = CCY
     C                   EVAL      SVACOD = ACOD
     C                   Endif
      *
     C                   Dow       Not(%EOF(ACBRC))
      *
      ** If change in branch, currency, account code, write records to the YTD balance file
     C                   If        SVBRCA <> BRCA or
     C                             SVCCY  <>CCY   or
     C                             SVACOD <>ACOD
      *
      ** Write records to GLMTDBPD
     C                   Exsr      SrWriteRec
      *
      ** Save current branch/ccy/acod
     C                   EVAL      SVBRCA = BRCA
     C                   EVAL      SVCCY  = CCY
     C                   EVAL      SVACOD = ACOD
      *
      ** Reset ytd balance
     C                   Eval      WKYTDA = *Zeros
      *
      ** Reset mtd balance
     C                   Eval      WKMTDA = *Zeros
     C                   Endif
      *
      ** Accumulate YTD balance
     C                   Eval      WKYTDA = WKYTDA + YTDB
      *
      ** Accumulate MTD balance
     C                   Eval      WKMTDA = WKMTDA + ACMTDA
      *
      ** Get next valid Income/Expense Account
     C                   Exsr      SrValidRec
      *
     C                   Enddo
      *
      ** Write the YTD balance of the last valid Income/Expense Account
     C                   If        SVBRCA <> *Blanks
     C                   Exsr      SrWriteRec
     C                   Endif
      *
      * Exit from Program
     C                   Seton                                        LR
     C                   Return

      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * SrValidRec - Get Valid records from ACBRC                     *
      * Called by: Main                                               *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     SrValidRec    Begsr
      *
      ** Initialise work variable OKRECI
     C                   Eval      OKRECI='N'
     C                   Eval      ACMTDA=*ZEROS
      *
      ** Read next account from ACCNTAB
     C                   Read      ACBRC
      *
      ** Loop while not end of ACBRC
     C                   Dow       OKRECI='N' and Not(%EOF(ACBRC))
      *
      ** Continue if currency is not the base currency
     C
     C                   If        CCY <> BJCYCD
      *
      ** Get Account Code details
     C                   Move      ACOD          @ACOD
     C                   Call      'AOACODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    @ACOD
     C     SDACOD        PARM      SDACOD        DSSDY
      *
      ** If account section is IN/EX, flag it as valid account and leave the loop
     C                   If        A5ACSC = 'IN' or A5ACSC = 'EX'
     C                   Eval      OKRECI='Y'
      *
      ** Get Month to Date Balances
     C                   Exsr      SrGetMTDBal
      *
     C                   Leave
     C                   Endif
     C                   Endif
      *
      ** Read next Account
     C                   Read      ACBRC
     C                   Enddo
      *
     C                   Endsr
      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * SrGetMTDBal - Get Month to Date Balances of the account       *
      * Called by: SrValidRec                                         *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     SrGetMTDBal   Begsr
      *
      ** Initialise Account MTD balance
     C                   Z-Add     0             ACMTDA
      *
      ** Set File Pointer to Account Posting at the beginning of the month
     C     K_APOST       Setll     APOST
     C     K_APOSTP      Reade     APOST
      *
      ** Get all the account posting for the current month
     C                   Dow       Not(%Eof(APOST))
      *
      ** Exclude posting from FCCY Transfer
     C                   If        A_SPOS <> '  GE-XF'
      *
      ** Negate the amount if it is a debit posting
     C                   If        A_DRCR = 0
     C                   Eval      ACMTDA = ACMTDA - A_PSTA
     C                   else
     C                   Eval      ACMTDA = ACMTDA + A_PSTA
     C                   Endif
     C                   Endif
      *
      ** Read next account posting for the current month
     C     K_APOSTP      Reade     APOST
     C                   Enddo
      *
     C                   Endsr
      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * SrWriteRec - Write GLMTDBPD record                            *
      * Called by: Main                                               *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     SrWriteRec    Begsr
      *
      ** Populate brca/ccy/acod details from the saved values.
     C                   Eval      TMBRCA = SVBRCA
     C                   Eval      TMCCY  = SVCCY
     C                   Eval      TMACOD = SVACOD
      *
      ** Initialise Month to Date Balance as zero
     C                   Eval      TMMTDA = *Zeros
      *
      ** Get YTD balance from the accumulated value.
     C                   Eval      TMYTDA = WKYTDA
      *
      ** Get MTD balance from the accumulated value.
     C                   Eval      TMMTDA = WKMTDA
      *
      ** Write GLMTDBPD record
     C                   Write     GLMTDBD0
     C                   Endsr
      /EJECT
      *
      *---------------------------------------------------------------*
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      * Called by: Main processing                                    *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     *Inzsr        Begsr

     C     K_APOST       KList
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BOMDAT
      *
     C     K_APOSTP      KList
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
      *
      ** Access Bank Details
      *
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C                   If         @RTCD <> *BLANKS
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Movel     '901'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
      ** Convert Rundate to ISO format
     C     Str_MDay      Adddur    BJRDNB:*days  Iso_Rundate
     C                   Move      Iso_Rundate   WK_BOM
      *
      ** Get Beginning of the month in Midas Date
     C                   Move      '01'          WK_BOM
     C     *iso          Move      WK_BOM        Iso_BOM
      *
      ** Convert beginning of the month from ISO Date to Midas Date
     C     Iso_BOM       Subdur    Str_MDay      BOMDAT:*days
      *
     C                   Endsr
     C****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound Call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILEB
      /EJECT
**  CPY@
(c) Finastra International Limited 2023
