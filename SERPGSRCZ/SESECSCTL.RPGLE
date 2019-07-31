     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities interface controller')             *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSCTL - Securities Interface Controller                  *
      *                                                               *
      *  Function: This module validates Securities input into the    *
      *            Midas database.                                    *
      *            Processes to be executed controlled by input       *
      *            Action Code:                                       *
      *            - For I (=INSERT) or A (=AMEND), validate the      *
      *              Securities.                                      *
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
      *            For all Action Codes, the decision as to whether   *
      *            to write to the Valid or Invalid file and the call *
      *            to the Message Handler (ZAMSGHNDLE) will take      *
      *            place in this module.                              *
      *                                                               *
      *  Component of: SESECSCTL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 AR996842           Date 11Feb13               *
      *                 CRE073             Date 10Dec06               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247440             Date 11May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9529            Date 17Nov05               *
      *                 CER001             Date 25Apr05               *
      *                 232543             Date 04Apr05               *
      *                 CGL031             Date 05Jul04               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 26May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 22Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE037             Date 29Apr02               *
      *                 216804             Date 09Apr03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 CSE031             Date 19Nov01               *
      *                 CSE032             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE029             Date 20Jul01               *
      *                 192054             Date 28Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060             Date 22May01               *
      *                 CSD006             Date 02Jan01               *
      *                 183604             Date 16Oct00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  AR996842 - Creation of new security details: Private Banking *
      *             Instrument type defaulting improvement            *
      *             (Child:AR996843)                                  *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      * 247440 - Parameter mismatch for SESECS3VL (232543)            *
      *        - Parameter mismatch for SESECS2VL (CGL032)            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9529 - Use full length of SEVSECSPD data structure        *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation on Savings Income                          *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSE037 - Countervalue rounding                               *
      *  216804 - *ENTRY Parameter missing for CSE031 in SESECSCTL    *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSE032 - Recompile over recompiled SESECS2VL.                *
      *  CSE029 - ISO15022 Message Generation (recompile)             *
      *  192054 - ISIN code must be available if PB is on             *
      *  CAP060 - Midas APIs Sec Prices                               *
      *  CSD006 - Market Data Feed                                    *
      *  183604 - Industry Code and Market Center must be mandatory   *
      *           when new PB Module is switched ON. Rating Code      *
      *           must be validated against new table PBRATIPD when   *
      *           new PB Module is switched ON.                       *
      *  CSE023 - Treaty Withholding Tax                              *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Valid securities
     FSEVSECSPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Invalid securities
     FSEISECSPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Valid securities by front office Id
     FSEVSECSL0 IF   E           K DISK    RENAME(SEVSECSD0:SEVSECSCHK)
      *
      ** Valid securities by security shortname and timestamp
     FSEVSECSL1 IF   E           K DISK    RENAME(SEVSECSD0:SEVSECSCHM)
      *
      ** Sequence number for input fields
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESECSC001
      *                                                                                      LLN022A
      ** Valid Security BoE details                                                          LLN022A
      *                                                                                      LLN022A
     FSEVSECSY0 UF A E             DISK    INFSR(*pssr)                                      LLN022A
     F                                     RENAME(SEVSECSD0:VSECSD0)                         LLN022A
     F                                     COMMIT                                            LLN022A
      *                                                                                      LLN022A
      ** Invalid Security BoE details                                                        LLN022A
      *                                                                                      LLN022A
     FSEISECSX0 UF A E             DISK    INFSR(*pssr)                                      LLN022A
     F                                     RENAME(SEISECSD0:ISECSD0)                         LLN022A
     F                                     COMMIT                                            LLN022A
                                                                                             LLN022A
     FSEVSELX2PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FSEISELX2PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
     FSEVSELX3PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FSEISELX5PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
     FSEVSELX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FSEISELX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes definition  for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
      /COPY ZACPYSRC,PROCPARMS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** String for error messages to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Work array for setting up new security shortname
     D WYA1            S              1    DIM(18)
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
      *
      ** Message header details
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities screen 3 details from incoming transaction
      ** - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *                                                                                       CSE031
      ** Securities screen 4 details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     D NwSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)                                  CSE031
                                                                                              CAS006
      ** Securities Screen 5 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     D NwSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)                                  CAS006
                                                                                              CSE071
      ** Securities Screen 6 Details From Incoming Transaction                                CSE071
      ** - Screen Format                                                                      CSE071
     D NwSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
     D*NwSEFilFmt1             1    899                                               CSE074 BUG9529
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O)
      *
      ** Securities screen 2 details retrieved from file
      ** - screen format
     D CrSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
     D                                     PREFIX(O)
      *
      ** Securities screen 3 details retrieved from file
      ** - screen format
     D CrSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
     D                                     PREFIX(O)
      *                                                                                       CSE031
      ** Securities screen 4 details retrieved from file                                      CSE031
      ** - screen format                                                                      CSE031
     D CrSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)                                  CSE031
     D                                     PREFIX(O)                                          CSE031
                                                                                              CAS006
      ** Securities Screen 5 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     D CrSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)                                  CAS006
     D                                     PREFIX(O)                                          CAS006
                                                                                              CSE071
      ** Securities Screen 6 Details Retrieved From File                                      CSE071
      ** - Screen Format                                                                      CSE071
     D CrSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
     D                                     PREFIX(O)                                          CSE071
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
     D*CrSEFilFmt1             1    899                                               CSE074 BUG9529
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** Securities screen 3 error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
      *                                                                                       CSE031
      ** Securities screen 4 error indicators                                                 CSE031
     D SEESEC4       E DS                  EXTNAME(SEESEC4PD)                                 CSE031
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     D SEESEC5       E DS                  EXTNAME(SEESEC5PD)                                 CAS006
                                                                                              CSE071
      ** Securities Screen 6 Error Indicators                                                 CSE071
     D SEESEC6       E DS                  EXTNAME(SEESEC6PD)                                 CSE071
      *
      ** Securities extra data
     D PExtData      E DS                  EXTNAME(SESEEXPD)
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(SESERXPD)                                  CER001
      *
      ** Externally described DS for investment types
     D Pinvtp        E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(P)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for funds transfer ICD details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      *
      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for retail ICD details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** Externally described DS for securities trading details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             01     01
                                                                                              CSC011
      ** 24x7 Status Dataarea                                                                 CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011

     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error messages
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D W1              S              3P 0
     D W2              S              3P 0
      *
      ** Index for arrays of error message Ids in amend validation
     D AMIDx           S              3P 0
      *
      ** Fields (500A) to receive the incoming transaction
     D PTrans5001      S            500A
     D PTrans5002      S            500A
     D PTrans5003      S            500A
     D PTrans5004      S            500A                                                      216804
     D PTrans5005      S            500A                                                      CAS006
     D PTrans5006      S            500A                                                      CSE071
      *
      ** Parametes for data substitution program.
     D PIncData        S           2000A
     D PCurData        S           2000A
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
      *                                                                                       CER001
     D RegData500      S            500A                                                      CER001
      *
      ** Timestamp for the transaction
     D PTimestamp      S               Z
      *
      ** Fields to be used on call to module APCALOBJ (Allocate Object API)
     D PObject         S             10A   INZ('SESECSUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcObj         S              1A   INZ('Y')
     D PReturn         S              7A
      *
      ** Module Id to be passed to the message handler
     D PModuleId       S              2A   INZ('SE')
      *
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list)
     D PClrPgmMsgQ     S              1A   INZ('Y')
      *
      ** Overall Transaction status, to be passed to the message handler
     D PTranStatus     S              1A
      *
      ** Dummy message Id and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgId     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     D PMode           S              6A
      *
      ** Work parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PTranID         S             20A
     D PMKTN           S             20A
     D PPrCpn          S              1A
     D POthInf         S            156A
     D PResetFld       S              1A
     D PAmendOk        S              1A
     D POSESN          S             10A
     D PPOldSecDtl     S              1A
     D PLCPN           S              6A
     D PNCD            S              6A
     D PNMDP           S              1P 0
     D PVLDP           S              1P 0
     D POutFlds        S             51A
     D PMQReturn       S             10A
     D PMQErrLong      S            132A
      *
      ** Switchable features
     D CEU017          S              1A
     D CEU018          S              1A
     D CSE005          S              1A
     D CSE007          S              1A
     D CSE011          S              1A
     D S01401          S              1A
     D S01511          S              1A
     D CSE023          S              1A                                        CSE023
     D CSE031          S              1A                                        CSE031
     D CSC011          S              1A                                                      CSC011
     D CAS006          S              1A   INZ('N')                                           CAS006
     D CSE071          S              1A                                                      CSE071
     D*CSE065***       S              1A   INZ('N')                                   CSE074 BUG9529
     D CGL032          S              1A                                                      CGL032
     D CGL031          S              1A                                                      CGL031
      *
      ** Redisplay screen flag
     D PReDsp          S              1A   INZ(*BLANK)
      *
      ** Work variable
     D WSubSE1         S              1A
     D WSubSE2         S              1A
     D WSubSE3         S              1A
     D WSubSE4         S              1A                                                      CAS006
     D WSubSE5         S              1A                                                      CAS006
     D WSubSE6         S              1A                                                      CSE071
     D WMQError        S             28A
                                                                                              CSD006
      * Market Data Feed                                                                      CSD006
     D CSD006          S              1A                                                      CSD006
      *                                                                                       CSD006
      ** Countervalue rounding                                                                CSE037
     D CSE037          S              1A                                                      CSE037
      *                                                                                       CSE037
      * Midas APIs Sec Prices                                                                 CAP060
     D CAP060          S              1A                                                      CAP060
                                                                                              CAP060
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNumber     S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PParmLink       S              1A                                                      CSC011
     D WkDate          S              5  0                                                    CSC011
     D WkNext          S              5  0                                                    CSC011
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESECSC002
      *                                                                                      LLN022A
      ** Valid Security Bankof England details layout                                        LLN022A
      *                                                                                      LLN022A
     D ValidBoE      E DS                  EXTNAME(SEVSECSX0)                                LLN022A
      *                                                                                      LLN022A
      ** OK Indicators for fields                                                            LLN022A
      *                                                                                      LLN022A
     D OKCuBoE       E DS                  EXTNAME(SEESECSX0)                                LLN022A
      *                                                                                      LLN022A
      ** DATA Structure for passing data required further down the Call Stack                LLN022A
      *                                                                                      LLN022A
     D DATA            DS          1024                                                      LLN022A
     D ULSESN                  1     10                                                      LLN022A
                                                                                             LLN022A
     DDATALUX          DS          1024                                                       CER001
     D  #1SESN                 1     10A                                                      CER001
     D  #1FOTR                11     30A                                                      CER001
     D  #1ISNO                31     42A                                                      CER001
     D  #1MATY                43     48A                                                      CER001
      *                                                                                       CER001
      ** Valid Extended Secur in File Format                                                  CER001
      *                                                                                       CER001
     D ValidFilEx4   E DS                  EXTNAME(SEVSELX2PD)                                CER001
      *                                                                                       CER001
      ** Errors Indicators Extended Fields                                                    CER001
      *                                                                                       CER001
     D OkFlagsEx4    E DS                  EXTNAME(SEESELX2PD)                                CER001
      *                                                                                       CER001
      ** Valid Extended Secur in File Format                                                  CER001
      *                                                                                       CER001
     D ValidFilEx6   E DS                  EXTNAME(SEVSELX3PD)                                CER001
      *                                                                                       CER001
      ** Errors Indicators Extended Fields                                                    CER001
      *                                                                                       CER001
     D OkFlagsEx6    E DS                  EXTNAME(SEESELX3PD)                                CER001
      *                                                                                       CER001
      ** Valid Extended Secur in File Format                                                  CER001
      *                                                                                       CER001
     D ValidFilExL   E DS                  EXTNAME(SEVSELX1PD)                                CER001
      *                                                                                       CER001
      ** Errors Indicators Extended Fields                                                    CER001
      *                                                                                       CER001
     D OkFlagsExL    E DS                  EXTNAME(SEESELX1PD)                                CER001
      *                                                                                       CER001
      ** External data structures for Customer Details                                        CER001
      *                                                                                       CER001
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER001
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,SESECSC003
      *
      ** Incoming transaction is in 500A fields, so that a common
      ** CLP can be used between this module and the one that
      ** read the MQ queue.  Break the 500A data by loading
      ** them into the appropriate (externally-described)
      ** data structures.
      *
     C                   MOVEL     PTrans5001    NwSE1ScnFmt
     C                   MOVEL     PTrans5002    NwSE2ScnFmt
     C                   MOVEL     PTrans5003    NwSE3ScnFmt
     C                   MOVEL     PTrans5004    NwSE4ScnFmt                                  216804
     C                   MOVEL     PTrans5005    NwSE5ScnFmt                                  CAS006
     C                   MOVEL     PTrans5006    NwSE6ScnFmt                                  CSE071
     C                   MOVEL     PExtData500   PExtData
     C                   MOVEL     RegData500    Regdata                                      CER001
      *
      ** Generate a timestamp for this transaction.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetFld
      *
      /COPY WNCPYSRC,SESECSC004
      *
      ** Check if valid securities exists for front office Id
      ** in the valid records file.
      *
     C                   EXSR      SRChkValTran
      *
      ** If valid securities does exist even after delay,
      ** fail this input.
      *
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Check if valid securities exists for midas security shortname.
      *
     C                   EXSR      SRChkValMTran
      *
      ** If valid securities does exist even after delay,
      ** fail this input.
      *
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Reset fields again in case the details have been corrupted
      ** by previous chain to valid securities file.
      *
     C                   EXSR      SRResetFld
      *
      /COPY WNCPYSRC,SESECSC005
      *
      ** Validate action code versus the security shortname supplied.
      ** original securities details are retrieved during the
      ** validation process.
      *
     C                   EXSR      SRValAction
      *
      /COPY WNCPYSRC,SESECSC006
      *
      ** If errors occurred in the initial validation, fail this input.
      *
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Processing depends upon action code.
      *
     C                   SELECT
      *
      ** Insert
      ** ======
      *
     C                   WHEN      DDACTN = 'I'
      *
      /COPY WNCPYSRC,SESECSC007
      *
      ** Validate incoming Securities details.
      *
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,SESECSC008
      *
      ** If LLN007 is ON and other data is valid then validate Bank Of                       LLN022A
      ** England Extra Data.                                                                 LLN022A
      *                                                                                      LLN022A
     C     LLN007        IfEq      'Y'                                                       LLN022A
     C     Idx           AndEq     0                                                         LLN022A
      *                                                                                      LLN022A
      ** Set Up DATA to be passed.                                                           LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     DDSESN        ULSESN                                      LLN022A
                                                                                             LLN022A
     C                   CALLB     'BYSECSW0VL'                                              LLN022A
      *                                                                                      LLN022A
      ** INPUTS                                                                              LLN022A
      *                                                                                      LLN022A
      ** Response mode                                                                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    RespMode          1                         LLN022A
      *                                                                                      LLN022A
      ** Data required further down call stack.                                              LLN022A
      *                                                                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details                                                             LLN022A
      *                                                                                      LLN022A
     C                   PARM                    PExtData                                    LLN022A
      *                                                                                      LLN022A
      ** OUTPUTS                                                                             LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details OK inds                                                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    OKCuBoE                                     LLN022A
      *                                                                                      LLN022A
      ** Error fields/message IDs/message data (arrays) from/to caller                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    Idx                                         LLN022A
      *                                                                                      LLN022A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WIdx                                        LLN022A
      *                                                                                      LLN022A
      ** Valid Bank of England layout (DS) from/to caller                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
                                                                                             LLN022A
     C                   EndIf                                                               LLN022A
                                                                                             LLN022A
      ** Amend
      ** =====
      *
     C                   WHEN      DDACTN = 'A'
      *
      /COPY WNCPYSRC,SESECSC009
      *
      ** Convert original securites details from file
      ** to screen format.
      *
     C                   EXSR      SRCvtSecD
      *
      /COPY WNCPYSRC,SESECSC010
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
      *
     C                   IF        GHSUBS <> *BLANK

     C     GHSUBS        SCAN      NwSE1ScnFmt                            99
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubSE1
     C                   ELSE
     C                   MOVE      'N'           WSubSE1
     C                   ENDIF

     C     GHSUBS        SCAN      NwSE2ScnFmt                            99
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubSE2
     C                   ELSE
     C                   MOVE      'N'           WSubSE2
     C                   ENDIF

     C     GHSUBS        SCAN      NwSE3ScnFmt                            99
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubSE3
     C                   ELSE
     C                   MOVE      'N'           WSubSE3
     C                   ENDIF
                                                                                              CAS006
     C     GHSUBS        SCAN      NwSE4ScnFmt                            99                  CAS006
     C                   IF        *IN99                                                      CAS006
     C                   MOVE      'Y'           WSubSE4                                      CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      'N'           WSubSE4                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C     GHSUBS        SCAN      NwSE5ScnFmt                            99                  CAS006
     C                   IF        *IN99                                                      CAS006
     C                   MOVE      'Y'           WSubSE5                                      CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      'N'           WSubSE5                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CSE071
     C     GHSUBS        SCAN      NwSE6ScnFmt                            99                  CSE071
     C                   IF        *IN99                                                      CSE071
     C                   MOVE      'Y'           WSubSE6                                      CSE071
     C                   ELSE                                                                 CSE071
     C                   MOVE      'N'           WSubSE6                                      CSE071
     C                   ENDIF                                                                CSE071
      *
      ** Do data substitution.
      *
     C                   IF        WSubSE1 = 'Y' OR WSubSE2 = 'Y' OR
     C                             WSubSE3 = 'Y'
     C                   EXSR      SRDtaSubs
     C                   ENDIF

     C                   ENDIF
      *
      /COPY WNCPYSRC,SESECSC011
      *
      ** Validate incoming Securities details.
      *
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,SESECSC012
      *
      ** If LLN007 is ON and other data is valid then validate Bank Of                       LLN022A
      ** England Extra Data.                                                                 LLN022A
      *                                                                                      LLN022A
     C     LLN007        IfEq      'Y'                                                       LLN022A
     C     Idx           AndEq     0                                                         LLN022A
      *                                                                                      LLN022A
      ** Set Up DATA to be passed.                                                           LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     DDSESN        ULSESN                                      LLN022A
                                                                                             LLN022A
     C                   CALLB     'BYSECSW0VL'                                              LLN022A
      *                                                                                      LLN022A
      ** INPUTS                                                                              LLN022A
      *                                                                                      LLN022A
      ** Response mode                                                                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    RespMode          1                         LLN022A
      *                                                                                      LLN022A
      ** Data required further down call stack.                                              LLN022A
      *                                                                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details                                                             LLN022A
      *                                                                                      LLN022A
     C                   PARM                    PExtData                                    LLN022A
      *                                                                                      LLN022A
      ** OUTPUTS                                                                             LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details OK inds                                                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    OKCuBoE                                     LLN022A
      *                                                                                      LLN022A
      ** Error fields/message IDs/message data (arrays) from/to caller                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    Idx                                         LLN022A
      *                                                                                      LLN022A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WIdx                                        LLN022A
      *                                                                                      LLN022A
      ** Valid Bank of England layout (DS) from/to caller                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
                                                                                             LLN022A
     C                   EndIf                                                               LLN022A
                                                                                             LLN022A
      ** Check if amended fields are amendable.
      *
     C                   EXSR      SRValAmend
      *
      /COPY WNCPYSRC,SESECSC013
      *
     C                   ENDSL
      *
     C     INVALID       TAG
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,SESECSC014
      *
     C                   IF        ARErrMod <> *BLANK

     C                   EVAL      PMQErrLong = *BLANK
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError
     C                   MOVEL     WMQError      PMQErrLong

     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMQReturn
     C                   PARM                    PMQErrLong
     C                   PARM                    PDummyMsgId
     C                   PARM                    PDummyMsgF

     C                   MOVEL     ARErrMod      APRetCode
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
     C                   RETURN

     C                   ELSE
      *
      ** Processing for error checking/write to database.
      *
      /COPY WNCPYSRC,SESECSC015
      *                                                                                       CER001
     C                   IF        ULX610 = 'Y' OR                                            CER001
     C                             ULX043 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Fill data added for windows                                                          CER001
      *                                                                                       CER001
     C                   MOVEL     DDSESN        #1SESN                                       CER001
      *                                                                                       CER001
      ** ULX004 - Field for ERL910 Calls                                                      CER001
      ** Retrieve Issuer details                                                              CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       @KEYC                                        CER001
     C                   MOVEL     DDISSR        @KEYC            10                          CER001
     C                   CALL      'AOCUSTR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*KEY   '     @OPTN                                        CER001
     C                   PARM                    @KEYC                                        CER001
     C                   PARM      *BLANKS       @KYST             7                          CER001
     C     SDCUST        PARM      SDCUST        DSSDY                                        CER001
      *                                                                                       CER001
      ** Interest bearing security.                                                           CER001
      *                                                                                       CER001
     C                   IF        (S1STBS = 'P' AND PPROT <> '2' AND                         CER001
     C                             PPROT <> '4' AND PPROT <> '7') OR                          CER001
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND                         CER001
     C                             PPROT <> '4' AND PPROT <> '7' AND                          CER001
     C                             PPROT <> '9')                                              CER001
     C                   MOVE      DDMATY2       #1MATY                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Discount Security                                                                    CER001
      *                                                                                       CER001
     C                   IF        S1STBS = 'D' OR                                            CER001
     C                             (S1STBS = 'Y' AND PPROT = '9')                             CER001
     C                   MOVE      DDMATY1       #1MATY                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX008 - CSSF reporting                                                              CER001
      *                                                                                       CER001
     C                   IF        ULX008 = 'Y'                                               CER001
     C                   MOVEL     DDISIN        #1ISNO                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX610 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsEx4                                   CER001
     C                   MOVE      *ALL'Y'       OkFlagsEx6                                   CER001
      *                                                                                       CER001
      ** Validate the extension transaction details for first window                          CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS6VL2'                                               CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsEx4                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilEx4                                  CER001
      *                                                                                       CER001
      ** Validate the extension transaction details for 2nd window                            CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS7VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsEx6                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilEx6                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExL                                   CER001
      *                                                                                       CER001
      ** Validate the extension transaction details for IBLC window                           CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS8VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsExL                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExL                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C                   IF        Idx        = 0                                             CER001
      *                                                                                       CER001
     C                   IF        ULX610     = 'Y'                                           CER001
     C                   EVAL      #4LXVXSESN = DDSESN                                        CER001
     C                   EVAL      #4LXVXTOPR = APFOTranID                                    CER001
     C                   EVAL      #4LXVXTMES = PTimestamp                                    CER001
     C                   WRITE     SEVSELXD4                                                  CER001
     C                   EVAL      #6LXVVSESN = DDSESN                                        CER001
     C                   EVAL      #6LXVVTOPR = APFOTranID                                    CER001
     C                   EVAL      #6LXVVTMES = PTimestamp                                    CER001
     C                   WRITE     SEVSELXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043     = 'Y'                                           CER001
     C                   EVAL      #LLXVVSESN = DDSESN                                        CER001
     C                   EVAL      #LLXVVTOPR = APFOTranID                                    CER001
     C                   EVAL      #LLXVVTMES = PTimestamp                                    CER001
     C                   WRITE     SEVSELXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C                   IF        Idx       > 0   AND                                        CER001
     C                             APRprLocn = 'B'                                            CER001
      *                                                                                       CER001
     C                   IF        ULX610   = 'Y'                                             CER001
     C                   EVAL      #4LXFOTR = APFOTranID                                      CER001
     C                   EVAL      #4LXTMES = PTimeStamp                                      CER001
     C                   EVAL      #4LXPORE = L4LXPORE                                        CER001
     C                   WRITE     SEISELXD4                                                  CER001
     C                   EVAL      #6LXFOTR = APFOTranID                                      CER001
     C                   EVAL      #6LXTMES = PTimeStamp                                      CER001
     C                   MOVEL     L6LXSECT      #6LXSECT                                     CER001
     C                   EVAL      #6LXROFC = L6LXROFC                                        CER001
     C                   EVAL      #6LXRATC = L6LXRATC                                        CER001
     C                   MOVE      L6LXIM93      #6LXIM93                                     CER001
     C                   MOVE      L6LXCLAT      #6LXCLAT                                     CER001
     C                   EVAL      #6LXSUBR = L6LXSUBR                                        CER001
     C                   MOVEL     L6LXLUSU      #6LXLUSU                                     CER001
     C                   EVAL      #6LXVOTR = L6LXVOTR                                        CER001
     C                   EVAL      #6LXSECD = L6LXSECD                                        CER001
     C                   EVAL      #6LXSNCD = L6LXSNCD                                        CER001
     C                   EVAL      #6LXEEEM = L6LXEEEM                                        CER001
     C                   EVAL      #6LXQUOT = L6LXQUOT                                        CER001
     C                   WRITE     SEISELXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043   = 'Y'                                             CER001
     C                   EVAL      #LLXFOTR = APFOTranID                                      CER001
     C                   EVAL      #LLXTMES = PTimeStamp                                      CER001
     C                   EVAL      #LLXISTP = LLLXISTP                                        CER001
     C                   WRITE     SEISELXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001

     C                   EXSR      SRCheckWrite

      /COPY WNCPYSRC,SESECSC016
      *
      ** If valid, send data queue entry to prompt DB update program.
      *
     C                   IF        IDx = 0
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Check if update program active using Allocate Object API.
      ** No prompting necessary if program is running.
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockState
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcObj
     C                   PARM      *BLANK        PReturn

     C                   IF        PReturn = *BLANK
      *
      ** Check if any messages are already on the data queue.
      ** No need to send duplicate prompt messages.
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESECSC017
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkValTran - Routine to check if valid securities exist    *
      *                 for Front Office Id in the valid Securities   *
      *                 file.                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRChkValTran  BEGSR
      *
      ** Check for front office Id in the valid records file.
      ** Run delay program if record found.
      *
     C     APFOTRANID    CHAIN     SEVSECSL0                          01

     C                   IF        RecNotFnd = False
      *
      ** Run delay program, then repeat chain.
     C                   CALLB     'ZACDELAY'

     C     APFOTRANID    CHAIN     SEVSECSL0                          01
      *
      ** Error if front office Id is still present.
     C                   IF        RecNotFnd = False
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDSESN'
     C                   EVAL      MsgIDArr(IDx)   = 'APM0900'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkValMTran - Routine to check if valid Securities exists   *
      *                 for Midas Security shortname in the valid     *
      *                 Securities file.                              *
      *                                                               *
      *****************************************************************
      *
     C     SRChkValMTran BEGSR
      *
      ** Check for midas security shortname in the valid records file.
      ** Run delay program if record found.
      *
     C     DDSESN        CHAIN     SEVSECSL1                          01

     C                   IF        RecNotFnd = False
      *
      ** Run delay program, then repeat chain.
     C                   CALLB     'ZACDELAY'

     C     DDSESN        CHAIN     SEVSECSL1                          01
      *
      ** Error if midas back office reference is still present.
     C                   IF        RecNotFnd = False
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDSESN'
     C                   EVAL      MsgIDArr(IDx) = 'APM0900'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAction - Routine to validate Action Code for the        *
      *                Security shortname supplied                    *
      *              - Original Securities details are retrieved      *
      *                during the validation process                  *
      *                                                               *
      *****************************************************************
     C     SRValAction   BEGSR
      *
      ** If insert, set retrieve mode to '*FRONT' (Access using Front
      ** Office Id).  Otherwise, if not insert and midas security
      ** shortname is present, set retrieve mode to blank
      ** (Access using Midas Security shortname).
      *
     C                   IF        DDACTN = 'I'
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE

     C                   IF        DDSESN = *BLANK
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
     C                   EVAL      PMode = *BLANKS
     C                   ENDIF

     C                   ENDIF

     C                   CALLB     'SESECSRTV'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front office transaction identifier (20A from caller)
     C                   PARM                    APFOTRANID
      *
      ** Security shortname
     C                   PARM                    DDSESN
      *
      ** Old Security from link proccessing
     C                   PARM                    POSESN
      *
      ** Process old security details indicator
     C                   PARM      'N'           PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Action code error indicator
     C                   PARM                    OKACTN
      *
      ** Security shortname error indicator
     C                   PARM                    OKSESN
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment type details
     C                   PARM                    Pinvtp
      *
      ** For the rest of the processing, set Mode of Operation
      ** to '*FRONT' for the other modules to process the
      ** transaction as coming from an external system.
      *
     C                   MOVEL     '*FRONT'      PMode

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDetails - Routine to validate Securities details.       *
      *               - Amended file fields (for update) are set up   *
      *                 during the validation process                 *
      *                                                               *
      *****************************************************************
     C     SRValDetails  BEGSR
      *
      ** Move Securities details retrieved from the midas
      ** database file into the update file record.  If no
      ** record has been retrieved (i.e. in Insert), fields
      ** contain initial values (zeros, blanks).
      *
     C**********         MOVEL     CrSEFilFmt    NwSEFilFmt                                   CSE074
     C**********         MOVEL     CrSEFilFmt1   NwSEFilFmt1                          CSE074 BUG9529
      *                                                                                       CSE074
     C**********         IF        CSE065 = 'Y'                                       CSE074 BUG9529
     C**********         Z-ADD     ALDT          S1ALDT                               CSE074 BUG9529
     C**********         ELSE                                                         CSE074 BUG9529
     C**********         Z-ADD     *ZEROS        S1ALDT                               CSE074 BUG9529
     C**********         ENDIF                                                        CSE074 BUG9529
     C                   MOVEL     CrSEFilFmt    NwSEFilFmt                                  BUG9529
      *
      ** Setup defaults on screen 1.
      *
     C                   EXSR      SRDefault1
      *
      ** Validate screen 1 details.
      *
     C                   EXSR      SRVScrn1
      *
      ** If error occurred in the previous validation, bypass
      ** remaining processing.
      *
     C                   IF        IDx <> 0
     C                   GOTO      EValDetails
     C                   ENDIF
      *
      ** Setup defaults on screen 2.
      *
     C                   EXSR      SRDefault2
      *
      ** Validate screen 2 details.
      *
     C                   EXSR      SRVScrn2
      *
      ** If error occurred in the previous validation, bypass
      ** remaining processing.
      *
     C                   IF        IDx <> 0
     C                   GOTO      EValDetails
     C                   ENDIF
      *                                                                                       CSE031
      ** Validate screen 4 details if CSE031 is on.                                           CSE031
      *                                                                                       CSE031
     C                   IF        CSE031 = 'Y'                                               CSE031
     C                   EXSR      SRVScrn4                                                   CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CAS006
      ** Validate Screen 5 Details.                                                           CAS006
                                                                                              CAS006
     C                   EXSR      SRVScrn5                                                   CAS006
                                                                                              CAS006
     C                   IF        IDx <> *ZERO                                               CAS006
     C                   GOTO      EValDetails                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CSE071
      ** Validate Screen 6 Details if CSE071 is on.                                           CSE071
                                                                                              CSE071
     C                   IF        CSE071 = 'Y'                                               CSE031
     C                   EXSR      SRVScrn6                                                   CSE071
                                                                                              CSE071
     C                   IF        IDx <> *ZERO                                               CSE071
     C                   GOTO      EValDetails                                                CSE071
     C                   ENDIF                                                                CSE071
     C                   ENDIF                                                                CSE071
      *
      ** Validate screen 3 details.
      *
     C                   EXSR      SRVScrn3

     C     EValDetails   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault1 - Defaulting for screen 1                         *
      *                                                               *
      *****************************************************************
     C     SRDefault1    BEGSR

     C                   CALLB     'SESECS1DT'
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment type details
     C                   PARM                    PINVTP
      *
      ** Redisplay screen
     C                   PARM      *BLANK        PReDsp
      *
      ** OUTPUT
      ** ======
      *
      ** Securities screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVScrn1  - Validate screen 1 details                        *
      *                                                               *
      *****************************************************************
     C     SRVScrn1      BEGSR

     C                   CALLB     'SESECS1VL'
      *
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen INPUT function)
     C                   PARM                    PMode
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** Decimals on nominals
     C                   PARM                    CEU018
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *
      ** Market migration
     C                   PARM                    S01511
      *                                                                                       CSD006
      ** Market Data Feed                                                                     CSD006
     C                   PARM                    CSD006                                       CSD006
      *                                                                                       CAP060
      ** Midas APIs Sec Prices                                                                CAP060
     C                   PARM                    CAP060                                       CAP060
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Externally described DS for investment types - output parameter
     C                   PARM                    Pinvtp
      *
      ** Nominal currency's no. of decimal places
     C                   PARM                    PNMDP
      *
      ** Value currency's no. of decimal places
     C                   PARM                    PVLDP
      *
      ** Redisplay screen indicator
     C                   PARM      *BLANK        PReDsp

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault2 - Defaulting for screen 2                         *
      *                                                               *
      *****************************************************************
     C     SRDefault2    BEGSR

     C                   CALLB     'SESECS2DT'
      *
      ** Security screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Security details retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Passed other information coming from link program
     C                   PARM      *BLANKS       POthInf
      *
      ** Externally described DS for investment types
     C                   PARM                    Pinvtp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Risk Management
     C                   PARM                    BGRKMG
      *                                                                                       222373
      ** SWITCHABLE FEATURES                                                                  222373
      ** ===================                                                                  222373
      *                                                                                       222373
      ** Coupon Fixing for Floating Rate Notes                                                222373
     C                   PARM                    CSE031                                       222373
      *
      ** OUTPUT
      ** ======
      *
      ** Security screen 2 details retrieved from file - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Security details for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Fields for display only
     C                   PARM                    POutFlds

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVScrn2  - Validate screen 2 details                        *
      *                                                               *
      *****************************************************************
     C     SRVScrn2      BEGSR

     C                   CALLB     'SESECS2VL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Security screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *                                                                                       CSE071
      ** Securities screen 6 details from incoming transaction                                CSE071
      ** - screen format                                                                      CSE071
     C                   PARM                    NwSE6ScnFmt                                  CSE071
      *                                                                                       CSE071
      ** Securities screen 6 details retrieved from file                                      CSE071
      ** - screen format                                                                      CSE071
     C                   PARM                    CrSE6ScnFmt                                  CSE071
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Settlement depot customer 1
     C                   PARM                    PSDC1
      *
      ** Settlement depot customer 2
     C                   PARM                    PSDC2
      *
      ** Settlement depot customer 3
     C                   PARM                    PSDC3
      *
      ** Protect coupon rate/days
     C                   PARM                    PPrCpn
      *
      ** Nominal currency's decimal places
     C                   PARM                    PNmDp
      *
      ** Value currency's decimal places
     C                   PARM                    PVlDp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - midas run date number
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WkDate                                       CSC011
      *
      ** SDBANK - date of next working day
     C**********         PARM                    BJDNWD                                       CSC011
     C                   PARM                    WkNext                                       CSC011
      *
      ** SDMMOD - interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDSTRD - convertible indicator A/K
     C                   PARM                    BVCIAK
      *                                                                        183604
      ** SDMMOD - Private banking                                              183604
     C                   PARM                    BGN4ST                        183604
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** Corporate action
     C                   PARM                    CSE007
      *
      ** EMU securities redenomination
     C                   PARM                    CEU017
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *                                                                                       CSE031
      ** Coupon Fixing  for Floating Rate Notes                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
      *********************                                                          CGL032   247440
      ***Taxation*on*Savings Income                                                  CGL032   247440
      *********************                                                          CGL032   247440
     C*******************PARM                    CGL032                              CGL032   247440
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen indicator
     C                   PARM      *BLANK        PReDsp
      *
      ** Market Name
     C                   PARM                    PMKTN

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVScrn3  - Validate screen 3 details                        *
      *                                                               *
      *****************************************************************
     C     SRVScrn3      BEGSR

     C                   CALLB     'SESECS3VL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSe2ScnFmt
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSe3ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *                                                                         CSE023
      ** Processing type, from PF/INVTPD                                        CSE023
     C                   PARM                    PPROT                          CSE023
      *
      ** New Issue
     C                   PARM                    DDNISS
      *
      ** Action code
     C                   PARM                    DDACTN
      *                                                                                       247440
      ** Subject to European Tax                                                              247440
     C                   PARM                    DDSETX                                       247440
      *                                                                                     AR996842
      ** Instrument type                                                                    AR996842
      *                                                                                     AR996842
     C                   PARM                    PINNR                                      AR996842
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
      *
      ** SDMMOD - Interest risk management
     C                   PARM                    BGRKMG
      *                                                                         CSE023
      ** CSE023 - US Withholding Tax Treaty                                     CSE023
     C                   PARM                    CSE023                         CSE023
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Securities screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen indicator
     C                   PARM      *BLANK        PReDsp

     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  CSE031
      *****************************************************************                       CSE031
      *                                                               *                       CSE031
      *  SRVScrn4  - Validate screen 4 details                        *                       CSE031
      *                                                               *                       CSE031
      *****************************************************************                       CSE031
     C     SRVScrn4      BEGSR                                                                CSE031
                                                                                              CSE031
     C                   CALLB     'SESECS4VL'                                                CSE031
      *                             =========                                                 CSE031
      ** INPUT                                                                                CSE031
      ** =====                                                                                CSE031
      *                                                                                       CSE031
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSE031
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSE031
      ** Mode = '*RPR  ' (Repair function)                                                    CSE031
      ** Mode = '*SIN  ' (Screen Input function)                                              CSE031
     C                   PARM                    PMode                                        CSE031
      *                                                                                       CSE031
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)                           CSE031
     C                   PARM                    APRESPMODE                                   CSE031
      *                                                                                       CSE031
      ** Securities screen 4 details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Security screen 4 details retrieved from file                                        CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    CrSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Securities retrieved from file - file format                                         CSE031
     C                   PARM                    CrSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** STANDING DATA                                                                        CSE031
      ** =============                                                                        CSE031
      *                                                                                       CSE031
      ** SDBANK - date format indicator                                                       CSE031
     C                   PARM                    BJDFIN                                       CSE031
      *                                                                                       CSE031
      ** SDBANK - midas run date number                                                       CSE031
     C                   PARM                    BJRDNB                                       CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNameArr                                   CSE031
     C                   PARM                    MsgIdArr                                     CSE031
     C                   PARM                    MsgDtaArr                                    CSE031
      *                                                                                       CSE031
      ** Array index (3P0) from/to caller                                                     CSE031
     C                   PARM                    IDx                                          CSE031
      *                                                                                       CSE031
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    WFldNamArr                                   CSE031
     C                   PARM                    WMsgIdArr                                    CSE031
     C                   PARM                    WMsgDtaArr                                   CSE031
      *                                                                                       CSE031
      ** Array index (3P0) from/to caller                                                     CSE031
     C                   PARM                    WIDx                                         CSE031
      *                                                                                       CSE031
      ** Securities screen 4 error indicators                                                 CSE031
     C                   PARM                    SEESEC4                                      CSE031
      *                                                                                       CSE031
      ** Securities for file update - file format                                             CSE031
     C                   PARM                    NwSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Redisplay screen indicator                                                           CSE031
     C                   PARM      *BLANK        PReDsp                                       CSE031
      *                                                                                       CSE031
     C                   ENDSR                                                                CSE031
      *                                                                                       CSE031
      *****************************************************************                       CSE031
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRVScrn5 - Validate Screen 5 Details.                        *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRVScrn5      BEGSR                                                                CAS006
                                                                                              CAS006
     C                   CALLB     'SESECS5VL'                                                CAS006
      *                  --------------------                                                 CAS006
                                                                                              CAS006
      ** Input Parameters                                                                     CAS006
      ** ================                                                                     CAS006
                                                                                              CAS006
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CAS006
      **      = '      ' (Not Front Office Transaction Interface)                             CAS006
      **      = '*RPR  ' (Repair Function)                                                    CAS006
      **      = '*SIN  ' (Screen Input Function)                                              CAS006
     C                   PARM                    PMode                                        CAS006
                                                                                              CAS006
      ** Response Mode = 'A' (Asynchronous)                                                   CAS006
      **               = 'S' (Synchronous)                                                    CAS006
     C                   PARM                    APRespMode                                   CAS006
                                                                                              CAS006
      ** Securities Screen 1 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE1ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 1 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE1ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Detail Retrieved From File - File Format                                  CAS006
     C                   PARM                    CrSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Processing Type                                                                      CAS006
     C                   PARM                    PPROT                                        CAS006
                                                                                              CAS006
      ** Switchable Features:                                                                 CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CAS006
      ** Output Parameters                                                                    CAS006
      ** =================                                                                    CAS006
                                                                                              CAS006
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Error Array Index (3P0) From/To Caller                                               CAS006
     C                   PARM                    IdX                                          CAS006
                                                                                              CAS006
      ** Warning Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                            CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIdArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Warning Array Index (3P0) From/To Caller                                             CAS006
     C                   PARM                    WIdX                                         CAS006
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     C                   PARM                    SEESEC5                                      CAS006
                                                                                              CAS006
      ** Securities Details For File Update - File Format                                     CAS006
     C                   PARM                    NwSEFilFmt                                   CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CSE071
      *****************************************************************                       CSE071
      *                                                               *                       CSE071
      *  SRVScrn6 - Validate Screen 6 Details.                        *                       CSE071
      *                                                               *                       CSE071
      *****************************************************************                       CSE071
     C     SRVScrn6      BEGSR                                                                CSE071
                                                                                              CSE071
     C                   CALLB     'SESECS6VL'                                                CSE071
      *                  --------------------                                                 CSE071
                                                                                              CSE071
      ** Input Parameters                                                                     CSE071
      ** ================                                                                     CSE071
                                                                                              CSE071
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSE071
      **      = '      ' (Not Front Office Transaction Interface)                             CSE071
      **      = '*RPR  ' (Repair Function)                                                    CSE071
      **      = '*SIN  ' (Screen Input Function)                                              CSE071
     C                   PARM                    PMode                                        CSE071
                                                                                              CSE071
      ** Response Mode = 'A' (Asynchronous)                                                   CSE071
      **               = 'S' (Synchronous)                                                    CSE071
     C                   PARM                    APRespMode                                   CSE071
                                                                                              CSE071
      ** Securities Screen 1 Details From Incoming Transaction                                CSE071
      ** - Screen Format                                                                      CSE071
     C                   PARM                    NwSE1ScnFmt                                  CSE071
                                                                                              CSE071
      ** Securities Screen 1 Details Retrieved From File                                      CSE071
      ** - Screen Format                                                                      CSE071
     C                   PARM                    CrSE1ScnFmt                                  CSE071
                                                                                              CSE071
      ** Securities Screen 6 Details From Incoming Transaction                                CSE071
      ** - Screen Format                                                                      CSE071
     C                   PARM                    NwSE6ScnFmt                                  CSE071
                                                                                              CSE071
      ** Securities Screen 6 Details Retrieved From File                                      CSE071
      ** - Screen Format                                                                      CSE071
     C                   PARM                    CrSE6ScnFmt                                  CSE071
                                                                                              CSE071
      ** Securities Detail Retrieved From File - File Format                                  CSE071
     C                   PARM                    CrSEFilFmt                                   CSE071
                                                                                              CSE071
      ** Processing Type                                                                      CSE071
     C                   PARM                    PPROT                                        CSE071
                                                                                              CSE071
      ** Output Parameters                                                                    CSE071
      ** =================                                                                    CSE071
                                                                                              CSE071
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                              CSE071
     C                   PARM                    FldNameArr                                   CSE071
     C                   PARM                    MsgIdArr                                     CSE071
     C                   PARM                    MsgDtaArr                                    CSE071
                                                                                              CSE071
      ** Error Array Index (3P0) From/To Caller                                               CSE071
     C                   PARM                    IdX                                          CSE071
                                                                                              CSE071
      ** Warning Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                            CSE071
     C                   PARM                    WFldNamArr                                   CSE071
     C                   PARM                    WMsgIdArr                                    CSE071
     C                   PARM                    WMsgDtaArr                                   CSE071
                                                                                              CSE071
      ** Warning Array Index (3P0) From/To Caller                                             CSE071
     C                   PARM                    WIdX                                         CSE071
                                                                                              CSE071
      ** Securities Screen 6 Error Indicators                                                 CSE071
     C                   PARM                    SEESEC6                                      CSE071
                                                                                              CSE071
      ** Securities Details For File Update - File Format                                     CSE071
     C                   PARM                    NwSEFilFmt                                   CSE071
                                                                                              CSE071
     C                   ENDSR                                                                CSE071
      *****************************************************************                       CSE071
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtSecD - Convert securities details from file to          *
      *              screen format                                    *
      *                                                               *
      *****************************************************************
     C     SRCvtSecD     BEGSR

     C                   CALLB     'SESECSCVT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Security details retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Passed other information from link proccessing
     C                   PARM      *BLANKS       POthInf
      *
      ** Process old security details indicator
     C                   PARM      'N'           PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - midas run day number
     C                   PARM                    BJRDNB
      *
      ** SDMMOD - interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDMMOD - midas-plato interface
     C                   PARM                    BGN2ST
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities decimals on nominals
     C                   PARM                    CEU018
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** MT5xx Message Generation
     C                   PARM                    S01401
      *                                                                         CSE023
      ** US Withholding tax treaty                                              CSE023
     C                   PARM                    CSE023                         CSE023
      *                                                                                       CSD006
      ** Market Data Feed                                                                     CSD006
     C                   PARM                    CSD006                                       CSD006
      *                                                                                       CAP060
      ** Midas APIs Sec Prices                                                                CAP060
     C                   PARM                    CAP060                                       CAP060
      *                                                                                       CSE031
      ** Coupon Fixing  for Floating Rate Notes                                               CSE031
     C                   PARM                    CSE031                                       CSE031
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
      *                                                                         CSE037
      ** Countervalue rounding                                                  CSE037
     C                   PARM                    CSE037                         CSE037
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
                                                                                              CGL032
      ** Taxation on Savings Income                                                           CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Security screen 1 details retrieved from file - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Security screen 2 details retrieved from file - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** Security screen 3 details retrieved from file - screen format
     C                   PARM                    CrSE3ScnFmt
      *                                                                                       CSE031
      ** Security screen 4 details retrieved from file - screen format                        CSE031
     C                   PARM                    CrSE4ScnFmt                                  CSE031
                                                                                              CAS006
      ** Security Screen 5 Details Retrieved From File - Screen Format                        CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
                                                                                              CSE071
      ** Security Screen 6 Details Retrieved From File - Screen Format                        CSE071
     C                   PARM                    CrSE6ScnFmt                                  CSE071
      *
      ** Last Coupon Date
     C                   PARM                    PLCPN
      *
      ** Next Coupon Date
     C                   PARM                    PNCD
                                                                                              CSC011
      ** Linked Maintenance Flag                                                              CSC011
                                                                                              CSC011
     C                   PARM                    PParmLink                                    CSC011

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSubs - Data Substitution Routine                        *
      *                                                               *
      *****************************************************************
      *
     C     SRDtaSubs     BEGSR
      *
      ** Substitute the data for the various parts of the transaction.
      *
     C                   IF        WSUBSE1 = 'Y'
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution character
     C                   PARM                    GHSUBS
      *
      ** Incoming data
     C                   PARM      NwSE1ScnFmt   PIncData
      *
      ** Current data
     C                   PARM      CrSE1ScnFmt   PCurData

     C                   MOVEL     PIncData      NwSE1ScnFmt
     C                   ENDIF

     C                   IF        WSUBSE2 = 'Y'
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution character
     C                   PARM                    GHSUBS
      *
      ** Incoming data
     C                   PARM      NwSE2ScnFmt   PIncData
      *
      ** Current data
     C                   PARM      CrSE2ScnFmt   PCurData

     C                   MOVEL     PIncData      NwSE2ScnFmt
     C                   ENDIF

     C                   IF        WSUBSE3 = 'Y'
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution character
     C                   PARM                    GHSUBS
      *
      ** Incoming data
     C                   PARM      NwSE3ScnFmt   PIncData
      *
      ** Current data
     C                   PARM      CrSE3ScnFmt   PCurData

     C                   MOVEL     PIncData      NwSE3ScnFmt
     C                   ENDIF

     C                   IF        WSUBSE4 = 'Y'                                              CAS006
     C                   CLEAR                   PIncData                                     CAS006
     C                   CLEAR                   PCurData                                     CAS006
                                                                                              CAS006
     C                   CALLB     'APDTASUBS'                                                CAS006
      *                             =========                                                 CAS006
      ** Return code                                                                          CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
      *                                                                                       CAS006
      ** Substitution character                                                               CAS006
     C                   PARM                    GHSUBS                                       CAS006
      *                                                                                       CAS006
      ** Incoming data                                                                        CAS006
     C                   PARM      NwSE4ScnFmt   PIncData                                     CAS006
      *                                                                                       CAS006
      ** Current data                                                                         CAS006
     C                   PARM      CrSE4ScnFmt   PCurData                                     CAS006
                                                                                              CAS006
     C                   MOVEL     PIncData      NwSE4ScnFmt                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WSUBSE5 = 'Y'                                              CAS006
     C                   CLEAR                   PIncData                                     CAS006
     C                   CLEAR                   PCurData                                     CAS006
                                                                                              CAS006
     C                   CALLB     'APDTASUBS'                                                CAS006
      *                             =========                                                 CAS006
      ** Return code                                                                          CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
      *                                                                                       CAS006
      ** Substitution character                                                               CAS006
     C                   PARM                    GHSUBS                                       CAS006
      *                                                                                       CAS006
      ** Incoming data                                                                        CAS006
     C                   PARM      NwSE5ScnFmt   PIncData                                     CAS006
      *                                                                                       CAS006
      ** Current data                                                                         CAS006
     C                   PARM      CrSE5ScnFmt   PCurData                                     CAS006
                                                                                              CAS006
     C                   MOVEL     PIncData      NwSE5ScnFmt                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
                                                                                              CSE071
     C                   IF        WSUBSE6 = 'Y'                                              CSE071
     C                   CLEAR                   PIncData                                     CSE071
     C                   CLEAR                   PCurData                                     CSE071
                                                                                              CSE071
     C                   CALLB     'APDTASUBS'                                                CSE071
      *                             =========                                                 CSE071
      ** Return code                                                                          CSE071
     C                   PARM      *BLANKS       RetCodeOut                                   CSE071
      *                                                                                       CSE071
      ** Substitution character                                                               CSE071
     C                   PARM                    GHSUBS                                       CSE071
      *                                                                                       CSE071
      ** Incoming data                                                                        CSE071
     C                   PARM      NwSE6ScnFmt   PIncData                                     CSE071
      *                                                                                       CSE071
      ** Current data                                                                         CSE071
     C                   PARM      CrSE6ScnFmt   PCurData                                     CSE071
                                                                                              CSE071
     C                   MOVEL     PIncData      NwSE6ScnFmt                                  CSE071
     C                   ENDIF                                                                CSE071
                                                                                              CSE071
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmend - Routine to check whether the fields are         *
      *               amendable                                       *
      *             - This subroutine calls a procedure which checks  *
      *               whether it is valid to amend the fields which   *
      *               have been altered.  To determine what fields    *
      *               have been changed, the current fields on file   *
      *               must be converted first to their screen formats.*
      *               These fields are then compared with the fields  *
      *               on the input transaction.  Any errors detected  *
      *               by the called procedure take precedence over    *
      *               any errors found during the validation of the   *
      *               transaction.  The errors from the called        *
      *               procedure are kept separately and if any are    *
      *               found, these errors will REPLACE the normal     *
      *               validation errors.                              *
      *                                                               *
      *****************************************************************
     C     SRValAmend    BEGSR

     C                   CALLB     'SESECS1MD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities Screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Midas-Plato Interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities Decimals on Nominals
     C                   PARM                    CEU018
      *
      ** MT5xx Message Generation
     C                   PARM                    S01401
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Securities Screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK

      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
      *                                                                                       192054
     C                   CALLB     'SESECS2MD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities Screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** Securities retrieved from file file format
     C                   PARM                    CrSEFilFmt
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Investment processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Risk Management
     C                   PARM                    BGRKMG
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Securities Screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *
      ** Protect Coupon Rate/Inds Indicator
     C                   PARM                    PPrCpn
                                                                                              CAS006
     C                   CALLB     'SESECS5MD'                                                CAS006
      *                  --------------------                                                 CAS006
                                                                                              CAS006
      ** Input Parameters                                                                     CAS006
      ** ================                                                                     CAS006
                                                                                              CAS006
      ** Return Code                                                                          CAS006
     C                   PARM                    RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Details From Incoming Transaction - File Format                           CAS006
     C                   PARM                    NwSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Securities Details Retrieved from File - File Format                                 CAS006
     C                   PARM                    CrSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Processing Type                                                                      CAS006
     C                   PARM                    PPROT                                        CAS006
                                                                                              CAS006
      ** Reset of Fields Flag                                                                 CAS006
     C                   PARM                    PResetFld                                    CAS006
                                                                                              CAS006
      ** Switchable Features:                                                                 CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CAS006
      ** Output Parameters                                                                    CAS006
      ** =================                                                                    CAS006
                                                                                              CAS006
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Error Array Index (3P0) From/To Caller                                               CAS006
     C                   PARM                    IdX                                          CAS006
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     C                   PARM                    SEESEC5                                      CAS006
                                                                                              CAS006
      ** Amend OK Flag                                                                        CAS006
     C                   PARM                    PAmendOK                                     CAS006

     C                   CALLB     'SESECS3MD'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Early Repayments? - from 1st screen
      ** New Issue - from 1st screen
      ** Issue Amount 1 - from 2nd screen
     C                   PARM                    DDERPY
     C                   PARM                    DDNISS
     C                   PARM                    DDISA1
      *
      ** Securities Screen 3 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE3ScnFmt
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Private Banking
     C                   PARM                    BGN4ST
      *
      ** SDMMOD - Interest Risk Management
     C                   PARM                    BGRKMG
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCheckWrite - Routine to control checking of error status   *
      *                 and sending of messages/writing to the        *
      *                 database                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRCheckWrite  BEGSR
      *
      ** If no errors were found:
      ** - set up additional data
      ** - write a record to the Valid Records file
      ** - use std message handler to report transaction status
      ** If any errors were found:
      ** - set up additional data
      ** - write a record to the Invalid Records file
      ** - call the message handler to pass the errors back
      ** - use std message handler to report transaction status
      ** The index to the error arrays is checked for presence/absence of
      ** errors.
      *
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date, this routine will have to cater for       |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIDx <> 0)             |
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
      ** | can probably be implemented unconditionally (i.e. the same |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
      *
     C     IDx           IFEQ      0
     C                   EXSR      SRSetValid
     C                   WRITE     SEVSECSD0
     C/COPY WNCPYSRC,SESECSCC01
      *                                                                                      LLN022A
      ** If LLN007 is ON and all data is valid then write to valid Extra                     LLN022A
      ** Data file.  Valid file fields are set up from return from extra                     LLN022A
      ** validation module.                                                                  LLN022A
      *                                                                                      LLN022A
     C     LLN007        IfEq      'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   EVAL      LVSESN = DDSESN                                           LLN022A
     C                   EVAL      LVTMST = PTimeStamp                                       LLN022A
     C                   Eval      LVAFRT = APFOTRANID                                       LLN022A
     C                   Eval      LVREPA = APRprLocn                                        LLN022A
                                                                                             LLN022A
     C                   WRITE     VSECSD0                                                   LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EXSR      SRMsgHdl
     C                   ENDIF

     C     IDx           IFGT      0
     C                   EXSR      SRSetInvalid
      *
      ** Only write to invalid file if repair in back office.
     C     APRPRLOCN     IFEQ      'B'
     C                   WRITE     SEISECSD0
     C/COPY WNCPYSRC,SESECSCC02
      *                                                                                      LLN022A
      ** If LLN007 is ON and all data is invalid then write to invalid                       LLN022A
      ** Extra Data file. Valid file fields are set up from return from                      LLN022A
      ** extra validation module.                                                            LLN022A
      *                                                                                      LLN022A
     C     LLN007        IfEq      'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   EVAL      LISESN = DDSESN                                           LLN022A
     C                   EVAL      LIGTEE = GTEE                                             LLN022A
     C                   EVAL      LIQUAL = QUAL                                             LLN022A
     C                   EVAL      LITMST = PTimeStamp                                       LLN022A
     C                   Eval      LIAFRT = APFOTRANID                                       LLN022A
     C                   Eval      LIREPA = APRprLocn                                        LLN022A
                                                                                             LLN022A
     C                   WRITE     ISECSD0                                                   LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = NwSE1ScnFmt + NwSE2ScnFmt +                     CSC011
     C**********                              NwSE3ScnFmt + PExtData                   CSC011 CAS006
     C                                        NwSE3ScnFmt + NwSE4ScnFmt +                     CAS006
     C**********                              NwSE5ScnFmt + PExtData                   CAS006 CSE071
     C                                        NwSE5ScnFmt + NwSE6ScnFmt +                     CSE071
     C**********                              PExtData                                 CSE071 CER001
     C                                        RegData + PExtData                              CER001
     C                   EVAL      APTGTTYPE = 'SESECS'                                       CSC011
     C                   EVAL      PDealNumber = DDSESN                                       CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    PHeadIn                                      CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    PTimeStamp                                   CSC011
     C                   PARM                    PDealNumber                                  CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBKEY = PDealNumber                                        CSC011
     C                   EVAL      DBASE = 14                                                 CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011

     C                   EXSR      SRMsgHdl
     C                   ENDIF

     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetValid - Routine to set up fields in the valid file      *
      *               record.                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRSetValid    BEGSR
      *
      ** Security shortname
      *
     C                   EVAL      S1SESN = DDSESN
      *
      ** Action is delete.
      ** =================
      *
     C                   IF        DDACTN = 'D'
      *
      ** Move securities details retrieved from file directly to
      ** the valid record data structure.
      *
     C**********         EVAL      NwSEFilFmt = CrSEFilFmt                                    CSE074
     C**********         EVAL      NwSEFilFmt1 = CrSEFilFmt1                          CSE074 BUG9529
      *                                                                                       CSE074
     C**********         IF        CSE065 = 'Y'                                       CSE074 BUG9529
     C**********         Z-ADD     ALDT          S1ALDT                               CSE074 BUG9529
     C**********         ELSE                                                         CSE074 BUG9529
     C**********         Z-ADD     *ZEROS        S1ALDT                               CSE074 BUG9529
     C**********         ENDIF                                                        CSE074 BUG9529
     C                   EVAL      NwSEFilFmt = CrSEFilFmt                                   BUG9529
      *                                                                                       CSE074
      *
      ** Record Id - update to 'C'.
     C                   EVAL      S1RECI = 'C'
     C                   ENDIF
      *
      ** Action is enquire.
      ** ==================
      *
     C                   IF        DDACTN = 'E'
      *
      ** Move securities details retrieved from file directly to
      ** the valid record data structure.
      *
     C**********         EVAL      NwSEFilFmt = CrSEFilFmt                                    CSE074
     C**********         EVAL      NwSEFilFmt1 = CrSEFilFmt1                          CSE074 BUG9529
      *                                                                                       CSE074
     C**********         IF        CSE065 = 'Y'                                       CSE074 BUG9529
     C**********         Z-ADD     ALDT          S1ALDT                               CSE074 BUG9529
     C**********         ELSE                                                         CSE074 BUG9529
     C**********         Z-ADD     *ZEROS        S1ALDT                               CSE074 BUG9529
     C**********         ENDIF                                                        CSE074 BUG9529
     C                   EVAL      NwSEFilFmt = CrSEFilFmt                                   BUG9529
      *                                                                                       CSE074
     C                   ENDIF
      *
      ** Action is insert.
      ** =================
      *
     C                   IF        DDACTN = 'I'
      *
      ** Record Id.
     C                   MOVEL     'D'           S1RECI
      *
      ** Original entry dates.
     C                   Z-ADD     BJRDNB        S1ORED
      *
      ** First redemption - call/put,price and market price
     C                   EVAL      S1SCPI = *BLANK
     C                   EVAL      S1SCPP = *ZEROS
     C                   EVAL      S1MKPR = *ZEROS
                                                                                              CAS006
      ** Set the S1MKPN, S1MCRK, and S1MLQP fields to zero if CAS006 is                       CAS006
      ** enabled.                                                                             CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      S1MKPN = *ZERO                                             CAS006
     C                   EVAL      S1MCRK = *ZERO                                             CAS006
     C                   EVAL      S1MLQP = *ZERO                                             CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      *
      ** If  new issue flag is not 'Y', output blank fields.
     C                   IF        DDNISS <> 'Y'
     C                   Z-ADD     *ZEROS        S1ISSD
     C                   IF        CGL031 <> 'Y'                                              232543
     C                   Z-ADD     *ZEROS        S1ISSP
     C                   ENDIF                                                                232543
     C**********         Z-ADD     *ZEROS        S1LMGR                                       CSD027
     C                   EVAL      S1LMGR = *BLANKS                                           CSD027
     C                   Z-ADD     *ZEROS        S1ISSA
     C                   Z-ADD     *ZEROS        S1TOTU
     C                   Z-ADD     *ZEROS        S1ALRQ
     C                   Z-ADD     *ZEROS        S1ALRC
     C                   Z-ADD     *ZEROS        S1UNFD
     C                   Z-ADD     *ZEROS        S1UNFR
     C                   Z-ADD     *ZEROS        S1MGFD
     C                   Z-ADD     *ZEROS        S1MGRC
     C                   MOVE      S1NMCY        S1FECY
     C                   ENDIF
      *
      ** Current factor
     C                   IF        PPROT = '8'
     C                   Z-ADD     1             S1CFCT
     C                   ELSE
     C                   Z-ADD     *ZEROS        S1CFCT
     C                   ENDIF
      *
      ** Default value of issue date to initial date if issue date
      ** was not entered.
     C                   IF        S1ISSD = *ZEROS
     C                   Z-ADD     S1ITLD        S1ISSD
     C                   ENDIF

     C                   ENDIF
      *
      ** Action is insert/amend.
      ** =======================
      *
     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A'
      *
      ** Date made complete
     C                   IF        ODDINCS = 'I'
     C                   IF        DDINCS = *BLANK OR DDINCS = 'C'
     C                   Z-ADD     BJRDNB        S1DCOM
     C                   ENDIF
     C                   ENDIF
      *
      ** Security Full name -1 defaults to Report name if blanks.
      *
     C                   IF        DDSFN1 <> *BLANKS
     C                   EVAL      S1SFN1 = DDSFN1
     C                   ELSE
     C                   EVAL      S1SFN1 = *BLANKS
     C                   EVAL      S1SFN1 = DDSRPN
     C                   ENDIF
      *
      ** Security full name - 2.
      *
     C                   EVAL      S1SFN2 = DDSFN2
      *
      ** Sector code
      *
     C                   EVAL      S1SSEC = DDSSEC
      *
      ** Rating.
      *
     C                   EVAL      S1QLTY = DDQLTY
      *
      ** Statutory Returns Code.
      *
     C                   EVAL      S1SRET = DDSRET
      *
      ** Pay currency
     C                   EVAL      S1SPYC = S1VLCY
      *
      ** If midas-plato interface is installed.
     C                   IF        BGN2ST = 'Y'
     C                   MOVE      DDICCD        S1PLICCD
     C                   MOVE      DDDINM        S1PLDINM
     C                   MOVE      DDRGCD        S1PLRGCD
     C                   MOVE      DDPGCD        S1PLPGCD
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Last change type.
      *
     C                   MOVEL     DDACTN        S1CHTP
      *
      ** Message header details.
      *
     C                   EVAL      S1FRNT = APFOTRANID
     C                   EVAL      S1REPA = APRPRLOCN
     C                   EVAL      S1TMST = PTimestamp
      *
      ** Master files will be updated.
      *
     C                   EVAL      PTranStatus = 'S'
      *
      /COPY WNCPYSRC,SESECSC018
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetInvalid - Routine to set up fields in the invalid file  *
      *                 record.                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRSetInvalid  BEGSR
      *
     C                   EVAL      DDFRNT = APFOTRANID
     C                   EVAL      DDREPA = APRPRLOCN
     C                   EVAL      DDTMST = PTimestamp
      *
      ** Transaction needs to be repaired.
      *
     C                   EVAL      PTranStatus = 'F'
      *
      /COPY WNCPYSRC,SESECSC019
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgHdl - Routine to call the message handling module       *
      *                                                               *
      *****************************************************************
      *
     C     SRMsgHdl      BEGSR
      *
      ** Set up an array of sequence numbers that correspond to the
      ** fields with errors.
      *
     C                   Z-ADD     1             W1

     C                   DO        ArrayMax

     C                   IF        FldNameArr(W1) <> *BLANKS
     C                   Z-ADD     1             W2
     C     FldNameArr(W1)LOOKUP    FieldArr(W2)                           02
     C                   EVAL      FldNoArr(W1) = FldSeqArr(W2)
     C                   ELSE
     C                   LEAVE
     C                   ENDIF

     C                   ADD       1             W1

     C                   ENDDO

     C                   MOVEL     DDSESN        PTranID

     C                   CALLB     'ZAMSGHNDLE'
      *
      ** Return code (10A, returned to this procedure)
     C                   PARM      *BLANK        ReturnCode
      *
      ** Repair location (1A, from caller)
     C                   PARM                    APRPRLOCN
      *
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCNFVALFO
      *
      ** List of messages (array of message Ids - from caller)
     C                   PARM                    MsgIDArr
      *
      ** List of field numbers (array of unsigned int. from caller)
     C                   PARM                    FldNoArr
      *
      ** List of field names (array of fields names from caller)
     C                   PARM                    FldNameArr
      *
      ** List of message data Entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      *
      ** Front office transaction identifier (20A from caller)
     C                   PARM                    APFOTRANID
      *
      ** Midas module Id (2A)
     C                   PARM                    PModuleId
      *
      ** Midas transaction Id (20A, from caller)
     C                   PARM                    PTranID
      *
      ** Message file (10A, from caller)
     C                   PARM                    #MSGFILE
      *
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      *
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    PTranStatus
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** The following three parameters are needed when messages are
      ** to be displayed on a screen
      *
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #PROCPGM
      *
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #PROCMOD
      *
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #PROCNAME
      *
      ** The MQ series queue to send replies to
     C                   PARM                    APRPYQUEUE
      *
      ** The transaction's timestamp
     C                   PARM                    PTimestamp
      *
      ** Additional message files to Check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MSGFARRAY
      *
      ** Whether or not clear the program message queue (1A)
     C                   PARM                    PClrPgmMsgQ

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
     C     SRResetFld    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIdArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx

     C                   RESET                   AMFldNamAr
     C                   RESET                   AMMsgIdArr
     C                   RESET                   AMMsgDtaAr
     C                   RESET                   AMIDx

     C                   RESET                   FldNoArr

     C                   MOVE      *ALL'Y'       SEESEC1
     C                   MOVE      *ALL'Y'       SEESEC2
     C                   MOVE      *ALL'Y'       SEESEC3

     C                   CLEAR                   CrSE1ScnFmt
     C                   CLEAR                   CrSE2ScnFmt
     C                   CLEAR                   CrSE3ScnFmt

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Message header details
     C                   PARM                    PHeadIn
      *
      ** Incoming transaction details
     C                   PARM                    PTrans5001
     C                   PARM                    PTrans5002
     C                   PARM                    PTrans5003
     C                   PARM                    PTrans5004                                   216804
     C                   PARM                    PTrans5005                                   CAS006
     C                   PARM                    PTrans5006                                   CSE071
     C                   PARM                    RegData500                                   CER001
      *
      ** Incoming transaction extra data
     C                   PARM                    PExtData500
      *
      ** Program details
     C                   PARM                    #PROCPGM
     C                   PARM                    #PROCMOD
     C                   PARM                    #PROCNAME
      *
      ** Set up the name of the module Id used to make the transaction
      ** number unique.
      *
     C                   EVAL      PModuleId = 'SE'
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages.
      *
     C                   EVAL      #MSGFILE     = 'SEUSRMSG'
     C                   EVAL      MSGFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
     C                   EVAL      MsgFArray(3) = 'WNMSGF'                      CSE023
     C/COPY WNCPYSRC,SESECSCC03
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DTAQNAME = 'APSECSDTQ'
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access midas modules details to determine if strategic
      ** risk management indicator is on.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD details.
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDAPIPD'
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU017
      ** (securities redenomination) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU017'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CEU017'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CEU017 = 'Y'
     C                   ELSE
     C                   EVAL      CEU017 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU018
      ** (decimals on nominals) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU018'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CEU018'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CEU018 = 'Y'
     C                   ELSE
     C                   EVAL      CEU018 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE007
      ** (corporate actions) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE007'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CSE007'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSE007 = 'Y'
     C                   ELSE
     C                   EVAL      CSE007 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE011
      ** (duplicate security code check) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CSE011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSE011 = 'Y'
     C                   ELSE
     C                   EVAL      CSE011 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01401
      ** (MT5xx message generation) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01401'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'S01401'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     8             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01401 = 'Y'
     C                   ELSE
     C                   EVAL      S01401 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01511
      ** (market migration) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01511'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'S01511'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     9             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01511 = 'Y'
     C                   ELSE
     C                   EVAL      S01511 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE005
      ** (effect of holidays on FRN coupon dates) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CSE005'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     10            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSE005 = 'Y'
     C                   ELSE
     C                   EVAL      CSE005 = 'N'
     C                   ENDIF
      *                                                                         CSE023
      ** Access SAR file to determine if CSE023                                 CSE023
      ** (US Withholding tax treaty) is installed.                              CSE023
      *                                                                         CSE023
     C                   CALLB     'AOSARDR0'                                   CSE023
     C                   PARM      *BLANKS       PRTCD                          CSE023
     C                   PARM      '*VERIFY'     POPTN                          CSE023
     C                   PARM      'CSE023'      PSARD                          CSE023
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE023
      *                                                                         CSE023
      ** An NRF (No Record Found) return code is valid.                         CSE023
      ** Issue database error only for error return codes.                      CSE023
      *                                                                         CSE023
     C                   IF        PRTCD <> *BLANKS AND                         CSE023
     C                             PRTCD <> '*NRF   '                           CSE023
     C                   EVAL      DBKEY = 'CSE023'                             CSE023
     C                   EVAL      DBFILE = 'SCSARDPD'                          CSE023
     C                   Z-ADD     12            DBASE                          CSE023
     C                   EXSR      *PSSR                                        CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C                   IF        PRTCD = *BLANKS                              CSE023
     C                   EVAL      CSE023 = 'Y'                                 CSE023
     C                   ELSE                                                   CSE023
     C                   EVAL      CSE023 = 'N'                                 CSE023
     C                   ENDIF                                                  CSE023
      *                                                                                       CSD006
      ** Access SAR details file to determine if MDF Switchable feature                       CSD006
      ** is switched on                                                                       CSD006
      *                                                                                       CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
     C     @RTCD         IFEQ      *BLANK                                                     CSD006
     C                   MOVEL     'Y'           CSD006            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CSD006                                       CSD006
     C                   END                                                                  CSD006
                                                                                              CSD006
      *                                                                                       CAP060
      ** Access SAR details file to determine if Midas APIs Sec Price                         CAP060
      ** is switched on                                                                       CAP060
      *                                                                                       CAP060
     C                   CALLB     'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAP060'      @SARD             6                          CAP060
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP060
     C     @RTCD         IFEQ      *BLANK                                                     CAP060
     C                   MOVEL     'Y'           CAP060            1                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     'N'           CAP060                                       CAP060
     C                   END                                                                  CAP060
      *                                                                                       CSE031
      ** Access SAR file to determine if CSE031                                               CSE031
      ** (Coupon Fixing for Floating Rate Notes) is installed.                                CSE031
      *                                                                                       CSE031
     C                   CALLB     'AOSARDR0'                                                 CSE031
     C                   PARM      *BLANKS       PRTCD                                        CSE031
     C                   PARM      '*VERIFY'     POPTN                                        CSE031
     C                   PARM      'CSE031'      PSARD                                        CSE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE031
      *                                                                                       CSE031
      ** An NRF (No Record Found) return code is valid.                                       CSE031
      ** Issue database error only for error return codes.                                    CSE031
      *                                                                                       CSE031
     C                   IF        PRTCD <> *BLANKS AND                                       CSE031
     C                             PRTCD <> '*NRF   '                                         CSE031
     C                   EVAL      DBKEY = 'CSE031'                                           CSE031
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE031
     C                   Z-ADD     13            DBASE                                        CSE031
     C                   EXSR      *PSSR                                                      CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        PRTCD = *BLANKS                                            CSE031
     C                   EVAL      CSE031 = 'Y'                                               CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      CSE031 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WkDate = BJRDNB                                            CSC011
     C                   EVAL      WkNext = BJDNWD                                            CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *Blanks       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WkDate = S1DATE                                            CSC011
     C                   EVAL      WkNext = S1NEXT                                            CSC011
     C                   ENDIF                                                                CSC011
     C                   ELSE                                                                 CSC011
     C                   IF        PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBASE  = 13                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAS006
      ** Check if CAS006 is enabled.                                                          CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        PRTCD <> '*NRF'                                            CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKEY  = 'CAS006'                                          CAS006
     C                   EVAL      DBASE  = 15                                                CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CSE037
      ** Access SAR details file to determine if Countervalue rounding                        CSE037
      ** is switched on                                                                       CSE037
      *                                                                                       CSE037
     C                   CALLB     'AOSARDR0'                                                 CSE037
     C                   PARM      *BLANKS       @RTCD                                        CSE037
     C                   PARM      '*VERIFY'     @OPTN                                        CSE037
     C                   PARM      'CSE037'      @SARD                                        CSE037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE037
     C     @RTCD         IFEQ      *BLANK                                                     CSE037
     C                   MOVEL     'Y'           CSE037                                       CSE037
     C                   ELSE                                                                 CSE037
     C                   MOVEL     'N'           CSE037                                       CSE037
     C                   ENDIF                                                                CSE037
                                                                                              CSE037
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 13                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CSE071
      ** Check if enhancement CSE071 (Multiple Holidays) is on                                CSE071
                                                                                              CSE071
     C                   CALLB     'AOSARDR0'                                                 CSE071
     C                   PARM      *BLANKS       PRTCD                                        CSE071
     C                   PARM      '*VERIFY'     POPTN                                        CSE071
     C                   PARM      'CSE071'      PSARD                                        CSE071
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE071
                                                                                              CSE071
     C                   IF        PRTCD = *BLANKS                                            CSE071
     C                   EVAL      CSE071 = 'Y'                                               CSE071
     C                   ELSE                                                                 CSE071
     C                   EVAL      CSE071 = 'N'                                               CSE071
     C                   ENDIF                                                                CSE071
                                                                                              CGL032
      ** Access SAR details file to determine if Automatic Exchange of                        CGL032
      ** Information is switched on                                                           CGL032
                                                                                              CGL032
     C                   CALLB     'AOSARDR0'                                                 CGL032
     C                   PARM      *BLANKS       PRTCD                                        CGL032
     C                   PARM      '*VERIFY'     POPTN                                        CGL032
     C                   PARM      'CGL032'      PSARD                                        CGL032
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL032
                                                                                              CGL032
      ** An NRF (No Record Found) return code is valid.                                       CGL032
      ** Issue database error only for error return codes.                                    CGL032
                                                                                              CGL032
     C                   IF        PRTCD <> *BLANKS AND                                       CGL032
     C                             PRTCD <> '*NRF   '                                         CGL032
     C                   EVAL      DBKEY = 'CGL032'                                           CGL032
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL032
     C                   Z-ADD     16            DBASE                                        CGL032
     C                   EXSR      *PSSR                                                      CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   IF        PRTCD = *BLANKS                                            CGL032
     C                   MOVEL     'Y'           CGL032                                       CGL032
     C                   ELSE                                                                 CGL032
     C                   MOVEL     'N'           CGL032                                       CGL032
     C                   END                                                                  CGL032
                                                                                              CGL031
      ** Access SAR details file to determine if Taxation of Savings                          CGL031
      ** Income is switched on                                                                CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
      ** An NRF (No Record Found) return code is valid.                                       CGL031
      ** Issue database error only for error return codes.                                    CGL031
                                                                                              CGL031
     C                   IF        PRTCD <> *BLANKS AND                                       CGL031
     C                             PRTCD <> '*NRF   '                                         CGL031
     C                   EVAL      DBKEY = 'CGL031'                                           CGL031
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL031
     C                   Z-ADD     17            DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PRTCD = *BLANKS                                            CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   END                                                                  CGL031
      *
      ** Retrieve ICD for securities trading.
     C                   CALLB     'AOSTRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDSTRDPD'
     C                   Z-ADD     11            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details to see if CSE065 is enabled.                                      CSE074
                                                                                              CSE074
     C**********         CALLB     'AOSARDR0'                                         CSE074 BUG9529
     C**********         PARM      *BLANKS       PRTCD                                CSE074 BUG9529
     C**********         PARM      '*VERIFY'     POPTN                                CSE074 BUG9529
     C**********         PARM      'CSE065'      PSARD                                CSE074 BUG9529
     C*****SCSARD        PARM      SCSARD        DSFDY                                CSE074 BUG9529
                                                                                              CSE074
     C**********         IF        PRTCD = *BLANKS                                    CSE074 BUG9529
     C**********         EVAL      CSE065 = 'Y'                                       CSE074 BUG9529
     C**********         ELSE                                                         CSE074 BUG9529
                                                                                              CSE074
     C**********         IF        PRTCD <> '*NRF'                                    CSE074 BUG9529
     C**********         EVAL      DBFILE = 'SCSARDPD'                                CSE074 BUG9529
     C**********         EVAL      DBKEY  = 'CSE065'                                  CSE074 BUG9529
     C**********         EVAL      DBASE  = 17                                        CSE074 BUG9529
     C**********         EXSR      *PSSR                                              CSE074 BUG9529
     C**********         ENDIF                                                        CSE074 BUG9529
                                                                                              CSE074
     C**********         ENDIF                                                        CSE074 BUG9529
                                                                                              CSE074
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SESECSC020
      *                                                                                      LLN022A
      ** Access SAR details file to determine if Bank of England is                          LLN022A
      ** switched on                                                                         LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
     C     @RTCD         IFEQ      *BLANK                                                    LLN022A
     C                   MOVEL     'Y'           LLN007            1                         LLN022A
     C                   ELSE                                                                LLN022A
     C                   MOVEL     'N'           LLN007                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** ULX610 - API Luxembourg - Function SESECS                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX610            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX610'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD  = *BLANKS  AND                                      CER001
     C                             BGLRIN = 'Y'                                               CER001
     C                   MOVEL     'Y'           ULX610                                       CER001
     C                   OPEN      SEVSELX2PD                                                 CER001
     C                   OPEN      SEVSELX3PD                                                 CER001
     C                   OPEN      SEISELX2PD                                                 CER001
     C                   OPEN      SEISELX5PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - NEW IBLC                                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD  = *BLANKS  AND                                      CER001
     C                             ULX610 = 'Y'                                               CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   OPEN      SEVSELX1PD                                                 CER001
     C                   OPEN      SEISELX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX008 - API Commissariat Aux Bourses                                                CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX008            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX008                                       CER001
     C                   ENDIF                                                                CER001
      *
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RtCd = *Blanks                                            CSC022
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
     C                   If        @RtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 16                                                 CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
