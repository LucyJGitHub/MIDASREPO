     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities interface controller')             *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSVU - SE Securities validate and update                 *
      *                                                               *
      *  Function: This program validates securities details for      *
      *            input into the Midas database.                     *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
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
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD044880           Date 15Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 BUG6218            Date 03Jun15               *
      *                 AR996842           Date 11Feb13               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 245170             Date 24Jan07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 05May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG9529            Date 17Nov05               *
      *                 BUG9500            Date 09Dec05               *
      *                 232543             Date 29Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 26May05               *
      *                 BUG8119            Date 20Oct05               *
      *                 BUG8880            Date 05Oct05               *
      *                 BUG7029            Date 09Jun05               *
      *                 BUG5230            Date 13Dec04               *
      *                 BUG4728            Date 05Nov04               *
      *                 CGL014             Date 20Oct03               *
      *                 TDA035             Date 02Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG1569            Date 17Oct03               *
      *                 222373             Date 23Oct03               *
      *                 CSE037             Date 03Oct03               *
      *                 CAS006             Date 03Oct03               *
      *                 CAP084  *CREATE    Date 09Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Core hooks added: SESECSJF01,SESECSDTA,SESECSJD01   *
      *                             SESECSJC01,SESECSJC04,SESECSJC05  *
      *                             SESECSJC02,SESECSJC03             *
      *  BUG6218 - Extra data must be included in the buffer          *
      *  AR996842 - Creation of new security details: Private Banking *
      *             Instrument type defaulting improvement            *
      *             (Child:AR996843)                                  *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  245170 - Set LUX details for validation.                     *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG9529 - Use full length of SEVSECSPD data structure        *
      *  BUG9500 - Ensure that the field investment type and nominal  *
      *            currency have correct value when the investment    *
      *            type record was retrieved.                         *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  BUG8119 - Fields returned incorrectly from API if update     *
      *            flag set to 'Y' but data is invalid.               *
      *  BUG8880 - Prevent Decimal Data Error due to data not being   *
      *            set up.                                            *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG5230 - To ensure information output to Buffer is a true   *
      *            picture of the update.                             *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG1569- Stopping user updating the same record at the same  *
      *           time.                                               *
      *  222373 - Parameter Mismatch                                  *
      *  CSE037 - Countervalue rounding                               *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** Valid securities by security shortname and timestamp
     FSEVSECSL1 IF   E           K DISK    RENAME(SEVSECSD0:SEVSECSCHM)

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
                                                                                              LLN022
     F/COPY WNCPYSRC,SESECSJF01                                                               LLN022
                                                                                             LLN022A
     FBYSECTY0  IF   E           K DISK    INFSR(*pssr)                                      LLN022A

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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------

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
                                                                                              CSC022
     D/COPY QWINDSRC,SESECSDTA                                                                LLN022
                                                                                              LLN022
     D/COPY WNCPYSRC,SESECSJD01                                                               LLN022
      *                                                                                      LLN022A
      ** Bank of England Details File                                                        LLN022A
      *                                                                                      LLN022A
     D SVRCD         E DS                  EXTNAME(BYSECTY1)                                 LLN022A
     D                                     PREFIX(SV)                                        LLN022A
      *                                                                                      LLN022A
      ** Securities for extension file update                                                LLN022A
      *                                                                                      LLN022A
     D ValidBoE      E DS                  EXTNAME(SEVSECSX0)                                LLN022A
      *                                                                                      LLN022A
      ** Error indicators (OK#S)                                                             LLN022A
      *                                                                                      LLN022A
     D OkFlags       E DS                  EXTNAME(SEESECSX0)                                LLN022A
      *                                                                                      LLN022A
      ** Work variable                                                                       LLN022A
      *                                                                                      LLN022A
     D WFIND           S              1A                                                     LLN022A
                                                                                             LLN022A
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022

      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
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
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     D NwSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
      *
      ** Securities screen 5 details from incoming transaction                                CAS006
      ** - screen format                                                                      CAS006
     D NwSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)                                  CAS006
      *                                                                                       CSE071
      ** Securities screen 6 details from incoming transaction                                CSE071
      ** - screen format                                                                      CSE071
     D NwSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
     D*NwSEFilFmt1             1    899                                               CSE065 BUG9529
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
      *
      ** Securities screen 4 details retrieved from file
      ** - screen format
     D CrSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
     D                                     PREFIX(O)
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
                                                                                            MD044880
     D CrExtFilFmt   E DS                  EXTNAME(SESEEXPD)                                MD044880
     D                                     PREFIX(O)                                        MD044880
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
     D*CrSEFilFmt1             1    899                                               CSE065 BUG9529
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** Securities screen 3 error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
      *
      ** Securities screen 4 error indicators
     D SEESEC4       E DS                  EXTNAME(SEESEC4PD)
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     D SEESEC5       E DS                  EXTNAME(SEESEC5PD)                                 CAS006
                                                                                              CSE071
      ** Securities Screen 6 Error Indicators                                                 CSE071
     D SEESEC6       E DS                  EXTNAME(SEESEC6PD)                                 CSE071
      *
      ** Securities extra data
     D PExtData      E DS                  EXTNAME(SESEEXPD)
                                                                                              CER001
      *                                                                                       CER001
      ** Extra data in file format (Regional)                                                 CER001
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(SESERXPD)                                  CER001
                                                                                              CER001
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

     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             01     01

      ** 24x7 Status Dataarea
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD Data Area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
     D D@USER        E DS                  EXTNAME(MUSERDD)
     D DRECI         E                     EXTFLD(RECI)
     D DLCD          E                     EXTFLD(LCD)
     D DCHTP         E                     EXTFLD(CHTP)
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
                                                                                              CER001
      *                                                                                       CER001
      ** Error indicators 1                                                                   CER001
      *                                                                                       CER001
     D OkFlags1      E DS                  EXTNAME(SEESELX2PD)                                CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Error indicators 2                                                                   CER001
      *                                                                                       CER001
     D OkFlags2      E DS                  EXTNAME(SEESELX3PD)                                CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Error indicators 3                                                                   CER001
      *                                                                                       CER001
     D OkFlags3      E DS                  EXTNAME(SEESELX1PD)                                CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Valid Extension File Record                                                          CER001
      *                                                                                       CER001
     D ValidLUX1     E DS                  EXTNAME(SEVSELX2PD)                                CER001
                                                                                              CER001
      *                                                                                       CER001
      ** New Extension in File Format (#6LXVV)                                                CER001
      *                                                                                       CER001
     D ValidLUX2     E DS                  EXTNAME(SEVSELX3PD)                                CER001
                                                                                              CER001
      *                                                                                       CER001
      ** New Extension in File Format (#LLXVV)                                                CER001
      *                                                                                       CER001
     D ValidLUX3     E DS                  EXTNAME(SEVSELX1PD)                                CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Current Extension File Record 1                                                      CER001
      *                                                                                       CER001
     D CrExFilRcd1   E DS                  EXTNAME(SESDX2PD)                                  CER001
     D                                     PREFIX(CR)                                         CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Current Extension File Record 2                                                      CER001
      *                                                                                       CER001
     D CrExFilRcd2   E DS                  EXTNAME(SESDX3PD)                                  CER001
     D                                     PREFIX(C2)                                         CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Current Extension File Record 3                                                      CER001
      *                                                                                       CER001
     D CrExFilRcd3   E DS                  EXTNAME(SESDX1PD)                                  CER001
     D                                     PREFIX(C3)                                         CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Data passed from caller program                                                      CER001
      *                                                                                       CER001
     D DATALUX         DS          1024                                                       CER001
     D  L1SESN                 1     10A                                                      CER001
     D  L1FOTR                11     30A                                                      CER001
     D  L1ISNO                31     42A                                                      CER001
                                                                                              CER001

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      * Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)

      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)

      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)

      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
     D Trans5005       S            500A                                                      CAS006
     D Trans5006       S            500A                                                      CSE071

      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
     D RegData500      S            500A                                                      CER001

      ** Overall Transaction status, to be passed to the message handler
     D PTranStatus     S              1A

      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      * Timestamp for the transaction
     D TimeStamp       S               Z
      *
      ** Parametes for data substitution program.
     D PIncData        S           2000A
     D PCurData        S           2000A
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
      *
      ** Fields to be used on call to module APCALOBJ (Allocate Object API)
     D PObject         S             10A   INZ('SESECSUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcObj         S              1A   INZ('Y')
     D PReturn         S              7A
      *
      ** Module Id to be passed to the message handler
     D PModuleId       S              2A   INZ('SE')
     D PMode           S              6A   INZ('      ')
      ** Work parameters
     D ASDC1           S              6A
     D ASDC2           S              6A
     D ASDC3           S              6A
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
     D CSE023          S              1A
     D CSE031          S              1A
     D CSC011          S              1A
     D CAS006          S              1A   INZ('N')                                           CAS006
     D CSE037          S              1A                                                      CSE037
     D ULX610          S              1A                                                      CER001
     D CSE071          S              1A                                                      CSE071
     D*CSE065***       S              1A                                              CSE065 BUG9529
     D CGL031          S              1A                                                      CGL031
     D CGL032          S              1A                                                      CGL032
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

      * Market Data Feed
     D CSD006          S              1A
      *
      * Midas APIs Sec Prices
     D CAP060          S              1A

     D TRANSDTL        S           5800A
     D PDealNumber     S             18A
     D PADealNo        S             18A
     D PParmLink       S              1A
     D WkDate          S              5  0
     D WkNext          S              5  0
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                              CGL014
     D CGL014          S              1A                                                      CGL014
                                                                                             BUG5230
      ***** Data used by SESECSR ******                                                      BUG5230
      ** Array of Fields in error.                                                           BUG5230
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG5230
                                                                                             BUG5230
      ** Array of error message IDs                                                          BUG5230
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG5230
     D                                     LIKE(#MsgID)                                      BUG5230
                                                                                             BUG5230
      ** Array of error message data.                                                        BUG5230
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG5230
     D                                     LIKE(#MsgData)                                    BUG5230
                                                                                             BUG5230
      ** Array of message files to check                                                     BUG5230
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG5230
                                                                                             BUG5230
     D WFIND1          S              1A                                                      CER001
     D WFIND2          S              1A                                                      CER001
     D WFIND3          S              1A                                                      CER001

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029

      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     NwSE1ScnFmt
     C                   MOVEL     Trans5002     NwSE2ScnFmt
     C                   MOVEL     Trans5003     NwSE3ScnFmt
     C                   MOVEL     Trans5004     NwSE4ScnFmt
     C                   MOVEL     Trans5005     NwSE5ScnFmt                                  CAS006
     C                   MOVEL     Trans5006     NwSE6ScnFmt                                  CSE071
     C                   MOVEL     RegData500    RegData                                      CER001
     C                   MOVEL     ExtData500    PExtData
     C     DDSITP        IFNE      *BLANKS                                                   BUG9500
     C     DDNMCY        ANDNE     *BLANKS                                                   BUG9500
     C                   EVAL      SITP = DDSITP                                             BUG9500
     C                   EVAL      NMCY = DDNMCY                                             BUG9500
     C                   ENDIF                                                               BUG9500

      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
      *
      ** Check if valid securities exists for midas security shortname.
      *
     C                   EXSR      SRChkValMTran

      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
     C/COPY WNCPYSRC,SESECSJC01                                                               LLN022
      *                                                                                      LLN022A
      ** If LLN012 on access BoE details                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   MOVEL     DDSESN        BYSESN                                      LLN022A
     C                   CLEAR                   SVRCD                                       LLN022A
                                                                                             LLN022A
     C     DDSESN        CHAIN     BYSECTY0                                                  LLN022A
                                                                                             LLN022A
     C                   IF        %FOUND(BYSECTY0)                                          LLN022A
     C                   EVAL      SVLSESN  = LSESN                                          LLN022A
     C                   EVAL      SVLGTEE  = LGTEE                                          LLN022A
     C                   EVAL      SVLQUAL  = LQUAL                                          LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A

      * Processing depends upon action code
     C                   SELECT

      * Processing for inserts
     C                   WHEN         DDACTN = 'I'
     C                   EXSR      SRValDetails
     C/COPY WNCPYSRC,SESECSJC04                                                               LLN022

      *                                                                                      LLN022A
      ** If LLN012 on validate BoE details.                                                  LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   CALLB     'BYSECSW0VL'                                              LLN022A
     C                   PARM                    DDACTN                         Action Code  LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    PExtData                                    LLN022A
     C                   PARM                    OKFlags                                     LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    ValidBoe                                    LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      SRValDetails
     C/COPY WNCPYSRC,SESECSJC05                                                               LLN022
      *                                                                                      LLN022A
      ** If LLN012 on validate BoE details.                                                  LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   CALLB     'BYSECSW0VL'                                              LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    PExtData                                    LLN022A
     C                   PARM                    OKFlags                                     LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    ValidBoe                                    LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EXSR      SRValAmend

     C                   WHEN      DDACTN = 'D'                                             MD044880
     C                   EXSR      SetupAmd                                                 MD044880
     C                   EVAL      PExtData = CrExtFilFmt                                   MD044880

     C                   ENDSL
      *
     C     INVALID       TAG

      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   IF        ReturnCode = *Blanks AND                                   CER001
     C                             ULX610     = 'Y'                                           CER001
     C                   EXSR      UpdLuxDB                                                   CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF
     C                   ENDIF

     C                   SETON                                        LR

      ** If action is for Update, get the correct record information                         BUG5230
      ** from file                                                                           BUG5230
     C                   IF        UpdateYN = 'Y'                                            BUG5230
     C                             AND Idx = 0                                               BUG8119
     C                   MOVE      DDSESN        DDSESN_IN                                   BUG5230
     C                   CALL      'SESECSR'                                                 BUG5230
     C                   PARM                    @AuthComp         1                         BUG5230
     C                   PARM                    @FwdBck           1                         BUG5230
     C                   PARM                    DDSESN_IN        10                         BUG5230
     C                   PARM                    Buffer                                      BUG5230
     C                   PARM                    @FldNameArr                                 BUG5230
     C                   PARM                    @MsgIDArr                                   BUG5230
     C                   PARM                    @MsgDtaArr                                  BUG5230
     C                   PARM                    @MsgFArray                                  BUG5230
     C                   PARM                    @APIRetC          1                         BUG5230
     C                   MOVEL     DDACTN        Buffer                                      BUG5230
     C                   ELSE                                                                BUG5230
      * Remerge buffer with all relevant data structures
     C                   MOVE      PSDC1         ASDC1
     C                   MOVE      PSDC2         ASDC2
     C                   MOVE      PSDC3         ASDC3
      *                                                                                      BUG6218
      ** Please ensure that when setting up the buffer, new core fields                      BUG6218
      ** are added before the data structure PExtData                                        BUG6218
      *                                                                                      BUG6218
     C                   MOVE      S1STBS        PTRBS                                      BUG8880
     C                   EVAL      Buffer = NWSe1ScnFmt + NWSe2ScnFmt
     C*****                            + NWSe3ScnFmt + NWSe4ScnFmt + PPROT                    CAS006
     C                                 + NWSe3ScnFmt + NWSe4ScnFmt                            CAS006
     C************                     + NWSe5ScnFmt + PPROT                          CAS006 BUG1569
     C************                     + NWSe5ScnFmt + @TimeStamp + PPROT             BUG1569 CSE071
     C************                     + PTRBS + PPRBS +ASDC1 + ASDC2 + ASDC3                 CSE071
     C                                 + NWSe5ScnFmt + NWSe6ScnFmt + @TimeStamp               CSE071
     C                                 + PPROT + PTRBS + PPRBS +ASDC1 + ASDC2                 CSE071
     C**********                       + ASDC3                                         CSE071 CER001
     C**********                       + ASDC3 + RegData                             CER001 MD044880
     C                                 + ASDC3                                              MD044880
     C                                 + PExtData                                            BUG6218
     C                                 + RegData                                            MD044880
     C                   ENDIF                                                               BUG5230

     C                   RETURN

      ********************************************************************
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

     C                   IF        *IN01 = '0'
      *
      ** Run delay program, then repeat chain.
     C                   CALLB     'ZACDELAY'

     C     DDSESN        CHAIN     SEVSECSL1                          01
      *
      ** Error if midas back office reference is still present.
     C                   IF        *IN01 = '0'
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
     C**********         MOVEL     CrSEFilFmt    NwSEFilFmt                                   CSE065
     C**********         MOVEL     CrSEFilFmt1   NwSEFilFmt1                          CSE065 BUG9529
      *                                                                                       CSE065
     C**********         IF        CSE065 = 'Y'                                       CSE065 BUG9529
     C**********         Z-ADD     ALDT          S1ALDT                               CSE065 BUG9529
     C**********         ELSE                                                         CSE065 BUG9529
     C**********         Z-ADD     *ZEROS        S1ALDT                               CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
     C                   MOVEL     CrSEFilFmt    NwSEFilFmt                                  BUG9529
      *                                                                                      BUG8880
      ** Get Investment type                                                                 BUG8880
      *                                                                                      BUG8880
     C                   EXSR      SRInvt                                                    BUG8880
      *
      ** Setup defaults on screen 1.
      *
     C                   EXSR      SRDefault1
      *
      ** Validate screen 1 details.
      *
     C                   EXSR      SRVScrn1
      *
      ** Setup defaults on screen 2.
      *
     C                   EXSR      SRDefault2
      *
      ** Validate screen 2 details.
      *
     C                   EXSR      SRVScrn2
      *
      ** Validate screen 4 details if CSE031 is on.
      *
     C                   IF        CSE031 = 'Y'
     C                   EXSR      SRVScrn4
     C                   ENDIF
                                                                                              CAS006
      ** Validate Screen 5 Details.                                                           CAS006
                                                                                              CAS006
     C                   EXSR      SRVScrn5                                                   CAS006
                                                                                              CAS006
      ** Validate Screen 6 Details if CSE071 is on.                                           CSE071
                                                                                              CSE071
     C                   IF        CSE071 = 'Y'                                               CSE071
     C                   EXSR      SRVScrn6                                                   CSE071
     C                   ENDIF                                                                CSE071
      *
      ** Validate screen 3 details.
      *
     C                   EXSR      SRVScrn3
      *                                                                                       CER001
      ** Validate Extension Details Screen                                                    CER001
      *                                                                                       CER001
     C                   IF        ULX610 = 'Y'                                               CER001
     C                                                                                        CER001
     C                   IF        Idx <> 0                                                   CER001
     C                   GOTO      EValDetails                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EXSR      ValidateLUX1                                               CER001
      *                                                                                       CER001
     C                   IF        Idx <> 0                                                   CER001
     C                   GOTO      EValDetails                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EXSR      ValidateLUX2                                               CER001
      *                                                                                       CER001
     C                   IF        Idx <> 0                                                   CER001
     C                   GOTO      EValDetails                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EXSR      ValidateLUX3                                               CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001

     C     EValDetails   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                 BUG8880
      *****************************************************************                      BUG8880
      *                                                               *                      BUG8880
      *  SRInvt - Setup Investement detail                            *                      BUG8880
      *                                                               *                      BUG8880
      *****************************************************************                      BUG8880
     C     SRInvt        BEGSR                                                               BUG8880
      *                                                                                      BUG8880
      ** Initialise output parameter.                                                        BUG8880
     C                   CLEAR                   PInvtp                                      BUG8880
     C**********         Z-ADD     0             PSDC1                               BUG8880 CSD027A
     C**********         Z-ADD     0             PSDC2                               BUG8880 CSD027A
     C**********         Z-ADD     0             PSDC3                               BUG8880 CSD027A
     C                   Eval      PSDC1 = *Blanks                                           CSD027A
     C                   Eval      PSDC2 = *Blanks                                           CSD027A
     C                   Eval      PSDC3 = *Blanks                                           CSD027A
     C                   Z-ADD     0             PCMGN                                       BUG8880
     C                   Z-ADD     0             PEXPC                                       BUG8880
     C                   Z-ADD     0             PDTRD                                       BUG8880
     C                   Z-ADD     0             PLCD                                        BUG8880
     C                   Z-ADD     0             PTNLU                                       BUG8880
     C                   Z-ADD     0             PDCMF                                       BUG8880
     C                   Z-ADD     0             PPRTO                                       BUG8880
      *                                                                                      BUG8880
     C                   CALL      'AOINVTR0'                                                BUG8880
     C                   PARM      *BLANKS       PRTCD                                       BUG8880
     C                   PARM      '*KEY   '     POPTN                                       BUG8880
     C                   PARM                    DDSITP                                      BUG8880
     C                   PARM                    DDNMCY                                      BUG8880
     C     PInvtp        PARM      PInvtp        DSFDY                                       BUG8880
                                                                                             BUG8880
     C                   ENDSR                                                               BUG8880
      *                                                                                      BUG8880
      *****************************************************************                      BUG8880
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
     C                   PARM      'S'           APRESPMODE
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
      *
      ** Market Data Feed
     C                   PARM                    CSD006
      *
      ** Midas APIs Sec Prices
     C                   PARM                    CAP060
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
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Coupon Fixing for Floating Rate Notes
     C                   PARM                    CSE031
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
     C                   PARM      'S'           APRESPMODE
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
     C                   PARM                    WkDate
      *
      ** SDBANK - date of next working day
     C                   PARM                    WkNext
      *
      ** SDMMOD - interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDSTRD - convertible indicator A/K
     C                   PARM                    BVCIAK
      *
      ** SDMMOD - Private banking
     C                   PARM                    BGN4ST
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
      *
      ** Coupon Fixing  for Floating Rate Notes
     C                   PARM                    CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
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
     C                   PARM      'S'           APRESPMODE
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
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** New Issue
     C                   PARM                    DDNISS
      *
      ** Action code
     C                   PARM                    DDACTN
      *                                                                                       232543
      ** Subject to European Tax                                                              232543
     C                   PARM                    DDSETX                                       232543
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
      *
      ** CSE023 - US Withholding Tax Treaty
     C                   PARM                    CSE023
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
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVScrn4  - Validate screen 4 details                        *
      *                                                               *
      *****************************************************************
     C     SRVScrn4      BEGSR

     C                   CALLB     'SESECS4VL'
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
     C                   PARM      'S'           APRESPMODE
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE4ScnFmt
      *
      ** Security screen 4 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE4ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - midas run date number
     C                   PARM                    BJRDNB
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
      ** Securities screen 4 error indicators
     C                   PARM                    SEESEC4
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen indicator
     C                   PARM      *BLANK        PReDsp
      *                                                                                       CRE073
      ** Processing Type                                                                      CRE073
      *                                                                                       CRE073
     C                   PARM                    PPROT                                        CRE073
      *
     C                   ENDSR
      *
      *****************************************************************
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
      ** SWITCHABLE FEATURES                                                                  CSE071
      ** ===================                                                                  CSE071
                                                                                              CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
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
      *
      ** US Withholding tax treaty
     C                   PARM                    CSE023
      *
      ** Market Data Feed
     C                   PARM                    CSD006
      *
      ** Midas APIs Sec Prices
     C                   PARM                    CAP060
      *
      ** Coupon Fixing  for Floating Rate Notes
     C                   PARM                    CSE031
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
      ** Automatic Exchange of Information                                                    CGL032
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
      *
      ** Security screen 4 details retrieved from file - screen format
     C                   PARM                    CrSE4ScnFmt
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

      ** Linked Maintenance Flag

     C                   PARM                    PParmLink
      *                                                                                     MD044880
      ** If LLN012 installed convert BOE fields.                                            MD044880
      *                                                                                     MD044880
     C                   IF        LLN012 = 'Y'                                             MD044880
                                                                                            MD044880
     C                   CALLB     'SESECSCVT1'                                             MD044880
     C                   PARM                    RetCodeOut                                 MD044880
     C                   PARM                    DDSESN                                     MD044880
     C                   PARM                    SVRCD                                      MD044880
     C                   PARM                    CrExtFilFmt                                MD044880
                                                                                            MD044880
     C                   ENDIF                                                              MD044880

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  ValidateLUX1 - Validate Extension Details 1                  *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     ValidateLUX1  BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      L1FOTR = S1FRNT                                            CER001
     C                   EVAL      L1SESN = DDSESN                                            CER001
     C                   EVAL      L1ISNO = DDISIN                                            245170
     C                   RESET                   Idx                                          CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS6VL2'                                               CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKFlags1                                     CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidLUX1                                    CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  ValidateLUX2 - Validate Extension Details 2                  *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     ValidateLUX2  BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      L1FOTR = S1FRNT                                            CER001
     C                   EVAL      L1SESN = DDSESN                                            CER001
     C**********         EVAL      L1ISNO = S1ISNO                                     CER001 245170
     C                   EVAL      L1ISNO = DDISIN                                            245170
     C                   RESET                   Idx                                          CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS7VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKFlags2                                     CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidLUX2                                    CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  ValidateLUX3 - Validate Extension Details 3                  *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     ValidateLUX3  BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      L1FOTR = S1FRNT                                            CER001
     C                   EVAL      L1SESN = DDSESN                                            CER001
     C                   EVAL      L1ISNO = DDISIN                                            245170
     C                   RESET                   Idx                                          CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS8VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKFlags3                                     CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidLUX3                                    CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
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
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    Trans5005
     C                   PARM                    Trans5006                                    CSE071
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26                         BUG1569
     C/COPY WNCPYSRC,SESECSJC02                                                               LLN022
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN012                                      LLN022A
      ** FSA Liquidity Report LR extract is installed.                                       LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN012            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       PRTCD                                       LLN022A
     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
     C                   PARM      'LLN012'      PSARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN012 is ON                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        PRTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN012 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'
     C                   EVAL      MsgFArray(4) = 'WNMSGF'
     C                   EVAL      MsgFArray(5) = 'SDUSRMSG'                                  CRE073

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SESECSM01
      *
      ****Add*GBBYUSRMSG*to*MsgFArray*if*BOE*installed                              LLN022A MD044880
      **********                                                                    LLN022A MD044880
     C**********         IF        LLN012 = 'Y'                                     LLN022A MD044880
     C**********         EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =         LLN022A MD044880
     C**********                   'GBBYUSRMSG'                                     LLN022A MD044880
     C**********         ENDIF                                                      LLN022A MD044880
                                                                                             LLN022A
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
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
      *
      ** Access SAR file to determine if CSE023
      ** (US Withholding tax treaty) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE023'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CSE023'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     12            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSE023 = 'Y'
     C                   ELSE
     C                   EVAL      CSE023 = 'N'
     C                   ENDIF
      *
      ** Access SAR details file to determine if MDF Switchable feature
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD006'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSD006            1
     C                   ELSE
     C                   MOVEL     'N'           CSD006
     C                   END

      *
      ** Access SAR details file to determine if Midas APIs Sec Price
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP060'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP060            1
     C                   ELSE
     C                   MOVEL     'N'           CAP060
     C                   END
      *
      ** Access SAR file to determine if CSE031
      ** (Coupon Fixing for Floating Rate Notes) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE031'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CSE031'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     13            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSE031 = 'Y'
     C                   ELSE
     C                   EVAL      CSE031 = 'N'
     C                   ENDIF
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
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CSE037
      ** Access SAR details file to determine if Countervalue rounding                        CSE037
      ** is switched on                                                                       CSE037
      *                                                                                       CSE037
     C                   CALLB     'AOSARDR0'                                                 CSE037
     C                   PARM      *BLANKS       PRTCD                                        CSE037
     C                   PARM      '*VERIFY'     POPTN                                        CSE037
     C                   PARM      'CSE037'      PSARD                                        CSE037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE037
     C     PRTCD         IFEQ      *BLANK                                                     CSE037
     C                   MOVEL     'Y'           CSE037                                       CSE037
     C                   ELSE                                                                 CSE037
     C                   MOVEL     'N'           CSE037                                       CSE037
     C                   ENDIF                                                                CSE037
                                                                                              CSE037
      ** Check if CSE071 is enabled.                                                          CSE071
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

      ** Check if CSC011 is installed

     C                   EVAL      WkDate = BJRDNB
     C                   EVAL      WkNext = BJDNWD
     C                   EVAL      CSC011 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   IF        S1SUPP = LIBR
     C                   EVAL      WkDate = S1DATE
     C                   EVAL      WkNext = S1NEXT
     C                   ENDIF
     C                   ELSE
     C                   IF        PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSC011'
     C                   EVAL      DBASE  = 13
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
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
      **********                                                                             BUG7029
      ***Retrieve*ZMUSER*details.                                                            BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029


      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,SESECS01

      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       PRTCD                                        CSC022
     C                   Parm      '*VERIFY'     POPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        PRtCd = *Blanks                                            CSC022
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
     C                   If        PRtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 14                                                 CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
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
      *                                                                                       CER001
      ** Access SAR file to determine if ULX610 is installed.                                 CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX610'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
      ** An NRF (No Record Found) return code is valid.                                       CER001
      ** Issue database error only for error return codes.                                    CER001
      *                                                                                       CER001
     C                   IF        PRTCD <> *BLANKS AND                                       CER001
     C                             PRTCD <> '*NRF   '                                         CER001
     C                   EVAL      DBKEY = 'ULX610'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   Z-ADD     15            DBASE                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX610 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX610 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *                                                                                       CSE065
      ***Check*if*CSE065*is*installed**********************************               CSE065 BUG9529
     C**********         EVAL      CSE065 = 'N'                                       CSE065 BUG9529
     C**********         CALLB     'AOSARDR0'                                         CSE065 BUG9529
     C**********         PARM      *Blanks       PRTCD                                CSE065 BUG9529
     C**********         PARM      '*VERIFY'     POPTN                                CSE065 BUG9529
     C**********         PARM      'CSE065'      PSARD                                CSE065 BUG9529
     C*****SCSARD        PARM      SCSARD        DSSDY                                CSE065 BUG9529
                                                                                              CSE065
     C**********         IF        PRTCD = *Blanks                                    CSE065 BUG9529
     C**********         EVAL      CSE065 = 'Y'                                       CSE065 BUG9529
     C**********         ELSE                                                         CSE065 BUG9529
     C**********         IF        PRTCD <> '*NRF   '                                 CSE065 BUG9529
     C******LOCK         IN        LDA                                                CSE065 BUG9529
     C**********         EVAL      DBFILE = 'SCSARDPD'                                CSE065 BUG9529
     C**********         EVAL      DBKEY  = 'CSE065'                                  CSE065 BUG9529
     C**********         EVAL      DBASE  = 15                                        CSE065 BUG9529
     C**********         OUT       LDA                                                CSE065 BUG9529
     C**********         EXSR      *PSSR                                              CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
                                                                                              CGL014
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = PSARD                                              CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL032
      ** Check if CGL032 is enabled.                                                          CGL032
                                                                                              CGL032
     C                   CALLB     'AOSARDR0'                                                 CGL032
     C                   PARM      *BLANKS       PRtCd                                        CGL032
     C                   PARM      '*VERIFY'     POptn                                        CGL032
     C                   PARM      'CGL032'      PSARD                                        CGL032
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL032
                                                                                              CGL032
     C                   EVAL      CGL032 = 'N'                                               CGL032
                                                                                              CGL032
     C                   IF        PRtCd = *BLANKS                                            CGL032
     C                   EVAL      CGL032 = 'Y'                                               CGL032
     C                   ELSE                                                                 CGL032
                                                                                              CGL032
     C                   IF        PRtCd <> '*NRF   '                                         CGL032
     C     *LOCK         IN        LDA                                                        CGL032
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL032
     C                   EVAL      DBKey = PSARD                                              CGL032
     C                   EVAL      DBase = 102                                                CGL032
     C                   OUT       LDA                                                        CGL032
     C                   EXSR      *PSSR                                                      CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied

     C                   RESET                   ReturnCode

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
     C                   PARM      'S'           APRESPMODE
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
      ** USER - default branch
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

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments.                                     *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      * For amends, put the complete (pre-existing) transaction into the valid
      * file record - fields in this will be updated during processing

     C                   EXSR      SRCvtSecD
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
     C                             OR WSubSE4 = 'Y' OR WSubSE5 = 'Y'
     C                             OR WSubSE6 = 'Y'                                           CSE071
     C                   EXSR      SRDtaSubs
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      ******************************************************************
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

      *
      ** Private Banking
      *
     C                   PARM                    BGN4ST
      *
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
      *
      ** Coupon Fixing for Floating Rate Notes
     C                   PARM                    CSE031
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
      * RESETCYCLE- Reset error information that is gradually         *
      *             updated during each run of this program           *
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

     C                   MOVE      *ALL'Y'       SEESEC1
     C                   MOVE      *ALL'Y'       SEESEC2
     C                   MOVE      *ALL'Y'       SEESEC3
     C                   MOVE      *ALL'Y'       SEESEC4

     C                   CLEAR                   CrSE1ScnFmt
     C                   CLEAR                   CrSE2ScnFmt
     C                   CLEAR                   CrSE3ScnFmt
     C                   CLEAR                   CrSE4ScnFmt

     C                   CLEAR                   NwSEFilFmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
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
     C**********         EVAL      NwSEFilFmt = CrSEFilFmt                                    CSE065
     C**********         EVAL      NwSEFilFmt1 = CrSEFilFmt1                          CSE065 BUG9529
      *                                                                                       CSE065
     C**********         IF        CSE065 = 'Y'                                       CSE065 BUG9529
     C**********         Z-ADD     ALDT          S1ALDT                               CSE065 BUG9529
     C**********         ELSE                                                         CSE065 BUG9529
     C**********         Z-ADD     *ZEROS        S1ALDT                               CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
     C                   EVAL      NwSEFilFmt = CrSEFilFmt                                   BUG9529
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
     C**********         EVAL      NwSEFilFmt = CrSEFilFmt                                    CSE065
     C**********         EVAL      NwSEFilFmt1 = CrSEFilFmt1                          CSE065 BUG9529
      *                                                                                       CSE065
     C**********         IF        CSE065 = 'Y'                                       CSE065 BUG9529
     C**********         Z-ADD     ALDT          S1ALDT                               CSE065 BUG9529
     C**********         ELSE                                                         CSE065 BUG9529
     C**********         Z-ADD     *ZEROS        S1ALDT                               CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
     C                   EVAL      NwSEFilFmt = CrSEFilFmt                                   BUG9529
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
                                                                                              232543
      ** Check first if CGL031 is not enabled.                                                232543
     C                   IF        CGL031 <> 'Y'                                              232543
     C                   Z-ADD     *ZEROS        S1ISSD
     C                   Z-ADD     *ZEROS        S1ISSP
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
     C                   ENDIF                                                                232543
                                                                                              232543
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
      ** If Treaty Tax is installed.
     C                   IF        CSE023 = 'Y'
     C                   MOVE      DDCRTT        S1CRTT
     C                   MOVE      DDINCT        S1INCT
     C                   MOVE      DDEXCD        S1EXCD
     C                   MOVE      DDOIDI        S1OIDI
     C                   MOVE      DDAPIE        S1APIE
     C                   ENDIF
      *
     C                   MOVE      DDSPDS        S1SPDS
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
      *
      ** Master files will be updated.
      *
     C                   EVAL      PTranStatus = 'S'
      *
      * Restore Timestamp from the original record                                           BUG1569
     C                   IF        DDACTN <> 'I'                                             BUG1569
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    S1TMST                                      BUG1569
     C                   ENDIF                                                               BUG1569
      *                                                                                      BUG1569
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR
      *
      * Update
     C                   RESET                   ReturnCode

      * Insert correct parameters for this UPD function
      *
     C                   CALLB     'SESECSUPD'
     C                   PARM                    ReturnCode
     C                   PARM                    NwSEFilFmt
     C                   PARM                    BVEXOP
     C                   PARM                    BJSBRC
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    PDBRN
     C                   PARM                    CSE007
     C                   PARM                    CEU017
     C                   PARM                    S01511
     C                   PARM                    CSD006            1
     C                   PARM                    CSE031
     C                   PARM                    CSE037                                       222373
     C                   PARM                    CSE071                                       CSE071
     C/COPY WNCPYSRC,SESECSJC03                                                               LLN022

      *                                                                                      LLN022A
      ** If LLN012 on update BoE details                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
     C                   CALLB     'BYSECSW0UP'                                              LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    @RTCD                                       LLN022A
     C                   PARM                    WFIND                                       LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
     C                   ENDIF                                                               LLN022A
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     ReturnCode    IFNE      *BLANK
     C     ReturnCode    ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.

     C     ReturnCode    IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)

     C                   MOVEL     'SEW3004'     MsgIdArr(1)

     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * UPDLUXDB  - Update Extention Files                            *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     UPDLUXDB      BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      WFIND1 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS2UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *Blanks       ReturnCode                                   CER001
     C                   PARM                    WFIND1                                       CER001
     C                   PARM                    ValidLUX1                                    CER001
     C                   PARM      *Blanks       CrExFilRcd1                                  CER001
      *                                                                                       CER001
     C                   EVAL      WFIND2 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS3UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *Blanks       ReturnCode                                   CER001
     C                   PARM                    WFIND2                                       CER001
     C                   PARM                    ValidLUX2                                    CER001
     C                   PARM      *Blanks       CrExFilRcd2                                  CER001
      *                                                                                       CER001
     C                   EVAL      WFIND3 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   CALLB     'SESECS4UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *Blanks       ReturnCode                                   CER001
     C                   PARM                    WFIND3                                       CER001
     C                   PARM                    ValidLUX3                                    CER001
     C                   PARM      *Blanks       CrExFilRcd3                                  CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
