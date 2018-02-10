     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendment retr + act/deal validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMRTV - DEAL AMENDMENTS RETRIEVE                         *
      *              (WITH ACTION CODE VERSUS DEAM NUMBER VALIDATION  *
      *                                                               *
      *  Function:  This module retrieves a deal amendment from       *
      *             the database. As it does so, it validates the     *
      *             action code, deal number, value date & seq.       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD021204           Date 12Jul13               *
      *                 MD000091           Date 14May13               *
      *                 CSC054             Date 23Feb12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER043             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 256482             Date 14Oct08               *
      *                 256795             Date 25Sep08               *
      *                 BUG16961           Date 14Mar08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185             Date 21Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 237063             Date 20Nov05               *
      *                 BUG8584            Date 30Sep05               *
      *                 BUG8114            Date 09Aug05               *
      *                 CDL038             Date 10May05               *
      *                 BUG8360            Date 12Sep05               *
      *                 BUG7537            Date 15Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG7411            Date 01Jun05               *
      *                 BUG6534            Date 15Apr04               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 BUG4849            Date 08Dec04               *
      *                 BUG5092            Date 10Dec04               *
      *                 BUG4422            Date 01Oct04               *
      *                 BUG3499            Date 30Jun04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAP084             Date 25Jun03               *
      *                 191881             Date 26Feb03               *
      *                 CSD015             Date 14Oct02               *
      *                 208100             Date 05Aug02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 12Jan01               *
      *                 185658             Date 20Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 176841             DATE 09May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 08Nov99               *
      *                 CAP051             Date 12Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD021204 - Impossible to create deal amendment via JMS_MQ    *
      *  MD000091 - Event Codes Substitution                          *
      *  CSC054 - Period End Adjustments                              *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  256482 - Correct Front Office Associated ID validation.      *
      *           Applied 250398                                      *
      *  256795 - Penalty Termination of Time deposits (CDL052).      *
      *  BUG16961 - Error in matured deal                             *
      *  CAP185 - MQ Series Interface                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  BUG8584 - Cannot enter new deal amendment due to error       *
      *            message MMM0149. Replaced HNDLTF (Logical          *
      *            Delete Flag) with HNDDLT (Deal Deleted Ind) as     *
      *            this field is not used anymore. Another issue      *
      *            is incorrect validation done for initial screen    *
      *            (in subr/VALACF) which is copied from VALACI.      *
      *            Validation should just be simple as proper         *
      *            checking will be done in VALACI anyway.            *
      *            (Similar to BUG7537)                               *
      *  BUG8114- Added 'CF' deal type for CDL033.                    *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG8360- EM should be prohibited under these conditions:     *
      *           1. Rollover indicator is automatic.                 *
      *           2. Rollover indicator is 'Yes' and deal is flagged  *
      *              as collateral.                                   *
      *           3. Deal is already rolled over.                     *
      *  BUG7537 - Cannot enter new deal amendment due to error       *
      *            message MMM0149. Replaced HNDLTF (Logical          *
      *            Delete Flag) with HNDDLT (Deal Deleted Ind) as     *
      *            this field is not used anymore. Another issue      *
      *            is incorrect validation done for initial screen    *
      *            (in subr/VALACF) which is copied from VALACI.      *
      *            Validation should just be simple as proper         *
      *            checking will be done in VALACI anyway.            *
      *  CSC024 - Open Month End                                      *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  BUG6534- Add validation to new initial input screen          *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  BUG4849- Should be allow to delete DEAM even DEAL is not     *
      *           authorised.                                         *
      *  BUG5092- Amendment type 'EM' not allowed for Blocked Deals   *
      *  BUG4422- Authorisation Error on DEAM.  Retrieve contents of  *
      *           DTAARA/ZMUSER for each user authorisation check.    *
      *  BUG3499- Decimal Data Error (Recompile)                      *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *                                                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API Wrapper project                                 *
      *  191881 - Next amendment action date (NAAD) and Next amendment*
      *           sequence (NASN) are not properly updated when a deal*
      *           amendment is authorised and related deal amendments *
      *           with lower value date or sequence are not authorised*
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  208100 - Check for further errors in subroutine VALAX.       *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  185658 - During authorisation of SI deal amendment, settle-  *
      *           ment details disappear. This is due to the wrong    *
      *           side being protected upon insertion of the amend-   *
      *           ment. Fix is to save the HNOMDT value (deal type of *
      *           the associated deal) and restore back after reading *
      *           a record from LF/MMLVDMLL (MMDEAMPP).  This is to   *
      *           ensure that the correct deal type is passed back to *
      *           MMDEAMSIN.                                          *
      *  176841 - User should be able to re-authorise a deal if       *
      *           'MM Authorisation Required' is 'N' and              *
      *           'MM Reauthorise Amended deals' is 'Y'.              *
      *  CSE006 - Repos Maintenance                                   *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDEAMPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDEAMPP               *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMDEAML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMOI)
     FMMDEAML3  IF   E           K DISK    INFSR(*PSSR)                                       CDL017
     F                                     RENAME(MMDEAMP0:MMDEAMEM)                          CDL017
     FMMDEALL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDELDP0)
     F                                     INCLUDE(MMDENBP0)
     F                                     RENAME(MMDELDP0:MMDELFOI)
     F                                     RENAME(MMDENBP0:MMDENBOI)
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMP2)
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMP4)
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
     FDEALSH    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDBF:DEALSHBF)
     F                                     RENAME(DEALSDCF:DEALSHCF)
     F                                     RENAME(DEALSDDF:DEALSHDF)
     F                                     RENAME(DEALSDEF:DEALSHEF)
     F                                     RENAME(DEALSDGF:DEALSHGF)
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
                                                                                              CAP185
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
     F/COPY WNCPYSRC,MMDEAMIF01

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

      ** Include the MM standard declares
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

     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D***@DT2***         S              2    DIM(15) CTDATA PERRCD(15)                        CDL033
     D @DT2            S              2    DIM(16) CTDATA PERRCD(16)                          CDL033
     D**  ARRAY TO LOOK UP MIDAS DEAL TYPE FOR VALIDATION.
     D*
     D FIDTYP          S              2    DIM(6) CTDATA PERRCD(6)              CDL006
      ** Array to look up fiduciary deal type for validation                    CDL006
                                                                                CDL006
      **  Data structure for file status of MM deals file.
     D INFDS           DS
     D  RECORD           *RECORD

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029


     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSE006
      ** EXTERNAL DS FOR SWITCHABLE FEATURES FILE                               CSE006
                                                                                CSE006
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
      ** Watch List Configuration Data File                                                   CSD015
                                                                                              CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
      ** 24X7 status data area                                                                CSD015
                                                                                              CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
      ** SD data area                                                                         CSD015
                                                                                              CSD015
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D ZMUSER          DS            17
     D  ZUSER                  1     10                                                       CDL010
     D  BRC                   11     13
     D  DEPT                  14     16

     D DeamFilFmt    E DS                  EXTNAME(MMDEAMPP)
      ** Deam in File Format
     D  @DMVYR                51     52
     D  @DMVMT                53     54
     D  @DMVDY                55     56

      **  Data Structure to split value date used in key to deams file
     D                 DS
     D  @KVALD                 1      8  0 INZ(0)
     D  @VDYY                  1      4  0
     D  @VYEAR                 3      4  0
     D  @VDMM                  5      6  0
     D  @VDDD                  7      8  0

     D                 DS
      **  Data Structure for screen value date
     D  ValueDate              1      6
     D  @DSPD                  1      2
     D  @DSPM                  3      4
     D  @DSPY                  5      6

     D                 DS
     D**  Data Structure for input start/last interest date
     D  H@SLDT                 1      8  0 INZ(0)
     D  H@SLYY                 1      4  0
     D  H@SLMM                 5      6  0
     D  H@SLDD                 7      8  0
     D*
     D                 DS
     D**  Data Structure for input interest accrual control date
     D  H@IADT                 1      8  0 INZ(0)
     D  H@IAYY                 1      4  0
     D  H@IAMM                 5      6  0
     D  H@IADD                 7      8  0
     D*
     D                 DS
     D**  Data Structure for input maturity date
     D  H@MATD                 1      8  0 INZ(0)
     D  H@MDYY                 1      4  0
     D  H@MDMM                 5      6  0
     D  H@MDDD                 7      8  0
     D*
     D                 DS
     D**  Data structure for convertion of YYMMDD to DDMMYY
     D  @DMVDT                 1      6
     D  @DMVD                  1      2
     D  @DMVM                  3      4
     D  @DMVY                  5      6
                                                                                              CSD015
      **  AOWLCCR0 Function Code Parameter.                                                   CSD015
     D  PFuncCode      S              8                                                       CSD015
                                                                                              CSD015
      **  AOSARDR0 Switchable Feature Parameter.                                              CSD015
     D  PSARD          S              6                                                       CSD015
                                                                                              CSD015
      **  Compliance Watch Enhancement Indicator.                                             CSD015
     D  CSD015         S              1    INZ('N')                                           CSD015
                                                                                              CSD015
      ** 24X7 Midas Availability Indicator                                                    CSD015
     D CSC011          S              1    INZ('N')                                           CSD015
                                                                                              CSD015
      **  Compliance Watch Hit List Key Fields.                                               CSD015
     D  KFuncType      S              8                                                       CSD015
     D  KIden          S             40                                                       CSD015
     D  KBranch        S              3                                                       CSD015
                                                                                              CSD015
      ** Fields defined for Enhancement CSD015                                                CSD015
                                                                                              CSD015
     D WHNDA3          S              6A                                                      CSD015
     D WHNVDY          S              4A                                                      CSD015
     D WHNVDM          S              2A                                                      CSD015
     D WHNVDD          S              2A                                                      CSD015
     D WHNDS3          S              3A                                                      CSD015
                                                                                              CSD015
     D/COPY WNCPYSRC,MMDEAMID01
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0

      ** Fields used by Module ZDATE10 to change date format.
     D DateIn          S              8S 0
     D DateOut         S              5  0
     D CDL006          S              1A   IMPORT                               CDL006

      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
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
     D CER043          S              1A                                                      CER043
                                                                                              CER043
      ** Parameters for Calling ZDATE2                                                        CER043
     D ZDAYNO          S              5  0                                                    CER043
     D ZDATE           S              6  0                                                    CER043
     D ZADATE          S              7A                                                      CER043
                                                                                              CER043
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
     I*
     I** Rename fields on deals file with common names
     I** to simplify processing
     IMMDELDP0
     I              HKRCID                      H@RCID
     I              HKDSTS                      H@DSTS
     I              HKDLTF                      H@DLTF
     I              HKDN38                      H@DN38
     I              HKDDLT                      H@DDLT
     I              HKMTYP                      H@MTYP
     I              HKAMNP                      H@AMNP
     I              HKBRCA                      H@BRCA
     I              HKSLYY                      H@SLYY
     I              HKSLMM                      H@SLMM
     I              HKSLDD                      H@SLDD
     I              HKIAYY                      H@IAYY
     I              HKIAMM                      H@IAMM
     I              HKIADD                      H@IADD
     I              HKTYPE                      H@TYPE
     I              HKMDYY                      H@MDYY
     I              HKMDMM                      H@MDMM
     I              HKMDDD                      H@MDDD
     I              HKORBR                      H@ORBR
     I*
     IMMDENBP0
     I              HLRCID                      H@RCID
     I              HLDSTS                      H@DSTS
     I              HLDLTF                      H@DLTF
     I              HLDN38                      H@DN38
     I              HLDDLT                      H@DDLT
     I              HLMTYP                      H@MTYP
     I              HLAMNP                      H@AMNP
     I              HLBRCA                      H@BRCA
     I              HLLIYY                      H@SLYY
     I              HLLIMM                      H@SLMM
     I              HLLIDD                      H@SLDD
     I              HLIAYY                      H@IAYY
     I              HLIAMM                      H@IAMM
     I              HLIADD                      H@IADD
     I              HLTYPE                      H@TYPE
     I              HLORBR                      H@ORBR
     I*
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *                                                                         CPB002
      * Front Office Transaction ID                                             CPB002
     C                   MOVEL     FOTRID        WFRONTID          2            CPB002
      *                                                                         CPB002
     C     WFRONTID      IFEQ      'TO'                                         CPB002
     C                   MOVE      *BLANKS       ModeofOp                       CPB002
     C                   ENDIF                                                  CPB002
     C/COPY WNCPYSRC,MMDEAMIC04
      *
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      * VALIDATE ACTION CODE, DEAL NUMBER, VALUE DATE & SEQUENCE NUMBER
      *
     C                   EXSR      VAL
     C/COPY WNCPYSRC,MMDEAMIC01
      *                                                                                      256795
     C     CDL052        IFEQ      'Y'                                                       256795
     C     DDACTN        IFEQ      'I'                                                       256795
     C     DDACTN        OREQ      'A'                                                       256795
      *                                                                                      256795
     C                   Z-ADD     @@DLNO        @DLNO             6 0                       256795
      *                                                                                      256795
     C                   CALL      'MM5294'                                                  256795
     C                   PARM                    @DLNO                                       256795
     C                   PARM      *Blanks       @ERR              1                         256795
     C                   PARM      *Blanks       @ERRM            55                         256795
      *                                                                                      256795
     C     @ERR          IFEQ      'Y'                                                       256795
     C                   MOVE      'N'           OKDLNO                                      256795
     C                   ADD       1             Ix                                          256795
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              256795
     C                   MOVEL     'MMM5400'     MsgIdArr(Ix)                                256795
     C                   ENDIF                                                               256795
     C                   ENDIF                                                               256795
     C                   ENDIF                                                               256795
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C     OKVDAT        OREQ      'N'
     C     OKSEQN        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'X'
     C                   EXSR      VALACX
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'I'
     C                   EXSR      VALACI
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      VALACD
     C                   END
      *
      **  Carry out no further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END
                                                                                CAP051
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'                     CAP051
      * DO AUTHORISATION ARE REQUIRED                                           CAP051
     C     ModeofOp      IFEQ      '      '                                     CAP051
     C                   MOVE      *BLANKS       HNAUTH                         CAP051
     C                   ENDIF                                                  CAP051
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I', 'A, 'D' or 'X'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0100'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      **********                                                                            MD021204
      **ERROR*IF*FRONT*OFFICE*ASSOCIATED*TRANS*ID*(ORIGINAL*DEAL*NO)*********               MD021204
      **IS*BLANK*************************************************************               MD021204
      **********                                                                            MD021204
     C*****FOASID        IFEQ      *BLANK                                                   MD021204
     C**********         MOVE      'N'           OKACTN                                     MD021204
     C**********         ADD       1             Ix                                         MD021204
     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                             MD021204
     C**********         MOVEL     'APM0105'     MsgIdArr(Ix)                               MD021204
     C**********         GOTO      EVFRNT                                                   MD021204
     C**********         END                                                                MD021204
      *
      * ACCESS DEAL AMENDMENT WITH FRONT OFFICE TRANSACTION ID
      *
     C                   MOVE      FOASID        OrigDealNo       20
     C                   MOVE      FOTRID        UniqDeamID       20

     C     FrntOfKey     CHAIN     MMDEAMOI                           99
      *
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      * IF NOT INSERT, UPDATE SEQUENCE NUMBER
      *
     C                   MOVEL     HNDS38        DDDS38
     C                   END
      *
      * FRONT OFFICE ASSOCIATED TRANSACTION ID
      * MUST POINT TO A MIDAS DEAL
      *
     C     FOASID        IFNE      *BLANKS                                                  MD021204
      *                                                                                     MD021204
     C     FOASID        CHAIN     MMDELFOI                           99
     C     *IN99         IFEQ      '1'                                                        256482
     C                   MOVEL     FOASID        WDDLNO            6 0                        256482
     C     WDDLNO        CHAIN     MMDEALLL                           99                      256482
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0104'     MsgIdArr(Ix)
     C**********         MOVEL     FOASID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOASID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOASID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ELSE                                                                 256482
     C                   MOVEL     H@DN38        DDDLNO                                       256482
     C                   END
      *
     C                   ELSE                                                                 256482
     C                   MOVEL     HKDN38        DDDLNO
     C                   ENDIF                                                                256482
      *                                                                                     MD021204
     C                   ENDIF                                                              MD021204
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND DEAL NUMBER/VALUE DATE/SEQUENCE
      *****************************************************************
     C     VAL           BEGSR
     C*
     C**  Check that the action code is valid; if authorizations are
     C**  not in the system, then action code X is not allowed.
     C*
     C     BNMMAU        IFEQ      'N'
     C     BNMMRA        ANDEQ     'N'                                                        176841
     C     DDACTN        IFNE      *BLANK                                                     176841
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0161'     MsgIdArr(Ix)
     C                   END
     C                   ELSE                                                             176841
     C*
     C*****BNMMAU        IFNE      'N'                                                    176841
     C     DDACTN        IFNE      *BLANK                                                 176841
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0160'     MsgIdArr(Ix)
     C                   END
     C                   END                                                                  176841
     C*
     C**  Validate that key fields are numeric or blank.
     C*
     C**  Validate that deal number is numeric & not blank.
     C*
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C*
     C     DDDLNO        IFEQ      *BLANK
     C     *IN98         OREQ      '0'
     C     *IN99         OREQ      '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0145'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C*
     C**  Set up the deal number as a numeric field.
     C*
     C                   MOVE      DDDLNO        @@DLNO            6 0
     C*                                                                                      BUG6534
     C**  Place the rest of the deal number validation here for it to be picked up           BUG6534
     C**  on the new DEAM first input screen.                                                BUG6534
     C*                                                                                      BUG6534
     C     DDACTN        IFEQ      'I'                                                       BUG6534
     C                   EXSR      VALACF                                                    BUG6534
     C                   END                                                                 BUG6534
                                                                                              CER043
      ** Default value date if CER043 is switched on and value date is blanks                 CER043
     C                   IF        CER043 = 'Y' AND DDVDAT = *BLANKS                          CER043
     C                   CALLB     'ZDATE2'                                                   CER043
     C                   PARM      BJRDNB        ZDAYNO                                       CER043
     C                   PARM                    BJDFIN                                       CER043
     C                   PARM      *ZEROS        ZDATE                                        CER043
     C                   PARM      *BLANK        ZADATE                                       CER043
     C                   MOVE      ZDATE         DDVDAT                                       CER043
     C                   ENDIF                                                                CER043
      *
      **  Validate that the value date is a valid date.
      *
     C                   MOVE      DDVDAT        ValueDate
     C*
     C                   TESTN                   DDVDAT               98
     C                   MOVE      DDVDAT        @@TEST
     C                   TESTZ                   @@TEST                   99
     C*
     C     *IN98         IFEQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVEL     DDVDAT        @DAT
     C                   CALL      'ZA0270'
     C                   PARM                    @DAT              6 0
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE            1
     C                   PARM                    @VDYNO            5 0
     C                   END
     C*
     C**  If the return code is 1 then the input date is invalid or
     C**  non-numeric.
     C*
     C     @RTCDE        IFEQ      '1'
     C     DDVDAT        OREQ      *BLANKS
     C     *IN99         OREQ      '0'
     C     *IN98         OREQ      '0'
     C*
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMM0125'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C*
     C                   ELSE
     C*
     C** Load value date to numeric keyfield,in YYYYMMDD format
     C                   Z-ADD     0             @KVALD
     C                   MOVE      @DSPY         @VYEAR
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPD         @VDDD
     C                   ELSE
     C                   MOVE      @DSPD         @VDMM
     C                   END
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPM         @VDMM
     C                   ELSE
     C                   MOVE      @DSPM         @VDDD
     C                   END
     C*
     C** Century
     C     @VYEAR        IFGE      72
     C     @VDYY         ADD       1900          @VDYY
     C                   ELSE
     C     @VDYY         ADD       2000          @VDYY
     C                   END
     C                   END
      *
      ** Sequence no. must be numeric if entered
      *
     C     DDDS38        IFNE      *BLANKS
     C*
     C                   TESTN                   DDDS38               98
     C                   MOVE      DDDS38        @@TEST
     C                   TESTZ                   @@TEST                   99
     C                   END
     C*
     C     DDDS38        IFEQ      *BLANKS
     C*
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C*
     C     DDDS38        IFEQ      *BLANKS
     C                   Z-ADD     *LOVAL        @DEAMS
     C                   ELSE
     C                   MOVE      DDDS38        @DEAMS
     C                   END
     C*
     C                   ELSE
     C*
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDS38'      FldNameArr(Ix)
     C                   MOVEL     'MMM0196'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C*
     C** If action code is 'I' sequence no. NOT needed otherwise sequence
     C** number must be entered
     C     DDACTN        IFNE      'I'
     C     DDDS38        ANDEQ     *BLANKS
     C*
     C     DDACTN        OREQ      'I'
     C     DDDS38        ANDNE     *BLANKS
     C     WFRONTID      ANDNE     'TO'                                         CPB002
                                                                                              CSC024
      ***Allow*entry*for*Sequence*number*for*Insert*if*CSC024*is                       CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for Sequence number for Insert if CSC054 is                              CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C     DDACTN        IFNE      'I'                                                        CSC024
     C     DDACTN        OREQ      'I'                                                        CSC024
     C*****CSC024        ANDNE     'Y'                                                 CSC024 CSC054
     C     CSC054        ANDNE     'Y'                                                        CSC054
     C     DDACTN        OREQ      'I'                                                        CSC024
     C*****WOMEInd       ANDNE     'Y'                                                 CSC024 CSC054
     C     WPEAInd       ANDNE     'Y'                                                        CSC054
                                                                                              CSC024
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDS38'      FldNameArr(Ix)
     C                   MOVEL     'MMM0146'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   END
     C*
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
     C*
     C**  If the deal number is blank, it is an error.
     C*
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
     C*
     C**  If there is no valid record on MMDEAMLL, it is an error.
     C*
     C     @DEAMK        CHAIN     MMDEAMLL                           65
     C*
     C**  Check for a valid record.
     C*
     C     *IN65         IFEQ      '1'
     C     HNDLTF        ORNE      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ELSE
     C*
     C**  If the deal status is not C,A or R, it is an error.
     C*
     C     HNDSTS        IFNE      'C'
     C     HNDSTS        ANDNE     'A'
     C     HNDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0148'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ELSE                                                   CSE006
     C*                                                                         CSE006
     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.          CSE006
     C*                                                                         CSE006
     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks           CSE006
     C                   MOVE      'N'           OKDLNO                         CSE006
     C                   MOVE      'N'           OKVDAT                         CSE006
     C                   MOVE      'N'           OKSEQN                         CSE006
     C                   ADD       1             Ix                             CSE006
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                 CSE006
     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                   CSE006
     C                   GOTO      EVALAE                                       CSE006
     C                   END                                                    CSE006
     C                   END
     C                   END
     C*
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - VALIDATION OF ACTION CODE 'X'
      *****************************************************************
     C     VALACX        BEGSR
     C*
     C**  If the deal number is blank, it is an error.
     C*
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
     C*
     C* CHECK IF PREVIOUS DEAMS ARE AUTHORISED OR DELETED
     C*
     C*****@DEAMK        SETLL     MMDEAMLL                           65                      191881
     C*****@DEAMK        READPE    MMDEAMLL                               65                  191881
     C     @@DLNO        SETLL     MMDEAMLL                           65                      191881
     C     @@DLNO        READPE    MMDEAMLL                               65                  191881
