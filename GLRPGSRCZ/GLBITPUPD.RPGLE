     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE item database update')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITPUPD - Journal Batch Entry Item Database Update         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 CGL148             Date 13Jul18               *
      *                 MD025083           Date 13Jul18               *
      *                 MD047741           Date 31Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD046060           Date 21Jun17               *
      *                 CGL182             Date 11May17               *
      *                 MD043023           Date 25Jul17               *
      *                 MD042040           Date 10Oct16               *
      *                 MD033964           Date 07Oct16               *
      *                 MD039859           Date 11Aug16               *
      *                 MD033630A          Date 25May16               *
      *                 MD036967           Date 25May16               *
      *                 MD035554           Date 25May16               *
      *                 MD037061           Date 19Jan16               *
      *                 MD033630           Date 23Jun15               *
      *                 MD034050           Date 23Jun15               *
      *                 MD032083           Date 08Jun15               *
      *                 257489             Date 08Jun15               *
      *                 CGL135A            Date 10Jul13               *
      *                 MD020177           Date 30Sep13               *
      *                 AR1093096          Date 30Sep13               *
      *                 AR1027164A         Date 16Oct12               *
      *                 AR1027164          Date 16Oct12               *
      *                 AR1001634          Date 08Jul12               *
      *                 AR792734A          Date 22Sep11               *
      *                 CSC054             Date 23Feb12               *
      *                 AR787620           Date 10Jun11               *
      *                 CAP207             Date 10Feb11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26099           Date 22Sep09               *
      *                 BUG24257           Date 10Jun09               *
      *                 BUG23742           Date 09May09               *
      *                 BUG22724           Date 09Feb09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247613             Date 08May07               *
      *                 239576             Date 16Apr07               *
      *                 246418             Date 15Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 239466A            Date 14Dec06               *
      *                 239466             Date 18Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10855           Date 14Mar06               *
      *                 BUG7332            Date 23Sep05               *
      *                 CRE023             Date 29Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG6979            Date 04May05               *
      *                 BUG4185            Date 20Sep04               *
      *                 CMM121             Date 29Jun04               *
      *                 BUG3036            Date 02Jul04               *
      *                 BUG3085            Date 08Jun04               *
      *                 BUG1175R           Date 01Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2558            Date 11May04               *
      *                 BUG1898            Date 21Apr04               *
      *                 BUG1738            Date 15Apr04               *
      *                 TCA102             Date 02Apr04               *
      *                 CRE019             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Aug03               *
      *                 CGL016             Date 01Aug02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186206             Date 26Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  CGL148 - Automatic Opening of GL accounts                    *
      *         - Includes fix MD024246 and MD025083                  *
      *  MD025083 - Hash integer input for Journal entry sent         *
      *             via API are changed add validation for JAVAUSER.  *
      *  MD047741 - (1) apply MD020761                                *
      *             (2) in case of update, take into account whether  *
      *             the record was found during CHAIN                 *
      *  MD020761 - GLBITPUPD Dumps (Update without prior read)       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD046060 - GLBTNOPD is not defined with COMMIT               *
      *  CGL182 - Journal Entry via the Interface File - Java Version *
      *  MD043023 - If batch is sent through interface with Auto      *
      *             autorization set to 'Y', reject batch item if     *
      *             'Hash item no. calculated' equals 'Hash item no.  *
      *             input'.                                           *
      *           - Applied for MD-46910
      *  MD042040 - Ensure delay loop processed for API transactions. *
      *           - Ensure correct chain for header update.           *
      *  MD033964 - Batch Header must not be created automatically    *
      *             Introduced sysval to condition checking.          *
      *           - Applied for MD041905                              *
      *  MD039859 - Batch header is not updated when batch item is    *
      *             through API without batch number, but Front       *
      *             Office Id. Pattern AR1092517 done for BITH.       *
      *  MD033630A - Corrected discrepancy in MD033630 codes.         *
      *  MD036967 - Conflict between CRE023 and CAP207. Update Credit *
      *            only after Accept when both features are ON.       *
      *  MD035554 - 2o'clock/ABC Compatibility                        *
      *  MD037061 - Serious Midas Error appears after clicking        *
      *             Confirm write. I/O operation was applied          *
      *             to closed file RETTYPL0.                          *
      *  MD033630 - Limit CRE023 functionality to those whose trans-  *
      *             action types are in RETTYPPD.                     *
      *  MD034050 - Serious Midas Error when inserting a batch item   *
      *             with cheque. Reset the BTOUTR(Check number out of *
      *             range) flag to 'N'                                *
      *  MD032083 - Serious Midas Error during batch input            *
      *  257489 - Physically delete cheques that are only use by the  *
      *           transaction and are out of range.                   *
      *         - Applied for MD032083                                *
      *  CGL135A - Accounting Rules Process                           *
      *            Added hooks: CGL135_060, CGL135_061, CGL135_062,   *
      *                         CGL135_063, CGL135_064, CGL135_065,   *
      *                         CGL135_066                            *
      *  MD020177 - On amend action, only update PDCID if non zero    *
      *  AR1093096 - ABC - Reservations not removed for JRNE          *
      *              (Child: AR1093097)                               *
      *  AR1027164A - Transactions inserted remains locked even if    *
      *               its not (Child: AR1027165)                      *
      *  AR1027164 - Allow blank batch numbers if from 3rd party      *
      *              (Child: AR1027165)                               *
      *  AR1001634 - PEA transfer of BITP failed                      *
      *  AR792734A - Projected Account movement show incorrect        *
      *              Available Balance when posting Cash Deposit.     *
      *              Applied fix 248347, 261330, 261330A but removed  *
      *              the updading of the MEMOS. Use CGL016 to insert  *
      *              Shadow Postings and update MEMOS                 *
      *              (Child: AR792735A)                               *
      *  CSC054 - Period End Adjustments                              *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,GLH00052                                 *
      *             WNCPYSRC,GLH00053                                 *
      *             WNCPYSRC,GLH00054                                 *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26099 - A serious Midas error has occurred when inserting *
      *             a new Batch Item                                  *
      *  BUG24257 - Incorrect "Write" condition on MTCash Narr File   *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  BUG22724 - Additional Information for Batch Legs Disappears  *
      *             after Insert                                      *
      *  CER030 - Multicash German Feature                            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247613 - Keep on looping 20 more times before writing the    *
      *           header. As lots of BITP details messages may be     *
      *           sent, it may take some time before reading the      *
      *           header.                                             *
      *  239576 - Ensure branch code (batch header) is not blank.     *
      *  246418 - CGL013 changes for Midas Plus                       *
      *  239466A - Tag cheque number as deleted when deleting a batch.*
      *  239466 - Ensure cheques are presented correctly.             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10855- No record found in MEMOS upon entry of batch item  *
      *            produce "A Serious Midas Error".                   *
      *  BUG7332- BRWSID should only be updated if not a java user    *
      *  CRE023 - 2 O'clock Flag Upgrade to MidasPlus                 *
      *  CSC024 - Open Month End                                      *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG4185- Calculated decimal total is incorrect               *
      *  CMM121 - Core changes for GBO021                             *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:GLBITPDC09,GLBITPDF03,GLBITPDD01   *
      *                            GLBITPDC10,GLBITPDC11,GLBITPDC12   *
      *         - OUTPUT tag :86: - Information to Account Owners     *
      *  BUG3036 - Make sure cheques are processed when batch entries *
      *            are amended.                                       *
      *  BUG3085- Update the last amend user on the batch header rec. *
      *  BUG1175R-User ID is now setup in workstation ID by java      *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2558- Currency summary totals incorrect when changing CCY *
      *  BUG1898- Use GL0137U to select correct batch item number     *
      *  BUG1738- GL004446 was changed so that it is now expecting a  *
      *         - parameter with the layout of GLJENPL0 not GLJENPPD  *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - MidasPlus Changes                                   *
      *  CGL016 - Projected Movements Update Prior to Authorisation   *
      *  CSC011 - 24x7 Midas Availability                             *
      *  186206 - Journal Entry API fixes. Produce only one dump      *
      *           per JE batch. Generate JE Valid errors report.      *
      *           Prevent record locking error in JE database         *
      *           updater.                                            *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** JE Items file - update
     FGLJENPPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** JE Headers file by Front Office Id - update
     FGLJENHL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *                                                                         CAP084
      ** JE Headers file by Batch Header Number                                 CAP084
     FGLJENHL0  UF A E           K DISK    INFSR(*PSSR)                         CAP084
     F                                     COMMIT                               CAP084
      *                                                                         CAP084
      *
      ** JE Currency Summary file - update
     FGLJENSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *                                                                         186206
      ** Today's batch numbers used                                             186206
     FGLBTNOL0  UF A E           K DISK    INFSR(*PSSR)                         186206
     F                                     COMMIT                                           MD046060
      *
     FGLJENPL0  UF A E           K DISK    INFSR(*PSSR)                         CGL016
     F********                             USROPN                                      CGL016 CAP084
     F                                     COMMIT                               CGL016
      *                                                                                       257489
      ** Teller Trans. logical file of all presented cheques                                  257489
     FTTRANL6   IF   E           K DISK    INFSR(*PSSR)                                       257489
     F                                     RENAME(@BTREMG:TTRAND6)                            257489
     F                                     PREFIX(TR)                                         257489
      *                                                                                       257489
      ** Teller Trans. logical file of all presented cheques                                  257489
     FTTRANL7   IF   E           K DISK    USROPN                                             257489
     F                                     PREFIX(TQ)                                         257489
      *                                                                                       257489
      ** Teller Identification file                                                           257489
     FSDTELDL1  IF   E           K DISK    INFSR(*PSSR)                                       257489
      *                                                                                       CRE019
      ** Midas RE Cheque Book file - 1                                                        CRE019
     FCHQBKL1   UF A E           K DISK    INFSR(*PSSR)                                       CRE019
     F                                     USROPN                                             CRE019
     F                                     COMMIT                                             CRE019
     F/COPY WNCPYSRC,GLBITPDF03
      *                                                                                       CRE023
     FRETTYPL0  IF   E           K DISK    INFSR(*PSSR)                                       CRE023
     F                                     USROPN                                             CRE023
      *                                                                                       CRE023
      ** Outward Clearing Transaction Types                                                   CRE023
      *                                                                                       CRE023
     FMEMOSL2   UF   E           K DISK    INFSR(*PSSR)                                       CRE023
     F                                     USROPN                                             CRE023
     F                                     COMMIT                                             CRE023
      *                                                                                       CRE023
      ** Shadow Balance File                                                                  CRE023
      *                                                                                       CRE023
     FREMEMLL0  UF   E           K DISK    INFSR(*PSSR)                                       CRE023
     F                                     USROPN                                             CRE023
     F                                     COMMIT                                             CRE023
      *                                                                                       CRE023
      ** Outward Clearing Balance File                                                        CRE023
      *                                                                                       CRE023
     FGLMNARL2  UF A E           K DISK    INFSR(*PSSR)                                     BUG23742
      *                                                                                     BUG23742
      ** Midas GL Journal Entry - Additional Information 1                                  BUG23742
      *                                                                                     BUG23742
     F/COPY OFCPYSRCZ,CGL135_060                                                             CGL135A
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
      *                                                                                       246418
      ** The following /COPY line includes all the definitions of the                         246418
      ** appended error arrays, including the named constant giving the size                  246418
      ** of the arrays.                                                                       246418
      *                                                                                       246418
      /COPY ZACPYSRC,ERR_XARRYS                                                               246418
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
     F/COPY WNCPYSRC,GLBITPDF01
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
     F/COPY WNCPYSRC,GLH00457
     D*PSysVal1*       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
     D PSysVal2        C                   CONST('MandatoryBchHdr')                         MD033964
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     F/COPY WNCPYSRC,GLBITPDF02
      *                                                                                       CRE019
      ** Cheques presented array                                                              CRE019
     D WAR             S              1    DIM(20)                                            CRE019
      *                                                                                       CRE019
      *                                                                                       257489
      ** Array for the content of @CMD in Data Structure                                      257489
     D@ARRTXT          S             80    DIM(2) CTDATA PERRCD(1)                            257489
      *                                                                                       257489
      ** Data Structure for QCMDEXEC                                                          257489
     D                 DS                                                                     257489
     D@CMD                     1     80                                                       257489
     D@BRI                    30     30                                                       257489
     D@BID                    31     33                                                       257489
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *                                                                                       246418
      ** Valid JE Item Additional Information (DS) - for file update                          246418
     D PVBITPX       E DS                  EXTNAME(GLVBIPXPD)                                 246418
      *                                                                                     BUG23742
      ** Journal Batch Entry Items Addnl Inf - for file update                              BUG23742
      *                                                                                     BUG23742
     D GLVNAR          DS           770                                                     BUG23742
      *                                                                                     BUG23742
      ** External DS for MultiCash Narratives file                                          BUG23742
      *                                                                                     BUG23742
     D GLMNarFilFmt  E DS                  EXTNAME(GLMNARPD)                                BUG23742
      *
      ** Externally described DS for JE Item details
     D WJENP         E DS                  EXTNAME(GLJENPPD)
     D WjAccd        E                     EXTFLD(QQACCD)                                     CGL029
      *                                                                                      BUG1738
      ** Externally described DS for JE Item details                                         BUG1738
     D LJENP         E DS                  EXTNAME(GLJENPL0)                                 BUG1738
     D                                     PREFIX(L)                                         BUG1738
      *
      ** Externally described DS for JE Header details
     D WJENH         E DS                  EXTNAME(GLJENHPD)
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CSC011
      ** Header information to be passed to APLOGTRAN                                         CSC011
     D PHead         E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      ** Externally described DS for SAR details                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
                                                                                              CSC011
      ** DS for access programs - short data structure                                        CSC011
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC011
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     CAP084
      ** Java user information                                                                CAP084
      *
      ** Hash normalisation data structures
      *
     D                 DS
     D  WINT15                 1     15  0
     D  WINT14                 1     14  0
     D  WINT13                 1     13  0
     D  WINT12                 1     12  0
     D  WINT01                15     15  1
     D  WINT02                14     15  2
     D  WINT03                13     15  3
      *
     D                 DS
     D  WDEC09                 1      9  3
     D  WDEC06                 1      6  0
     D  WDEC03                 7      9  0
      *                                                                                       CRE019
      ** Data structure to update last transaction number                                     CRE019
     DDNATN            DS             5                                                       CRE019
     D  FNATN                  1      5  0                                                    CRE019
      *
     D D@ACCT        E DS                  EXTNAME(ACCNTAB)                     CGL016
     D L_CD          E                     EXTFLD(LCD)                          CGL016
      ** Account DS                                                             CGL016
      *                                                                         CGL016
     D RUNDAT        E DS                  EXTNAME(RUNDAT)                      CGL016
      * RUNDAT DATA AREA                                                        CGL016
      *                                                                         CGL016
      *                                                                                       246418
     D PPostDetails    DS           118                                                       246418
     D WBTNB                   1      3                                                       246418
     D WBINB                   4      6  0                                                    246418
     D WBranch                 7      9                                                       CER030
     D WCNum                  10     15                                                       CER030
     D WCurr                  16     18                                                       CER030
     D WASeq                  23     24                                                       CER030
     D WACode                109    118                                                       CER030
      *                                                                                       246418
     D/COPY OFCPYSRCZ,CGL135_061                                                             CGL135A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CSC011
      ** Define variable for switchable CSC011.                                               CSC011
     D CSC011          S              1A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Define parameter to be passed to APLOGTRAN.                                          CSC011
     D TRANSDTL        S           5800A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Define Timestamp variable                                                            CSC011
     D PTime           S             26A                                                      CSC011
                                                                                              CSC011
      ** Transaction reference to be pass to APLOGTRAN.                                       CSC011
     D***PDealNo         S             18A   INZ(*BLANKS)                              CSC011 CGL029
     D PDealNo         S             24A   INZ(*BLANKS)                                       CGL029
                                                                                              CSC011
      ** Transaction reference to be pass to APLOGTRAN.                                       CSC011
     D***PADealNo        S             18A   INZ(*BLANKS)                              CSC011 CGL029
     D PADealNo        S             24A   INZ(*BLANKS)                                       CGL029
                                                                                              CSC011
      ** Define parameters for AOSARDR0                                                       CSC011
     D PRTNC           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
      *                                                                                       CRE023
     D CRE023          S              1                                                       CRE023
      ** Singapore 2 o'clock enhancement flag                                                 CRE023
      *                                                                                       CRE023
     D CAP207          S              1                                                     MD036967
      ** Account balance Check                                                              MD036967
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CRE023
      ** Externally described DS for Bank Details                                             CRE023
      *                                                                                       CRE023
     D CrGLJENP      E DS                  EXTNAME(GLJENPPD)                                  CRE023
     D                                     PREFIX(Cr_)                                        CRE023
      ** Externally described DS for GLJENPPD                                                 CRE023
      *                                                                                       CRE023
      ** Reservation ID dataarea                                                              CAP207
     D GPRESERVID      DS            15                                                       CAP207
     D  ReservID               1     15                                                       CAP207
                                                                                              CAP207
      ** Parameters for QUSROBJD                                                              CAP207
     D ERROR           DS                                                                     CAP207
     D MSGID                   9     15                                                       CAP207
     D REC             S            100                                                       CAP207
     D RECLEN          S              4B 0 INZ(100)                                           CAP207
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
     D BchHdr          S              1A                                                    MD033964
     D PActnCde        S              1A                                                      CSC024
     D WPlayBack       S              1A                                                      CSC024
                                                                                              CSC024
     D PApiMode        S              1A                                                      246418
     D PMode           S              1A                                                      246418
     D PRetCodeIn      S              7A                                                      246418
     D PAdditional     S              1A                                                      246418
      *                                                                                     BUG23742
     D CER030          S              1A                                                    BUG23742
      *                                                                                     BUG23742
     D KPTDT           S              5P 0                                                  BUG23742
     D KBTNB           S              3A                                                    BUG23742
     D KITNB           S              3P 0                                                  BUG23742
      *                                                                                     BUG23742
     D*WEX1*****       S             35A                                           BUG23742 BUG24257
     D*WEX2*****       S             35A                                           BUG23742 BUG24257
     D PCancel         S              1A                                                    BUG23742
     D PExit           S              1A                                                    BUG23742
      *                                                                                     BUG23742
     D T_REV           S              1A                                                   AR792734A
      *                                                                                    AR792734A
     D WPdId           S             15S 0 INZ(0)                                          AR1093096
     D/COPY WNCPYSRC,GLBITPDD01
      ** Duplicate cheque                                                                     257489
     D WCDup           S              1A   Inz('N')                                           257489
     D CGL182          S              1A   INZ('N')                                           CGL182
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
                                                                                             BUG6979
      * If the user is connected via a browser, the job user name is QUSER -                 BUG6979
      * their user name is stored in ZMUSER                                                  BUG6979
      *                                                                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
      *                                                                                      BUG6979
     C     USRID         IFNE      *BLANKS                                                   BUG6979
     C     USRID         ANDNE     PSUser                                                    BUG6979
     C                   MOVE      'Y'           JAVAUSER          1                         BUG6979
     C                   ELSE                                                                BUG6979
     C                   MOVE      'N'           JAVAUSER                                    BUG6979
     C                   ENDIF                                                               BUG6979
     C/COPY WNCPYSRC,GLH00458
      *                                                                                       CAP207
      * Check if reservation id dataarea exists                                               CAP207
     C                   EVAL      LIB='GPRESERVID'+'QTEMP     '                              CAP207
                                                                                              CAP207
     C                   CALL      'QUSROBJD'                                                 CAP207
     C                   PARM                    REC                                          CAP207
     C                   PARM                    RECLEN                                       CAP207
     C                   PARM      'OBJD0100'    FILFORM           8                          CAP207
     C                   PARM                    LIB              20                          CAP207
     C                   PARM      '*DTAARA   '  OBJTYP           10                          CAP207
     C                   PARM                    ERROR                                        CAP207
                                                                                              CAP207
      * If dataarea exists, read in the contents                                              CAP207
     C                   IF        MSGID = *BLANKS                                            CAP207
     C     *DTAARA       DEFINE                  GPRESERVID                                   CAP207
     C                   IN        GPRESERVID                                                 CAP207
     C                   ELSE                                                                 CAP207
     C                   EVAL      ReservID = *BLANKS                                         CAP207
     C                   ENDIF                                                                CAP207
                                                                                              CAP207
     C                   IF        ReservID <> *BLANKS                                        CAP207
     C                   MOVE      *BLANKS       ZFIELD                                       CAP207
     C                   MOVEL     ReservID      ZFIELD                                       CAP207
     C                   Z-ADD     0             ZADEC                                        CAP207
     C                   Z-ADD     15            ZADIG                                        CAP207
     C                   CALLB     'ZALIGN2'                                                  CAP207
     C                   PARM      'Y'           ZALIGNok          1                          CAP207
     C                   PARM                    ZFIELD           16                          CAP207
     C                   PARM                    ZADEC             2 0                        CAP207
     C                   PARM                    ZADIG             2 0                        CAP207
     C**********         MOVE      ZFIELD        BTPDID                             CAP207 AP1093096
     C                   MOVE      ZFIELD        WPdId                                     AR1093096
     C                   ELSE                                                              AR1093096
     C                   EVAL      WPdId = 0                                               AR1093096
     C                   ENDIF                                                                CAP207
      *
      ** Validate Front Office Id; it must not be blank.
      *
     C     B2FRNT        IFEQ      *BLANKS
     C*****CGL125        ANDEQ     'N'                                               CSC054 MD039859
     C     CAP209        ANDEQ     'N'                                                      MD039859
     C                   MOVEL     B2FRNT        DBKEY
     C                   MOVEL(P)  'GLVBITPPD'   DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      SRERR
     C                   ENDIF
     C/COPY WNCPYSRC,GLBITPDC04
      *
      ** Check if JE Header record is already existing.
      *
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     B2BTNB        ANDNE     *BLANKS                                                 AR1027164
     C     KJENH0        CHAIN     GLJENHL0                           01                      CAP084
     C                   ELSE                                                                 CAP084
     C**********         IF        CGL125 = 'N'                                     CSC054 AR1027164
     C     KJENH         CHAIN     GLJENHL3                           01
     C**********         ENDIF                                                      CSC054 AR1027164
     C                   ENDIF                                                                CAP084
      *
      ** If JE Header not found, issue a delay of 10 seconds
      ** and then try to retrieve the record again.
      *
     C     *IN01         IFEQ      *ON
      *
     C                   CALLB     'ZACDELAY'
      *
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     B2BTNB        ANDNE     *BLANKS                                                 AR1027164
     C     KJENH0        CHAIN     GLJENHL0                           01                      CAP084
     C                   ELSE                                                                 CAP084
     C**********         IF        CGL125 = 'N'                                     CSC054 AR1027164
     C     KJENH         CHAIN     GLJENHL3                           01
     C**********         ENDIF                                                      CSC054 AR1027164
     C                   ENDIF                                                                CAP084
      *
      ** If batch sent through API, loop two more times to wait for the header.               247613
                                                                                              247613
     C                   Z-ADD     0             COUNT             2 0                        247613
     C     *IN01         DOWEQ     *ON                                                        247613
     C*****JAVAUSER      ANDNE     'Y'                                               247613 MD042040
     C     COUNT         ANDLE     20                                                         247613
     C                   CALLB     'ZACDELAY'                                                 247613
     C                   ADD       1             COUNT                                        247613
     C**********         IF        CGL125 = 'N'                                     CSC054 AR1027164
     C     JAVAUSER      IFEQ      'Y'                                                      MD042040
     C     B2BTNB        ANDNE     *BLANKS                                                  MD042040
     C     KJENH0        CHAIN     GLJENHL0                           01                    MD042040
     C                   ELSE                                                               MD042040
     C     KJENH         CHAIN     GLJENHL3                           01                      247613
     C**********         ENDIF                                                      CSC054 AR1027164
     C                   ENDIF                                                              MD042040
     C                   ENDDO                                                                247613
                                                                                              247613
      ** If record still doesn't exist, write new JE Header.
      *
     C     *IN01         IFEQ      *ON
     C     BchHdr        IFEQ      'N'                                                      MD033964
     C                   EXSR      SRWrtRecord
     C                   ELSE                                                               MD033964
     C                   Eval      PRTCD = 'NOHEADR'                                        MD033964
     C                   EVAL      *INLR = *ON                                              MD033964
     C                   RETURN                                                             MD033964
     C                   ENDIF                                                              MD033964
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CSC024
      ***Determine*if*transaction*is*an*insert*from*OME*playback                       CSC024 CSC054
      ** Determine if transaction is an insert from PEA playback                              CSC054
      ** where batch item number is not *zero.                                                CSC024
                                                                                              CSC024
     C                   EVAL      WPlayBack = 'N'                                            CSC024
     C**********         IF        CSC024 = 'Y' AND                                    CSC024 CSC054
     C**********                   WOMEInd = 'Y' AND                                   CSC024 CSC054
     C                   IF        CSC054 = 'Y' AND                                           CSC054
     C**********                   WPEAInd = 'Y' AND                                CSC054 AR1001634
     C                             PActnCde = 'I'AND                                          CSC024
     C                             B2BINB <> *ZERO                                            CSC024
     C                   EVAL      WPlayBack = 'Y'                                            CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CAP084
      ** Set up key for chain to GLJENPPD for header totals calculation                       CAP084
      ** and item update later in subroutine                                                  CAP084
     C     B2BINB        IFNE      *ZERO                                                      CAP084
     C     JAVAUSER      ANDEQ     'Y'                                                        CAP084
     C     WPlayBack     ANDEQ     'N'                                                        CSC024
                                                                                              CAP084
     C                   MOVE      BRBTNB        BTBTNB                                       CAP084
     C                   MOVE      B2BINB        BTBINB                                       CAP084
                                                                                              CAP084
     C     KJENP         CHAIN     GLJENPL0                           91                      CAP084
     C                   IF        *IN91 = *OFF                                             MD020761
                                                                                              CRE023
      ** Save the current GLJENPPD record before the validated screen                         CRE023
      ** input is applied to GLJENPPD.                                                        CRE023
     C**********         IF        (CRE023 = 'Y')                                   CRE023 AR792734A
     C                   IF        (CRE023 = 'Y') OR (CGL016 = 'Y')                        AR792734A
     C                   MOVEL     WJENP         CrGLJENP                                     CRE023
     C                   ENDIF                                                                CRE023
                                                                                              CAP084
      ** Save current amount for correct currency summary update and calculated totals        CAP084
                                                                                              CAP084
     C                   MOVE      BTCYCD        CYCDJV                                       CAP084
     C                   Z-ADD     BTPTAM        PTAMJV                                       CAP084
     C                   MOVE      BTDCIN        PTDCIN            1                          CAP084
     C                   MOVE      BTIBCA        PTIBCA                                      BUG2558
                                                                                              CAP084
     C                   ENDIF                                                              MD020761
      *                                                                                     MD020761
     C                   ENDIF                                                                CAP084
      *
      ** If JE Header record exists, update it.
      ** and reset flag BITUPD to show whether this is an update of an item                   CAP084
      *
     C     *IN01         IFEQ      *OFF
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     B2BINB        IFEQ      *ZERO                                                      CAP084
     C     WPlayBack     OREQ      'Y'                                                        CSC024
     C                   MOVE      'N'           BITUPD                                       CAP084
     C                   ELSE                                                                 CAP084
     C                   MOVE      'Y'           BITUPD                                       CAP084
     C                   ENDIF                                                                CAP084
     C                   ENDIF                                                                CAP084
     C                   EXSR      SRUpdRecord
     C                   ENDIF
      *
      ** Write JE Item record.
      *
     C     B2BINB        IFNE      *ZERO                                                      CAP084
      *                                                                                     MD020761
      ** Ensure update/delete is attempted only if JE Item was                              MD020761
      ** found previously                                                                   MD020761
     C     *IN91         ANDEQ     *OFF                                                     MD020761
      *                                                                                     MD020761
     C     JAVAUSER      ANDEQ     'Y'                                                        CAP084
     C     WPlayBack     ANDEQ     'N'                                                        CSC024
                                                                                              CAP084
      * Update Batch Item record if java user is editing an item                              CAP084
                                                                                              CAP084
      ** If CSC011 is installed, supply a Front Office ID for the                             CAP084
      ** transaction even if it originated from SIN module.                                   CAP084
                                                                                              CAP084
     C                   IF        CSC011 = 'Y'                                               CAP084
     C**********                   AND CGL125 = 'N'                                  CSC054 MD039859
     C                             AND CAP209 = 'N'                                         MD039859
     C                   IF        BTFRNT = *BLANKS                                           CAP084
     C                   EVAL      BTFRNT = 'MD' + BTBTNB                                     CAP084
     C                   ENDIF                                                                CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
                                                                                              CAP084
      ** Move Valid details into file details ready for update                                CAP084
                                                                                              CAP084
     C                   MOVE      BRBTNB        B2BTNB                                       CAP084
     C                   MOVE      BRBCDA        B2BCBH                                       239576
     C                   MOVEL     PVBITP        WJENP                                        CAP084
     C                   IF        WPdId > 0                                                MD020177
     C                   EVAL      BTPDID = WPdId                                          AR1093096
     C                   ENDIF                                                              MD020177
                                                                                              CAP084
     C     B2VALI        IFEQ      '*'                                                        CAP084
      *                                                                                       239466
      ** Delete presented cheques for debit postings where cheque is used                     239466
      *                                                                                       239466
     C                   IF        CRE019 = 'Y' AND BTDCIN = 'D'                              239466
     C                             AND BTCQNB <> *BLANKS                                      239466
     C                   EXSR      SrUpdateChq                                                239466
     C                   ENDIF                                                                239466
      *                                                                                       239466
     C                   DELETE    @BTREAK                                                    CAP084
     C                   ELSE                                                                 CAP084
     C                   UPDATE    @BTREAK                                                    CAP084
     C                   ENDIF                                                                CAP084
     C/COPY OFCPYSRCZ,CGL135_062                                                             CGL135A
      *                                                                                       246418
      ** CGL013 processing                                                                    246418
      *                                                                                       246418
     C     CGL013        IFEQ      'Y'                                                        246418
      *                                                                                       246418
     C     B2VALI        IFEQ      '*'                                                        246418
     C                   EVAL      B3ADI1 = *BLANKS                                           246418
     C                   EVAL      B3ADI2 = *BLANKS                                           246418
     C                   EVAL      B3ADI3 = *BLANKS                                           246418
     C                   EVAL      B3ADI4 = *BLANKS                                           246418
     C                   EVAL      B3ADI5 = *BLANKS                                           246418
     C                   EVAL      B3ADI6 = *BLANKS                                           246418
     C                   EVAL      B3AERI = *BLANKS                                           246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C                   EVAL      WBTNB = B2BTNB                                             246418
     C                   EVAL      WBINB = B2BINB                                             246418
      *                                                                                       CER030
     C                   EVAL      WBranch = B2IBCA                                           CER030
     C                   EVAL      WCNum = B2CUST                                             CER030
     C                   EVAL      WCurr = B2CYCD                                             CER030
     C                   EVAL      WACode = B2ACCD                                            CER030
     C                   EVAL      WASeq = B2ACSN                                             CER030
      *                                                                                       246418
     C                   CALL      'GL000185'                                                 246418
     C                   PARM      *BLANKS       PRetCodeIn                                   246418
     C                   PARM                    PPostDetails                                 246418
     C                   PARM      *BLANKS       PAdditional                                  246418
     C                   PARM      'U'           PMode                                        246418
     C                   PARM      '0'           PExit                                      BUG23742
     C                   PARM      '0'           PCancel                                    BUG23742
     C                   PARM                    PVBITPX                                      246418
     C                   PARM      'Y'           PApiMode                                     246418
     C                   PARM                    FldNamXAr                                    246418
     C                   PARM                    MsgIDXAr                                     246418
     C                   PARM                    MsgDtaXAr                                    246418
      *                                                                                       246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C/COPY WNCPYSRC,GLBITPDC10

     C                   IF        CER030 = 'Y'                                             BUG23742
      *                                                                                     BUG23742
     C                   EVAL      KPTDT = B2PTDT                                           BUG23742
     C                   EVAL      KBTNB = B2BTNB                                           BUG23742
     C                   EVAL      KITNB = B2BINB                                           BUG23742
      *                                                                                     BUG23742
     C     KJENX1        CHAIN     GLMNARL2                                                 BUG23742
      *                                                                                     BUG23742
     C                   IF        %FOUND()                                                 BUG23742
      *                                                                                     BUG23742
     C                   EVAL      BAPODT = B2PTDT                                          BUG23742
     C                   EVAL      BABANB = B2BTNB                                          BUG23742
     C                   EVAL      BAITNB = B2BINB                                          BUG23742
      *                                                                                     BUG23742
     C                   IF        GLVNAR = *BLANKS                                         BUG23742
     C                   DELETE    GLMNARD0                                                 BUG23742
     C                   ELSE                                                               BUG23742
     C                   EVAL      %SUBST(GLMNarFilFmt:9) = GLVNAR                          BUG23742
     C                   UPDATE    GLMNARD0                                                 BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ELSE                                                               BUG23742
      *                                                                                     BUG23742
     C**********         EVAL      WEX1 = %SUBST(GLVNAR:1:35)                      BUG23742 BUG24257
     C**********         EVAL      WEX2 = %SUBST(GLVNAR:36:70)                     BUG23742 BUG24257
      *                                                                                     BUG23742
     C**********         IF        WEX1 <> *BLANKS OR                              BUG23742 BUG24257
     C**********                   WEX2 <> *BLANKS                                 BUG23742 BUG24257
      *                                                                                     BUG24257
      ** Write record only when MTCash Narratives contain Data                              BUG24257
      *                                                                                     BUG24257
     C                   IF        GLVNAR <> *BLANKS                                        BUG24257
      *                                                                                     BUG23742
     C                   EVAL      BAPODT = B2PTDT                                          BUG23742
     C                   EVAL      BABANB = B2BTNB                                          BUG23742
     C                   EVAL      BAITNB = B2BINB                                          BUG23742
     C                   EVAL      %SUBST(GLMNarFilFmt:9) = GLVNAR                          BUG23742
     C                   WRITE     GLMNARD0                                                 BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                      BUG3036
      ** Update presented cheques for debit postings where cheque is used                    BUG3036
      ** except when cheque used has been previously presented                               BUG3036
      *                                                                                      BUG3036
     C                   IF        CRE019 = 'Y' AND BTDCIN = 'D'                             BUG3036
     C                             AND BTCQNB <> *BLANKS AND BTDUPC <> 'Y'                   BUG3036
     C                   EXSR      SrUpdateChq                                               BUG3036
     C                   ENDIF                                                               BUG3036
      *                                                                                      BUG3036
     C                   MOVE      'Y'           BITUPD            1                          CAP084
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
     C                   MOVE      'N'           BITUPD                                       CAP084
     C                   MOVE      BRBTNB        B2BTNB
     C                   MOVE      BRBCDA        B2BCBH                                       239576
     C**********         Z-ADD     BRHINC        B2BINB                                      BUG1898
                                                                                              CSC024
      ***If*from*OME*playback,*bypass*generation*of*batch*item*numbe                   CSC024 CSC054
      ** If from PEA playback, bypass generation of batch item number                         CSC054
                                                                                              CSC024
     C                   IF        WPlayBack = 'N'                                            CSC024
      *                                                                                      BUG1898
      ** Use GL0137U to get last batch item number used.                                     BUG1898
      *                                                                                      BUG1898
     C                   CALL      'GL0137U'                                                 BUG1898
     C                   PARM                    B2BTNB                                      BUG1898
     C                   PARM      *ZERO         LSBINB            3 0                       BUG1898
      *                                                                                      BUG1898
     C     LSBINB        ADD       1             B2BINB                                      BUG1898
     C                   ENDIF                                                                CSC024
      *                                                                                      BUG1898
     C/COPY WNCPYSRC,GLBITPDC05
     C                   MOVEL     PVBITP        WJENP                                        CAP084
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C*********                    AND CGL125 = 'N'                                  CSC054 MD039859
     C                             AND CAP209 = 'N'                                         MD039859
     C                   IF        BTFRNT = *BLANKS                                           CSC011
     C                   EVAL      BTFRNT = 'MD' + BTBTNB                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   EVAL      BTPDID = WPdId                                          AR1093096
      *
     C*******************WRITE     @BTREMG                                      CGL016
     C                   WRITE     @BTREMG                              91      CGL016
     C/COPY OFCPYSRCZ,CGL135_063                                                             CGL135A
      *                                                                                       239466
      ** Update presented cheques for debit postings where cheque is used                     239466
      ** except when cheque used has been previously presented                                239466
      *                                                                                       239466
     C                   IF        CRE019 = 'Y' AND BTDCIN = 'D'                              239466
     C                             AND BTCQNB <> *BLANKS AND BTDUPC <> 'Y'                    239466
     C                   EXSR      SrUpdateChq                                                239466
     C                   ENDIF                                                                239466
      *                                                                                       239466
      ** CGL013 processing                                                                    246418
      *                                                                                       246418
     C     CGL013        IFEQ      'Y'                                                        246418
      *                                                                                       246418
     C                   EVAL      WBTNB = B2BTNB                                             246418
     C                   EVAL      WBINB = B2BINB                                             246418
      *                                                                                     BUG22724
     C                   EVAL      WBranch = B2IBCA                                         BUG22724
     C                   EVAL      WCNum = B2CUST                                           BUG22724
     C                   EVAL      WCurr = B2CYCD                                           BUG22724
     C                   EVAL      WACode = B2ACCD                                          BUG22724
     C                   EVAL      WASeq = B2ACSN                                           BUG22724
      *                                                                                       246418
     C                   CALL      'GL000185'                                                 246418
     C                   PARM      *BLANKS       PRetCodeIn                                   246418
     C                   PARM                    PPostDetails                                 246418
     C                   PARM      *BLANKS       PAdditional                                  246418
     C                   PARM      'U'           PMode                                        246418
     C                   PARM      '0'           PExit                                      BUG23742
     C                   PARM      '0'           PCancel                                    BUG23742
     C                   PARM                    PVBITPX                                      246418
     C                   PARM      'Y'           PApiMode                                     246418
     C                   PARM                    FldNamXAr                                    246418
     C                   PARM                    MsgIDXAr                                     246418
     C                   PARM                    MsgDtaXAr                                    246418
      *                                                                                       246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C/COPY WNCPYSRC,GLBITPDC11
     C**********         ENDIF                                                   AR792734A MD033630A
      *                                                                                     BUG23742
     C                   IF        CER030 = 'Y'                                             BUG23742
      *                                                                                     BUG23742
     C                   EVAL      KPTDT = B2PTDT                                           BUG23742
     C                   EVAL      KBTNB = B2BTNB                                           BUG23742
     C                   EVAL      KITNB = B2BINB                                           BUG23742
      *                                                                                     BUG23742
     C     KJENX1        CHAIN     GLMNARL2                                                 BUG23742
      *                                                                                     BUG23742
     C                   IF        %FOUND()                                                 BUG23742
      *                                                                                     BUG23742
     C                   EVAL      BAPODT = B2PTDT                                          BUG23742
     C                   EVAL      BABANB = B2BTNB                                          BUG23742
     C                   EVAL      BAITNB = B2BINB                                          BUG23742
      *                                                                                     BUG23742
     C                   IF        GLVNAR = *BLANKS                                         BUG23742
     C                   DELETE    GLMNARD0                                                 BUG23742
     C                   ELSE                                                               BUG23742
     C                   EVAL      %SUBST(GLMNarFilFmt:9) = GLVNAR                          BUG23742
     C                   UPDATE    GLMNARD0                                                 BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ELSE                                                               BUG23742
      *                                                                                     BUG23742
     C**********         EVAL      WEX1 = %SUBST(GLVNAR:1:35)                      BUG23742 BUG24257
     C**********         EVAL      WEX2 = %SUBST(GLVNAR:36:70)                     BUG23742 BUG24257
      *                                                                                     BUG23742
     C**********         IF        WEX1 <> *BLANKS OR                              BUG23742 BUG24257
     C**********                   WEX2 <> *BLANKS                                 BUG23742 BUG24257
      *                                                                                     BUG24257
      ** Write record only when MTCash Narratives contain Data                              BUG24257
      *                                                                                     BUG24257
     C                   IF        GLVNAR <> *BLANKS                                        BUG24257
      *                                                                                     BUG23742
     C                   EVAL      BAPODT = B2PTDT                                          BUG23742
     C                   EVAL      BABANB = B2BTNB                                          BUG23742
     C                   EVAL      BAITNB = B2BINB                                          BUG23742
     C                   EVAL      %SUBST(GLMNarFilFmt:9) = GLVNAR                          BUG23742
     C                   WRITE     GLMNARD0                                                 BUG23742
      *                                                                                     BUG24257
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
      *                                                                          AR792734A MD033630A
     C**********         MOVE      'N'           T_REV                           AR792734A MD033630A
     C*****CRE023        Ifeq      'Y'                                            MD037061 MD033630A
     C*****BTTRTY        CHAIN     RETTYPL0                                       MD033630 MD033630A
     C**********         If        %FOUND(RETTYPL0)                               MD033630 MD033630A
     C**********         Move      'Y'           OUTWRD            1              MD033630 MD033630A
     C**********         Else                                                     MD033630 MD033630A
     C**********         Move      'N'           OUTWRD                           MD033630 MD033630A
     C**********         EndIf                                                    MD033630 MD033630A
     C**********         EndIf                                                    MD037061 MD033630A
      *                                                                          AR792734A MD033630A
     C*****PActnCde      IFNE      'I'                                           AR792734A MD033630A
     C*****PActnCde      ANDNE     ' '                                           AR792734A MD033630A
     C*****WPlayBack     ANDEQ     'N'                                           AR792734A MD033630A
     C*****CGL016        IFEQ      'Y'                                           AR792734A MD033630A
     C******IN91         ANDEQ     *OFF                                          AR792734A MD033630A
     C*****CRE023        OREQ      'Y'                                           AR792734A MD033630A
     C******IN91         ANDEQ     *OFF                                          AR792734A MD033630A
     C******OUTWRD        AndEQ     'Y'                                           MD033630 MD033630A
      *                                                                          AR792734A MD033630A
     C*****Cr_BTCUST     IFNE      BTCUST                                        AR792734A MD033630A
     C*****Cr_BTCYCD     ORNE      BTCYCD                                        AR792734A MD033630A
     C*****Cr_BTACCD     ORNE      BTACCD                                        AR792734A MD033630A
     C*****Cr_BTACSN     ORNE      BTACSN                                        AR792734A MD033630A
     C*****Cr_BTRACN     ORNE      BTRACN                                        AR792734A MD033630A
     C*****Cr_BTIBCA     ORNE      BTIBCA                                        AR792734A MD033630A
     C*****Cr_BTPTAM     ORNE      BTPTAM                                        AR792734A MD033630A
     C*****Cr_BTDCIN     ORNE      BTDCIN                                        AR792734A MD033630A
     C*****Cr_BTNRDC     ORNE      BTNRDC                                        AR792734A MD033630A
     C*****Cr_BTTRTY     ORNE      BTTRTY                                        AR792734A MD033630A
     C*****Cr_BTVLDT     ORNE      BTVLDT                                        AR792734A MD033630A
     C*****Cr_BTCQNB     ORNE      BTCQNB                                        AR792734A MD033630A
     C*****Cr_BTPTDT     ORNE      BTPTDT                                        AR792734A MD033630A
     C*****PActnCde      OREQ      'R'                                            AR792734A MD033630
     C*****PActnCde      OREQ      'D'                                            MD033630 MD033630A
      *                                                                          AR792734A MD033630A
     C*****SCKEY2        KLIST                                                   AR792734A MD033630A
     C**********         KFLD                    B2BTNB                          AR792734A MD033630A
     C**********         KFLD                    B2BINB                          AR792734A MD033630A
      *                                                                          AR792734A MD033630A
     C*****SCKEY2        CHAIN     @BTREAK                            99         AR792734A MD033630A
      *                                                                          AR792734A MD033630A
     C**********         CALL      'AOACCTR0'                                    AR792734A MD033630A
     C**********         PARM      *BLANKS       UUAPRC                          AR792734A MD033630A
     C**********         PARM      '*KEY'        UUAPOP                          AR792734A MD033630A
     C**********         PARM      *BLANKS       UUACID                          AR792734A MD033630A
     C**********         PARM                    BTCUST                          AR792734A MD033630A
     C**********         PARM                    BTCYCD                          AR792734A MD033630A
     C**********         PARM                    BTACCD                          AR792734A MD033630A
     C**********         PARM                    BTACSN                          AR792734A MD033630A
     C**********         PARM                    BTIBCA                          AR792734A MD033630A
     C*****D@ACCT        PARM      *BLANK        DSSDY                           AR792734A MD033630A
      *                                                                          AR792734A MD033630A
     C*****ATYP          IFEQ      'R'                                           AR792734A MD033630A
      *                                                                          AR792734A MD033630A
     C**********         MOVE      Cr_BTBTNB     LBTBTNB                         AR792734A MD033630A
     C**********         Z-ADD     Cr_BTBINB     LBTBINB                         AR792734A MD033630A
     C**********         MOVE      Cr_BTIBCA     LBTIBCA                         AR792734A MD033630A
     C**********         MOVE      Cr_BTCUST     LBTCUST                         AR792734A MD033630A
     C**********         MOVE      Cr_BTCYCD     LBTCYCD                         AR792734A MD033630A
     C**********         MOVE      Cr_BTACCD     LBTACCD                         AR792734A MD033630A
     C**********         MOVE      Cr_BTACSN     LBTACSN                         AR792734A MD033630A
     C**********         MOVE      Cr_BTNNBI     LBTNNBI                         AR792734A MD033630A
     C**********         Z-ADD     Cr_BTRACN     LBTRACN                         AR792734A MD033630A
     C**********         MOVE      Cr_BTRINO     LBTRINO                         AR792734A MD033630A
     C**********         MOVE      Cr_BTRINE     LBTRINE                         AR792734A MD033630A
     C**********         MOVE      Cr_BTTRTY     LBTTRTY                         AR792734A MD033630A
     C**********         Z-ADD     Cr_BTPTAM     LBTPTAM                         AR792734A MD033630A
      *                                                                          AR792734A MD033630A
     C*****Cr_BTDCIN     IFEQ      'C'                                           AR792734A MD033630A
     C**********         MOVE      'D'           LBTDCIN                         AR792734A MD033630A
     C**********         ELSE                                                    AR792734A MD033630A
     C**********         MOVE      'C'           LBTDCIN                         AR792734A MD033630A
     C**********         ENDIF                                                   AR792734A MD033630A
      *                                                                          AR792734A MD033630A
     C**********         Z-ADD     Cr_BTPTDT     LBTPTDT                         AR792734A MD033630A
     C**********         Z-ADD     Cr_BTVLDT     LBTVLDT                         AR792734A MD033630A
     C**********         MOVE      Cr_BTNVCD     LBTNVCD                         AR792734A MD033630A
     C**********         MOVE      Cr_BTNRDC     LBTNRDC                         AR792734A MD033630A
     C**********         MOVE      'RE'          LBTNRDC                         AR792734A MD033630A
     C**********         MOVE      Cr_BTACTY     LBTACTY                         AR792734A MD033630A
     C**********         MOVE      Cr_BTACNB     LBTACNB                         AR792734A MD033630A
     C**********         MOVE      Cr_BTCQNB     LBTCQNB                         AR792734A MD033630A
     C**********         MOVE      Cr_BTCOIN     LBTCOIN                         AR792734A MD033630A
     C**********         MOVE      Cr_BTSWCR     LBTSWCR                         AR792734A MD033630A
     C**********         MOVE      Cr_BTPRCN     LBTPRCN                         AR792734A MD033630A
     C**********         MOVE      Cr_BTBCBH     LBTBCBH                         AR792734A MD033630A
     C**********         MOVE      Cr_BTRADP     LBTRADP                         AR792734A MD033630A
     C**********         MOVE      Cr_BTSHPI     LBTSHPI                         AR792734A MD033630A
     C**********         Z-ADD     Cr_BTRRNM     LBTRRNM                         AR792734A MD033630A
     C**********         MOVE      Cr_BTRNBE     LBTRNBE                         AR792734A MD033630A
     C**********         MOVE      Cr_BTRARC     LBTRARC                         AR792734A MD033630A
     C**********         MOVE      Cr_BTTSTY     LBTTSTY                         AR792734A MD033630A
     C**********         MOVE      Cr_BTBKCD     LBTBKCD                         AR792734A MD033630A
     C**********         Z-ADD     Cr_BTSPFC     LBTSPFC                         AR792734A MD033630A
     C**********         MOVE      Cr_BTRVDI     LBTRVDI                         AR792734A MD033630A
     C**********         Z-ADD     Cr_BTNITM     LBTNITM                         AR792734A MD033630A
     C**********         MOVE      Cr_BTOCCY     LBTOCCY                         AR792734A MD033630A
     C**********         Z-ADD     Cr_BTOAMT     LBTOAMT                         AR792734A MD033630A
     C**********         MOVE      Cr_BTFRNT     LBTFRNT                         AR792734A MD033630A
     C**********         MOVE      Cr_BTAFRT     LBTAFRT                         AR792734A MD033630A
     C**********         MOVE      Cr_BTTMST     LBTTMST                         AR792734A MD033630A
     C**********         MOVE      Cr_BTVALI     LBTVALI                         AR792734A MD033630A
     C**********         MOVE      Cr_BTDUPC     LBTDUPC                         AR792734A MD033630A
     C**********         MOVE      Cr_BTOUTR     LBTOUTR                         AR792734A MD033630A
      *                                                                                    AR792734A
     C**********         CALL      'GL004446'                                    AR792734A MD033630A
     C**********         PARM      *Blanks       UUAPRC                          AR792734A MD033630A
     C**********         PARM                    LJENP                           AR792734A MD033630A
      *                                                                                    AR792734A
     C*****UUAPRC        IFNE      *BLANKS                                       AR792734A MD033630A
     C**********         EXSR      *PSSR                                         AR792734A MD033630A
     C**********         ELSE                                                    AR792734A MD033630A
     C**********         MOVE      'Y'           T_REV                           AR792734A MD033630A
     C**********         ENDIF                                                   AR792734A MD033630A
      *                                                                                    AR792734A
     C**********         ENDIF                                                   AR792734A MD033630A
     C**********         ENDIF                                                   AR792734A MD033630A
     C**********         ENDIF                                                   AR792734A MD033630A
     C**********         ENDIF                                                   AR792734A MD033630A
      *                                                                                    AR792734A
     C*****B2BINB        IFEQ      *ZERO                                         AR792734A MD033630A
     C*****JAVAUSER      ORNE      'Y'                                           AR792734A MD033630A
     C*****WPlayBack     ORNE      'N'                                           AR792734A MD033630A
     C*****T_REV         OREQ      'Y'                                           AR792734A MD033630A
     C*****PActnCde      ANDEQ     'A'                                           AR792734A MD033630A
     C*****PActnCde      OREQ      'I'                                           AR792734A MD033630A
      *                                                                         CGL016
