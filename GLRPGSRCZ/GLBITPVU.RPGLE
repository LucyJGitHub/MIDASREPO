     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE item validate and update')                 *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLBITPVU - General Ledger JE Item validate and update        *
      *                                                               *
      *                                                               *
      *  Function: This Program Validates GL Function name      for   *
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
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD052075           Date 07Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD048370           Date 29Nov17               *
      *                 MD043023           Date 25Jul17               *
      *                 MD027817           Date 06Apr17               *
      *                 MD042436           Date 07Nov16               *
      *                 MD033964           Date 07Oct16               *
      *                 MD039859           Date 21Jul16               *
      *                 AR851481           Date 27Oct15               *
      *                 AR570314           Date 27Oct15               *
      *                 MD027587           Date 19Jun14               *
      *                 MD023635           Date 20Nov13               *
      *                 CGL135A            Date 10Jul13               *
      *                 MD000091           Date 07May13               *
      *                 AR1081387          Date 23Jan13               *
      *                 AR1092119          Date 05Mar13               *
      *                 AR1029481          Date 15Oct12               *
      *                 AR1027164          Date 16Oct12               *
      *                 AR1005162          Date 16Jul12               *
      *                 AR994585           Date 15Jul12               *
      *                 AR994584           Date 25Jun12               *
      *                 CSC054             Date 23Feb12               *
      *                 249585             Date 16May12               *
      *                 AR910409           Date 02Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26099           Date 22Sep09               *
      *                 BUG23742           Date 09May09               *
      *                 BUG28091           Date 06Sep10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG18301           Date 22Apr08               *
      *                 246418             Date 14Mar07               *
      *                 GBO021             Date 07Sep06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 238884             Date 14Jul06               *
      *                 237621             Date 11Jan06               *
      *                 240684             Date 26Jun06               *
      *                 BUG10855           Date 14Mar06               *
      *                 CER001             Date 25Apr05               *
      *                 CRE023             Date 29Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BG9185             Date 08Nov05               *
      *                 BUG6979            Date 04May05               *
      *                 CMM121             Date 29Jun04               *
      *                 BUG2948            Date 03Jun04               *
      *                 BUG1175R           Date 01Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG1175            Date 28Apr04               *
      *                 TCA102             Date 12Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CRE019             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 20Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD052075 - [CGL150] Warning message should be displayed when *
      *           the system defaults the value date.                 *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD048370 - User encounters an error "batch is already        *
      *             accepted" when amending/inserting a BITP whose    *
      *             BITH has BITP inserted via SOAP first then        *
      *             another BITP via UI.                              *
      *  MD043023 - (1) access header with Front Office Id only if    *
      *             it is non blank.                                  *
      *             (2) if Front Office Id is blank, use batch number *
      *             instead to access batch header to retrieve status *
      *             for MD042436.                                     *
      *             (3) if batch is sent through interface with Auto  *
      *             autorization set to 'Y', reject batch item if     *
      *             'Hash item no. calculated' equals 'Hash item no.  *
      *             input'.                                           *
      *           - Applied for MD-46910                              *
      *  MD027817 - Values of Additional Info and Multicash Narrative *
      *             are lost during amendment. Prevent clearing of    *
      *             the fields during edit.                           *
      *           - Applied for MD-45092                              *
      *  MD042436 - Postings can still be added to Accepted batches   *
      *             when using multi-threading which causes imbalance.*
      *  MD033964 - Batch Header must not be created automatically    *
      *             Introduced sysval to condition checking.          *
      *           - Applied for MD041905                              *
      *  MD039859 - Batch header is not updated when batch item is    *
      *             through API without batch number, but Front       *
      *             Office Id. Pattern AR1092517 done for BITH.       *
      *  AR851481 - Batch is blocked when Cancel is pressed. Created  *
      *             conditions to skip validation when input is       *
      *             cancelled. (Child: AR853231)                      *
      *           - Applied for MD036205                              *
      *  AR570314 - Dummy Headers are created. Applied part of fix    *
      *             AR573787. Skip WriteToDB sr if DDDLIT is 'U'.     *
      *           - Applied for MD036205                              *
      *  MD027587 - Unable to use the C for Copy and T for Template   *
      *             (Recompile)                                       *
      *  MD023635 - Posting date not showing in the confimation       *
      *             screen. Added hook: CGL135_081                    *
      *  CGL135A - Accounting Rules Process                           *
      *            Added hooks: CGL135_073, CGL135_074, CGL135_075,   *
      *                         CGL135_076, CGL135_077, CGL135_078    *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1081387 - Imbalance batch is accepted                      *
      *  AR1092119 - Batch Input triggered an invalid batch header and*
      *              can't be deleted                                 *
      *  AR1029481 - Add auto-authorization processing into JMS MQ    *
      *              API BITH/BITP (Child:AR1029482)                  *
      *  AR1027164 - Allow blank batch numbers if from 3rd party      *
      *              (Child: AR1027165)                               *
      *  AR1005162 - Base ccy exchange rate in corrective batch has   *
      *              incorrect number of decimal places               *
      *  AR994585 - Batch item is still shown in the corrective batch *
      *             details even after Cancel                         *
      *  AR994584 - Base currency exchange rate and indicator are     *
      *             getting blanked-out after clicking WRITE button   *
      *  CSC054 - Period End Adjustments                              *
      *  249585 - Front office id of batch entered via APIs gets      *
      *           overriden when amended in Midas Plus screens        *
      *           Applied for AR971392 (Child: AR971393)              *
      *  AR910409 - Mapping error caused by adding fields in CSF011   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT075 Mapping error in Journal Entry                *
      *  BUG26099 - A serious Midas error has occurred when inserting *
      *             a new Batch Item (Recompile)                      *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  BUG28091 - Error "The batch is in used by another operator.  *
      *             It was last used by operator..." appeared upon    *
      *             input of a second batch item.                     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG18301 - System not allowing to pass journal entry(balance *
      *             increase) on retail account used as collateral    *
      *             (Recompile)                                       *
      *  246418 - CGL013 changes for midas plus                       *
      *  GBO021 - OUTPUT tag :86: - Information to Account Owners     *
      *         - Core hook added: GLBITPXC07.                        *
      *  238884 - Authorisation of Overrides (Recompile)              *
      *  240684 - Applied fix 237621.                                 *
      *  237621 - Upgrade CGL037 Journal Entry only.                  *
      *  BUG10855- No record found in MEMOS upon entry of batch item  *
      *            produce "A Serious Midas Error".(Recompile)        *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CRE023 - 2 O'clock Flag Upgrade to MidasPlus                 *
      *  CSC024 - Open Month End                                      *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CMM121 - Core changes for GBO021                             *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:GLBITPXD01,                        *
      *                            GLBITPXC03,GLBITPXC04,GLBITPXC05,  *
      *                            GLBITPXC06                         *
      *           Core hooks amended:GLBITP02                         *
      *         - OUTPUT tag :86: - Information to Account Owners     *
      *  BUG2948 - Different branch code item accepted even if        *
      *           multiple branch indicator is set to 'N'. (recompile)*
      *  BUG1175R-User ID is now setup in workstation ID by java      *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG1175- If setting batch to in use also set up user & tmst  *
      *  TCA102 - Various errors on Journal Entry input.              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ** Today's batch numbers used
     FGLBTNOL0  UF   E           K DISK    INFSR(*PSSR)
      *
      ** JE Headers file by Front Office ID
     FGLJENHL3  IF   E           K DISK    INFSR(*PSSR)
      *                                                                                       249585
      ** JE Items file by batch / item                                                        249585
     FGLJENPL1  IF   E           K DISK    INFSR(*PSSR)                                       249585
      *
      ** JE Headers file by Front Office ID
     FGLJENHL0  UF   E           K DISK    INFSR(*PSSR)
      ** JE Headers file by batch number                                                   AR1029481
     FGLJENHL1  IF   E           K DISK    INFSR(*PSSR)                                    AR1029481
      ** JE summary by batch number                                                        AR1081387
     FGLJENSL1  IF   E           K DISK    INFSR(*PSSR)                                    AR1081387
     F/COPY WNCPYSRC,GLH00742
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
      **    True       logical = *on (for indicator processing)
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
      ** The following /COPY line includes definitions for the above fields
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
      ** User                                                                                BUG1175
     D LUser           S             10A                                                     BUG1175
     D TIMEtime        S               T                                                     BUG1175
     D TIMEchar        S             10A                                                     BUG1175
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Message Header (DS)
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** Incoming Transaction (DS)
     D PTranIn       E DS                  EXTNAME(GLBITPPD)
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** JE Items Error Indicators (DS)
     D PFlagsOK      E DS                  EXTNAME(GLEBITPPD)
     D  WIndOK                 1     20    DIM(20) INZ('Y')
      *                                                                                       246418
      ** Valid JE Item Additional Information (DS) - for file update                          246418
     D PVBITPX       E DS                  EXTNAME(GLVBIPXPD)                                 246418
      *
      ** JE Items Extra Data (DS)
     D PExtData      E DS                  EXTNAME(GLBPEXPD)
      *
      ** GL Accounts Extra Data                                                               CER001
     D RegData       E DS                  EXTNAME(GLBPRXPD)                                  CER001
      *                                                                                       CER001
      ** JE Additional Info Data for CGL013                                                   246418
     D PAddInfo      E DS                  EXTNAME(GLBITPXPD)                                 246418
      *                                                                                       246418
      ** Additional Naratives                                                               BUG23742
     D GLMNAR          DS                                                                   BUG23742
     D  PAddNarr1              1    500                                                     BUG23742
     D  PAddNarr2            501    770                                                     BUG23742
      *                                                                                     BUG23742
      ** Period End Adjustments Fields                                                        CSC054
     D*PEADetail       S             13A                                            CSC054 AR1005162
     D PEADetail       S             15A                                                   AR1005162
      *                                                                                       CSC054
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACCD2      E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Externally described DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for Retail ICD Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACCD3      E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
     D SVRCD         E DS                  EXTNAME(GLJPX1PD)                                  CER001
     D ValidFilExtL  E DS                  EXTNAME(GLVBPLX1PD)                                CER001
     D OkFlagsExtL   E DS                  EXTNAME(GLEBPLX1PD)                                CER001
     D PVBITH        E DS                  EXTNAME(GLJENHPD)                               AR1029481
     D/COPY WNCPYSRC,GLH00659
      *                                                                                       CER001
     D PDATA           DS          1024                                                       CER001
     D  #1CUST                 1      6                                                       CER001
     D  #1CYCD                 7      9                                                       CER001
     D  #1BTNB                10     12                                                       CER001
     D  #1BINB                13     15  0                                                    CER001
     D  #1DCIN                16     16                                                       CER001
     D  #DFMPA                17     30                                                       CER001
     D  #1FOTR                31     50                                                       CER001
     D  #1TMST                51     76Z                                                      CER001
      *                                                                                       CER001
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSF011
     D AccKeyDs        DS                                                                     CSF011
     D PKACID                        10                                                       CSF011
     D PKCUST                         6                                                       CSF011
     D PKCYCD                         3                                                       CSF011
     D PKACCD                        10                                                       CSF011
     D PKACSN                         2                                                       CSF011
     D PKBRCD                         3                                                       CSF011
     D PKNONB                         2                                                       CSF011
     D PKUCSN                        10                                                       CSF011
     D PKPNOI                         1                                                       CSF011
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
     D                                     PREFIX(NO_)                                        CSF011
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D/COPY OFCPYSRCZ,CGL135_073                                                             CGL135A
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIdx            S              3P 0
      *
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
      *
     D W1              S              3P 0
     D W2              S              3P 0
      *
      ** Field (500A) to receive the incoming transaction
     D PTrans500       S            500A
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
      *                                                                                       CER001
      ** Field (500A) to receive the incoming Extra Data                                      CER001
     D RegData500      S            500A                                                      CER001
      *                                                                                       246418
      ** Field (500A) to receive the incoming Extra Data                                      246418
     D PAddInfo500     S            500A                                                      246418
      *                                                                                     BUG23742
      ** Field (500A) to receive the Additional Inf Data - 1                                BUG23742
      *                                                                                     BUG23742
     D PAddInf1500     S            500A                                                    BUG23742
      *                                                                                     BUG23742
      ** Field (500A) to receive the Additional Inf Data - 2                                BUG23742
      *                                                                                     BUG23742
     D PAddInf2500     S            500A                                                    BUG23742
      *
      ** Module ID, to be passed to the Message Handler
     D PModuleID       S              2A
      *
      ** Action code defaults to 'I' for insert
     D PAction         S              1A   INZ('I')
      *
      ** Timestamp for the transaction
     D PTimeStamp      S               Z
                                                                                              CSC022
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014

      ** Timestamp field                                                                     BUG1175
     D WSysTmSt        S             26Z                                                     BUG1175
      ** Java user information                                                               BUG1175
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                    BUG1175
      *
     D SGDNOSTRO       S              1                                         CMM121
     D SBRNM           S             35                                         CMM121
     D SBREF           S             35                                         CMM121
                                                                                              CER001
      ** Parameters on call to GLBPLX2UP                                                      CER001
     D PFIND           S              1                                                       CER001
                                                                                              CER001
      ** Switchable Feature ULX043                                                            CER001
     D ULX043          S              1A   INZ('N')                                           CER001
                                                                                              CER001
      *                                                                                       CRE023
      ** Variable used by CRE023                                                              CRE023
      *                                                                                       CRE023
     D CRE023          S              1                                                       CRE023
      *                                                                                       CRE023
      ** Switchable feature CGL013                                                            246418
     D CGL013          S              1                                                       246418
      *                                                                                       246418
     D DDADIN          S              1                                                       246418
     D DDINBI          S              1                                                     BUG28091
      *                                                                                       246418
     D WADIN           S              1                                                     BUG23742
     D CER030          S              1A                                                    BUG23742
     D P@TYP           S             10                                                       CSF011
     D P0RETL          S             10                                                       CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D P@Str           S             35                                                       CSF011
     D JERRMSG         S              7                                                    AR1029481
      *                                                                                     BUG23742
     D WBTNB           S                   LIKE(BTBTNB)                                       249585
     D WBINB           S                   LIKE(BTBINB)                                       249585
      *                                                                                       249585
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     D/COPY WNCPYSRC,GLBITPXD01
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
      * If the user is connected via a browser, the job user name is QUSER -                 BUG6979
      * their user name is stored in ZMUSER                                                  BUG6979
     C                   IN        ZMUSER                                                    BUG6979
     C     USRID         IFNE      *BLANKS                                                  MD048370
     C     USRID         ANDNE     PSUser                                                   MD048370
     C                   MOVE      'Y'           JAVAUSER          1                        MD048370
     C                   ELSE                                                               MD048370
     C                   MOVE      'N'           JAVAUSER                                   MD048370
     C                   ENDIF                                                              MD048370
      *
      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.
      *
     C                   MOVEL     PTrans500     PTranIn
     C/COPY WNCPYSRC,GLBITPXC05
     C**********         EVAL      DDADIN = %SUBST(PTrans500:240:1)                  246418 AR910409
     C                   EVAL      DDADIN = %SUBST(PTrans500:300:1)                         AR910409
     C                   EVAL      WADIN = DDADIN                                           BUG23742
     C**********         EVAL      DDINBI = %SUBST(PTrans500:241:1)                BUG28091 AR910409
     C                   EVAL      DDINBI = %SUBST(PTrans500:301:1)                         AR910409
     C                   EVAL      PAddInfo = PAddInfo500                                     246418
     C/COPY OFCPYSRCZ,CGL135_074                                                             CGL135A
     C                   MOVEL     PExtdata500   PExtdata
     C                   EVAL      RegData = RegData500                                       CER001
      *                                                                                     BUG23742
     C                   MOVEL     PAddInf1500   PAddNarr1                                  BUG23742
     C                   MOVEL     PAddInf2500   PAddNarr2                                  BUG23742
      *
      ** Generate a timestamp for this transaction.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetFld
      *                                                                                       246418
      ** If Additional Information Indicator is 'N' then clear Additional Info Fields         246418
      *                                                                                       246418
     C                   IF        CGL013 = 'Y'                                               246418
      *                                                                                       246418
     C                   IF        DDADIN = 'N'                                               246418
     C                   IF        DDACTN = 'A' and PAddInfo <> *BLANKS                     MD027817
     C                   EVAL      DDADIN = 'Y'                                             MD027817
     C                   ELSE                                                               MD027817
     C                   CLEAR                   PAddInfo                                     246418
     C                   ENDIF                                                              MD027817
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C                   IF        DDADIN = 'Y' and PAddInfo = *blanks                        246418
     C                   EVAL      DDADIN = 'N'                                               246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C                   ENDIF                                                                246418
      *                                                                                     BUG23742
     C                   IF        CER030 = 'Y'                                             BUG23742
      *                                                                                     BUG23742
     C                   IF        WADIN = 'N'                                              BUG23742
     C                   IF        DDACTN = 'A' AND GLMNAR <> *BLANKS                       MD027817
     C                   EVAL      WADIN = 'Y'                                              MD027817
     C                   ELSE                                                               MD027817
     C                   CLEAR                   GLMNAR                                     BUG23742
     C                   ENDIF                                                              MD027817
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   IF        WADIN = 'Y' AND                                          BUG23742
     C                             GLMNAR = *BLANKS                                         BUG23742
     C                   EVAL      WADIN = 'N'                                              BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   IF        WADIN = 'Y'                                              BUG23742
     C                   EVAL      DDADIN = 'Y'                                             BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                    AR1092119
      ** Do not allow blank batch number with no corresponding front office                AR1092119
      ** ID in JE Headers file for transactions coming from 3rd party                      AR1092119
      *                                                                                    AR1092119
      ** Access header with Front Office Id if non blank only                               MD043023
     C                   MOVEL     'N'           HeaderFound       1                        MD043023
     C     APFOTRANID    IFNE      *BLANKS                                                  MD043023
     C     APFOTRANID    CHAIN     GLJENHL3                           31                   AR1092119
     C     *IN31         IFEQ      *ON                                                     AR1092119
     C     DDBTNB        ANDEQ     *BLANKS                                                 AR1092119
     C     DDBTNB        OREQ      *ZEROS                                                  AR1092119
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                             AR1092119
     C                   MOVEL     '5016871'     MsgIdArr(1)                               AR1092119
     C                   ELSE                                                              AR1092119
      *                                                                                       249585
     C     *IN31         IFEQ      *OFF                                                     MD043023
     C                   EVAL      HeaderFound = 'Y'                                        MD043023
     C                   ENDIF                                                              MD043023
      ** Retrieve original batch item details                                                 249585
      *                                                                                       249585
     C                   EVAL      WBTNB = DDBTNB                                             249585
     C**********         MOVE      DDBTNB        WBINB                               249585 MD042436
     C                   MOVE      DDBINB        WBINB                                      MD042436
     C     KBITP         CHAIN     GLJENPL1                           01                      249585
     C                   IF        %FOUND(GLJENPL1)                                           249585
     C                   EVAL      B2FRNT = BTFRNT                                            249585
     C                   EVAL      B2AFRT = BTAFRT                                            249585
     C                   ENDIF                                                                249585
     C                   ENDIF                                                             AR1092119
     C                   ENDIF                                                              MD043023
      *                                                                                     MD043023
      ** If Front Office Id is blank or Front Office Id is not blank and it was not found   MD043023
     C     APFOTRANID    IFEQ      *BLANKS                                                  MD043023
     C     APFOTRANID    ORNE      *BLANKS                                                  MD043023
     C     *IN31         ANDEQ     *ON                                                      MD043023
      ** use batch number to access header                                                  MD043023
     C     DDBTNB        CHAIN(N)  GLJENHL0                           22                    MD043023
     C     *IN22         IFEQ      *OFF                                                     MD043023
     C                   EVAL      HeaderFound = 'Y'                                        MD043023
     C                   ENDIF                                                              MD043023
     C                   ENDIF                                                              MD043023
      *                                                                                     MD042436
      ** Only process is batch status is not authorised                                     MD042436
      *                                                                                     MD042436
     C*****BRBTSF        IFNE      'A'                                             MD042436 MD043023
      ** Do not process if header was found and batch is already accepted                   MD043023
     C     HeaderFound   IFEQ      'Y'                                                      MD043023
     C     BRBTSF        ANDEQ     'A'                                                      MD043023
      ** or if header was found and batch is auto authorize and item no. calculated is      MD043023
      ** greater or equal to item no. input                                                 MD043023
     C     HeaderFound   OREQ      'Y'                                                      MD043023
     C     BRAUTH        ANDEQ     'Y'                                                      MD043023
     C     BRHINC        ANDGE     BRHINI                                                   MD043023
     C     JAVAUSER      ANDEQ     'N'                                                      MD048370
                                                                                            MD043023
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                              MD043023
     C                   MOVEL     'GLX1005'     MsgIDArr(1)                                MD043023
     C                   MOVE      'E'           DDDLIT                                     MD043023
     C                   Z-ADD     1             Idx                                        MD043023
     C                   ELSE                                                               MD043023
      *
      ** Process transaction.
      ** Check to see whether the header is in use
      ** and take appropriate actions
      *
     C     DDDLIT        IFNE      'U'
     C     DDDLIT        ANDNE     'L'
     C     DDDLIT        OREQ      'R'
     C                   EXSR      SRValdTran
     C/COPY WNCPYSRC,GLH00768
     C                   ELSE
      *
     C     DDBTNB        CHAIN     GLJENHL0                           22
     C     *IN22         IFEQ      *OFF
     C     DDDLIT        IFEQ      'L'
     C     UpdateYN      ANDEQ     'Y'
     C     BRBIUF        ANDEQ     'Y'
     C     DDINBI        OREQ      'Y'                                                      BUG28091
     C     DDDLIT        ANDNE     'U'                                                      AR851481
     C                   UNLOCK    GLJENHL0
     C                   EXSR      SRValdTran
     C                   ELSE
     C     BRBIUF        IFEQ      'Y'
      ** User has pressed cancel after having the batch set to in use
     C     DDDLIT        IFEQ      'U'
     C                   MOVE      *BLANKS       BRBIUF
     C                   Eval      BRWSID = *blanks                                         BUG1175R
     C                   UPDATE    @BRREAG
     C                   ELSE
      * Send a error message that the batch is in use
     C*****BRUSRA        IFEQ      *BLANKS                                          BUG1175 BUG1175R
     C**********         Eval      LUser = BRUSRI                                   BUG1175 BUG1175R
     C**********         ELSE                                                       BUG1175 BUG1175R
     C**********         Eval      LUser = BRUSRA                                   BUG1175 BUG1175R
     C**********         ENDIF                                                      BUG1175 BUG1175R
     C                   Eval      LUser = BRWSID                                           BUG1175R
      *                                                                                      BUG1175
     C                   MOVEL     'DDBTNB'      FldNameArr(1)
     C**********         MOVEL     'GLX0041'     MsgIDArr(1)                                 BUG1175
     C                   MOVEL     'GLX0422'     MsgIDArr(1)                                 BUG1175
     C                   Eval      TIMEtime = %time(BRTMST)                                  BUG1175
     C                   MOVE      TIMEtime      TIMEchar                                    BUG1175
     C**********         Eval      MsgDtaArr(1) = LUser + ' @ ' + TIMEchar          BUG1175 MD000091
     C                   EVAL      MsgDtaTmp = LUser + ' @ ' + TIMEchar                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
     C                   MOVE      'E'           DDDLIT
     C                   Z-ADD     1             Idx
     C                   ENDIF
      *                                                                                       CER001
      ** Populate Customer Name on Inputs fields                                              CSF011
      *                                                                                       CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
     C                   EVAL                    Buffer = PTranIn
     C                                           + SGDNOSTRO + SBRNM            CMM121
     C                                           + SBREF                        CMM121
     C**********                                 + DDADIN + PAddInfo                 246418 BUG28091
     C**********                                 + GLMNAR                            BUG23742 CER059
     C                                           + DDADIN + DDINBI                          BUG28091
     C                                           + PaddInfo                                 BUG28091
     C                                           + GLMNAR                                     CER059
     C                                           + PEADetail                                  CSC054
      /COPY OFCPYSRCZ,CGL135_080                                                             CGL135A
     C                                           + VDFLTF                                   MD052075
     C                                           + RegData                                    CER001
     C                                           + PExtData
      *                                                                                       CER001
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ELSE
      *                                                                                      BUG1175
     C                   CALLB     'ZAGENTMSTM'                                              BUG1175
     C                   PARM                    WSysTmSt                                    BUG1175
      *                                                                                      BUG1175
     C                   Eval      BRTMST = WsysTmSt                                         BUG1175
     C**********         Eval      BRUSRA = USRID                                   BUG1175 BUG1175R
     C                   Eval      BRWSID = USRID                                           BUG1175R
     C                   MOVE      'Y'           BRBIUF
     C                   UPDATE    @BRREAG
     C                   EXSR      SRValdTran
     C     Idx           IFNE      0
     C     WIdx          ORNE      0
     C                   MOVE      'R'           DDDLIT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD042436
      ** Else error since batch status already authorised                                   MD042436
      *                                                                                     MD042436
     C**********         ELSE                                                      MD042436 MD043023
     C**********         MOVEL     'DDBTNB'      FldNameArr(1)                     MD042436 MD043023
     C**********         MOVEL     'GLX1005'     MsgIDArr(1)                       MD042436 MD043023
     C**********         MOVE      'E'           DDDLIT                            MD042436 MD043023
     C**********         Z-ADD     1             Idx                               MD042436 MD043023
     C                   ENDIF                                                              MD042436
      *
      ** If errors exist, set Valid Indicator to 'N'; otherwise, set
      ** Valid Indicator to 'Y' and Transaction Status to S (Success).
      *
     C     Idx           IFGT      *ZERO
     C                   EVAL      B2VALI = 'N'
     C                   ELSE
      ** Take into account whether item is to be deleted
     C     B2VALI        IFNE      '*'
     C                   EVAL      B2VALI = 'Y'
     C                   ENDIF
     C                   ENDIF
                                                                                            AR994585
      ** Do not write when User has pressed Cancel                                          AR994585
                                                                                            AR994585
     C*****CGL125        IFEQ      'Y'                                             AR994585 MD039859
     C     CAP209        IFEQ      'Y'                                                      MD039859
     C     DDDLIT        ANDEQ     'U'                                                      AR994585
     C     UpdateYN      ANDEQ     'Y'                                                      AR994585
     C                   Z-ADD     1             Idx                                        AR994585
     C                   ENDIF                                                              AR994585

      ** Populate Customer Name on Inputs fields                                              CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     DDDLIT        ANDNE     'U'                                                      AR570314
     C                   EXSR      WriteToDB
     C                   ENDIF

     C                   SETON                                        LR

     C                   EVAL                    Buffer = PTranIn
     C                                           + SGDNOSTRO + SBRNM            CMM121
     C                                           + SBREF                        CMM121
     C**********                                 + DDADIN + PAddInfo                 246418 BUG28091
     C**********                                 + GLMNAR                            BUG23742 CER059
     C                                           + DDADIN + DDINBI                          BUG28091
     C                                           + PaddInfo                                 BUG28091
     C                                           + GLMNAR                                     CER059
     C                                           + PEADetail                                AR994584
      /COPY OFCPYSRCZ,CGL135_081                                                            MD023635
     C                                           + VDFLTF                                   MD052075
     C                                           + RegData                                    CER001
     C                                           + PExtData
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
      *
     C     SRResetFld    BEGSR
      *
     C                   CLEAR                   PVBITP
     C                   CLEAR                   DDATSN                                      CSF011A
     C                   CLEAR                   DDATNM                                      CSF011A
     C                   CLEAR                   DDATRT                                      CSF011A
     C                   CLEAR                   DDATAN                                      CSF011A
      *
      ** Numeric fields within PVBITP have to be reset explicitly as
      ** there are long alpha fileds overlapping these which cause the
      ** CLEAR to put blanks in the numeric fields.
      *
     C                   Z-ADD     *ZERO         B2BINB
     C                   Z-ADD     *ZERO         B2RACN
     C                   Z-ADD     *ZERO         B2PTAM
     C                   Z-ADD     BJRDNB        B2PTDT
     C                   Z-ADD     *ZERO         B2VLDT
     C                   Z-ADD     *ZERO         B2RRNM
     C                   Z-ADD     *ZERO         B2SPFC
     C                   Z-ADD     *ZERO         B2NITM
     C                   Z-ADD     *ZERO         B2OAMT
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
      *
     C                   RESET                   FldNoArr
      *
     C                   RESET                   PFlagsOK
     C/COPY WNCPYSRC,GLH00660
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValdTran - Routine to validate the main transaction        *
      *               details                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRValdTran    BEGSR
      *
     C                   CALLB     'GLBITPVAL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Response Mode
     C                   PARM      'S'           APRespMode
      *
      ** Associated Front Office Id
     C                   PARM                    APFOAsocId
      *
      ** Incoming Transaction (DS)
     C                   PARM                    PTranIn
                                                                                              246418
      ** JE Items Additional Info                                                             246418
     C                   PARM                    PAddInfo                                     246418
      *                                                                                     BUG23742
      ** Multicash Narratives                                                               BUG23742
      *                                                                                     BUG23742
     C                   PARM                    GLMNAR                                     BUG23742
      *
      ** JE Items Extra Data (DS)
     C                   PARM                    PExtData
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Profit Centres Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Management Accounts
     C                   PARM                    BGNVST
      *
      ** SDRETL - No. of Days Forward Value
     C                   PARM                    BMNDFV
      *
      ** TABTBRE - Charge for Multiple Transactions
     C                   PARM                    PCMTR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013
      *
      ** Block GL Accounts feature
     C                   PARM                    CGL002
      *
      ** Security on Journal Entry feature
     C                   PARM                    CGL008
      *                                                                                       CRE019
      ** Cheque book processing feature                                                       CRE019
     C                   PARM                    CRE019                                       CRE019
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              237621
      ** Account Access Security                                                              237621
     C                   PARM                    CGL037            1                          237621
                                                                                              246418
      ** MT94x Messages Generation                                                            246418
     C                   PARM                    CGL013                                       246418
      *                                                                                     BUG23742
      ** CER030 feature                                                                     BUG23742
      *                                                                                     BUG23742
     C                   PARM                    CER030                                     BUG23742
      *
      ** OUTPUT
      ** ======
      *
      ** JE Items Error Indicators (DS)
     C                   PARM                    PFlagsOK
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/msg data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
     C/COPY WNCPYSRC,GLBITPXC04
     C                   PARM                    CRE023                                       CRE023
      ** Valid JE Item (DS) - for file update                                                 246418
     C                   PARM                    PVBITPX                                      246418
     C/COPY OFCPYSRCZ,CGL135_075                                                             CGL135A
      ** CGL150 Default Value Date 'Y'                                                      MD052075
     C                   PARM                    VDFLTF                                     MD052075
      *                                                                                       CER001
      ** If switchable feature is on,                                                         CER001
      **    Validate Batch Item Extension Details                                             CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   EXSR      SRValdExt                                                  CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,GLH00661
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR

     C     Idx           IFEQ      0
     C                   EXSR      SRSetOFld
     C                   EXSR      UpdateDB
     C                   EXSR      SrAutoAuth                                              AR1029481
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetOFld - Set up additional fields that are needed on the  *
      *              file record                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRSetOFld     BEGSR
      *
      ** Update record with Message Header data.
      *
     C                   IF        B2FRNT = *BLANKS                                           249585
     C                   EVAL      B2FRNT = 'APCTRANVU'
      *                                                                                       CSC054
      ** Front office only updated from 3rd party                                             CSC054
      *                                                                                       CSC054
     C**********         IF        CGL125 = 'Y'                                      CSC054 MD039859
     C                   IF        CAP209 = 'Y'                                             MD039859
     C                   EVAL      B2FRNT = APFOTranID                                        CSC054
     C                   ENDIF                                                                CSC054
     C                   EVAL      B2AFRT = APFOAsocID
     C                   ENDIF                                                                249585
     C                   EVAL      B2TMST = PTimeStamp
      *
      ** If current batch has dumped already, set to allow to dump again
      *
     C/COPY WNCPYSRC,GLH00749
     C     B2BTNB        CHAIN     GLBTNOL0                           21
      *
     C                   IF        *IN21 = *OFF AND B3DUMP = 'Y'
      *
     C                   MOVE      ' '           B3DUMP
     C                   UPDATE    GLBTNOD0
     C                   ELSE                                                               MD042436
     C                   UNLOCK    GLBTNOL0                                                 MD042436
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00750
      *
      ** Set up Front Office correctly for Java users
      *
      ** Front office only updated from 3rd party                                             CSC054
      *                                                                                       CSC054
     C**********         IF        CGL125 = 'N'                                      CSC054 MD039859
     C                   IF        CAP209 = 'N'                                             MD039859
      *                                                                                       CSC054
     C                   IF        B2FRNT = 'APCTRANVU'                                       249585
     C                   MOVE      *BLANKS       FRNTID            9
     C                   MOVEL     B2FRNT        FRNTID
     C     FRNTID        CAT       DDBTNB        B2FRNT
     C                   ENDIF                                                                249585
      *
      ** Checking JE Headers master file to see if already exists
      *
     C     B2FRNT        CHAIN     GLJENHL3                           20
      *                                                                                       CSC054
     C                   ENDIF                                                                CSC054
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR
      *
      ** Update JE Items file.
      *
     C                   CALLB     'GLBITPUPD'
      *                             =========
      ** Return code
     C                   PARM      *BLANK        PRTCD             7
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Security on Journal Entry
     C                   PARM                    CGL008
      *                                                                                       TCA102
      ** Cheque book processing feature                                                       TCA102
     C                   PARM                    CRE019                                       TCA102
      *                                                                                       246418
      ** Cheque book processing feature                                                       246418
     C                   PARM                    CGL013                                       246418
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
                                                                                              246418
      ** Valid JE Item Additional Information (DS) - for file update                          246418
     C                   PARM                    PVBITPX                                      246418
      *                                                                                     BUG23742
      ** Multicash Narratives                                                               BUG23742
      *                                                                                     BUG23742
     C                   PARM                    GLMNAR                                     BUG23742
                                                                                              CSC024
      ** Action Code for OME system                                                           CSC024
     C                   PARM                    DDACTN                                       CSC024
     C/COPY WNCPYSRC,GLBITPXC07
     C/COPY OFCPYSRCZ,CGL135_076                                                             CGL135A
                                                                                              CSC024
      *                                                                                       CER001
      ** If no error updating the main batch item details and                                 CER001
      ** if switchable feature is on,                                                         CER001
      **    Update Batch Item Extension Details                                               CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                             AND ULX043 = 'Y'                                           CER001
     C                   EXSR      SRUpdtExt                                                  CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   IF        PRTCD = 'NOHEADR'                                        MD033964
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                              MD033964
     C                   MOVEL     'GLX1004'     MsgIdArr(1)                                MD033964
     C                   MOVE      'E'           DDDLIT                                     MD033964
     C                   Z-ADD     1             Idx                                        MD033964
     C                   ENDIF                                                              MD033964
     C                   IF        PRTCD = 'GLX1005'                                        MD043023
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                              MD043023
     C                   MOVEL     'GLX1005'     MsgIDArr(1)                                MD043023
     C                   MOVE      'E'           DDDLIT                                     MD043023
     C                   Z-ADD     1             Idx                                        MD043023
     C                   ENDIF                                                              MD043023
     C/COPY WNCPYSRC,GLBITPXC06
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*RECUPD'                                                  TCA102
     C     PRTCD         ANDNE     'CGL0002'                                                  TCA102
     C     PRTCD         ANDNE     'CGL0003'                                                  TCA102
     C     PRTCD         ANDNE     'NOHEADR'                                                MD033964
     C     PRTCD         ANDNE     'GLX1005'                                                MD043023
     C                   MOVEL     '0'           APIRetc                                      TCA102
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                TCA102
     C**********         ELSE                                                          CSC022 TCA102
     C                   EXSR      *PSSR                                                      TCA102
     C**********         SETON                                        U7U8             CSC022 TCA102
     C**********         ENDIF                                                         CSC022 TCA102
     C                   ELSE
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   ENDIF
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*RECUPD'
     C     PRTCD         ANDNE     'NOHEADR'                                                MD033964
     C     PRTCD         ANDNE     'GLX1005'                                                MD043023
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM1000'     MsgIdArr(1)
     C
     C                   END

      ** Batch Number to pass back to APTRANVU on insert mode

     C                   Z-ADD     B2BINB        #DDBINB           3 0
     C                   MOVE      #DDBINB       DDBINB
     C                   EVAL      DDBTNB = B2BTNB                                         AR1027164
                                                                                              246418
      * Pass back correct value of ERI Indicator                                              246418
     C                   IF        CGL013 = 'Y' and PAddInfo <> *blanks                       246418
     C                   EVAL      DDAERI = B3AERI                                            246418
     C                   ENDIF                                                                246418

     C                   ENDSR
      *****************************************************************                       CER001
      *  SRValdExt - Validate Batch Item Extension Details            *                       CER001
      *****************************************************************                       CER001
     C     SRValdExt     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #1CYCD = DDCYCD                                            CER001
     C                   EVAL      #1BTNB = DDBTNB                                            CER001
     C                   MOVE      DDBINB        #1BINB                                       CER001
      *                                                                                       CER001
     C                   CALLB     'GLBPLX2VL'                                                CER001
     C                   PARM                    PAction                                      CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsExtL                                  CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExtL                                 CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Determine type of account                                                            CSF011
                                                                                              CSF011
                                                                                              CSF011
     C                   CALL      'AOACCTV1'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      *BLANKS       P@TYP                                        CSF011
     C                   PARM      DDACID        P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
                                                                                              CSF011
      ** Retail Account, save Customer number. Move account name detail.                      CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*RETAIL'                                          CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
     C                   EVAL      DDATAN    = AC_ANAM                                       CSF011A
                                                                                              CSF011
      ** Nostro, save Customer number. Call Access object for account                         CSF011
      ** details                                                                              CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
     C                   EVAL      SDNOST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = NO_A7CUST                                      CSF011
     C                   CLEAR                   AccKeyDs                                     CSF011
     C                   MOVEL     NO_A7CUST     PKCUST                                       CSF011
     C                   MOVEL     NO_A7CYCD     PKCYCD                                       CSF011
     C                   MOVEL     NO_A7ACCD     PKACCD                                       CSF011
     C                   MOVEL     NO_A7ACSN     PKACSN                                       CSF011
     C                   MOVEL     NO_A7BRCD     PKBRCD                                       CSF011
     C                   EXSR      SRActDtls                                                  CSF011
                                                                                              CSF011
      ** Customer Number, save shortname, report name and town.                               CSF011
      ** Call access object for account details                                               CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*CUSTNO' OR                                       CSF011
     C                             P@TYP = '*SHNAME'                                          CSF011
     C                   EVAL      SDCUST = DSSDY                                             CSF011
     C                   EVAL      DDATSN = BBCSSN                                           CSF011A
     C                   EVAL      DDATNM = BBCRNM                                           CSF011A
     C                   EVAL      DDATRT = BBCRTN                                           CSF011A
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   CLEAR                   AccKeyDs                                     CSF011
     C                   MOVEL     DDACID        PKCUST                                       CSF011
     C                   MOVEL     DDCYCD        PKCYCD                                       CSF011
     C                   MOVEL     DDACCD        PKACCD                                       CSF011
     C                   MOVEL     DDACSN        PKACSN                                       CSF011
     C                   MOVEL     DDIBCA        PKBRCD                                       CSF011
     C                   EXSR      SRActDtls                                                  CSF011
                                                                                              CSF011
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
      ** Call access object for customer details                                              CSF011
                                                                                              CSF011
     C                   IF         WCustomer <> *BLANKS                                      CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    WCustomer                                    CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      DDATSN = BBCSSN                                           CSF011A
     C                   EVAL      DDATNM = BBCRNM                                           CSF011A
     C                   EVAL      DDATRT = BBCRTN                                           CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SRActDtls - Call access object for Account details           *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
                                                                                              CSF011
     C     SRActDtls     BEGSR                                                                CSF011
                                                                                              CSF011
     C                   CALLB     'AOACCTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     POPTN                                        CSF011
     C                   PARM                    PKACID                                       CSF011
     C                   PARM                    PKCUST                                       CSF011
     C                   PARM                    PKCYCD                                       CSF011
     C                   PARM                    PKACCD                                       CSF011
     C                   PARM                    PKACSN                                       CSF011
     C                   PARM                    PKBRCD                                       CSF011
     C     ACCNT         PARM      ACCNT         DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      DDATAN = AC_ANAM                                          CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      *****************************************************************                       CER001
      *  SRUpdtExt - Update Batch Item Extension Detail Records       *                       CER001
      *****************************************************************                       CER001
     C     SRUpdtExt     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #LLXJEBTNB = B2BTNB                                        CER001
     C                   EVAL      #LLXJEBINB = B2BINB                                        CER001
      *                                                                                       CER001
     C                   CALLB     'GLBPLX2UP'                                                CER001
     C                   PARM      DDACTN        PAction                                      CER001
     C                   PARM                    PRTCD                                        CER001
     C                   PARM      'Y'           PFIND                                        CER001
     C                   PARM                    ValidFilExtL                                 CER001
     C                   PARM                    SVRCD                                        CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
     C/COPY WNCPYSRC,GLH00662
      *****************************************************************                    AR1029481
      /EJECT                                                                               AR1029481
      *****************************************************************                    AR1029481
      *                                                               *                    AR1029481
      *  SrAutoAuth - Subroutine to auto authorize the GL batch       *                    AR1029481
      *               transaction.                                    *                    AR1029481
      *                                                               *                    AR1029481
      *****************************************************************                    AR1029481
      *                                                                                    AR1029481
     C     SrAutoAuth    BEGSR                                                             AR1029481
      *                                                                                    AR1029481
     C     DDBTNB        CHAIN     GLJENHL1                           22                   AR1029481
     C     *IN22         IFEQ      *OFF                                                    AR1029481
      *                                                                                    AR1081387
     C                   MOVE      'Y'           WCcyBal           1                       AR1081387
     C     DDBTNB        SETLL     GLJENSL1                                                AR1081387
     C     DDBTNB        READE     GLJENSL1                               23               AR1081387
      *                                                                                    AR1081387
     C     *IN23         IFEQ      *ON                                                     AR1081387
     C                   MOVE      'N'           WCcyBal                                   AR1081387
     C                   ENDIF                                                             AR1081387
      *                                                                                    AR1081387
      ** Check if currency DR and CR totals balance.                                       AR1081387
      *                                                                                    AR1081387
     C     BRMBRB        IFNE      'Y'                                                     AR1081387
     C     *IN23         DOWEQ     *OFF                                                    AR1081387
     C     WCcyBal       ANDEQ     'Y'                                                     AR1081387
      *                                                                                    AR1081387
     C     BSDBTT        IFNE      BSCRTT                                                  AR1081387
     C                   MOVE      'N'           WCcyBal                                   AR1081387
     C                   ENDIF                                                             AR1081387
      *                                                                                    AR1081387
     C     DDBTNB        READE     GLJENSL1                               23               AR1081387
     C                   ENDDO                                                             AR1081387
      *                                                                                    AR1081387
     C                   ELSE                                                              AR1081387
      *                                                                                    AR1081387
      ** Multi branch batch, check each ccy total for all                                  AR1081387
      ** branches matches                                                                  AR1081387
      *                                                                                    AR1081387
     C                   Z-ADD     0             WDBTT            15 0                     AR1081387
     C                   Z-ADD     0             WCRTT            15 0                     AR1081387
     C                   MOVE      BSCYCD        WCYCD             3                       AR1081387
     C     *IN23         DOWEQ     *OFF                                                    AR1081387
     C     WCcyBal       ANDEQ     'Y'                                                     AR1081387
     C     WCYCD         IFNE      BSCYCD                                                  AR1081387
     C     WDBTT         IFNE      WCRTT                                                   AR1081387
     C                   EVAL      WccyBal = 'N'                                           AR1081387
     C                   ENDIF                                                             AR1081387
     C                   Z-ADD     0             WDBTT                                     AR1081387
     C                   Z-ADD     0             WCRTT                                     AR1081387
     C                   ENDIF                                                             AR1081387
     C                   ADD       BSDBTT        WDBTT                                     AR1081387
     C                   ADD       BSCRTT        WCRTT                                     AR1081387
     C                   EVAL      WCYCD = BSCYCD                                          AR1081387
     C     DDBTNB        READE     GLJENSL1                               23               AR1081387
     C                   ENDDO                                                             AR1081387
      *                                                                                    AR1081387
     C     WDBTT         IFNE      WCRTT                                                   AR1081387
     C     WCcyBal       ANDNE     'N'                                                     AR1081387
     C                   EVAL      WCcyBal = 'N'                                           AR1081387
     C                   ENDIF                                                             AR1081387
     C                   ENDIF                                                             AR1081387
      *                                                                                    AR1081387
     C                   IF        BRAUTH = 'Y' AND                                        AR1029481
     C                             BRFRNT <> *BLANKS AND                                   AR1029481
     C                             BRBTSF = 'H' AND                                        AR1029481
     C                             BRHICC = BRHIIN AND                                     AR1029481
     C                             BRHDCC = BRHDIN AND                                     AR1029481
     C**********                   BRHINC = BRHINI                               AR1029481 AR1081387
     C                             BRHINC = BRHINI AND                                     AR1081387
     C                             WCcyBal = 'Y'                                           AR1081387
      *                                                                                    AR1029481
     C                   Z-ADD     0             BRHICC                                    AR1029481
     C                   Z-ADD     0             BRHDCC                                    AR1029481
     C                   Z-ADD     0             BRHINC                                    AR1029481
     C                   EVAL      BRBTSF = 'A'                                            AR1029481
     C                   EVAL      BRIBCF = *BLANKS                                        AR1029481
     C                   EVAL      BRBHAI = 'A'                                            AR1029481
     C                   EVAL      BRTMST = PTimeStamp                                     AR1029481
     C                   EVAL      BRBIUF = ' '                                            AR1029481
     C                   EVAL      BRWSID = *BLANKS                                        AR1029481
      *                                                                                    AR1029481
     C                   CALLB     'GLBITHUPD'                                             AR1029481
     C                   PARM      *BLANK        PRTCD                                     AR1029481
     C                   PARM                    CGL008                                    AR1029481
     C                   PARM                    PVBITH                                    AR1029481
     C                   PARM      *BLANKS       JERRMSG                                   AR1029481
     C                   PARM                    BKMHTN                                    AR1029481
      *                                                                                    AR1029481
     C                   ENDIF                                                             AR1029481
     C                   ENDIF                                                             AR1029481
      *                                                                                    AR1029481
     C                   ENDSR                                                             AR1029481
      *                                                                                    AR1029481
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
      ** Common Message Header information (DS) from source system
     C                   PARM                    PHeadIn
      ** Transaction information in a single large field from
      ** from source system
     C                   PARM                    PTrans500
      *
      ** Extra Transaction information in a single large field
      ** from source system
     C                   PARM                    PAddInfo500                                  246418
     C                   PARM                    PAddInf1500                                BUG23742
     C                   PARM                    PAddInf2500                                BUG23742
      *                                                                                       CSC054
      ** Corrective batch detail                                                              CSC054
     C                   PARM                    PEADetail                                    CSC054
     C/COPY OFCPYSRCZ,CGL135_077                                                             CGL135A
      ** CGL150 Default Value Date 'Y'                                                      MD052075
     C                   PARM                    VDFLTF            1                        MD052075
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    PExtData500
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

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'GLUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'SDUSRMSG'                                  237621
     C/COPY WNCPYSRC,GLH00663

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,GLBITP02
      *                                                                                       CRE023
      ** Access SAR details file to determine if 2'O Clock Flag SAR                           CRE023
      ** processing is switched ON                                                            CRE023
      *                                                                                       CRE023
     C                   EVAL      CRE023 = 'N'                                               CRE023
     C                   CALLB     'AOSARDR0'                                                 CRE023
     C                   PARM      *BLANKS       PRTCD                                        CRE023
     C                   PARM      '*VERIFY'     POPTN                                        CRE023
     C                   PARM      'CRE023'      PSARD                                        CRE023
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE023
      *                                                                                       CRE023
      ** An NRF (No Record Found) return code is valid. Issue database                        CRE023
      ** error only for error return codes.                                                   CRE023
      *                                                                                       CRE023
     C                   IF        PRTCD <> *BLANKS AND                                       CRE023
     C                             PRTCD <> '*NRF   '                                         CRE023
     C                   EVAL      DBKEY = 'CRE023'                                           CRE023
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE023
     C                   EVAL      DBASE = 010                                                CRE023
     C                   EXSR      *PSSR                                                      CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
     C                   IF        PRTCD = *BLANK                                             CRE023
     C                   EVAL      CRE023 = 'Y'                                               CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       246418
      ** Access SAR details file to determine if MT94x Messages Generation                    246418
      ** processing is switched ON                                                            246418
      *                                                                                       246418
     C                   EVAL      CGL013 = 'N'                                               246418
     C                   CALLB     'AOSARDR0'                                                 246418
     C                   PARM      *BLANKS       PRTCD                                        246418
     C                   PARM      '*VERIFY'     POPTN                                        246418
     C                   PARM      'CGL013'      PSARD                                        246418
     C     SCSARD        PARM      SCSARD        DSFDY                                        246418
      *                                                                                       246418
      ** An NRF (No Record Found) return code is valid. Issue database                        246418
      ** error only for error return codes.                                                   246418
      *                                                                                       246418
     C                   IF        PRTCD <> *BLANKS AND                                       246418
     C                             PRTCD <> '*NRF   '                                         246418
     C                   EVAL      DBKEY = 'CGL013'                                           246418
     C                   EVAL      DBFILE = 'SCSARDPD'                                        246418
     C                   EVAL      DBASE = 011                                                246418
     C                   EXSR      *PSSR                                                      246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C                   IF        PRTCD = *BLANK                                             246418
     C                   EVAL      CGL013 = 'Y'                                               246418
     C                   ENDIF                                                                246418
      *                                                                                     BUG23742
     C                   CALLB     'AOSARDR0'                                               BUG23742
     C                   PARM      *BLANKS       PRtCd                                      BUG23742
     C                   PARM      '*VERIFY'     POptn                                      BUG23742
     C                   PARM      'CER030'      PSard                                      BUG23742
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23742
      *                                                                                     BUG23742
     C                   IF        PRtcd = *BLANKS                                          BUG23742
     C                   EVAL      CER030 = 'Y'                                             BUG23742
     C                   ELSEIF    PRtcd <> '*NRF'                                          BUG23742
      *                                                                                     BUG23742
     C     *LOCK         IN        LDA                                                      BUG23742
     C                   EVAL      DBASE = 12                                               BUG23742
     C                   EVAL      DBFile = 'AOSARDR0'                                      BUG23742
     C                   EVAL      DBKEY = '*VERIFY'                                        BUG23742
     C                   OUT       LDA                                                      BUG23742
     C                   EXSR      *PSSR                                                    BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger ICD details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Retail III ICD details to check if Charge for
      ** Multiple Transactions is 'Y'.
      *
     C     BGNXST        IFEQ      'Y'
     C                   CALL      'SD9343'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      *BLANK        PCMTR             1
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'TABTBRE'     DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Access Retail ICD details.
      *
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if CEU013
      ** (EMU Account Posting Narrative feature) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU013'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU013'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013            1
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   ENDIF
      *
      ** Access SAR details file to determine if CGL002
      ** (Block GL Accounts feature) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL002'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL002            1
     C                   ELSE
     C                   MOVEL     'N'           CGL002
     C                   ENDIF
      *
      ** Access SAR file to determine if CGL008 (Security on Journal
      ** Entry) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGL008'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL008'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL008            1
     C                   ELSE
     C                   MOVE      'N'           CGL008
     C                   ENDIF
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 8                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CRE019
      ** Access SAR file to determine if CRE019 is installed.                                 CRE019
                                                                                              CRE019
     C                   CALLB     'AOSARDR0'                                                 CRE019
     C                   PARM      *BLANKS       PRTCD                                        CRE019
     C                   PARM      '*VERIFY'     POPTN                                        CRE019
     C                   PARM      'CRE019'      PSARD                                        CRE019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE019
                                                                                              CRE019
      ** An NRF (No Record Found) return code is valid.  Issue database error                 CRE019
      ** only for error return codes.                                                         CRE019
                                                                                              CRE019
     C     PRTCD         IFNE      *BLANKS                                                    CRE019
     C     PRTCD         ANDNE     '*NRF   '                                                  CRE019
     C                   MOVEL     'CRE019'      DBKEY                                        CRE019
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CRE019
     C                   Z-ADD     008           DBASE                                        CRE019
     C                   EXSR      *PSSR                                                      CRE019
     C                   ENDIF                                                                CRE019
                                                                                              CRE019
     C     PRTCD         IFEQ      *BLANK                                                     CRE019
     C                   MOVE      'Y'           CRE019            1                          CRE019
     C                   ELSE                                                                 CRE019
     C                   MOVE      'N'           CRE019                                       CRE019
     C                   ENDIF                                                                CRE019
                                                                                              CGL014
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
     C                   EVAL      DBASE  = 9                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              237621
      ** Access SAR file to determine if CGL037 is installed.                                 237621
                                                                                              237621
     C                   CALLB     'AOSARDR0'                                                 237621
     C                   PARM      *BLANKS       PRTCD                                        237621
     C                   PARM      '*VERIFY'     POPTN                                        237621
     C                   PARM      'CGL037'      PSARD                                        237621
     C     SCSARD        PARM      SCSARD        DSFDY                                        237621
                                                                                              237621
      ** An NRF (No Record Found) return code is valid.  Issue database error                 237621
      ** only for error return codes.                                                         237621
                                                                                              237621
     C     PRTCD         IFNE      *BLANKS                                                    237621
     C     PRTCD         ANDNE     '*NRF   '                                                  237621
     C                   MOVEL     'CGL037'      DBKEY                                        237621
     C                   MOVEL     'SCSARDPD'    DBFILE                                       237621
     C                   Z-ADD     010           DBASE                                        237621
     C                   EXSR      *PSSR                                                      237621
     C                   ENDIF                                                                237621
                                                                                              237621
     C     PRTCD         IFEQ      *BLANK                                                     237621
     C                   MOVE      'Y'           CGL037            1                          237621
     C                   ELSE                                                                 237621
     C                   MOVE      'N'           CGL037                                       237621
     C                   ENDIF                                                                237621
                                                                                              237621
     C/COPY WNCPYSRC,GLBITPXC03
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER*-        BUG1175R BUG6979
      **their*user*name*is*stored*in*ZMUSER                                         BUG1175R BUG6979
     C**********         IN        ZMUSER                                           BUG1175R BUG6979
      *
      ** Access SAR details to see if ULX043 is switched on.                                  CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX043'      PSARD                                        CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX043 = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
     C                   EVAL      DBASE  = 10                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ***Access*SAR*file*to*determine*if*CGL125*is*installed.                        CSC054 MD039859
      ** Access SAR file to determine if CAP209 is installed.                               MD039859
      *                                                                                       CSC054
     C**********         MOVE      'N'           CGL125                              CSC054 MD039859
     C                   MOVE      'N'           CAP209                                     MD039859
     C                   CALLB     'AOSARDR0'                                                 CSC054
     C                   PARM      *BLANKS       PRTCD                                        CSC054
     C                   PARM      '*VERIFY'     POPTN                                        CSC054
     C**********         PARM      'CGL125'      PSARD                               CSC054 MD039859
     C                   PARM      'CAP209'      PSARD                                      MD039859
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC054
      *                                                                                       CSC054
      ** An NRF (No Record Found) return code is valid. Issue database error                  CSC054
      ** only for error return codes.                                                         CSC054
      *                                                                                       CSC054
     C     PRTCD         IFNE      *BLANKS                                                    CSC054
     C     PRTCD         ANDNE     '*NRF   '                                                  CSC054
     C**********         MOVEL     'CGL125'      DBKEY                               CSC054 MD039859
     C                   MOVEL     'CAP209'      DBKEY                                      MD039859
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSC054
     C                   Z-ADD     013           DBASE                                        CSC054
     C                   EXSR      *PSSR                                                      CSC054
     C                   ENDIF                                                                CSC054
      *                                                                                       CSC054
     C     PRTCD         IFEQ      *BLANKS                                                    CSC054
     C**********         MOVE      'Y'           CGL125            1                 CSC054 MD039859
     C                   MOVE      'Y'           CAP209            1                        MD039859
     C                   ENDIF                                                                CSC054
      *                                                                                       CSC054
     C     KBITP         KLIST                                                                249585
     C                   KFLD                    WBTNB                                        249585
     C                   KFLD                    WBINB                                        249585
      *                                                                                       249585
     C/COPY WNCPYSRC,GLH00664
     C/COPY OFCPYSRCZ,CGL135_078                                                             CGL135A
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
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
      *
**  CPY@
(c) Finastra International Limited 2003
