     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV interface controller')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEDPMVCTL - SE Depot Movement Transaction Interface          *
      *              Contoller.                                       *
      *                                                               *
      *  Function: This Program Validates SE DPMV WI/WO Transaction   *
      *            of inputs into the Midas database.                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245675             Date 22Feb07               *
      *                 243950             Date 28Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 03Aug05               *
      *                 CSE075             Date 17Nov05               *
      *                 234691             Date 05Jul05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG9632            Date 25Apr05               *
      *                 CER001             Date 25Apr05               *
      *                 CSC022             Date 24Feb04               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 23Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE039             Date 14Mar03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 174742             Date 17Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 167486             Date 25Apr00               *
      *                 175327             Date 28Feb00               *
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 167354             Date 09Sep99               *
      *                 167221             Date 08Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003  *CREATE    Date 29May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  245675 - To complete fix 244007.                             *
      *           Add repo indicator from repurchased agreement input.*
      *  243950 - To make information consistent between parser       *
      *           module and depot movements controller module.       *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           New parameter DDDPSS added to call to               *
      *           SEDPMVRTV. Also due to new fields added to          *
      *           SEDMWIPD and SEEDMWIPD.                             *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  234691 - Fixes EU Taxes - block deletions of depot movements *
      *  CGL031 - Taxation of Sacings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG9632- SEDPMVCTL parameters inconsistent with APCCALLCTL   *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE039 - Auto-settle of trades.                              *
      *  207006 - Add Counterparty & Market Centre to SSI             *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  174742 - Walk in transactions showing on Walk out screen with*
      *         - Walk out transactions showing on Walk in screen     *
      *  CSE023 - Treaty Withholding Tax (Recompiled over SECTYD)     *
      *  167486 - Recompiled over changes in SEVDPMVPD.               *
      *  175327 - Generate a Reference Number doesn't run. Reference  *
      *           Number always blank  (Alpha & numeric fields)       *
      *           (Parameters wrong when calling module ZATRNRTV and  *
      *           parameters return never used)                       *
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Mismatch between parameter lists on call SEDPMVVAL  *
      *  CSE015 - Forward Valued Depot Movements (Recompiled)         *
      *  CSE017 - Cum/Ex Indicator on Depot Narratives (Recompiled)   *
      *  CSE012 - SE Depot Movement Narratives                        *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  167354 - Depot movement interface crashes & update function  *
      *           rejects movements on SEVDPMVPD.                     *
      *           (Module re-compiled over new layout of SEVDPMVPD)   *
      *  167221 - Duplicate depot movements as wrong reference assignd*
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FSEIDPMVPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

     FSEVDPMVPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
     F                                     PREFIX(V_)

     F***APIDSETPD*UF*A*E*************DISK****INFSR(*pssr)                      167354
     F****************************************COMMIT                            167354

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

     FSEVDPMVL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEVDPMVD0:SEVDPMVCHK)
     FSEVDPMVL1 IF   E           K DISK    INFSR(*PSSR)                         CAP013
     F                                     RENAME(SEVDPMVD0:SEVDPMVCK1)         CAP013

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEDPMVC018
     FSEVDMLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FSEIDMLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001


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

     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
                                                                                              CSC022
      ** Standing Data Data structures
      ** -----------------------------

      ** External DS for Bank Details
      ** DS for Access Programs
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCA_LCD      E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
     ** Transaction Details Data Structures
     ** -----------------------------------
      *
      ** Incoming Header
      ** Incoming Transaction
      ** Rename In Depot/Date to be used for both Walk In/Walk Out Trans.
      *
     D HeadIn        E DS                  EXTNAME(APHEADPD)
     D TransIn       E DS                  EXTNAME(SEDMWIPD)
     D DDDEPOT       E                     EXTFLD(DDDPID)
     D DDDATE        E                     EXTFLD(DDDPMD)
                                                                                              243950
      ** Incoming transaction in screen format.                                               243950
     D TranInDPMV    E DS                  EXTNAME(SEDMIDPD)                                  243950
     D                                     PREFIX(IN_)                                        243950
     D TranInDMES    E DS                  EXTNAME(SEDMESPD)                                  243950
     D                                     PREFIX(IN_)                                        243950
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(SEDMEXPD)                    CAP004
      * SE Trades Extra Data - File (D/B) format                                CAP004
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(SEDMRXPD)                                  CER001
      *                                                                                       CER001
      ** SE Trades Extra Data                                                                 CER001

      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SEC)
     D/COPY WNCPYSRC,SEDPMVCD01

      *
      ** Incoming transaction file format
      ** Transaction screen format used for existing records
      ** Flags DS used to indicate whether transaction fields are valid
      ** Incoming transaction Valid File Format
      *
     D DPMVFilFmt    E DS                  EXTNAME(DPTMVD)
     D DPMVScnFmt    E DS                  EXTNAME(SEDMWIPD)
     D                                     PREFIX(Old)
     D OldDDDEPOT    E                     EXTFLD(DDDPID)
     D OldDDDATE     E                     EXTFLD(DDDPMD)

     D OKFlagsDS     E DS                  EXTNAME(SEEDMWIPD)
     D DDDEPOTOk     E                     EXTFLD(DDDPIDOk)
     D DDDATEOk      E                     EXTFLD(DDDPMDOk)

     D ValidTrans    E DS                  EXTNAME(SEVDPMVPD)
     D                                     PREFIX(V_)

     D MsgTypeDS       DS             8
     D DPMVtype                5      6
      *                                                                         CSE012
     D NewDPMVRec    E DS                  EXTNAME(DPTMVD)                      CSE012
     D                                     PREFIX(New)                          CSE012

     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
                                                                                              CSC022
      ** Working fields
      ** --------------
                                                                                CAP004
      ** Field (500A) to receive the incoming Extra Data                        CAP004
     D ExtData500      S            500A                                        CAP004
      *                                                                                       CER001
      ** Field (500A) to receive the incoming Extra Data                                      CER001
     D RegData500      S            500A                                                      CER001
      *                                                                                      BUG9632
      ** Other depot details for Securities Customer                                         BUG9632
      *                                                                                      BUG9632
     D OthDData        S           4755A                                                     BUG9632

      ** Timestamp for the transaction                                          167354
     D TimeStamp       S               Z                                        167354
                                                                                167354
      ** Array Index Error
      ** Array Index Warning Error
     D Idx             S              3P 0
     D WIdx            S              3P 0

     D Object          S             10A   INZ('SEDPMVUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
     D CGL031          S              1A                                                      CGL031

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PCustNum        S             18A                                                      CSC011
     D PACustNo        S             18A                                                      CSC011
                                                                                              CSC011
      ** Module Id
     D ModuleID        S              2A

      ** Ref. no
      ** Removed because not used                                                            CSD027A
     D*WDPRN****       S              6S 0                                                   CSD027A

      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')

     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                              CSC022
      ** Introduced by CER001                                                                 CER001
     D ULX602          S              1A                                                      CER001
     D ULX008          S              1A                                                      CER001
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEDPMVC019
      ** External data structures for Midas Modules                                           CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
                                                                                              CER001
      ** Valid Extended Deal in File Format                                                   CER001
     D ValidFilExt   E DS                  EXTNAME(SEVDMLX1PD)                                CER001
                                                                                              CER001
      ** Errors Indicators Extended Fields                                                    CER001
     D OkFlagsExt    E DS                  EXTNAME(SEEDMLX1PD)                                CER001
      *                                                                                       CER001
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD1                 1      6  0                                                    CER001
     D  #1DPSS                 1     10                                                       CER001
     D  #1DPRN                11     16                                                       CER001
     D  #1DPMV                17     18                                                       CER001
     D  #1FOTR                19     38                                                       CER001
     D  #1TMST                39     64Z                                                      CER001

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,SEDPMVC001
      *
      **  Move Message to the file Data Structure
      *
     C**********         MOVEL     Trans500      TransIn                                      243950
     C                   MOVEL     Trans500      TranInDPMV                                   243950
     C                   MOVEL     OthDData      TranInDMES                                   243950
     C                   EVAL      TransIn = TranInDPMV + TranInDMES                          243950
     C                   MOVEL     Extdata500    Extdata                        CAP004
     C                   MOVEL     RegData500    RegData                                      CER001
      *
      ** Setup Movement Type
      *
     C*******************MOVE      APTGTTYPE     MsgTypeDS                      167354
     C                   MOVEL     APTGTTYPE     MsgTypeDS                      167354
      *
      ** Start of Processing
      ** -------------------
      *
      ** Generate a Time stamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
      /COPY WNCPYSRC,SEDPMVC002
      ** Reset Working fields
      *
     C                   EXSR      SRRsetFlds
      /COPY WNCPYSRC,SEDPMVC003
      *
      ** Validate Transaction Identifiers
      *
     C                   EXSR      SRChkTrnId
                                                                                CAP013
      *  Check if valid transaction exists for Midas Reference                  CAP013
                                                                                CAP013
     C     Idx           IFEQ      0                                            CAP013
     C                   EXSR      ChkValMiRf                                   CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
      /COPY WNCPYSRC,SEDPMVC004
      *
      ** If error occured, reject transaction.
      ** Else
      ** Reset Working fields
      ** Validate Primary Details (Key Fields)
      *
      /COPY WNCPYSRC,SEDPMVC005
     C     Idx           IFEQ      0
     C                   EXSR      SRRsetFlds
     C                   EXSR      SRChkPDtls
     C                   ENDIF
      /COPY WNCPYSRC,SEDPMVC006
      *
      ** If error occured in Primary Validation, reject transaction,
      ** Else
      ** Validate Main Details
      *

     C                   IF        Idx =  0

     C                   IF        DDACTN = 'I'
     C                             OR DDACTN = 'A'
     C                             OR DDACTN = 'D' AND CGL031 = 'Y'                           234691
      /COPY WNCPYSRC,SEDPMVC007
     C                   EXSR      SRMainVal
      *                                                                                       CSE012
      ** If CSE012 is installed, Validate Second Screen                                       CSE012
      *                                                                                       CSE012
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C     DDACTN        ANDNE     'D'                                                        234691
     C                   EXSR      SRSecVal                                                   CSE012
     C                   ENDIF                                                                CSE012
      *                                                                                       CSE012
      /COPY WNCPYSRC,SEDPMVC008
     C                   ENDIF

     C                   ENDIF
      *
      ** Error Handler Routine
      ** Check For Exception error from any program lower in the stack.
      *
      /COPY WNCPYSRC,SEDPMVC009
     C                   EXSR      SRErrorVal
      /COPY WNCPYSRC,SEDPMVC010

     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEDPMVC020

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRsetFlds - Reset Error Information that is gradually        *
      *              updated during each program cycle.               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRRsetFlds    BEGSR
      *
      ** Field Error messages
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
      *
      ** Field Warning messages
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
      *
      ** Field Arrarys
      *
     C                   RESET                   FldNoArr
      *
      ** Ok flag indicator
      *
     C                   RESET                   OKFlagsDS

     C                   CLEAR                   ValidTrans
      *
      ** Numeric fields within 'ValidTrans' have to be reset explicitly as
      ** there are long alpha fileds overlapping these which cause the
      ** CLEAR to put blanks in the numeric fields
      *
     C**********         Z-ADD     *ZERO         V_DPID                                       CSD027
     C                   EVAL      V_DPID = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         V_DPMD
     C**********         Z-ADD     *ZERO         V_DPOD                                       CSD027
     C                   EVAL      V_DPOD = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         V_DPDO
     C**********         Z-ADD     *ZERO         V_DPBN                                       CSD027
     C                   EVAL      V_DPBN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         V_DPNA
     C                   Z-ADD     *ZERO         V_MKTP
     C                   Z-ADD     *ZERO         V_DPAD
     C                   Z-ADD     *ZERO         V_ORED
     C                   Z-ADD     *ZERO         V_LCD
     C                   Z-ADD     *ZERO         V_TNLU
     C                   Z-ADD     *ZERO         V_DCHA
     C                   Z-ADD     *ZERO         V_DCSE
     C                   Z-ADD     *ZERO         V_DPVD
     C                   Z-ADD     *ZERO         V_SPXR
     C                   Z-ADD     *ZERO         V_CYLD
     C                   Z-ADD     *ZERO         V_PINT                         CPB001
     C**********         Z-ADD     *ZERO         V_CPTY                                207006 CSD027
     C                   EVAL      V_CPTY = *BLANKS                                           CSD027
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     *ZERO         V_FSPR                                       CGL031
     C                   Z-ADD     *ZERO         V_OPDT                                       CGL031
     C                   Z-ADD     *ZERO         V_OPIN                                       CGL031
     C                   ENDIF                                                                CGL031

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkTrnId - Validation routine for the Transaction Id of the *
      *              concern SE Deal.                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChkTrnId    BEGSR
      *
      ** Check for deal on Valid file
      *
     C     APFOTranId    CHAIN     SEVDPMVL0                          99
      *
      ** If record found...
      *
     C     *IN99         IFEQ      '0'
      *
      ** ..delay, then repeat check
      *
     C                   CALLB     'ZACDELAY'

     C     APFOTranID    CHAIN     SEVDPMVL0                          99
      *
      ** Error if still present
      *
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C*******************EVAL******FldNameArr(Idx) = 'DDDPNR'                   CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDDPRN'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP013
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiRf - Routine to check if valid transaction exists for *         CAP013
      *    Midas Reference                                            *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiRf    BEGSR                                                  CAP013
                                                                                CAP013
      * If (numeric) Midas reference number supplied                            CAP013
                                                                                CAP013
     C                   TESTN                   DDDPRN               9898      CAP013
                                                                                CAP013
     C     DDDPRN        IFNE      *BLANKS                                      CAP013
     C     *IN98         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      * Check for transaction on Valid file                                     CAP013
     C                   MOVEL     DDDPRN        DPRN                           CAP013
     C     DPRN          CHAIN     SEVDPMVL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     DPRN          CHAIN     SEVDPMVL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDDPRN'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   ENDSR                                                  CAP013
      *****************************************************************         CAP013
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkPDtls - Performs the Validation for the key fields of    *
      *              the concerned SE deal.  This is done by calling  *
      *              the retrieve module which validates the key      *
      *              fields of the record.                            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChkPDtls    BEGSR
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDDPRN        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *
      ** Validate action code versus transaction IDs supplied
      ** This function will set the Midas deal number
      ** The deal in file format from the SE database is retrieved as well.
      *
     C                   RESET                   ReturnCode

     C                   CALLB     'SEDPMVRTV'

     ** Screen Fields
      * Action Code (1A)
      * Depot Movement Reference Number (6A)
      * Security Shortname (10A)
      * Booking Branch  (3A)
      * Originating Branch  (3A)

     C                   PARM                    DDACTN
     C                   PARM                    DDDPRN
     C                   PARM                    DDDPBA
     C                   PARM                    DDORBR

     ** Operation Details
      * Mode of Operation (6A)
      * Response Mode (1A)
      * Front Office ID No. (20A)
      * Depot Movement Type. (2A)                                                             174742
      * Calling program      (10A)                                                            CSE039

     C*******************PARM      '*FRONT'      ModeOfOP          6            CAP013
     C                   PARM                    ModeofOp          6            CAP013
     C                   PARM                    APRespMode
     C                   PARM                    APFOTranId
     C                   PARM                    DPMVType                                     174742
     C                   PARM      'SEDPMVCTL'   CallProg         10                          CSE039
     C                   PARM                    DDDPSS                                       CAP087
      *
      ** Returned Parameters
      ** -------------------
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Error Index (3P 0)
      *
     C                   PARM                    Idx

      *
      ** Depot movement transaction file Output
      *
     C                   PARM                    DPMVFilFmt

     ** Ok Indicators
      * Action Code Ok Indicator (1A)
      * Transaction ID number Ok Indicator (1A)
      * Booking Branch Ok indicator (1A)
      * Originating Branch Ok indicator (1A)

     C                   PARM                    DDACTNOk
     C                   PARM                    DDDPRNOk
     C                   PARM                    DDDPBAOk
     C                   PARM                    DDORBROk

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMainVal - Validation Routine                                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************

     C     SRMainVal     BEGSR
      *
      ** If Action is Amend, put the complete (pre-existing)
      ** deal (retreived by SEDPMVRTV) into the Valid file record.
      ** - fields in this will be updated during processing.
      *

     C                   IF        DDACTN = 'A'
     C                   MOVE      DPMVFilFmt    ValidTrans
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      TransIn                                99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
     C                   END
      *
      ** Validate deal details
      *
     C                   CALLB     'SEDPMVVAL'

     C                   PARM                    TransIn
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    SECTY
     C                   PARM                    DPMVType
     C                   PARM                    DDDRID            1                         245675
     C                   PARM                    APRespMode
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM      'Y'           PortCusInd        1
     C                   PARM      'Y'           PBInd             1            CPB001
     C                   PARM                    PBFieldInd        1            176883
     C                   PARM                    ValidTrans
     C                   PARM                    OKFlagsDS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WIdx
     C                   PARM                    CGL031                                       CGL031

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'SEDPMVCVT'                                  CAP011
                                                                                CAP011
      * INPUTS                                                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * (Current) Depot movement in file format                                 CAP011
     C                   PARM                    DPMVFilfmt                     CAP011
                                                                                CAP011
      * OUTPUTS                                                                 CAP011
      * (Current) Depot movement in screen format                               CAP011
     C                   PARM                    DPMVScnfmt                     CAP011
      ** Fx Rate                                                                CAP011
      ** Mul/Div Indicator                                                      CAP011
     C                   PARM                    DDSPXR           14            CAP011
     C                   PARM                    DDSPMD            1            CAP011
      *                                                                         CAP011
      ** Security Status                                                        CAP011
      ** Transaction status                                                     CAP011
     C                   PARM                    DDSecSts          7            CAP011
     C                   PARM                    DDTranSts         7            CAP011
     C                   PARM                    PBCusInd          1            222373
     C                   PARM                    PBFieldInd                     222373
     C                   PARM                    CGL031                                       CGL031
                                                                                CAP011
      ** DATA SUBSTITUTION                                                      CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TransIn       IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      DPMVScnfmt    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TransIn                        CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErrorVal - Check for any exception error from any program   *
      *              lower in the stack.                              *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRChkWrt                                               *
      *                                                               *
      *****************************************************************
     C     SRErrorVal    BEGSR
      *
      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program
      *
     C                   IN        APDUMP

      /COPY WNCPYSRC,SEDPMVC011

     C     ARERRMOD      IFNE      *BLANK
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
     C                   RETURN

     C                   ELSE
      *
      ** Processing for Error checking/write to database
      *
      /COPY WNCPYSRC,SEDPMVC012
      *                                                                                       CER001
     C                   IF        ULX602 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExt                                   CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C                   MOVE      DPMVtype      #1DPMV                                       CER001
      *                                                                                       CER001
      ** Validate Transaction Time and CAB Reporting if Depot Movement                        CER001
      ** is 'WI' or 'WO'                                                                      CER001
      *                                                                                       CER001
     C                   IF        ULX008 = 'Y'                                               CER001
     C                   IF        #1DPMV <> 'WI'  AND                                        CER001
     C                             #1DPMV <> 'WO'                                             CER001
     C                   EVAL      ULX008 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'SEDPMV3VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsExt                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExt                                  CER001
     C                   PARM                    ULX008                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C                   IF        Idx = 0                                                    CER001
      *                                                                                       CER001
     C                   IF        DDACTN = 'I'                                               CER001
     C                   EXSR      SRSetupRef                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   EVAL      #6LXWNDPSS = V_DPSS                                        CER001
     C                   EVAL      #6LXWNDPRN = V_DPRN                                        CER001
     C                   EVAL      #6LXWNFOTR = APFOTranID                                    CER001
     C                   EVAL      #6LXWNTMES = TimeStamp                                     CER001
     C                   WRITE     SEVDMLXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C                   IF        Idx > 0  AND                                               CER001
     C                             APRprLocn =  'B'                                           CER001
      *                                                                                       CER001
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   EVAL      #6LXFOTR = APFOTranID                                      CER001
     C                   EVAL      #6LXTIME = TimeStamp                                       CER001
     C                   EVAL      #6LXOPTP = L6LXOPTP                                        CER001
     C                   EVAL      #6LXEXCF = L6LXEXCF                                        CER001
     C                   EVAL      #6LXTTIM = L6LXTTIM                                        CER001
     C                   EVAL      #6LXCABR = L6LXCABR                                        CER001
     C                   EVAL      #6LXCNBR = L6LXCNBR                                        CER001
     C                   WRITE     SEIDMLXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EXSR      SRChkWrt
      /COPY WNCPYSRC,SEDPMVC013
      *
      ** If valid, send data queue entry to prompt DB update program
      *
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *
      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return

     C     Return        IFEQ      *BLANK

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkWrt - Routine to control checking of error status and    *
      *            sending of messages/writing to the database        *
      *                                                               *
      * Called by: SRErrorVal                                         *
      *                                                               *
      * Calls: SRSetupVal                                             *
      *        SRSetupInV                                             *
      *        SRSetupRef                                             *
      *        SRMsgHdl                                               *
      *                                                               *
      *****************************************************************

     C     SRChkWrt      BEGSR

      *  If no errors were found:
      *  - If Action Code is Insert and Deal Number is not supplied
      *     - set up the deal number
      *  - If there are still no errors
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report deal status
      *  If any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report deal status
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
      *
      ** No error
      *
     C     DDACTN        CASEQ     'I'           SRSetupRef
     C                   ENDCS

     C     Idx           IFEQ      0
      /COPY WNCPYSRC,SEDPMVC014
     C                   EXSR      SRSetupVal
      /COPY WNCPYSRC,SEDPMVC015
     C                   WRITE     SEVDPMVD0
     C                   EXSR      SRMsgHdl
     C                   ENDIF

     C                   ENDIF
      *
      ** Error Occured
      *
     C                   IF        Idx > 0

      /COPY WNCPYSRC,SEDPMVC016
     C                   EXSR      SRSetupInV
      /COPY WNCPYSRC,SEDPMVC017
      *                                                                         CAP004
      * Only write to invalid files if repair in back office                    CAP004
      *                                                                         CAP004
     C     APRprLocn     IFEQ      'B'                                          CAP004
     C                   WRITE     SEIDPMVD0
     C*******************WRITE*****APIDSETD0                                    167354
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TransIn                                         CSC011
     C                                        + RegData                                       CER001
     C                                        + ExtData                                       CSC011
     C                   EVAL      PCustNum = DDDPRN                                          CSC011
                                                                                              CSC011
      ** Write log file                                                                       CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PCustNum                                     CSC011
     C                   PARM      *BLANKS       PACustNo                                     CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY  = PCustNum                                          CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE  = 4                                                 CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                  CAP004
     C                   EXSR      SRMsgHdl

     C                   ENDIF

     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetUpRef - Set up a Ref. Number for Inserts.                *
      *                                                               *
      * Called by: SRChkWrt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSetupRef    BEGSR

     C                   IF           DDDPRN = *blanks
     C                             OR DDDPRN = *zeros
      *
      ** Generate A Reference Number
      *
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'SE'          MODU              2
     C*******************PARM      'T'           TRTY              1            167221
     C                   PARM      'D'           TRTY              1            167221
     C**********         PARM                    DPRN                           175327
     C**********         PARM      *ZERO         WDPRN                          175327
     C                   PARM                    DDDPRN                         175327
     C                   PARM      *ZERO         V_DPRN                         175327
      *
      ** DATABASE ERROR
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     'ZATRNRTV'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     DDDPRN        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END

     C                   ELSE
      *
      ** If Ref. Number was entered, put it in the file field
      *
     C                   MOVE      DDDPRN        V_DPRN

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetupVal - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *                                                               *
      * Called by: SRChkWrt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSetupVAL    BEGSR
      *
      ** For Delete put the complete (pre-existing) deal
      ** into the Valid file record
      *
     C                   IF        DDACTN = 'D'
     C/COPY WNCPYSRC,SEDPMVCC01
     C                   MOVE      DPMVFilFmt    ValidTrans
     C                   ENDIF
      *
      ** Set Valid file field(s) that are needed for all Action Codes
      *
      ** Last Change type
      ** Movement Type
      *
     C                   EVAL      V_CHTP = DDACTN
     C                   EVAL      DPMV = DPMVtype
      *                                                                                       CSE039
     C                   IF        CSE039 = 'Y'                                               CSE039
      ** Notification Method                                                                  CSE039
     C                   Eval      V_NOTM = DSNOTM                                            CSE039
      ** Message Key                                                                          CSE039
     C                   Eval      V_MSGK = DSMSGK                                            CSE039
     C                   ENDIF                                                                CSE039
      *
      ** Include Header fields that need to be o/p to the Valid file
      *
     C******LIKE*********DEFINE    DDTMESTMP     TimeStamp                      167354

     C                   EVAL      V_DMFRNT = APFOTranID
     C                   EVAL      V_DMREPA = APRprLocn
     C                   EVAL      V_DMTMST = TimeStamp
     C                   EVAL      TranStatus = 'S'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetupInV - Set up additional fields that are needed on the  *
      *              Invalid file record.                             *
      *                                                               *
      * Called by: SRChkWrt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRSetupInV    BEGSR
      *
      ** Include Header fields that need to be o/p to the Invalid files
      *
     C                   EVAL      FOFFID = APFOTranID
     C                   EVAL      RPRLOC = APRprLocn
     C                   EVAL      DDTSTMP = TimeStamp
     C                   EVAL      DDDPMV = DPMVType

     C                   EVAL      TranStatus = 'F'

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE012
      *****************************************************************                       CSE012
      *                                                               *                       CSE012
      * SRSecVal - Validate Second Screen Entry                       *                       CSE012
      *                                                               *                       CSE012
      * Called by: Main Processing                                    *                       CSE012
      *                                                               *                       CSE012
      * Calls: None                                                   *                       CSE012
      *                                                               *                       CSE012
      *****************************************************************                       CSE012
      *                                                                                       CSE012
     C     SRSecVal      BEGSR                                                                CSE012
      *                                                                                       CSE012
     C                   CALLB     'SEDPMV2VL'                                                CSE012
     C                   PARM                    RetrnCod          6                          CSE012
     C                   PARM                    DDDPNR2          35                          CSE012
     C                   PARM                    DDDPNR3          35                          CSE012
     C                   PARM                    DDDPNR4          35                          CSE012
     C                   PARM                    DDDPNR5          35                          CSE012
     C                   PARM                    NewDPMVRec                                   CSE012
     C                   PARM                    FldNameArr                                   CSE012
     C                   PARM                    MsgIDArr                                     CSE012
     C                   PARM                    MsgDtaArr                                    CSE012
     C                   PARM                    WFldNamArr                                   CSE012
     C                   PARM                    WMsgIDArr                                    CSE012
     C                   PARM                    WMsgDtaArr                                   CSE012
     C                   PARM                    Idx                                          CSE012
     C                   PARM                    WIdx                                         CSE012
      *                                                                                       CSE012
     C                   ENDSR                                                                CSE012
      *****************************************************************                       CSE012
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMsgHdl - Call the Message Handling module                   *
      *                                                               *
      * Called by: SRChkWrt                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRMsgHdl      BEGSR
      *
      ** Set up an array of sequence numbers that correspond to the fields
      ** with errors
      *
     C                   Z-ADD     1             Ix                3 0
     C                   DO        ArrayMax

     C     FldNameArr(Ix)IFNE      *BLANKS

     C                   Z-ADD     1             Iy                3 0
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)

     C                   ELSE

     C                   LEAVE

     C                   ENDIF

     C                   ADD       1             Ix
     C                   ENDDO

     C                   RESET                   ReturnCode

     C                   CALLB     'ZAMSGHNDLE'

      ** Return code (10A, returned to this procedure)
      ** Deal repair location (1A, from caller)
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    ReturnCode
     C                   PARM                    APRprLocn
     C                   PARM                    APCnfValFO

      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgIDArr
     C                   PARM                    FldNoArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgDtaArr

      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Midas module ID (2A)
      ** Midas transaction ID (6A, from caller)
      ** Message file (10A, from caller)
     C                   Parm                    ModuleID
     C                   PARM                    DDDPRN
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
      ** Status of transaction (1A, F=Failure, S=Success)
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    DDACTN
     C                   PARM                    TranStatus        1
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
      ** Screen-handling module (10A, from caller)
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
      ** The transaction's timestamp
     C                   PARM                    APRpyQueue
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ

     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
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
      * Common header information (DS) from source system
      * Transaction information in a single large field from source system
     C                   PARM                    HeadIn
     C                   PARM                    Trans500        500
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500                     CAP004
     C                   PARM                    OthDData                                    BUG9632
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

     C                   EVAL      DBPGM = 'SEDPMVCTL'

      ** Set up the name of the primary and secomdary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      *
      ** Set up the Module ID, used to make the Transaction number unique
      *
     C                   EVAL      ModuleID = 'SE'
      *
      ** Initialize Ok Indicators
      *
     C                   MOVE      *ALL'Y'       OKFlagsDS
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*                                                                         CSE012
     C** Access Switchable Features File, for SE Depot Movement Narratives      CSE012
     C*                                                                         CSE012
     C                   MOVE      'N'           CSE012            1            CSE012
     C                   CALLB     'AOSARDR0'                                   CSE012
     C                   PARM      *BLANKS       PRTCD             7            CSE012
     C                   PARM      '*VERIFY'     POPTN             7            CSE012
     C                   PARM      'CSE012'      PSARD             6            CSE012
     C*                                                                         CSE012
     C     PRTCD         IFEQ      *BLANKS                                      CSE012
     C                   MOVE      'Y'           CSE012                         CSE012
     C                   ENDIF                                                  CSE012
     C*                                                                         CSE012
     C** Database Error                                                         CSE012
     C*                                                                         CSE012
     C     PRTCD         IFNE      *BLANKS                                      CSE012
     C     PRTCD         ANDNE     '*NRF   '                                    CSE012
     C                   MOVEL     'CSE012 '     DBKEY                          CSE012
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE012
     C                   MOVEL     '002'         DBASE                          CSE012
     C                   EXSR      *PSSR                                        CSE012
     C                   ENDIF                                                  CSE012
     C                                                                          CSE012
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
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE  = 3                                                 CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CGL031
      ** Access Switchable Features File, for SE Depot Movement Narratives                    CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
                                                                                              CGL031
     C                   IF        PRTCD = *BLANKS                                            CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C                   IF        PRTCD <> *Blanks AND PRTCD <> '*NRF   '                    CGL031
     C                   EVAL      DBKEY = 'CGL031'                                           CGL031
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBASE = 5                                                  CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                CAP011
      ** Retrieve the status of CSE039                                                        CSE039
      *                                                                                       CSE039
     C                   MOVE      'N'           CSE039            1                          CSE045
      *                                                                                       CSE039
     C                   CALLB     'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RtCd                                        CSE039
     C                   PARM      '*VERIFY'     @Optn                                        CSE039
     C                   PARM      'CSE039'      @SARD                                        CSE039
      *                                                                                       CSE039
     C                   IF        @RtCd = *Blanks                                            CSE039
     C                   MOVE      'Y'           CSE039                                       CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
      ** Access API ICD via access program                                      CAP011
      *  (database error handling done in access program)                       CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      '*DBERR '     @RTCD             7            CAP011
     C                   PARM      '*FIRST '     @OPTN             7            CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011

      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APDPMVDTQ'
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 902                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEDPMVC021
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is active                      CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
      ** ULX602 - API Luxembourg - Function SEDPMV                                            CER001
      *                                                                                       CER001
     C                   EVAL      ULX602 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX602'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS AND                                        CER001
     C                             BGLRIN = 'Y'                                               CER001
     C                   EVAL      ULX602 = 'Y'                                               CER001
     C                   OPEN      SEVDMLX1PD                                                 CER001
     C                   OPEN      SEIDMLX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   If        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX602'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 903                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX008 - API Commissariat Aux Bourses (Funct. SEDPMV/SETRAD)                         CER001
      *                                                                                       CER001
     C                   EVAL      ULX008 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   EVAL      ULX008 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX008'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 904                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