B1   C     CGL016        IFEQ      'Y'                                          CGL016
     C     *IN91         ANDEQ     *OFF                                         CGL016
     C*****CRE023        OREQ      'Y'                                           AR792734A MD033630A
     C******IN91         ANDEQ     *OFF                                          AR792734A MD033630A
     C*****OUTWRD        AndEQ     'Y'                                            MD033630 MD033630A
      *                                                                         CGL016
     C     SCKEY         KLIST                                                  CGL016
     C                   KFLD                    B2BTNB                         CGL016
     C                   KFLD                    B2BINB                         CGL016
      *                                                                         CGL016
     C     SCKEY         CHAIN     @BTREAK                            99        CGL016
      *                                                                         CGL016
     C                   CALL      'AOACCTR0'                                   CGL016
     C                   PARM      *Blanks       UUAPRC            7            CGL016
     C                   PARM      '*KEY'        UUAPOP            7            CGL016
     C                   PARM      *BLANKS       UUACID           10            CGL016
     C                   PARM                    BTCUST            6            CGL016
     C                   PARM                    BTCYCD            3            CGL016
     C**********         PARM                    BTACCD            4                   CGL016 CGL029
     C                   PARM                    BTACCD           10                          CGL029
     C                   PARM                    BTACSN            2            CGL016
     C                   PARM                    BTIBCA            3            CGL016
     C     D@ACCT        PARM      *BLANK        DSSDY                          CGL016
      *                                                                         CGL016
      * Accessing end date                                                      CGL016
      *                                                                         CGL016
