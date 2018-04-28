     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV database update function')               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDPMVUPD - Depot Movement Database Update function module   *
      *                                                               *
      *  Component of SE0070 - Depot Movement Maintenance             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG11193           Date 02May06               *
      *                 BUG11009           Date 30Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 02Sep05               *
      *                 CSE075             Date 17Nov05               *
      *                 235546             Date 27Jul05               *
      *                 234440             Date 22Jun05               *
      *                 236705             Date 18Jun05               *
      *                 233615             Date 16May05               *
      *                 233566             Date 17May05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 223870             Date 18Jan04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2852            Date 27May04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE039             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209844             Date 16Jan03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CSC011             Date 18Sep01               *
      *                 193045             Date 16Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 174742             Date 17Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      *                 183768             Date 15Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE005             Date 20Jun00               *
      *                 167486             Date 07Apr00               *
      *                 178378             Date 28Apr00               *
      *                 CSE018             Date 20Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 13Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 18Mar99               *
      *                 CAP003  *CREATE    Date 04May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  BUG11009 - Wrong calculation of purchased interest.          *
      *             Applied fix 231841.                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  235546 - EU Tax backvaluations                               *
      *           overwrite of data from SE006680                     *
      *  234440 - Purchase Interest Management                        *
      *           including removing 236758 and most of 236705        *
      *         - Purchase Interest should be maintained during input *
      *           cycle                                               *
      *  236705 - original purchase date should default to average    *
      *           purchase date                                       *
      *  233615 - Takeon programs for CGL031 (Recompile)              *
      *  233566 - Add field to CDEPPD                                 *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  223870 - CPOSNA lock conflict between DBU_TRAD and SEDPMVUPD.*
      *           The fix is to delay the job if locked by another    *
      *           user. Patterned after core fix 213720.              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2852- I/C fields in CDEPPD are prematurely updated for    *
      *           forward valued walk-in/walk-out. Check if the walk- *
      *           in or walk-out is future valued if CSE015 is on.    *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE039 - Auto-settle of trades.                              *
      *  CSD015 - Midas Compliance Watch - Watch Listing Checking.    *
      *  209844 - CDEPP must be updated with PTFR in key. Reinstate   *
      *           coding removed by 178378 and change condition on    *
      *           PM or PB being on. Also add check on RECI ='D'      *
      *  207006 - Add Counterparty & Market Centre to SSI             *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193045 - Set Confirmation and Pay/Receive Indicators if      *
      *           depot amended.                                      *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *           (Recompiled).                                       *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  174742 - Walk in transactions showing on Walk out screen with*
      *         - Walk out transactions showing on Walk in screen     *
      *  CSE023 - Treaty Withholding Tax (Recompiled over SECTYD)     *
      *  183768 - Error in Switchable feature processing              *
      *           - features are always set on.                       *
      *  CSE005 - Added  3 more Parameters  when calling  ZLCD  & ZNCD
      *           modules , which were introduced in them  by this    *
      *           amendment in  the  old  /COPY s  ZLCDZ1 &  ZNCDZ3 . *
      *  167486 - Update DPTMVDY1 if a depot movement has been        *
      *           inserted/amended/deleted. Part of CSW003 also       *
      *           included.                                           *
      *  178378 - Incorrect figure showing on Customer Holding        *
      *           Enqury because historic record being updated by     *
      *           a set of unknown coding. (Coding removed)           *
      *  CSE018 - Deletion of Walk-in and Walk-out depot movement     *
      *           after movement date.                                *
      *  CSE015 - Forward Valued Depot Movements                      *
      *  CSE017 - Cum/Ex Indicator on Depot Movements                 *
      *  CSE012 - SE Depot Movement Narratives (Recompiled).          *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a  another Midas Deal . *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for Trade being updated by another workstation*
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FDPTMV     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
     FDPTMVA    UF   E             DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(DP_)
 
     FDPTMVDY1  UF A E           K DISK    COMMIT                                             167486
     F                                     INFSR(*PSSR)                                       167486
                                                                                              167486
     FCDEPP     UF A E           K DISK    COMMIT
     F                                     RENAME(CDEPPDF:CDEPPD1)
     F                                     INFSR(*PSSR)
     F                                     PREFIX(CD_)
 
     F*SECDEPL5*UF*A*E***********K DISK    COMMIT                                             178378
     F**********                           RENAME(CDEPPDF:CDEPPD2)                            178378
     F**********                           INFSR(*PSSR)                                       178378
     F**********                           PREFIX(CD_)                                        178378
     FSECDEPL5  UF A E           K DISK    COMMIT                                             209844
     F                                     RENAME(CDEPPDF:CDEPPD2)                            209844
     F                                     INFSR(*PSSR)                                       209844
     F                                     PREFIX(CD_)                                        209844
 
     FCDEPPA    UF   E             DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(CD_)
 
     FCPOSN     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(CP_)
 
     FCPOSNA    UF   E             DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(CP_)
 
     FSEPCCD    UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(SP_)
 
     FSEPCA     UF   E             DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(SP_)
 
     FSECTY     IF   E           K DISK    PREFIX(SEC_)
     F                                     INFSR(*PSSR)
 
     FINVTP     IF   E           K DISK    PREFIX(INV_)
     F                                     INFSR(*PSSR)
     FSDCWHTL1  IF   E           K DISK                                                       CSD015
     F                                     INFSR(*PSSR)                                       CSD015
      *                                                                                       CSD015
      **  Compliance Hit list file for retrieve.                                              CSD015
      *                                                                                       CSD015
      **  Logical file based on extended settlements file                                     CSD015
     FDPTMVDY3  IF   E           K DISK                                                       CSD015
     F                                     RENAME(DPTMVDD2:DPMVEX2)                           CSD015
                                                                                              CRE020
     FREADVCL1  UF A E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
                                                                                              CSD015
      ** Security Trade Movments Status                                                       CSE039
     FSEMVTSL6  O  A E           K DISK    RENAME(SEMVTSD0:SEMVTSD06)                         CSE039
     F                                     COMMIT                                             CSE039
      *                                                                                       CSE039
      ** Security Trade Movments Status                                                       CSE039
     FSEMVTSL0  IF   E           K DISK    PREFIX(MV_)                                        CSE039
      *                                                                                       CSE039
     F/COPY WNCPYSRC,SEDPMVDF01
 
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
 
     ****Include*the*SE*standard*declares*******************************                      CAP087
     D*COPY*SECPYSRC,STDDECLARE*****************************************                      CAP087
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and        CAP006
      ** warning message arrays.                                                CAP006
     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     ** Transaction Details Structure
     ** -----------------------------
 
     ** Externally Describe Data structure to received the valid
     ** Transaction
 
     D DPMVTrans     E DS                  EXTNAME(DPTMVD)
     D                                     PREFIX(V_)
                                                                                              234440
     D TRADTrans     E DS                  EXTNAME(SEVTRADPD)                                 234440
     D                                     PREFIX(T_)                                         234440
                                                                                              234440
 
     ** Externally Describe Data structure to received the before
     ** image of the involved transaction
                                                                                              CSD015
     D DPMVOLDV      E DS                  EXTNAME(DPTMVD)                                    CSD015
     D                                     PREFIX(X_)                                         CSD015
 
     D PrvDPMVRec    E DS                  EXTNAME(DPTMVD)
     D                                     PREFIX(Prev)
 
     D ChkDPMVFmt    E DS                  EXTNAME(DPTMVD)                      CAP006
      ** Rename fields for Timestamp checking                                   CAP006
     D                                     PREFIX(CH)                           CAP006
                                                                                              CAP087
     D PosDPMVrec    E DS                  EXTNAME(DPTMVD)                                    CAP087
     D                                     PREFIX(UP_)                                        CAP087
     ** Externally Describe Data Structure to hold DPTMVD data to be                          CAP087
     ** passed to MMRPDLUPD for update of Depot User Position.                                CAP087
 
     D SEEDPMV       E DS                  EXTNAME(SEEDMWIPD)                   CAP006
      * Error indicators                                                        CAP006
                                                                                CAP006
     ** Externally Describe Data Structure to function as a scratch pad DS
     ** for DPTMVD records for initialization and other purposes.
 
     D DPMVDS        E DS                  EXTNAME(DPTMVD)
 
      ** External DS for Bank Details
      ** General ledger details
      ** External DS for Currency Details
      ** External DS for Security Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  209844
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SECTY1        E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SEC_)
      *                                                                                       CAP087
     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)                                 CAP087
      ** New Deal in File Format - dummy only for call to MMRPDLUPD                           CAP087
      *                                                                                       CAP087
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
      ** Watch list checking details                                                          CSD015
      *                                                                                       CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
      ** DS For Watch List Configuration Data File                                            CSD015
      *                                                                                       CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
     D CDArr                 183    230
     D CRArr                 231    242
     D CWA             S             30    DIM(4) CTDATA PERRCD(1)                            CSD015
                                                                                              CSD015
      ** Arrays containing the tags for extended settlement details                           CSD015
     D***OPNTAG          S             30    DIM(13)CTDATA PERRCD(1)                   CSD015 CSW210
     D***CLSTAG          S             30    DIM(13)CTDATA PERRCD(1)                   CSD015 CSW210
     D OPNTAG          S             30    DIM(15)CTDATA PERRCD(1)                            CSW210
     D CLSTAG          S             30    DIM(15)CTDATA PERRCD(1)                            CSW210
 
      ** DS for AccessPrograms, Short DS
      ** DS for AccessPrograms, Long DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** Midas API Message Header Format Definition                                           CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCA_LCD      E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
     D PMCWL           DS          9999                                                       CSD015
                                                                                              CSD015
      ** Temporary DS to store the concatinated intermediary details                          CSD015
     D PMCWL1          DS          9999                                                       CSD015
                                                                                              CSD015
      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006
                                                                                CAP006
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PTimeStamp      S             26A                                                      CSC011
     D***PCustNum        S             18A                                             CSC011 CGL029
     D***PACustNo        S             18A                                             CSC011 CGL029
     D PCustNum        S             24A                                                      CGL029
     D PACustNo        S             24A                                                      CGL029
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D DepotPos        S              1A                                                      CAP087
                                                                                              CSC011
      *                                                                                       223870
      ** Array of QCMDEXC command to edit                                                     223870
      *                                                                                       223870
     D CMDDLY          S             80    DIM(1) CTDATA PERRCD(1)                            223870
      *                                                                                       223870
      *                                                                                       223870
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D*PrvDepot*       S              6S 0                                                    CSD027
     D PrvDepot        S              6A                                                      CSD027
     D PrvDate         S              5P 0
     D*NewDepot*       S              6S 0                                                    CSD027
     D NewDepot        S              6A                                                      CSD027
     D NewDate         S              5P 0
 
     D TimeStamp       S               Z                                        CAP006
                                                                                CAP006
     D PDS1          E DS                  EXTNAME(SDWLTDPD)                                  CSD015
      ** Compliance watch engine program 1st data parameter                                   CSD015
      *                                                                                       CSD015
      ** Declared Variables                                                                   CSD015
     D PKEY            S             10A                                                      CSD015
     D PKYSTS          S              7A                                                      CSD015
     D PDATE           S              5A                                                      CSD015
     D CONVERTEDDATE   S               D                                                      CSD015
     D PDUMMY10        S             10                                                       CSD015
     D PDUMMY16        S             16                                                       CSD015
     D FLD1            S             35                                                       CSD015
     D RESULT1         S            300                                                       CSD015
     D RESULT2         S            300                                                       CSD015
     D RESULT3         S          30000                                                       CSD015
     D DPBNA           S              6                                                       CSD015
     D WX              S              2  0                                                    CSD015
                                                                                              CSD015
      ** Parameter for ZACVTAMT                                                               CSD015
     D PAMFlot         S             18  3                                                    CSD015
     D PCurr           S              3A                                                      CSD015
     D PInAmt          S             15A                                                      CSD015
     D POutAmt         S             16A                                                      CSD015
     D PRtnCode        S              7A                                                      CSD015
                                                                                              CRE020
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KDptRef         S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('SEDPMVUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('DepotMovements      ')                        CRE020
     D PCurSet01       S            200A                                                      CRE020
     D PSysVal02       S             20A   INZ('DepotMovementsWalkIn')                        CRE020
     D PCurSet02       S            200A                                                      CRE020
     D PSysVal03       S             20A   INZ('DepotMovementWalkOut')                        CRE020
     D PCurSet03       S            200A                                                      CRE020
     D PSysVal04       S             20A                                                      CRE020
     D PCurSet04       S            200A                                                      CRE020
     D PSysVal05       S             20A                                                      CRE020
     D PCurSet05       S            200A                                                      CRE020
     D PSysVal06       S             20A                                                      CRE020
     D PCurSet06       S            200A                                                      CRE020
     D PSysVal07       S             20A                                                      CRE020
     D PCurSet07       S            200A                                                      CRE020
     D PSysVal08       S             20A                                                      CRE020
     D PCurSet08       S            200A                                                      CRE020
     D PSysVal09       S             20A                                                      CRE020
     D PCurSet09       S            200A                                                      CRE020
     D PSysVal10       S             20A                                                      CRE020
     D PCurSet10       S            200A                                                      CRE020
     D WDptMvAdv       S              1A   INZ('N')                                           CRE020
     D WDptWIAdv       S              1A   INZ('N')                                           CRE020
     D WDptWOAdv       S              1A   INZ('N')                                           CRE020
     D WPrcsAdv        S              1A   INZ('N')                                           CRE020
                                                                                              CSD015
     D CGL031          S              1A                                                      CGL031
     D*WCust****       S              6S 0                                             236705 234440
                                                                                              CGL031
     D CSW210          S              1A                                                      CSW210
                                                                                              CSW210
     D/COPY WNCPYSRC,SEH00074
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Clear working fields
      ** --------------------
      *
     C                   EXSR      SRInit
      *
      ** Retrieve Security Details
      ** -------------------------
      *
     C                   EXSR      SRRtvSec
      *
      ** Retrieve Depot Movement Details (Set file pointer)
      ** -------------------------------
      *
     C     V_CHTP        CASNE     'I'           SRRtvTrans
     C                   ENDCS
      *
      ** Ensure transaction has not been updated by another workstation         CAP006
      ** - if so, bypass updating and return to calling program.                CAP006
     C                   EXSR      CHKOTHUPD                                    CAP006
                                                                                CAP006
     C     RetCodeIn     IFNE      *BLANKS                                      CAP006
     C                   GOTO      EXIT                                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Update Depot Movement Details file
      ** ----------------------------------
      *
     C                   MOVE      DPMVDS        DPMVOLDV                                     CSD015
                                                                                              CSD015
     C     V_DPMV        CASEQ     'WI'          SRWIUpd
     C     V_DPMV        CASEQ     'WO'          SRWOUpd
     C                   CAS                     SRRPUpd                                      CAP087
     C                   ENDCS
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        DMFRNT = *BLANKS                                           CSC011
     C                   EVAL      DMFRNT = 'MD' + DPRN                                       CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C     CSD015        IFEQ      'Y'                                                        CSD015
     C     W1EWLC        ANDEQ     'Y'                                                        CSD015
     C     CSC011        IFEQ      'N'                                                        CSD015
     C     CSC011        OREQ      'Y'                                                        CSD015
     C     S1MAIN        ANDEQ     LIBR                                                       CSD015
     C                   EXSR      SRWATCH                                                    CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
 
     C                   SELECT
 
     C                   WHEN      V_CHTP = 'I'
     C/COPY WNCPYSRC,SEH00075
     C                   WRITE     DPTMVDF                              99
 
     C                   WHEN      V_CHTP = 'A'
     C                             OR V_CHTP = 'D'
     C/COPY WNCPYSRC,SEH00076
     C                   UPDATE    DPTMVDF                              99
     C/COPY WNCPYSRC,SEH00077
 
     C                   ENDSL
                                                                                              CRE020
     C/COPY WNCPYSRC,SEH00078
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   EVAL      WPrcsAdv = 'N'                                             CRE020
     C                   IF        V_DPMV = 'WI' and                                          CRE020
     C                             WDptWIAdv = 'Y' or                                         CRE020
     C                             V_DPMV = 'WO' and                                          CRE020
     C                             WDptWOAdv = 'Y' or                                         CRE020
     C                             V_DPMV <> 'WO' and                                         CRE020
     C                             V_DPMV <> 'WI' and                                         CRE020
     C                             WDptMvAdv = 'Y'                                            CRE020
     C                   EVAL      WPrcsAdv = 'Y'                                             CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WPrcsAdv = 'Y '                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
     C/COPY WNCPYSRC,SEH00079
                                                                                              CRE020
     C/COPY WNCPYSRC,SEDPMVDC05
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
      *
      ** Update DPMV Trailer file
      ** ------------------------
     C/COPY WNCPYSRC,SEDPMVDC06
      *
     C                   EXSR      SRUpdCtlR
     C/COPY WNCPYSRC,SEDPMVDC07
      *
      ** Calculate Position values
      ** -------------------------
      *
     C                   EXSR      SRCalcPos
      *
      ** Update Depot Position Files
      ** ---------------------------
      *
      ** Update Depot Positions file                                                          CAP087
      *                                                                                       CAP087
      ** If type is repo or depot transfer, update the user positions file.                   CAP087
      *                                                                                       CAP087
     C                   IF        V_DPMV = 'RR' OR V_DPMV = 'RP'                             CAP087
     C                             OR V_DPMV = 'BB' OR V_DPMV = 'BL'                          CAP087
     C                             OR V_DPMV = 'PD' OR V_DPMV = 'PL'                          CAP087
     C                             OR V_DPMV = 'DT'                                           CAP087
      *                                                                                       CAP087
     C                   EVAL      DepotPos = 'Y'                                             CAP087
     C                   EVAL      PosDPMVrec = DPMVDS                                        CAP087
      *                                                                                       CAP087
     C                   CALLB     'MMRPDLUPD'                                                CAP087
     C                   PARM      *BLANKS       RetCodeIn                                    CAP087
     C                   PARM                    NwDlFilFmt                                   CAP087
     C                   PARM                    PosDPMVrec                                   CAP087
     C                   PARM                    DepotPos                                     CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
      *                                                                                       CAP087
      ** Update Previous Position **
      *
     C                   IF        V_CHTP = 'A'
     C                             OR V_CHTP  = 'D'
     C/COPY WNCPYSRC,SEDPMVDC08
     C                   EXSR      SRUpdPrvPs
     C                   ENDIF
      *
      ** Create/Update Current Position **
      *
     C                   IF        V_CHTP = 'A'
     C                             OR V_CHTP  = 'I'
     C/COPY WNCPYSRC,SEDPMVDC09
     C                   EXSR      SRUpdNewPs
     C                   ENDIF
      *                                                                                       CSE039
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
      ** Write record to the Movement Status file                                             CSE039
      *  ----------------------------------------                                             CSE039
      *                                                                                       CSE039
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C                   Exsr      SrMovement                                                 CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
      *                                                                                       234440
      ** Create/Update EU Tax Position **                                                     234440
      *                                                                                       234440
     C                   IF        CGL031 = 'Y'                                               234440
     C*                                                                                       235546
     C* check if value date has changed and ensure that earlier value date                    235546
     C* is used                                                                               235546
     C     V_CHTP        IFEQ      'A'                                                        235546
     C     ValueDate     IFLT      PrvDate                                                    235546
     C                   Z-ADD     ValueDate     PTDVD             5 0                        235546
     C                   ELSE                                                                 235546
     C                   Z-ADD     PrvDate       PTDVD                                        235546
     C                   ENDIF                                                                235546
     C                   ELSE                                                                 235546
     C                   Z-ADD     ValueDate     PTDVD                                        235546
     C                   ENDIF                                                                235546
     C*                                                                                       235546
     C* delete all records on ETCPOSND after the date/timestamp            i                  235546
     C*                                                                                       235546
     C                   CALL      'SE006670'                                                 235546
     C                   PARM      V_CHTP        Actn_Code                                    235546
     C                   PARM      'D'           Tr_Type                                      235546
     C                   PARM                    TRADTrans                                    235546
     C                   PARM                    DPMVTrans                                    235546
     C                   PARM                    SECTY1                                       235546
     C                   PARM                    PTDVD                                        235546
     C*                                                                                       235546
     C* if value date has not changed to be later, then process                               235546
     C* this depot movement now                                                               235546
     C*                                                                                       235546
     C     V_CHTP        IFEQ      'I'                                                        235546
     C     V_CHTP        OREQ      'D'                                                        235546
     C     V_CHTP        OREQ      'A'                                                        235546
     C     ValueDate     ANDLE     PrvDate                                                    235546
     C                   Z-ADD     0             PTDVD                                        235546
     C                   CALL      'SEETCPUPD'                                                234440
     C                   PARM                    RetCodeIn                                    234440
     C                   PARM      V_CHTP        Actn_Code         1                          234440
     C                   PARM      'D'           Tr_Type           1                          234440
     C                   PARM                    TRADTrans                                    234440
     C                   PARM                    DPMVTrans                                    234440
     C                   PARM                    SECTY1                                       234440
     C*                                                                                       235546
     C* Re-process all the other trades/depot movements after this date.                      235546
     C*                                                                                       235546
     C                   CALL      'SE006680'                                                 235546
     C                   PARM      'D'           Tr_Type                                      235546
     C                   PARM                    SECTY1                                       235546
     C                   PARM                    INV_PROT                                     235546
     C                   PARM      'S'           CustClass         1                          235546
     C                   PARM                    NomCcyDec                                    235546
     C                   PARM                    CSE023                                       235546
     C                   PARM                    PTDVD                                        235546
     C                   PARM                    PTMST                                        235546
     C                   ELSE                                                                 235546
     C*                                                                                       235546
     C* If movmt has changed to make value date later, then re-process                        235546
     C* trades/depot movements up to this date/time                                           235546
     C*                                                                                       235546
     C                   Z-ADD     ValueDate     PTDVD                                        235546
     C                   EVAL      PTMST = DMTMST                               CAP006        235546
     C                   CALL      'SE006680'                                                 235546
     C                   PARM      'D'           Tr_Type                                      235546
     C                   PARM                    SECTY1                                       235546
     C                   PARM                    INV_PROT                                     235546
     C                   PARM      'S'           CustClass         1                          235546
     C                   PARM                    NomCcyDec                                    235546
     C                   PARM                    CSE023                                       235546
     C                   PARM                    PTDVD                                        235546
     C                   PARM                    PTMST                                        235546
     C*                                                                                       235546
     C* Now process changed depot movement                                                    235546
     C*                                                                                       235546
     C                   CALL      'SEETCPUPD'                                                235546
     C                   PARM                    RetCodeIn                                    234440
     C                   PARM      V_CHTP        Actn_Code         1                          234440
     C                   PARM      'D'           Tr_Type           1                          234440
     C                   PARM                    TRADTrans                                    234440
     C                   PARM                    DPMVTrans                                    234440
     C                   PARM                    SECTY1                                       234440
     C*                                                                                       235546
     C* Now re-process all the other trades/depot movements after the date                    235546
     C* of this changed trade                                                                 235546
     C*                                                                                       235546
     C                   Z-ADD     0             PTDVD                                        235546
     C                   CALL      'SE006680'                                                 235546
     C                   PARM      'D'           Tr_Type                                      235546
     C                   PARM                    SECTY1                                       235546
     C                   PARM                    INV_PROT                                     235546
     C                   PARM      'S'           CustClass         1                          235546
     C                   PARM                    NomCcyDec                                    235546
     C                   PARM                    CSE023                                       235546
     C                   PARM                    PTDVD                                        235546
     C                   PARM                    PTMST                                        235546
     C                   ENDIF                                                                235546
     C                   ENDIF                                                                234440
      *                                                                                       167486
      ***  If MT5xx Feature present, then if a Depot Movement has been                        167486
      ***  Inserted/Amended/Deleted, Update the Extension to indicate                         167486
      ***  that a new S.W.I.F.T. Settlement Message may be required.                          167486
      *                                                                                       167486
     C     DPTMK1        KLIST                                                                167486
     C                   KFLD                    V_DPSS                                       167486
     C                   KFLD                    V_DPRN                                       167486
     C                   KFLD                    DPWHEN                                       167486
                                                                                              167486
     C     S01401        IFEQ      'Y'                                                        167486
     C     DPTMVK        CHAIN     DPTMVDY1                           33                      167486
     C     *IN33         IFEQ      *OFF                                                       167486
     C                   MOVEL     'Y'           DPSCMG                                       167486
     C                   UPDATE    DPTMVDD1                                                   167486
     C     DPWHEN        IFEQ      'M'                                                        167486
     C                   MOVE      'S'           DPWHEN                                       167486
     C     DPTMK1        CHAIN     DPTMVDY1                           33                      167486
     C     *IN33         IFEQ      *OFF                                                       167486
     C                   MOVEL     'Y'           DPSCMG                                       167486
     C                   UPDATE    DPTMVDD1                                                   167486
     C                   ENDIF                                                                167486
     C                   ENDIF                                                                167486
     C                   ENDIF                                                                167486
     C                   ENDIF                                                                167486
 
      ** If 24x7 Midas Availability is installed, write to the standard                       CSC011
      ** log file when support system is active                                               CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   CALLB     'SEDPMVLOG'                                                CSC011
     C                   Parm      *Blanks       RetCodeOut                                   CSC011
     C                   Parm                    DPMVTrans                                    CSC011
     C                   Parm                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** Write to support database log file                                                   CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
                                                                                              CSC011
     C                   IF        V_DPMV = 'WI'                                              CSC011
     C                   EVAL      APTGTTYPE = 'SEDMWI'                                       CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      APTGTTYPE = 'SEDMWO'                                       CSC011
     C                   ENDIF                                                                CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
     C                   EVAL      APRPRLOCN = DMREPA                                         CSC011
     C                   EVAL      APFOTRANID = DMFRNT                                        CSC011
     C                   EVAL      APFOASOCID = DMAFRT                                        CSC011
     C                   EVAL      PCustNum = DPRN                                            CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimeStamp                                   CSC011
     C                   PARM                    PCustNum                                     CSC011
     C                   PARM      *BLANKS       PACustNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      RetCodeIn = '*ERROR'                                       CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,SEH00080
      *
      ** Return
     C     EXIT          TAG                                                    CAP006
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWIUpd - Update routine for WI transaction.                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRWIUpd       BEGSR
      *
      ** Generate Transaction number
      *
     C                   EXSR      SRGenTrnNo
      *
      ** Move fields updated by Validation Modules
      *
     C                   MOVE      DPMVTrans     DPMVDS
      *
      ** Set-up fields appropriately for WI transaction
      *
     C                   MOVE      'WI'          DPMVType          2
     C                   Z-ADD     DPMD          ValueDate         5 0
      *
      ** Update the fields not needed for a Walk In Transaction
      *
     C**********         Z-ADD     0             DPOD                                         CSD027
     C                   EVAL      DPOD = *BLANKS                                             CSD027
     C                   Z-ADD     0             DPDO
     C                   MOVE      *BLANKS       DPAD
     C                   MOVE      *BLANKS       SWRF
     C                   MOVE      *BLANKS       SIOI
      *
      ** Update remaining fields accorgingly
      *
     C     V_CHTP        CASEQ     'I'           SRUpdIns
     C     V_CHTP        CASEQ     'A'           SRUpdAmd
     C     V_CHTP        CASEQ     'D'           SRUpdDel
     C/COPY WNCPYSRC,SEDPMVDC10
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWOUpd - Update routine for WO transaction.                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRWOUpd       BEGSR
      *
      ** Move fields updated by Validation Modules
      *
     C                   MOVE      DPMVTrans     DPMVDS
      *
      ** Set-up fields appropriately for WO transaction
      *
     C                   MOVE      'WO'          DPMVType          2
     C                   Z-ADD     DPDO          ValueDate         5 0
      *
      ** Fields not needed for a Walk Out Transaction
      *
     C**********         Z-ADD     0             DPID                                         CSD027
     C                   EVAL      DPID = *BLANKS                                             CSD027
     C                   Z-ADD     0             DPMD
     C                   MOVE      *BLANKS       DPAD
     C                   MOVE      *BLANKS       SWRF
     C                   MOVE      *BLANKS       SIOI
      *
      ** Update remaining fields accordingly
      *
     C     V_CHTP        CASEQ     'I'           SRUpdIns
     C     V_CHTP        CASEQ     'A'           SRUpdAmd
     C     V_CHTP        CASEQ     'D'           SRUpdDel
     C/COPY WNCPYSRC,SEDPMVDC11
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * SRRPUpd - Update routine for Repos and Depot Transfers        *                       CAP087
      *                                                               *                       CAP087
      * Called by: Main                                               *                       CAP087
      *                                                               *                       CAP087
      * Calls: None                                                   *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
                                                                                              CAP087
     C     SRRPUpd       BEGSR                                                                CAP087
      *                                                                                       CAP087
      ** Move fields updated by Validation Modules                                            CAP087
      *                                                                                       CAP087
     C                   MOVE      DPMVTrans     DPMVDS                                       CAP087
      *                                                                                       CAP087
      ** Set-up fields appropriately                                                          CAP087
      *                                                                                       CAP087
     C                   MOVE      V_DPMV        DPMVType          2                          CAP087
      *                                                                                       CAP087
      ** Setup Value Date in DPTMVD based on type                                             CAP087
      *                                                                                       CAP087
     C                   Z-ADD     0             ValueDate         5 0                        CAP087
     C     DPMV          IFEQ      'BB'                                                       CAP087
     C     DPMV          OREQ      'RR'                                                       CAP087
     C     DPMV          OREQ      'PD'                                                       CAP087
     C     DPMV          OREQ      'DT'                                                       CAP087
     C                   Z-ADD     V_DPMD        ValueDate                                    CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C     DPMV          IFEQ      'BL'                                                       CAP087
     C     DPMV          OREQ      'RP'                                                       CAP087
     C     DPMV          OREQ      'PL'                                                       CAP087
     C                   Z-ADD     V_DPDO        ValueDate                                    CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
      ** Update remaining fields accordingly                                                  CAP087
      *                                                                                       CAP087
     C     V_CHTP        CASEQ     'I'           SRUpdIns                                     CAP087
     C     V_CHTP        CASEQ     'A'           SRUpdAmd                                     CAP087
     C     V_CHTP        CASEQ     'D'           SRUpdDel                                     CAP087
     C                   ENDCS                                                                CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
                                                                                              CAP087
      *****************************************************************                       CAP087
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdIns - Transaction file update for Input Transaction      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUpdIns      BEGSR
      *
      ** Update remaining fields
      *
     C                   MOVE      'D'           RECI
     C                   MOVE      DPMVType      DPMV
     C                   MOVE      SEC_MKTI      DPMK
     C                   BITOFF    '0'           DPMS
     C                   MOVE      'Y'           DCFR
     C                   BITOFF    '01'          TACI
     C                   MOVE      'N'           DPR1
     C                   MOVE      'N'           DPR2
     C                   Z-ADD     RunDate       ORED
     C                   Z-ADD     RunDate       LCD
     C                   MOVEL     'I'           CHTP
     C                   MOVEL     NATN          TNLU
     C                   MOVE      ValueDate     DPVD
     C     CSE017        IFEQ      'Y'                                                        CSE017
     C     DPAP          IFEQ      'N'                                                        CSE017
     C                   MOVE      'N'           DCFR                                         CSE017
     C                   ENDIF                                                                CSE017
     C                   ENDIF                                                                CSE017
     C     CSE015        IFEQ      'Y'                                                        CSE015
     C                   BITOFF    '2'           TACI                                         CSE015
     C                   ENDIF                                                                CSE015
     C/COPY WNCPYSRC,SEDPMVDC02
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      DMTMST = TimeStamp                           CAP006
                                                                                CAP006
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdAmd - Amendment action processing routine                *
      *                                                               *
      * Called by: SRWOUPD                                            *
      *            SRWIUPD                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUpdAmd      BEGSR
 
     C                   MOVE      SEC_MKTI      DPMK
     C                   Z-ADD     RunDate       LCD
     C                   MOVEL     'A'           CHTP
     C                   MOVEL     NATN          TNLU
     C                   MOVE      ValueDate     DPVD
     C/COPY WNCPYSRC,SEH00081
      *                                                                                       193045
      ** Set Pay/Receive processed indicators to N if Other Settlement                        193045
      ** record already printed.                                                              193045
      *                                                                                       193045
     C     DPR1          IFEQ      'Y'                                                        193045
     C                   MOVE      'N'           DPR1                                         193045
     C                   ELSE                                                                 193045
     C                   MOVE      'Y'           DPR1                                         193045
     C                   ENDIF                                                                193045
                                                                                              193045
     C     DPR2          IFEQ      'Y'                                                        193045
     C                   MOVE      'N'           DPR2                                         193045
     C                   ELSE                                                                 193045
     C                   MOVE      'Y'           DPR2                                         193045
     C                   ENDIF                                                                193045
                                                                                              193045
     C**********         TESTB     '0'           DPMS                     99           193045 CSW210
                                                                                              193045
     C******IN99         IFEQ      '0'                                                 193045 CSW210
     C**********         MOVE      'N'           DCFR                                  193045 CSW210
     C**********         ELSE                                                          193045 CSW210
     C                   MOVE      'Y'           DCFR                                         193045
     C     CSE017        IFEQ      'Y'                                                        CSW210
     C     DPAP          IFEQ      'N'                                                        CSW210
     C                   MOVE      'N'           DCFR                                         CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                193045
                                                                                              193045
     C     CSE015        IFEQ      'Y'                                                        CSE015
     C                   BITOFF    '2'           TACI                                         CSE015
     C                   ENDIF                                                                CSE015
 
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      DMTMST = TimeStamp                           CAP006
                                                                                CAP006
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdDel - Deletion processing routine                        *
      *                                                               *
      * Called by: SRWOUPD                                            *
      *            SRWIUPD                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUpdDel      BEGSR
 
     C                   MOVEL     '*'           RECI
      *                                                                                       CSE015
     C     ORED          IFNE      RunDate                                                    CSE015
     C     CSE015        ANDEQ     'Y'                                                        CSE015
     C     ORED          ORNE      RunDate                                                    CSE018
     C     CSE018        ANDEQ     'Y'                                                        CSE018
     C                   MOVEL     'R'           RECI                                         CSE015
     C                   ENDIF                                                                CSE015
      *                                                                                       CSE015
      ** Set RECI to 'R' if Original Entry Date is earlier than Rundate                       CAP087
      ** depot movement is a repo, bond or pledge.                                            CAP087
     C     ORED          IFLT      RunDate                                                    CAP087
     C     DPMVType      IFEQ      'RR'                                                       CAP087
     C     DPMVType      OREQ      'RP'                                                       CAP087
     C     DPMVType      OREQ      'BB'                                                       CAP087
     C     DPMVType      OREQ      'BL'                                                       CAP087
     C     DPMVType      OREQ      'PL'                                                       CAP087
     C     DPMVType      OREQ      'PD'                                                       CAP087
     C                   MOVEL     'R'           RECI                                         CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   Z-ADD     RunDate       LCD
     C                   MOVEL     'D'           CHTP
     C                   MOVEL     NATN          TNLU
     C                   MOVE      ValueDate     DPVD
      *
      ** Set Pay/Receive processed indicators to N if Other Settlement
      ** record already printed.
      *
     C     DPR1          IFEQ      'Y'
     C                   MOVE      'N'           DPR1
     C                   ELSE
     C                   MOVE      'Y'           DPR1
     C                   END
 
     C     DPR2          IFEQ      'Y'
     C                   MOVE      'N'           DPR2
     C                   ELSE
     C                   MOVE      'Y'           DPR2
     C                   END
 
     C                   TESTB     '0'           DPMS                     99
 
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           DCFR
     C                   ELSE
     C                   MOVE      'Y'           DCFR
     C     CSE017        IFEQ      'Y'                                                        CSE017
     C     DPAP          IFEQ      'N'                                                        CSE017
     C                   MOVE      'N'           DCFR                                         CSE017
     C                   ENDIF                                                                CSE017
     C                   ENDIF                                                                CSE017
      *                                                                                       CSE017
     C                   END
     C/COPY WNCPYSRC,SEDPMVDC01
      *                                                                                       CSE015
      ** Initialise Trade Date Accounting Indicator                                           CSE015
      *                                                                                       CSE015
     C     CSE015        IFEQ      'Y'                                                        CSE015
     C                   BITOFF    '2'           TACI                                         CSE015
     C                   ENDIF                                                                CSE015
 
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      DMTMST = TimeStamp                           CAP006
                                                                                CAP006
     C                   ENDSR
      *****************************************************************
     C/COPY WNCPYSRC,SEDPMVDC12
      /EJECT
     C*****************************************************************         CAP006
     C*                                                               *         CAP006
     C* CHKOTHUPD - Check for update by another workstation           *         CAP006
     C*                                                               *         CAP006
     C*****************************************************************         CAP006
     C     CHKOTHUPD     BEGSR                                                  CAP006
                                                                                CAP006
      ** Retrieve current Trade details                                         CAP006
                                                                                CAP006
      ** Determine whether program is running interactively or in batch         CAP006
      **  ( 0 = batch   1 = interactive)                                        CAP006
      *                                                                         CAP006
     C                   CALLB     'ZARTVJOBA'                                  CAP006
     C                   PARM                    @Return           6            CAP006
     C                   PARM                    @type             1            CAP006
      *                                                                         CAP006
      * Allow access to transaction record by Front-Office ID when in Repair    168345
      * mode for inserts .Set  *RTV module  parameter 'ModeOfOp' to  *FRONT     168345
      * if the pgm is:  a) running in Interactive mode - @Type= 1    ~~~~~~     168345
      * and             b) action code is Insert - 'I'                          168345
      * and             c) Front-Office Id is NOT Blank                         168345
      *                                                                         168345
     C     @Type         IFEQ      '1'                                          168345
     C     V_CHTP        ANDEQ     'I'                                          168345
     C     V_DMFRNT      ANDNE     *BLANKS                                      168345
      *                                                                         168345
     C                   MOVE      '*FRONT'      ModeOfOp                       168345
      *                                                                         168345
     C                   ELSE                                                   168345
      *                                                                         168345
      * Otherwise, if running in batch use Front-Office ID                      168345
      *            (if insert)                                                  CAP013
      *            else, use Midas Deal Number                                  168345
      *                                                                         168345
     C     @Type         IFEQ      '0'                                          CAP006
     C     V_CHTP        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      ModeOfOp          6            CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       ModeOfOp                       CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
      *                                                                                       CAP087
      ** Setup Depot Movement type here, RTV module now changed to make use                   CAP087
      ** of Depot Movement Type to get the correct record.                                    CAP087
      *                                                                                       CAP087
     C                   MOVE      V_DPMV        DPMVType                                     CAP087
                                                                                CAP006
     C                   CALLB     'SEDPMVRTV'                                  CAP006
      * INPUTS                                                                  CAP006
      *                                                                         CAP006
      * Action Code (1A)
     C                   PARM                    V_CHTP
      * Depot Movement Reference Number (6A)
     C                   PARM                    V_DPRN
      * Booking Branch  (3A)
     C                   PARM                    V_DPBA
      * Originating Branch  (3A)
     C                   PARM                    V_ORBR
      * Mode of Operation (6A)
     C                   PARM                    ModeOfOP
      * Response Mode (1A)
     C                   PARM      ' '           RespMode          1
      * Front Office ID No. (20A)
      * Depot Movement Type. (2A)                                                             174742
     C                   PARM                    V_DMFRNT
     C                   PARM                    DPMVType                                     174742
     C                   PARM                    CallProg         10                          CSE039
     C                   PARM                    V_DPSS                                       CAP087
      *
      * OUTPUTS                                                                 CAP006
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM      *BLANK        FldNameArr                     CAP006
     C                   PARM      *BLANK        MsgIdArr                       CAP006
     C                   PARM      *BLANK        MsgDtaArr                      CAP006
      *                                                                         CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006
      *                                                                         CAP006
      * Depot movement transaction file Output
     C                   PARM                    ChkDPMVFmt                     CAP006
      *                                                                         CAP006
      * OK - Action code                                                        CAP006
     C                   PARM      *BLANK        DDACTNOK                          CAP006
      *                                                                         CAP006
      * Transaction ID number Ok Indicator (1A)
     C                   PARM      *BLANK        DDDPRNOK                         CAP006
      *                                                                         CAP006
      * OK - Booking branch                                                     CAP006
     C                   PARM      *BLANK        DDDPBAOk
      *                                                                         CAP006
      * Originating Branch Ok indicator (1A)
     C                   PARM      *BLANK        DDORBROk
      *                                                                         CAP006
      ** Error if Timestamp is not the same (record has been changed            CAP006
      **  by another workstation)                                               CAP006
                                                                                CAP006
      ** Processing varies according to mode program is running in.             CAP006
      ** In interacive mode simply check whether the timestamp field            CAP006
      ** has been updated since the original Trade was fetched by this          CAP006
      ** program.                                                               CAP006
      ** In batch (API input) check return parameters from Retrieve             CAP006
      ** module for errors, and send message to system operator.                CAP006
                                                                                CAP006
      ** Interactive mode:                                                      CAP006
                                                                                CAP006
     C     @TYPE         IFEQ      '1'                                          CAP006
                                                                                CAP006
     C     CHDMTMST      IFNE      V_DMTMST                                     CAP006
     C                   MOVEL     '*RECUPD'     RetCodeIn                      CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Batch mode:                                                            CAP006
     C                   ELSE                                                   CAP006
     C     DDACTNOK      IFEQ      'N'                                             CAP006
     C     DDDPRNOK      OREQ      'N'                                            CAP006
     C                   MOVEL     '*RECUPD'     RetCodeIn                      CAP006
     C                   Z-ADD     1             C                 2 0          CAP006
                                                                                CAP006
     C     C             DOWLE     ArrayMax                                     CAP006
     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP006
     C*******************MOVEL     *BLANKS       DBError          28     CAP006 CAP013
     C*******************MOVEL     MsgIDArr(C)   DBError                 CAP006 CAP013
     C                   CLEAR                   DBError         132            CAP013
     C                   EVAL      DBerror = 'Update error: ' + V_DMFRNT        CAP013
     C                   CALLB     'ZAMSGTOOPR'                                 CAP006
     C                   PARM                    MsgSndRtn        10            CAP006
     C                   PARM                    DBError                        CAP006
     C                   PARM                    DummyMsgID                     CAP006
     C                   PARM                    DummyMsgF                      CAP006
     C                   ADD       1             C                              CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   ENDSR                                                  CAP006
     C*****************************************************************         CAP006
      /EJECT                                                                    CAP006
      *****************************************************************
      *                                                               *
      * SRUpdCtlR - Update File Control Records                       *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUpdCtlR     BEGSR
 
     C     1             CHAIN     DPTMVAF                            99
 
     C     *IN99         IFEQ      '0'
     C/COPY WNCPYSRC,SEH00082
     C                   SELECT
 
     C                   WHEN      V_CHTP = 'I'
     C                   ADD       1             DP_SINS
     C                   ADD       1             DP_NORE
 
     C                   WHEN      V_CHTP = 'A'
     C/COPY WNCPYSRC,SEH00122
     C                   ADD       1             DP_SAMD
 
     C                   WHEN      V_CHTP = 'D'
     C                   ADD       1             DP_SDEL
     C                   SUB       1             DP_NORE
 
     C                   ENDSL
     C/COPY WNCPYSRC,SEH00083
 
     C                   MOVEL     NATN          DP_TNLU
 
     C                   UPDATE    DPTMVAF                              99
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
 
     C                   ELSE
 
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'DPTMV   '    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
                                                                                ************
     C                   EXSR      SRErr
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcPos - Position computation Routine                      *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCalcPos     BEGSR
      *
      ** Fetch Nominal currency details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SEC_NMCY      @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Fetch investment type details
      *
     C     INVKA         KLIST
     C                   KFLD                    SEC_NMCY
     C                   KFLD                    SEC_SITP
 
     C     INVKA         CHAIN     INVTPDF                            33
 
     C                   IF        V_CHTP = 'A'
     C                             OR  V_CHTP = 'D'
     C/COPY WNCPYSRC,SEDPMVDC13
      *
      ** Calculate Consideration For AP Numerator
      *
     C                   Z-ADD     PrevDPNA      ZNOML
     C                   Z-ADD     PrevMKTP      ZPRCIN
     C                   Z-ADD     PrevDPVD      ZFDATE
      *
      ** Set up parameters for Australian Yields mod
      *
     C     SEC_STBS      IFEQ      'Y'
     C     SEC_SYBS      ANDEQ     'AU'
     C                   Z-ADD     PrevDPVD      ZECD
 
     C                   EXSR      SRZLCD
 
     C                   Z-ADD     PrevDPVD      ECD
 
     C                   EXSR      SRZNCD
 
     C                   Z-ADD     ZZLCD         ZDCSDT            5 0
     C                   Z-ADD     PrevDPMD      ZDCEDT            5 0
     C                   Z-ADD     ZNOML         ZAMT             15 0
     C                   Z-ADD     A6NBDP        NomCcyDec
 
     C                   EXSR      SRZACCZ
 
     C                   Z-ADD     PrevDPVD      WRKD
 
     C     ZDCINT        DIV       ZNOML         WRKPI
 
     C                   EXSR      SRZYCE
      *
      ** If Ex-Coupon then PI passed is the remaining Interest
      ** till NCD and is negative
      *
     C     SCUMEX        IFEQ      'X'
     C                   Z-ADD     ZZLCD         ZDCSDT
     C                   Z-ADD     NCD           ZDCEDT
     C                   Z-ADD     A6NBDP        NomCCyDec
 
     C                   EXSR      SRZACCZ
 
     C     ZDCINT        DIV       ZNOML         WKWPI            15 9
     C     WRKPI         SUB       WKWPI         WRKPI
 
     C                   END
 
     C                   ELSE
 
     C                   MOVE      'C'           SCUMEX            1
     C                   Z-ADD     0             WRKPI
     C                   END
 
     C                   EXSR      SRZPRCI
 
     C                   Z-ADD     ZPRCOT        ZPRC
     C                   Z-ADD     A6NBDP        NomCcyDEc
 
     C                   EXSR      SRZCNSD
 
     C                   Z-ADD     ZCONS         PrevValue        15 0
 
     C     INV_PROT      IFEQ      '8'
     C                   MULT(H)   SEC_CFCT      PrevValue
     C                   END
 
     C                   END
      *
      ** Insert or amend mode
      *
     C/COPY WNCPYSRC,SEH00123
     C                   IF        V_CHTP = 'I'
     C/COPY WNCPYSRC,SEH00124
     C                             OR V_CHTP = 'A'
     C/COPY WNCPYSRC,SEDPMVDC14
      *
      ** Calculate Consideration for AP Numerator
      *
     C                   Z-ADD     DPNA          ZNOML
     C                   Z-ADD     MKTP          ZPRCIN
     C                   Z-ADD     DPVD          ZFDATE
      *
      ** Set up parameters for Australian Yields mod
      *
     C     SEC_STBS      IFEQ      'Y'
     C     SEC_SYBS      ANDEQ     'AU'
     C                   Z-ADD     DPVD          ZECD
 
     C                   EXSR      SRZLCD
 
     C                   Z-ADD     DPVD          ECD
 
     C                   EXSR      SRZNCD
 
     C                   Z-ADD     ZZLCD         ZDCSDT
     C                   Z-ADD     DPVD          ZDCEDT
     C                   Z-ADD     ZNOML         ZAMT
     C                   Z-ADD     A6NBDP        NomCcyDec
 
     C                   EXSR      SRZACCZ
 
     C                   Z-ADD     DPVD          WRKD              5 0
     C     ZDCINT        DIV       ZNOML         WRKPI
 
     C                   EXSR      SRZYCE
      *
      ** If Ex-coupon then PI Passed is the remaining interest
      ** till NCD and is negative
      *
     C     SCUMEX        IFEQ      'X'
     C                   Z-ADD     ZZLCD         ZDCSDT
     C                   Z-ADD     NCD           ZDCEDT
     C                   Z-ADD     A6NBDP        NomCcyDec
 
     C                   EXSR      SRZACCZ
 
     C     ZDCINT        DIV       ZNOML         WKWPI            15 9
     C     WRKPI         SUB       WKWPI         WRKPI
 
     C                   END
 
     C                   ELSE
 
     C                   MOVE      'C'           SCUMEX            1
     C                   Z-ADD     0             WRKPI
     C                   END
 
     C                   EXSR      SRZPRCI
 
     C                   Z-ADD     ZPRCOT        ZPRC
     C                   Z-ADD     A6NBDP        NomCcyDec
 
     C                   EXSR      SRZCNSD
 
     C                   Z-ADD     ZCONS         NewValue         15 0
 
     C     INV_PROT      IFEQ      '8'
     C                   MULT(H)   SEC_CFCT      NewValue
     C                   END
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdPrvPs - Previous Depot Position update routine           *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUpdPrvPs    BEGSR
      *
      ** Update customer depot file
      *
     C                   SELECT
 
     C                   WHEN      DPMV = 'WI'
     C                   MOVE      PrevDPID      PrvDepot
     C                   Z-ADD     PrevDPMD      PrvDate
 
     C                   WHEN      DPMV = 'WO'
     C                   MOVE      PrevDPOD      PrvDepot
     C                   Z-ADD     PrevDPDO      PrvDate
 
     C                   ENDSL
 
     C     CDEPKB1       KLIST
     C                   KFLD                    PrevDPBA
     C                   KFLD                    PrevDPBN
     C                   KFLD                    PrevDPSS
     C                   KFLD                    PrvDepot
     C                   KFLD                    SEC_MKTI
 
     C*****CDEPKB2       KLIST                                                                178378
     C************       KFLD                    PrevDPBA                                     178378
     C************       KFLD                    PrevDPBN                                     178378
     C************       KFLD                    PrevPTFR                                     178378
     C************       KFLD                    PrevDPSS                                     178378
     C************       KFLD                    PrvDepot                                     178378
     C************       KFLD                    SEC_MKTI                                     178378
     C     CDEPKB2       KLIST                                                                209844
     C                   KFLD                    PrevDPBA                                     209844
     C                   KFLD                    PrevDPBN                                     209844
     C                   KFLD                    PrevPTFR                                     209844
     C                   KFLD                    PrevDPSS                                     209844
     C                   KFLD                    PrvDepot                                     209844
     C                   KFLD                    SEC_MKTI                                     209844
 
     C************       IF        S01496 = 'N'                                               178378
     C                   IF        BGPFMG <> 'Y'                                              209844
     C                             AND BGN4ST <> 'Y'                                          209844
     C     CDEPKB1       CHAIN     CDEPPD1                            33
     C                   ELSE                                                                 209844
     C     CDEPKB2       CHAIN     CDEPPD2                            33                      209844
     C*    ensure RECI = 'D'                                                                  209844
     C     CD_RECI       DOWNE     'D'                                                        209844
     C     *IN33         ANDEQ     '0'                                                        209844
     C     CDEPKB2       READE     CDEPPD2                                33                  209844
     C                   ENDDO                                                                209844
     C                   END                                                                  209844
     C************       ELSE                                                                 178378
     C*****CDEPKB2       CHAIN     CDEPPD2                            33                      178378
     C************       END                                                                  178378
 
     C     *IN33         IFEQ      '1'
     C     *IN33         OREQ      '0'
     C     CD_RECI       ANDEQ     '*'
      *
      ** Not found/Record deleted, set up record
      *
     C                   DO
     C                   MOVE      'D'           CD_RECI
     C                   MOVE      DPBA          CD_CDPA
     C                   MOVE      DPBN          CD_CDCN
     C                   MOVE      DPSS          CD_CDSN
     C                   MOVE      PrvDepot      CD_CDPT
     C                   MOVE      SEC_MKTI      CD_CDMK
     C                   MOVE      PTFR          CD_PTFR
     C                   Z-ADD     Rundate       CD_DDTE
     C                   Z-ADD     *ZEROS        CD_CECN
     C                   Z-ADD     *ZEROS        CD_CDNT
     C                   Z-ADD     *ZEROS        CD_CDNV
     C                   Z-ADD     *ZEROS        CD_SNPT
     C                   Z-ADD     *ZEROS        CD_CDST
     C                   Z-ADD     *ZEROS        CD_CDNS
     C                   Z-ADD     *ZEROS        CD_SAPP
     C                   Z-ADD     *ZEROS        CD_SAPS
     C                   Z-ADD     *ZEROS        CD_CNPV
     C                   Z-ADD     *ZEROS        CD_CNSV
     C                   Z-ADD     *ZEROS        CD_SAPV
     C                   Z-ADD     *ZEROS        CD_SPSV
     C                   Z-ADD     *ZEROS        CD_CNSI
                                                                                              CGL031
     C**********         IF        CGL031 = 'Y'                                        CGL031 234440
     C                   Z-ADD     *ZEROS        CD_CPCH                                      CGL031
     C**********         Z-ADD     *ZEROS        CD_AFPT                               CGL031 233566
     C**********         Z-ADD     *ZEROS        CD_AFPV                               CGL031 233566
     C                   Z-ADD     *ZEROS        CD_SAFP                                      233566
     C                   Z-ADD     *ZEROS        CD_SAFS                                      233566
     C                   Z-ADD     *ZEROS        CD_SAPD                                      233566
     C**********         ENDIF                                                         CGL031 234440
 
     C                   ENDDO
     C                   ENDIF
 
     C     DPMV          IFEQ      'WI'
                                                                                             BUG2852
     C     CSE015        IFEQ      'Y'                                                       BUG2852
     C     PrevDMTD      IFLE      Rundate                                                   BUG2852
     C                   SUB       PrevDPNA      CD_CDST                                     BUG2852
     C                   SUB       PrevValue     CD_SAPS                                     BUG2852
     C                   ENDIF                                                               BUG2852
      *                                                                                      BUG2852
      ** If CSE015 is not installed, no more validation needed.                              BUG2852
      *                                                                                      BUG2852
     C                   ELSE                                                                BUG2852
     C                   SUB       PrevDPNA      CD_CDST
     C                   SUB       PrevValue     CD_SAPS
     C                   ENDIF                                                               BUG2852
 
     C     PrevDPMD      IFLE      Rundate
     C                   SUB       PrevDPNA      CD_CNSV
     C                   SUB       PrevValue     CD_SPSV
     C                   SUB       PrevDPNA      CD_CNSI
     C                   END
 
     C                   ELSE
                                                                                             BUG2852
     C     CSE015        IFEQ      'Y'                                                       BUG2852
     C     PrevDMTD      IFLE      Rundate                                                   BUG2852
     C                   ADD       PrevDPNA      CD_SNPT                                     BUG2852
     C                   SUB       PrevValue     CD_SAPP                                     BUG2852
     C                   ENDIF                                                               BUG2852
      *                                                                                      BUG2852
      ** If CSE015 is not installed, no more validation needed.                              BUG2852
      *                                                                                      BUG2852
     C                   ELSE                                                                BUG2852
     C                   ADD       PrevDPNA      CD_SNPT
     C                   SUB       PrevValue     CD_SAPP
     C                   ENDIF                                                               BUG2852
 
     C     PrevDPDO      IFLE      Rundate
     C                   ADD       PrevDPNA      CD_CNPV
     C                   SUB       PrevValue     CD_SAPV
     C                   ADD       PrevDPNA      CD_CNSI
     C                   END
 
     C                   END
 
     C                   MOVEL     NATN          CD_TNLU
 
     C     *IN33         IFEQ      '1'
 
     C************       IF        S01496 = 'N'                                               178378
     C                   IF        BGPFMG <> 'Y'                                              209844
     C                             AND BGN4ST <> 'Y'                                          209844
     C                   WRITE     CDEPPD1                              99
     C                   ELSE                                                                 209844
     C                   WRITE     CDEPPD2                              99                    209844
     C                   ENDIF                                                                209844
     C************       ELSE                                                                 178378
     C************       WRITE     CDEPPD2                              99                    178378
     C************       ENDIF                                                                178378
 
     C                   ELSE
 
     C************       IF        S01496 = 'N'                                               178378
     C                   IF        BGPFMG <> 'Y'                                              209844
     C                             AND BGN4ST <> 'Y'                                          209844
     C                   UPDATE    CDEPPD1                              99
     C                   ELSE                                                                 209844
     C                   UPDATE    CDEPPD2                              99                    209844
     C                   ENDIF                                                                209844
     C************       ELSE                                                                 178378
     C************       UPDATE    CDEPPD2                              99                    178378
     C************       ENDIF                                                                178378
 
     C                   END
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
      *
      ** If a new record has been written then increment audit
      ** file record no. of recs on file by 1
      *
     C     *IN33         IFEQ      '1'
     C*****1****         CHAIN     CDEPPAF                            34                      223870
     C     1             CHAIN     CDEPPAF                            3458                    223870
      *                                                                                       223870
     C                   Z-ADD     1             COUNT                                        223870
     C     *IN58         DOWEQ     '1'                                                        223870
     C     COUNT         ANDLT     7                                                          223870
      *                                                                                       223870
     C                   MOVEA     CMDDLY(1)     DLYJOB                                       223870
     C                   Z-ADD     80            CMDLEN                                       223870
     C                   CALL      'QCMDEXC'                              59                  223870
     C                   PARM                    DLYJOB                                       223870
     C                   PARM                    CMDLEN                                       223870
      *                                                                                       223870
     C     *IN59         IFEQ      '1'                                                        223870
     C                   MOVEL     'QCMDEXC'     DBKEY                                        223870
     C                   MOVEL     '*CALL   '    DBFILE                         ************  223870
     C                   MOVEL     '008'         DBASE                          * DBERR 008*  223870
      *                                                                         ************  223870
     C                   EXSR      SRErr                                                      223870
     C                   ENDIF                                                                223870
      *                                                                                       223870
     C     1             CHAIN     CDEPPAF                            3458                    223870
     C                   ADD       1             COUNT                                        223870
      *                                                                                       223870
     C                   ENDDO                                                                223870
 
     C     *IN34         IFEQ      '1'
     C     *IN58         OREQ      '1'                                                        223870
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'CDEPP   '    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRErr                                        ************
 
     C                   ELSE
 
     C                   ADD       1             CD_NORE
     C                   MOVEL     NATN          CD_TNLU
 
     C                   UPDATE    CDEPPAF                              99
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
 
     C                   END
     C                   END
      *
      ** If movement date LT date, update Customer position
      *
     C     PrvDate       IFLE      CD_DDTE
 
     C     CPOSKB        KLIST
     C                   KFLD                    PrevDPBA
     C                   KFLD                    DPSS
     C                   KFLD                    PrevDPBN
 
     C     CPOSKB        CHAIN     CPOSNDF                            33
                                                                                              CGL031
      ** Not found/Record deleted, set up record                                              CGL031
                                                                                              CGL031
     C                   IF        *IN33 = *ON OR                                             CGL031
     C                             *IN33 = *OFF AND CD_RECI = '*'                             CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     *ZEROS        CP_CSPI                                      CGL031
     C                   Z-ADD     *ZEROS        CP_CSAT                                      CGL031
     C                   Z-ADD     *ZEROS        CP_CSAV                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *
      ** If movement date before either Last Position Change date
      ** update corresponding flag
      *
     C     PrvDate       IFLT      CP_CSCT
     C                   MOVE      'Y'           CP_CSBT
     C                   MOVEL     NATN          CP_TNLU
     C                   END
     C*
     C     PrvDate       IFLT      CP_CSCV
     C                   MOVE      'Y'           CP_CSBV
     C                   MOVEL     NATN          CP_TNLU
     C                   END
 
     C                   UPDATE    CPOSNDF                              99
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
 
     C                   END
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdNewPs - Depot Previous Position update routine           *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUpdNewPs    BEGSR
      *
      ** Access Customer depot file
      *
     C     DPMV          IFEQ      'WI'
     C                   MOVE      DPID          NewDepot
     C                   ELSE
     C                   MOVE      DPOD          NewDepot
     C                   END
 
     C     CDEPKA1       KLIST
     C                   KFLD                    DPBA
     C                   KFLD                    DPBN
     C                   KFLD                    DPSS
     C                   KFLD                    NewDepot
     C                   KFLD                    SEC_MKTI
 
     C*****CDEPKA2       KLIST                                                                178378
     C************       KFLD                    DPBA                                         178378
     C************       KFLD                    DPBN                                         178378
     C************       KFLD                    PTFR                                         178378
     C************       KFLD                    DPSS                                         178378
     C************       KFLD                    NewDepot                                     178378
     C************       KFLD                    SEC_MKTI                                     178378
     C     CDEPKA2       KLIST                                                                209844
     C                   KFLD                    DPBA                                         209844
     C                   KFLD                    DPBN                                         209844
     C                   KFLD                    PTFR                                         209844
     C                   KFLD                    DPSS                                         209844
     C                   KFLD                    NewDepot                                     209844
     C                   KFLD                    SEC_MKTI                                     209844
 
     C************       IF        S01496 = 'N'                                               178378
     C                   IF        BGPFMG <> 'Y'                                              209844
     C                             AND BGN4ST <> 'Y'                                          209844
     C     CDEPKA1       CHAIN     CDEPPD1                            33
     C                   ELSE                                                                 209844
     C     CDEPKA2       CHAIN     CDEPPD2                            33                      209844
     C*    ensure RECI = 'D'                                                                  209844
     C     CD_RECI       DOWNE     'D'                                                        209844
     C     *IN33         ANDEQ     '0'                                                        209844
     C     CDEPKA2       READE     CDEPPD2                                33                  209844
     C                   ENDDO                                                                209844
     C                   END                                                                  209844
     C************       ELSE                                                                 178378
     C*****CDEPKA2       CHAIN     CDEPPD2                            33                      178378
     C************       END                                                                  178378
 
     C     *IN33         IFEQ      '1'
     C     *IN33         OREQ      '0'
     C     CD_RECI       ANDEQ     '*'
      *
      ** Not found/Record deleted, set up record
      *
     C                   DO
     C                   MOVE      'D'           CD_RECI
     C                   MOVE      DPBA          CD_CDPA
     C                   MOVE      DPBN          CD_CDCN
     C                   MOVE      DPSS          CD_CDSN
     C                   MOVE      NewDepot      CD_CDPT
     C                   MOVE      SEC_MKTI      CD_CDMK
     C                   MOVE      PTFR          CD_PTFR
 
     C     DPMV          IFEQ      'WI'
     C                   Z-ADD     DPMD          CD_DDTE
     C                   ELSE
     C                   Z-ADD     DPDO          CD_DDTE
     C                   END
 
     C                   Z-ADD     *ZEROS        CD_CECN
     C                   Z-ADD     *ZEROS        CD_CDNT
     C                   Z-ADD     *ZEROS        CD_CDNV
     C                   Z-ADD     *ZEROS        CD_SNPT
     C                   Z-ADD     *ZEROS        CD_CDST
     C                   Z-ADD     *ZEROS        CD_CDNS
     C                   Z-ADD     *ZEROS        CD_SAPP
     C                   Z-ADD     *ZEROS        CD_SAPS
     C                   Z-ADD     *ZEROS        CD_CNPV
     C                   Z-ADD     *ZEROS        CD_CNSV
     C                   Z-ADD     *ZEROS        CD_SAPV
     C                   Z-ADD     *ZEROS        CD_SPSV
     C                   Z-ADD     *ZEROS        CD_CNSI
     C                   ENDDO
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     *ZEROS        CD_CPCH                                      CGL031
     C**********         Z-ADD     *ZEROS        CD_AFPT                               CGL031 233566
     C**********         Z-ADD     *ZEROS        CD_AFPV                               CGL031 233566
     C                   Z-ADD     *ZEROS        CD_SAFP                                      233566
     C                   Z-ADD     *ZEROS        CD_SAFS                                      233566
     C                   Z-ADD     *ZEROS        CD_SAPD                                      233566
     C                   ENDIF                                                                CGL031
 
     C                   ENDIF
 
     C     DPMV          IFEQ      'WI'
                                                                                             BUG2852
     C     CSE015        IFEQ      'Y'                                                       BUG2852
     C     DMTD          IFLE      Rundate                                                   BUG2852
     C                   ADD       DPNA          CD_CDST                                     BUG2852
     C                   ADD       NewValue      CD_SAPS                                     BUG2852
     C                   ENDIF                                                               BUG2852
      *                                                                                      BUG2852
      ** If CSE015 is not installed, no more validation needed.                              BUG2852
      *                                                                                      BUG2852
     C                   ELSE                                                                BUG2852
     C                   ADD       DPNA          CD_CDST
     C                   ADD       NewValue      CD_SAPS
     C                   ENDIF                                                               BUG2852
     C                   Z-ADD     DPMD          NewDate
 
     C     DPMD          IFLE      Rundate
     C                   ADD       DPNA          CD_CNSV
     C                   ADD       NewValue      CD_SPSV
     C                   ADD       DPNA          CD_CNSI
     C                   END
 
     C                   ELSE
 
     C     CSE015        IFEQ      'Y'                                                       BUG2852
     C     DMTD          IFLE      Rundate                                                   BUG2852
     C                   SUB       DPNA          CD_SNPT                                     BUG2852
     C                   ADD       NewValue      CD_SAPP                                     BUG2852
     C                   ENDIF                                                               BUG2852
      *                                                                                      BUG2852
      ** If CSE015 is not installed, no more validation needed.                              BUG2852
      *                                                                                      BUG2852
     C                   ELSE                                                                BUG2852
     C                   SUB       DPNA          CD_SNPT
     C                   ADD       NewValue      CD_SAPP
     C                   ENDIF                                                               BUG2852
     C                   Z-ADD     DPDO          NewDate
      *
     C     DPDO          IFLE      Rundate
     C                   SUB       DPNA          CD_CNPV
     C                   ADD       NewValue      CD_SAPV
     C                   SUB       DPNA          CD_CNSI
     C                   END
 
     C                   END
 
     C                   MOVEL     NATN          CD_TNLU
 
     C     *IN33         IFEQ      '1'
 
     C************       IF        S01496 = 'N'                                               178378
     C                   IF        BGPFMG <> 'Y'                                              209844
     C                             AND BGN4ST <> 'Y'                                          209844
     C                   WRITE     CDEPPD1                              99
     C                   ELSE                                                                 209844
     C                   WRITE     CDEPPD2                              99                    209844
     C                   ENDIF                                                                209844
     C************       ELSE                                                                 178378
     C************       WRITE     CDEPPD2                              99                    178378
     C************       ENDIF                                                                178378
 
     C                   ELSE
 
     C************       IF        S01496 = 'N'                                               178378
     C                   IF        BGPFMG <> 'Y'                                              209844
     C                             AND BGN4ST <> 'Y'                                          209844
     C                   UPDATE    CDEPPD1                              99
     C                   ELSE                                                                 209844
     C                   UPDATE    CDEPPD2                              99                    209844
     C                   ENDIF                                                                209844
     C************       ELSE                                                                 178378
     C************       UPDATE    CDEPPD2                              99                    178378
     C************       ENDIF                                                                178378
 
     C                   END
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
      *
      ** Update audit file
      *
     C     *IN33         IFEQ      '1'
     C*****1****         CHAIN     CDEPPAF                            34                      223870
     C     1             CHAIN     CDEPPAF                            3460                    223870
      *                                                                                       223870
     C                   Z-ADD     1             COUNT                                        223870
     C     *IN60         DOWEQ     '1'                                                        223870
     C     COUNT         ANDLT     7                                                          223870
      *                                                                                       223870
     C                   MOVEA     CMDDLY(1)     DLYJOB                                       223870
     C                   Z-ADD     80            CMDLEN                                       223870
     C                   CALL      'QCMDEXC'                              61                  223870
     C                   PARM                    DLYJOB                                       223870
     C                   PARM                    CMDLEN                                       223870
      *                                                                                       223870
     C     *IN61         IFEQ      '1'                                                        223870
     C                   MOVEL     'QCMDEXC'     DBKEY                                        223870
     C                   MOVEL     '*CALL   '    DBFILE                         ************  223870
     C                   MOVEL     '009'         DBASE                          * DBERR 009*  223870
      *                                                                         ************  223870
     C                   EXSR      SRErr                                                      223870
     C                   ENDIF                                                                223870
      *                                                                                       223870
     C     1             CHAIN     CDEPPAF                            3460                    223870
     C                   ADD       1             COUNT                                        223870
      *                                                                                       223870
     C                   ENDDO                                                                223870
 
     C     *IN34         IFEQ      '1'
     C     *IN60         OREQ      '1'                                                        223870
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'CDEPP   '    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
                                                                                ************
     C                   EXSR      SRErr
 
     C                   ELSE
 
     C                   ADD       1             CD_NORE
     C                   MOVEL     NATN          CD_TNLU
 
     C                   UPDATE    CDEPPAF                              99
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
     C                   END
 
     C                   END
      *
      ** If movement date LT date, update Customer position
      *
     C     NewDate       IFLE      CD_DDTE
 
     C     CPOSKA        KLIST
     C                   KFLD                    DPBA
     C                   KFLD                    DPSS
     C                   KFLD                    DPBN
 
     C     CPOSKA        CHAIN     CPOSNDF                            33
      *
      ** If no record found, create new
      *
     C     *IN33         IFEQ      '1'
     C                   MOVE      'D'           CP_RECI
     C                   MOVE      DPBA          CP_CSBA
     C                   MOVE      DPSS          CP_CSSC
     C                   MOVE      DPBN          CP_CSCN
     C                   Z-ADD     NewDate       CP_CSDA
     C                   Z-ADD     *ZEROS        CP_CSNT
     C                   Z-ADD     *ZEROS        CP_CSNV
     C                   Z-ADD     *ZEROS        CP_CSNS
     C                   Z-ADD     *ZEROS        CP_CSEX
     C                   Z-ADD     *ZEROS        CP_CSPT
     C                   Z-ADD     *ZEROS        CP_CSPV
     C                   MOVE      'N'           CP_CSBT
     C                   MOVE      'N'           CP_CSBV
     C                   Z-ADD     *ZEROS        CP_CSCT
     C                   Z-ADD     *ZEROS        CP_CSCV
     C                   MOVEL     NATN          CP_TNLU
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     *ZEROS        CP_CSPI                                      CGL031
     C                   Z-ADD     *ZEROS        CP_CSAT                                      CGL031
     C                   Z-ADD     *ZEROS        CP_CSAV                                      CGL031
     C                   Z-ADD     *ZEROS        CP_AVFP                                      236705
     C     DPMV          IFEQ      'WO'                                                       236705
     C                   Z-ADD     *ZEROS        CP_APDT                                      236705
     c                   ELSE                                                                 236705
     C                   Z-ADD     DPMD          CP_APDT                                      236705
     c                   ENDIF                                                                236705
     C                   ENDIF                                                                CGL031
 
     C                   WRITE     CPOSNDF                              99
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
      *
      ** Update audit file
      *
     C*****1****         CHAIN     CPOSNAF                            33                      223870
     C     1             CHAIN     CPOSNAF                            3356                    223870
      *                                                                                       223870
     C                   Z-ADD     1             COUNT             1 0                        223870
     C     *IN56         DOWEQ     '1'                                                        223870
     C     COUNT         ANDLT     7                                                          223870
      *                                                                                       223870
     C                   MOVEA     CMDDLY(1)     DLYJOB           80                          223870
     C                   Z-ADD     80            CMDLEN                                       223870
     C                   CALL      'QCMDEXC'                              57                  223870
     C                   PARM                    DLYJOB                                       223870
     C                   PARM                    CMDLEN           15 5                        223870
      *                                                                                       223870
     C     *IN57         IFEQ      '1'                                                        223870
     C                   MOVEL     'QCMDEXC'     DBKEY                                        223870
     C                   MOVEL     '*CALL   '    DBFILE                         ************  223870
     C                   MOVEL     '007'         DBASE                          * DBERR 007*  223870
      *                                                                         ************  223870
     C                   EXSR      SRErr                                                      223870
     C                   ENDIF                                                                223870
      *                                                                                       223870
     C     1             CHAIN     CPOSNAF                            3356                    223870
     C                   ADD       1             COUNT                                        223870
      *                                                                                       223870
     C                   ENDDO                                                                223870
 
     C     *IN33         IFEQ      '1'
     C     *IN56         OREQ      '1'                                                        223870
 
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'CPOSN   '    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
                                                                                ************
     C                   EXSR      SRErr
 
     C                   ELSE
     C*
     C                   ADD       1             CP_NORE
     C                   MOVEL     NATN          CP_TNLU
 
     C                   UPDATE    CPOSNAF                              99
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
 
     C                   END
 
     C                   ELSE
      *
      ** If movement date before either Last Position Change date,
      ** update corresponding flag
      *
     C     NewDate       IFLT      CP_CSCT
 
     C     CP_RECI       IFEQ      '*'
     C                   MOVE      'D'           CP_RECI
     C                   END
 
     C                   MOVE      'Y'           CP_CSBT
     C                   MOVEL     NATN          CP_TNLU
     C                   END
     C*
     C     NewDate       IFLT      CP_CSCV
 
     C     CP_RECI       IFEQ      '*'
     C                   MOVE      'D'           CP_RECI
     C                   END
 
     C                   MOVE      'Y'           CP_CSBV
     C                   MOVEL     NATN          CP_TNLU
      *****************************************************************                236705 234440
     C*****CGL031        IFEQ      'Y'                                                 236705 234440
     C**********         CALLB     'SEVAPDT'                                           236705 234440
     C**********         PARM      DPBA          WBrca                                 236705 234440
     C**********         PARM      DPBN          WCust                                 236705 234440
     C**********         PARM      DPSS          WSesn                                 236705 234440
     C**********         PARM      DPMV          WType                                 236705 234440
     C**********         PARM      DPNA          WAmt                                  236705 234440
     C**********         PARM      DPMD          WDate                                 236705 234440
     C**********         PARM                    WrkAPDT                               236705 234440
     C*****DPMV*         IFEQ      'WO'                                                236705 234440
     C*****WrkAPDT       IFEQ      *ZEROS                                              236705 234440
     C**********         Z-ADD     WrkAPDT       CP_APDT                               236705 234440
     c**********         ENDIF                                                         236705 234440
     c**********         ELSE                                                          236705 234440
     C**********         Z-ADD     WrkAPDT       CP_APDT                               236705 234440
     c**********         ENDIF                                                         236705 234440
      *****************************************************************                236758 234440
     C**********         CALLB     'SEVCSPI'                                           236758 234440
     C**********         PARM      V_CHTP        WAction           1                   236758 234440
     C**********         PARM      DPBA          WBrca                                 236758 234440
     C**********         PARM      DPBN          WCust                                 236758 234440
     C**********         PARM      DPSS          WSesn                                 236758 234440
     C**********         PARM      DPMV          WType                                 236758 234440
     C**********         PARM      DPNA          WAmt                                  236758 234440
     C**********         PARM      OPIN          WPInt            11 0                 236758 234440
     C**********         PARM                    WrkCSPI                               236758 234440
     C**********         Z-ADD     WrkCSPI       CP_CSPI                               236758 234440
     C**********         ENDIF                                                         236705 234440
     C                   END
 
     C                   UPDATE    CPOSNDF                              99
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
 
     C                   END
      *****************************************************************                236705 234440
     C**********         ELSE                                                          236705 234440
      *****************************************************************                236705 234440
     C*****CGL031        IFEQ      'Y'                                                 236705 234440
     C**********         CALLB     'SEVAPDT'                                           236705 234440
     C**********         PARM      DPBA          WBrca                                 236705 234440
     C**********         PARM      DPBN          WCust                                 236705 234440
     C**********         PARM      DPSS          WSesn                                 236705 234440
     C**********         PARM      DPMV          WType                                 236705 234440
     C**********         PARM      DPNA          WAmt                                  236705 234440
     C**********         PARM      DPMD          WDate                                 236705 234440
     C**********         PARM                    WrkAPDT                               236705 234440
     C*****DPMV*         IFEQ      'WO'                                                236705 234440
     C*****WrkAPDT       IFEQ      *ZEROS                                              236705 234440
     C**********         Z-ADD     WrkAPDT       CP_APDT                               236705 234440
     c**********         ENDIF                                                         236705 234440
     c**********         ELSE                                                          236705 234440
     C**********         Z-ADD     WrkAPDT       CP_APDT                               236705 234440
     c**********         ENDIF                                                         236705 234440
      **********                                                                       236758 234440
     C**********         CALLB     'SEVCSPI'                                           236758 234440
     C**********         PARM      V_CHTP        WAction           1                   236758 234440
     C**********         PARM      DPBA          WBrca                                 236758 234440
     C**********         PARM      DPBN          WCust                                 236758 234440
     C**********         PARM      DPSS          WSesn                                 236758 234440
     C**********         PARM      DPMV          WType                                 236758 234440
     C**********         PARM      DPNA          WAmt                                  236758 234440
     C**********         PARM      OPIN          WPInt            11 0                 236758 234440
     C**********         PARM                    WrkCSPI                               236758 234440
     C**********         Z-ADD     WrkCSPI       CP_CSPI                               236758 234440
      **********                                                                       236705 234440
     C**********         UPDATE    CPOSNDF                              99             236705 234440
      **********                                                                       236705 234440
     C******IN99         CASEQ     '1'           SRErr                                 236705 234440
     C**********         ENDCS                                                         236705 234440
     c**********         ENDIF                                                         236705 234440
 
     C                   END
      *
      ** If No record on Customer Position Profit Centre file
      ** need to add one and amend the Audit file
      *
     C     BKPRCU        IFEQ      'Y'
 
     C     SEPCCK        KLIST
     C                   KFLD                    DPBN
     C                   KFLD                    DPBA
     C                   KFLD                    DPSS
 
     C     SEPCCK        CHAIN     SEPCCD                             33
 
     C     *IN33         IFEQ      '1'
     C                   MOVEL     'D'           SP_RECI
     C                   MOVEL     DPBN          SP_CNUM
     C                   MOVEL     DPBA          SP_BRCA
     C                   MOVEL     DPSS          SP_SESN
     C                   MOVEL     DPPC          SP_PCCU
     C                   MOVEL     Rundate       SP_LCD
     C                   MOVEL     'I'           SP_CHTP
     C                   MOVEL     NATN          SP_TNLU
     C                   MOVE      *BLANKS       SP_PTFR
     C                   MOVE      PTFR          SP_PTFR                        CPB001
 
     C                   WRITE     SEPCCDF                              99
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
 
     C     1             CHAIN     SEPCAF                             33
     C     *IN33         IFEQ      '1'
 
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'SEPCA   '    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
                                                                                ************
     C                   EXSR      SRErr
 
     C                   ELSE
     C                   ADD       1             SP_NORE
     C                   ADD       1             SP_SINS
 
     C                   UPDATE    SEPCAF                               99
 
     C     *IN99         CASEQ     '1'           SRErr
     C                   ENDCS
 
     C                   END
 
     C                   END
     C                   END
 
     C                   ENDSR
 
      *****************************************************************                       CSE039
      *                                                               *                       CSE039
      *  SrMovement - Movement Status Record                          *                       CSE039
      *                                                               *                       CSE039
      *****************************************************************                       CSE039
     C     SrMovement    BEGSR                                                                CSE039
      *                                                                                       CSE039
      ** Key list to access Movement Status file                                              CSE039
     C     KeyMove       KLIST                                                                CSE039
     C                   KFLD                    KTRRF             6                          CSE039
     C                   KFLD                    KTRTY             1                          CSE039
     C                   KFLD                    KNTDT             5 0                        CSE039
      *                                                                                       CSE039
      ** Transaction Reference                                                                CSE039
     C                   Eval      TMTRRF = V_DPRN                                            CSE039
     C                   Eval      KTRRF = V_DPRN                                             CSE039
      *                                                                                       CSE039
      ** Transaction Type                                                                     CSE039
     C                   Eval      TMTRTY = 'W'                                               CSE039
     C                   Eval      KTRTY = 'W'                                                CSE039
      *                                                                                       CSE039
      ** Notification Date                                                                    CSE039
     C                   Z-Add     BJRDNB        TMNTDT                                       CSE039
     C                   Z-Add     BJRDNB        KNTDT                                        CSE039
      *                                                                                       CSE039
      ** Sequence Number                                                                      CSE039
     C     KeyMove       Chain     SEMVTSL0                           80                      CSE039
     C                   If        *IN80 = '1'                                                CSE039
     C                   Z-Add     1             TMSQNR                                       CSE039
     C                   Else                                                                 CSE039
     C     MV_TMSQNR     Add       1             TMSQNR                                       CSE039
     C                   EndIf                                                                CSE039
      *                                                                                       CSE039
      ** SWIFT Status Code                                                                    CSE039
     C                   Select                                                               CSE039
     C                   When      V_CHTP = 'I'                                               CSE039
     C                   Movel     'INS'         TMSWSC                                       CSE039
     C                   When      V_CHTP = 'A'                                               CSE039
     C                   Movel     'AMD'         TMSWSC                                       CSE039
     C                   When      V_CHTP = 'D'                                               CSE039
     C                   Movel     'DEL'         TMSWSC                                       CSE039
     C                   EndSl                                                                CSE039
      *                                                                                       CSE039
      ** SWIFT Reason Code                                                                    CSE039
     C                   Eval      TMSWRC = *Blanks                                           CSE039
      *                                                                                       CSE039
      ** Notification Method: From Interface                                                  CSE039
     C                   Eval      TMNTMT = V_NOTM                                            CSE039
      *                                                                                       CSE039
      ** Message Key: From Interface                                                          CSE039
     C                   Eval      TMMSGK = V_MSGK                                            CSE039
      *                                                                                       CSE039
      ** Narrative                                                                            CSE039
     C                   Eval      TMNARR = *Blanks                                           CSE039
      *                                                                                       CSE039
      ** Input Origin                                                                         CSE039
     C                   Eval      TMINOR = 'Midas'                                           CSE039
      *                                                                                       CSE039
      ** Settlement Message Generated                                                         CSE039
     C                   Eval      TMSTMG = *Blanks                                           CSE039
      *                                                                                       CSE039
      ** Transaction Booking Branch                                                           CSE039
     C                   EVAL      TMTRBB = V_DPBA                                            CSE039
      *                                                                                       CSE039
      ** Front Office Id                                                                      CSE039
     C                   Eval      TMFRNT = V_DMFRNT                                          CSE039
      *                                                                                       CSE039
      ** Time Stamp                                                                           CSE039
     C                   CallB     'ZAGENTMSTM'                                               CSE039
     C                   Parm                    Timestamp                                    CSE039
     C                   Eval      TMTMST = Timestamp                                         CSE039
      *                                                                                       CSE039
      ** Last Change Type                                                                     CSE039
     C                   Eval      TMLCTP = 'I'                                               CSE039
      *                                                                                       CSE039
      ** Last Change Date                                                                     CSE039
     C                   Z-Add     BJRDNB        TMLCDT                                       CSE039
      *                                                                                       CSE039
      ** Last Change User                                                                     CSE039
     C                   Eval      TMLCUS = PsUser                                            CSE039
      *                                                                                       CSE039
      ** Output a record to the Trade Movement Status File                                    CSE039
      *                                                                                       CSE039
      *                 ********************                                                  CSE039
     C                   Write     SEMVTSD06                            99                    CSE039
      *                 ********************                                                  CSE039
      *                                                                                       CSE039
     C                   ENDSR                                                                CSE039
      *                                                                                       CSE039
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZLCD - Compute Last Coupon Date                             *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZLCD        BEGSR
 
     C                   CALLB     'ZLCD'
     C                   PARM                    SEC_ISSD
     C                   PARM                    SEC_ITLD
     C                   PARM                    SEC_FCPN
     C                   PARM                    SEC_MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    SEC_LCPN                                   BUG11009
      *
      ** Event Control Date
      ** Date Format
     C                   PARM                    ZECD              5 0
     C                   PARM                    BJDFIN
                                                                                              CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY              3                          CSE005
     C                   PARM                    SITP              3                          CSE005
     C                   PARM                    BCNV              1                          CSE005
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    SEC_HCY1                                     CSE071
     C                   PARM                    SEC_HCY2                                     CSE071
     C                   PARM                    SEC_HCY3                                     CSE071
     C                   PARM                    SEC_HCY4                                     CSE071
     C                   PARM                    SEC_HCY5                                     CSE071
     C                   PARM                    SEC_HCY6                                     CSE071
     C                   PARM                    SEC_HCY7                                     CSE071
     C                   PARM                    SEC_HCY8                                     CSE071
     C                   PARM                    SEC_HCY9                                     CSE071
 
      * OUTPUTS
      ** Last Coupon Date before Control Date
     C                   PARM                    ZZLCD             5 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZNCD - Compute Next Coupon Date                             *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZNCD        BEGSR
 
     C                   CALLB     'ZNCD'
     C                   PARM                    SEC_ITLD
     C                   PARM                    SEC_FCPN
     C                   PARM                    SEC_MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
      *
      ** Event Control Date
      ** Date Format
     C                   PARM                    ECD               5 0
     C                   PARM                    BJDFIN
                                                                                              CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY                                         CSE005
     C                   PARM                    SITP                                         CSE005
     C                   PARM                    BCNV                                         CSE005
      ** Last Coupon Date                                                                     CSE031
     C                   PARM                    LCPN              5 0                        CSE031
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    SEC_HCY1                                     CSE071
     C                   PARM                    SEC_HCY2                                     CSE071
     C                   PARM                    SEC_HCY3                                     CSE071
     C                   PARM                    SEC_HCY4                                     CSE071
     C                   PARM                    SEC_HCY5                                     CSE071
     C                   PARM                    SEC_HCY6                                     CSE071
     C                   PARM                    SEC_HCY7                                     CSE071
     C                   PARM                    SEC_HCY8                                     CSE071
     C                   PARM                    SEC_HCY9                                     CSE071
 
      * OUTPUTS
      ** Next Coupon Date
     C                   PARM                    NCD               5 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZACCZ - Compute Accrued Interest                            *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZACCZ       BEGSR
 
     C                   CALLB     'ZACCZ'
     C                   PARM                    ZAMT
     C                   PARM                    ZDCSDT
     C                   PARM                    ZDCEDT
      *
      ** Security Details
      ** Interest days adjustment
      ** Next Coupon Date (5P 0)
      ** Nominal currency decimal places (1P 0)
      ** Processing Type (1A)
     C                   PARM                    SECTY1
     C                   PARM                    DADJN             1
     C                   PARM                    NCD
     C                   PARM                    NomCcyDec
     C                   PARM                    INV_PROT
      *
      ** System Date Format (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      ** Accrued Interest  (13P 0)
      ** Accrued Interest  (15P 1)
      ** No. of days (ZDAYS output)
      ** No. of days in interest year (ZDYYR output)
     C                   PARM                    ZDCINT           13 0
     C                   PARM                    ZDXINT           15 1
     C                   PARM                    ZDDAYS            5 0
     C                   PARM                    ZINTDD            5 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZYCE   -   For Australian Yield Formulae - Determine        *
      *              whether the passed date is in the cum- or ex-    *
      *              coupon date range for this security.             *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZYCE        BEGSR
 
     C                   CALLB     'ZYCE'
     C                   PARM                    WRKD              5 0
     C                   PARM                    NCD
     C                   PARM                    EDFT              3
     C                   PARM                    ZLOC              3
     C                   PARM                    SEC_NMCY
      * OUTPUTS
      ** Cum/Ex coupon indicator (1A)
     C                   PARM                    SCUMEX
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZPRCI -  - Generate Transcation No. Routine                 *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZPRCI       BEGSR
 
     C                   CALLB     'ZPRCI'
     C                   PARM                    ZPRCIN           15 8
     C                   PARM                    ZFDATE            5 0
      *
      ** Security Details
      ** Nominal currency decimal position  (1P 0)
      ** Processing type (1A)
     C                   PARM                    SECTY1
     C                   PARM                    NomCcyDec         1 0
     C                   PARM                    INV_PROT
      *
      ** Nominal (15P 0)
      ** Purchased interest working variable (15P 9)
      ** CUM/Ex-coupon indicator (1A)
     C                   PARM                    ZNOML
     C                   PARM                    WRKPI            15 9
     C                   PARM                    SCUMEX
 
      ** System Info
      ** Date format (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      ** Zyld Ok indicator (1A)
      ** Price as Percentage (15P 8)
     C                   PARM                    ZYLDOk            1
     C                   PARM                    ZPRCOT           15 8
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZCNSD - Calculate Consideration                             *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZCNSD       BEGSR
 
     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM                    SEC_SPBS
     C                   PARM                    SEC_NMDP
     C                   PARM                    NomCcyDec
 
      * OUTPUTS
 
      **  Consideration
     C                   PARM                    ZCONS            15 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenTrnNo - Generate Transcation No. Routine                 *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRGenTrnNo    BEGSR
      *
      ** Initialize Transaction Number
      *
     C                   Z-ADD     0             NATN              5 0
      *
      ** Call  Ref. no. Generation program
      *
     C*****              CALLB     'ZTNLU1'
     C*****              PARM                    ReturnCode
     C*****              PARM                    NATN
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialization Routine                               *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
     C                   CLEAR                   DPMVDS
      *
      ** Zeroise Numeric fields
      *
     C**********         Z-ADD     *ZERO         DPID                                         CSD027
     C                   EVAL      DPID = *BLANKS                                             CSD027
     C                   Z-ADD     *ZERO         DPMD
     C**********         Z-ADD     *ZERO         DPOD                                         CSD027
     C                   EVAL      DPOD = *BLANKS                                             CSD027
     C                   Z-ADD     *ZERO         DPDO
     C**********         Z-ADD     *ZERO         DPBN                                         CSD027
     C                   EVAL      DPBN = *BLANKS                                             CSD027
     C                   Z-ADD     *ZERO         DPNA
     C                   Z-ADD     *ZERO         MKTP
     C                   Z-ADD     *ZERO         DPAD
     C                   Z-ADD     *ZERO         ORED
     C                   Z-ADD     *ZERO         LCD
     C                   Z-ADD     *ZERO         TNLU
     C                   Z-ADD     *ZERO         DCHA
     C                   Z-ADD     *ZERO         DCSE
     C                   Z-ADD     *ZERO         DPVD
     C                   Z-ADD     *ZERO         SPXR
     C                   Z-ADD     *ZERO         CYLD
     C                   Z-ADD     *ZERO         PINT                           CPB001
     C**********         Z-ADD     *ZERO         CPTY                                  207006 CSD027
     C                   EVAL      CPTY = *BLANKS                                             CSD027
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvSec -  Retrieve Security details.                        *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRtvSec      BEGSR
 
     C     V_DPSS        CHAIN     SECTYDF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     V_DPSS        DBKEY
     C                   MOVEL     'SECTY   '    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRErr                                        ************
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTrans -  Retrieve transaction Details                    *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRtvTrans    BEGSR
 
     C     DPTMVK        KLIST
     C                   KFLD                    V_DPSS
     C                   KFLD                    V_DPRN
      *
      ** Validate Transaction Reference and Security
     C/COPY WNCPYSRC,SEDPMVDC15
      *
     C     DPTMVK        CHAIN     DPTMVDF                            33
     C/COPY WNCPYSRC,SEDPMVDC16
      *                                                                                       CAP087
      ** If Transaction Ref + Security found, also check for the                              CAP087
      ** Depot Movement type and continue reading the file until                              CAP087
      ** the correct record was retrieved.                                                    CAP087
      *                                                                                       CAP087
     C     *IN33         DOWEQ     '0'                                                        CAP087
      *                                                                                       CAP087
     C     DPRN          IFEQ      V_DPRN                                                     CAP087
     C     DPSS          ANDEQ     V_DPSS                                                     CAP087
      *                                                                                       CAP087
     C     DPMV          IFEQ      V_DPMV                                                     CAP087
     C                   LEAVE                                                                CAP087
     C                   ELSE                                                                 CAP087
     C                   READ      DPTMVDF                                33                  CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
     C                   MOVE      '1'           *IN33                                        CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ENDDO                                                                CAP087
 
     C     *IN33         IFEQ      '1'
 
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVE      V_DPRN        DBKEY
     C                   MOVEL     V_DPSS        DBKEY
     C                   MOVEL     'DPTMV   '    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
                                                                                ************
     C                   EXSR      SRErr
 
     C                   ELSE
      *
      ** Move the details of the previous transaction to a working DS
      *
     C                   MOVEL     DPMVDS        PrvDPMVRec
      *
      ** Reset Working DS
      *
     C                   EXSR      SRInit
 
     C                   END
 
     C                   ENDSR
 
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRErr - Exception Errors                                     *
      *                                                              *
      ****************************************************************
     C     SRErr         BEGSR
      *
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
      **  Terminate the Program
      *
     C                   EXSR      *PSSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *InzSR        BEGSR
 
     C     *ENTRY        PLIST
 
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
 
      ** Incoming Transaction
 
     C                   PARM                    DPMVTrans
                                                                                              CSD015
      ** Added parameter for Midas Compliance Watch                                           CSD015
     C                   PARM                    PMCWL                                        CSD015
     C*****              PARM                    V_NOTM            7                   CSE039 222727
     C*****              PARM                    V_MSGK           40                   CSE039 222727
     C                   PARM                    P_NOTM            7                          222727
     C                   PARM                    P_MSGK           40                          222727
     C                   PARM                    CGL031                                       CGL031
 
     C                   EVAL      V_NOTM = P_NOTM                                            222727
     C                   EVAL      V_MSGK = P_MSGK                                            222727
     C                   MOVEL     'SEDPMVUPD'   DBPGM            10
 
     C/COPY WNCPYSRC,SEH00084
      ** ICD Information Retrieval starts here
      ** -------------------------------------
 
      *
      ** Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE                          **************
     C                   MOVEL     @OPTN         DBKEY                          * DB ERROR 01*
     C                   EXSR      SRERR                                        **************
     C                   END
 
     C                   MOVE      BJRDNB        RunDate           5 0
      *
      ** Get General Ledger ICD
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   EXSR      SRERR                                        ************
     C                   END
      *                                                                                       209844
      ** ACCESS MIDAS MODULE DETAILS                                                          209844
      *                                                                                       209844
     C                   CALLB     'AOMMODR0'                                                 209844
     C                   PARM      '*MSG    '    @RTCD                                        209844
     C                   PARM      '*FIRST  '    @OPTN                                        209844
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        209844
      *                                                                                       209844
      * DATABASE ERROR                                                                        209844
      *                                                                                       209844
     C     @RTCD         IFNE      *BLANK                                                     209844
     C                   MOVEL     @OPTN         DBKEY                                        209844
     C                   MOVEL     'SDMMODPD'    DBFILE                                       209844
     C                   MOVEL     '903'         DBASE                                        209844
     C                   EXSR      SRERR                                                      209844
     C                   END                                                                  209844
      ***********                                                                             209844
      ***Check*if*switchable*feature*S01496*is*switched*on.************                       209844
      ***********                                                                             209844
     C***********        MOVE      'N'           S01496            1                          209844
      ***********                                                                             209844
     C***********        CALL      'AOSARDR0'                                                 209844
     C***********        PARM      *BLANKS       @RTCD                                        209844
     C***********        PARM      '*VERIFY'     @OPTN                                        209844
     C***********        PARM      'S01496'      @SARD                                        209844
      ***********                                                                             209844
      ***DATABASE*ERROR************************************************                       209844
      ***********                                                                             209844
     C*****@RTCD*        IFNE      *BLANKS                                                    209844
     C*****@RTCD*        ANDNE     '*NRF   '                                                  209844
     C***********        MOVEL     'S01496'      DBKEY                                        209844
     C***********        MOVEL     'SCSARDPD'    DBFILE                         ************  209844
     C***********        MOVEL     '903'         DBASE                          * DBERR 903*  209844
     C***********        EXSR      SRERR                                        ************  209844
     C***********        ELSE                                                                 209844
     C*****@RTCD*        IFEQ      *BLANKS                                             183768 209844
     C***********        MOVE      'Y'           S01496                                       209844
     C***********        END                                                           183768 209844
     C***********        END                                                                  209844
     C/COPY WNCPYSRC,SEDPMVDC03
      *                                                                                       CSE017
      ** Check if switchable feature CSE017 is switched on.                                   CSE017
      *                                                                                       CSE017
     C                   MOVE      'N'           CSE017            1                          CSE017
     C                   CALL      'AOSARDR0'                                                 CSE017
     C                   PARM      *BLANKS       @RTCD                                        CSE017
     C                   PARM      '*VERIFY'     @OPTN                                        CSE017
     C                   PARM      'CSE017'      @SARD                                        CSE017
      *                                                                                       CSE017
      ** Database error                                                                       CSE017
      *                                                                                       CSE017
     C     @RTCD         IFNE      *BLANKS                                                    CSE017
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE017
     C                   MOVEL     'CSE017'      DBKEY                                        CSE017
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE017
     C                   MOVEL     '904'         DBASE                                        CSE017
     C                   EXSR      SRERR                                                      CSE017
     C                   ELSE                                                                 CSE017
     C     @RTCD         IFEQ      *BLANKS                                                    CSE017
     C                   MOVE      'Y'           CSE017                                       CSE017
     C                   END                                                                  CSE017
     C                   END                                                                  CSE017
      *                                                                                       CSE015
      ** Check if switchable feature CSE015 is switched on.                                   CSE015
      *                                                                                       CSE015
     C                   MOVE      'N'           CSE015            1                          CSE015
     C                   CALL      'AOSARDR0'                                                 CSE015
     C                   PARM      *BLANKS       @RTCD                                        CSE015
     C                   PARM      '*VERIFY'     @OPTN                                        CSE015
     C                   PARM      'CSE015'      @SARD                                        CSE015
      *                                                                                       CSE015
      ** Database error                                                                       CSE015
      *                                                                                       CSE015
     C     @RTCD         IFNE      *BLANKS                                                    CSE015
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE015
     C                   MOVEL     'CSE015'      DBKEY                                        CSE015
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE015
     C                   MOVEL     '905'         DBASE                                        CSE015
     C                   EXSR      SRERR                                                      CSE015
     C                   ELSE                                                                 CSE015
     C     @RTCD         IFEQ      *BLANKS                                                    CSE015
     C                   MOVE      'Y'           CSE015                                       CSE015
     C                   END                                                                  CSE015
     C                   END                                                                  CSE015
      *                                                                                       167486
      ** Check if switchable feature S01401 is switched on.                                   167486
      *                                                                                       167486
     C                   MOVE      'N'           S01401            1                          167486
                                                                                              167486
     C                   CALL      'AOSARDR0'                                                 167486
     C                   PARM      *BLANKS       @RTCD                                        167486
     C                   PARM      '*VERIFY'     @OPTN                                        167486
     C                   PARM      'S01401'      @SARD                                        167486
      *                                                                                       167486
      ** DATABASE ERROR                                                                       167486
      *                                                                                       167486
     C     @RTCD         IFNE      *BLANKS                                                    167486
     C     @RTCD         ANDNE     '*NRF   '                                                  167486
     C                   MOVEL     'S01401'      DBKEY                                        167486
     C                   MOVEL     'SCSARDPD'    DBFILE                                       167486
     C                   MOVEL     '904'         DBASE                                        167486
     C                   EXSR      SRERR                                                      167486
     C                   ELSE                                                                 167486
     C     @RTCD         IFEQ      *BLANKS                                                    183768
     C                   MOVE      'Y'           S01401                                       167486
     C                   END                                                                  183768
     C                   END                                                                  167486
      *                                                                                       CSE018
      ** Check if switchable feature CSE018 is switched on.                                   CSE018
      *                                                                                       CSE018
     C                   MOVE      'N'           CSE018            1                          CSE018
     C                   CALL      'AOSARDR0'                                                 CSE018
     C                   PARM      *BLANKS       @RTCD                                        CSE018
     C                   PARM      '*VERIFY'     @OPTN                                        CSE018
     C                   PARM      'CSE018'      @SARD                                        CSE018
      *                                                                                       CSE018
      ** Database error                                                                       CSE018
      *                                                                                       CSE018
     C     @RTCD         IFNE      *BLANKS                                                    CSE018
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE018
     C                   MOVEL     'CSE018'      DBKEY                                        CSE018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE018
     C                   MOVEL     '906'         DBASE                                        CSE018
     C                   EXSR      SRERR                                                      CSE018
     C                   ELSE                                                                 CSE018
     C     @RTCD         IFEQ      *BLANKS                                                    CSE018
     C                   MOVE      'Y'           CSE018                                       CSE018
     C                   END                                                                  CSE018
     C                   END                                                                  CSE018
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE  = 907                                               CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
      ** Check if switchable feature CSE039 is switched on.                                   CSE039
      *                                                                                       CSE039
     C                   MOVE      'N'           CSE039            1                          CSE039
     C                   CALL      'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD                                        CSE039
     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
     C                   PARM      'CSE039'      @SARD                                        CSE039
     C     @RTCD         IFEQ      *BLANKS                                                    CSE039
     C                   MOVE      'Y'           CSE039                                       CSE039
     C                   END                                                                  CSE039
      *                                                                                       CSE039
     C                   IN        SDSTAT                                                     CSD015
      *                                                                                       235546
      ** Check if switchable feature CSE023 is switched on.                                   235546
      *                                                                                       235546
     C                   CALL      'AOSARDR0'                                                 235546
     C                   PARM      *BLANKS       @RTCD                                        235546
     C                   PARM      '*VERIFY'     @OPTN                                        235546
     C                   PARM      'CSE023'      @SARD                                        235546
     C     @RTCD         IFEQ      *BLANKS                                                    235546
     C                   MOVE      'Y'           CSE023            1                          235546
     C                   END                                                                  235546
      *****************************************************************                236705 234440
     C******LIKE         DEFINE    DPBA          WBrca                                 236705 234440
     C******LIKE         DEFINE    DPSS          WSesn                                 236705 234440
     C******LIKE         DEFINE    DPMV          WType                                 236705 234440
     C******LIKE         DEFINE    DPNA          WAmt                                  236705 234440
     C******LIKE         DEFINE    DPMD          WDate                                 236705 234440
     C******LIKE         DEFINE    DPMD          WrkAPDT                               236705 234440
     C******LIKE         DEFINE    OPIN          WrkCSPI                               236758 234440
     C     *LIKE         DEFINE    DMTMST        PTMST                                        235546
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
      *                                                                                       CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RTCD                                        CSD015
     C                   PARM      '*VERIFY'     @OPTN                                        CSD015
     C                   PARM      'CSD015'      @SARD                                        CSD015
      *                                                                                       CSD015
      ** DATABASE ERROR                                                                       CSD015
      *                                                                                       CSD015
     C                   MOVE      'N'           CSD015            1                          CSD015
     C     @RTCD         IFNE      *BLANKS                                                    CSD015
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE =  908                                               CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ELSE                                                                 CSD015
     C     @RTCD         IFEQ      *BLANKS                                                    CSD015
     C                   MOVE      'Y'           CSD015            1                          CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
 
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RTCD                                        CSD015
     C                   PARM      '*FIRST '     @OPTN                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSFDY                                        CSD015
      *                                                                                       CSD015
      ** DATABASE ERROR                                                                       CSD015
      *                                                                                       CSD015
     C     @RTCD         IFNE      *BLANKS                                                    CSD015
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD015
     C                   EVAL      DBKEY = @OPTN                                              CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE =  909                                               CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Check if function code is being monitored by compliance watch.                       CSD015
      *                                                                                       CSD015
     C                   CALL      'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       @RTCD                                        CSD015
     C                   PARM      '*KEY   '     @OPTN                                        CSD015
     C                   PARM      'SECTTRAD'    PFUNC             8                          CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
      *                                                                                       CSD015
      ** If return code not blank, then issue database error.                                 CSD015
      *                                                                                       CSD015
     C     @RTCD         IFNE      *BLANKS                                                    CSD015
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD015
     C                   EVAL      DBKEY  = 'TRANSACT'                                        CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 911                                                CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RTCD                                        CSD015
     C                   PARM      '*VERIFY'     @OPTN                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
      *                                                                                       CSD015
      ** DATABASE ERROR                                                                       CSD015
      *                                                                                       CSD015
     C                   MOVE      'N'           CCF001            1                          CSD015
     C     @RTCD         IFNE      *BLANKS                                                    CSD015
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD015
     C                   EVAL      DBKEY = 'CCF001'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE =  910                                               CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ELSE                                                                 CSD015
     C     @RTCD         IFEQ      *BLANKS                                                    CSD015
     C                   MOVE      'Y'           CCF001            1                          CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CRE020
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   EVAL      DBase = 912                                                CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   CALLB     'AOSVALR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM                    PSysVal01                                    CRE020
     C                   PARM                    PCurSet01                                    CRE020
     C                   PARM                    PSysVal02                                    CRE020
     C                   PARM                    PCurSet02                                    CRE020
     C                   PARM                    PSysVal03                                    CRE020
     C                   PARM                    PCurSet03                                    CRE020
     C                   PARM                    PSysVal04                                    CRE020
     C                   PARM                    PCurSet04                                    CRE020
     C                   PARM                    PSysVal05                                    CRE020
     C                   PARM                    PCurSet05                                    CRE020
     C                   PARM                    PSysVal06                                    CRE020
     C                   PARM                    PCurSet06                                    CRE020
     C                   PARM                    PSysVal07                                    CRE020
     C                   PARM                    PCurSet07                                    CRE020
     C                   PARM                    PSysVal08                                    CRE020
     C                   PARM                    PCurSet08                                    CRE020
     C                   PARM                    PSysVal09                                    CRE020
     C                   PARM                    PCurSet09                                    CRE020
     C                   PARM                    PSysVal10                                    CRE020
     C                   PARM                    PCurSet10                                    CRE020
                                                                                              CRE020
     C                   EVAL      WDptMvAdv = 'N'                                            CRE020
     C                   EVAL      WDptWIAdv = 'N'                                            CRE020
     C                   EVAL      WDptWOAdv = 'N'                                            CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WDptMvAdv                                    CRE020
     C                   MOVEL     PCurSet02     WDptWIAdv                                    CRE020
     C                   MOVEL     PCurSet03     WDptWOAdv                                    CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 913                                                CRE020
     C                   EVAL      DBKey = PSysVal01 + PSysVal02 +                            CRE020
     C                                     PSysVal03                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CSW210
      ** Check to see if switchable feature CSW210 is on                                      CSW210
      *                                                                                       CSW210
     C                   CALL      'SWIF2010'                                                 CSW210
     C                   PARM      *BLANKS       PRTCD                                        CSW210
                                                                                              CSW210
     C                   IF        PRTCD = 'CSW2010'                                          CSW210
     C                   EVAL      CSW210 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      CSW210 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSD015
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRtCd                                        CSD083
     C                   PARM      '*VERIFY'     POptn                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRtCd <> *BLANKS AND                                       CSD083
     C                             PRtCd <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EVAL      DBase = 914                                                CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      SRErr                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRtCd = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
     C/COPY WNCPYSRC,SEH00085
                                                                                              CSD083
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWATCH - Subroutine to send details to wtach list engine      *                      CSD015
      *                                                               *                       CSD015
      * Called by: Main program                                       *                       CSD015
      *                                                               *                       CSD015
      * Calls: SDCWHLCHK                                              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWATCH       BEGSR                                                                CSD015
                                                                                              CSD015
     C     KEY1          KLIST                                                                CSD015
     C                   KFLD                    W4FUNT                                       CSD015
     C                   KFLD                    W4IDEN                                       CSD015
     C                   KFLD                    W4BRCH                                       CSD015
                                                                                              CSD015
     C                   MOVE      *BLANKS       RESULT1                                      CSD015
     C                   MOVE      *BLANKS       RESULT2                                      CSD015
     C                   MOVE      *BLANKS       RESULT3                                      CSD015
     C                   MOVE      *BLANKS       W4CUST                                       CSD015
     C                   MOVE      *BLANKS       W4CNUM                                       CSD015
     C                   MOVE      *BLANKS       W4CTYP                                       CSD015
     C                   MOVE      DPBN          DPBNA                                        CSD015
                                                                                              CSD015
     C     DPMV          IFEQ      'WI'                                                       CSD015
     C                   MOVE      'SEWKIN'      W4ITEM                                       CSD015
     C                   ELSE                                                                 CSD015
     C     DPMV          IFEQ      'WO'                                                       CSD015
     C                   MOVE      'SEWKOT'      W4ITEM                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4IDEN = DPRN                                              CSD015
     C                   EVAL      W4BRCH = DPBA                                              CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
                                                                                              CSD015
     C                   EVAL      W4FUNT = 'DPTMVD'                                          CSD015
      *                                                                                       CSD015
      ** Access customer details file for Counter Party (Midas Report                         CSD015
      ** Name + Customer Report Town)                                                         CSD015
      ** Determine Country party type                                                         CSD015
      *                                                                                       CSD015
     C                   EVAL      PKey = *Blanks                                             CSD015
     C                   MOVE      DPBNA         PKey                                         CSD015
                                                                                              CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*KEY'        POPTN                                        CSD015
     C                   PARM                    PKEY                                         CSD015
     C                   PARM      *BLANKS       PKYSTS                                       CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
     C     PRTCD         IFNE      *BLANKS                                                    CSD015
     C     PRTCD         ANDNE     '*NRF   '                                                  CSD015
     C                   EVAL      DBASE = 47                                                 CSD015
     C                   EVAL      DBKEY = DPBNA                                              CSD015
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4CNUM = DPBNA                                             CSD015
     C     PRTCD         IFEQ      *BLANKS                                                    CSD015
     C     BBCRNM        CAT       BBCRTN:1      W4CUST                                       CSD015
      *                                                                                       CSD015
      ** If Concord Interface Development (CCF001) is installed                               CSD015
      *                                                                                       CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        BBLICD <> *BLANKS                                          CSD015
     C                             AND BBLICD <> W1IND1                                       CSD015
     C                             AND BBLICD <> W1IND2                                       CSD015
     C                             AND BBLICD <> W1IND3                                       CSD015
     C                             AND BBLICD <> W1IND4                                       CSD015
     C                             AND BBLICD <> W1IND5                                       CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   MOVEL     DMTD          PDATE                                        CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM                    PRTCD                                        CSD015
     C                   PARM                    PDATE                                        CSD015
     C                   PARM                    CONVERTEDDATE                                CSD015
     C                   PARM                    PDUMMY10                                     CSD015
     C                   EVAL      W4DDAT = CONVERTEDDATE                                     CSD015
                                                                                              CSD015
     C                   MOVEL     DPVD          PDATE                                        CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM                    PRTCD                                        CSD015
     C                   PARM                    PDATE                                        CSD015
     C                   PARM                    CONVERTEDDATE                                CSD015
     C                   PARM                    PDUMMY10                                     CSD015
     C                   EVAL      W4VDAT = CONVERTEDDATE                                     CSD015
     C                                                                                        CSD015
     C                   MOVEL     *BLANKS       PDATE                                        CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM                    PRTCD                                        CSD015
     C                   PARM                    PDATE                                        CSD015
     C                   PARM                    CONVERTEDDATE                                CSD015
     C                   PARM                    PDUMMY10                                     CSD015
     C                   EVAL      W4MDAT = CONVERTEDDATE                                     CSD015
                                                                                              CSD015
     C                   EVAL      W4DEN1 = DPSS                                              CSD015
     C                   EVAL      W4DEN2 = *BLANKS                                           CSD015
                                                                                              CSD015
     C                   MOVE      DPNA          PInAmt                                       CSD015
     C                   EVAL      PCurr = *BLANKS                                            CSD015
     C                   EXSR      SrCvtAmt                                                   CSD015
     C                   Z-ADD     PAMFlot       W4AMT1                                       CSD015
     C                   Z-ADD     0             W4AMT2                                       CSD015
                                                                                              CSD015
     C     V_CHTP        IFEQ      'A'                                                        CSD015
     C     KEY1          CHAIN     SDCWHTL1                           50                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     DPMV          IFEQ      'WO'                                                       CSD015
     C     V_CHTP        IFEQ      'I'                                                        CSD015
     C     W3UNCF        OREQ      'Y'                                                        CSD015
     C     CHTP          OREQ      'A'                                                        CSD015
     C     NEWDEPOT      ANDNE     V_DPOD                                                     CSD015
     C                   MOVEL     DPOD          DPODA            18                          CSD015
     C                   EVAL      FLD1  = DPODA                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   MOVEL     OUTFMT        RESULT1                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
      *                                                                                       CSD015
     C     CHTP          IFEQ      'I'                                                        CSD015
     C     W3UNCF        OREQ      'Y'                                                        CSD015
     C     CHTP          OREQ      'A'                                                        CSD015
     C     NEWDEPOT      ANDNE     V_DPID                                                     CSD015
     C                   MOVEL     DPID          DPIDA            18                          CSD015
     C                   EVAL      FLD1  = DPIDA                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   MOVEL     OUTFMT        RESULT2                                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     RESULT1       IFNE      *BLANKS                                                    CSD015
     C     CWA(1)        CAT       RESULT1:0     RESULT3                                      CSD015
     C     RESULT3       CAT       CWA(2):0      RESULT3                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     RESULT2       IFNE      *BLANKS                                                    CSD015
     C     RESULT3       CAT       CWA(3):0      RESULT3                                      CSD015
     C     RESULT3       CAT       RESULT2:0     RESULT3                                      CSD015
     C     RESULT3       CAT       CWA(4):0      RESULT3                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Execute SREXTSET which will get the extended settlement details                      CSD015
      ** directly from file in W3UNCF = 'Y', else get it from SE1808                          CSD015
                                                                                              CSD015
     C                   IF        W3UNCF = 'Y'                                               CSD015
     C                             AND V_CHTP = 'A'                                           CSD015
     C                             AND PMCWL = *BLANKS                                        CSD015
     C                   EXSR      SREXTSET                                                   CSD015
     C                   CAT       PMCWL:0       RESULT3                                      CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        PMCWL <> *BLANKS                                           CSD015
     C                   CAT       PMCWL:0       RESULT3                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Send watch list fields to compliance watch                                           CSD015
                                                                                              CSD015
     C     RESULT3       IFNE      *BLANKS                                                    CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    PDS1                                         CSD015
     C                   PARM                    RESULT3                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRCONV  - Subroutine to convert accounts, customer no. to     *                       CSD015
      *           custumer name and address.                          *                       CSD015
      * Called by: Main program                                       *                       CSD015
      *                                                               *                       CSD015
      * Calls: SDCWHLCHK                                              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRCONV        BEGSR                                                                CSD015
                                                                                              CSD015
     C                   MOVE      *BLANKS       OUTFMT          216                          CSD015
     C                   MOVE      *BLANKS       WRTCD            35                          CSD015
      *                                                                                       CSD015
     C     FLD1          IFNE      *BLANKS                                                    CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      FLD1          WRTCD1           35                          CSD015
     C                   PARM                    WRTCD2           35                          CSD015
     C                   PARM                    WRTCD3           35                          CSD015
     C                   PARM                    WRTCD4           35                          CSD015
     C                   PARM                    WRTCD5           35                          CSD015
     C                   PARM                    WRTCD6           35                          CSD015
     C                   PARM                    WCCY              3                          CSD015
     C                   PARM                    OUTFMT          216                          CSD015
     C                   PARM                    OUTCUS            6                          CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
     C/EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SREXTSET - Get the extended settlement details directly       *                       CSD015
      *            from file if Hit Unconfirmed Flag is 'Y'           *                       CSD015
      *                                                               *                       CSD015
      * Called by: SRWATCH                                            *                       CSD015
      * CallS    : SRCONV                                             *                       CSD015
      *            SRCONCAT                                           *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SREXTSET      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   EVAL      PMCWL = *BLANKS                                            CSD015
                                                                                              CSD015
      ** Set pointer to first record with key value equal to DPRN                             CSD015
                                                                                              CSD015
     C     DPRN          SETLL     DPMVEX2                                24                  CSD015
                                                                                              CSD015
      ** Retrieve extended settlements if record is found                                     CSD015
                                                                                              CSD015
     C                   IF        *IN24 = *ON                                                CSD015
     C                   READ      DPMVEX2                                                    CSD015
                                                                                              CSD015
      ** If not end of file and record equal to key is still found                            CSD015
                                                                                              CSD015
     C                   DOW       *IN31 = *OFF                                               CSD015
                                                                                              CSD015
      ** Format and concatinate extended settlement fields and their                          CSD015
      ** corresponding tags to PMCWL if they are not blank                                    CSD015
                                                                                              CSD015
      ** Account for Payment                                                                  CSD015
                                                                                              CSD015
     C                   EVAL      WX = 1                                                     CSD015
     C                   IF        D2AFPN <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2AFPN                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Account wtih Institution                                                             CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2AWIN <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2AWIN                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Beneficiary                                                                          CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2BOFN <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2BOFN                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Instructing Party                                                                    CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2IPYN <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IPYN                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Counterparty                                                                         CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2CTYN <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2CTYN                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Safekeeping Account                                                                  CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2SKAN <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2SKAN                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Deliverer Instructing Party                                                          CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2DCTL <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2DCTL                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Receivers of Securities                                                              CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2RSSN <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2RSSN                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Deliverers of Securities                                                             CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2DSSN <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2DSSN                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Beneficiary of Securities                                                            CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2BSSN <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2BSSN                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Investor                                                                             CSD015
                                                                                              CSD015
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        D2INVE <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2INVE                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   EXSR      SRCONCAT                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Settlement Party Intermediary 1 - 9                                                 CSD015
                                                                                              CSD015
     C                   EVAL      PMCWL1 = *BLANKS                                           CSD015
     C                   IF        D2IMD1 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMD1                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMD2 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMD2                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSW210 = 'Y'                                               CSW210
                                                                                              CSW210
     C                   IF        D2IMD3 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMD3                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMD4 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMD4                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMD5 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMD5                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMD6 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMD6                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMD7 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMD7                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMD8 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMD8                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMD9 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMD9                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        PMCWL1 <> *BLANKS                                          CSD015
     C                   CAT       OPNTAG(WX):0  PMCWL                                        CSD015
     C                   CAT       PMCWL1        PMCWL                                        CSD015
     C                   CAT       CLSTAG(WX):0  PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Safekeeping Account Intermediary 1 - 9                                              CSD015
                                                                                              CSD015
     C                   EVAL      PMCWL1 = *BLANKS                                           CSD015
     C                   IF        D2IMS1 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMS1                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMS2 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMS2                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSW210 = 'Y'                                               CSW210
                                                                                              CSW210
     C                   IF        D2IMS3 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMS3                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMS4 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMS4                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMS5 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMS5                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMS6 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMS6                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMS7 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMS7                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMS8 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMS8                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        D2IMS9 <> *BLANKS                                          CSD015
     C                   EVAL      FLD1 = D2IMS9                                              CSD015
     C                   EXSR      SRCONV                                                     CSD015
     C                   CAT       OUTFMT:0      PMCWL1                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      WX = WX + 1                                                CSD015
     C                   IF        PMCWL1 <> *BLANKS                                          CSD015
     C                   CAT       OPNTAG(WX):0  PMCWL                                        CSD015
     C                   CAT       PMCWL1:0      PMCWL                                        CSD015
     C                   CAT       CLSTAG(WX):0  PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSW210
      ** Debtor                                                                               CSW210
                                                                                              CSW210
     C                   EVAL      WX = WX + 1                                                CSW210
     C                   IF        D2DIDN <> *BLANKS                                          CSW210
     C                   EVAL      FLD1 = D2DIDN                                              CSW210
     C                   EXSR      SRCONV                                                     CSW210
     C                   EXSR      SRCONCAT                                                   CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Qualified Foreign Intermediary                                                       CSW210
      *                                                                                       CSW210
     C                   EVAL      WX = WX + 1                                                CSW210
     C                   IF        D2QFIN <> *BLANKS                                          CSW210
     C                   EVAL      FLD1 = D2QFIN                                              CSW210
     C                   EXSR      SRCONV                                                     CSW210
     C                   EXSR      SRCONCAT                                                   CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSD015
      ** Read next record with key value still equal to DPRN                                  CSD015
                                                                                              CSD015
     C     DPRN          READE     DPMVEX2                                31                  CSD015
                                                                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
     C/EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRCONCAT  - Concatinate the tags with the converted extended  *                       CSD015
      *             settlement details to create the XML format       *                       CSD015
      *                                                               *                       CSD015
      * Called by:  SREXST                                            *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRCONCAT      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CAT       OPNTAG(WX):0  PMCWL                                        CSD015
     C                   CAT       OUTFMT:0      PMCWL                                        CSD015
     C                   CAT       CLSTAG(WX):0  PMCWL                                        CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrCvtAmt - Convert amounts for Watch Engine Program          *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtAmt      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM                    PCurr                                        CSD015
     C                   PARM                    PInAmt                                       CSD015
     C                   PARM                    PAMFLOT                                      CSD015
     C                   PARM      *ZEROS        POutAmt                                      CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KDptRef                                      CRE020
     C                   KFLD                    KPrgMn                                       CRE020
                                                                                              CRE020
      ** In Amend Mode, if changes doesnt affect the projections for charges,                 CRE020
      ** do not generate advice                                                               CRE020
                                                                                              CRE020
     C                   IF        V_CHTP = 'A'                                               CRE020
     C                   IF        PrevDCHC <> DCHC or                                        CRE020
     C                             PrevDCCE <> DCCE or                                        CRE020
     C                             PrevDCHA <> DCHA or                                        CRE020
     C                             PrevDCSE <> DCSE or                                        CRE020
     C                             PrevDCAT <> DCAT or                                        CRE020
     C                             PrevDCAB <> DCAB                                           CRE020
     C                   ELSE                                                                 CRE020
     C                   LEAVESR                                                              CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Process all transactions.                                                            CRE020
                                                                                              CRE020
     C                   MOVEL     DPRN          KDptRef                                      CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
     C     KADVC         CHAIN     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   IF        NOT %FOUND                                                 CRE020
     C                   EVAL      RREFNO = DPRN                                              CRE020
     C                   EVAL      RPRGMN = 'SEDPMVUPD'                                       CRE020
     C                   EVAL      RSEQNO = *BLANKS                                           CRE020
     C                   EVAL      RTRTYP = DPMV                                              CRE020
     C                   EVAL      RCHTYP = CHTP                                              CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   EVAL      RENARR = *Blanks                                           CRE020
     C                   WRITE     READVCD0                                                   CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RCHTYP = 'I' and                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        V_CHTP = 'D'                                               CRE020
     C                   EVAL      RCHTYP = 'D'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   LEAVESR                                                              CRE020
     C                   ENDIF                                                                CRE020
     C                   IF        V_CHTP = 'A'                                               CRE020
     C                   EVAL      RCHTYP = 'I'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   EVAL      RCHTYP = CHTP                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
     C                   EVAL      RCHTYP = CHTP                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   UNLOCK    READVCL1                                                   CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      *                                                               *
      *                  F I E L D S   L O G                          *
      *                  -------------------                          *
      *                                                               *
      *  Field                         Set in     Set in              *
      *  Name    Description         Validation    This    Amendable  *
      *                                Module    Function             *
      *****************************************************************
      *  RECI    Record Id                         Yes       Yes      *
      *  DPSS    Security Shortname     Yes                           *
      *  DPRN    Reference              Yes                           *
      *  DPMV    Movement Type                     Yes                *
      *  DPID    In Depot               Yes        Yes       Yes      *
      *  DPMD    Movement Date In       Yes        Yes       Yes      *
      *  DPOD    Out Depot              Yes        Yes       Yes      *
      *  DPDO    Movement Date Out      Yes        Yes       Yes      *
      *  DPBA    Branch Code            Yes                  Yes      *
      *  ORBR    Originating Branch     Yes                  Yes      *
      *  DPBK    Book Code              Yes                  Yes      *
      *  DPMK    Market                            Yes                *
      *  DPBN    Beneficial Customer               Yes                *
      *  DPNA    Nominal Amount         Yes                  Yes      *
      *  DPNR    Narrative              Yes                  Yes      *
      *  MKTP    Market Price           Yes                           *
      *  DPAD    Assosciated deal No.              Yes                *
      *  SWRF    Switch Reference                  Yes                *
      *  SIOI    Switch In/On Ind.                 Yes                *
      *  DPMS    Message Indicator                 Yes                *
      *  DCFR    Confirmation Required             Yes                *
      *  TACI    Accounting Indicator              Yes                *
      *  DPR1    Depot Required 1                  Yes                *
      *  DPR2    Depot Required 2                  Yes                *
      *  ORED    Original Entry Date               Yes                *
      *  LCD     Last Change Date                  Yes                *
      *  CHTP    Type of Last Change               Yes                *
      *  TNLU    Trans no of Last Update           Yes                *
      *  RPIN    Repo/Pledge Indicator             Yes                *
      *  DPPC    Profit Centre          Yes                  Yes      *
      *  DCHC    Charge Code            Yes                  Yes      *
      *  DCCE    Charge Currency        Yes                  Yes      *
      *  DCHA    Charge Amount          Yes                  Yes      *
      *  DCSE    Charge Settlement Type Yes                  Yes      *
      *  DCAB    Charge Acc. Branch     Yes                  Yes      *
      *  DCAT    Charge Account         Yes                  Yes      *
      *  DPVD    Value Date                        Yes       Yes      *
      *  SPXR    Exchange Rate          Yes                  Yes      *
      *  SPMD    Spot Rate Mul/Div Ind. Yes                  Yes      *
      *  PTFR    Portfolio Reference    Yes                  Yes      *
      *  CYLD    Customer Yield Rate    Yes                  Yes      *
      *  CWDI    Cust Withdl/Delv. Ind. Yes                  Yes      *
      *  PINT    Purchased Interest     Yes                  Yes      *         CPB001
      *  CPTY    Counterparty           Yes                  Yes      *                       207006
      *  MRKT    Market Centre          Yes                  Yes      *                       207006
      *                                                               *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** CWA - Array for watch list fields                                                          CSD015
<Depot in>                                                                                    CSD015
</Depot in>                                                                                   CSD015
<Depot out>                                                                                   CSD015
</Depot out>                                                                                  CSD015
**  OPNTAG - Array containing the open tags for extended settlements                          CSD015
<Account for Payment>                                                                         CSD015
<A/C with Institution>                                                                        CSD015
<Beneficiary>                                                                                 CSD015
<Instructing Party>                                                                           CSD015
<Counterparty>                                                                                CSD015
<Safekeeping Account>                                                                         CSD015
<Deliverr Instrctg Prty>                                                                      CSD015
<Receivers of Securties>                                                                      CSD015
<Deliverrs of Securties>                                                                      CSD015
<Benfciary of Securties>                                                                      CSD015
<Investor>                                                                                    CSD015
<Sttlmnt Prty Intmdiary>                                                                      CSD015
<Safkeepg A/C Intmdiary>                                                                      CSD015
<Debtor>                                                                                      CSW210
<Qualified Foreign Intermediary>                                                              CSW210
**  CLSTAG - Array containing the close tag for extended settlements                          CSD015
</Account for Payment>                                                                        CSD015
</A/C with Institution>                                                                       CSD015
</Beneficiary>                                                                                CSD015
</Instructing Party>                                                                          CSD015
</Counterparty>                                                                               CSD015
</Safekeeping Account>                                                                        CSD015
</Deliverr Instrctg Prty>                                                                     CSD015
</Receivers of Securties>                                                                     CSD015
</Deliverrs of Securties>                                                                     CSD015
</Benfciary of Securties>                                                                     CSD015
</Investor>                                                                                   CSD015
</Sttlmnt Prty Intmdiary>                                                                     CSD015
</Safkeepg A/C Intmdiary>                                                                     CSD015
</Debtor>                                                                                     CSW210
</Qualified Foreign Intermediary>                                                             CSW210
**  CTDATA CMDDLY                                                                             223870
DLYJOB     DLY(10)                                                                            223870