B2   C     *IN65         DOWEQ     '0'
B3   C     HNDSTS        IFNE      'A'
     C     HNDDLT        ANDEQ     ' '
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM015A'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
X3   C                   ELSE
     C*****@DEAMK        READPE    MMDEAMLL                               65                  191881
     C     @@DLNO        READPE    MMDEAMLL                               65                  191881
E3   C                   ENDIF
E2   C                   ENDDO
     C*
     C**  If there is no valid, undeleted record on MMDEAMLL, it is an
     C**  error.
     C*
     C     @DEAMK        CHAIN     MMDEAMLL                           65
     C*
     C     *IN65         IFEQ      '1'
     C     HNDLTF        ORNE      *BLANK
     C     HNDDLT        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0147'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   ELSE
     C/COPY WNCPYSRC,MMDEAMIC02
     C*
     C** Deam status indicator  must be 'C' or 'R'
     C*
     C     HNDSTS        IFNE      'C'
     C     HNDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0290'     MsgIdArr(Ix)
     C                   GOTO      EVALAX                                                     208100
     C                   ELSE
     C*
     C**  Access Original Deal:
     C**  If no valid record is found, or the record does not have a
     C**  status of 'A' or 'R', it is an error.
     C*
     C     HNDA38        CHAIN     MMDEALLL                           65
     C*
      **  If the deal status is not C, R or A it is an error.                                BUG6534
     C     *IN65         IFEQ      '1'
     C     H@DSTS        ORNE      'A'
     C     H@DSTS        ANDNE     'R'
     C     H@DSTS        ANDNE     'C'                                                       BUG6534
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0173'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   ELSE                                                   CSE006
     C*                                                                         CSE006
     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.          CSE006
     C*                                                                         CSE006
     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks           CSE006
     C                   MOVE      'N'           OKDLNO                         CSE006
     C                   MOVE      'N'           OKVDAT                         CSE006
     C                   MOVE      'N'           OKSEQN                         CSE006
     C                   ADD       1             Ix                             CSE006
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                 CSE006
     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                   CSE006
     C                   GOTO      EVALAX                                       CSE006
     C                   END                                                    CSE006
     C                   END
     C*
     C                   END
     C                   END
     C/COPY WNCPYSRC,MMDEAMIC08
                                                                                              CSD015
      ** If Compliance Watch is enabled, check for pending cases.                             CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND                                           CSD015
     C                             W1EWLC = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             (CSC011 = 'Y' AND                                          CSD015
     C                             S1MAIN = LIBR)                                             CSD015
                                                                                              CSD015
      ** Check if Deal Amendments details are being reviewed                                  CSD015
                                                                                              CSD015
     C                   EVAL      KFuncType = *BLANKS                                        CSD015
     C                   EVAL      KIden = *BLANKS                                            CSD015
     C                   EVAL      KBranch = *BLANKS                                          CSD015
                                                                                              CSD015
     C                   MOVEL     'MMDEAMPP'    KFuncType                                    CSD015
     C                   MOVE      HNDA38        WHNDA3                                       CSD015
     C                   MOVE      HNVDYY        WHNVDY                                       CSD015
     C                   MOVE      HNVDMM        WHNVDM                                       CSD015
     C                   MOVE      HNVDDD        WHNVDD                                       CSD015
     C                   MOVE      HNDS38        WHNDS3                                       CSD015
     C                   EVAL      KIden = WHNDA3 + WHNVDY + WHNVDM +                         CSD015
     C                             WHNVDD + WHNDS3                                            CSD015
     C                   MOVEL     HNBRCA        KBranch                                      CSD015
                                                                                              CSD015
     C     KCWHT         CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) AND                                       CSD015
     C                             W3TREL <> 'Y'                                              CSD015
     C                   EVAL      OKACTN = 'N'                                               CSD015
     C                   EVAL      OKDLNO = 'N'                                               CSD015
     C                   EVAL      Ix = Ix + 1                                                CSD015
     C                   EVAL      FldNameArr(Ix) = 'DDDLNO'                                  CSD015
     C                   EVAL      MsgIdArr(Ix) = 'MMM0797'                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Retrieve latest content of DTAARA/ZMUSER                                            BUG4422
      *                                                                                      BUG4422
     C                   IN        ZMUSER                                                    BUG4422
     C                   UNLOCK    ZMUSER                                                    BUG4422
                                                                                             BUG4422
      ** Determine whether program is running interactively or in batch                       CAP185
      **  ( 0 = batch 1 = interactive)                                                        CAP185
      *                                                                                       CAP185
     C                   CALLB     'ZARTVJOBA'                                                CAP185
     C                   PARM                    @Return           6                          CAP185
     C                   PARM                    @Type             1                          CAP185
      *                                                                                       CAP185
     C                   IF        CAP185 = 'N' OR                                            CAP185
     C                             CAP185 = 'Y' AND                                           CAP185
     C                             @AUTHO = 'N' OR                                            CAP185
     C                             CAP185 = 'Y' AND                                           CAP185
     C                             @AUTHO = 'Y' AND                                           CAP185
     C                             @TYPE = '1'                                                CAP185
      *                                                                                       CDL010
      ** User cannot authorise an authorised deal or deal requires                            CDL010
      ** double authorisation.                                                                CDL010
      *                                                                                       CDL010
     C     CDL010        IFEQ      'Y'                                                        CDL010
     C     HNUSER        ANDEQ     ZUSER                                                      CDL010
     C                   MOVE      'N'           OKDLNO                                       CDL010
     C                   ADD       1             Ix                                           CDL010
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL010
     C                   MOVEL     'MMM0702'     MsgIdArr(Ix)                                 CDL010
     C                   END                                                                  CDL010
     C                   ENDIF                                                                CAP185
     C*
     C     EVALAX        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
     C*
     C**  Check that the deal does not exist on the
     C**  MMDEAMLL file; if it does it is an error.
     C     @DEAMK        CHAIN     MMDEAMLL                           65
     C     *IN65         IFEQ      '0'
     C*
     C** Record already exists
     C*****HNDLTF        IFEQ      *BLANKS                                                   BUG7537
     C     HNDDLT        IFEQ      *BLANKS                                                   BUG7537
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0149'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END
     C                   END
     C*                                                                                       CDL017
     C**  More that one EM amendment per Deal is not allowed                                  CDL017
     C     DDMTYP        IFEQ      'EM'                                                       CDL017
     C                   MOVE      DDDLNO        KeyDealNo                                    CDL017
     C                   MOVE      'EM'          KeyAmdTyp         2                          CDL017
     C     @DMKY3        CHAIN     MMDEAML3                           65                      CDL017
     C     *IN65         IFEQ      '0'                                                        CDL017
     C                   MOVE      'N'           OKDLNO                                       CDL017
     C                   ADD       1             Ix                                           CDL017
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL017
     C                   MOVEL     'MMM0353'     MsgIdArr(Ix)                                 CDL017
     C                   GOTO      EVALAI                                                     CDL017
     C                   ENDIF                                                                CDL017
     C                   ENDIF                                                                CDL017
     C*
     C** check that the Original Deal record exists
     C     @@DLNO        CHAIN     MMDEALLL                           65
     C*
     C** Check deal type is valid
     C*
     C** INITIALISE INDICATORS
     C                   Z-ADD     1             @N                2 0
     C                   MOVE      '0'           *IN75
     C*
     C     H@MTYP        LOOKUP    @DT2(@N)                               75
                                                                                CDL006
      ** If Dealing Fiduciary is installed and the deal type not found          CDL006
      ** in the first deal type array(@DT2), lookup from the newly crea         CDL006
      ** ted fiduciary deal type array.                                         CDL006
                                                                                CDL006
     C                   If        CDL006 = 'Y' and *IN75 = *Off                CDL006
     C     H@MTYP        LookUp    FIDTYP(@N)                             75    CDL006
     C                   EndIf                                                  CDL006
     C*
     C     *IN65         IFEQ      '1'
     C     *IN75         OREQ      '0'
     C     H@DLTF        ORNE      ' '
     C     H@DDLT        ORNE      ' '
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END
      *                                                                                      BUG5092
      ** Amendment type 'EM' not allowed for Blocked Deals                                   BUG5092
      *                                                                                      BUG5092
     C     DDMTYP        IFEQ      'EM'                                                      BUG5092
     C     HKBLKA        ANDEQ     'Y'                                                       BUG5092
     C                   MOVE      'N'           OKDLNO                                      BUG5092
     C                   ADD       1             Ix                                          BUG5092
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG5092
     C                   MOVEL     'MMM0337'     MsgIdArr(Ix)                                BUG5092
     C                   GOTO      EVALAI                                                    BUG5092
     C                   ENDIF                                                               BUG5092
      *                                                                                      BUG8360
      ** 'EM' should not be allowed if rollover indicator is automatic.                      BUG8360
      *                                                                                      BUG8360
     C     DDMTYP        IFEQ      'EM'                                                      BUG8360
     C     HKAURO        ANDEQ     'A'                                                       BUG8360
     C                   MOVE      'N'           OKDLNO                                      BUG8360
     C                   ADD       1             Ix                                          BUG8360
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG8360
     C                   MOVEL     'MMM0360'     MsgIdArr(Ix)                                BUG8360
     C                   GOTO      EVALAI                                                    BUG8360
     C                   ENDIF                                                               BUG8360
      *                                                                                      BUG8360
      ** 'EM' should not be allowed if Rollover indicator is 'Y' and deal is                 BUG8360
      ** collateral and CGL014 is installed.                                                 BUG8360
      *                                                                                      BUG8360
     C     DDMTYP        IFEQ      'EM'                                                      BUG8360
     C     HKAURO        ANDEQ     'Y'                                                       BUG8360
     C     HKCOLF        ANDEQ     'Y'                                                       BUG8360
     C     CGL014        ANDEQ     'Y'                                                       BUG8360
     C                   MOVE      'N'           OKDLNO                                      BUG8360
     C                   ADD       1             Ix                                          BUG8360
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG8360
     C                   MOVEL     'MMM0361'     MsgIdArr(Ix)                                BUG8360
     C                   GOTO      EVALAI                                                    BUG8360
     C                   ENDIF                                                               BUG8360
      *                                                                                      BUG8360
      ** 'EM' is not allowed for rolled over deal.                                           BUG8360
      *                                                                                      BUG8360
     C     DDMTYP        IFEQ      'EM'                                                      BUG8360
     C     HKROBY        ANDNE     *BLANKS                                                   BUG8360
     C                   MOVE      'N'           OKDLNO                                      BUG8360
     C                   ADD       1             Ix                                          BUG8360
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG8360
     C                   MOVEL     'MMM0362'     MsgIdArr(Ix)                                BUG8360
     C                   GOTO      EVALAI                                                    BUG8360
     C                   ENDIF                                                               BUG8360
     C*
     C** Output Midas deal type
     C*
     C                   MOVEL     H@MTYP        HNOMDT
     C*
     C** Check that the deal does not exist on
     C** DEALSH file else, it is an error
     C*
     C     @@DLNO        CHAIN     DEALSH                             65
     C*
     C** Record already exists in DEALSH file
     C     *IN65         IFEQ      '0'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ELSE                                                    CSE006
     C*                                                                          CSE006
     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.           CSE006
     C*                                                                          CSE006
     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks            CSE006
     C                   MOVE      'N'           OKDLNO                          CSE006
     C                   MOVE      'N'           OKVDAT                          CSE006
     C                   MOVE      'N'           OKSEQN                          CSE006
     C                   ADD       1             Ix                              CSE006
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                  CSE006
     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                    CSE006
     C                   GOTO      EVALAI                                        CSE006
     C                   END                                                     CSE006
     C                   END
     C*
     C** Check valid deal for key fields
     C                   EXSR      CHKKEYFLDS
     C*
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG6534
      * VALACF - VALIDATION OF ACTION CODE 'I' FOR FIRST SCREEN                              BUG6534
      *****************************************************************                      BUG6534
     C     VALACF        BEGSR                                                               BUG6534
      *                                                                                      BUG7537
     C** Check that the deal exists on DEALS, otherwise                                      BUG7537
     C** issue an appropirate error message.                                                 BUG7537
     C*                                                                                      BUG7537
     C     @@DLNO        CHAIN     MMDEALLL                           65                     BUG7537
     C*                                                                                      BUG7537
     C** Record does not exist.                                                              BUG7537
     C     *IN65         IFEQ      '1'                                                       BUG7537
     C     H@DDLT        ORNE      ' '                                                       BUG7537
     C                   MOVE      'N'           OKDLNO                                      BUG7537
     C                   ADD       1             Ix                                          BUG7537
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG7537
     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)                                BUG7537
     C                   GOTO      EVALAF                                                    BUG7537
     C                   END                                                                 BUG7537
      *                                                                                     BUG16961
      ** Check deal type is valid                                                           BUG16961
      ** Initialise indicators                                                              BUG16961
      *                                                                                     BUG16961
     C                   Z-ADD     1             @N                2 0                      BUG16961
     C                   MOVE      '0'           *IN75                                      BUG16961
      *                                                                                     BUG16961
     C     H@MTYP        LOOKUP    @DT2(@N)                               75                BUG16961
                                                                                            BUG16961
      *                                                                                     BUG16961
      ** If Dealing Fiduciary is installed and the deal type not found                      BUG16961
      ** in the first deal type array(@DT2), lookup from the newly created                  BUG16961
      ** fiduciary deal type array                                                          BUG16961
      *                                                                                     BUG16961
                                                                                            BUG16961
     C                   If        CDL006 = 'Y' and *IN75 = *Off                            BUG16961
     C     H@MTYP        LookUp    FIDTYP(@N)                             75                BUG16961
     C                   EndIf                                                              BUG16961
      *                                                                                     BUG16961
     C     *IN65         IFEQ      '1'                                                      BUG16961
     C     *IN75         OREQ      '0'                                                      BUG16961
     C     H@DLTF        ORNE      ' '                                                      BUG16961
     C     H@DDLT        ORNE      ' '                                                      BUG16961
     C                   MOVE      'N'           OKDLNO                                     BUG16961
     C                   MOVE      'N'           OKVDAT                                     BUG16961
     C                   MOVE      'N'           OKSEQN                                     BUG16961
     C                   ADD       1             Ix                                         BUG16961
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                             BUG16961
     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)                               BUG16961
     C                   GOTO      EVALAF                                                   BUG16961
     C                   ENDIF                                                              BUG16961
      *                                                                                     BUG16961
      ** Check that the deal does not exist on                                              BUG16961
      ** DEALSH file else, it is an error                                                   BUG16961
      *                                                                                     BUG16961
     C     @@DLNO        CHAIN     DEALSH                             65                    BUG16961
      *                                                                                     BUG16961
      ** Record already exists in DEALSH file                                               BUG16961
      *                                                                                     BUG16961
     C     *IN65         IFEQ      '0'                                                      BUG16961
     C                   MOVE      'N'           OKDLNO                                     BUG16961
     C                   MOVE      'N'           OKVDAT                                     BUG16961
     C                   MOVE      'N'           OKSEQN                                     BUG16961
     C                   ADD       1             Ix                                         BUG16961
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                             BUG16961
     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)                               BUG16961
     C                   GOTO      EVALAF                                                   BUG16961
     C                   ENDIF                                                              BUG16961
      *                                                                                      BUG7537
      ** Remove the rest of processing below as this will be                                 BUG7537
      ** handled in main screen validation subr/VALACI.                                      BUG7537
     C***********                                                                    BUG6534 BUG7537
     C****Check that the deal does not exist on the                                  BUG6534 BUG7537
     C****MMDEAMLL file; if it does it is an error.                                  BUG6534 BUG7537
     C*****@DEAMK        CHAIN     MMDEAMLL                           65             BUG6534 BUG7537
     C******IN65         IFEQ      '0'                                               BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C** Record already exists                                                       BUG6534 BUG7537
     C*****HNDLTF        IFEQ      *BLANKS                                           BUG6534 BUG7537
     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
     C***********        ADD       1             Ix                                  BUG6534 BUG7537
     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
     C***********        MOVEL     'MMM0149'     MsgIdArr(Ix)                        BUG6534 BUG7537
     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
     C***********        END                                                         BUG6534 BUG7537
     C***********        END                                                         BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C****More that one EM amendment per Deal is not allowed                         BUG6534 BUG7537
     C*****DDMTYP        IFEQ      'EM'                                              BUG6534 BUG7537
     C***********        MOVE      DDDLNO        KeyDealNo                           BUG6534 BUG7537
     C***********        MOVE      'EM'          KeyAmdTyp         2                 BUG6534 BUG7537
     C*****@DMKY3        CHAIN     MMDEAML3                           65             BUG6534 BUG7537
     C******IN65         IFEQ      '0'                                               BUG6534 BUG7537
     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
     C***********        ADD       1             Ix                                  BUG6534 BUG7537
     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
     C***********        MOVEL     'MMM0353'     MsgIdArr(Ix)                        BUG6534 BUG7537
     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
     C***********        ENDIF                                                       BUG6534 BUG7537
     C***********        ENDIF                                                       BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C***check that the Original Deal record exists                                  BUG6534 BUG7537
     C*****@@DLNO        CHAIN     MMDEALLL                           65             BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C***Check deal type is valid                                                    BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C***INITIALISE INDICATORS                                                       BUG6534 BUG7537
     C***********        Z-ADD     1             @N                2 0               BUG6534 BUG7537
     C***********        MOVE      '0'           *IN75                               BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C*****H@MTYP        LOOKUP    @DT2(@N)                               75         BUG6534 BUG7537
      ***********                                                                    BUG6534 BUG7537
      ***If Dealing Fiduciary is installed and the deal type not found               BUG6534 BUG7537
      ***in the first deal type array(@DT2), lookup from the newly crea              BUG6534 BUG7537
      ***ted fiduciary deal type array.                                              BUG6534 BUG7537
      ***********                                                                    BUG6534 BUG7537
     C***********        If        CDL006 = 'Y' and *IN75 = *Off                     BUG6534 BUG7537
     C*****H@MTYP        LookUp    FIDTYP(@N)                             75         BUG6534 BUG7537
     C***********        EndIf                                                       BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C******IN65         IFEQ      '1'                                               BUG6534 BUG7537
     C******IN75         OREQ      '0'                                               BUG6534 BUG7537
     C*****H@DLTF        ORNE      ' '                                               BUG6534 BUG7537
     C*****H@DDLT        ORNE      ' '                                               BUG6534 BUG7537
     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
     C***********        MOVE      'N'           OKVDAT                              BUG6534 BUG7537
     C***********        MOVE      'N'           OKSEQN                              BUG6534 BUG7537
     C***********        ADD       1             Ix                                  BUG6534 BUG7537
     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
     C***********        MOVEL     'MMM0150'     MsgIdArr(Ix)                        BUG6534 BUG7537
     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
     C***********        END                                                         BUG6534 BUG7537
      ***********                                                                    BUG6534 BUG7537
      ** Amendment type 'EM' not allowed for Blocked Deals                           BUG6534 BUG7537
      ************                                                                   BUG6534 BUG7537
     C*****DDMTYP        IFEQ      'EM'                                              BUG6534 BUG7537
     C*****HKBLKA        ANDEQ     'Y'                                               BUG6534 BUG7537
     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
     C***********        ADD       1             Ix                                  BUG6534 BUG7537
     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
     C***********        MOVEL     'MMM0337'     MsgIdArr(Ix)                        BUG6534 BUG7537
     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
     C***********        ENDIF                                                       BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C***Output Midas deal type                                                      BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C***********        MOVEL     H@MTYP        HNOMDT                              BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C***Check that the deal does not exist on                                       BUG6534 BUG7537
     C***DEALSH file else, it is an error                                            BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C*****@@DLNO        CHAIN     DEALSH                             65             BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C***Record already exists in DEALSH file                                        BUG6534 BUG7537
     C******IN65         IFEQ      '0'                                               BUG6534 BUG7537
     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
     C***********        MOVE      'N'           OKVDAT                              BUG6534 BUG7537
     C***********        MOVE      'N'           OKSEQN                              BUG6534 BUG7537
     C***********        ADD       1             Ix                                  BUG6534 BUG7537
     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
     C***********        MOVEL     'MMM0150'     MsgIdArr(Ix)                        BUG6534 BUG7537
     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
     C***********        ELSE                                                        BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C****If*CSE006*is*'Y'*and*deal*is*not*a*Repo*deal*it*is*an*error.               BUG6534 BUG7537
     C***********                                                                    BUG6534 BUG7537
     C***********        IF        CSE006 = 'Y' and HKDRID <> *Blanks                BUG6534 BUG7537
     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
     C***********        MOVE      'N'           OKVDAT                              BUG6534 BUG7537
     C***********        MOVE      'N'           OKSEQN                              BUG6534 BUG7537
     C***********        ADD       1             Ix                                  BUG6534 BUG7537
     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
     C***********        MOVEL     'MMA0793'     MsgIdArr(Ix)                        BUG6534 BUG7537
     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
     C***********        END                                                         BUG6534 BUG7537
     C***********        END                                                         BUG6534 BUG7537
     C*                                                                                      BUG6534
     C     EVALAF        ENDSR                                                               BUG6534
      *****************************************************************                      BUG6534
      /EJECT                                                                                 BUG6534
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
     C*
     C**  If the deal number is blank, it is an error.
     C*
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
     C*
     C**  If there is no valid, undeleted record on MMDEAMLL, it is an
     C**  error.
     C*
     C     @DEAMK        CHAIN     MMDEAMLL                           65
     C*
     C     *IN65         IFEQ      '1'
     C     HNDLTF        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
     C*
     C**  If the deam has been deleted, then it may not be amended.
     C*
     C     HNDDLT        IFNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0151'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
     C*
     C**  If the record exists, its status must be C,A or R.
     C*
     C     HNDSTS        IFNE      'C'
     C     HNDSTS        ANDNE     'A'
     C     HNDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0152'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ELSE                                                    CSE006
     C*                                                                          CSE006
     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.           CSE006
     C*                                                                          CSE006
     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks            CSE006
     C                   MOVE      'N'           OKDLNO                          CSE006
     C                   MOVE      'N'           OKVDAT                          CSE006
     C                   MOVE      'N'           OKSEQN                          CSE006
     C                   ADD       1             Ix                              CSE006
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                  CSE006
     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                    CSE006
     C                   GOTO      EVALAA                                        CSE006
     C                   END                                                     CSE006
     C                   END
     C*
     C** Check valid deal for key fields
     C                   EXSR      CHKKEYFLDS
     C*
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
     C*
     C**  If the deal number is blank, it is an error.
     C*
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C**  If there is no valid, undeleted record on MMDEAMLL, it is an
     C**  error.
     C*
     C     @DEAMK        CHAIN     MMDEAMLL                           65
     C*
     C     *IN65         IFEQ      '1'
     C     HNDLTF        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C**  If a valid record exists and the deal deleted indicator is
     C**  not blank, it is an error.
     C*
     C     HNDDLT        IFNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0151'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C** if the record exists the status must be C A or R
     C*
     C     HNDSTS        IFNE      'C'
     C     HNDSTS        ANDNE     'A'
     C     HNDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0156'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C**If amendment type is 'PI' execute process 'Check deal amendment
     C** principle'   : MMP0082.
     C*
     C     DDMTYP        IFEQ      'PI'
     C     DDAMNP        IFNE      *BLANKS
     C*
     C                   EXSR      CHKDEAMPPL
     C*
     C** If invalid exit routine
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   GOTO      EVALAD
     C                   END
     C*
     C**  Reset deams file if amount passed principle validation check
     C**  Access only if current deam is not deam last accessed.
     C     @@DLNO        IFNE      HNDA38
     C     @VDYY         ORNE      HNVDYY
     C     @VDMM         ORNE      HNVDMM
     C     @VDDD         ORNE      HNVDDD
     C     @DEAMS        ORNE      HNDS38
     C*
     C** deam must exist
     C     @DEAMK        CHAIN     MMDEAMLL                           65
     C     *IN65         IFEQ      '1'
     C     HNDLTF        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C                   END
     C                   END
     C                   END
     C*                                                                         CSE006
     C     HNDA38        CHAIN     MMDEALLL                           65        CSE006
     C*                                                                         CSE006
     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.          CSE006
     C*                                                                         CSE006
     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks           CSE006
     C                   MOVE      'N'           OKDLNO                         CSE006
     C                   MOVE      'N'           OKVDAT                         CSE006
     C                   MOVE      'N'           OKSEQN                         CSE006
     C                   ADD       1             Ix                             CSE006
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                 CSE006
     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                   CSE006
     C                   GOTO      EVALAD                                       CSE006
     C                   END                                                    CSE006
     C*
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*      CHKKEYFLDS - Check valid deal for key fields
     C*****************************************************************
     C     CHKKEYFLDS    BEGSR
     C*
     C** Access MMDEALLL if this has not been done for this deal number
     C     @@DLNO        IFNE      H@DN38
     C     @@DLNO        CHAIN     MMDEALLL                           65
     C     *IN65         IFEQ      '1'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0184'     MsgIdArr(Ix)
     C                   GOTO      CHKKEYEND
     C                   END
     C                   END
     C*
     C** Convert dates used in compares to midas day numbers
     C*
     C                   Z-ADD     H@SLDT        DateIn
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   Z-ADD     DateOut       @SLDYN            5 0
     C*
     C                   Z-ADD     H@IADT        DateIn
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   Z-ADD     DateOut       @IADYN            5 0
     C*
     C     H@RCID        IFEQ      'HK'
     C                   Z-ADD     H@MATD        DateIn
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   Z-ADD     DateOut       @MDAYN            5 0
     C                   ELSE
     C                   Z-ADD     0             @MDAYN
     C                   END
     C*
     C     @VDYNO        IFLT      @SLDYN
     C     @VDYNO        ORLT      @IADYN
     C/COPY WNCPYSRC,MMDEAMIC05
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMM0153'     MsgIdArr(Ix)
     C                   GOTO      CHKKEYEND
     C/COPY WNCPYSRC,MMDEAMIC06
     C                   END
     C*
     C** Value date must be = or < than maturity date if maturity date
     C** is present
     C     @MDAYN        IFNE      0
     C     @VDYNO        ANDGE     @MDAYN
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMM0154'     MsgIdArr(Ix)
     C                   GOTO      CHKKEYEND
     C                   END
     C*
     C** For deam type 'SI' the deam value date must not be the same
     C** as the value date of a deam already existing on the deal.
     C** Also applys to deam type 'CI'.
     C     DDMTYP        IFEQ      'SI'
     C     DDACTN        ANDEQ     'I'
     C     DDMTYP        OREQ      'CI'
     C     DDACTN        ANDEQ     'I'
      *                                                                                       185658
      ** Save HNOMDT value.                                                                   185658
      *                                                                                       185658
     C                   MOVE      HNOMDT        W@OMDT            2                          185658
     C*
     C** Check for all possible deam sequence  values
     C                   MOVE      *LOVAL        @DEAMS
     C     @DEAMK        SETLL     MMLVDMLL
     C                   READ      MMLVDMLL                               65
     C*
     C**  Place value date from files into same sequence as display (DDMMYY)
     C                   MOVE      @DMVYR        @DMVY
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DMVMT        @DMVM
     C                   MOVE      @DMVDY        @DMVD
     C                   ELSE
     C                   MOVE      @DMVMT        @DMVD
     C                   MOVE      @DMVDY        @DMVM
     C                   END
     C*
     C**  If a live record is found then a deam already exists
     C**  for the value date & deal number
     C     *IN65         IFEQ      '0'
     C     @@DLNO        ANDEQ     HNDA38
     C     DDVDAT        ANDEQ     @DMVDT
      *
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C     DDMTYP        IFEQ      'SI'
     C                   MOVEL     'MMM0577'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     'MMM2548'     MsgIdArr(Ix)
     C                   END
     C                   END
      *                                                                                       185658
      ** Restore HNOMDT value.                                                                185658
      *                                                                                       185658
     C                   MOVE      W@OMDT        HNOMDT                                       185658
     C                   END
     C/COPY WNCPYSRC,MMDEAMIC09
     C*
     C     CHKKEYEND     ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*          CHKDEAMPPL      - Check deal amendment principle
     C*****************************************************************
     C     CHKDEAMPPL    BEGSR
     C*
     C**  Access Original Deal:
     C**  If no valid record is found, or the record does not have a
     C**  status of 'A' or 'R', it is an error.
     C*
     C     HNDA38        CHAIN     MMDEALLL                           65
     C*
     C     *IN65         IFEQ      '1'
     C     H@DSTS        ORNE      'A'
     C     H@DSTS        ANDNE     'R'
     C     H@DSTS        ANDNE     'C'                                                       BUG4849
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0165'     MsgIdArr(Ix)
     C                   GOTO      CHKDEAMEND
     C                   END
     C*
     C** If deal amount is -ve make +ve for calculation
     C     H@AMNP        IFLT      0
     C                   Z-SUB     H@AMNP        H@AMNP
     C                   END
     C*
     C** Process all deams on file for this deal
     C*
     C                   MOVE      DDDLNO        KeyDealNo         6 0
     C                   MOVE      *LOVAL        KeyValDatD        2 0
     C                   MOVE      *LOVAL        KeyValDatM        2 0
     C                   MOVE      *LOVAL        KeyValDatY        4 0
     C                   MOVE      *LOVAL        KeySeqNum         3 0
     C                   MOVE      'N'           ErrorFound
     C                   MOVE      *ALL' '       DlnoOnFile        6
     C     @DMKY2        SETLL     MMLVDMLL
     C     *IN65         DOUEQ     '1'
     C     ErrorFound    OREQ      'Y'
     C                   READ      MMLVDMLL                               65
     C                   MOVE      HNDA38        DlnoOnFile
     C*
     C**  If a live record is found then a deam exists
     C**  for the deal number
     C     *IN65         IFEQ      '0'
     C     DlnoOnFile    ANDEQ     DDDLNO
     C*
     C**  Place value date from files into same sequence as display (DDMMYY)
     C                   MOVE      @DMVYR        @DMVY
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DMVMT        @DMVM
     C                   MOVE      @DMVDY        @DMVD
     C                   ELSE
     C                   MOVE      @DMVMT        @DMVD
     C                   MOVE      @DMVDY        @DMVM
     C                   END
     C*
     C** If DEAM amount is -ve make +ve for calculation
     C     HNAMNP        IFLT      0
     C                   Z-SUB     HNAMNP        HNAMNP
     C                   END
     C*

     C     H@AMNP        IFLT      *ZERO
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0295'     MsgidArr(Ix)
     C                   GOTO      CHKDEAMEND
     C                   END
     C*
     C** If current transaction is a delete of a 'PI' & record read
     C** is record to be deleted ignore it
     C*
     C     DDMTYP        IFEQ      'PI'
     C*
     C** Place sequence number into alpha field for comparison
     C                   MOVE      *BLANKS       SeqNoAlpha
     C                   MOVE      HNDS38        SeqNoAlpha        3
     C     DDACTN        IFNE      'D'
     C*
     C     DDVDAT        ORNE      @DMVDT
     C     SeqNoAlpha    ORNE      DDDS38
     C*
     C** If record read is PI add deam amount to deal principle
     C     HNMTYP        IFEQ      'PI'
     C     H@AMNP        ADD       HNAMNP        H@AMNP
     C                   END
     C                   END
     C** Move end to after check if PCPL >= 0.
     C*
     C** If read transaction is a 'PD' subtract deam amount
     C** from deal principle
     C     HNMTYP        IFEQ      'PD'
     C     H@AMNP        SUB       HNAMNP        H@AMNP
     C                   END
     C*
     C** New principle must be = or > 0.
     C     H@AMNP        IFLT      *ZERO
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0295'     MsgidArr(Ix)
     C                   GOTO      CHKDEAMEND
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C/COPY WNCPYSRC,MMDEAMIC10
     C*
     C     CHKDEAMEND    ENDSR
     C*
     C/EJECT
      *****************************************************************
      * ACSSEC - ACCESS SECURITY CHECKING
      *****************************************************************
     C     ACSSEC        BEGSR
     C*
     C* If not multi-branching, check authority to only action code
     C*
     C     BJSBRC        IFNE      *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0292'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
     C*
     C* If multi-branching, check authority to booking branch
     C*
     C     BJSBRC        IFEQ      *BLANK
     C*
     C*  Access file for deal associated  branch code
     C*  for validation.
     C     @@DLNO        CHAIN     MMDEALLL                           65
     C*
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM      H@BRCA        ZBR               3
     C                   PARM                    @@ERR             1 0
     C*
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0290'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C*
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0291'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C*
     C* Check authority to originating branch
     C*
     C     BKOBUV        IFEQ      'Y'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'I'
     C                   CALL      'ZVOBU'
     C                   PARM      H@ORBR        ZOBRX             3
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0287'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0288'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
     C                   END
     C*
     C/COPY WNCPYSRC,MMDEAMIC11
     C     EACSSE        ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
     C     *DTAARA       DEFINE                  ZMUSER                         CAP084
     C                   IN        ZMUSER                                       CAP084
     C                   UNLOCK    ZMUSER                                       CAP084
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   DeamFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKDLNO
     C                   MOVEL     'Y'           OKVDAT
     C                   MOVEL     'Y'           OKSEQN
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      *
      * Value Date
     C                   PARM                    DDVDAT            6
      *
      * Sequence Number
     C                   PARM                    DDDS38            3
      *
      * Deal Amendment Amount
     C                   PARM                    DDAMNP           15
      *
      * Deal Amendment Type
     C                   PARM                    DDMTYP            2
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    DeamFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Deal Number
     C                   PARM                    OKDLNO            1
      *
      * OK - Value Date
     C                   PARM                    OKVDAT            1
      *
      * OK - Sequence Number
     C                   PARM                    OKSEQN            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMDEAMRTV'   DBPGM
      *
      * Key Lists
      *
      * Deal Amendments
     C     @DEAMK        KLIST
     C********           KFLD                    @DEAMN            6 0
     C                   KFLD                    @@DLNO            6 0
     C                   KFLD                    @VDYY             4 0
     C                   KFLD                    @VDMM             2 0
     C                   KFLD                    @VDDD             2 0
     C                   KFLD                    @DEAMS            3 0
      *
      * Deal Amendments 2
     C     @DMKY2        KLIST
     C                   KFLD                    KeyDealNo
     C                   KFLD                    KeyValDatY
     C                   KFLD                    KeyValDatM
     C                   KFLD                    KeyValDatD
     C                   KFLD                    KeySeqNum
      *                                                                                       CDL017
      * Deal Amendments 3                                                                     CDL017
     C     @DMKY3        KLIST                                                                CDL017
     C                   KFLD                    KeyDealNo                                    CDL017
     C                   KFLD                    KeyAmdTyp                                    CDL017
     C*
     C** Key List for MMDEAML0
     C     FrntOfKey     KLIST
     C                   KFLD                    UniqDeamID       20
     C                   KFLD                    OrigDealNo       20
                                                                                              CSD015
      ** Compliance Watch Hit List Key                                                        CSD015
     C     KCWHT         KLIST                                                                CSD015
     C                   KFLD                    KFuncType                                    CSD015
     C                   KFLD                    KIden                                        CSD015
     C                   KFLD                    KBranch                                      CSD015
                                                                                              CSD015
     C*
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS DEAL NUMBER RECORD
      *
     C     1             CHAIN     FDDLNMLL                           99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C     NODLTF        OREQ      '*'
     C                   MOVEL     '1     '      DBKEY
     C                   MOVEL     'FDDLNMLL'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                         CSE006
      ** Access SAR details file to determine if CSE006 is on.                  CSE006
      ** (Repurchase Agreement Enhancements)                                    CSE006
      *                                                                         CSE006
     C                   CALLB     'AOSARDR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM      '*VERIFY'     @OPTN                          CSE006
     C                   PARM      'CSE006'      @SARD                          CSE006
     C     @RTCD         IFNE      *BLANKS                                      CSE006
     C     @RTCD         ANDNE     '*NRF   '                                    CSE006
     C     *LOCK         IN        LDA                                          CSE006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
     C                   MOVEL     '905'         DBASE                          CSE006
     C                   MOVEL     'CSE006'      DBKEY                          CSE006
     C                   OUT       LDA                                          CSE006
     C                   SETON                                        U7U8LR    CSE006
     C                   EXSR      *PSSR                                        CSE006
     C                   END                                                    CSE006
     C     @RTCD         IFEQ      *BLANK                                       CSE006
     C                   MOVEL     'Y'           CSE006            1            CSE006
     C                   END                                                    CSE006
                                                                                              CSD015
      **  Access the SDSTAT Data Area.                                                        CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      **  Access SAR details to see if CSD015 is switched on.                                 CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSD015'      PSARD                                        CSD015
     C     SCSARD        PARM      *BLANKS       DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 906                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
      ** Check if transactions are being monitored by Compliance Watch.                       CSD015
     C                   CALL      'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*KEY   '     @Optn                                        CSD015
     C                   PARM      'DEALING '    PFuncCode                                    CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *BLANKS AND                                       CSD015
     C                             @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'DEALING'                                          CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CSC011 is switched on.                                 CSD015
     C                   EVAL      CSC011 = 'N'                                               CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSC011'      PSARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CSC011'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 908                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      *                                                                                       CDL010
      ** Access SAR details file to determine if CDL010 is on.                                CDL010
      ** (Dealing Transaction Authorisation)                                                  CDL010
      *                                                                                       CDL010
     C                   CALLB     'AOSARDR0'                                                 CDL010
     C                   PARM      *BLANKS       @RTCD             7                          CDL010
     C                   PARM      '*VERIFY'     @OPTN             7                          CDL010
     C                   PARM      'CDL010'      @SARD             6                          CDL010
      *                                                                                       CDL010
     C     @RTCD         IFEQ      *BLANK                                                     CDL010
     C                   MOVE      'Y'           CDL010            1                          CDL010
     C                   ELSE                                                                 CDL010
     C     @RTCD         IFEQ      '*NRF'                                                     CDL010
     C                   MOVE      'N'           CDL010                                       CDL010
     C                   ELSE                                                                 CDL010
      *                                                                                       CDL010
      **    Database error processing                                                         CDL010
      *                                                                                       CDL010
     C     *LOCK         IN        LDA                                                        CDL010
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CDL010
     C                   MOVEL     '906'         DBASE                          * DBERR 906 * CDL010
     C                   MOVEL     'CDL010'      DBKEY                          ************* CDL010
     C                   OUT       LDA                                                        CDL010
     C                   SETON                                        U7U8LR                  CDL010
     C                   EXSR      *PSSR                                                      CDL010
     C                   END                                                                  CDL010
     C                   END                                                                  CDL010
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
     C                   EVAL      DBase  = 3                                                 CSC024
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
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C                   PARM      *BLANKS       P@OP02                                       CSC024
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C                   PARM      *BLANKS       P@OP03                                       CSC024
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C                   PARM      *BLANKS       P@OP04                                       CSC024
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
     C                   EVAL      DBase = 4                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
      *                                                                                      BUG8360
      ** Access CGL014 details in SCSARDPD.                                                  BUG8360
      *                                                                                      BUG8360
     C                   CALLB     'AOSARDR0'                                                BUG8360
     C                   PARM      *BLANKS       @RTCD                                       BUG8360
     C                   PARM      '*VERIFY'     @OPTN                                       BUG8360
     C                   PARM      'CGL014'      @SARD                                       BUG8360
     C     @RTCD         IFNE      *BLANKS                                                   BUG8360
     C     @RTCD         ANDNE     '*NRF   '                                                 BUG8360
     C     *LOCK         IN        LDA                                                       BUG8360
     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG8360
     C                   MOVEL     '909'         DBASE                                       BUG8360
     C                   MOVEL     'CGL014'      DBKEY                                       BUG8360
     C                   OUT       LDA                                                       BUG8360
     C                   SETON                                        U7U8LR                 BUG8360
     C                   EXSR      *PSSR                                                     BUG8360
     C                   END                                                                 BUG8360
     C     @RTCD         IFEQ      *BLANK                                                    BUG8360
     C                   MOVEL     'Y'           CGL014            1                         BUG8360
     C                   END                                                                 BUG8360
                                                                                              CAP185
      ** Check if CAP185 is installed                                                         CAP185
     C                   CALLB     'AOSARDR0'                                                 CAP185
     C                   PARM      *BLANKS       @RTCD             7                          CAP185
     C                   PARM      '*VERIFY'     @OPTN             7                          CAP185
     C                   PARM      'CAP185'      @SARD             6                          CAP185
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP185
     C*                                                                                       CAP185
     C                   IF        @RTCD = *BLANK                                             CAP185
     C                   MOVE      'Y'           CAP185            1                          CAP185
      *                                                                                       CAP185
      ** Determine if Auto-authorise                                                          CAP185
     C     *LIKE         DEFINE    APNAME        @APINAME                                     CAP185
     C                   MOVEL     'DEAM'        @APINAME                                     CAP185
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
     C                   END                                                                  CAP185
     C                   END                                                                  CAP185
      *                                                                                       CAP185
      ** Check if CER043 is switched on                                                       CER043
                                                                                              CER043
     C                   CALL      'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       @RTCD                                        CER043
     C                   PARM      '*VERIFY'     @OPTN                                        CER043
     C                   PARM      'CER043'      @SARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        @RTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ELSE                                                                 CER043
     C                   EVAL      CER043 = 'N'                                               CER043
                                                                                              CER043
     C                   IF        @RTCD <> '*NRF'                                            CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 001                                                CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C/COPY WNCPYSRC,MMDEAMIC03
      *                                                                                       256795
     C                   CALLB     'AOSARDR0'                                                 256795
     C                   PARM      *BLANKS       @RTCD                                        256795
     C                   PARM      '*VERIFY'     @OPTN                                        256795
     C                   PARM      'CDL052'      @SARD                                        256795
     C     @RTCD         IFEQ      *BLANK                                                     256795
     C                   MOVEL     'Y'           CDL052            1                          256795
     C                   else                                                                 256795
     C                   MOVEL     'N'           CDL052            1                          256795
     C                   ENDIF                                                                256795
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS AND                                       CSD083
     C                             @RTCD <> '*NRF   '                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBASE = 910                                                CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       256795
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                       CAP084
     C*****              IN        ZMUSER                                                     CAP084
     C*****              UNLOCK    ZMUSER                                                     CAP084
     C/COPY WNCPYSRC,MMDEAMIC07
      *
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
(c) Finastra International Limited 2001
** @DT2  ARRAY OF POSSIBLE MIDAS DEAL TYPES
ITIPTDTICILNCDCLDLC1C2BPBDILIDCF                                                             BUG8114
** FIDTYP Array for Fiduciary Deal Types                                        CDL006
FLFTDPDTLPLT                                                                    CDL006