B2   C     ATYP          IFEQ      'R'                                          CGL016
     C                   MOVE      BTBTNB        LBTBTNB                                     BUG1738
     C                   Z-ADD     BTBINB        LBTBINB                                     BUG1738
     C                   MOVE      BTIBCA        LBTIBCA                                     BUG1738
     C                   MOVE      BTCUST        LBTCUST                                     BUG1738
     C                   MOVE      BTCYCD        LBTCYCD                                     BUG1738
     C                   MOVE      BTACCD        LBTACCD                                     BUG1738
     C                   MOVE      BTACSN        LBTACSN                                     BUG1738
     C                   MOVE      BTNNBI        LBTNNBI                                     BUG1738
     C                   Z-ADD     BTRACN        LBTRACN                                     BUG1738
     C                   MOVE      BTRINO        LBTRINO                                     BUG1738
     C                   MOVE      BTRINE        LBTRINE                                     BUG1738
     C                   MOVE      BTTRTY        LBTTRTY                                     BUG1738
     C                   Z-ADD     BTPTAM        LBTPTAM                                     BUG1738
     C                   MOVE      BTDCIN        LBTDCIN                                     BUG1738
     C                   Z-ADD     BTPTDT        LBTPTDT                                     BUG1738
     C                   Z-ADD     BTVLDT        LBTVLDT                                     BUG1738
     C                   MOVE      BTNVCD        LBTNVCD                                     BUG1738
     C                   MOVE      BTNRDC        LBTNRDC                                     BUG1738
     C                   MOVE      BTACTY        LBTACTY                                     BUG1738
     C                   MOVE      BTACNB        LBTACNB                                     BUG1738
     C                   MOVE      BTCQNB        LBTCQNB                                     BUG1738
     C                   MOVE      BTCOIN        LBTCOIN                                     BUG1738
     C                   MOVE      BTSWCR        LBTSWCR                                     BUG1738
     C                   MOVE      BTPRCN        LBTPRCN                                     BUG1738
     C                   MOVE      BTBCBH        LBTBCBH                                     BUG1738
     C                   MOVE      BTRADP        LBTRADP                                     BUG1738
     C                   MOVE      BTSHPI        LBTSHPI                                     BUG1738
     C                   Z-ADD     BTRRNM        LBTRRNM                                     BUG1738
     C                   MOVE      BTRNBE        LBTRNBE                                     BUG1738
     C                   MOVE      BTRARC        LBTRARC                                     BUG1738
     C                   MOVE      BTTSTY        LBTTSTY                                     BUG1738
     C                   MOVE      BTBKCD        LBTBKCD                                     BUG1738
     C                   Z-ADD     BTSPFC        LBTSPFC                                     BUG1738
     C                   MOVE      BTRVDI        LBTRVDI                                     BUG1738
     C                   Z-ADD     BTNITM        LBTNITM                                     BUG1738
     C                   MOVE      BTOCCY        LBTOCCY                                     BUG1738
     C                   Z-ADD     BTOAMT        LBTOAMT                                     BUG1738
     C                   MOVE      BTFRNT        LBTFRNT                                     BUG1738
     C                   MOVE      BTAFRT        LBTAFRT                                     BUG1738
     C                   MOVE      BTTMST        LBTTMST                                     BUG1738
     C                   MOVE      BTVALI        LBTVALI                                     BUG1738
     C                   MOVE      BTDUPC        LBTDUPC                                     BUG1738
     C                   MOVE      BTOUTR        LBTOUTR                                     BUG1738
      *                                                                         CGL016
     C                   CALL      'GL004446'                                   CGL016
     C                   PARM      *Blanks       UUAPRC                         CGL016
     C*********          PARM                    WJENP                          CGL016       BUG1738
     C                   PARM                    LJENP                          CGL016       BUG1738
      *                                                                         CGL016
     C     UUAPRC        IFNE      *BLANKS                                      CGL016
     C                   EXSR      *pssr                                        CGL016
     C                   ENDIF                                                  CGL016
      *                                                                         CGL016
     C                   MOVE      'Y'           BTSHPI                         CGL016
      *                                                                         CGL016
