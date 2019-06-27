     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                     MD026120
/*STD *  RPGSQLMOD                                                    *                     MD026120
/*EXI *  TEXT('Midas LE Facility input retrieve')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIPRTV - Facility Retrieve                                *
      *                                                               *
      *  Function:  This module retrieves a Facility from             *
      *             the database. As it does so, it validates the     *
      *             action code and facility reference                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. LUC123             Date 18Jun18               *
      *  Prev Amend No. MD026120           Date 13May14               *
      *                 MD024398           Date 11May14               *
      *                 MD000091           Date 09May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 AR788404           Date 21Jun11               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CLE056             Date 17Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17135           Date 24Mar08               *
      *                 246694             Date 13Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244314             Date 11Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185             Date 21Apr06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 241113             Date 13Jul06               *
      *                 240968             Date 10Jul06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 BUG8485            Date 14Sep05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CLE041             Date 15Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4555            Date 19Oct04               *
      *                 BUG3221            Date 20Oct04               *
      *                 BUG4253            Date 14Sep04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2086            Date 21Apr04               *
      *                 BUG1621            Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Oct02               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 18Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation (CSD025) to GL and LE *
      *           Use of core hook GLH00266                           *
      *           Addition of hook LUC123_007                         *
      *           Addition of hook LUC123_008                         *
      *           Addition of hook LUC123_009                         *
      *           Addition of hook LUC123_010                         *
      *           Addition of hook LUC123_011                         *
      *  MD026120 - Additional deps for GLC0720/740                   *
      *  MD024398 - API Performance Optimisation                      *
      *  MD000091 - Event Codes Substitution                          *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  AR788404 - Component LEC000030 failed. Amend program to      *
      *             prevent the system from reversing a facility      *
      *             linked to a retail account. (Child: AR788405)     *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00261                                 *
      *             WNCPYSRC,LEH00402                                 *
      *             WNCPYSRC,LEH00403                                 *
      *             WNCPYSRC,LEH00404                                 *
      *             WNCPYSRC,LEH00262                                 *
      *             WNCPYSRC,LEH00263                                 *
      *             WNCPYSRC,LEH00264                                 *
      *             WNCPYSRC,LEH00353                                 *
      *             WNCPYSRC,LEH00317                                 *
      *             WNCPYSRC,LEH00266                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CLE056 - Authorisation on Lending Transactions               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17135 - Do not allow reversal of facility if there's a    *
      *             collateral attached to it.                        *
      *  246694 - Allow reversal of CA Only if tranch are reversed.   *
      *         - Allow closure of CA if NO tranch is LIVE.           *
      *  244314 - If system value CLAuthSameORED = 'Y', then allow    *
      *           original input user to re-authorise a transaction   *
      *           that was previously authorised and has been amended *
      *           by a second user.                                   *
      *  CAP185 - MQ Series Interface                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  241113 - Allow entry of facility sequence number when        *
      *           inserting a facility if system value                *
      *           AllowEnterFctySeqNo is 'Y'                          *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if facility was amended after ORED             *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager.                               *
      *  BUG8485- Add Validation in FCLTY during Insert.              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSC024 - Open Month End                                      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4555 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs. Additional fix for BUG3760.          *
      *  BUG3221- Check for outstanding Manual Facility Utilisations  *
      *           and Facility Amendments before closing/reversing a  *
      *           facility (regardless of TRCA indicator).            *
      *           Do not allow reversal of Credit Agreement even if   *
      *           tranches have expired as they might be reactivated  *
      *           later.                                              *
      *  BUG4253- Misleading message if branch is blank               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2086 - Populate branch field on call to ZVACTBU           *
      *  BUG1621 - Validate users authority to branch in insert mode  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Midas Plus API development                          *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
     FFCLTY     IF   E           K DISK
     F                                     PREFIX(FC_)
     F                                     IGNORE(FCLTYHHF)
     FLEAGFCL0  IF   E           K DISK                                                       CLE041
     F                                     PREFIX(AGFC_)                                      CLE041
     F                                     IGNORE(FCLTYHHF)                                   CLE041
     F                                     RENAME(FCLTYFMF:AGFCLTFMF)                         CLE041
     F                                     RENAME(FCLTYFNF:AGFCLTFNF)                         CLE041
     F                                     RENAME(FCLTYZZF:AGFCLTZZF)                         CLE041
     FFCLTYL4   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFMF4)
     F                                     PREFIX(F3_)
      **  Facilities Requiring Authorisation
     FLEFCLTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFMF1)
     F                                     PREFIX(F1_)
      **  Funding Participant Details file
     FLEFCLTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL2)
     F                                     PREFIX(F2_)
      **  Facilities Live or Expired
     FLEFCLTL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFMF7)
     F                                     PREFIX(F7_)
      ** Aggregate Facilities Live or Expired                                                 CLE041
     FLEAGFCL1  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     RENAME(FCLTYFMF:AGFCLTF1F)                         CLE041
     F                                     PREFIX(AGF1_)                                      CLE041
      **  Credit Agreement File
     FLEFCLTL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFLF9)
     F                                     PREFIX(F9_)
      **  Customer/Facility/Loan Cross-Reference file
     FLEREF     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LE_)

      **  Loan Master file
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F                                     IGNORE(CLOANCKF)
     F                                     PREFIX(CL_)
      **  Live Utilisation Retrieval Index
     FLEMNFUL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L6_)
      **  Fees Master file
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
      **  Collateral                                                                        BUG17135
     FGLCOLLL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG17135

      **  Account master file                                                               AR788404
     F***GLACNTL5  IF   E           K DISK    INFSR(*PSSR)                         AR788404 MD026120
     F**********                           PREFIX(AC_)                             AR788404 MD026120
                                                                                            AR788404
     FLEFCAML3  IF   E           K DISK
     F                                     RENAME(LEFCAMPF:LEFCAMDF3)
     F                                     PREFIX(L3_)

     FLEAGAML3  IF   E           K DISK                                                       CLE041
     F                                     RENAME(LEFCAMPF:LEAGAMDF3)                         CLE041
     F                                     PREFIX(AGL3_)                                      CLE041
                                                                                              CLE041
     FLEFCAML6  IF   E           K DISK
     F                                     RENAME(LEFCAMPF:LEFCAMDF6)
     F                                     PREFIX(L6_)
     FSDCWHTL1  IF   E           K DISK                                                     BUG4555
      ** Compliance Watch Hit List by Function Type/Identifier/Branch                       BUG4555
      *                                                                                     BUG4555
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
     F/COPY WNCPYSRC,LEH00261
                                                                                              CAP185
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

      ** Include the LE standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+

     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
     D CLAuthORED      C                   Const('CLAuthORED')                                240968
     D CLAuthSMDT      C                   Const('CLAuthSameORED')                            244314
     D PSysVal3        C                   CONST('AllowEnterFctySeqNo')                       241113
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** Customer lending Details

     D SDFACT        E DS                  EXTNAME(SDFACTPD)
      **   FACILITY TYPE
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **   CUSTOMER
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG4555
      ***  SAR Details                                                                      BUG4555
      *                                                                                     BUG4555
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                   BUG4555
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                   BUG4555
      *                                                                                     BUG4555
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                BUG4555
      ** Midas Functions for Watch List Checking Details File                               BUG4555
      *                                                                                     BUG4555
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                BUG4555
      ** Midas SD Watch List Configuration Data File                                        BUG4555
      *                                                                                     BUG4555
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D DSSDY         E DS                  EXTNAME(DSSDY)
     D/COPY WNCPYSRC,LUC123_011                                                               LUC123

     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FC_)
      ** Facility FM in File Format
                                                                                              CLE041
     D AGFacmFilFmt  E DS                  EXTNAME(LEAGFMPD)                                  CLE041
     D                                     PREFIX(AGFC_)                                      CLE041
      ** Aggregate Facility FM in File Format                                                 CLE041

     D FacnFilFmt    E DS                  EXTNAME(FCLTYFN)
     D                                     PREFIX(FN_)
      ** Facility FN in File Format
                                                                                              CLE041
     D AGFacnFilFmt  E DS                  EXTNAME(LEAGFNPD)                                  CLE041
     D                                     PREFIX(AGFN_)                                      CLE041
      ** Aggregate Facility FN in File Format                                                 CLE041

      ** Key
     D KCNUM           S                   LIKE(FC_CNUM)
     D K2CNUM          S                   LIKE(FC_CNUM)
     D K3CNUM          S                   LIKE(FC_CNUM)
     D K9CNUM          S                   LIKE(FC_CNUM)                                    AR788404
     D K0CANM          S                   LIKE(FC_CNUM)
     D KFACT           S                   LIKE(FC_FACT)
     D K2FACT          S                   LIKE(FC_FACT)
     D K3FACT          S                   LIKE(FC_FACT)
     D K9FACT          S                   LIKE(FC_FACT)                                    AR788404
     D K0CAFT          S                   LIKE(FC_FACT)
     D KFCNO           S                   LIKE(FC_FCNO)
     D K2FCNO          S                   LIKE(FC_FCNO)
     D K3FCNO          S                   LIKE(FC_FCNO)
     D K9FCNO          S                   LIKE(FC_FCNO)                                    AR788404
     D K0CAFN          S                   LIKE(FC_FCNO)
     D KRCTP           S                   LIKE(FC_RCTP)

      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
                                                                                              CLE041
     D WAggregate      S              1A                                                      CLE041
     D CLE025          S              1A                                                      CLE041
      ** SAR Indicators (on/off)                                                            BUG4555
     D CCF001          S              1                                                     BUG4555
     D CSC011          S              1                                                     BUG4555
     D CSD015          S              1                                                     BUG4555
      *                                                                                     BUG4555
     D WFuncType       S              8                                                     BUG4555
     D WIdntifier      S             40                                                     BUG4555
     D WBranch         S              3                                                     BUG4555
                                                                                              CSC024
     D PRetCode        S              7A                                                      CSC024
     D P@OP01          S             20A                                                      CSC024
     D P@VL01          S            200A                                                      CSC024
     D P@OP02          S             20A                                                      CSC024
     D P@VL02          S            200A                                                      CSC024
     D P@OP03          S             20A                                                      CSC024
     D P@VL03          S            200A                                                      CSC024
     D P@OP04          S             20A                                                      CSC024
     D P@VL04          S            200A                                                      CSC024
     D P@OP05          S             20A                                                      CSC024
     D P@VL05          S            200A                                                      CSC024
     D P@OP06          S             20A                                                      CSC024
     D P@VL06          S            200A                                                      CSC024
     D P@OP07          S             20A                                                      CSC024
     D P@VL07          S            200A                                                      CSC024
     D P@OP08          S             20A                                                      CSC024
     D P@VL08          S            200A                                                      CSC024
     D P@OP09          S             20A                                                      CSC024
     D P@VL09          S            200A                                                      CSC024
     D P@OP10          S             20A                                                      CSC024
     D P@VL10          S            200A                                                      CSC024
                                                                                              CSC024
     D*CSC024***       S              1A                                               CSC024 CSC054
     D*WOMEInd**       S              1A                                               CSC024 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
                                                                                              CSC024
     D CAP086          S              1A                                                      CAP086
     D CLE056          S              1A                                                      CLE056
     D CountN          S              3  0                                                  MD026120
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
     IFCLTYFNF
     I              TNLU                        TNLUX
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *inzsr is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+

      * INITIALISATION
     C                   EXSR      INIT

      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUSER = USER                                CAP084
     C                   ENDIF                                                  CAP084
                                                                                              CAP086
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'  AND                                          CAP086
     C                             ModeofOp = *BLANKS                                         CAP086
     C                   EVAL      F1_AUTH = *BLANKS                                          CAP086
     C                   ENDIF                                                                CAP086

      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT

      **  Carry out no further validation if errors have occurred.
     C     DDACTNOK      IFEQ      'N'
     C                   RETURN
     C                   END
     C                   END

      * VALIDATE Action code & Facility reference
     C                   EXSR      VAL

      **  Carry out no further validation if errors have occurred.
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C     DDFACTOK      OREQ      'N'
     C     DDFCNOOK      OREQ      'N'
     C                   RETURN
     C                   END

      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'E'
     C                   EXSR      VALACE
     C                   END

      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'X'
     C                   EXSR      VALACX
     C                   END

      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'A'
     C                   EXSR      VALACA
     C                   END

      *  *---------------------------------------*
      *  * Validation for Action Code 'R' or 'C' *
      *  *---------------------------------------*
     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'C'
     C                   EXSR      VALACR
     C                   END

      **  Carry out no further validation if errors occurred.
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C     DDFACTOK      OREQ      'N'
     C     DDFCNOOK      OREQ      'N'
     C                   RETURN
     C                   END

      *  *-----------------------------------------------*
      **  Validate Authority
      *  *-----------------------------------------------*
      *
     C     ModeofOp      IFNE      '*FRONT'
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      VLDAUT
     C                   ENDIF

     C     DDACTNOK      IFNE      'N'
     C     DDCSSNOK      ANDNE     'N'
     C     DDFACTOK      ANDNE     'N'
     C     DDFCNOOK      ANDNE     'N'

     C     DDACTN        IFNE      'I'
     C                   MOVE      'A'           KRCTP
     C                   MOVEL     DDCSSN        KCNUM
     C                   MOVE      DDFACT        KFACT
     C                   MOVE      DDFCNO        KFCNO
                                                                                              CLE041
     C                   IF        WAggregate = 'Y'                                           CLE041
     C     CHKFAC        CHAIN     LEAGFCL0                           80                      CLE041
     C                   EVAL      FacmFilFmt = AGFacmFilFmt                                  CLE041
     C                   MOVE      'B'           KRCTP                                        CLE041
     C     CHKFAC        CHAIN     LEAGFCL0                           80                      CLE041
     C***                EVAL      FacmFilFmt = AGFacmFilFmt                                  CLE041
     C                   EXSR      SRMovAGFld                                                 CLE041
     C                   EVAL      FacnFilFmt = AGFacnFilFmt                                  CLE041
     C                   ELSE                                                                 CLE041
                                                                                              CLE041
     C     CHKFAC        CHAIN     FCLTY                              80
     C                   MOVE      'B'           KRCTP
     C     CHKFAC        CHAIN     FCLTY                              80
     C                   EXSR      MOVFLD
     C                   ENDIF                                                                CLE041
      *
     C                   ELSE
     C                   MOVE      *BLANKS       WWRECI
     C                   ENDIF
     C
      **  If Facility is either closed or expired, check for records
      **  in PF/LEFCAMPD if it has been reactivated.
     C                   MOVE      *OFF          WREAC             1
     C     WWRECI        IFEQ      'C'
     C     WWRECI        OREQ      'E'
     C                   MOVEL     DDCSSN        K3CNUM
     C                   MOVE      DDFACT        K3FACT
     C                   MOVE      DDFCNO        K3FCNO
     C                   EXSR      SRCKFR
     C                   ENDIF
     C                   ENDIF

      * Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR

      * ERROR IF ACTION CODE IS NOT 'I', 'A, 'R', 'C' or 'X'
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0100'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END

      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END

      * ACCESS FCLTY WITH FRONT OFFICE TRANSACTION ID
     C                   MOVEL     FOTRID        FOTRID15         15

     C     FOTRID15      CHAIN     FCLTYL4                            99

      * IF INSERT
     C     DDACTN        IFEQ      'I'

      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID15      MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID15))                             MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID15)                  MD000091
     C                   GOTO      EVFRNT
     C                   END

     C                   ELSE

      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID15      MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID15))                             MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID15)                  MD000091
     C                   GOTO      EVFRNT
     C                   END

      * IF NOT INSERT, UPDATE MIDAS FACILITY REFERENCE
     C                   MOVEL     F3_CNUM       DDCSSN
     C                   MOVEL     F3_FACT       DDFACT
     C                   MOVEL     F3_FCNO       DDFCNO

     C                   END

     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND FACILITY REFERENCE
      *****************************************************************
     C     VAL           BEGSR

      **  Check that the action code is valid; if authorisations are
      **  not in the system, then action code X is not allowed.

     C     BPFAAU        IFEQ      'N'
     C     DDACTN        ANDEQ     'X'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0002'     MsgIdArr(Ix)
     C                   END

     C     DDACTN        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0001'     MsgIdArr(Ix)
     C                   END
     C     DDACTN        IFEQ      *BLANK
     C                   MOVEL     'E'           DDACTN
     C                   END

      ** Customer number must be defined

     C     DDCSSN        IFEQ      *BLANKS
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0214'     MsgIdArr(Ix)

     C                   ELSE

      ** Customer number must refer to a valid customer

     C/COPY WNCPYSRC,LUC123_009                                                               LUC123
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DDCSSN        @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C/COPY WNCPYSRC,LUC123_010                                                               LUC123
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0214'     MsgIdArr(Ix)
     C                   ELSE

     C/COPY WNCPYSRC,LUC123_007                                                               LUC123
     C                   MOVEL     *BLANK        DDCSSN
     C                   MOVEL     BBCUST        DDCSSN
     C/COPY WNCPYSRC,LUC123_008                                                               LUC123
     C                   ENDIF

     C                   ENDIF

      ** Facility type must be defined

     C     DDFACT        IFEQ      *BLANKS
     C                   MOVE      'N'           DDFACTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0004'     MsgIdArr(Ix)

     C                   ELSE

     C                   CALLB     'AOFACTR0'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    DDFACT
     C     SDFACT        PARM      SDFACT        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDFACTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0004'     MsgIdArr(Ix)
     C                   ENDIF

     C                   ENDIF

      **  Validate Facility Seq No.
     C     DDACTN        IFNE      'I'
     C     ALWFCNO       OREQ      'Y'                                                        241113
     C     DDACTN        ANDEQ     'I'                                                        241113
     C     DDFCNO        ANDNE     *BLANKS                                                    241113
     C                   TESTN                   DDFCNO               19
     C     *IN19         IFEQ      *OFF
     C     DDFCNO        OREQ      '00'                                                       241113
     C                   MOVE      'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFCNO    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0005'     MsgIdArr(Ix)
     C                   ENDIF
      *  For insert this field should not be entered
     C                   ELSE
     C     DDFCNO        IFNE      *BLANKS
                                                                                              CSC024
      ***Allow*entry*for*Facility*Seq.*No.*for*Insert*if*CSC024*is                     CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for Facility Seq. No. for Insert if CSC054 is                            CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
     C                   MOVE      'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFCNO    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0054'     MsgIdArr(Ix)
     C                   ENDIF                                                                CSC024
     C                   ENDIF
     C                   ENDIF                                                                241113

      ** For INSERT determine facility sequence number

     C                   MOVE      *BLANKS       FCTYDET           1                          241113
     C     DDACTN        IFEQ      'I'                                                        241113
     C     DDFCNOOK      IFNE      'N'
                                                                                              CSC024
      ***Bypass*generate*facility*Seq.*No.*for*insert*if*CSC024*is                     CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Bypass generate facility Seq. No. for insert if CSC054 is                            CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     ALWFCNO       ANDEQ     'N'                                                        241113
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
     C     ALWFCNO       ANDEQ     'N'                                                        241113
     C     DDFCNO        OREQ      *BLANKS                                                    CSC024
     C                   EXSR      DETFCNO

     C     DDFCNOOK      IFEQ      'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDFCNO    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0110'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      K4FCNO        DDFCNO
     C                   MOVE      'Y'           FCTYDET                                      241113
     C                   ENDIF

     C                   ENDIF                                                                CSC024
                                                                                             BUG8485
     c**********         IF        CSC024  = 'Y' AND                                  BUG8485 CSC054
     c**********                   WOMEInd = 'Y'                                      BUG8485 241113
     c**********                   WOMEInd = 'Y' Or                                    241113 CSC054
     C                   IF        CSC054  = 'Y' AND                                  BUG8485 CSC054
     C                             WPEAInd = 'Y' Or                                    241113 CSC054
     C                             ALWFCNO = 'Y' AND DDACTN = 'I' AND                         241113
     C                             DDFCNO <> *BLANKS AND DDFCNOOK <> 'N' AND                  241113
     C                             FCTYDET <> 'Y'                                             241113
                                                                                             BUG8485
     C                   MOVEL     DDCSSN        KCNUM                                       BUG8485
     C                   MOVE      DDFACT        KFACT                                       BUG8485
     C                   MOVE      DDFCNO        KFCNO                                       BUG8485
     C                   MOVE      'A'           KRCTP                                       BUG8485
                                                                                             BUG8485
     C     CHKFAC        CHAIN     FCLTY                                                     BUG8485
     C                   IF        %FOUND(FCLTY)                                             BUG8485
     C                   EVAL      DDFCNOOK = 'N'                                            BUG8485
     C                   EVAL      Ix = Ix + 1                                               BUG8485
     C                   EVAL      FldNameArr(Ix) = 'DDCSSN'                                 BUG8485
     C                   EVAL      MsgIdArr(Ix)   = 'LEF0456'                                BUG8485
     C                   ENDIF                                                               BUG8485
     C                   ENDIF                                                               BUG8485
                                                                                             BUG8485
     C                   ENDIF
     C                   ENDIF

     C                   MOVEL     DDCSSN        KCNUM
     C                   MOVE      DDFACT        KFACT
     C                   MOVE      DDFCNO        KFCNO
     C                   MOVE      'A'           KRCTP

     C     DDACTN        IFNE      'I'

     C**  If there is no valid record on FCLTY, it is an error.
     C     CHKFAC        CHAIN     FCLTY                              65
     C/COPY WNCPYSRC,LEH00402
                                                                                              CLE041
      **  If not found, check if existing in aggregates file LEAGFCL0                         CLE041
                                                                                              CLE041
     C                   IF        CLE025='Y' AND *IN65                                       CLE041
     C     CHKFAC        CHAIN     LEAGFCL0                           65                      CLE041
     C                   IF        NOT(*IN65)                                                 CLE041
     C                   EVAL      FacmFilFmt = AGFacmFilFmt                                  CLE041
     C                   EVAL      WAggregate = 'Y'                                           CLE041
     C/COPY WNCPYSRC,LEH00403
     C                   ENDIF                                                                CLE041
     C                   ENDIF                                                                CLE041
      *
      * Must reference a record on FCLTY
      *
     C     *IN65         IFEQ      '1'
     C                   MOVEL     'N'           DDCSSNOK
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACR'      FldNameArr(Ix)
     C                   MOVEL     'LEF0006'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C                   MOVEL     FC_RECI       WWRECI            1
     C     DDBRCA        IFEQ      *BLANK
     C                   MOVEL     FC_BRCA       DDBRCA
     C                   ENDIF
     C/COPY WNCPYSRC,LEH00404
     C                   ENDIF

     C/COPY WNCPYSRC,LEH00262
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR

     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - VALIDATION OF ACTION CODE 'X'
      *****************************************************************
     C     VALACX        BEGSR

      **  Facility must have status 'C' or 'R' for action 'X'
     C     FC_FSTS       IFNE      'C'
     C     FC_FSTS       ANDNE     'R'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0007'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   ENDIF

      *   Authorising user should not be the same as the Insert or
      *   Amendment user
      ***  Unless CLE056 is enabled and not day of input and not last amender                 CLE056
      ** Determine whether program is running interactively or in batch                       CAP185
      **  ( 0 = batch 1 = interactive)                                                        CAP185
      *                                                                                       CAP185
     C                   CALLB     'ZARTVJOBA'                                                CAP185
     C                   PARM                    @Return           6                          CAP185
     C                   PARM                    @Type             1                          CAP185
      *                                                                                       CAP185
     C     CAP185        IFEQ      'N'                                                        CAP185
     C     CAP185        OREQ      'Y'                                                        CAP185
     C     @AUTHO        ANDEQ     'N'                                                        CAP185
     C     CAP185        OREQ      'Y'                                                        CAP185
     C     @AUTHO        ANDEQ     'Y'                                                        CAP185
     C     @TYPE         ANDEQ     '1'                                                        CAP185
      *                                                                                       CAP185
      * If system value CLAuthORED = 'Y' and last amend date is later than                    240968
      * original entry date then allow authorise user to be same as original insert user      240968
      *                                                                                       240968
      * Or if CLAuthSameORED = 'Y' then allow authorise user to be same as original           244314
      * insert user as long as the last change type was an amendment and the                  244314
      * current status of transaction is 'Reauthorise Required'                               244314
      *                                                                                       244314
     C     ATHORED       IFEQ      'Y'                                                        240968
     C     ATHOSMDT      ANDNE     'Y'                                                        244314
     C     FC_LCD        ANDGT     FC_ORED                                                    240968
     C     FC_CHTP       ANDEQ     'A'                                                        240968
     C     BJRDNB        ANDGT     FC_ORED                                                    240968
     C     ATHOSMDT      OREQ      'Y'                                                        244314
     C     FC_CHTP       ANDEQ     'A'                                                        244314
     C     FC_FSTS       ANDEQ     'R'                                                        244314
      *                                                                                       240968
     C     PSUser        IFEQ      FC_AUSR                                                    240968
     C                   MOVEL     'N'           DDACTNOK                                     240968
     C                   ADD       1             Ix                                           240968
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               240968
     C                   MOVEL     'LEF0112'     MsgIdArr(Ix)                                 240968
     C                   GOTO      EVALAX                                                     240968
     C                   ENDIF                                                                240968
      *                                                                                       240968
     C                   ELSE                                                                 240968
     C     PSUSER        IFEQ      FC_IUSR
     C     PSUSER        OREQ      FC_AUSR
      *                                                                                       CLE056
     C                   If        (CLE056 = 'N') or                                          CLE056
     C                             (CLE056 = 'Y' and FC_ORED = BJRDNB                         CLE056
     C                                           and PSUser = FC_IUSR) or                     CLE056
     C                             (CLE056 = 'Y' and FC_LCD = BJRDNB and                      CLE056
     C                              FC_CHTP = 'A' and PSUser = FC_AUSR)                       CLE056
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0112'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   ENDIF                                                                CLE056
     C                   ENDIF
     C                   ENDIF                                                                240968
     C                   ENDIF                                                                CAP185

      **  Check if facility is a tranche.  If so, authorisation is not
      **  allowed unless the credit agreement facility is already
      **  authorised

     C     CLE025        IFEQ      'N'                                                        CLE041
     C                   MOVEL     'FCLTY'       W#FILE
     C                   EXSR      CHKAUT
     C                   ENDIF                                                                CLE041

      *                                                                                     BUG4555
      ** If Compliance Watch Enhancement (CSD015) is installed, Watch                       BUG4555
      ** List Checking Applied and Authorization is allowed....                             BUG4555
      ** If 24x7 Midas Availability is not installed or it is installed and                 BUG4555
      ** in the main system...                                                              BUG4555
      ** Determine  if there is a pending case.                                             BUG4555
      ** If there no pending case or case has been temporarily released,                    BUG4555
      ** continue normal processing.  Otherwise send error message.                         BUG4555
      *                                                                                     BUG4555
     C                   IF        (CSD015 = 'Y') AND                                       BUG4555
     C                             (W1EWLC = 'Y')                                           BUG4555
      *                                                                                     BUG4555
     C                   IF        (CSC011 = 'N') OR                                        BUG4555
     C                             (S1MAIN = LIBR)                                          BUG4555
     C                   EVAL      WFuncType = 'FCLTYFM'                                    BUG4555
     C                   MOVEL     '/'           Wrk3              3                        BUG4555
     C                   MOVE      FC_FCNO       Wrk3                                       BUG4555
     C                   MOVEL     FC_FACT       FCNbr             6                        BUG4555
     C                   MOVE      Wrk3          FCNbr                                      BUG4555
     C                   MOVEL     FC_CNUM       FIdentfr         13                        BUG4555
     C                   MOVE      FCNbr         FIdentfr                                   BUG4555
     C                   EVAL      WIdntifier = FIdentfr                                    BUG4555
     C                   EVAL      WBranch = FC_BRCA                                        BUG4555
      *                                                                                     BUG4555
     C     KCwFld        CHAIN     SDCWHTL1                                                 BUG4555
     C                   IF        %FOUND(SDCWHTL1) AND                                     BUG4555
     C                             (W3TREL <> 'Y')                                          BUG4555
     C                   EVAL      Ix = Ix + 1                                              BUG4555
     C                   MOVEL     'FIdentfr'    FldNameArr(Ix)                             BUG4555
     C                   EVAL      MsgIdArr(Ix) = 'LEL0564'                                 BUG4555
     C                   GOTO      EVALAX                                                   BUG4555
     C                   ENDIF                                                              BUG4555
     C                   ENDIF                                                              BUG4555
     C                   ENDIF                                                              BUG4555
     C     EVALAX        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR

     C**  If there is no valid record on FCLTY, it is an error.
     C                   MOVE      FC_CNUM       K2CNUM
     C                   MOVE      FC_FACT       K2FACT
     C                   MOVE      FC_FCNO       K2FCNO

     C     WAggregate    IFEQ      'Y'                                                        CLE041
     C     K#KY02        CHAIN     LEAGFCL1                           65                      CLE041
     C                   ELSE                                                                 CLE041
     C     K#KY02        CHAIN     LEFCLTL7                           65
     C                   ENDIF                                                                CLE041
      *
      * Must reference a record on Fclty file
      *
     C     *IN65         IFEQ      '1'
     C                   MOVEL     'N'           DDCSSNOK
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACR'      FldNameArr(Ix)
     C                   MOVEL     'LEF0315'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END

      * Amendments are only allowed on live records
     C     F7_RECI       IFNE      'D'
     C     WAggregate    ANDNE     'Y'                                                        CLE041
                                                                                              CLE041
     C     AGF1_RECI     ORNE      'D'                                                        CLE041
     C     WAggregate    ANDEQ     'Y'                                                        CLE041
                                                                                              CLE041
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0227'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ENDIF

     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACR - VALIDATION OF ACTION CODE 'R'
      *****************************************************************
     C     VALACR        BEGSR

      **  Funding or internal facility cannot be closed, reversed
     C*****FC_PRTR       IFEQ      'P'                                                        CLE106
     C*****FC_PRTR       OREQ      'I'                                                        CLE106
     C***********        MOVEL     'N'           DDACTNOK                                     CLE106
     C***********        ADD       1             Ix                                           CLE106
     C***********        MOVEL     'DDACTN'      FldNameArr(Ix)                               CLE106
     C***********        MOVEL     'LEF0055'     MsgIdArr(Ix)                                 CLE106
     C***********        GOTO      EVALAR                                                     CLE106
     C***********        ENDIF                                                                CLE106

      **  Reverse
     C     FC_RECI       IFNE      'D'
     C     DDACTN        ANDEQ     'R'
     C     DDACTN        OREQ      'C'
     C     FC_RECI       ANDNE     'D'
     C     FC_RECI       ANDNE     'E'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0085'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF
                                                                                              CLE041
      ** Bypass other validations if aggregate                                                CLE041
                                                                                              CLE041
     C     WAggregate    IFEQ      'Y'                                                        CLE041
     C                   GOTO      EVALAR                                                     CLE041
     C                   ENDIF                                                                CLE041
      *
      ** Check for outstanding loans.
     C                   Z-ADD     FC_DTEX       ZDAYNO            5 0
      *
     C                   EXSR      CHKOTS
      *
     C     W#ERR4        IFEQ      'Y'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0086'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF
     C*
      **  Check if a loan, manual facility, or facility amendment is
      ****attached*to*one*of*the*credit*agreement's*tranches                                 BUG3221
      **  attached this facility                                                             BUG3221
     C*****FC_TRCA       IFEQ      'TR'                                                      BUG3221
     C                   EXSR      CHKCRE
      *
     C     W#ERR5        IFEQ      'Y'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0289'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF
      *
     C     W#ERR6        IFEQ      'Y'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0290'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF
      *
     C     W#ERR7        IFEQ      'Y'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0291'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF

     C**********         ENDIF                                                               BUG3221
      *
      **  Check if there are tranches referring to a credit agreement.
      **  If so, credit agreement cannot be deleted
     C                   EXSR      CHKTRA

     C     W#ERR4        IFEQ      'Y'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0293'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF

      *  TO CHECK FOR OUTSTANDING FEES FOR FCLTY RECORD, IF FOUND
      *  THEN THE FCLTY RECORD CANNOT BE REVERSED.
     C                   EXSR      CHKFEE

     C     W#ERR4        IFEQ      'Y'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0087'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF
                                                                                            AR788404
      ** Check if facility is attached to a live account in                                 AR788404
      ** ACCNTAB, if found do not allow reversal of facility                                AR788404
                                                                                            AR788404
     C                   EXSR      CHKACT                                                   AR788404
     C     W#ERR4        IFEQ      'Y'                                                      AR788404
     C                   MOVEL     'N'           DDACTNOK                                   AR788404
     C                   ADD       1             Ix                                         AR788404
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR788404
     C                   MOVEL     '5045477'     MsgIdArr(Ix)                               AR788404
     C                   GOTO      EVALAR                                                   AR788404
     C                   ENDIF                                                              AR788404
                                                                                            AR788404
      *                                                                                     BUG17135
      *  To check for outstanding collaterals for fclty record, if found                    BUG17135
      *  then the fclty record cannot be reversed.                                          BUG17135
     C                   EXSR      CHKCOL                                                   BUG17135
                                                                                            BUG17135
     C     W#ERR4        IFEQ      'Y'                                                      BUG17135
     C                   MOVEL     'N'           DDACTNOK                                   BUG17135
     C                   ADD       1             Ix                                         BUG17135
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             BUG17135
     C                   MOVEL     'LER2025'     MsgIdArr(Ix)                               BUG17135
     C                   GOTO      EVALAR                                                   BUG17135
     C                   ENDIF                                                              BUG17135
                                                                                            BUG17135
      *
      ** Check for funding participants
     C     ModeOfop      IFNE      '*FRONT'
     C                   MOVE      DDBRCA        K4BRCA            3
     C**********         MOVE      DDCSSN        K4CNUM            6 0                        CSD027
     C                   MOVE      DDCSSN        K4CNUM            6                          CSD027
     C                   MOVE      DDFACT        K4FACT            3 0
     C                   MOVE      DDFCNO        K4FCNO            2 0
     C     K#KY04        CHAIN(N)  LEFCLTL2                           80
     C     *IN80         DOWEQ     *OFF
     C     F2_RECI       IFEQ      'D'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0109'     MsgIdArr(Ix)
     C                   GOTO      EVALAR
     C                   ENDIF
     C     K#KY04        READE(N)  LEFCLTL2                               80
     C                   ENDDO
     C                   ENDIF

     C     EVALAR        ENDSR
      *****************************************************************
      /EJECT
      ***********************************************************
      *  CHKAUT :
      ***********************************************************
     C     CHKAUT        BEGSR
      *
     C     FC_TRCA       IFEQ      'TR'
      *
     C                   MOVE      FC_CANM       K2CNUM
     C                   MOVE      FC_CAFT       K2FACT
     C                   MOVE      FC_CAFN       K2FCNO
      *
     C     K#KY02        CHAIN     LEFCLTL1                           80
     C     *IN80         IFEQ      '0'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0294'     MsgIdArr(Ix)
     C                   GOTO      ECHK
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   SELECT
     C     W#FILE        WHENEQ    'FCLTY'
     C     CHKFAC        CHAIN     FCLTY                              80
     C***  W#FILE        WHENEQ    'LEFCLTL7'
     C***  K#KY01        CHAIN     LEFCLTL7                           80
     C                   ENDSL
      *
     C                   MOVE      *BLANKS       W#FILE           10

     C     ECHK          ENDSR
      *****************************************************************
      /EJECT
      ***********************************************************
      *  CHKOTS :
      ***********************************************************
     C     CHKOTS        BEGSR
      *
     C                   MOVE      'N'           W#ERR4            1
      *
      **  Check to see if new expiry date is less than any of the
      **  customer outstanding loan expiry dates.
     C**********         Z-ADD     FC_CNUM       K2CNUM                                       CSD027
     C                   EVAL      K2CNUM = FC_CNUM                                           CSD027
     C                   Z-ADD     FC_FACT       K2FACT
     C                   Z-ADD     FC_FCNO       K2FCNO
      *
     C     K#KY02        SETLL     LEREF
     C     K#KY02        READE     LEREF                                  80
      *
     C     *IN80         DOWEQ     *OFF
      *
     C     LE_RECI       IFEQ      'D'
     C**********         Z-ADD     LE_LNNO       K5LNRF            6 0                        CLE148
     C                   MOVEL     LE_LNNO       K5LNRF            6                          CLE148
     C                   MOVE      'A'           K5RCTP            1
     C     K#KY05        CHAIN     CLOAN                              80
      *
     C     ZDAYNO        IFLT      CL_MDAT
     C                   MOVE      'Y'           W#ERR4
     C                   LEAVE
     C                   ENDIF

     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'C'
     C     CL_MDAT       IFEQ      0
     C     CL_RECI       OREQ      'D'
     C     CL_RECI       OREQ      'M'
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      'Y'           W#ERR4
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     K#KY02        READE     LEREF                                  80
      *
     C                   ENDDO
      *
     C                   ENDSR
      ***********************************************************
      /EJECT
      ***********************************************************
      *  CHKCRE :
      ***********************************************************
     C     CHKCRE        BEGSR
      *
     C                   MOVE      'N'           W#ERR5            1
     C                   MOVE      'N'           W#ERR6            1
     C                   MOVE      'N'           W#ERR7            1
      *                                                                                      BUG3221
     C     FC_TRCA       IFNE      'CA'                                                      BUG3221
      *
      **  Check to see if new expiry date is less than any of the
      **  customer outstanding loan expiry dates.
     C**********         Z-ADD     FC_CNUM       K2CNUM                                       CSD027
     C                   EVAL      K2CNUM = FC_CNUM                                           CSD027
     C                   Z-ADD     FC_FACT       K2FACT
     C                   Z-ADD     FC_FCNO       K2FCNO
      *
     C     K#KY02        SETLL     LEREF
     C     K#KY02        READE     LEREF                                  80
      *
     C     *IN80         DOWEQ     '0'
      *
     C     LE_RECI       IFEQ      'D'
     C**********         Z-ADD     LE_LNNO       K5LNRF                                       CLE148
     C                   MOVEL     LE_LNNO       K5LNRF                                       CLE148
     C                   MOVE      'A'           K5RCTP
     C     K#KY05        CHAIN     CLOAN                              80
      *
     C     ZDAYNO        IFLT      CL_MDAT
     C                   MOVE      'Y'           W#ERR5
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     K#KY02        READE     LEREF                                  80
      *
     C                   ENDDO
      *
      ****Check*if*Manual*Fac.*is*attached*to*credit*agreement's*tranche                     BUG3221
      **  Check if Manual Fac. is attached to a facility                                     BUG3221
      *
     C     K#KY02        CHAIN     LEMNFUL6                           80
     C     *IN80         IFEQ      '0'
     C                   MOVE      'Y'           W#ERR6
     C                   ENDIF
     C                   ENDIF                                                               BUG3221
      *
      ****Check*if*Facility*Amend.*is*attached*to*CA's*tranche                               BUG3221
      **  Check if a Facility Amendment is attached to this facility                         BUG3221
      *
     C*****K#KY02        CHAIN     LEFCAML6                           80                     BUG3221
     C     K#KY02        CHAIN(N)  LEFCAML6                           80                     BUG3221
     C     *IN80         IFEQ      '0'
     C                   MOVE      'Y'           W#ERR7
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ***********************************************************
      *  CHKTRA :
      ***********************************************************
     C     CHKTRA        BEGSR
      *
     C                   MOVE      'N'           W#ERR4
      *
     C     FC_TRCA       IFEQ      'CA'
      *
     C**********         Z-ADD     FC_CNUM       K0CANM                                       CSD027
     C                   EVAL      K0CANM = FC_CNUM                                           CSD027
     C                   Z-ADD     FC_FACT       K0CAFT
     C                   Z-ADD     FC_FCNO       K0CAFN
      *
      ** Ensure record is not locked by chain.                                               BUG3221
      *                                                                                      BUG3221
     C*****K#KY10        CHAIN     LEFCLTL9                           80                     BUG3221
     C     K#KY10        CHAIN(N)  LEFCLTL9                           80                     BUG3221
      *
     C                   If        (DDACTN='R')                                               246694
      *                                                                                       246694
      ** Case1: Reversal (Allow only if all tranches are already reversed)                    246694
     C                   Dow       (*IN80=*OFF) And (W#ERR4='N')                              246694
     C                   If        (F9_RECI<>'R')                                             246694
     C                   Eval      W#ERR4 = 'Y'                                               246694
     C                   Else                                                                 246694
     C     K#KY10        READE(N)  LEFCLTL9                               80                  246694
     C                   Endif                                                                246694
     C                   Enddo                                                                246694
     C                   Else                                                                 246694
      *                                                                                       246694
      ** Case2: Closure (Allow except when live tranches attached)                            246694
     C                   Dow       (*IN80=*OFF) And (W#ERR4='N')                              246694
     C                   If        (F9_RECI='D')                                              246694
     C                   Eval      W#ERR4 = 'Y'                                               246694
     C                   Else                                                                 246694
     C     K#KY10        READE(N)  LEFCLTL9                               80                  246694
     C                   Endif                                                                246694
     C                   Enddo                                                                246694
     C                   Endif                                                                246694
      *                                                                                       246694
     C******IN80****     IFEQ      '0'                                                        246694
      **********                                                                              246694
      ***AND*record*found*is*live                                                            BUG3221
     C*****F9_RECI       ANDEQ     'D'                                                       BUG3221
     C**********         MOVE      'Y'           W#ERR4                                       246694
     C**********         ENDIF                                                                246694
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ***********************************************************
      *  CHKFEE :
      ***********************************************************
     C     CHKFEE        BEGSR
      *
     C                   MOVE      'N'           W#ERR4
     C**********         Z-ADD     FC_CNUM       K7CNUM            6 0                        CSD027
     C                   MOVE      FC_CNUM       K7CNUM            6                          CSD027
     C                   MOVEL     FC_FACT       K7FCTY            5 0
     C                   MOVE      FC_FCNO       K7FCTY
      *
     C     K#KY07        SETLL     LEFEEDL1
     C     K#KY07        READE     LEFEEDL1                               80
      *
     C     *IN80         DOWEQ     *OFF
      *
      **  If outstanding fees are found (FERECI = 'D') the facility
      **  cannot be reversed.
      *
     C     FERECI        IFEQ      'D'
     C                   MOVE      'Y'           W#ERR4
     C                   LEAVE
     C                   ENDIF
      *
     C     K#KY07        READE     LEFEEDL1                               80
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     AR788404
      *  CHKACT :   Check account details                                                   AR788404
      *****************************************************************                     AR788404
     C     CHKACT        BEGSR                                                              AR788404
                                                                                            AR788404
     C                   MOVE      'N'           W#ERR4                                     AR788404
     C                   MOVE      FC_BRCA       K9BRCA            3                        AR788404
     C                   MOVE      FC_CNUM       K9CNUM                                     AR788404
     C                   Z-ADD     FC_FACT       K9FACT                                     AR788404
     C                   Z-ADD     FC_FCNO       K9FCNO                                     AR788404
     C                   EVAL      CountN = 0                                               MD026120
     C/EXEC SQL                                                                             MD026120
     C+  Select Count(*) into :CountN from ACCNTAB where BRCA = :K9BRCA                     MD026120
     C+  and CNUM = :K9CNUM and FACT = :K9FACT and FCNO = :K9FCNO and                       MD026120
     C+  RECI = 'D'                                                                         MD026120
     C/END-EXEC                                                                             MD026120
     C*****K#KY09        SETLL     GLACNTL5                                        AR788404 MD026120
     C*****K#KY09        READE     GLACNTL5                               80       AR788404 MD026120
     C******IN80         DOWEQ     *OFF                                            AR788404 MD026120
     C*****AC_RECI       IFEQ      'D'                                             AR788404 MD026120
     C                   IF        SQLCOD <> 0                                              MD026120
     C                   EXSR      *PSSR                                                    MD026120
     C                   ELSE                                                               MD026120
     C                   IF        CountN > 0                                               MD026120
     C                   MOVE      'Y'           W#ERR4                                     AR788404
     C                   ENDIF                                                              MD026120
     C                   ENDIF                                                              MD026120
     C**********         LEAVE                                                     AR788404 MD026120
     C**********         ENDIF                                                     AR788404 MD026120
     C*****K#KY09        READE     GLACNTL5                               80       AR788404 MD026120
     C**********         ENDDO                                                     AR788404 MD026120
     C                   ENDSR                                                              AR788404
                                                                                            AR788404
      *****************************************************************                     AR788404
      /EJECT                                                                                AR788404
      ***********************************************************                           BUG17135
      *  CHKCOL :                                                                           BUG17135
      ***********************************************************                           BUG17135
     C     CHKCOL        BEGSR                                                              BUG17135
      *                                                                                     BUG17135
     C                   MOVE      'N'           W#ERR4                                     BUG17135
     C                   MOVE      'LE'          CDMODS            2                        BUG17135
     C                   MOVE      FC_CNUM       CDFCUS            6                        BUG17135
     C                   MOVE      FC_FACT       CDFTYP            3 0                      BUG17135
     C                   MOVE      FC_FCNO       CDFSEQ            2 0                      BUG17135
      *                                                                                     BUG17135
     C     K#KY08        SETLL     GLCOLLL3                                                 BUG17135
     C     K#KY08        READE     GLCOLLL3                               80                BUG17135
      *                                                                                     BUG17135
     C     *IN80         DOWEQ     *OFF                                                     BUG17135
      *                                                                                     BUG17135
      **  If outstanding collaterals are found (CDRECI = 'D') the facility                  BUG17135
      **  cannot be reversed.                                                               BUG17135
      *                                                                                     BUG17135
     C     CDRECI        IFEQ      'D'                                                      BUG17135
     C                   MOVE      'Y'           W#ERR4                                     BUG17135
     C                   LEAVE                                                              BUG17135
     C                   ENDIF                                                              BUG17135
      *                                                                                     BUG17135
     C     K#KY08        READE     GLCOLLL3                               80                BUG17135
      *                                                                                     BUG17135
     C                   ENDDO                                                              BUG17135
      *                                                                                     BUG17135
     C                   ENDSR                                                              BUG17135
      *****************************************************************                     BUG17135
      /EJECT                                                                                BUG17135
      *****************************************************************
      *  VLDAUT :   Validate Authority
      ***********************************************************
     C     VLDAUT        BEGSR
      *
      **  Validate users authority to usse this branch/action
     C                   Z-ADD     *ZERO         @ERR
      *
      **  If not a multi-branch
     C     BJSBRC        IFNE      *BLANK
     C*****DDACTN        ANDNE     'I'                                                       BUG1621
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFNE      *ZERO
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0009'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate facility branch if not an insert
     C     BJSBRC        IFEQ      *BLANK
     C*****DDACTN        ANDNE     'I'                                                       BUG1621
     C     DDACTN        IFEQ      'I'                                                       BUG4253
     C     DDBRCA        ANDEQ     '   '                                                     BUG4253
     C                   MOVEL     'N'           DDACTNOK                                    BUG4253
     C                   ADD       1             Ix                                          BUG4253
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)                              BUG4253
     C                   MOVEL     'LEF0369'     MsgIdArr(Ix)                                BUG4253
     C                   ELSE                                                                BUG4253
      *
     C     FC_BRCA       IFEQ      *BLANKS                                                   BUG2086
     C                   Eval      FC_BRCA = DDBRCA                                          BUG2086
     C                   ENDIF                                                               BUG2086
      *                                                                                      BUG2086
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM      FC_BRCA       @ZBR              3
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFEQ      1
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0010'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     @ERR          IFEQ      2
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0011'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF                                                               BUG4253
      *
      **  Validate Orig. Branch if used and validation required and
      **  is not an insert
     C     BKOBRU        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C     DDACTN        ANDNE     'I'
      *
     C                   CALL      'ZVOBU'
     C                   PARM      FC_ORBR       @ZOBRX            3
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFEQ      1
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0012'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     @ERR          IFEQ      2
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEF0013'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCKFR  -  Check if the Facility has been reactivated.       *
      *  Called by: AMENDS - Process amendment                        *
      *  Calls    : None                                              *
      *****************************************************************
      *
     C     SRCKFR        BEGSR
      *
     C     WAggregate    IFEQ      'Y'                                                        CLE041
     C     K#KY12        SETLL     LEAGAML3                                                   CLE041
     C     K#KY12        READE     LEAGAML3                               80                  CLE041
      *                                                                                       CLE041
     C     *IN80         DOWEQ     *OFF                                                       CLE041
     C     WREAC         ANDEQ     *OFF                                                       CLE041
     C     AGL3_RECI     IFEQ      'D'                                                        CLE041
     C     AGL3_FATP     ANDEQ     'FR'                                                       CLE041
     C                   MOVE      AGL3_NDEX     WNDTEX            5                          CLE041
     C                   MOVE      *ON           WREAC                                        CLE041
     C                   ENDIF                                                                CLE041
     C     K#KY12        READE     LEAGAML3                               80                  CLE041
     C                   ENDDO                                                                CLE041
                                                                                              CLE041
     C                   ELSE                                                                 CLE041
                                                                                              CLE041
     C     K#KY12        SETLL     LEFCAML3
     C     K#KY12        READE     LEFCAML3                               80
      *
     C     *IN80         DOWEQ     *OFF
     C     WREAC         ANDEQ     *OFF
     C     L3_RECI       IFEQ      'D'
     C     L3_FATP       ANDEQ     'FR'
     C                   MOVE      L3_NDEX       WNDTEX            5
     C                   MOVE      *ON           WREAC
     C                   ENDIF
     C     K#KY12        READE     LEFCAML3                               80
     C                   ENDDO
     C                   ENDIF                                                                CLE041
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MOVFLD - Move file fields (File FCLTYFN) to DS fields
      *****************************************************************
     C     MOVFLD        BEGSR
     C                   MOVEL     FC_RECI       FN_RECI
     C**********         Z-ADD     FC_CNUM       FN_CNUM                                      CSD027
     C                   EVAL      FN_CNUM = FC_CNUM                                          CSD027
     C                   Z-ADD     FC_FACT       FN_FACT
     C                   Z-ADD     FC_FCNO       FN_FCNO
     C                   MOVEL     FC_RCTP       FN_RCTP
     C                   MOVEL     FC_CMFT       FN_CMFT
     C                   Z-ADD     FC_CALC       FN_CALC
     C                   Z-ADD     FC_SPRD       FN_SPRD
     C                   Z-ADD     FC_BCOD       FN_BCOD
     C                   Z-ADD     FC_BRAT       FN_BRAT
     C                   Z-ADD     FC_STDT       FN_STDT
     C                   Z-ADD     FC_EDDT       FN_EDDT
     C                   Z-ADD     FC_DUDT       FN_DUDT
     C                   MOVEL     FC_BLFR       FN_BLFR
     C                   Z-ADD     FC_BLDN       FN_BLDN
     C                   MOVEL     FC_BTIN       FN_BTIN
     C                   Z-ADD     FC_BLDY       FN_BLDY
     C                   Z-ADD     FC_SETT       FN_SETT
     C                   MOVEL     FC_OBAC       FN_OBAC
     C                   MOVEL     FC_TNAC       FN_TNAC
     C                   Z-ADD     FC_SLCD       FN_SLCD
     C                   Z-ADD     FC_ACCD       FN_ACCD
     C                   Z-ADD     FC_ADNP       FN_ADNP
     C                   Z-ADD     FC_PDTD       FN_PDTD
     C                   Z-ADD     FC_AFPD       FN_AFPD
     C                   Z-ADD     FC_ADJP       FN_ADJP
     C                   Z-ADD     FC_ADJN       FN_ADJN
     C                   Z-ADD     FC_TOTD       FN_TOTD
     C                   Z-ADD     FC_CAMD       FN_CAMD
     C                   Z-ADD     FC_LSWSC      FN_LSWSC
     C                   MOVEL     FC_PRFC       FN_PRFC
     C                   MOVEL     FC_MBFC       FN_MBFC
     C                   MOVEL     FC_BITS       FN_BITS
     C                   Z-ADD     FC_PEXP       FN_PEXP
     C                   MOVEL     FC_ZZ003      FN_ZZ003
     C                   MOVEL     FC_CFBR       FN_CFBR
     C                   MOVEL     FC_ZZ002      FN_ZZ002
     C                   Z-ADD     FC_RUN0       FN_RUN0
     C                   Z-ADD     FC_RUN1       FN_RUN1
     C                   Z-ADD     FC_RUN2       FN_RUN2
     C                   Z-ADD     FC_RUN3       FN_RUN3
     C                   Z-ADD     FC_RUN4       FN_RUN4
     C                   Z-ADD     FC_RUN5       FN_RUN5
     C                   Z-ADD     FC_RUN6       FN_RUN6
     C                   Z-ADD     FC_RUN7       FN_RUN7
     C                   Z-ADD     FC_RUN8       FN_RUN8
     C                   Z-ADD     FC_RUN9       FN_RUN9
     C                   Z-ADD     FC_OAM1       FN_OAM1
     C                   Z-ADD     FC_OAM2       FN_OAM2
     C                   Z-ADD     FC_OAM3       FN_OAM3
     C                   Z-ADD     FC_OAM4       FN_OAM4
     C                   Z-ADD     FC_OAM5       FN_OAM5
     C                   Z-ADD     FC_OAM6       FN_OAM6
     C                   Z-ADD     FC_OAM7       FN_OAM7
     C                   Z-ADD     FC_OAM8       FN_OAM8
     C                   Z-ADD     FC_OAM9       FN_OAM9
     C                   Z-ADD     FC_OA10       FN_OA10
     C                   Z-ADD     FC_ORED       FN_ORED
     C                   Z-ADD     FC_LCD        FN_LCD
     C                   MOVEL     FC_CHTP       FN_CHTP
     C                   Z-ADD     FC_TNLU       FN_TNLU
     C                   Z-ADD     FC_CEXP       FN_CEXP
     C
     C/COPY WNCPYSRC,LEH00263
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CLE041
      *****************************************************************                       CLE041
      *                                                               *                       CLE041
      * SRMovAGFld - Move file fields (File LEAGFNPD) to DS fields    *                       CLE041
      *                                                               *                       CLE041
      *****************************************************************                       CLE041
     C     SRMovAGFld    BEGSR                                                                CLE041
                                                                                              CLE041
     C                   MOVEL     AGFC_RECI     AGFN_RECI                                    CLE041
     C**********         Z-ADD     AGFC_CNUM     AGFN_CNUM                             CLE041 CSD027
     C                   EVAL      AGFN_CNUM = AGFC_CNUM                                      CSD027
     C                   Z-ADD     AGFC_FACT     AGFN_FACT                                    CLE041
     C                   Z-ADD     AGFC_FCNO     AGFN_FCNO                                    CLE041
     C                   MOVEL     AGFC_RCTP     AGFN_RCTP                                    CLE041
     C                   MOVEL     AGFC_CMFT     AGFN_CMFT                                    CLE041
     C                   Z-ADD     AGFC_CALC     AGFN_CALC                                    CLE041
     C                   Z-ADD     AGFC_SPRD     AGFN_SPRD                                    CLE041
     C                   Z-ADD     AGFC_BCOD     AGFN_BCOD                                    CLE041
     C                   Z-ADD     AGFC_BRAT     AGFN_BRAT                                    CLE041
     C                   Z-ADD     AGFC_STDT     AGFN_STDT                                    CLE041
     C                   Z-ADD     AGFC_EDDT     AGFN_EDDT                                    CLE041
     C                   Z-ADD     AGFC_DUDT     AGFN_DUDT                                    CLE041
     C                   MOVEL     AGFC_BLFR     AGFN_BLFR                                    CLE041
     C                   Z-ADD     AGFC_BLDN     AGFN_BLDN                                    CLE041
     C                   MOVEL     AGFC_BTIN     AGFN_BTIN                                    CLE041
     C                   Z-ADD     AGFC_BLDY     AGFN_BLDY                                    CLE041
     C                   Z-ADD     AGFC_SETT     AGFN_SETT                                    CLE041
     C                   MOVEL     AGFC_OBAC     AGFN_OBAC                                    CLE041
     C                   MOVEL     AGFC_TNAC     AGFN_TNAC                                    CLE041
     C                   Z-ADD     AGFC_SLCD     AGFN_SLCD                                    CLE041
     C                   Z-ADD     AGFC_ACCD     AGFN_ACCD                                    CLE041
     C                   Z-ADD     AGFC_ADNP     AGFN_ADNP                                    CLE041
     C                   Z-ADD     AGFC_PDTD     AGFN_PDTD                                    CLE041
     C                   Z-ADD     AGFC_AFPD     AGFN_AFPD                                    CLE041
     C                   Z-ADD     AGFC_ADJP     AGFN_ADJP                                    CLE041
     C                   Z-ADD     AGFC_ADJN     AGFN_ADJN                                    CLE041
     C                   Z-ADD     AGFC_TOTD     AGFN_TOTD                                    CLE041
     C                   Z-ADD     AGFC_CAMD     AGFN_CAMD                                    CLE041
     C                   Z-ADD     AGFC_LSWSC    AGFN_LSWSC                                   CLE041
     C                   MOVEL     AGFC_PRFC     AGFN_PRFC                                    CLE041
     C                   MOVEL     AGFC_MBFC     AGFN_MBFC                                    CLE041
     C                   MOVEL     AGFC_BITS     AGFN_BITS                                    CLE041
     C                   Z-ADD     AGFC_PEXP     AGFN_PEXP                                    CLE041
     C                   MOVEL     AGFC_ZZ003    AGFN_ZZ003                                   CLE041
     C                   MOVEL     AGFC_CFBR     AGFN_CFBR                                    CLE041
     C                   MOVEL     AGFC_ZZ002    AGFN_ZZ002                                   CLE041
     C                   Z-ADD     AGFC_RUN0     AGFN_RUN0                                    CLE041
     C                   Z-ADD     AGFC_RUN1     AGFN_RUN1                                    CLE041
     C                   Z-ADD     AGFC_RUN2     AGFN_RUN2                                    CLE041
     C                   Z-ADD     AGFC_RUN3     AGFN_RUN3                                    CLE041
     C                   Z-ADD     AGFC_RUN4     AGFN_RUN4                                    CLE041
     C                   Z-ADD     AGFC_RUN5     AGFN_RUN5                                    CLE041
     C                   Z-ADD     AGFC_RUN6     AGFN_RUN6                                    CLE041
     C                   Z-ADD     AGFC_RUN7     AGFN_RUN7                                    CLE041
     C                   Z-ADD     AGFC_RUN8     AGFN_RUN8                                    CLE041
     C                   Z-ADD     AGFC_RUN9     AGFN_RUN9                                    CLE041
     C                   Z-ADD     AGFC_OAM1     AGFN_OAM1                                    CLE041
     C                   Z-ADD     AGFC_OAM2     AGFN_OAM2                                    CLE041
     C                   Z-ADD     AGFC_OAM3     AGFN_OAM3                                    CLE041
     C                   Z-ADD     AGFC_OAM4     AGFN_OAM4                                    CLE041
     C                   Z-ADD     AGFC_OAM5     AGFN_OAM5                                    CLE041
     C                   Z-ADD     AGFC_OAM6     AGFN_OAM6                                    CLE041
     C                   Z-ADD     AGFC_OAM7     AGFN_OAM7                                    CLE041
     C                   Z-ADD     AGFC_OAM8     AGFN_OAM8                                    CLE041
     C                   Z-ADD     AGFC_OAM9     AGFN_OAM9                                    CLE041
     C                   Z-ADD     AGFC_OA10     AGFN_OA10                                    CLE041
     C                   Z-ADD     AGFC_ORED     AGFN_ORED                                    CLE041
     C                   Z-ADD     AGFC_LCD      AGFN_LCD                                     CLE041
     C                   MOVEL     AGFC_CHTP     AGFN_CHTP                                    CLE041
     C                   Z-ADD     AGFC_TNLU     AGFN_TNLU                                    CLE041
     C                   Z-ADD     AGFC_CEXP     AGFN_CEXP                                    CLE041
                                                                                              CLE041
     C/COPY WNCPYSRC,LEH00264
     C                   ENDSR                                                                CLE041
      *****************************************************************                       CLE041
      /EJECT
      *****************************************************************
      * DETFCNO  : Determine facility sequence number                 *
      *****************************************************************
     C     DETFCNO       BEGSR
      *
     C**********         MOVEL     DDCSSN        K#CNUM            6 0                        CSD027
     C                   MOVEL     DDCSSN        K#CNUM            6                          CSD027
     C                   MOVE      DDFACT        K#FACT            3 0
                                                                                              CLE041
     C                   IF        CLE025 = 'N'                                               CLE041
     C                   Z-ADD     1             K4FCNO            2 0

     C     K#FCTYP       SETLL     FCLTY                                  70
      *
     C                   MOVE      'N'           W#EXIT            1
     C     W#EXIT        DOWNE     'Y'
      *
     C     *IN70         IFEQ      *OFF
     C                   MOVE      'Y'           W#EXIT
     C                   ELSE
     C     K4FCNO        IFNE      99
     C                   ADD       1             K4FCNO
     C     K#FCTYP       SETLL     FCLTY                                  70
     C                   ELSE
     C                   MOVE      'Y'           W#EXIT
     C                   MOVE      'N'           DDFCNOOK
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
     C                   ELSE                                                                 CLE041
                                                                                              CLE041
      ** If Credit Lines is installed, check aggregates file                                  CLE041
                                                                                              CLE041
     C                   EVAL      K4FCNO = 99                                                CLE041
     C     K#FCTYP       SETGT     FCLTY                                                      CLE041
     C                   READP     FCLTY                                  70                  CLE041
     C                   IF        NOT(*IN70) AND                                             CLE041
     C                             K#CNUM = FC_CNUM AND K#FACT = FC_FACT                      CLE041
     C     FC_FCNO       ADD       1             WFCNO             2 0                        CLE041
     C                   ELSE                                                                 CLE041
     C                   Z-ADD     1             WFCNO                                        CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
     C     K#FCTYP       SETGT     LEAGFCL0                                                   CLE041
     C                   READP     LEAGFCL0                               70                  CLE041
     C                   IF        NOT(*IN70) AND                                             CLE041
     C                             K#CNUM = AGFC_CNUM AND K#FACT = AGFC_FACT                  CLE041
     C     AGFC_FCNO     ADD       1             WAFCNO            2 0                        CLE041
     C                   ELSE                                                                 CLE041
     C                   Z-ADD     1             WAFCNO                                       CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
     C                   IF        WAFCNO > WFCNO                                             CLE041
     C                   EVAL      K4FCNO = WAFCNO                                            CLE041
     C                   ELSE                                                                 CLE041
     C                   EVAL      K4FCNO = WFCNO                                             CLE041
     C                   ENDIF                                                                CLE041
     C                   ENDIF                                                                CLE041

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALISATION
      *****************************************************************
     C     INIT          BEGSR

      * CLEAR OUTPUTS
     C                   CLEAR                   FacmFilFmt
     C                   CLEAR                   FacnFilFmt
     C                   MOVEL     'Y'           DDACTNOK
     C                   MOVEL     'Y'           DDCSSNOK
     C                   MOVEL     'Y'           DDFACTOK
     C                   MOVEL     'Y'           DDFCNOOK
     C                   EVAL      WAggregate = 'N'                                           CLE041

      *
      ** files FCLTY
     C     CHKFAC        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
     C                   KFLD                    KRCTP

      **  Used for LEFCLTL1 and L7
     C     K#KY02        KLIST
     C                   KFLD                    K2CNUM
     C                   KFLD                    K2FACT
     C                   KFLD                    K2FCNO

      ** Used for CLOAN
     C     K#KY05        KLIST
     C                   KFLD                    K5LNRF
     C                   KFLD                    K5RCTP

      ** Key for LEFEDL1
     C     K#KY07        KLIST
     C                   KFLD                    K7CNUM
     C                   KFLD                    K7FCTY

      ** Used for GLACNTL5                                                                  AR788404
     C     K#KY09        KLIST                                                              AR788404
     C                   KFLD                    K9BRCA                                     AR788404
     C                   KFLD                    K9CNUM                                     AR788404
     C                   KFLD                    K9FACT                                     AR788404
     C                   KFLD                    K9FCNO                                     AR788404
                                                                                            AR788404
      ** Key for Collaterals                                                                BUG17135
     C     K#KY08        KLIST                                                              BUG17135
     C                   KFLD                    CDMODS                                     BUG17135
     C                   KFLD                    CDFCUS                                     BUG17135
     C                   KFLD                    CDFTYP                                     BUG17135
     C                   KFLD                    CDFSEQ                                     BUG17135
                                                                                            BUG17135
      **  Used for LEFCLTL9
     C     K#KY10        KLIST
     C                   KFLD                    K0CANM
     C                   KFLD                    K0CAFT
     C                   KFLD                    K0CAFN

      **  Used for LEFCAML3
     C     K#KY12        KLIST
     C                   KFLD                    K3CNUM
     C                   KFLD                    K3FACT
     C                   KFLD                    K3FCNO

     C     K#FCTYP       KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K4FCNO

     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR

      * Parameters
     C     *ENTRY        PLIST

      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office User
     C                   PARM                    FOUSER           16
      * (Midas) Customer Number
     C                   PARM                    DDCSSN           10
      * (Midas) Facility Type
     C                   PARM                    DDFACT            3
      * (Midas) Facility number
     C                   PARM                    DDFCNO            2
      * (Midas) Branch
     C                   PARM                    DDBRCA            3
     C/COPY WNCPYSRC,LEH00353

      * OUTPUTS
      * (Current) Facility FM in file format
     C                   PARM                    FacmFilFmt
      * (Current) Facility FN in file format
     C                   PARM                    FacnFilFmt
      * OK - Action code
     C                   PARM                    DDACTNOK          1
      * OK - Customer number
     C                   PARM                    DDCSSNOK          1
      * OK - Facility type
     C                   PARM                    DDFACTOK          1
      * OK - Facility number
     C                   PARM                    DDFCNOOK          1
     C/COPY WNCPYSRC,LEH00317
      * Reactivation indicator
     C                   PARM                    WREAC             1
      * New expiry date
     C                   PARM                    WNDTEX            5
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix

      ** Initialise program name

     C                   MOVEL     'LEFCIPRTV'   DBPGM

      ** Access Bank Detailes
      *  ~~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger Detailes
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '       '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  ACCESS CUSTOMER LENDING DATA
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
      **  Access Switchable SAR details for the existence of CLE005
      **  (Tranch 3)
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C                   ENDIF
     C/COPY WNCPYSRC,LEH00266
                                                                                              CLE041
      ** Access Switchable SAR details for the existence of CLE025                            CLE041
                                                                                              CLE041
     C                   CALLB     'AOSARDR0'                                                 CLE041
     C                   PARM      *BLANK        @RTCD                                        CLE041
     C                   PARM      '*VERIFY'     @OPTN                                        CLE041
     C                   PARM      'CLE025'      @SARD                                        CLE041
                                                                                              CLE041
     C                   IF        @RTCD = *BLANK                                             CLE041
     C                   EVAL      CLE025 = 'Y'                                               CLE041
     C                   ELSE                                                                 CLE041
     C                   EVAL      CLE025 = 'N'                                               CLE041
     C                   ENDIF                                                                CLE041
      *
      **  Facility participant (LEFCLTL2)
     C     K#KY04        KLIST
     C                   KFLD                    K4BRCA
     C                   KFLD                    K4CNUM
     C                   KFLD                    K4FACT
     C                   KFLD                    K4FCNO
      **  Used for SDCWHTL1                                                                 BUG4555
      *                                                                                     BUG4555
     C     KCwFld        KLIST                                                              BUG4555
     C                   KFLD                    WFuncType                                  BUG4555
     C                   KFLD                    WIdntifier                                 BUG4555
     C                   KFLD                    WBranch                                    BUG4555
      *                                                                                     BUG4555
      ** Determine if 24x7 Midas Availability active?                                       BUG4555
      *                                                                                     BUG4555
      ** CSC011 is a redundant feature. No need to check                                    MD024398
     C**********         CALL      'AOSARDR0'                                       BUG4555 MD024398
     C**********         PARM      *BLANK        @RTCD                              BUG4555 MD024398
     C**********         PARM      '*VERIFY'     @OPTN                              BUG4555 MD024398
     C**********         PARM      'CSC011'      @SARD                              BUG4555 MD024398
     C**********                                                                    BUG4555 MD024398
     C*****@RTCD         IFEQ      *BLANKS                                          BUG4555 MD024398
     C**********         EVAL      CSC011  = 'Y'                                    BUG4555 MD024398
     C**********         ELSE                                                       BUG4555 MD024398
     C                   EVAL      CSC011 = 'N'                                             BUG4555
     C**********         ENDIF                                                      BUG4555 MD024398
     C*                                                                                     BUG4555
     C                   IN        SDSTAT                                                   BUG4555
     C                   IN        SC24X7                                                   BUG4555
      *                                                                                     BUG4555
      ** Access SAR Details to see if COMPLIANCE WATCH ENHANCEMENT (CSD015)                 BUG4555
      ** is installed.                                                                      BUG4555
      *                                                                                     BUG4555
     C                   EVAL      CSD015 = 'N'                                             BUG4555
      *                                                                                     BUG4555
     C                   CALLB     'AOSARDR0'                                               BUG4555
     C                   PARM      *BLANKS       @RTCD                                      BUG4555
     C                   PARM      '*VERIFY '    @OPTN                                      BUG4555
     C                   PARM      'CSD015'      @SARD                                      BUG4555
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG4555
      *                                                                                     BUG4555
     C                   IF        @RTCD = *BLANKS                                          BUG4555
     C                   EVAL      CSD015 = 'Y'                                             BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
     C                   IF        (@RTCD <> '*NRF    ') AND                                BUG4555
     C                             (@RTCD <> *BLANKS)                                       BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG4555
     C                   EVAL      DBASE = 56                                               BUG4555
     C                   EVAL      DBKEY = @SARD                                            BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
      ** Access SAR Details to see if Concord Interface Development (CCF001)                BUG4555
      ** is installed.                                                                      BUG4555
      *                                                                                     BUG4555
     C                   EVAL      CCF001 = 'N'                                             BUG4555
      *                                                                                     BUG4555
     C                   CALLB     'AOSARDR0'                                               BUG4555
     C                   PARM      *BLANKS       @RTCD                                      BUG4555
     C                   PARM      '*VERIFY '    @OPTN                                      BUG4555
     C                   PARM      'CCF001'      @SARD                                      BUG4555
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG4555
      *                                                                                     BUG4555
     C                   IF        @RTCD = *BLANKS                                          BUG4555
     C                   EVAL      CCF001 = 'Y'                                             BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
     C                   IF        (@RTCD <> '*NRF    ') AND                                BUG4555
     C                             (@RTCD <> *BLANKS)                                       BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG4555
     C                   EVAL      DBASE = 57                                               BUG4555
     C                   EVAL      DBKEY = @SARD                                            BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
     C                   IF        CSD015 = 'Y'                                             BUG4555
      *                                                                                     BUG4555
      ** Access Compliance Watch Configuration file to get the                              BUG4555
      ** Private Customer Industry Codes                                                    BUG4555
      *                                                                                     BUG4555
     C                   CALLB     'AOCWCDR0'                                               BUG4555
     C                   PARM      *BLANKS       @RTCD                                      BUG4555
     C                   PARM      '*FIRST '     @OPTN                                      BUG4555
     C     SDCWCD        PARM      SDCWCD        DSSDY                                      BUG4555
      *                                                                                     BUG4555
     C                   IF        @RTCD <> *BLANKS                                         BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBFILE = 'SDCWCDPD'                                      BUG4555
     C                   EVAL      DBASE = 58                                               BUG4555
     C                   EVAL      DBKEY = @OPTN                                            BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
      ** Check if function code is being monitored by compliance watch.                     BUG4555
      *                                                                                     BUG4555
     C                   CALLB     'AOWLCCR0'                                               BUG4555
     C                   PARM      *BLANKS       @RTCD                                      BUG4555
     C                   PARM      '*KEY   '     @OPTN                                      BUG4555
     C                   PARM      'LENDING'     @FUNC             8                        BUG4555
     C     SDWLCC        PARM      SDWLCC        DSFDY                                      BUG4555
      *                                                                                     BUG4555
     C                   IF        (@RTCD <> '*NRF    ') AND                                BUG4555
     C                             (@RTCD <> *BLANKS)                                       BUG4555
     C     *LOCK         IN        LDA                                                      BUG4555
     C                   EVAL      DBFILE = 'SDWLCCPD'                                      BUG4555
     C                   EVAL      DBASE = 59                                               BUG4555
     C                   EVAL      DBKEY = @FUNC                                            BUG4555
     C                   OUT       LDA                                                      BUG4555
     C                   EXSR      *PSSR                                                    BUG4555
     C                   ENDIF                                                              BUG4555
      *                                                                                     BUG4555
     C                   ENDIF                                                              BUG4555
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C**********         PARM      'CSC024'      @SARD                                 CSC024 CSC054
     C                   PARM      'CSC054'      @SARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 1                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CSC024
     C                   IF        @RTCD = *BLANKS                                            CSC024
     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
     C                   ENDIF                                                                240968
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C**********         PARM      *BLANKS       P@OP02                                CSC024 240968
     C                   PARM      CLAuthORED    P@OP02                                       240968
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C**********         PARM      *BLANKS       P@OP03                                CSC024 241113
     C                   PARM      PSysVal3      P@OP03                                       241113
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C**********         PARM      *BLANKS       P@OP04                                CSC024 244314
     C                   PARM      CLAuthSMDT    P@OP04                                       244314
     C                   PARM      *BLANKS       P@VL04                                       CSC024
     C                   PARM      *BLANKS       P@OP05                                       CSC024
     C                   PARM      *BLANKS       P@VL05                                       CSC024
     C                   PARM      *BLANKS       P@OP06                                       CSC024
     C                   PARM      *BLANKS       P@VL06                                       CSC024
     C                   PARM      *BLANKS       P@OP07                                       CSC024
     C                   PARM      *BLANKS       P@VL07                                       CSC024
     C                   PARM      *BLANKS       P@OP08                                       CSC024
     C                   PARM      *BLANKS       P@VL08                                       CSC024
     C                   PARM      *BLANKS       P@OP09                                       CSC024
     C                   PARM      *BLANKS       P@VL09                                       CSC024
     C                   PARM      *BLANKS       P@OP10                                       CSC024
     C                   PARM      *BLANKS       P@VL10                                       CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 2                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC024
     C                   ENDIF                                                                CSC024
     C**********         ENDIF                                                         CSC024 240968
     C                   MOVEL     P@VL02        ATHORED           1                          240968
     C                   MOVEL     P@VL03        ALWFCNO           1                          241113
     C                   MOVEL     P@VL04        ATHOSMDT          1                          244314
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 7                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CLE056
      ** Check if Authorisation on Lending Transactions (CLE056) is on                        CLE056
                                                                                              CLE056
     C                   EVAL      CLE056 = 'N'                                               CLE056
     C                   CALLB     'AOSARDR0'                                                 CLE056
     C                   PARM      *BLANKS       @RTCD                                        CLE056
     C                   PARM      '*VERIFY'     @OPTN                                        CLE056
     C                   PARM      'CLE056'      @SARD                                        CLE056
                                                                                              CLE056
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CLE056
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE056
     C                   EVAL      DBKey  = 'CLE056'                                          CLE056
     C                   EVAL      DBase  = 8                                                 CLE056
     C                   EXSR      *PSSR                                                      CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CLE056
     C                   IF        @RTCD = *BLANKS                                            CLE056
     C                   EVAL      CLE056 = 'Y'                                               CLE056
     C                   ENDIF                                                                CLE056

      ** Check if CAP185 is installed                                                         CAP185
     C                   CALLB     'AOSARDR0'                                                 CAP185
     C                   PARM      *BLANKS       @RTCD             7                          CAP185
     C                   PARM      '*VERIFY'     @OPTN             7                          CAP185
     C                   PARM      'CAP185'      @SARD             6                          CAP185
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP185
     C*                                                                                       CAP185
     C                   If        @RTCD = *BLANK                                             CAP185
     C                   MOVE      'Y'           CAP185            1                          CAP185
      *                                                                                       CAP185
      ** Determine if Auto-authorise                                                          CAP185
     C     *LIKE         DEFINE    APNAME        @APINAME                                     CAP185
     C                   MOVEL     'FCIP'        @APINAME                                     CAP185
     C     @APINAME      CHAIN     APICFGL0                                                   CAP185
     C                   IF        %FOUND(APICFGL0)                                           CAP185
     C                   MOVE      APAUT         @AUTHO            1                          CAP185
     C                   ENDIF                                                                CAP185
      *                                                                                       CAP185
     C                   ELSE                                                                 CAP185
     C                   IF        @RTCD = '*NRF'                                             CAP185
     C                   MOVE      'N'           CAP185                                       CAP185
     C                   ELSE                                                                 CAP185
     C*                                                                                       CAP185
     C**    Database error processing                                                         CAP185
     C*                                                                                       CAP185
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CAP185
     C                   MOVEL     '185'         DBASE                          * DBERR 185 * CAP185
     C                   MOVEL     'CAP185'      DBKEY                          ************* CAP185
     C                   EXSR      *PSSR                                                      CAP185
     C                   ENDIF                                                                CAP185
     C                   ENDIF                                                                CAP185
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      @SARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS AND                                       CSD083
     C                             @RTCD <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 09                                                 CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CAP185
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
