     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Repo interface controller')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMREPOCTL - REPOs Interface Controller                       *
      *                                                               *
      *  Function: This Program Validates MM REPOs for                *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249287             Date 19Jul07               *
      *                 247888             Date 18May07               *
      *                 247695             Date 10May07               *
      *                 247683             Date 09May07               *
      *                 247785             Date 15May07               *
      *                 247716             Date 11May07               *
      *                 247022             Date 13Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241257             Date 30Aug06               *
      *                 239899             Date 22Aug06               *
      *                 239889             Date 21Aug06               *
      *                 240474             Date 21Aug06               *
      *                 240856             Date 21Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10853           Date 15Mar06               *
      *                 233352             Date 06May05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CMM105             Date 22Jun04               *
      *                 BUG2804            Date 20May04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 24Oct03               *
      *                 CAS005             Date 16Dec02               *
      *                 CRE008             Date 19Feb02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23May02               *
      *                 CSC011             Date 14Mar02               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249287 - Recompile on MMRPTRPD.                              *
      *  247888 - Missing record in CLE025 files.                     *
      *  247695 - Add CDL010, CAS005, CGL014, CDL016, CDL017, CDL019, *
      *           CDL018, CDL033 AND CAP086 fields.                   *
      *  247683 - REPO Repair: mismatch fields in settlement screen.  *
      *  247785 - Recompile on MMTRPLNPD and MMTRPDMPD.               *
      *           Review Pay/Receive Settlement data structures.      *
      *  247716 - Problem in REPO API. Add missing fields.            *
      *           Recompile on MMVRPDMPD.                             *
      *  247022 - REPO Repair: mismatch fields in screen.             *
      *  241257 - Repos deleted via API were not having their         *
      *           corresponding depot movements deleted.              *
      *           (Note, this fix relies on a depot movement deletion *
      *           message being sent along with the deal deletion     *
      *           message. It must have the 'D' action code in        *
      *           pos.144 as per TranInREPO)                          *
      *  239899 - For any REPO API with action code 'I', a depot      *
      *           movement is required as the manual Repo input.      *
      *  239889 - REPOS coming from APIs are missing depot movements. *
      *           Instead of using *LOVAL for SETLL use a key for the *
      *           SETLL.                                              *
      *  240474 - APISERVER dumping when calling MM0011 because it    *
      *           uses AOCREPT which is use to send message for       *
      *           interactive jobs.                                   *
      *  240856 - Movement Date Out incorrectly set to zero           *
      *           for Call Reverse Repos                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10853 - CGL029 changes missing for repos (Recompile)      *
      *  233352 - Problem in REPO API (Recompile)                     *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMREPOC002,                      *
      *           Core hooks added:MMREPOC021,MMREPOC022              *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Parameter Mismatch                                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CRE008 - Cash Management  Added parameters to ZASETINVAL     *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************

      * Valid REPO Loans and Deposits Transaction file
     FMMVRPLNPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

      * Invalid REPO Loans and Deposits Transaction file
     FMMIRPLDPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

      * Valid REPO Depot Movements Transactions file
     FMMVRPDMPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

      * Invalid REPO Depot Movements Transactions file
     FMMIRPDDPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

      * Invalid REPO Trailer file
     FMMIRPTRPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

      * Invalid Settlement details
     FAPIDSETPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

      * Work file for REPO Loans and Deposits
     FMMWLNDPD  UF A E             DISK    INFSR(*pssr)

      * Work file for REPO Depot movement records
     FMMWRPDPD  UF A E             DISK    INFSR(*pssr)

      * Work file for Loans and Deposits Extra Data - Class 1 records
     FMMWINFPD  UF A E             DISK    INFSR(*pssr)

      * Work file for Depot Movements Extra Data records
     FMMWEXTPD  UF A E             DISK    INFSR(*pssr)

      * Work file for Loans and Deposits Extended Settle Ins - Pay
     FMMWESPPD  UF A E             DISK    INFSR(*pssr)

      * Work file for Loans and Deposits Extended Settle Ins - Rec
     FMMWESRPD  UF A E             DISK    INFSR(*pssr)

      * Work file for Loans and Deposits Extended Settle Ins - FRA/IRS
     FMMWESFPD  UF A E             DISK    INFSR(*pssr)

      * Temporary file for REPO Loans and Deposits
     FMMTRPLNPD UF A E             DISK    INFSR(*pssr)

      * Temporary file for REPO Depot movement records
     FMMTRPDMPD UF A E             DISK    INFSR(*pssr)

      ** FX/MM/FRA/IRS Extension files                                                        247888
     FDLDEALL5  UF A E           K DISK    PREFIX(DX_)                                        247888
     F                                     INFSR(*pssr)                                       247888
     F                                     COMMIT                                             247888
                                                                                              247888
      * Files used for data retrieval and update
     FSECTY     IF   E           K DISK    INFSR(*pssr)
     FDPTMVDL1  IF   E           K DISK    INFSR(*pssr)

     FMMVRPLNL0 IF   E           K DISK    RENAME(MMVRPLND0:MMVRPLNCHK)
     F                                     INFSR(*pssr)
     FMMVRPLNL1 IF   E           K DISK    RENAME(MMVRPLND0:MMVRPLNCK1)
     F                                     INFSR(*pssr)

     FMMWLNDL0  UF A E           K DISK    RENAME(MMWLNDD0:MMWLNDDX)
     F                                     INFSR(*pssr)
     FMMWRPDL0  UF A E           K DISK    RENAME(MMWRPDD0:MMWRPDDX)
     F                                     INFSR(*pssr)
     FMMWINFL0  UF A E           K DISK    RENAME(MMWINFD0:MMWINFDX)
     F                                     INFSR(*pssr)
     FMMWEXTL0  UF A E           K DISK    RENAME(MMWEXTD0:MMWEXTDX)
     F                                     INFSR(*pssr)
     FMMWESFL0  UF A E           K DISK    RENAME(MMWESFD0:MMWESFDX)
     F                                     INFSR(*pssr)
     FMMWESRL0  UF A E           K DISK    RENAME(MMWESRD0:MMWESRDX)
     F                                     INFSR(*pssr)
     FMMWESPL0  UF A E           K DISK    RENAME(MMWESPD0:MMWESPDX)
     F                                     INFSR(*pssr)
     FMMTRPLNL0 UF A E           K DISK    RENAME(MMTRPLND0:MMTRPLNDX)
     F                                     INFSR(*pssr)
     FMMTRPDML0 UF A E           K DISK    RENAME(MMTRPDMD0:MMTRPDMDX)
     F                                     INFSR(*pssr)

     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMREPOC001

      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
     D   MsgType               1      6

      * Incoming REPO Transaction
     D TranInREPO    E DS                  EXTNAME(MMLDNIPD)

      * Incoming REPO Transaction (Work)
     D*****WkTrInREPO    E DS                  EXTNAME(MMWLNDPD)                              247022
     D WkTrInREPO    E DS                  EXTNAME(MMLDNIPD)                                  247022
     D                                     PREFIX(WL:2)                                       247022

      * Incoming REPO Depot Transaction
     D TranInDEPO    E DS                  EXTNAME(MMRPDDPD)
     D GADLNO        E                     EXTFLD(DDDLNO)
     D GAACTN        E                     EXTFLD(DDACTN)

      * Incoming REPO Depot Transaction (Work)
     D WkTrInDEPO    E DS                  EXTNAME(MMWRPDPD)

      * Incoming Transaction Trailer
     D TranTrailer   E DS                  EXTNAME(MMRPTRPD)

      * Incoming Transaction Trailer (Work)
     D WkTrTrailer   E DS                  EXTNAME(MMIRPTRPD)

      * Transaction Trailer DS for validation
     D TranInTrail   E DS                  EXTNAME(MMRPDHPD)
     D                                     PREFIX(KA:2)
     D QQKAACCN      E                     EXTFLD(QQACCN)                                     CGL029

      * VAlid Transaction Trailer DS from validation
     D ValidTrailer  E DS                  EXTNAME(MMVRPDHPD)
     D                                     PREFIX(HA:2)
     D QQHAACCN      E                     EXTFLD(QQACCN)                                     CGL029

      * Valid REPO Details layout
     D ValidREPO     E DS                  EXTNAME(MMVRPLNPD)
     D QQINS1        E                     EXTFLD(QQINSA)                                     CGL029
     D***LDNIRecIns          456    524                                                       CGL029
     D***LDNIPayIns          525   1083                                                       CGL029
     D   LDNIRecIns          470    524                                                       CGL029
     D   LDNIPayIns          539   1083                                                       CGL029
     D***LDNIRecInsEx*******1731   1748                                                 CGL029247785
     D   LDNIRecInsEx       1756   1773                                                       247785
     D***LDNIPayInsEx*******1749   1766                                                 CGL029247785
     D   LDNIPayInsEx       1774   1791                                                       247785
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)

      * (Current) Transaction record in file Format
     D REPOFilFmt    E DS                  EXTNAME(MMDELDPP)
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS2        E                     EXTFLD(QQINSA)                                     CGL029
     D***DELDRecIns          456    524                                                       CGL029
     D***DELDPayIns          525   1083                                                       CGL029
     D   DELDRecIns          470    524                                                       CGL029
     D   DELDPayIns          539   1083                                                       CGL029
     D***DELDRecInsEx*******1741   1758                                                 CGL029247785
     D   DELDRecInsEx       1756   1773                                                       247785
     D***DELDPayInsEx*******1759   1776                                                 CGL029247785
     D   DELDPayInsEx       1774   1791                                                       247785
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)

      * (Current) Transaction in Screen Format - Main Details
     D CurTrREPO     E DS                  EXTNAME(MMLDNIPD)
     D                                     PREFIX(@)

      * Incoming Transaction in File Format
     D ValidDEPO     E DS                  EXTNAME(MMVRPDDPD)

      * Pay Settlement Instructions - Input
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)

      * Pay Settlement Instructions - Input work file
     D*****WInPaySttmt   E DS                  EXTNAME(MMWESPPD)                              247683
     D WInPaySttmt   E DS                  EXTNAME(SDESSPPD)                                  247683
     D                                     PREFIX(WI:2)                                       247683

      * Receive Settlement Instructions - Input
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)

      * Receive Settlement Instructions - Input work file
     D*****WInRecSttmt   E DS                  EXTNAME(MMWESRPD)                              247683
     D WInRecSttmt   E DS                  EXTNAME(SDESSRPD)                                  247683
     D                                     PREFIX(WO:2)                                       247683

      * FRA/IRS Settlement Instructions - Input
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)

      * FRA/IRS Settlement Instructions - Input work file
     D*****WInFRASttmt   E DS                  EXTNAME(MMWESFPD)                              247683
     D WInFRASttmt   E DS                  EXTNAME(MMWESFPD)                                  247683
     D                                     PREFIX(WU:2)                                       247683

      * Pay Settlement Instructions - Current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)

      * Receive Settlement Instructions - Current
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)

      * FRA/IRS Settlement Instructions - Current
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)

      * Pay Settlement Instructions - File (D/B) format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                 21    565                                                       CGL029
     D  FLPAY2                21    569                                                       CGL029

      * Receive Settlement Instructions - File (D/B) format
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D  FLREC                 21     75                                                       CGL029
     D  FLREC2                21     78                                                       CGL029

      * FRA/IRS Settlement Instructions - File (D/B) format
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)

      * MM Extra Data - Classe 1 Data - File (D/B) format
     D InfData       E DS                  EXTNAME(MMLDIFPD)
     D                                     PREFIX(IF_)

      * MM Extra Data - Classe 1 Data - Work File (D/B) format
     D WInfData      E DS                  EXTNAME(MMWINFPD)

      * MM Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(MMLDEXPD)

      * MM Extra Data - Work File (D/B) format
     D WExtData      E DS                  EXTNAME(MMWEXTPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      * Depot error indicators
     D MMErep        E DS                  EXTNAME(MMERPDDPD)

     D MMErHd        E DS                  EXTNAME(MMERPDHPD)
     D DLNOOK        E                     EXTFLD(OKDLNO)

     D MMREPOUPC       DS             1    DTAARA(MMREPOUPC)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A   INZ('Y')
     D  DDDlnoOK                      1A   INZ('Y')
     D  DDTypeOK                      1A   INZ('Y')
     D  DDStypOK                      1A   INZ('Y')
     D  DDFedFOK                      1A   INZ('Y')
     D  DDDADNOK                      1A   INZ('Y')
     D  DDDlDtOK                      1A   INZ('Y')
     D  DDBrCAOK                      1A   INZ('Y')
     D  DDBokCOK                      1A   INZ('Y')
     D  DDLnkNOK                      1A   INZ('Y')
     D  DDBkCdOK                      1A   INZ('Y')
     D  DDBrkgOK                      1A   INZ('Y')
     D  DDRaCDOK                      1A   INZ('Y')
     D  DDCustOK                      1A   INZ('Y')
     D  DDVDatOK                      1A   INZ('Y')
     D  DDMDatOK                      1A   INZ('Y')
     D  DDNtceOK                      1A   INZ('Y')
     D  DDAcSqOK                      1A   INZ('Y')
     D  DDCcyOK                       1A   INZ('Y')
     D  DDAmnpOK                      1A   INZ('Y')
     D  DDBRatOK                      1A   INZ('Y')
     D  DDDRIDOK                      1A   INZ('Y')
     D  DDDDMROK                      1A   INZ('Y')
     D  DDBsRCOK                      1A   INZ('Y')
     D  DDSpRtOK                      1A   INZ('Y')
     D  DDICMtOK                      1A   INZ('Y')
     D  DDNgvIOK                      1A   INZ('Y')
     D  DDIPFqOK                      1A   INZ('Y')
     D  DDNDatOK                      1A   INZ('Y')
     D  DDTotIOK                      1A   INZ('Y')
     D  DDIPDMOK                      1A   INZ('Y')
     D  DDCptIOK                      1A   INZ('Y')
     D  DDMTaxOK                      1A   INZ('Y')
     D  DDFUIDOK                      1A   INZ('Y')
     D  DDFLIdOK                      1A   INZ('Y')
     D  DDRDFCOK                      1A   INZ('Y')
     D  DDCDRfOK                      1A   INZ('Y')
     D  DDCDCHOK                      1A   INZ('Y')
     D  DDPrfCOK                      1A   INZ('Y')
     D  DDOrBrOK                      1A   INZ('Y')
     D  DDPtfROK                      1A   INZ('Y')
     D  DDAuRoOK                      1A   INZ('Y')
     D  DDCnNaOK                      1A   INZ('Y')
     D  DDRoFqOK                      1A   INZ('Y')
     D  DDRlDNOK                      1A   INZ('Y')
     D  DDIPdSOK                      1A   INZ('Y')
     D  DDIMetOK                      1A   INZ('Y')
     D  DDIScyOK                      1A   INZ('Y')
     D  DDInSAOK                      1A   INZ('Y')
     D  DDINosOK                      1A   INZ('Y')
     D  DDIi72OK                      1A   INZ('Y')
     D  DDFsrpOK                      1A   INZ('Y')
     D  DDFsgnOK                      1A   INZ('Y')
     D  DDFprcOK                      1A   INZ('Y')
     D  DDPenaOK                      1A   INZ('Y')                                           CAS001
     D  DDTrnTpOK                     1A   INZ('Y')                                           CAS001
     D  DDOylcOK                      1A   INZ('Y')                                           CAS001

      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A   INZ('Y')

      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')

      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')

      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')

      **  Data structure for dummy reference number for depo extension
     D                 DS
     D  DRefNo                 1      6
     D  DumConst               1      1
     D  DumRef                 2      6

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
      ** Error message field(s)
     D Msg1            S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A

      ** Field (500A) to receive the incoming Extra Data
     D InfData500      S            500A

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Link reference number
     D PLnkRef         S              6S 0

      ** Flag to indicate outcome of call to lower level module
     D AmendOK         S              1A   INZ('Y')

      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** A code to indicate the calling function to the lower level modules
     D REPO            S              4A   INZ('LDNI')

      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)

      ** Value Date as a Midas Day Number to be placed in either Payment
      **  or Receipt Date
     D ValDateMDN      S              5P 0

     D BenCust         S             10A
     D PortRef         S              4A
     D ActMode         S              1A
     D DepRef          S              6A

     D DealAmt         S             15S 0
     D PAccNom         S             15P 0
     D PAccVal         S             15P 0
     D Counter         S             15P 0
     D WCount          S             15P 0

     D WTHCNTN         S             15P 0

      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank2          S              2A   INZ(*BLANKS)
     D Blank3          S              3A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095

     D WPass           S              1A   INZ('Y')

      ** Loan/Deposit Ccy
     D LoanCcy         S                            LIKE(DDCCY)

      ** Branch
     D Branch          S                            LIKE(DDBRCA)

      ** Midas Day No Formatted Value Date
     D ValueDate       S              5  0

      ** Midas Day No Formatted Maturity Date
     D MaturDate       S              5  0

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D*RecNostro       S             12A                                                      CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D*PayNostro       S             12A                                                      CGL029
     D PayNostro       S             18A                                                      CGL029

     D Object          S             10A   INZ('MMREPOUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
     D OLD_MATD        S              5P 0

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepREPO         S              1A   INZ('N')

     D CSC011          S              1A   INZ('N')                                           CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D*PDealNo         S             18A                                               CSC011 CGL029
     D*PADealNo        S             18A                                               CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D WMSGTYPE        S              6A                                                      CSC011
     D TRFOTRANID      S                   LIKE(APFOTRANID)                                   CSC011
                                                                                              CSC011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMREPOC002

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,MMREPOC003

      ** A REPO transaction consist of a Loans and Deposits record,
      ** an unlimited number of Depo Movement records, and a trailer
      ** record containing the transaction summary details.
      ** Processing starts only when trailer record arrives.

     C                   SELECT

     C                   WHEN      MsgType = 'MMRPLD'
     C                   EXSR      WrtLDNIRec
     C                   EXSR      ClrAllDS

     C                   WHEN      MsgType = 'MMRPDM'
     C                   EXSR      WrtDEPORec
     C                   EXSR      ClrAllDS

     C                   WHEN      MsgType = 'MMRPTR'
     C                   EXSR      ClrAllDS
     C                   MOVEL     Trans5001     TranTrailer

     C                   ENDSL

      ** Only process transucktion record once the trailer arrives.

     C                   IF        MsgType <> 'MMRPTR'

     C                   COMMIT

     C                   RETURN

     C                   ENDIF

      * Incoming transaction is broken into 5000A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 5000A fields by loading them into
      * the appropriate (externally described) data structure.

     C                   EXSR      RtvLDNIRec

      ** Generate a timestamp for this transaction

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,MMREPOC004

      *  Check if valid REPO details exists for Front Office ID

     C                   EXSR      ChkValREPO
      *
      *  If valid REPO details does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      *  Check if valid REPO exists for Midas Transaction Number

     C                   EXSR      ChkValMiRe
      *
      *  If valid Transaction does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Transaction details file.

     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,MMREPOC005

      *  Validate Action Code

     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,MMREPOC006

      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,MMREPOC007
     C                   EXSR      DftSettmts
      /COPY WNCPYSRC,MMREPOC008
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,MMREPOC009
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,MMREPOC010

     C                   WHEN         DDACTN = 'A' or DDACTN = 'D'
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,MMREPOC011
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   IF        DDACTN = 'A' AND GHSUBS <> *BLANK

     C     GHSUBS        SCAN      TranInREPO                             99
     C                   IF        *in99
     C                   EVAL      RepREPO = 'Y'
     C                   ENDIF

      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   IF        RepREPO = 'Y'
     C                   EXSR      DtaSubs
     C                   ENDIF

     C                   ENDIF
      **                 (End of "if DDACTN = 'A' AND GHSUBS <> *blank")

     C                   IF        DDACTN = 'D'

     C                   EXSR      ValdTrDEPO

     C                   ELSE

     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,MMREPOC012
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,MMREPOC013
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,MMREPOC014
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,MMREPOC015

     C                   ENDIF

     C                   ENDSL
      *
     C     INVALID       TAG

      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
      *  Delete work and temporary files

     C                   IN        APDUMP
      /COPY WNCPYSRC,MMREPOC016

     C                   IF        ARERRMOD <> *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong

     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF

     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP

     C                   EXSR      DltWrkTmpF

     C                   RETURN

     C                   ELSE

      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,MMREPOC017
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,MMREPOC018

      *  If valid, send data queue entry to prompt DB update program
     C                   IF        Idx = 0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return

     C                   IF        RETURN = *BLANK

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMREPOC019

     C                   RETURN

      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * WrtLDNIRec - Routine to write Loans & Deposits record to         *
      *              work file.                                          *
      *                                                                  *
      ********************************************************************
     C     WrtLDNIRec    BEGSR

      ** Setup DS for writing to work files, processing starts
      ** later when the trailer file arrives.

     C                   MOVEL     Trans5001     TranInREPO
     C                   MOVEL     Infdata500    Infdata
     C                   MOVEL     Extdata500    Extdata

      ** Move incoming message DS to work file DS for writing to file

     C                   MOVE      TranInREPO    WkTrInREPO

      ** Setup keys for work files for accesing later

     C                   EVAL      WLFOTRANID = APFOTranID
     C                   EVAL      WLFOASOCID = APFOAsocID
     C                   EVAL      WLRPRLOCN  = APRPRLOCN

      ** Write message to work file for processing later when trailer arrives

     C                   WRITE     MMWLNDD0

      ** Write extended message details to corresponding work file

     C                   IF        InfData <> *BLANKS
     C                   MOVE      InfData       WInfData
     C                   EVAL      WAFOID = APFOTranID
     C                   EVAL      WAFOAS = APFOAsocID
     C                   EVAL      WARLOC = APRPRLOCN
     C                   WRITE     MMWINFD0
     C                   ENDIF

     C                   IF        ExtData <> *BLANKS
     C                   MOVE      ExtData       WExtData
     C                   EVAL      WEFOID = APFOTranID
     C                   EVAL      WEFOAS = APFOAsocID
     C                   EVAL      WERLOC = APRPRLOCN
     C                   WRITE     MMWEXTD0
     C                   ENDIF

     C                   IF        InPaySttmt <> *BLANKS
     C                   MOVE      InPaySttmt    WInPaySttmt
     C                   EVAL      WIFOID = APFOTranID
     C                   EVAL      WIFOAS = APFOAsocID
     C                   EVAL      WIRLOC = APRPRLOCN
     C                   WRITE     MMWESPD0
     C                   ENDIF

     C                   IF        InRecSttmt <> *BLANKS
     C                   MOVE      InRecSttmt    WInRecSttmt
     C                   EVAL      WOFOID = APFOTranID
     C                   EVAL      WOFOAS = APFOAsocID
     C                   EVAL      WORLOC = APRPRLOCN
     C                   WRITE     MMWESRD0
     C                   ENDIF

     C                   IF        InFRASttmt <> *BLANKS
     C                   MOVE      InFRASttmt    WInFRASttmt
     C                   EVAL      WUFOID = APFOTranID
     C                   EVAL      WUFOAS = APFOAsocID
     C                   EVAL      WURLOC = APRPRLOCN
     C                   WRITE     MMWESFD0
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * WrtDEPORec - Routine to write depot movement records to          *
      *              work file.                                          *
      *                                                                  *
      ********************************************************************
     C     WrtDEPORec    BEGSR

     C                   MOVEL     Trans5001     TranInDEPO

     C                   IF        TranInDepo <> *BLANKS
     C                   MOVE      TranInDepo    WkTrInDEPO
     C                   EVAL      WDFOTRANID = APFOTranID
     C                   EVAL      WDFOASOCID = APFOAsocID
     C                   EVAL      WDRPRLOCN  = APRPRLOCN
     C                   WRITE     MMWRPDD0
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * RtvLDNIRec - Routine to retrieve Loans & Deposits record from    *
      *              work file.                                          *
      *                                                                  *
      ********************************************************************
     C     RtvLDNIRec    BEGSR

     C     APFOAsocID    CHAIN     MMWLNDL0                           99

     C                   IF        *IN99 = *OFF
     C     APFOAsocID    CHAIN     MMWINFL0                           99
     C     APFOAsocID    CHAIN     MMWEXTL0                           99
     C     APFOAsocID    CHAIN     MMWESPL0                           99
     C     APFOAsocID    CHAIN     MMWESRL0                           99
     C     APFOAsocID    CHAIN     MMWESFL0                           99
     C                   ENDIF

     C                   MOVE      WkTrInREPO    TranInREPO
     C                   MOVE      WInfdata      Infdata
     C                   MOVE      WExtdata      Extdata
     C                   MOVE      WInPaySttmt   InPaySttmt
     C                   MOVE      WInRecSttmt   InRecSttmt
     C                   MOVE      WInFRASttmt   InFRASttmt

     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * ChkValREPO - Routine to check if valid Transaction details exist *
      *                                                                  *
      ********************************************************************
     C     ChkValREPO    BEGSR

      * Check for REPO on Valid file
     C     WLFOTranID    CHAIN     MMVRPLNL0                          99

      * If record found...
     C                   IF        *IN99 = *OFF

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     WLFOTranID    CHAIN     MMVRPLNL0                          99

      * Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiRe - Routine to check if valid REPO Transaction       *
      *    exists for Midas Transaction number                        *
      *                                                               *
      *****************************************************************

     C     ChkValMiRe    BEGSR

      * If (numeric) Midas Transaction number supplied

     C                   TESTN                   DDDLNO               9898
     C
     C                   IF        DDDLNO <> *BLANKS AND
     C                             *IN98 = *ON

      * Check for Transaction on Valid file
     C                   MOVEL     DDDLNO        IKDN38
     C     IKDN38        CHAIN     MMVRPLNL1                          99

      * If record found...
     C                   IF        *IN99 = *OFF

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     IKDN38        CHAIN     MMVRPLNL1                          99

      * Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C                   IF        DDACTN = 'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   IF        DDDLNO = *BLANK
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF
     C                   ENDIF

      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the mm database is retrieved
      * as well.

     C                   RESET                   ReturnCode

     C                   CALLB     'MMLDNIRTV'
      *
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    WLFOTranID       20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    APFOAsocID
      *
      * (Midas) Transaction Number
     C                   PARM                    DDDLNO
      * (Midas) Depot Movement Reference                                                      222373
     C                   PARM                    DDDDMR                                       222373
      *
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      *
      * Booking branch
     C                   PARM                    DDBRCA
      *
      * REPO Flag
     C                   PARM      'Y'           RepoFlag          1
      *
      * Outputs
      *
      * (Current) Transaction in file format
     C                   PARM                    REPOFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Transaction Number
     C                   PARM                    DDDlnoOK          1
      *
      * OK - Booking branch
     C                   PARM                    DDBrcaOK
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMREPOC022

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************

     C     DftSettmts    BEGSR

      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.

     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)

     C                   CALLB     'ZASETINDFT'

      ** Output
      ** Calling function type
     C                   PARM                    REPO
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    DDCcy
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    DDCcy
      ** Customer (shortname or number)
     C                   PARM                    DDCust
      ** Deal type
     C                   PARM                    DDType
      ** Federal Funds Ind.
     C                   PARM                    DDFedF
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4
      ** Type of ISDA agreement
     C                   PARM                    Blank6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt

      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      DDCCY         #TRCCY                                      CSF011A
     C                   PARM      DDCCY         #TPCCY                                      CSF011A

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      * For Amends, put the complete (pre-existing) Transaction into the Valid
      *  file record - fields in this will be updated during processing

     C                   MOVE      REPOFilFmt    ValidREPO
     C                   Z-ADD     HKMATD        OLD_MATD

     C                   EVAL      FLRSTM     = HKRSTM                                        CGL029
     C                   EVAL      FLRONS     = DELDRecInsEx                                  CGL029
     C                   EVAL      FLREC2     = DELDRecIns + HKROBR                           CGL029
     C**********         EVAL      DBRecSttmt = DELDRecIns + HKROBR                           CGL029
     C                   EVAL      FLRSCY     = HKSTCY
     C                   EVAL      FLPSTM     = HKPSTM                                        CGL029
     C                   EVAL      FLPONS     = DELDPayInsEx                                  CGL029
     C                   EVAL      FLPAY2     = DELDPayIns + HKPOBR + HKCVMR                  CGL029
     C**********         EVAL      DBPaySttmt = DELDPayIns + HKPOBR + HKCVMR                  CGL029
     C                   EVAL      FLPSCY     = HKSTCY
     C                   EVAL      FLIC72     = HKIC72

      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'

      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Current Settlement Instruction in input format
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      HKCCY         #TRCCY                                      CSF011A
     C                   PARM      HKCCY         #TPCCY                                      CSF011A

      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.

     C                   IF            (InPaySttmt = *blank)
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF

     C                   IF            (InRecSttmt = *blank)
     C                   EVAL      InRecSttmt = CrRecSttmt
     C                   ENDIF

      * Do data substitution for Settlement Instructions

     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      InPaySttmt                             99
     C  N99GHSUBS        SCAN      InRecSttmt                             99
     C                   IF        *IN99 = *on
     C                   EXSR      SDtDtaSubs
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * Beer Troubleshooting to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

      * Validate REPO Loans and Deposits Transaction details

     C                   EXSR      ValdTrREPO
      *
      *  If error in validation, fail this input
      *
     C                   IF        IDx <> 0
     C                   GOTO      EValidTr
     C                   ENDIF

      * Validate REPO Depot Movements Transaction details

     C                   EXSR      ValdTrDEPO
      *
      *  If error in validation, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      EValidTr
     C                   ENDIF

      * Validate REPO Depot Movements Transaction details

     C                   EXSR      ValTrailer
      *
      *  If error in validation, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      EValidTr
     C                   ENDIF

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrREPO - Validate REPO Transaction details                *
      *                                                               *
      *****************************************************************
     C     ValdTrREPO    BEGSR

     C                   CALLB     'MMLDNIVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranInREPO
     C                   PARM                    InfData
      * Receive Settlement Currency, Method & Nostro and
      * Payment Settlement Currency, Method & Nostro
      * Extra Data
     C                   PARM      *BLANK        RecSetCcy
     C                   PARM      *ZERO         RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANK        PaySetCcy
     C                   PARM      *ZERO         PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM      WLFOTRANID    @@FRNT           20
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidREPO
     C                   PARM      'Y'           RepoFlag          1
     C/COPY WNCPYSRC,MMREPOC021

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrDEPO - Validate DEPO Transaction details                *
      *                                                               *
      *****************************************************************
     C     ValdTrDEPO    BEGSR

     C                   Z-ADD     *ZERO         PAccNom
     C                   Z-ADD     *ZERO         PAccVal
     C                   Z-ADD     *ZERO         WCount
     C                   Z-ADD     *ZERO         Counter

     C******LOVAL        SETLL     MMWRPDL0                                                   239889
     C     APFOAsocID    SETLL     MMWRPDL0                                                   239889

     C     APFOAsocID    READE     MMWRPDL0                               99

     C                   IF        DDACTN = 'I' and *IN99 = *ON                               239899
     C                   ADD       1             Idx                                          239899
     C                   EVAL      FldNameArr(Idx) = '*ANY'                                   239899
     C                   EVAL      MsgIDArr(Idx) = 'MMA0778'                                  239899
     C                   ENDIF                                                                239899
                                                                                              239899
     C                   DOW       *IN99 = *OFF and Idx = 0

     C                   EVAL      Counter = Counter + 1

     C                   IF        DDACTN <> 'D'

     C                   EXSR      SetupParms

     C                   CALLB     'MMRPDL1VL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranInDEPO
     C                   PARM                    LoanCcy
     C                   PARM                    Branch
     C                   PARM                    ValueDate
     C                   PARM                    MaturDate
     C                   PARM                    BenCust
     C                   PARM                    PortRef
     C                   PARM                    ActMode
     C                   PARM                    DepRef
      * Receive Datastructure for Error indicatirs flags
     C                   PARM                    MMErep
      * Receive Datastructure for Field Name Array
     C                   PARM                    FldNameArr
      * Receive Datastructure for Message ID Array
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidDEPO

     C                   ENDIF

     C                   IF        Idx = 0

     C                   IF        DDACTN <> 'D'
     C                   EXSR      CalcNomVal
     C                   ENDIF

     C                   IF        Idx = 0                                                    240474
     C                   EXSR      WriteTDepot
     C                   ENDIF                                                                240474

     C                   ENDIF

     C     APFOAsocID    READE     MMWRPDL0                               99

     C                   ENDDO

     C                   IF        DDACTN <> 'D'

      ** Error if counter not equal to expected number of depot movement records

     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZALIGNok
     C                   PARM      THNODP        ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      13            ZADIG
     C
     C                   MOVE      ZFIELD        WCount

     C                   IF        Counter <> WCount and Idx = 0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIDArr(Idx) = 'MMA1222'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupParms - Setup parameters for DEPO validation routine.    *
      *                                                               *
      *****************************************************************

     C     SetupParms    BEGSR

     C                   MOVE      WkTrInDEPO    TranInDEPO

     C                   EVAL      LoanCcy = DDCCY

     C                   EVAL      Branch  = DDBRCA
      *
      * Convert Value Date a Midas Day Number
      *
     C                   EVAL      ValDateMDN=*Zeros
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDVDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

     C                   EVAL      ValueDate = ValDateMDN
     C                   EVAL      ValDateMDN=*Zeros
      *
      * Convert Maturity Date a Midas Day Number
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDMDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

     C                   EVAL      MaturDate = ValDateMDN

     C                   EVAL      BenCust = DDCUST
     C                   EVAL      PortRef = DDPTFR

     C                   IF        DDACTN = 'D'
     C                   EVAL      ActMode = 'R'
     C                   ELSE
     C                   EVAL      ActMode = DDACTN
     C                   ENDIF
      *
      ** If no Depot Reference number exists create a dummy one so that
      ** extension records and certificate records can be matched to
      ** depot movements in update module.
      *
     C                   IF        DDDPMV = *Blanks

      ** Set up dummy reference number
     C                   ADD       1             DRef              5 0
     C                   MOVE      DRef          DumRef
     C                   MOVEL     'X'           DumConst
     C                   MOVEL     DRefNo        DDDPMV

     C                   ENDIF
      *
      ** Set up Depot Reference numver to export to module MMVACCD
      *
     C                   EVAL      DepRef = DDDPMV

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcNomVal - Claculate total REPO nominal and value amount    *
      *                                                               *
      *****************************************************************
     C     CalcNomVal    BEGSR
      *
     C                   CALLB     'MMREPOACC'
      *
      * Input parameters
      *
      * Return code
     C**********         PARM                    RetCodeIn                                    240474
     C                   PARM      *BLANKS       RetCodeIn                                    240474
      * Transaction information (DS) from source system
     C                   PARM                    TranInDEPO
      * Validated depot movements details
     C                   PARM                    ValidDEPO
      * Deal Currency
     C                   PARM                    DDCCY
      * Midas Run Day Numner
     C                   PARM                    BJRDNB
      *
      * Input/Output parameters
      * Total Nominal accumulated
      * Total Value accumulated
     C                   PARM                    PAccNom
     C                   PARM                    PAccVal

     C                   IF        RetCodeIn <> '*ERROR'                                      240474
     C                             AND  RetCodeIn <> *BLANKS                                  240474
     C                   ADD       1             Idx                                          240474
     C                   EVAL      FldNameArr(Idx) = 'DDVDDL'                                 240474
     C                   EVAL      MsgIDArr(Idx) = RetCodeIn                                  240474
     C                   ENDIF                                                                240474
                                                                                              240474
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValTrailer - Validate REPO Transaction details                *
      *                                                               *
      *****************************************************************
     C     ValTrailer    BEGSR
      *
     C                   EVAL      KADLNO = DDDLNO
     C                   EVAL      KATRNT = DDTRTP
     C                   EVAL      KADLAM = DDAMNP
     C                   EVAL      KAVDAT = DDVDAT
     C                   EVAL      KAMDAT = DDMDAT

     C                   EVAL      KACCY = DDCCY

     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*BLANKS'     @@RTCD
     C                   PARM      '*KEY   '     @@OPTN
     C                   PARM      DDCUST        @@KEY1
     C                   PARM      *BLANKS       @@KYST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   EVAL      KACUST = BBCUST

     C                   EVAL      KARPRT = DDSPRT

     C                   MOVEL     THCNTN        KACNTN

     C                   MOVEL     THCNTN        KATOTN
     C                   MOVEL     PAccVal       KATOTV

     C                   Z-ADD     PAccNom       HATOTN
     C                   Z-ADD     PAccVal       HATOTV

     C                   EVAL      KANARR = THNARR

     C                   MOVEL     THFEAM        KAFEAM

     C                   EVAL      KAFECY = THFECY

     C                   MOVEL     THFESM        KAFESM
     C
     C                   EVAL      KAACCN = THACCN
      *
      ** Set up deal amount in case amount has been ameneded
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      LoanCcy       @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   MOVE      A6NBDP        LoanDP            1 0
     C                   MOVE      *Blanks       ZFIELD           16
     C                   MOVE      DDAMNP        ZFIELD
     C                   Z-ADD     LoanDP        ZADEC
     C     15            SUB       ZADEC         ZADIG

     C                   IF        LoanDp <> 0
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C
     C                   MOVE      ZFIELD        DealAmt
     C
     C                   ELSE
     C                   MOVE      DDAMNP        DealAmt
     C                   ENDIF
     C

     C                   CALLB     'MMRPDL2VL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranInTrail
     C                   PARM                    LoanCcy
     C                   PARM                    Branch
     C                   PARM                    DealAmt
      * Receive Datastructure for Error indicatirs flags
     C                   PARM                    MMErHd
      * Receive Datastructure for Field Name Array
     C                   PARM                    FldNameArr
      * Receive Datastructure for Message ID Array
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      * Transaction information (DS) from source system
     C                   PARM                    ValidTrailer
     C                   PARM                    @INKI             1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************

     C     ValidateSt    BEGSR

      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.

     C                   IF        NOT (DDCustOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF

      * The called module uses the value date in Midas Day Number format,
      *  which will not have been returned from the overall validation
      *  routine, so it needs to be converetd here.

     C                   IF        DDVDatOK <> 'N'

     C                   CALLB     'ZDATE1'
     C                   PARM                    DDVDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

      * If the Deal Type is for a Loan,    set the Pay Date = Value Date
      * If the Deal Type is for a Deposit, set the Receive Date = Value Date
     C                   IF           DDType = 'IP' OR DDType = 'TI'
     C                             OR DDType = 'CL' OR DDType = 'LN'
     C                             OR DDType = 'DL'
     C                   EVAL      PayDat = ValDateMDN
     C                   ELSE
     C                   EVAL      RecDat = ValDateMDN
     C                   ENDIF

     C                   ENDIF

     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'

      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    REPO
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Customer (shortname or number)
     C                   PARM                    DDCUST
      ** Deal type
     C                   PARM                    DDTYPE
      ** Federal Funds Ind.
     C                   PARM                    DDFEDF
      ** Booking Branch
     C                   PARM                    DDBrCA
      ** Receipt Date
     C                   PARM                    RecDat
      ** Payment Date
     C                   PARM                    Paydat
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
      * Action Code
     C                   PARM                    DDACTN
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373

      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
     C                   PARM                    WFldNamArr                                   CRE008
     C                   PARM                    WMsgIDArr                                    CRE008
     C                   PARM                    WMsgDtaArr                                   CRE008
      ** Array index (3P0) from/to caller                                                     CRE008
     C                   PARM                    WIdx                                         CRE008
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3

      **MIDAS*Our Receive/ Pay Instructions (for Settlm Meth = 04 )                           222373
     C**********         PARM                    @MORPI           24                          222373
      *
     C     ValSetExit    TAG

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************

     C     DtaSubs       BEGSR

      ** Convert file fields to screen format
     C                   RESET                   ReturnCode
     C                   CALLB     'MMLDNICVT'
      * Return Code
     C                   PARM                    ReturnCode
      * Input parameters
      * REPO Transaction - file formats
     C                   PARM                    REPOFilFmt
      *
      * Output parameters
      * REPO Details - screen formats
     C                   PARM                    CurTrREPO
      * Deal Status
     C                   PARM                    DDSTS
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10

      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.

     C                   IF        RepREPO = 'Y'

     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInREPO    IncData        2000
      * Current Data
     C                   PARM      CurTrREPO     CurData        2000

     C                   MOVEL     IncDATA       TranInREPO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *                                                               *
      *****************************************************************

     C     SDtDtaSubs    BEGSR

      ** PAYMENT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      InPaySttmt    IncDATA        2000
      * Current Data
     C                   PARM      CrPaySttmt    CurDATA        2000

     C                   MOVEL     IncDATA       InPaySttmt

      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InRecSttmt    IncDATA
      * Current Data
     C                   PARM      CrRecSttmt    CurDATA

     C                   MOVEL     IncDATA       InRecSttmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************

     C     ValdateAmd    BEGSR

      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.  Some are never amendable and some depend upon ICD
      ** settings as to whether they are amendable.

      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.

      ** These fields are then compared with the fields on the input
      ** transaction.

      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.

      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT

     C                   RESET                   ReturnCode

     C                   CALLB     'MMLDNICVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    REPOFilfmt

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    CurTrREPO
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10

      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'MMLDNIAMD'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranInREPO
      * (Current) Deal in Screen Format
     C                   PARM                    CurTrREPO
      * (Current) Deal in file format
     C                   PARM                    REPOFilfmt

      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1

      ** If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************

     C     CheckWrite    BEGSR

      *  If no errors were found:
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report customer status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
     
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+

     C                   IF        Idx = 0

     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDEALN
     C                   ENDIF

     C                   IF        Idx = 0
     C                   EXSR      SETUPVALID
     C                   WRITE     MMVRPLND0
     C                   IF        DDACTN <> 'X'
     C                   EXSR      WriteVDepot
     C                   ENDIF
      ** Insert DLDLDCQD record for CLE025 processing                                         247888
     C                   IF        DDACTN = 'I' AND CLE025 = 'Y'                              247888
     C     DDDLNO        CHAIN     DLDLDCD0                           12                      247888
     C     *IN12         IFEQ      *ON                                                        247888
     C                   EVAL      DX_F1DLNO = DDDLNO                                         247888
     C                   EVAL      DX_F1BRCA = DDBRCA                                         247888
     C                   WRITE     DLDLDCD0                                                   247888
     C                   ENDIF                                                                247888
     C                   ENDIF                                                                247888
                                                                                              247888
     C                   EXSR      CallMsgHdl
     C                   ENDIF

     C                   ENDIF

     C                   IF        IDx > 0

     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
     C                   IF        APRprLocn = 'B'

     C                   WRITE     MMIRPLDD0
     C                   WRITE     APIDSETD0
                                                                                              CSC011
      ** Write all invalid records to the support log file                                    CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      WMSGTYPE  = 'MMRPLD'                                       CSC011
      ** Keep trailer front office id for update later of trailer log file                    CSC011
     C                   EVAL      TRFOTRANID  = APFOTRANID                                   CSC011
     C                   EVAL      APFOTRANID  = WLFOTRANID                                   CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranInREPO +                                    CSC011
     C                                        InRecSttmt +                                    CSC011
     C                                        InPaySttmt +                                    CSC011
     C                                        InfData +                                       CSC011
     C                                        ExtData                                         CSC011
                                                                                              CSC011
     C                   EXSR      WrtInvLog                                                  CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011

     C                   EXSR      WriteIDepot

     C                   ENDIF

     C                   EXSR      CallMsgHdl

     C                   ENDIF

      ** Delete records from work and temporary files
     C                   EXSR      DltWrkTmpF

     C                   COMMIT

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WriteVDepot - Write valid depot records to file               *
      *                                                               *
      *****************************************************************
     C     WriteVDepot   BEGSR

     C                   EVAL      WPass = 'Y'

     C******LOVAL        SETLL     MMTRPDML0                                                  239889
     C     APFOAsocID    SETLL     MMTRPDML0                                                  239889

     C     APFOAsocID    READE     MMTRPDML0                              99

     C     *IN99         DOWEQ     '0'

      ** Only update Fee Details for first depot movement
     C                   IF        WPass <> 'N'

      ** Skip this for deletes                                                                241257
     c                   IF        DDACTN <> 'D'                                              241257
                                                                                              241257
     C                   EVAL      DCCE = HAFECY

     C                   Z-ADD     HAFEAM        DCHA

     C                   Z-ADD     HAFESM        DCSE

     C                   EVAL      DCAB = HABRCA

     C                   EVAL      DCAT = HAACCN

     C                   EVAL      WPASS = 'N'
                                                                                              241257
     C                   ENDIF                                                                241257

     C                   ENDIF

     C                   WRITE     MMVRPDMD0

     C     APFOAsocID    READE     MMTRPDML0                              99

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WriteTDepot - Write temporay valid depot records to file      *
      *                                                               *
      *****************************************************************
     C     WriteTDepot   BEGSR

     ** Initialise all fields prior to update

     C                   CLEAR                   MMTRPDMD0

     C                   SELECT
      *
      ** When Delete
      ** ===========
     C                   WHEN      DDACTN = 'D'
      *
      ** Retrieve original record from file
     C*****DDDPMV********CHAIN     DPTMVDL1                           88                      241257
     C     DDDLNO        CHAIN     DPTMVDL1                           88                      241257

     C                   EVAL      RECI = '*'

     C     ORED          IFLT      BJRDNB
     C                   EVAL      RECI = 'R'
     C                   ENDIF

     C                   EVAL      CHTP = 'D'
     C                   EVAL      LCD = BJRDNB
      *
      *  Set Pay/Receive processed indicators to N if Other Settlement
      *  record already printed.
      *
     C     DPR1          IFEQ      'Y'
     C                   MOVE      'N'           DPR1
     C                   ELSE
     C                   MOVE      'Y'           DPR1
     C                   ENDIF
      *
     C     DPR2          IFEQ      'Y'
     C                   MOVE      'N'           DPR2
     C                   ELSE
     C                   MOVE      'Y'           DPR2
     C                   ENDIF
      *
     C                   TESTB     '0'           DPMS                     99
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           DCFR
     C                   ELSE
     C                   MOVE      'Y'           DCFR
     C                   ENDIF
      *
      ** Others
      ** ======
     C                   OTHER
      *
      ** Reaccess Security Details
     C     DDSECT        CHAIN     SECTY                              88

     C                   EVAL      RECI = 'D'

      ** If a Rollover, DPRN needs to be blanked so that MMRPDLUPD writes
      ** a new Depot Movement rather than updating the original one.
     C                   IF        DPRN = *BLANKS and DDACTN <> 'R'
     C                   EVAL      DPRN = DDDPMV
     C                   ENDIF

     C                   EVAL      DPSS = SESN
     C                   EVAL      DPMV = DDTRTP

     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*BLANKS'     @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM      DDORDP        @@KEY1           10
     C                   PARM      *BLANKS       @@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   MOVEL     BBCUST        DPID

     C                   MOVEL     BBCUST        DPBN

     C                   IF        DDTRTP = 'RR' or DDTRTP = 'BB'
     C                             or DDTRTP = 'PL'
     C                   EVAL      DPMD = ValueDate
     C                   ELSE
      *
      ** If this is a call deposit maturity date may not have been entered
      ** Therefore set Depot Out date to maturity of security. If there
      ** is no Maturity date e.g with shares set it to 99999.
      *
     C                   IF        DDTYPE = 'CD'

     C                   IF        MaturDate <> *ZERO
     C                   EVAL      DPMD = MaturDate
     C                   ELSE

     C                   IF        MATY <> *ZEROS
     C                   EVAL      DPMD = MATY
     C                   ELSE

     C                   EVAL      DPMD = 99999
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

     C                   EVAL      DPMD = Maturdate

     C                   ENDIF

     C                   ENDIF

     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*BLANKS'     @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM      DDCPDP        @@KEY1           10
     C                   PARM      *BLANKS       @@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   MOVEL     BBCUST        DPOD

     C                   IF        DDTRTP = 'RP' or DDTRTP = 'BL'
     C                             or DDTRTP = 'PD'
     C                   EVAL      DPDO = ValueDate
     C                   ELSE
      *
      ** If this is a call loan maturity date will not have been entered
      ** Therefore set Depot In date to maturity of security. If there
      ** is no Maturity date e.g with shares set it to 99999.
      *
     C                   IF        DDTYPE = 'CL'

     C                   IF        MaturDate <> *ZERO
     C                   EVAL      DPDO = MaturDate
     C                   ELSE

     C                   IF        MATY <> *ZEROS
     C                   EVAL      DPDO = MATY
     C                   ELSE
     C                   EVAL      DPDO = 99999
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

     C                   EVAL      DPDO = MaturDate                                           240856
                                                                                              240856
     C                   ENDIF

     C**********         EVAL      DPDO = MaturDate                                           240586

     C                   ENDIF

     C                   EVAL      DPBA = DDBRCA

     C                   EVAL      ORBR = *BLANKS
      *
      ** If CAC005 is on convert Book Code to Pseudo Book
     C                   IF        CAC005 = 'Y'

     C                   CALL      'AOBKPCR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*PSEUDO'     POPTN             7
     C                   PARM      DDBOKC        PBOOK             2
     C                   PARM      DDPRFC        PPRFC             4
     C                   PARM                    PPSCD             2

     C                   EVAL      DPBK = PPSCD

     C                   ELSE

     C                   EVAL      DPBK = DDBOKC

     C                   ENDIF

     C                   EVAL      DPMK = MKTI

     C                   Z-ADD     IFNOML        DPNA

     C                   EVAL      DPNR = THNARR

     C                   Z-ADD     IFVALP        MKTP

     C                   MOVE      DDDLNO        DPAD

     C                   EVAL      DCFR = 'Y'

     C                   IF        DDTRTP = 'RP' or DDTRTP = 'RR'

     C                   EVAL      RPIN = 'R'

     C                   ELSE

     C                   IF        DDTRTP = 'PL' or DDTRTP = 'PD'

     C                   EVAL      RPIN = 'P'

     C                   ELSE

     C                   EVAL      RPIN = 'B'

     C                   ENDIF

     C                   ENDIF

     C                   Z-ADD     IFVDIN        DVIN

     C                   Z-ADD     IFMDIN        DMIN

     C                   Z-ADD     IFEXCR        DEXRT

     C                   EVAL      DFROM = 'R'
      *
      ** Set Switch in-out indicator to be 'I' if depot movement is added
      ** via Margin Call program
     C                   EVAL      DRefNo = DDDPMV

     C                   IF        DDACTN = 'I'
     C                   EVAL      CHTP = 'I'
     C                   ELSE
     C                   EVAL      CHTP = 'A'
     C                   ENDIF

     C                   IF        DDACTN = 'M' and DumConst = 'X'
     C                   EVAL      SIOI = 'I'
     C                   ENDIF

     C                   ENDSL

     C                   EVAL      DMFRNT = WDFOTRANID
     C                   EVAL      DMAFRT = WDFOASOCID
     C                   EVAL      DMREPA = WDRPRLOCN
     C                   EVAL      DMTMST = TimeStamp

      ** Write record to file

     C                   WRITE     MMTRPDMD0

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WriteIDepot - Write invalid depot records to file             *
      *                                                               *
      *****************************************************************
     C     WriteIDepot   BEGSR

     C******LOVAL        SETLL     MMWRPDL0                                                   239889
     C     APFOAsocID    SETLL     MMWRPDL0                                                   239889

     C     APFOAsocID    READE     MMWRPDL0                               99

     C     *IN99         DOWEQ     '0'

     C                   MOVE      WkTrInDEPO    TranInDepo

     C                   EVAL      GADLNO = WDDLNO
     C                   EVAL      GAACTN = WDACTN
     C                   EVAL      DDFOID = WDFOTRANID
     C                   EVAL      DDFOAS = WDFOASOCID
     C                   EVAL      DDRLOC = WDRPRLOCN

     C                   WRITE     MMIRPDD0
                                                                                              CSC011
      ** Write all invalid records to the support log file                                    CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      WMSGTYPE  = 'MMRPDM'                                       CSC011
     C                   EVAL      APFOTRANID  = WDFOTRANID                                   CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranInDEPO +                                    CSC011
     C                                        ExtData                                         CSC011
                                                                                              CSC011
     C                   EXSR      WrtInvLog                                                  CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011

     C     APFOAsocID    READE     MMWRPDL0                               99

     C                   ENDDO

      ** Write invalid trailer file as well

     C                   MOVE      TranTrailer   WkTrTrailer

     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
     C                   EVAL      IHFOID = TRFOTranID                                        CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      IHFOID = APFOTranID
     C                   ENDIF                                                                CSC011
     C                   EVAL      IHFOAS = APFOAsocID
     C                   EVAL      IHRLOC = APRPRLOCN

     C                   WRITE     MMIRPTRD0
                                                                                              CSC011
      ** Write all invalid records to the support log file                                    CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      WMSGTYPE  = 'MMRPTR'                                       CSC011
     C                   EVAL      APFOTRANID  = TRFOTRANID                                   CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranTrailer +                                   CSC011
     C                                        ExtData                                         CSC011
                                                                                              CSC011
     C                   EXSR      WrtInvLog                                                  CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ClrAllDS  - Clear all work and temporary data structures for  *
      *             clean processing.                                 *
      *                                                               *
      *****************************************************************
     C     ClrAllDS      BEGSR

     C                   CLEAR                   TranInREPO
     C                   CLEAR                   WkTrInREPO
     C                   CLEAR                   TranInDEPO
     C                   CLEAR                   WkTrInDEPO
     C                   CLEAR                   TranTrailer
     C                   CLEAR                   TranInTrail
     C                   CLEAR                   InfData
     C                   CLEAR                   WInfData
     C                   CLEAR                   ExtData
     C                   CLEAR                   WExtData
     C                   CLEAR                   InPaySttmt
     C                   CLEAR                   WInPaySttmt
     C                   CLEAR                   InRecSttmt
     C                   CLEAR                   WInRecSttmt
     C                   CLEAR                   InFRASttmt
     C                   CLEAR                   WInFRASttmt

     C                   MOVE      *ALL'Y'       MMErHd
     C                   MOVE      *ALL'Y'       MMERep
     C                   MOVE      *ALL'Y'       OKFlagsDS
     C                   MOVE      *ALL'Y'       OKPayInsDS
     C                   MOVE      *ALL'Y'       OKRecInsDS
     C                   MOVE      *ALL'Y'       OKFRAInsDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DltWrkTmpF  - Clear work and temporary files for this record  *
      *               set.                                            *
      *                                                               *
      *****************************************************************
     C     DltWrkTmpF    BEGSR

      ** Remove record from loans and deposits work and temporary files

     C     APFOAsocID    CHAIN     MMWLNDL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    MMWLNDDX
     C                   ENDIF
     C     APFOAsocID    CHAIN     MMTRPLNL0                          99
     C                   IF        *IN99 = *OFF
     C                   DELETE    MMTRPLNDX
     C                   ENDIF
     C     APFOAsocID    CHAIN     MMWINFL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    MMWINFDX
     C                   ENDIF
     C     APFOAsocID    CHAIN     MMWEXTL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    MMWEXTDX
     C                   ENDIF
     C     APFOAsocID    CHAIN     MMWESPL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    MMWESPDX
     C                   ENDIF
     C     APFOAsocID    CHAIN     MMWESRL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    MMWESRDX
     C                   ENDIF
     C     APFOAsocID    CHAIN     MMWESFL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    MMWESFDX
     C                   ENDIF

      ** Remove record from depot movements work and temporary file

     C******LOVAL        SETLL     MMWRPDL0                                                   239889
     C     APFOAsocID    SETLL     MMWRPDL0                                                   239889

     C     APFOAsocID    READE     MMWRPDL0                               99

     C     *IN99         DOWEQ     '0'

     C                   DELETE    MMWRPDDX

     C     APFOAsocID    READE     MMWRPDL0                               99

     C                   ENDDO

     C******LOVAL        SETLL     MMTRPDML0                                                  239889
     C     APFOAsocID    SETLL     MMTRPDML0                                                  239889

     C     APFOAsocID    READE     MMTRPDML0                              99

     C     *IN99         DOWEQ     '0'

     C                   DELETE    MMTRPDMDX

     C     APFOAsocID    READE     MMTRPDML0                              99

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx

     C                   RESET                   FldNoArr

     C                   RESET                   OKFlagsDS

     C                   RESET                   AmendOK

     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS

     C                   RESET                   PayDat
     C                   RESET                   RecDat

     C                   CLEAR                   ValidREPO

      ** Numeric fields within 'ValidREPO' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields

     C                   Z-ADD     *ZERO         IKRSTM
     C**********         Z-ADD     *ZERO         IKROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKROCN                                       CSD027
     C                   EVAL      IKROBN = *BLANKS                                           CSD027
     C                   EVAL      IKROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKPSTM
     C**********         Z-ADD     *ZERO         IKPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKPOCN                                       CSD027
     C                   EVAL      IKPOBN = *BLANKS                                           CSD027
     C                   EVAL      IKPOCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKOMDT

      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.

     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt

     C                   CLEAR                   CurTrREPO

     C                   CLEAR                   ValidREPO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************

     C     SETUPINVAL    BEGSR

      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDMsgType  = 'MMRPLD'
     C                   EVAL      DDFOtranID = WLFOTranID
     C                   EVAL      DDFOAsocID = WLFOAsocID
     C                   EVAL      DDRprLocn  = WLRprLocn
     C                   MOVE      TimeStamp     DDTMESTMP

      * Setup the Last Breakdown User Id
     C                   IF        CDL007 = 'Y'
     C                   EVAL      DDBUSR     = IF_BUSR
     C                   ENDIF

      * Setup the Automatic Authorisation Flag
     C                   IF        CAP051 = 'Y'
     C                   EVAL      DDAUTH     = IF_AUTH
     C                   ENDIF

     C                   EVAL      TranStatus = 'F'

      /COPY WNCPYSRC,SDSECDC016
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *                                                               *
      *****************************************************************

     C     SETUPDEALN    BEGSR

     C                   IF           DDDLNO = *blanks
     C                             OR DDDLNO = *zeros

     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDDLNO
     C                   PARM      *ZEROS        IKDN38

     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDlnoOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      ** If deal number was entered, put it in the file field
     C                   ELSE

     C                   MOVE      DDDLNO        IKDN38

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      * For Inserts and Amends, put the Settlement Instructions (input or
      *  defaulted) into the Valid file record.
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record
     C                   IF        DDACTN = 'I'
     C                             OR (DDACTN = 'A')
     C                   MOVEL     FLRSTM        IKRSTM                                       CGL029
     C                   MOVEL     FLPSTM        IKPSTM                                       CGL029
     C                   MOVEL     FLRONS        LDNIRecInsEx                                 CGL029
     C                   MOVEL     FLPONS        LDNIPayInsEx                                 CGL029
     C                   MOVEL     FLPAY         LDNIPayIns                                   CGL029
     C                   MOVEL     FLREC         LDNIRecIns                                   CGL029
     C**********         MOVEL     DBPaySttmt    LDNIPayIns                                   CGL029
     C**********         MOVEL     DBRecSttmt    LDNIRecIns                                   CGL029
     C                   MOVE      FLPOBR        IKPOBR
     C                   MOVE      FLROBR        IKROBR
     C                   MOVE      FLCVMR        IKCVMR
     C                   MOVE      FLPSCY        IKSTCY
     C                   MOVE      FLIC72        IKIC72
     C                   ENDIF

      * For Deletes & Authorises, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVE      REPOFilFmt    ValidREPO
     C                   ENDIF

      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      IKLACT = DDACTN

      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      IKFRNT = WLFOTranID
     C                   EVAL      IKAFRT = WLFOAsocID
     C                   EVAL      IKREPA = WLRprLocn
     C                   EVAL      IKTMESTMP = TimeStamp

      * Information needed to broken down
     C                   IF        CDL007 = 'Y'
     C                                AND DDACTN = 'A'

      * Update Breakdown User Id with Last Breakdown User Id
     C                   EVAL      IKBUSR = IF_BUSR

      * Update The Original Maturity Date
     C                   IF        IKMATD < OLD_MATD
     C                             AND DDTYPE = 'TD'
     C                             OR IKMATD < OLD_MATD
     C                             AND DDTYPE = 'TI'
     C                   EVAL      IKOMDT = OLD_MATD
     C                   EVAL      IKPRIN = *BLANKS
     C                   ENDIF

     C                   ENDIF

      * Automatic Authorisation flag
     C                   IF        CAP051 = 'Y'
     C                   EVAL      IKAUTH = IF_AUTH
     C                   ENDIF

     C                   EVAL      TranStatus = 'S'

      /COPY WNCPYSRC,SDSECDC017

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************

     C     CallMsgHdl    BEGSR

      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors

     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax

     C                   IF        FldNameArr(Ix) <> *blanks

     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)

     C                   ELSE

     C                   LEAVE

     C                   ENDIF

     C                   ADD       1             Ix

     C                   ENDDO

     C                   RESET                   ReturnCode

     C                   MOVEL     DDDLNO        PTranID          20

     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    WLFOTranID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (6A, from caller)
     C                   PARM                    PTranID
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    InfData500
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages

     C                   EVAL      #MsgFile     = 'DRSMM'
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(3) = 'FTUSRMSG'                                  240474

      *  Set up the Module ID, used to make the Transaction number unique

     C                   EVAL      ModuleID = 'DL'
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access SAR details file to determine if
      ** Automatic Authorisation (MM Part) is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP051'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CAP051            1
     C                   ELSE
     C                   MOVEL     'N'           CAP051
     C                   ENDIF
      *
      ** Access SAR details file to determine if
      ** Deposit Breakdown Penalty is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CDL007            1
     C                   ELSE
     C                   MOVEL     'N'           CDL007
     C                   ENDIF
      *
      ** Access SAR details file to determine if
      ** CAC005 is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAC005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CAC005            1
     C                   ELSE
     C                   MOVEL     'N'           CAC005
     C                   ENDIF

      ** Set up the name of the server/database updater data queue.

     C                   EVAL      DtaQName = 'APREPODTQ'
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 900                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011

                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
                                                                                              247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMREPOC020

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CSC011
      * WrtInvLog - Write details to 24X7 log file                    *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
     C     WrtInvLog     BEGSR                                                                CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE  = WMsgType                                      CSC011
     C                   EVAL      PDealNo = DDDLNO                                           CSC011
     C                                                                                        CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = DDDLNO                                             CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE = 901                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
     C/COPY ZACPYSRC,PSSR_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