E2   C                   ENDIF                                                  CGL016
      *                                                                         CGL016
E1   C     *IN99         IFEQ      *OFF                                         CGL016
     C                   UPDATE    @BTREAK                                      CGL016
      *                                                                                       CRE019
      ** Update presented cheques for debit postings where cheque is used                     CRE019
      ** except when cheque used has been previously presented                                CRE019
      *                                                                                       CRE019
     C                   IF        CRE019 = 'Y' AND BTDCIN = 'D'                              CRE019
     C                             AND BTCQNB <> *BLANKS AND BTDUPC <> 'Y'                    CRE019
     C                   EXSR      SrUpdateChq                                                CRE019
     C                   ENDIF                                                                CRE019
E1   C                   ENDIF                                                  CGL016
      *                                                                         CGL016
E1   C                   ENDIF                                                  CGL016
     C**********         ENDIF                                                   AR792734A MD033630A
      *                                                                         CGL016
     C/COPY WNCPYSRC,GLBITPDC12
     C**********         ENDIF                                                      CAP084 AR792734A
     C                   ENDIF                                                             MD033630A
      *
      ** Update Currency Totals file GLJENSPD.
      *
     C                   EXSR      SRUpdateCcy
                                                                                              CSC011
      ** If CSC011 is on and program is running in the support system,                        CSC011
      ** convert JE item details in file format to screen format                              CSC011
      ** before writing to AP log file.                                                       CSC011
     C                   IF        CSC011 = 'Y' AND S1SUPP = LIBR                             CSC011
                                                                                              CSC011
     C                   CLEAR                   ReturnCode                                   CSC011
     C                   EXSR      SRCONVERT                                                  CSC011
      ** If there are no errors in conversion, proceed with writing to                        CSC011
      ** API log file.                                                                        CSC011
     C                   IF        ReturnCode = *BLANKS                                       CSC011
     C                   EXSR      SRAPILOG                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,GLBITPDC01
      *                                                                                       CRE023
      ** Execute SRUpdTwoClk if CRE023 is on                                                  CRE023
      *                                                                                       CRE023
     C**********         IF        CRE023 = 'Y'                                      CRE023 MD036967
     C                   IF        CRE023 = 'Y' AND CAP207='N'                              MD036967
     C                             OR CRE023='Y' AND CAP207='Y'                             MD036967
     C                             AND BTDCIN = 'D'                                         MD036967
     C                   EXSR      SRUpdTwoClk                                                CRE023
     C                   ENDIF                                                                CRE023
      *
      ** Exit from program.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrtRecord - Write New JE Header                            *
      *                                                               *
      *****************************************************************
      *
     C     SRWrtRecord   BEGSR
     C/COPY WNCPYSRC,GLH00052
      *
      ** Get next available batch number.
      *
     C                   CALLB     'ZAGENBTCHN'
     C                   PARM                    PErrorFlag        1
     C                   PARM                    PBTNB             3
     C/COPY WNCPYSRC,GLH00459
      *
     C     PErrorFlag    IFEQ      'Y'
     C                   MOVEL     B2FRNT        DBKEY
     C                   MOVEL(P)  'GLJENHPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      SRERR
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00053
      *
      ** Reset JE Header data structure.
      *
     C                   CLEAR                   WJENH
      *
      ** Numeric fields within WJENH have to be reset explicitly as
      ** there are long alpha fields overlapping these which cause
      ** the CLEAR to put blanks in the numeric fields.
      *
     C                   Z-ADD     *ZERO         BRHICC
     C                   Z-ADD     *ZERO         BRHDCC
     C                   Z-ADD     *ZERO         BRHINC
     C                   Z-ADD     *ZERO         BRHIIN
     C                   Z-ADD     *ZERO         BRHDIN
     C                   Z-ADD     *ZERO         BRHINI
     C                   Z-ADD     *ZERO         BRSPTT
     C                   Z-ADD     *ZERO         BRNIST
     C                   Z-ADD     *ZERO         BRRACF
     C                   Z-ADD     *ZERO         BRAMTF
     C                   Z-ADD     *ZERO         BRRACT
      *
      ** Create a dummy record to JE Headers file GLJENHPD.
      *
     C/COPY WNCPYSRC,GLBITPDC02
     C                   MOVE      PBTNB         BRBTNB
     C/COPY WNCPYSRC,GLH00054
     C                   MOVE      B2IBCA        BRBCDA
     C                   MOVE      B2IBCA        BRIBCF
     C                   MOVE      *BLANKS       BRDPCD
     C                   MOVE      *BLANKS       BRWSID
      *
      ** Add posting amount to Hash Amount calculated.
      *
     C                   EXSR      SRPostAmt
      *
     C                   Z-ADD     WHASH         BRHICC
     C                   Z-ADD     WDEC03        BRHDCC
      *
      ** Reset Hash Item No. calculated to 1.
      *
     C                   Z-ADD     1             BRHINC
      *
     C                   MOVE      *ALL'9'       BRHIIN
     C                   MOVE      *ALL'9'       BRHDIN
     C                   MOVE      *ALL'9'       BRHINI
      *
     C                   MOVE      'Y'           BRBIUF
     C                   If        JAVAUSER = 'Y'                                            BUG7332
     C                   MOVE      USRID         BRWSID                                     BUG1175R
     C                   EndIf                                                               BUG7332
     C                   MOVE      'H'           BRBTSF
     C                   MOVE      B2VALI        BRVALI
     C                   MOVE      B2TMST        BRTMST
     C                   MOVE      'N'           BRMBRB
     C                   MOVE      B2FRNT        BRFRNT
     C                   MOVE      B2FRNT        BRBDES
     C                   MOVE      'H'           BRBHAI
     C                   MOVE      'I'           BRTOJE
      *
      ** If Security on Journal Entry is *ON, set Last Insert
      ** User field to system user.
      *
     C     CGL008        IFEQ      'Y'
     C                   MOVE      PSUser        BRUSRI
     C                   ENDIF
      *                                                                         186206
      ** Write to Today's batch numbers used                                    186206
      *                                                                         186206
     C/COPY WNCPYSRC,GLH00712
     C                   MOVEL     BRBTNB        B3BTNB                         186206
     C                   MOVEL     'N'           B3DUMP                         186206
     C                   WRITE     GLBTNOD0                             60      186206
     C                   IF        *IN60 = *ON                                  186206
     C                   MOVEL     BRBTNB        DBKEY                          186206
     C                   MOVEL(P)  'GLBTNOPD'    DBFILE                         186206
     C                   Z-ADD     004           DBASE                          186206
     C                   EXSR      SRERR                                        186206
     C                   ENDIF                                                  186206
                                                                                              CSC011
     C/COPY WNCPYSRC,GLH00713
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C**********                   AND CGL125 = 'N'                                  CSC054 MD039859
     C                             AND CAP209 = 'N'                                         MD039859
     C                   IF        BRFRNT = *BLANKS                                           CSC011
     C                   EVAL      BRFRNT = 'MD' + BRBTNB                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      *
     C                   WRITE     @BRREMA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdRecord - Update JE Header                               *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdRecord   BEGSR
      *
      ** Record already exists but Batch in Use is not 'Y',
      ** Batch Status is not 'H' and Workstation Id is not
      ** blanks.
      *
     C     BRBIUF        IFNE      'Y'
     C     JAVAUSER      ANDEQ     'N'                                                        CAP084
     C     CGL148        andeq     'N'                                                        CGL148
     C     BRBTSF        ORNE      'H'
     C     CGL182        ANDEQ     'N'                                                        CGL182
     C     BRWSID        ORNE      *BLANKS
     C     JAVAUSER      ANDEQ     'N'                                                        CAP084
     C     BRBTSF        ORNE      'H'                                                        CGL182
     C     BRBTSF        ANDNE     'P'                                                        CGL182
     C     CGL182        ANDEQ     'Y'                                                        CGL182
      *
     C                   MOVEL     B2FRNT        DBKEY
     C                   MOVEL(P)  'GLJENHPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     BRIBCF        IFEQ      *BLANKS
     C                   MOVE      B2IBCA        BRIBCF
     C                   ENDIF
      *
      ** If Branch Code in JE Header record is different
      ** from Input Branch Code of JE Item, then flag batch
      ** as Multiple Branch batch.
      *
     C     BRIBCF        IFNE      B2IBCA
     C                   MOVE      '***'         BRIBCF
     C                   ENDIF
      *
      ** Add posting amount to Hash Amount calculated.
      *
     C                   EXSR      SRPostAmt
      *
     C                   Z-ADD     BRHDCC        WINT15
      *                                                                                       CAP084
      ** If it's a delete of an item then reduce the totals, else add to them...              CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     B2VALI        ANDEQ     '*'                                                        CAP084
     C     B2BINB        ANDNE     *ZERO                                                      CAP084
                                                                                              CAP084
     C**********         ADD       WINT03        WDEC09                               CAP084 BUG4185
     C                   SUB       WDEC09        WINT03                                      BUG4185
      *                                                                                       CAP084
      ** Sub the carry over to Hash Integer Calculated.                                       CAP084
      *                                                                                       CAP084
     C                   ADD       WDEC06        WHASH                                        CAP084
      *                                                                                       CAP084
      ** Save computed values to file fields.                                                 CAP084
      *                                                                                       CAP084
     C                   SUB       WHASH         BRHICC                                       CAP084
     C**********         Z-SUB     WDEC03        BRHDCC                              CAP084  BUG4185
     C                   Z-ADD     WINT15        BRHDCC                                      BUG4185
      *                                                                                      BUG4185
      * If the calculated decimal hash is negative, subtract 1 from                          BUG4185
      * the calculated integer hash and add it to the decimal hash                           BUG4185
     C                   If        BRHDCC < 0                                                BUG4185
     C                   Sub       1             BRHICC                                      BUG4185
     C                   Add       1000          BRHDCC                                      BUG4185
     C                   EndIf                                                               BUG4185
      *                                                                                       CAP084
      ** Reduce Hash Item No. calculated by 1.                                                CAP084
      *                                                                                       CAP084
     C                   SUB       1             BRHINC                                       CAP084
                                                                                              CGL148
     C     CGL148        Ifeq      'Y'                                                        CGL148
     C                   z-add     BRHINC        BRHINI                                       CGL148
     C                   Endif                                                                CGL148
                                                                                              CAP084
      ** Else Add to the totals....                                                           CAP084
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
      *
      ** Add Hash Decimal Calculated to posting amount.
      *
     C                   ADD       WINT03        WDEC09
      *
      ** Add the carry over to Hash Integer Calculated.
      *
     C                   ADD       WDEC06        WHASH
      *
      ** Save computed values to file fields.
      *
     C                   ADD       WHASH         BRHICC
     C                   Z-ADD     WDEC03        BRHDCC
      *
      ** Increment Hash Item No. calculated by 1.
      *
     C                   ADD       1             BRHINC
                                                                                              CGL148
     C     CGL148        Ifeq      'Y'                                                        CGL148
     C     JAVAUSER      ANDEQ     'Y'                                                      MD025083
     C                   z-add     BRHINC        BRHINI                                       CGL148
     C                   Endif                                                                CGL148
      *                                                                                       CAP084
      ** If it is an update then delete the original amount from the calculated               CAP084
      ** amount as the new amount has now been added to it.                                   CAP084
      *                                                                                       CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     B2BINB        ANDNE     *ZEROS                                                     CAP084
      ** provided that record was found                                                     MD047741
     C     *IN91         ANDEQ     *OFF                                                     MD047741
     C     WPlayBack     ANDEQ     'N'                                                        CSC024
     C                   Z-ADD     *ZERO         WINT15                                       CAP084
     C                   Z-ADD     *ZERO         WDEC09                                       CAP084
     C                   Z-ADD     *ZERO         WHASH                                        CAP084
      *                                                                                       CAP084
      ** Get currency's no. of decimal places.                                                CAP084
      *                                                                                       CAP084
     C                   CALLB     'AOCURRR0'                                                 CAP084
     C                   PARM      *BLANKS       PRETC             7                          CAP084
     C                   PARM      '*KEY   '     POPTN             7                          CAP084
     C                   PARM      CYCDJV        PKCYCD            3                          CAP084
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP084
      *                                                                                       CAP084
     C     PRETC         IFEQ      *BLANKS                                                    CAP084
     C                   Z-ADD     A6NBDP        WNBDP                                        CAP084
     C                   ELSE                                                                 CAP084
     C                   Z-ADD     *ZERO         WNBDP                                        CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   Z-ADD     PTAMJV        WINT15                                       CAP084
     C                   MLLZO     '0'           WINT15                                       CAP084
     C                   SELECT                                                               CAP084
      *                                                                                       CAP084
     C     WNBDP         WHENEQ    *ZERO                                                      CAP084
     C                   ADD       WINT15        WHASH                                        CAP084
      *                                                                                       CAP084
     C     WNBDP         WHENEQ    1                                                          CAP084
     C                   ADD       WINT14        WHASH                                        CAP084
     C                   ADD       WINT01        WDEC09                                       CAP084
                                                                                              CAP084
     C     WNBDP         WHENEQ    2                                                          CAP084
     C                   ADD       WINT13        WHASH                                        CAP084
     C                   ADD       WINT02        WDEC09                                       CAP084
                                                                                              CAP084
     C     WNBDP         WHENEQ    3                                                          CAP084
     C                   ADD       WINT12        WHASH                                        CAP084
     C                   ADD       WINT03        WDEC09                                       CAP084
     C                   ENDSL                                                                CAP084
                                                                                              CAP084
     C                   Z-ADD     BRHDCC        WINT15                                       CAP084
      *                                                                                       CAP084
      ***Add*Hash*Decimal*Calculated to posting amount.                               CAP084 BUG4185
      ** Sub the posting amount from the Hash Decimal Calculated.                            BUG4185
      *                                                                                       CAP084
     C**********         ADD       WINT03        WDEC09                               CAP084 BUG4185
     C                   SUB       WDEC09        WINT03                                      BUG4185
      *                                                                                       CAP084
      ***Add*the*carry over to Hash Integer Calculated.                               CAP084 BUG4185
      **********                                                                      CAP084 BUG4185
     C**********         ADD       WDEC06        WHASH                                CAP084 BUG4185
      *                                                                                       CAP084
      ** Save computed values to file fields.                                                 CAP084
      *                                                                                       CAP084
     C                   SUB       WHASH         BRHICC                                       CAP084
     C**********         Z-SUB     WDEC03        BRHDCC                               CAP084 BUG4185
     C                   SUB       WDEC03        BRHDCC                                      BUG4185
      *                                                                                      BUG4185
      * If the calculated decimal hash is negative, subtract 1 from                          BUG4185
      * the calculated integer hash and add it to the decimal hash                           BUG4185
     C                   If        BRHDCC < 0                                                BUG4185
     C                   Sub       1             BRHICC                                      BUG4185
     C                   Add       1000          BRHDCC                                      BUG4185
     C                   EndIf                                                               BUG4185
      *                                                                                       CAP084
      ** Reduce Hash Item No. calculated by 1.                                                CAP084
      *                                                                                       CAP084
     C                   SUB       1             BRHINC                                       CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
     C                   ENDIF                                                                CAP084
      *
     C     B2VALI        IFEQ      'N'
     C                   MOVE      'N'           BRVALI
     C                   ENDIF
      *
      ** For Java users, reset batch in use flag if number of items                           CAP084
      ** input is equal or less than the number of items calculated                           CAP084
      ** as all entries for the batch have been received                                      CAP084
      *                                                                                       CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     BITUPD        ANDEQ     'Y'                                                        CAP084
     C     JAVAUSER      OREQ      'Y'                                                    AR1027164A
     C*****CGL125        ANDEQ     'Y'                                           AR1027164A MD039859
     C     CAP209        ANDEQ     'Y'                                                      MD039859
     C     BRFRNT        ANDNE     *BLANKS                                                AR1027164A
     C     BRHINI        ANDLE     BRHINC                                                 AR1027164A
     C                   MOVE      *BLANKS       BRBIUF                                       CAP084
     C                   EVAL      BRWSID = *blanks                                         BUG1175R
     C                   ENDIF                                                                CAP084
      *                                                                                     MD043023
      ** If batch is auto-authorized and number of items calculated is now greater than     MD043023
      ** number of items input, reject batch item as batch is being authorized.             MD043023
     C     BRAUTH        IFEQ      'Y'                                                      MD043023
     C     BRHINC        ANDGT     BRHINI                                                   MD043023
     C                   EVAL      PRTCD = 'GLX1005'                                        MD043023
     C                   EVAL      *INLR = *ON                                              MD043023
     C                   RETURN                                                             MD043023
     C                   ENDIF                                                              MD043023
      *                                                                                     MD043023
      *                                                                                      BUG3085
      ** If Security on Journal Entry is *ON, set Last Amend                                 BUG3085
      ** User field to system user.  Use correct user field if java user                     BUG3085
      *                                                                                      BUG3085
     C     CGL008        IFEQ      'Y'                                                       BUG3085
     C     JAVAUSER      IFEQ      'Y'                                                       BUG3085
     C                   MOVE      USRID         BRUSRA                                      BUG3085
     C                   ELSE                                                                BUG3085
     C                   MOVE      PSUser        BRUSRA                                      BUG3085
     C                   ENDIF                                                               BUG3085
     C                   ENDIF                                                               BUG3085
      *                                                                                       CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     B2BTNB        ANDNE     *BLANKS                                                 AR1027164
     C                   UPDATE    @BRREAG                                                    CAP084
     C                   ELSE                                                                 CAP084
     C                   UPDATE    @BRREMA
     C                   ENDIF                                                                CAP084
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPostAmt - Get Posting Amount                               *
      *                                                               *
      *****************************************************************
      *
     C     SRPostAmt     BEGSR
      *
     C                   Z-ADD     *ZERO         WINT15
     C                   Z-ADD     *ZERO         WDEC09
     C                   Z-ADD     *ZERO         WHASH
      *
      ** Get currency's no. of decimal places.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRETC             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      B2CYCD        PKCYCD            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRETC         IFEQ      *BLANKS
     C                   Z-ADD     A6NBDP        WNBDP
     C                   ELSE
     C                   Z-ADD     *ZERO         WNBDP
     C                   ENDIF
      *
     C                   Z-ADD     B2PTAM        WINT15
     C                   MLLZO     '0'           WINT15
      *
     C                   SELECT
      *
     C     WNBDP         WHENEQ    *ZERO
     C                   ADD       WINT15        WHASH
      *
     C     WNBDP         WHENEQ    1
     C                   ADD       WINT14        WHASH
     C                   ADD       WINT01        WDEC09
      *
     C     WNBDP         WHENEQ    2
     C                   ADD       WINT13        WHASH
     C                   ADD       WINT02        WDEC09
      *
     C     WNBDP         WHENEQ    3
     C                   ADD       WINT12        WHASH
     C                   ADD       WINT03        WDEC09
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  CRE019
      *****************************************************************                       CRE019
      *                                                               *                       CRE019
      *  SrUpdateChq - Updates Cheque book file                       *                       CRE019
      *                                                               *                       CRE019
      *****************************************************************                       CRE019
      *                                                                                       CRE019
     C     SrUpdateChq   BEGSR                                                                CRE019
      *                                                                                       CRE019
     C                   IF        B2VALI = '*'                                               239466
     C                   EXSR      SrChkDup                                                   257489
     C                   EXSR      SrDeleteChq                                                239466
      *                                                                                       239466
     C                   ELSE                                                                 239466
      *                                                                                       239466
     C     KCHQBK        KLIST                                                                CRE019
     C                   KFLD                    KACNO            10 0                        CRE019
     C                   KFLD                    KGCIN             1 0                        CRE019
     C                   KFLD                    KSCQN             8 0                        CRE019
      *                                                                                       CRE019
     C     KCHQB2        KLIST                                                                CRE019
     C                   KFLD                    KACNO                                        CRE019
     C                   KFLD                    KGCIN                                        CRE019
      *                                                                                       CRE019
     C     KCHQTR        KLIST                                                                CRE019
     C                   KFLD                    KACNTR           10 0                        CRE019
     C                   KFLD                    KGCITR            1 0                        CRE019
     C                   KFLD                    KSQNTR            8 0                        CRE019
      *                                                                                       CRE019
     C                   MOVE      BTCQNB        KSCQN                                        CRE019
     C                   EVAL      KGCIN = 0                                                  CRE019
     C                   IF        BTRACN = 0                                                 CRE019
     C                   EVAL      KACNO = ACNO                                               CRE019
     C                   ELSE                                                                 CRE019
     C                   EVAL      KACNO = BTRACN                                             CRE019
     C                   ENDIF                                                                CRE019
      *                                                                                       CRE019
     C                   OPEN      CHQBKL1                                                    CRE019
     C     KCHQBK        SETGT     CHQBKPDF                                                   CRE019
     C     KCHQB2        READPE    CHQBKPDF                               43                  CRE019
      *                                                                                       CRE019
     C                   IF        SCQN <= KSCQN AND KSCQN <= ECQN                            CRE019
      *                                                                                       CRE019
     C                   Eval      BTOUTR = 'N'                                             MD034050
     C                   MOVE      RECID         WKRECID           1                        MD032083
     C                   Z-ADD     KSCQN         WSCQN             8 0                        CRE019
     C     WSCQN         SUB       SCQN          WOFSET            8 0                        CRE019
     C     WOFSET        DIV       8             WI                2 0                        CRE019
     C                   MVR                     WBITN             1 0                        CRE019
     C                   EVAL      WI = WI + 1                                                CRE019
      *                                                                                       CRE019
      ** Set the correct bit representing the cheque number presented                         CRE019
      *                                                                                       CRE019
     C                   MOVEA     CQPS          WAR                                          CRE019
     C                   SELECT                                                               CRE019
     C                   WHEN      WBITN = 0                                                  CRE019
     C                   BITON     '0'           WAR(WI)                                      CRE019
     C                   WHEN      WBITN = 1                                                  CRE019
     C                   BITON     '1'           WAR(WI)                                      CRE019
     C                   WHEN      WBITN = 2                                                  CRE019
     C                   BITON     '2'           WAR(WI)                                      CRE019
     C                   WHEN      WBITN = 3                                                  CRE019
     C                   BITON     '3'           WAR(WI)                                      CRE019
     C                   WHEN      WBITN = 4                                                  CRE019
     C                   BITON     '4'           WAR(WI)                                      CRE019
     C                   WHEN      WBITN = 4                                                  CRE019
     C                   BITON     '4'           WAR(WI)                                      CRE019
     C                   WHEN      WBITN = 5                                                  CRE019
     C                   BITON     '5'           WAR(WI)                                      CRE019
     C                   WHEN      WBITN = 6                                                  CRE019
     C                   BITON     '6'           WAR(WI)                                      CRE019
     C                   WHEN      WBITN = 7                                                  CRE019
     C                   BITON     '7'           WAR(WI)                                      CRE019
     C                   ENDSL                                                                CRE019
     C                   MOVEA     WAR           CQPS                                         CRE019
     C                   ENDIF                                                                CRE019
      *                                                                                       CRE019
      ** Generate next trnsaction number                                                      CRE019
      *                                                                                       CRE019
     C     *DTAARA       DEFINE    MNATN         DNATN                                        CRE019
     C     *LOCK         IN        DNATN                                                      CRE019
     C                   MOVE      FNATN         WNATN             5 0                        CRE019
     C                   MOVE      FNATN         WWRK5             5 0                        CRE019
     C                   EVAL      WWRK5 = WWRK5 + 1                                          CRE019
     C                   MOVE      WWRK5         FNATN                                        CRE019
     C                   OUT       DNATN                                                      CRE019
      *                                                                                       CRE019
      ** For out of range cheques, write new record in CHQBKPD                                CRE019
      *                                                                                       CRE019
     C                   IF        BTOUTR = 'Y'                                               CRE019
     C                   EVAL      RECID = 'D'                                                CRE019
     C                   MOVE      BTRACN        ACNO                                         CRE019
     C                   EVAL      GCQI = 0                                                   CRE019
     C                   MOVE      BTCQNB        SCQN                                         CRE019
     C                   EVAL      NOCQ = 1                                                   CRE019
     C                   MOVE      BTCQNB        ECQN                                         CRE019
     C                   EVAL      DISS = BTVLDT                                              CRE019
     C                   EVAL      DCOL = BTVLDT                                              CRE019
     C                   EVAL      BRCA = BTIBCA                                              CRE019
     C                   EVAL      LCD = AGRDNB                                               CRE019
     C                   EVAL      CHTP = 'I'                                                 CRE019
     C                   EVAL      TNLU = WNATN                                               CRE019
     C                   CLEAR                   CHAM                                         CRE019
     C                   CLEAR                   CHAC                                         CRE019
     C                   EVAL      LCD = AGRDNB                                               CRE019
     C                   EVAL      OUTR = BTOUTR                                              CRE019
     C                   CLEAR                   CHTT                                         CRE019
     C                   CLEAR                   W1                2 0                        CRE019
     C                   DO        20                                                         CRE019
     C                   EVAL      W1 = W1 +1                                                 CRE019
     C                   BITON     '01234567'    WAR(W1)                                      CRE019
     C                   BITOFF    '01234567'    WAR(W1)                                      CRE019
     C                   ENDDO                                                                CRE019
     C                   BITON     '0'           WAR(1)                                       CRE019
     C                   MOVEA     WAR           CQPS                                         CRE019
     C                   IF        WKRECID = '*'                                            MD032083
     C                   UPDATE    CHQBKPDF                                                 MD032083
     C                   ELSE                                                               MD032083
     C                   WRITE     CHQBKPDF                                                   CRE019
     C                   ENDIF                                                              MD032083
      *                                                                                       CRE019
      ** Update the trailer file as well                                                      CRE019
      *                                                                                       CRE019
     C                   MOVE      *ALL'9'       KACNTR                                       CRE019
     C                   EVAL      KGCITR = 9                                                 CRE019
     C                   MOVE      *ALL'9'       KSQNTR                                       CRE019
     C     KCHQTR        CHAIN     CHQBKPTF                           70                      CRE019
     C                   IF        *IN70 = *ON                                                CRE019
     C     *LOCK         IN        LDA                                                        CRE019
     C                   EVAL      DBFILE = 'CHQBKPT'                                         CRE019
     C                   EVAL      DBASE = 8                                                  CRE019
     C                   MOVE      *ALL'9'       DBKEY                                        CRE019
     C                   OUT       LDA                                                        CRE019
     C                   ELSE                                                                 CRE019
     C                   EVAL      NORE = NORE + 1                                            CRE019
     C                   EVAL      LCD = AGRDNB                                               CRE019
     C                   EVAL      CHTP = 'A'                                                 CRE019
     C                   EVAL      TNLU = WNATN                                               CRE019
     C                   UPDATE    CHQBKPTF                                                   CRE019
     C                   ENDIF                                                                CRE019
      *                                                                                       CRE019
      ** Otherwise, update the record                                                         CRE019
      *                                                                                       CRE019
     C                   ELSE                                                                 CRE019
     C                   EVAL      TNLU = WNATN                                               CRE019
     C                   EVAL      CHTP = 'A'                                                 CRE019
     C                   EVAL      LCD = AGRDNB                                               CRE019
     C                   UPDATE    CHQBKPDF                                                   CRE019
     C                   ENDIF                                                                CRE019
      *                                                                                       CRE019
     C                   CLOSE     CHQBKL1                                                    CRE019
      *                                                                                       239466
     C                   ENDIF                                                                239466
      *                                                                                       239466
     C                   ENDSR                                                                CRE019
      *                                                                                       CRE019
      *****************************************************************                       CRE019
      *                                                               *                       257489
      *  SrChkDup - Checks for duplicate cheque transaction           *                       257489
      *                                                               *                       257489
      *****************************************************************                       257489
      *                                                                                       257489
     C     SrChkDup      BEGSR                                                                257489
      *                                                                                       257489
      ** Access TTRANL6 to check if other transaction uses the cheque                         257489
      *                                                                                       257489
     C                   MOVE      BTCQNB        WDCHN             8                          257489
     C     WDCHN         SETLL     TTRANL6                                                    257489
     C     WDCHN         READE     TTRANL6                                71                  257489
      *                                                                                       257489
     C                   EVAL      WCDup = 'N'                                                257489
     C                   DOW       (*IN71 = *OFF AND                                          257489
     C                             WCDup = 'N')                                               257489
     C     TRDRAN        IFNE      *ZEROS                                                     257489
     C     TRDRAN        ANDEQ     BTRACN                                                     257489
     C     TRBTRACN      ORNE      *ZEROS                                                     257489
     C     TRBTRACN      ANDEQ     BTRACN                                                     257489
      *                                                                                       257489
      ** Check if other transaction w/in GLJENPPD is using cheque no.                         257489
      *                                                                                       257489
     C     TRBTBTNB      IFEQ      BTBTNB                                                     257489
     C     TRBTBINB      ANDEQ     BTBINB                                                     257489
     C                   MOVE      *BLANKS       TRBTBTNB                                     257489
     C     WDCHN         READE     TTRANL6                                71                  257489
     C                   ELSE                                                                 257489
     C                   EVAL      WCDup = 'Y'                                                257489
     C                   ENDIF                                                                257489
      *                                                                                       257489
     C                   ELSE                                                                 257489
     C     WDCHN         READE     TTRANL6                                71                  257489
     C                   ENDIF                                                                257489
      *                                                                                       257489
     C                   ENDDO                                                                257489
      *                                                                                       257489
     C     WCDup         IFEQ      'N'                                                        257489
     C                   EVAL      *IN71 = *OFF                                               257489
     C     *LOVAL        SETLL     SDTELDL1                                                   257489
     C                   READ      SDTELDL1                               71                  257489
     C                   DOW       (*IN71 = *OFF AND WCDup = 'N')                             257489
      *                                                                                       257489
      ** If not the first time, delete the previous overrides                                 257489
      *                                                                                       257489
     C     @CMD          IFNE      *BLANKS                                                    257489
     C                   EVAL      @CMD = *BLANKS                                             257489
     C                   MOVEL     @ARRTXT(1)    @CMD                                         257489
     C                   Z-ADD     80            @Len             15 5                        257489
     C                   CALL      'QCMDEXC'                                                  257489
     C                   PARM                    @CMD                                         257489
     C                   PARM                    @Len                                         257489
     C                   CLOSE     TTRANL7                                                    257489
     C                   ENDIF                                                                257489
      *                                                                                       257489
      ** Perform override to LF/TTRANL7                                                       257489
      *                                                                                       257489
     C                   EVAL      @CMD = *BLANKS                                             257489
     C                   MOVEL     @ARRTXT(2)    @CMD                                         257489
     C                   MOVEL     'T'           @BRI                                         257489
     C                   MOVEL     FRTLID        @BID                                         257489
     C                   Z-ADD     80            @Len                                         257489
     C                   CALL      'QCMDEXC'                                                  257489
     C                   PARM                    @CMD                                         257489
     C                   PARM                    @Len                                         257489
      *                                                                                       257489
     C                   OPEN      TTRANL7                                                    257489
      *                                                                                       257489
     C     *LOVAL        SETLL     TTRANL7                                                    257489
     C     WDCHN         CHAIN     TTRANL7                            72                      257489
     C                   IF        *IN72 = *OFF                                               257489
     C     TQHCAC        IFNE      *BLANKS                                                    257489
     C                   MOVE      TQHCAC        TQACNO                                       257489
     C                   ENDIF                                                                257489
     C     TQACNO        IFNE      *ZEROS                                                     257489
     C     TQACNO        ANDEQ     BTRACN                                                     257489
     C                   EVAL      WCDup = 'Y'                                                257489
     C                   ENDIF                                                                257489
     C                   ENDIF                                                                257489
      *                                                                                       257489
     C                   READ      SDTELDL1                               71                  257489
      *                                                                                       257489
     C                   ENDDO                                                                257489
     C                   ENDIF                                                                257489
      *                                                                                       257489
     C                   ENDSR                                                                257489
      *****************************************************************                       257489
      /EJECT                                                                                  239466
      *****************************************************************                       239466
      *                                                               *                       239466
      *  SrDeleteChq - Deletes Cheque book file                       *                       239466
      *                                                               *                       239466
      *****************************************************************                       239466
      *                                                                                       239466
     C     SrDeleteChq   BEGSR                                                                239466
      *                                                                                       239466
     C     KCHQB3        KLIST                                                                239466
     C                   KFLD                    KACNO            10 0                        239466
     C                   KFLD                    KGCIN             1 0                        239466
     C                   KFLD                    KSCQN             8 0                        239466
      *                                                                                       239466
     C     KCHQB4        KLIST                                                                239466
     C                   KFLD                    KACNO                                        239466
     C                   KFLD                    KGCIN                                        239466
      *                                                                                       239466
     C     KCHQT1        KLIST                                                                239466
     C                   KFLD                    KACNTR           10 0                        239466
     C                   KFLD                    KGCITR            1 0                        239466
     C                   KFLD                    KSQNTR            8 0                        239466
      *                                                                                       239466
     C                   MOVE      BTCQNB        KSCQN                                        239466
     C                   EVAL      KGCIN = 0                                                  239466
     C                   IF        BTRACN = 0                                                 239466
     C                   EVAL      KACNO = ACNO                                               239466
     C                   ELSE                                                                 239466
     C                   EVAL      KACNO = BTRACN                                             239466
     C                   ENDIF                                                                239466
      *                                                                                       239466
     C                   OPEN      CHQBKL1                                                    239466
     C     KCHQB3        SETGT     CHQBKPDF                                                   239466
     C     KCHQB4        READPE    CHQBKPDF                               43                  239466
      *                                                                                       239466
     C                   IF        SCQN <= KSCQN AND KSCQN <= ECQN                            239466
      *                                                                                       239466
     C                   Z-ADD     KSCQN         WSCQN             8 0                        239466
     C     WSCQN         SUB       SCQN          WOFSET            8 0                        239466
     C     WOFSET        DIV       8             WI                2 0                        239466
     C                   MVR                     WBITN             1 0                        239466
     C                   EVAL      WI = WI + 1                                                239466
      *                                                                                       239466
      ** Set the correct bit representing the cheque number presented                         239466
      *                                                                                       239466
     C                   MOVEA     CQPS          WAR                                          239466
     C                   SELECT                                                               239466
     C                   WHEN      WBITN = 0                                                  239466
     C                   BITOFF    '0'           WAR(WI)                                      239466
     C                   WHEN      WBITN = 1                                                  239466
     C                   BITOFF    '1'           WAR(WI)                                      239466
     C                   WHEN      WBITN = 2                                                  239466
     C                   BITOFF    '2'           WAR(WI)                                      239466
     C                   WHEN      WBITN = 3                                                  239466
     C                   BITOFF    '3'           WAR(WI)                                      239466
     C                   WHEN      WBITN = 4                                                  239466
     C                   BITOFF    '4'           WAR(WI)                                      239466
     C                   WHEN      WBITN = 4                                                  239466
     C                   BITOFF    '4'           WAR(WI)                                      239466
     C                   WHEN      WBITN = 5                                                  239466
     C                   BITOFF    '5'           WAR(WI)                                      239466
     C                   WHEN      WBITN = 6                                                  239466
     C                   BITOFF    '6'           WAR(WI)                                      239466
     C                   WHEN      WBITN = 7                                                  239466
     C                   BITOFF    '7'           WAR(WI)                                      239466
     C                   ENDSL                                                                239466
     C                   MOVEA     WAR           CQPS                                         239466
     C                   ENDIF                                                                239466
      *                                                                                       239466
      ** Generate next trnsaction number                                                      239466
      *                                                                                       239466
     C     *LOCK         IN        DNATN                                                      239466
     C                   MOVE      FNATN         WNATN             5 0                        239466
     C                   MOVE      FNATN         WWRK5             5 0                        239466
     C                   EVAL      WWRK5 = WWRK5 + 1                                          239466
     C                   MOVE      WWRK5         FNATN                                        239466
     C                   OUT       DNATN                                                      239466
      *                                                                                       239466
      ** For out of range cheques, remove cheque number in CHQBKPD                            239466
      *                                                                                       239466
     C**********         IF        OUTR = 'Y'                                          239466 257489
     C                   IF        (OUTR = 'Y' AND WCDup = 'N')                               257489
     C**********         DELETE    CHQBKPDF                                           239466 239466A
     C                   DELETE    CHQBKPDF                                                   257489
     C**********         EVAL      TNLU = WNATN                                       239466A 257489
     C**********         EVAL      RECID = '*'                                        239466A 257489
     C**********         EVAL      CHTP = 'D'                                         239466A 257489
     C**********         EVAL      LCD = AGRDNB                                       239466A 257489
     C**********         UPDATE    CHQBKPDF                                           239466A 257489
      *                                                                                       239466
      ** Update the trailer file as well                                                      239466
      *                                                                                       239466
     C                   MOVE      *ALL'9'       KACNTR                                       239466
     C                   EVAL      KGCITR = 9                                                 239466
     C                   MOVE      *ALL'9'       KSQNTR                                       239466
     C     KCHQT1        CHAIN     CHQBKPTF                           70                      239466
     C                   IF        *IN70 = *ON                                                239466
     C     *LOCK         IN        LDA                                                        239466
     C                   EVAL      DBFILE = 'CHQBKPT'                                         239466
     C                   EVAL      DBASE = 8                                                  239466
     C                   MOVE      *ALL'9'       DBKEY                                        239466
     C                   OUT       LDA                                                        239466
     C                   ELSE                                                                 239466
     C                   EVAL      NORE = NORE - 1                                            239466
     C                   EVAL      LCD = AGRDNB                                               239466
     C                   EVAL      CHTP = 'A'                                                 239466
     C                   EVAL      TNLU = WNATN                                               239466
     C                   UPDATE    CHQBKPTF                                                   239466
     C                   ENDIF                                                                239466
      *                                                                                       239466
      ** Otherwise, update the record                                                         239466
      *                                                                                       239466
     C                   ELSE                                                                 239466
     C                   EVAL      TNLU = WNATN                                               239466
     C                   EVAL      CHTP = 'A'                                                 239466
     C                   EVAL      LCD = AGRDNB                                               239466
     C                   MOVEA     WAR           CQPS                                         239466
     C                   UPDATE    CHQBKPDF                                                   239466
     C                   ENDIF                                                                239466
      *                                                                                       239466
     C                   CLOSE     CHQBKL1                                                    239466
     C                   ENDSR                                                                239466
      *                                                                                       239466
      *****************************************************************                       239466
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdateCcy - Update Currency Totals                         *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdateCcy   BEGSR
      *
      ** Get Currency Summary details of batch.
      *
     C     KJENS         CHAIN     @BSREAI                            01
      *
      ** If record found, update Debit/Credit Summary Total.
      *
     C     *IN01         IFEQ      *OFF
                                                                                              CAP084
      ** If editing the item or deleting then ensure Debit/Credit Summary is correct          CAP084
      ** First of all delete the existing amount, then if it's not a deletion, add            CAP084
      ** the new amount in the usual way.                                                     CAP084
                                                                                              CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     BITUPD        ANDEQ     'Y'                                                        CAP084
     C     CYCDJV        ANDEQ     B2CYCD                                                    BUG2558
     C     PTIBCA        ANDEQ     B2IBCA                                                    BUG2558
                                                                                              CAP084
     C     B2DCIN        IFNE      PTDCIN                                                     CAP084
     C     PTDCIN        ANDNE     *BLANKS                                                    CAP084
      *                                                                                       CAP084
     C     PTDCIN        IFEQ      'D'                                                        CAP084
     C                   SUB       PTAMJV        BSDBTT                                       CAP084
     C                   ELSE                                                                 CAP084
     C                   SUB       PTAMJV        BSCRTT                                       CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   ELSE                                                                 CAP084
      *                                                                                       CAP084
     C     B2DCIN        IFEQ      'D'                                                        CAP084
     C                   SUB       PTAMJV        BSDBTT                                       CAP084
     C                   ELSE                                                                 CAP084
     C                   SUB       PTAMJV        BSCRTT                                       CAP084
     C                   ENDIF                                                                CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   ENDIF                                                                CAP084
      *
     C     B2VALI        IFNE      '*'                                                        CAP084
     C     B2DCIN        IFEQ      'D'
     C                   ADD       B2PTAM        BSDBTT
     C                   ELSE
     C                   ADD       B2PTAM        BSCRTT
     C                   ENDIF
     C                   ENDIF                                                                CAP084
      *
      *
      * Delete summary record for this currency if both ccy totals are zero                  BUG2558
      * else update the record                                                               BUG2558
     C     BSCRTT        IFEQ      *ZERO                                                     BUG2558
     C     BSDBTT        ANDEQ     *ZERO                                                     BUG2558
     C                   DELETE    @BSREAI                                                   BUG2558
     C                   ELSE                                                                BUG2558
     C                   UPDATE    @BSREAI
     C                   ENDIF                                                               BUG2558
     C                   ENDIF
      *                                                                                      BUG2558
      ** Check to see if currency or the branch of the item has changed                      BUG2558
      *                                                                                      BUG2558
     C     B2CYCD        IFNE      CYCDJV                                                    BUG2558
     C     CYCDJV        ANDNE     *BLANKS                                                   BUG2558
     C     BITUPD        ANDEQ     'Y'                                                       BUG2558
     C     JAVAUSER      ANDEQ     'Y'                                                       BUG2558
     C     B2IBCA        ORNE      PTIBCA                                                    BUG2558
     C     PTIBCA        ANDNE     *BLANKS                                                   BUG2558
     C     BITUPD        ANDEQ     'Y'                                                       BUG2558
     C     JAVAUSER      ANDEQ     'Y'                                                       BUG2558
      * Chain on record for previous currency and branch                                     BUG2558
     C     KJENS1        CHAIN     @BSREAI                            02                     BUG2558
                                                                                             BUG2558
     C     *IN02         IFEQ      *OFF                                                      BUG2558
                                                                                             BUG2558
      * Update the amount                                                                    BUG2558
     C     PTDCIN        IFEQ      'D'                                                       BUG2558
     C                   SUB       PTAMJV        BSDBTT                                      BUG2558
     C                   ELSE                                                                BUG2558
     C                   SUB       PTAMJV        BSCRTT                                      BUG2558
     C                   ENDIF                                                               BUG2558
                                                                                             BUG2558
      * Delete summary record for this currency if both ccy totals are zero                  BUG2558
      * else update the record                                                               BUG2558
     C     BSCRTT        IFEQ      *ZERO                                                     BUG2558
     C     BSDBTT        ANDEQ     *ZERO                                                     BUG2558
     C                   DELETE    @BSREAI                                                   BUG2558
     C                   ELSE                                                                BUG2558
     C                   UPDATE    @BSREAI                                                   BUG2558
     C                   ENDIF                                                               BUG2558
                                                                                             BUG2558
     C                   ENDIF                                                               BUG2558
      * Chain using new details once more                                                    BUG2558
     C     KJENS         CHAIN     @BSREAI                            01                     BUG2558
     C                   ENDIF                                                               BUG2558
      *
      ** Create Currency Summary record if not existing.
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     B2BTNB        BSBTNB
     C                   MOVEL     B2CYCD        BSCYCD
     C                   MOVEL     B2IBCA        BSBRCD
      *
     C                   Z-ADD     *ZERO         BSDBTT
     C                   Z-ADD     *ZERO         BSCRTT
      *
     C     B2DCIN        IFEQ      'D'
     C                   Z-ADD     B2PTAM        BSDBTT
     C                   ELSE
     C                   Z-ADD     B2PTAM        BSCRTT
     C                   ENDIF
      *
     C                   WRITE     @BSREAI
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      **                                                              *                       CSC011
      ** SRCONVERT - convert journal batch entry item to screen       *                       CSC011
      **   ~~~~~~~   format before writing to standard API log file.  *                       CSC011
      **                                                              *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRCONVERT     BEGSR                                                                CSC011
                                                                                              CSC011
      ** Input:                                                                               CSC011
      ** JE item details in file format                                                       CSC011
                                                                                              CSC011
      ** Output parameters:                                                                   CSC011
      ** Return Code                                                                          CSC011
      ** JE item details in screen format                                                     CSC011
     C                   CALLB     'GLBITPLOG'                                                CSC011
     C                   PARM                    ReturnCode                                   CSC011
     C                   PARM                    WJENP                                        CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If error occurred in program, return with an error code.                             CSC011
     C                   IF        ReturnCode <> *BLANKS                                      CSC011
     C                   EVAL      DBASE = 006                                                CSC011
     C                   EVAL      DBFILE = 'GLBITPLOG'                                       CSC011
     C                   EVAL      DBKEY = '*CALL'                                            CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      **                                                              *                       CSC011
      ** SRAPILOG - write JE details to API standard log file.        *                       CSC011
      **                                                              *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRAPILOG      BEGSR                                                                CSC011
                                                                                              CSC011
     C                   CLEAR                   PHead                                        CSC011
      ** Fill up other neccessary information in the header to be used                        CSC011
      ** by APITRANLOG                                                                        CSC011
     C                   EVAL      APTGTTYPE = 'GLBITP'                                       CSC011
     C                   EVAL      APFOTRANID = BTFRNT                                        CSC011
     C                   EVAL      APFOASOCID = BTAFRT                                        CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
                                                                                              CSC011
      ** Batch number                                                                         CSC011
     C                   EVAL      PDealNo = BTBTNB                                           CSC011
                                                                                              CSC011
      ** Input parameters:                                                                    CSC011
      ** Header information                                                                   CSC011
      ** JE details in screen format                                                          CSC011
      ** Timestamp                                                                            CSC011
      ** Batch Number                                                                         CSC011
                                                                                              CSC011
      ** Output parameter:                                                                    CSC011
      ** ReturnCode                                                                           CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM                    ReturnCode                                   CSC011
     C                   PARM                    PHead                                        CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTime                                        CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** If error occurred, return with an error to the calling program                       CSC011
     C                   IF        ReturnCode <> *BLANKS                                      CSC011
     C                   EVAL      DBASE = 007                                                CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBKEY = '*CALL'                                            CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
                                                                                              CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
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
      ** Return code
     C                   PARM                    PRTCD             7
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Security on Journal Entry
     C                   PARM                    CGL008            1
      *                                                                                       CRE019
      ** Cheque processing and maintenance                                                    CRE019
     C                   PARM                    CRE019            1                          CRE019
      *                                                                                       246418
      ** MT94x Messages Generation                                                            246418
     C                   PARM                    CGL013            1                          246418
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
                                                                                              246418
      ** Valid JE Item Additional Information (DS) - for file update                          246418
     C                   PARM                    PVBITPX                                      246418
      *                                                                                     BUG23742
      ** Valid Journal Batch Entry Items Addnl Inf - for file update                        BUG23742
      *                                                                                     BUG23742
     C                   PARM                    GLVNAR                                     BUG23742
                                                                                              CSC024
      ***Action*Code*for*OME*system                                                    CSC024 CSC054
      ** Action Code for PEA system                                                           CSC054
     C                   PARM                    PActnCde                                     CSC024
                                                                                              CSC024
     C/COPY WNCPYSRC,GLBITPDC09
     C/COPY OFCPYSRCZ,CGL135_064                                                             CGL135A
      *
      ** Define key list for GLJENHL3.
      *
     C     KJENH         KLIST
     C                   KFLD                    B2FRNT
      *                                                                                       CAP084
      ** Define key list for GLJENHL1.                                                        CAP084
      *                                                                                       CAP084
     C     KJENH0        KLIST                                                                CAP084
     C                   KFLD                    B2BTNB                                       CAP084
      *
      ** Define key list for GLJENSL0.
      *
     C     KJENS         KLIST
     C                   KFLD                    B2BTNB
     C                   KFLD                    B2CYCD
     C                   KFLD                    B2IBCA
      *                                                                                      BUG2558
     C     KJENS1        KLIST                                                               BUG2558
     C                   KFLD                    B2BTNB                                      BUG2558
     C                   KFLD                    CYCDJV                                      BUG2558
     C                   KFLD                    PTIBCA                                      BUG2558
      *                                                                                       CAP084
      ** Define key list for GLJENPPD.                                                        CAP084
      *                                                                                       CAP084
     C     KJENP         KLIST                                                                CAP084
     C                   KFLD                    BTBTNB                                       CAP084
     C                   KFLD                    BTBINB                                       CAP084
      *                                                                                     BUG23742
     C     KJENX1        KLIST                                                              BUG23742
     C                   KFLD                    KPTDT                                      BUG23742
     C                   KFLD                    KBTNB                                      BUG23742
     C                   KFLD                    KITNB                                      BUG23742
     C/COPY OFCPYSRCZ,CGL135_065                                                             CGL135A
      *
      ** Define working fields.
      *
     C     *LIKE         DEFINE    BRHICC        WHASH
     C     *LIKE         DEFINE    A6NBDP        WNBDP
     C     *LIKE         DEFINE    BTPTAM        PTAMJV                                       CAP084
     C     *LIKE         DEFINE    BTCYCD        CYCDJV                                       CAP084
     C     *LIKE         DEFINE    BTIBCA        PTIBCA                                      BUG2558
                                                                                              CSC011
      ** Check if Midas 24x7 Availability is installed.                                       CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTNC                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** An NRF (No Record Found) return code is valid.                                       CSC011
      ** Issue database error only for error return codes.                                    CSC011
     C                   IF        PRTNC <> *BLANKS AND PRTNC <> '*NRF   '                    CSC011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKey = 'CSC011'                                           CSC011
     C                   Z-ADD     005           DBase                                        CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTNC = *BLANK                                             CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,GLBITPDC03
      *                                                                                     MD036967
      ** Check for Account Balance Check Flag                                               MD036967
      *                                                                                     MD036967
     C                   EVAL      CAP207 = 'N'                                             MD036967
     C                   CALLB     'AOSARDR0'                                               MD036967
     C                   PARM      *BLANKS       @RTCD                                      MD036967
     C                   PARM      '*VERIFY'     @OPTN                                      MD036967
     C                   PARM      'CAP207'      @SARD                                      MD036967
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD036967
      *                                                                                     MD036967
      ** An NRF (No Record Found) return code is valid.  Issue database error               MD036967
      ** only for error return codes.                                                       MD036967
      *                                                                                     MD036967
     C                   IF        (@RTCD <> *BLANKS) AND                                   MD036967
     C                             (@RTCD <> '*NRF   ')                                     MD036967
     C                   EVAL      DBKEY = 'CAP207'                                         MD036967
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD036967
     C                   EVAL      DBASE = 11                                               MD036967
     C                   EXSR      *PSSR                                                    MD036967
     C                   ENDIF                                                              MD036967
      *                                                                                     MD036967
     C                   IF        @RTCD = *BLANK                                           MD036967
     C                   EVAL      CAP207 = 'Y'                                             MD036967
     C                   ENDIF                                                              MD036967
      *                                                                                       CRE023
      ** Check for 2 O'clock Flag SAR                                                         CRE023
      *                                                                                       CRE023
     C                   EVAL      CRE023 = 'N'                                               CRE023
     C                   CALLB     'AOSARDR0'                                                 CRE023
     C                   PARM      *BLANKS       @RTCD                                        CRE023
     C                   PARM      '*VERIFY'     @OPTN                                        CRE023
     C                   PARM      'CRE023'      @SARD                                        CRE023
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE023
      *                                                                                       CRE023
      ** An NRF (No Record Found) return code is valid.  Issue database error                 CRE023
      ** only for error return codes.                                                         CRE023
      *                                                                                       CRE023
     C                   IF        (@RTCD <> *BLANKS) AND                                     CRE023
     C                             (@RTCD <> '*NRF   ')                                       CRE023
     C                   EVAL      DBKEY = 'CRE023'                                           CRE023
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE023
     C                   EVAL      DBASE = 11                                                 CRE023
     C                   EXSR      *PSSR                                                      CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
     C                   IF        @RTCD = *BLANK                                             CRE023
     C                   EVAL      CRE023 = 'Y'                                               CRE023
     C                   OPEN      MEMOSL2                                                    CRE023
     C                   OPEN      REMEMLL0                                                   CRE023
     C                   OPEN      RETTYPL0                                                   CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      ** Access Bank Details                                                                  CRE023
      *                                                                                       CRE023
     C                   CALLB     'AOBANKR0'                                                 CRE023
     C                   PARM      *BLANKS       @RTCD                                        CRE023
     C                   PARM      '*FIRST'      @OPTN                                        CRE023
     C     SDBANK        PARM      SDBANK        DSFDY                                        CRE023
      *                                                                                       CRE023
      ** Database Error                                                                       CRE023
      *                                                                                       CRE023
     C                   IF        @RTCD <> *BLANKS                                           CRE023
     C                   EVAL      DBKEY  = @OPTN                                             CRE023
     C                   EVAL      DBFILE = 'SDBANKPD'                                        CRE023
     C                   EVAL      DBASE  = 12                                                CRE023
     C                   EXSR      *PSSR                                                      CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
                                                                                              CSC011
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER*-          CAP084 BUG6979
      **their*user*name*is*stored*in*ZMUSER                                           CAP084 BUG6979
     C**********         IN        ZMUSER                                             CAP084 BUG6979

     C*****USRID         IFNE      *BLANKS                                            CAP084 BUG6979
     C*****USRID         ANDNE     PSUser                                             CAP084 BUG6979
     C**********         MOVE      'Y'           JAVAUSER          1                  CAP084 BUG6979
     C**********         ELSE                                                         CAP084 BUG6979
     C**********         MOVE      'N'           JAVAUSER                             CAP084 BUG6979
     C**********         ENDIF                                                        CAP084 BUG6979
      *                                                                         CGL016
      ** Access SAR details for Projected Movements Update Prior to Auth.       CGL016
      *                                                                         CGL016
     C                   MOVEL     'N'           CGL016            1            CGL016
     C                   CALLB     'AOSARDR0'                                   CGL016
     C                   PARM      *BLANKS       @RTCD                          CGL016
     C                   PARM      '*VERIFY'     @OPTN                          CGL016
     C                   PARM      'CGL016'      @SARD                          CGL016
     C     SCSARD        PARM      SCSARD        DSFDY                          CGL016
      *                                                                         CGL016
     C     @RTCD         IFEQ      *BLANK                                       CGL016
     C                   MOVEL     'Y'           CGL016                         CGL016
     C*****              OPEN      GLJENPL0                                            CGL016 CAP084
     C                   ENDIF                                                  CGL016
      *                                                                         CGL016
     C     *DTAARA       DEFINE                  RUNDAT                         CGL016
     C                   IN        RUNDAT                                       CGL016
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC024
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
     C                   EVAL      DBase  = 9                                                 CSC024
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
     C                   EVAL      DBase = 10                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
     C                   CALL      'AOSVALR0'                                               MD033964
     C                   PARM      *BLANKS       PRetCode                                   MD033964
     C                   PARM      PSysVal2      P@OP01                                     MD033964
     C                   PARM      *BLANKS       P@VL01                                     MD033964
     C                   PARM      *BLANKS       P@OP02                                     MD033964
     C                   PARM      *BLANKS       P@VL02                                     MD033964
     C                   PARM      *BLANKS       P@OP03                                     MD033964
     C                   PARM      *BLANKS       P@VL03                                     MD033964
     C                   PARM      *BLANKS       P@OP04                                     MD033964
     C                   PARM      *BLANKS       P@VL04                                     MD033964
     C                   PARM      *BLANKS       P@OP05                                     MD033964
     C                   PARM      *BLANKS       P@VL05                                     MD033964
     C                   PARM      *BLANKS       P@OP06                                     MD033964
     C                   PARM      *BLANKS       P@VL06                                     MD033964
     C                   PARM      *BLANKS       P@OP07                                     MD033964
     C                   PARM      *BLANKS       P@VL07                                     MD033964
     C                   PARM      *BLANKS       P@OP08                                     MD033964
     C                   PARM      *BLANKS       P@VL08                                     MD033964
     C                   PARM      *BLANKS       P@OP09                                     MD033964
     C                   PARM      *BLANKS       P@VL09                                     MD033964
     C                   PARM      *BLANKS       P@OP10                                     MD033964
     C                   PARM      *BLANKS       P@VL10                                     MD033964
                                                                                            MD033964
     C                   IF        PRetCode  <> *BLANKS                                     MD033964
     C                   EVAL      DBFile = 'SDSVALPD'                                      MD033964
     C                   EVAL      DBKEy = '*KEY   '                                        MD033964
     C                   EVAL      DBase = 10                                               MD033964
     C                   EXSR      *PSSR                                                    MD033964
     C                   ENDIF                                                              MD033964
      *                                                                                     MD033964
     C                   EVAL      BchHdr = 'N'                                             MD033964
     C                   IF        P@VL01 = 'Y'                                             MD033964
     C                   EVAL      BchHdr = 'Y'                                             MD033964
     C                   ENDIF                                                              MD033964
      *                                                                                     BUG23742
     C                   CALLB     'AOSARDR0'                                               BUG23742
     C**********         PARM      *BLANKS       PRtCd                             BUG23742 BUG26099
     C                   PARM      *BLANKS       @RtCd                                      BUG26099
     C                   PARM      '*VERIFY'     POptn                                      BUG23742
     C                   PARM      'CER030'      PSard                                      BUG23742
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23742
      *                                                                                     BUG23742
     C**********         IF        PRtcd = *BLANKS                                 BUG23742 BUG26099
     C                   IF        @Rtcd = *BLANKS                                          BUG26099
     C                   EVAL      CER030 = 'Y'                                             BUG23742
     C**********         ELSEIF    PRtcd <> '*NRF'                                 BUG23742 BUG26099
     C                   ELSEIF    @Rtcd <> '*NRF'                                          BUG26099
      *                                                                                     BUG23742
     C     *LOCK         IN        LDA                                                      BUG23742
     C                   EVAL      DBASE = 11                                               BUG23742
     C                   EVAL      DBFile = 'AOSARDR0'                                      BUG23742
     C                   EVAL      DBKEY = '*VERIFY'                                        BUG23742
     C                   OUT       LDA                                                      BUG23742
     C                   EXSR      *PSSR                                                    BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                       CGL148
      ** Check if CGL148 is installed                                                         CGL148
      *                                                                                       CGL148
     C                   CallB     'AOSARDR0'                                                 CGL148
     C                   Parm      *BLANKS       PRTNC                                        CGL148
     C                   Parm      '*VERIFY'     POPTN                                        CGL148
     C                   Parm      'CGL148'      PSARD                                        CGL148
     C     SCSARD        Parm      SCSARD        DSFDY                                        CGL148
                                                                                              CGL148
     C                   If        PRTNC = *BLANKS                                            CGL148
     C                   move      'Y'           CGL148            1                          CGL148
     C                   Else                                                                 CGL148
     C                   Eval      CGL148 = 'N'                                               CGL148
     C                   EndIf                                                                CGL148
                                                                                              CGL148
      *                                                                                       CSC054
      ***Access*SAR*details*file*to*see*if*CGL125*is*installed.                      CSC054 MD039859
      ** Access SAR details file to see if CAP209 is installed.                             MD039859
      *                                                                                       CSC054
     C                   CALLB     'AOSARDR0'                                                 CSC054
     C                   PARM      *BLANKS       @RTCD                                        CSC054
     C                   PARM      '*VERIFY'     @OPTN                                        CSC054
     C**********         PARM      'CGL125'      @SARD                               CSC054 MD039859
     C                   PARM      'CAP209'      @SARD                                      MD039859
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC054
      *                                                                                       CSC054
     C                   IF        @RTCD <> *BLANKS AND                                       CSC054
     C                             @RTCD <> '*NRF'                                            CSC054
     C**********         EVAL      DBKEY = 'CGL125'                                  CSC054 MD039859
     C                   EVAL      DBKEY = 'CAP209'                                         MD039859
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC054
     C                   EVAL      DBASE  = 13                                                CSC054
     C                   EXSR      *PSSR                                                      CSC054
     C                   ENDIF                                                                CSC054
      *                                                                                       CSC054
     C     @RTCD         IFEQ      *BLANK                                                     CSC054
     C**********         MOVE      'Y'           CGL125            1                 CSC054 MD039859
     C                   MOVE      'Y'           CAP209            1                        MD039859
     C                   ELSE                                                                 CSC054
     C**********         MOVE      'N'           CGL125                              CSC054 MD039859
     C                   MOVE      'N'           CAP209                                     MD039859
     C                   ENDIF                                                                CSC054
      *                                                                                       CGL182
      ** Access SAR details file to see if CGL182 is installed.                               CGL182
      *                                                                                       CGL182
     C                   CALLB     'AOSARDR0'                                                 CGL182
     C                   PARM      *BLANKS       @RTCD                                        CGL182
     C                   PARM      '*VERIFY'     @OPTN                                        CGL182
     C                   PARM      'CGL182'      @SARD                                        CGL182
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL182
      *                                                                                       CGL182
     C                   IF        (@RTCD <> *BLANKS) AND                                     CGL182
     C                             (@RTCD <> '*NRF   ')                                       CGL182
     C                   EVAL      DBKEY = 'CGL182'                                           CGL182
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL182
     C                   EVAL      DBASE = 14                                                 CGL182
     C                   EXSR      *PSSR                                                      CGL182
     C                   ENDIF                                                                CGL182
      *                                                                                       CGL182
     C                   IF        @RTCD = *BLANK                                             CGL182
     C                   EVAL      CGL182 = 'Y'                                               CGL182
     C                   ENDIF                                                                CGL182
      *                                                                                       CGL182
     C/COPY WNCPYSRC,GLH00460
     C/COPY OFCPYSRCZ,CGL135_066                                                             CGL135A
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      ** Initialize QCMDEXC text                                                              257489
     C                   EVAL      @CMD = *blanks                                             257489
      *                                                                                       257489
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERR - Routine for Exception Errors                         *
      *                                                               *
      *****************************************************************
      *
     C     SRERR         BEGSR
      *
     C                   MOVEL     '*ERROR '     PRTCD
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *                                                                         186206
      ** If current batch has dumped already, don't execute dump again          186206
      *                                                                         186206
     C/COPY WNCPYSRC,GLH00714
     C     BRBTNB        CHAIN     GLBTNOL0                           21        186206
      *                                                                         186206
     C                   IF        *IN21 = *OFF AND B3DUMP <> 'Y'               186206
      *
     C                   DUMP
      *                                                                         186206
     C                   MOVE      'Y'           B3DUMP                         186206
     C                   UPDATE    GLBTNOD0                                     186206
     C                   ELSE                                                               BUG10855
     C                   UNLOCK    GLBTNOL0                                                 BUG10855
     C                   ENDIF                                                  186206
      *
     C/COPY WNCPYSRC,GLH00715
      ** Terminate program.
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *                                                                                       CRE023
      *****************************************************************                       CRE023
      *                                                               *                       CRE023
      * SRUpdTwoClk - Update MEMOS and REMEMLPD files                 *                       CRE023
      *                                                               *                       CRE023
      *****************************************************************                       CRE023
      *                                                                                       CRE023
     C     SRUpdTwoClk   BEGSR                                                                CRE023
      *                                                                                       CRE023
      ** ---------------------------- **                                                      CRE023
      ** Update MEMOS                                                                         CRE023
      ** ---------------------------- **                                                      CRE023
      *                                                                                       CRE023
      ** Additional reversal processing for an amendment or delete action                     CRE023
      *                                                                                       CRE023
     C**********         IF        BITUPD = 'Y'                                     CRE023 AR792734A
      *                                                                                       CRE023
     C*****Cr_BTRACN     CHAIN     MEMOSL2                                          CRE023 AR792734A
      *                                                                                       CRE023
     C**********         IF        (NOT(%FOUND)) OR                                 CRE023 AR792734A
     C**********                   (%FOUND AND RECI <> 'D')                         CRE023 AR792734A
     C**********         EXSR      SRERR                                             CRE023 BUG10855
     C**********         UNLOCK    MEMOSL2                                        BUG10855 AR792734A
     C**********         LEAVESR                                                  BUG10855 AR792734A
     C**********         ENDIF                                                      CRE023 AR792734A
      *                                                                                       CRE023
      ** Update ledger balance of MEMOSL2                                                     CRE023
      *                                                                                       CRE023
     C**********         IF        Cr_BTDCIN = 'D'                                  CRE023 AR792734A
     C**********         EVAL      LDBLN = LDBLN - Cr_BTPTAM                        CRE023 AR792734A
     C**********         ELSE                                                       CRE023 AR792734A
     C**********         EVAL      LDBLN = LDBLN + Cr_BTPTAM                        CRE023 AR792734A
     C**********         ENDIF                                                      CRE023 AR792734A
      *                                                                                       CRE023
      ** Update the cleared balance                                                           CRE023
      *                                                                                       CRE023
     C**********         IF        Cr_BTVLDT <= BJRDNB                              CRE023 AR792734A
      *                                                                                       CRE023
     C**********         IF        Cr_BTDCIN = 'D'                                  CRE023 AR792734A
     C**********         EVAL      CLBLN = CLBLN - Cr_BTPTAM                        CRE023 AR792734A
     C**********         ELSE                                                       CRE023 AR792734A
     C**********         EVAL      CLBLN = CLBLN + Cr_BTPTAM                        CRE023 AR792734A
     C**********         ENDIF                                                      CRE023 AR792734A
      *                                                                                       CRE023
     C**********         ENDIF                                                      CRE023 AR792734A
      *                                                                                       CRE023
      ** Update MEMOS file                                                                    CRE023
      *                                                                                       CRE023
     C**********         UPDATE    MEMOSMDF                                         CRE023 AR792734A
      *                                                                                       CRE023
     C**********         ENDIF                                                      CRE023 AR792734A
      *                                                                                       CRE023
     C*****B2RACN        CHAIN     MEMOSL2                                          CRE023 AR792734A
      *                                                                                       CRE023
     C**********         IF        (NOT(%FOUND)) OR                                 CRE023 AR792734A
     C**********                   (%FOUND AND RECI <> 'D')                         CRE023 AR792734A
     C**********         EXSR      SRERR                                             CRE023 BUG10855
     C**********         UNLOCK    MEMOSL2                                        BUG10855 AR792734A
     C**********         LEAVESR                                                  BUG10855 AR792734A
     C**********         ENDIF                                                      CRE023 AR792734A
      *                                                                                       CRE023
      ** Update ledger balance of MEMOSL2                                                     CRE023
      *                                                                                       CRE023
     C**********         IF        B2DCIN = 'D'                                     CRE023 AR792734A
     C**********         EVAL      LDBLN = LDBLN + B2PTAM                           CRE023 AR792734A
     C**********         ELSE                                                       CRE023 AR792734A
     C**********         EVAL      LDBLN = LDBLN - B2PTAM                           CRE023 AR792734A
     C**********         ENDIF                                                      CRE023 AR792734A
      *                                                                                       CRE023
      ** Update the cleared balance                                                           CRE023
      *                                                                                       CRE023
     C**********         IF        B2VLDT <= BJRDNB                                 CRE023 AR792734A
      *                                                                                       CRE023
     C**********         IF        B2DCIN = 'D'                                     CRE023 AR792734A
     C**********         EVAL      CLBLN = CLBLN + B2PTAM                           CRE023 AR792734A
     C**********         ELSE                                                       CRE023 AR792734A
     C**********         EVAL      CLBLN = CLBLN - B2PTAM                           CRE023 AR792734A
     C**********         ENDIF                                                      CRE023 AR792734A
      *                                                                                       CRE023
     C**********         ENDIF                                                      CRE023 AR792734A
      *                                                                                       CRE023
      ** Update MEMOS file                                                                    CRE023
      *                                                                                       CRE023
     C**********         UPDATE    MEMOSMDF                                         CRE023 AR792734A
      *                                                                                    MD033630A
      ** Additional reversal processing for an amendment or delete action                  MD033630A
      *                                                                                    MD033630A
     C                   IF        BITUPD = 'Y'                                            MD033630A
      *                                                                                    MD033630A
     C     Cr_BTTRTY     CHAIN     RETTYPL0                                                MD033630A
      *                                                                                    MD033630A
     C                   IF        (NOT(%FOUND)) OR                                        MD033630A
     C                             (%FOUND AND GRECI <> 'D')                               MD033630A
     C                   LEAVESR                                                           MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
     C     Cr_BTRACN     CHAIN     MEMOSL2                                                 MD033630A
      *                                                                                    MD033630A
     C                   IF        (NOT(%FOUND)) OR                                        MD033630A
     C                             (%FOUND AND RECI <> 'D')                                MD033630A
     C                   UNLOCK    MEMOSL2                                                 MD033630A
     C                   LEAVESR                                                           MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update ledger balance of MEMOSL2                                                  MD033630A
      *                                                                                    MD033630A
     C                   IF        Cr_BTDCIN = 'D'                                         MD033630A
     C                   EVAL      LDBLN = LDBLN - Cr_BTPTAM                               MD033630A
     C                   ELSE                                                              MD033630A
     C                   EVAL      LDBLN = LDBLN + Cr_BTPTAM                               MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update the cleared balance                                                        MD033630A
      *                                                                                    MD033630A
     C                   IF        Cr_BTVLDT <= BJRDNB                                     MD033630A
      *                                                                                    MD033630A
     C                   IF        Cr_BTDCIN = 'D'                                         MD033630A
     C                   EVAL      CLBLN = CLBLN - Cr_BTPTAM                               MD033630A
     C                   ELSE                                                              MD033630A
     C                   EVAL      CLBLN = CLBLN + Cr_BTPTAM                               MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update MEMOS file                                                                 MD033630A
      *                                                                                    MD033630A
     C                   UPDATE    MEMOSMDF                                                MD033630A
      *                                                                                    MD033630A
     C                   If        B2VALI <> '*'                                           MD033630A
      *                                                                                    MD033630A
     C     B2TRTY        CHAIN     RETTYPL0                                                MD033630A
      *                                                                                    MD033630A
     C                   IF        (NOT(%FOUND)) OR                                        MD033630A
     C                             (%FOUND AND GRECI <> 'D')                               MD033630A
     C                   LEAVESR                                                           MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
     C     B2RACN        CHAIN     MEMOSL2                                                 MD033630A
      *                                                                                    MD033630A
     C                   IF        (NOT(%FOUND)) OR                                        MD033630A
     C                             (%FOUND AND RECI <> 'D')                                MD033630A
     C                   UNLOCK    MEMOSL2                                                 MD033630A
     C                   LEAVESR                                                           MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update ledger balance of MEMOSL2                                                  MD033630A
      *                                                                                    MD033630A
     C                   IF        B2DCIN = 'D'                                            MD033630A
     C                   EVAL      LDBLN = LDBLN + B2PTAM                                  MD033630A
     C                   ELSE                                                              MD033630A
     C                   EVAL      LDBLN = LDBLN - B2PTAM                                  MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update the cleared balance                                                        MD033630A
      *                                                                                    MD033630A
     C                   IF        B2VLDT <= BJRDNB                                        MD033630A
      *                                                                                    MD033630A
     C                   IF        B2DCIN = 'D'                                            MD033630A
     C                   EVAL      CLBLN = CLBLN + B2PTAM                                  MD033630A
     C                   ELSE                                                              MD033630A
     C                   EVAL      CLBLN = CLBLN - B2PTAM                                  MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update MEMOS file                                                                 MD033630A
      *                                                                                    MD033630A
     C                   UPDATE    MEMOSMDF                                                MD033630A
      *                                                                                    MD033630A
     C                   EndIf                                                             MD033630A
      *                                                                                    MD033630A
     C                   Else                                                              MD033630A
      *                                                                                    MD033630A
     C     B2TRTY        CHAIN     RETTYPL0                                                MD033630A
      *                                                                                    MD033630A
     C                   IF        (NOT(%FOUND)) OR                                        MD033630A
     C                             (%FOUND AND GRECI <> 'D')                               MD033630A
     C                   LEAVESR                                                           MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
     C     B2RACN        CHAIN     MEMOSL2                                                 MD033630A
      *                                                                                    MD033630A
     C                   IF        (NOT(%FOUND)) OR                                        MD033630A
     C                             (%FOUND AND RECI <> 'D')                                MD033630A
     C                   UNLOCK    MEMOSL2                                                 MD033630A
     C                   LEAVESR                                                           MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update ledger balance of MEMOSL2                                                  MD033630A
      *                                                                                    MD033630A
     C                   IF        B2DCIN = 'D'                                            MD033630A
     C                   EVAL      LDBLN = LDBLN + B2PTAM                                  MD033630A
     C                   ELSE                                                              MD033630A
     C                   EVAL      LDBLN = LDBLN - B2PTAM                                  MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update the cleared balance                                                        MD033630A
      *                                                                                    MD033630A
     C                   IF        B2VLDT <= BJRDNB                                        MD033630A
      *                                                                                    MD033630A
     C                   IF        B2DCIN = 'D'                                            MD033630A
     C                   EVAL      CLBLN = CLBLN + B2PTAM                                  MD033630A
     C                   ELSE                                                              MD033630A
     C                   EVAL      CLBLN = CLBLN - B2PTAM                                  MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update MEMOS file                                                                 MD033630A
      *                                                                                    MD033630A
     C                   UPDATE    MEMOSMDF                                                MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                       CRE023
      ** ---------------------------- **                                                      CRE023
      ** Update REMEMLPD                                                                      CRE023
      ** ---------------------------- **                                                      CRE023
      *                                                                                       CRE023
      ** Additional reversal processing for an amendment or delete action                     CRE023
      *                                                                                       CRE023
     C                   IF        BITUPD = 'Y'                                               CRE023
      *                                                                                       CRE023
      ** Setup posting amount fields of REMEMLL0                                              CRE023
      *                                                                                       CRE023
     C**********         IF        Cr_BTVLDT > BJDNWD                               CRE023 AR792734A
     C**********         IF        Cr_BTVLDT >=BJDNWD                            AR792734A MD033630A
     C                   IF        Cr_BTVLDT > BJDNWD                                      MD033630A
     C                   LEAVESR                                                              CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
     C     Cr_BTTRTY     CHAIN     RETTYPL0                                                   CRE023
      *                                                                                       CRE023
     C                   IF        (NOT(%FOUND)) OR                                           CRE023
     C                             (%FOUND AND GRECI <> 'D')                                  CRE023
      *                                                                                     MD035554
      ** Exclude Outward Clearing Checks with Value Date equal to Run Date                  MD035554
      *                                                                                     MD035554
     C                             Or (%FOUND And GRECI = 'D'                               MD035554
     C                                And GOCLR = 'Y' and Cr_BTVLDT = BJRDNB)               MD035554
     C                   LEAVESR                                                              CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
     C     Cr_BTRACN     CHAIN     REMEMLL0                                                   CRE023
      *                                                                                       CRE023
     C                   IF        (NOT(%FOUND)) OR                                           CRE023
     C                             (%FOUND AND GRECI <> 'L')                                  CRE023
     C                   UNLOCK    REMEMLL0                                                 BUG10855
     C                   LEAVESR                                                              CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      ** If the transaction is an Outward clearing                                            CRE023
      *                                                                                       CRE023
     C                   IF        GOCLR = 'Y'                                                CRE023
     C                   EVAL      GTAMT = GTAMT - Cr_BTPTAM                                  CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      ** If the transaction is a Reversal of Today's Outward Clearing                         CRE023
      *                                                                                       CRE023
     C                   IF        GRCLT = 'Y'                                                CRE023
     C                   EVAL      GTAMT = GTAMT + Cr_BTPTAM                                  CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      ** If the transaction is a Reversal of Previous Outward Clearing                        CRE023
      *                                                                                       CRE023
     C                   IF        GRCLP = 'Y'                                                CRE023
     C                   EVAL      GPAMT = GPAMT + Cr_BTPTAM                                  CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      ** Update REMEMLL0                                                                      CRE023
      *                                                                                       CRE023
     C                   UPDATE    REMEMLD0                                                   CRE023
      *                                                                                       CRE023
      ** Setup posting amount fields of REMEMLL0                                           AR792734A
      *                                                                                    AR792734A
     C                   IF        B2VALI <> '*'                                           AR792734A
     C                   IF        B2VLDT > BJDNWD                                         AR792734A
     C                   LEAVESR                                                           AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
     C     B2TRTY        CHAIN     RETTYPL0                                                AR792734A
      *                                                                                    AR792734A
     C                   IF        (NOT(%FOUND)) OR                                        AR792734A
     C                             (%FOUND AND GRECI <> 'D')                               AR792734A
      *                                                                                     MD035554
      ** Exclude Outward Clearing Checks with Value Date equal to Run Date                  MD035554
      *                                                                                     MD035554
     C                             Or (%FOUND And GRECI = 'D'                               MD035554
     C                                And GOCLR = 'Y' and B2VLDT = BJRDNB)                  MD035554
     C                   LEAVESR                                                           AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
     C     B2RACN        CHAIN     REMEMLL0                                                AR792734A
      *                                                                                    AR792734A
     C                   IF        (NOT(%FOUND)) OR                                        AR792734A
     C                             (%FOUND AND GRECI <> 'L')                               AR792734A
     C                   UNLOCK    REMEMLL0                                                AR792734A
     C                   LEAVESR                                                           AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
      ** If the transaction is an Outward clearing                                         AR792734A
      *                                                                                    AR792734A
     C                   IF        GOCLR = 'Y'                                             AR792734A
     C                   EVAL      GTAMT = GTAMT + B2PTAM                                  AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
      ** If the transaction is a Reversal of Today's Outward Clearing                      AR792734A
      *                                                                                    AR792734A
     C                   IF        GRCLT = 'Y'                                             AR792734A
     C                   EVAL      GTAMT = GTAMT - B2PTAM                                  AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
      ** If the transaction is a Reversal of Previous Outward Clearing                     AR792734A
      *                                                                                    AR792734A
     C                   IF        GRCLP = 'Y'                                             AR792734A
     C                   EVAL      GPAMT = GPAMT - B2PTAM                                  AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
      ** Update REMEMLL0                                                                   AR792734A
      *                                                                                    AR792734A
     C                   UPDATE    REMEMLD0                                                AR792734A
      *                                                                                    AR792734A
     C                   ENDIF                                                                CRE023
      *                                                                                    AR792734A
     C                   ELSE                                                              AR792734A
      *                                                                                       CRE023
      ** Setup posting amount fields of REMEMLL0                                              CRE023
      *                                                                                       CRE023
     C**********         IF        B2VLDT > BJDNWD                                  CRE023 AR792734A
     C**********         IF        B2VLDT >= BJDNWD                              AR792734A MD033630A
     C                   IF        B2VLDT >  BJDNWD                                        MD033630A
     C                   LEAVESR                                                              CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
     C     B2TRTY        CHAIN     RETTYPL0                                                   CRE023
      *                                                                                       CRE023
     C                   IF        (NOT(%FOUND)) OR                                           CRE023
     C                             (%FOUND AND GRECI <> 'D')                                  CRE023
      *                                                                                     MD035554
      ** Exclude Outward Clearing Checks with Value Date equal to Run Date                  MD035554
      *                                                                                     MD035554
     C                             Or (%FOUND And GRECI = 'D'                               MD035554
     C                                And GOCLR = 'Y' and B2VLDT = BJRDNB)                  MD035554
     C                   LEAVESR                                                              CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
     C     B2RACN        CHAIN     REMEMLL0                                                   CRE023
      *                                                                                       CRE023
     C                   IF        (NOT(%FOUND)) OR                                           CRE023
     C                             (%FOUND AND GRECI <> 'L')                                  CRE023
     C                   UNLOCK    REMEMLL0                                                 BUG10855
     C                   LEAVESR                                                              CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      ** If the transaction is an Outward clearing                                            CRE023
      *                                                                                       CRE023
     C                   IF        GOCLR = 'Y'                                                CRE023
     C                   EVAL      GTAMT = GTAMT + B2PTAM                                     CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      ** If the transaction is a Reversal of Today's Outward Clearing                         CRE023
      *                                                                                       CRE023
     C                   IF        GRCLT = 'Y'                                                CRE023
     C                   EVAL      GTAMT = GTAMT - B2PTAM                                     CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      ** If the transaction is a Reversal of Previous Outward Clearing                        CRE023
      *                                                                                       CRE023
     C                   IF        GRCLP = 'Y'                                                CRE023
     C                   EVAL      GPAMT = GPAMT - B2PTAM                                     CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      ** Update REMEMLL0                                                                      CRE023
      *                                                                                       CRE023
     C                   UPDATE    REMEMLD0                                                   CRE023
      *                                                                                       CRE023
     C**********         UNLOCK    MEMOSL2                                           CRE023 BUG10855
     C**********         UNLOCK    REMEMLL0                                          CRE023 BUG10855
      *                                                                                       CRE023
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
     C                   ENDSR                                                                CRE023
      *                                                                                       CRE023
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
**  @ARRTXT                                                                                   257489
DLTOVR     FILE(TTRANL7)                                                                      257489
OVRDBF     FILE(TTRANL7) MBR(XXXX) SECURE(*YES) SHARE(*NO)  SEQONLY(*NO)                      257489
