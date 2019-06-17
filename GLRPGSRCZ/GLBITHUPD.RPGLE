     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE Header Database Update')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITHUPD - Journal Batch Entry Header Database Update       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. JMI111             Date 16May19               *
      *  Prev Amend No. 249405             Date 09Mar18               *
      *                 CGL148             Date 13Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD046060           Date 21Jun17               *
      *                 CGL182             Date 11May17               *
      *                 MD046910           Date 25Jul17               *
      *                 MD042261           Date 07Jun17               *
      *                 MD045854           Date 25May17               *
      *                 MD033630A          Date 25May16               *
      *                 MD036967           Date 25May16               *
      *                 MD035554           Date 25May16               *
      *                 AR922022A          Date 26Apr16               *
      *                 AR922022           Date 26Apr16               *
      *                 MD033630           Date 23Jun15               *
      *                 MD031298           Date 20Feb15               *
      *                 MD023889           Date 10Dec13               *
      *                 CGL135A            Date 23Oct13               *
      *                 AR1093096          Date 30Sep13               *
      *                 MD020144           Date 22Apr13               *
      *                 AR1092517          Date 14Mar13               *
      *                 AR1027164          Date 16Oct12               *
      *                 AR792734A          Date 22Sep11               *
      *                 CSC054             Date 23Feb12               *
      *                 AR787620           Date 10Jun11               *
      *                 CAP207             Date 10Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26246A          Date 09Oct09               *
      *                 BUG26246           Date 01Oct09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245211             Date 25jan07               *
      *                 243743             Date 18Jul06               *
      *                 GBO021             Date 13Sep06               *
      *                 CRE026             Date 24May06               *
      *                 BUG13083A          Date 14Feb07               *
      *                 BUG13083           Date 23Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237512 (Reopen)    Date 22May06               *
      *                 240684             Date 26Jun06               *
      *                 240063             Date 06Jun06               *
      *                 239155 (Reopen)    Date 31May06               *
      *                 237621             Date 17Jan06               *
      *                 BUG9713            Date 04Jan06               *
      *                 BUG9009            Date 03Nov05               *
      *                 CER001             Date 08Aug05               *
      *                 BUG7426            Date 15Jul05               *
      *                 GOC001             Date 14Jul04               *
      *                 BUG11437           Date 03Jun06               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG6979            Date 04May05               *
      *                 BUG3500            Date 06Jul04               *
      *                 BUG3085            Date 08Jun04               *
      *                 BUG1175R           Date 01Jun04               *
      *                 BUG1898            Date 20Apr04               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Aug03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186206             Date 26Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI111 - Midas-OPICS Interface. Upgrade to FBM 2.1           *
      *           Use of core hook GLH00446                           *
      *           Addition of hook JMI111_011                         *
      *           Addition of hook JMI111_010                         *
      *  249405 - Validate Batch In Use Flag field.                   *
      *         - Applied for MD-49830.                               *
      *  CGL148 - Automatic Opening of GL accounts                    *
      *         - Includes fix MD024246                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD046060 - GLBTNOPD is not defined with COMMIT               *
      *  CGL182 - Journal Entry via the Interface File - Java Version *
      *  MD046910 - Reversal of MD-45854 as part of fix MD-43023      *
      *  MD042261 - Records from GLJENP1D were not reversed when      *
      *             deleting a batch. Remove record if batch is delete*
      *  MD045854 - Batch Detail cannot be entered with message       *
      *             Batch Header already accepted. Removed CAP209     *
      *             conditioning from AR1092517 fix.                  *
      *  MD033630A - Corrected discrepancy in MD033630 codes.         *
      *  MD036967 - Conflict betwen CAP207 and CRE023. Update files   *
      *             for Credit after accept when both feat are ON.    *
      *  MD035554 - 2o'clock/ABC compatibility                        *
      *  AR922022A - Added Submission of REC000881 when CRE023 and    *
      *              CRE016 is both on.                               *
      *            - Applied for MD033905                             *
      *  AR992022 - On line Retail Advices are not being printed for  *
      *             journal entries (CRE020). Pattern retail advice   *
      *             process after GLC1400 and in other modules.       *
      *           - Applied for MD033905                              *
      *  MD033630 - Limit CRE023 functionality to those whose trans-  *
      *             action types are in RETTYPPD.                     *
      *  MD031298 - 4-Eyes Principle Error - Journal Entries          *
      *             Remove validation in the input user               *
      *  MD023889 - Accounting Rules Process (GL Account creation)    *
      *             Amend /COPY CGL135_015 and CGL135_016             *
      *             (Recompile)                                       *
      *  CGL135A  - Accounting Rules Process                          *
      *             Added hooks: CGL135_015, CGL135_016               *
      *  AR1093096 - ABC - Reservations not removed for JRNE          *
      *              (Child: AR1093097) (Recompile)                   *
      *  MD020144 - Serious Midas error occured upon deletion of      *
      *             batch header of journal entry. PRTCD field should *
      *             be blanked out at the end of *INZSR subroutine.   *
      *  AR1092517 - Transaction is not populated in List View for    *
      *              transactions with blank batch number             *
      *  AR1027164 - Allow blank batch numbers if from 3rd party      *
      *              (Child: AR1027165)                               *
      *  AR792734A - Projected Account movement show incorrect        *
      *              Available Balance when posting Cash Deposit      *
      *              Applied Fix 248347 and 261330 but removed the    *
      *              updating of MEMOS from CRE023 as this is already *
      *              being done in the CGL016 codes(Child: AR792735A) *
      *  CSC054 - Period End Adjustments                              *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,GLH00301                                 *
      *             WNCPYSRC,GLH00302                                 *
      *             WNCPYSRC,GLH00303                                 *
      *             WNCPYSRC,GLH00069                                 *
      *             WNCPYSRC,GLH00070                                 *
      *             WNCPYSRC,GLH00071                                 *
      *             WNCPYSRC,GLH00072                                 *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26246A - Extended narratives are not refreshed with reused*
      *             batch numbers (via JRNE).                         *
      *  BUG26246 - Extended narratives are not refreshed with reused *
      *             batch numbers (via JRNE).                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245211  - Remove this part of 237512 because not correct     *
      *            Validation of batch totals should also be done     *
      *            when GL ICD setup is equal to "N" and values have  *
      *            been entered in fields Batch Total and Nbr of Items*
      *  243743 - Bug 7332 fix is incomplete. Problem still occurs.   *
      *           B1WSID should only be updated if not a java user.   *
      *  GBO021 - OUTPUT tag :86: - Information to Account Owners     *
      *           Core hooks added: GLBITHDC03 (in lieu of GLBITHDC01)*
      *                             GLBITHDF01                        *
      *           Amended hook GLBITHDC02                             *
      *  CRE026  - Consumer Banking (Recompile)                       *
      *  BUG13083A - Remove this fix.                                 *
      *  BUG13083 - Newly inserted batch headers are held             *
      *  237512  - Validation of batch totals should only be done     *
      *            when GL ICD setup is equal to "Y".                 *
      *  240684 - Applied fix 237621 and BUG9009.                     *
      *  240063  - Validation of batch totals should only be done     *
      *            when GL ICD setup is equal to "Y". Applied fix     *
      *            237512.                                            *
      *  237512  - Validation of batch totals should only be done     *
      *            when GL ICD setup is equal to "Y".                 *
      *  239155 - (Reopen) Batch should be flagged as ACCEPTED once   *
      *           shadow postings are successfully updated.           *
      *  237621 - Add additional fix to BUG9009 during update mode    *
      *  BUG9713 - GL Batch Header Input - Serious MidasPlus had      *
      *            occurred                                           *
      *  BUG9009 - Implement CGL037                                   *
      *  CER001 - LUX Upgrade to Midasplus.                           *
      *  BUG7426 - GL Batch Input, user can't reuse previously        *
      *            deleted batch number                               *
      *  GOC001 - Account Posting (Journal Entry) Input Amendments    *
      *           Add hooks GLBITHDD01, GLBITHDC01, GLBITHDC02        *
      *  BUG11437 - Set return code to blank after test for CAP086    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSC024 - Open Month End                                      *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG3500- Amendment to batch deletion processing              *
      *  BUG3085- Update the last amend user on the batch header rec. *
      *  BUG1175R-User ID is now setup in workstation ID by java      *
      *  BUG1898- Add new *entry parameter for error message number   *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - MidasPlus Changes.                                  *
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
      ** JE Headers file by Front Office Id
     FGLJENHL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** JE Headers file by Batch Header Number                                 CAP084
     FGLJENHL0  UF A E           K DISK    INFSR(*PSSR)                         CAP084
     F                                     COMMIT                               CAP084
      ** JE Items file by Batch Header Number                                                BUG3500
     FGLJENPL0  UF A E           K DISK    INFSR(*PSSR)                                      BUG3500
     F                                     COMMIT                                            BUG3500
      ** JE Summary file by Batch Header Number                                              BUG3500
     FGLJENSL0  UF A E           K DISK    INFSR(*PSSR)                                      BUG3500
     F                                     COMMIT                                            BUG3500
      ** Midas GL Journal entry - add. inf. - retrieval                                     BUG26246
     FGLJENXL5  UF A E           K DISK    INFSR(*PSSR)                                     BUG26246
     F                                     COMMIT                                           BUG26246
      ***Midas*GL*Multicash*Narratives*File*-*by*batch*no*and*item*no             BUG26246 BUG26246A
     F***GLMNARL6**UF*A*E***********K*DISK****INFSR(*PSSR)**********              BUG26246 BUG26246A
      *                                                                                    BUG26246A
      ** Midas GL Multicash Narratives File - by batch no                                  BUG26246A
     FGLMNARL7  UF A E           K DISK    INFSR(*PSSR)                                    BUG26246A
     F                                     COMMIT                                           BUG26246
     F/COPY WNCPYSRC,GLBITHDF01
      ** IBLC Journal Entry Details                                                           CER001
     FGLJPX1L0  UF A E           K DISK    INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      *                                                                         186206
      ** Today's batch numbers used                                             186206
     FGLBTNOL0  UF A E           K DISK    INFSR(*PSSR)                         186206
     F                                     COMMIT                                           MD046060
      *
     FRETTYPL0  IF   E           K DISK    INFSR(*PSSR)                                    AR792734A
     F                                     USROPN                                          AR792734A
      *                                                                                    AR792734A
      ** Outward Clearing Transaction Types                                                AR792734A
      *                                                                                    AR792734A
     FMEMOSL2   UF   E           K DISK    INFSR(*PSSR)                                    AR792734A
     F                                     USROPN                                          AR792734A
     F                                     COMMIT                                          AR792734A
      *                                                                                    AR792734A
      ** Shadow Balance File                                                               AR792734A
      *                                                                                    AR792734A
     FREMEMLL0  UF   E           K DISK    INFSR(*PSSR)                                    AR792734A
     F                                     USROPN                                          AR792734A
     F                                     COMMIT                                          AR792734A
      *                                                                                    AR792734A
      ** Outward Clearing Balance File                                                     AR792734A
      *                                                                                    AR792734A
     FGLJENPL1  IF   E           K DISK    USROPN                                           AR992022
     F                                     PREFIX(M)                                       AR992022A
      *                                                                                     AR992022
      ** Midas GL Journal entry posting Rtv                                                 AR992022
      *                                                                                     AR992022
     FREADVCL1  UF A E           K DISK    COMMIT                                           AR992022
     F                                     USROPN                                           AR992022
      *                                                                                     AR992022
      ** MIDAS RE Settled Transaction Index file                                            AR992022
      *                                                                                     AR992022
     FGLJENPI2  UF   E           K DISK    INFSR(*PSSR)                                     MD042261
     F                                     COMMIT                                           MD042261
      ** Midas GL Journal Entry - Posting Date                                              MD042261
     F/COPY WNCPYSRC,GLH00301
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
     D*PSysVal1*       C                   CONST('OMEIndicator')                       CAP086 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
     D/COPY WNCPYSRC,GLH00443
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Valid JE Header (DS) - for file update
     D PVBITH        E DS                  EXTNAME(GLVBITHPD)
     D  WVSUB1                46    156
      *
      ** Externally described DS for JE Header details
     D WJENH         E DS                  EXTNAME(GLJENHPD)
     D QQACCF1       E                     EXTFLD(QQACCF)                                     CGL029
     D QQACCT1       E                     EXTFLD(QQACCT)                                     CGL029
     D  WVSUB2                46    156
      *                                                                                    AR792734A
      ** Externally described DS for JE Item details                                       AR792734A
      *                                                                                    AR792734A
     D LJENP         E DS                  EXTNAME(GLJENPL0)                               AR792734A
     D                                     PREFIX(L)                                       AR792734A
     D D@ACCT        E DS                  EXTNAME(ACCNTAB)                                AR792734A
     D L_CD          E                     EXTFLD(LCD)                                     AR792734A
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
      ** DS for access programs -  Long  data structure                                       CAP084
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CAP084
                                                                                              CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     CAP084
      ** Java user information                                                                CAP084
     D SDUSER        E DS                  EXTNAME(MUSERDD) PREFIX(M_)                        CAP084
      ** Data Structure for User Details                                                      CAP084
      *                                                                                       CAP084
      ** Data structure for data area ZMITEM                                                 BUG9009
     D ZMITEM        E DS                  EXTNAME(ZMITEM) DTAARA(ZMITEM)                    BUG9009
      *
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
     D PDealNo         S             18A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Associated transaction reference                                                     CSC011
     D PADealNo        S             18A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Define parameters for AOSARDR0                                                       CSC011
     D PRTNC           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                             BUG3500
      ** Define CMD1 for call to QCDMEXC                                                     BUG3500
     D CMD1            S              1    DIM(50) CTDATA PERRCD(50)                         BUG3500
                                                                                             BUG9009
      ** Define variable for switchable CGL037.                                              BUG9009
     D CGL037          S              1A   INZ(*BLANKS)                                      BUG9009
      *                                                                                    AR792734A
     D CRE023          S              1A                                                   AR792734A
      ** Singapore 2 o'clock enhancement flag                                              AR792734A
     D CAP207          S              1                                                     MD036967
      ** Account balance Check                                                              MD036967
      *                                                                                    AR792734A
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                               AR792734A
                                                                                              CAP086
     D PRetCode        S              7A                                                      CAP086
     D P@OP01          S             20A                                                      CAP086
     D P@VL01          S            200A                                                      CAP086
     D P@OP02          S             20A                                                      CAP086
     D P@VL02          S            200A                                                      CAP086
     D P@OP03          S             20A                                                      CAP086
     D P@VL03          S            200A                                                      CAP086
     D P@OP04          S             20A                                                      CAP086
     D P@VL04          S            200A                                                      CAP086
     D P@OP05          S             20A                                                      CAP086
     D P@VL05          S            200A                                                      CAP086
     D P@OP06          S             20A                                                      CAP086
     D P@VL06          S            200A                                                      CAP086
     D P@OP07          S             20A                                                      CAP086
     D P@VL07          S            200A                                                      CAP086
     D P@OP08          S             20A                                                      CAP086
     D P@VL08          S            200A                                                      CAP086
     D P@OP09          S             20A                                                      CAP086
     D P@VL09          S            200A                                                      CAP086
     D P@OP10          S             20A                                                      CAP086
     D P@VL10          S            200A                                                      CAP086
     D UUAPRC          S              7A                                                   AR792734A
     D UUAPOP          S              7A                                                   AR792734A
     D UUACID          S             10A                                                   AR792734A
     D CGL016          S              1A                                                   AR792734A
                                                                                              CAP086
      ** Define variable for switchable CAP086                                                CAP086
     D*CSC024***       S              1A                                               CAP086 CSC054
     D CSC054          S              1A                                                      CSC054
     D CAP086          S              1A                                                      CAP086
     D*WOMEInd**       S              1A                                               CAP086 CSC054
     D WPEAInd         S              1A                                                      CSC054
      *                                                                                     BUG26246
      ** Define variable for switchable CGL013.                                             BUG26246
     D CGL013          S              1A   INZ(*BLANKS)                                     BUG26246
      *                                                                                     AR992022
      ** Switchable Features Flags                                                          AR992022
      *                                                                                     AR992022
     D CRE020          S              1A   INZ('N')                                         AR992022
     D POption         S              7A                                                    AR992022
     D PRtnCode        S              7A                                                    AR992022
      *                                                                                     AR992022
      ** Parameters for System Values Access Object                                         AR992022
      *                                                                                     AR992022
     D PRtCd           S              7A                                                    AR992022
     D PSValOpt        S             20A   INZ('JournalEntry')                              AR992022
     D PSysVal         S            200A   INZ(' ')                                         AR992022
     D PSValOptB       S             20A   INZ(' ')                                         AR992022
     D PSysValB        S            200A   INZ(' ')                                         AR992022
      ** CRE020 Parameters for QCMDEXC                                                     AR992022A
     D SBMAdvice       S            150A   INZ('SBMJOB JOB(REC000881) +                    AR992022A
     D                                       JOBD(MBATCH) USER(*JOBD) +                    AR992022A
     D                                       RTGDTA(*JOBD) RQSDTA(+                        AR992022A
     D                                       ''CALL REC000881 +                            AR992022A
     D                                       (GLBITHUPD GL)'') INLLIBL+                    AR992022A
     D                                       (*JOBD) MSGQ(MOPERQ)')                        AR992022A
     D SBMAdvLngth     S             15  5 INZ(150)                                        AR992022A
      *                                                                                     AR992022
      ** Working Variables                                                                  AR992022
      *                                                                                     AR992022
     D WRefNo          S              6A                                                    AR992022
     D CGL182          S              1A   INZ('N')                                           CGL182
      *
      ** Hook for non-core D-specs (all types)                                                GOC001
      /COPY WNCPYSRC,GLBITHDD01                                                               GOC001
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
      * If the user is connected via a browser, the job user name is QUSER -                 BUG6979
      * their user name is stored in ZMUSER                                                  BUG6979
     C                   IN        ZMUSER                                                    BUG6979
                                                                                             BUG6979
     C     USRID         IFNE      *BLANKS                                                   BUG6979
     C     USRID         ANDNE     PSUser                                                    BUG6979
     C                   MOVE      'Y'           JAVAUSER          1                         BUG6979
     C                   ELSE                                                                BUG6979
     C                   MOVE      'N'           JAVAUSER                                    BUG6979
     C                   ENDIF                                                               BUG6979
     C/COPY WNCPYSRC,GLH00302
      *                                                                                      BUG6979
      ** Check the User details extension to retrieve the journal                            BUG6979
      ** entry authorisation for CGL008                                                      BUG6979
      *                                                                                      BUG6979
     C     CGL008        IFEQ      'Y'                                                       BUG6979
     C     JAVAUSER      ANDEQ     'Y'                                                       BUG6979
     C                   CALL      'AOUSERR0'                                                BUG6979
     C                   PARM      *BLANKS       PRTNC                                       BUG6979
     C                   PARM      '*KEY   '     POPTN                                       BUG6979
     C                   PARM      USRID         PUSRP            10                         BUG6979
     C     SDUSER        PARM      SDUSER        DSSDY                                       BUG6979
                                                                                             BUG6979
      ** An NRF (No Record Found) return code is valid.                                      BUG6979
      ** Issue database error only for error return codes.                                   BUG6979
     C                   IF        PRTNC <> *BLANKS AND PRTNC <> '*NRF   '                   BUG6979
     C                   EVAL      DBFile = 'ZMUSER'                                         BUG6979
     C                   EVAL      DBKey = USRID                                             BUG6979
     C                   EVAL      DBase = 006                                               BUG6979
     C                   EXSR      SRERR                                                     BUG6979
     C                   ENDIF                                                               BUG6979
      *                                                                                      BUG6979
     C                   ENDIF                                                               BUG6979
      *                                                                                      BUG6979
     C/COPY WNCPYSRC,GLH00444
      ** Validate Front Office Id; it must not be blank.
      *
     C     B1FRNT        IFEQ      *BLANKS
     C*****CGL125        ANDEQ     'N'                                              CSC054 AR1092517
     C*****CAP209        ANDEQ     'N'                                            AR1092517 MD045854
     C     CAP209        ANDEQ     'N'                                                      MD046910
     C                   MOVEL     B1FRNT        DBKEY
     C                   MOVEL(P)  'GLVBITHPD'   DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** If a dummy header record is found, update record.  Else,
      ** add a new header record.
      *
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     B1BTNB        ANDNE     *BLANKS                                                    CAP084
     C     KJENH0        CHAIN     GLJENHL0                           01                      CAP084
     C                   ELSE                                                                 CAP084
     C**********         IF        CGL125 = 'N'                                     CSC054 AR1027164
     C     KJENH         CHAIN     GLJENHL3                           01
     C**********         ENDIF                                                      CSC054 AR1027164
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
      ** If JAVA User is accepting a batch perform some extra validation                      CAP084
      ** Using fields from the file that are not available in the VAL Module                  CAP084
      *                                                                                       CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     B1BTSF        ANDEQ     'A'                                                        CAP084
                                                                                              CAP084
     C     CGL008        IFEQ      'Y'                                                        CAP084
     C                   EXSR      SRCGL008                                                   CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   EXSR      SRCHKTOT                                                   CAP084
                                                                                              CAP084
     C/COPY WNCPYSRC,GLH00634
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C     *IN01         IFEQ      *OFF
     C                   EXSR      SRUpdate
     C                   ELSE
     C                   EXSR      SRWrite
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00604
                                                                                              CSC011
      ** If CSC011 is on and program is running in the support system,                        CSC011
      ** convert journal entry details in file format to screen format                        CSC011
      ** before writing to API log file.                                                      CSC011
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
      *
      ** Exit program.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update Header record                              *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
      ** Record already exists but Batch in Use is not 'Y',
      ** Batch Status is not 'H' and Workstation Id is not
      ** blanks.
      *
     C     BRBIUF        IFNE      'Y'
     C     JAVAUSER      ANDEQ     'N'                                                        CAP084
     C     CGL148        AndEQ     'N'                                                        CGL148
     C     BRBTSF        ORNE      'H'
     C     CGL182        ANDEQ     'N'                                                        CGL182
     C     BRWSID        ORNE      *BLANKS
     C     JAVAUSER      ANDEQ     'N'                                                        CAP084
     C     BRBTSF        ORNE      'H'                                                        CGL182
     C     BRBTSF        ANDNE     'P'                                                        CGL182
     C     CGL182        ANDEQ     'Y'                                                        CGL182
      *
     C                   MOVEL     B1FRNT        DBKEY
     C                   MOVEL(P)  'GLJENHPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Move valid file details to update file details.
      *
     C                   MOVE      B1BCDA        BRBCDA
     C                   MOVE      B1DPCD        BRDPCD
      *
      ** Move integer values.
      *
     C                   Z-ADD     B1HIIN        BRHIIN
     C                   Z-ADD     B1HDIN        BRHDIN
     C                   Z-ADD     B1HINI        BRHINI
      *
      ** Input Branch Code on file should not be overwritten.
      *
     C                   MOVE      BRIBCF        B1IBCF
      *
     C                   MOVE      WVSUB1        WVSUB2
      *
     C                   MOVE      B1FRNT        BRFRNT
     C                   MOVE      B1AFRT        BRAFRT
     C                   MOVE      B1TMST        BRTMST
     C**********         MOVE      B1BHAI        BRBHAI                                       239155
      *                                                                                       JMI111
      /COPY WNCPYSRC,JMI111_010                                                               JMI111
      *                                                                                       JMI111
     C     CGL016        IFEQ      'Y'                                                     AR792734A
     C     CRE023        OREQ      'Y'                                                     AR792734A
      *                                                                                       JMI111
      /COPY WNCPYSRC,JMI111_011                                                               JMI111
      *                                                                                       JMI111
     C                   MOVE      B1BHAI        BRBHAI                                    AR792734A
     C                   ENDIF                                                             AR792734A
     C                   MOVE      B1MEAB        BRMEAB                                       CSC024
                                                                                              237621
      ** If coming from JAVA front end                                                        237621
      ** If retail account access security is on....                                          237621
                                                                                              237621
     C     JAVAUSER      IFEQ      'Y'                                                        237621
     C     CGL037        ANDEQ     'Y'                                                        237621
                                                                                              237621
      ** ... find out what the menu option taken was and suffix the                           237621
      ** front office ID accordingly.                                                         237621
                                                                                              237621
     C                   In        ZMITEM                                                     237621
                                                                                              237621
      ** Front office only updated from 3rd party                                             CSC054
     C**********         IF        CGL125 = 'N'                                     CSC054 AR1092517
     C**********         IF        CAP209 = 'N'                                   AR1092517 MD045854
     C                   IF        CAP209 = 'N'                                             MD046910
                                                                                              CSC054
      ** Journal entry - non-retail                                                           237621
     C                   If        INDX = '0000002745'                                        237621
     C                   Eval      BRFRNT = %trimr(BRFRNT) + 'N'                              237621
     C                   Else                                                                 237621
                                                                                              237621
      ** Journal entry - all accounts                                                         237621
     C                   Eval      BRFRNT = %trimr(BRFRNT) + 'Y'                              237621
     C                   EndIf                                                                237621
                                                                                              CSC054
     C**********         ENDIF                                                       CSC054 MD045854
     C                   ENDIF                                                              MD046910
                                                                                              CSC054
     C                   EndIf                                                                237621
      *                                                                                       CAP084
      ** Delete batch header record if B1BHAI is flagged as 'D'                               CAP084
      *                                                                                       CAP084
     C     B1BHAI        IFEQ      'D'                                                        CAP084
     C     JAVAUSER      ANDEQ     'Y'                                                        CAP084
     C     BRBTSF        ANDEQ     'H'                                                        CAP084
     C*****BRBIUF        ANDNE     'Y'                                                CAP084 BUG1898
     C     B1BIUF        ANDNE     'Y'                                                       BUG1898
      *                                                                                       CAP084
     C                   MOVE      *BLANKS       FWP4            100                         BUG3500
     C                   CALL      'FC0040X'                                                 BUG3500
     C                   PARM      *BLANKS       FRTCD             7                         BUG3500
     C                   PARM      'GL0123    '  FWP1             10                         BUG3500
     C                   PARM      'GL0101C   '  FWP2             10                         BUG3500
     C                   PARM      '10001'       FWP3              5                         BUG3500
     C                   PARM      BRBTNB        FWP4                                        BUG3500
     C                   PARM      BRMBRB        FWP5              1                         BUG3500
     C                   PARM      'S'           FWP6              1                         BUG3500
     C                   PARM      *BLANKS       FWP7              3                         BUG3500
      ** Include a delay so that the submitted job from FC0040X can complete before          BUG3500
      ** before the batch details get deleted.                                               BUG3500
     C                   Z-ADD     50            CMDLEN           15 5                       BUG3500
     C                   CALL      'QCMDEXC'                                                 BUG3500
     C                   PARM                    CMD1                                        BUG3500
     C                   PARM                    CMDLEN                                      BUG3500
      * Delete summary                                                                       BUG3500
     C     BRBTNB        SETLL     @BSREAI                            99                     BUG3500
     C     *IN99         IFEQ      *OFF                                                      BUG3500
     C     BRBTNB        READE     @BSREAI                                98                 BUG3500
     C     *IN98         DOWEQ     *OFF                                                      BUG3500
     C                   DELETE    @BSREAI                                                   BUG3500
     C     BRBTNB        READE     @BSREAI                                98                 BUG3500
     C                   ENDDO                                                               BUG3500
     C                   ENDIF                                                               BUG3500
     C                   SETOFF                                       9899                   BUG3500
      * Delete batch items                                                                   BUG3500
     C     BRBTNB        SETLL     @BTREAK                            99                     BUG3500
     C     *IN99         IFEQ      *OFF                                                      BUG3500
     C     BRBTNB        READE     @BTREAK                                98                 BUG3500
     C     *IN98         DOWEQ     *OFF                                                      BUG3500
                                                                                           AR792734A
     C**********         Move      'N'           OUTWRD            1              MD033630 MD033630A
     C*****CRE023        IFEQ      'Y'                                            AR792734A MD036967
     C                   IF        CRE023 = 'Y' AND CAP207='N'                              MD036967
     C                             OR CRE023='Y' AND CAP207='Y'                             MD036967
     C                             AND BTDCIN = 'D'                                         MD036967
     C                   EXSR      UPDPOST                                                 AR792734A
     C                   ENDIF                                                             AR792734A
                                                                                           AR792734A
     C                   DELETE    @BTREAK                                                   BUG3500
     C     CGL016        IFEQ      'Y'                                                     AR792734A
     C*****CRE023        OREQ      'Y'                                           AR792734A MD033630A
     C*****OUTWRD        AndEq     'Y'                                            MD033630 MD033630A
     C                   EXSR      REVPOST                                                 AR792734A
     C                   ENDIF                                                             AR792734A
     C     BRBTNB        READE     @BTREAK                                98                 BUG3500
     C                   ENDDO                                                               BUG3500
     C                   ENDIF                                                               BUG3500
     C                   SETOFF                                       9899                   BUG3500
     C/COPY WNCPYSRC,GLBITHDC03
     C                   DELETE    @BRREAG                                                    CAP084
      *                                                                                       CER001
      ** Delete batch items in extension file                                                 CER001
      *                                                                                       CER001
     C                   SETOFF                                       9899                    CER001
     C     BRBTNB        SETLL     GLJENPDL                           99                      CER001
     C     *IN99         IFEQ      *OFF                                                       CER001
     C     BRBTNB        READE     GLJENPDL                               98                  CER001
      *                                                                                       CER001
     C     *IN98         DOWEQ     *OFF                                                       CER001
     C                   DELETE    GLJENPDL                                                   CER001
     C     BRBTNB        READE     GLJENPDL                               98                  CER001
     C                   ENDDO                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C                   SETOFF                                       9899                    CER001
      *                                                                                     MD042261
      ** Delete batch items in extension file GLJENP1D                                      MD042261
      *                                                                                     MD042261
     C     CGL135        IFEQ      'Y'                                                      MD042261
     C                   MOVEL     BJRDNB        BTPTDT                                     MD042261
     C                   MOVEL     BRBTNB        BTBTNB                                     MD042261
     C     KJEN1P        SETLL     GLJENPD0                           99                    MD042261
     C     *IN99         IFEQ      *OFF                                                     MD042261
     C     KJEN1P        READE     GLJENPD0                               98                MD042261
      *                                                                                     MD042261
     C     *IN98         DOWEQ     *OFF                                                     MD042261
     C                   DELETE    GLJENPD0                                                 MD042261
     C     KJEN1P        READE     GLJENPD0                               98                MD042261
     C                   ENDDO                                                              MD042261
      *                                                                                     MD042261
     C                   ENDIF                                                              MD042261
     C                   SETOFF                                       9899                  MD042261
     C                   ENDIF                                                              MD042261
      ** If CER030 is installed, delete Multicash Narratives if                             BUG26246
      ** present in PF/GLMNARPD.                                                            BUG26246
      *                                                                                     BUG26246
     C                   IF        CER030 = 'Y'                                             BUG26246
     C*****KLDLSB        SETLL     GLMNARL6                           99          BUG26246 BUG26246A
     C     KLDLSB        SETLL     GLMNARL7                           99                   BUG26246A
     C     *IN99         IFEQ      *OFF                                                     BUG26246
     C*****BTBTNB        READE     GLMNARL6                               98      BUG26246 BUG26246A
     C     BTBTNB        READE     GLMNARL7                               98               BUG26246A
     C     *IN98         DOWEQ     *OFF                                                     BUG26246
     C                   DELETE    GLMNARD0                                                 BUG26246
     C*****BTBTNB        READE     GLMNARL6                               98      BUG26246 BUG26246A
     C     BTBTNB        READE     GLMNARL7                               98               BUG26246A
     C                   ENDDO                                                              BUG26246
     C                   ENDIF                                                              BUG26246
     C                   ENDIF                                                              BUG26246
     C                   SETOFF                                       9899                  BUG26246
      *                                                                                     BUG26246
      ** If CGL013 is installed, delete Additional Information if                           BUG26246
      ** present in PF/GLJENXPD.                                                            BUG26246
      *                                                                                     BUG26246
     C                   IF        CGL013 = 'Y'                                             BUG26246
     C     BTBTNB        SETLL     GLJENXL5                           99                    BUG26246
     C     *IN99         IFEQ      *OFF                                                     BUG26246
     C     BTBTNB        READE     GLJENXL5                               98                BUG26246
     C     *IN98         DOWEQ     *OFF                                                     BUG26246
     C                   DELETE    GLJENXD0                                                 BUG26246
     C     BTBTNB        READE     GLJENXL5                               98                BUG26246
     C                   ENDDO                                                              BUG26246
     C                   ENDIF                                                              BUG26246
     C                   ENDIF                                                              BUG26246
     C                   SETOFF                                       9899                  BUG26246
      *                                                                                       CAP084
     C/COPY WNCPYSRC,GLH00765
     C     BRBTNB        CHAIN     GLBTNOL0                           21                     BUG7426
     C                   IF        *IN21 = *OFF                                              BUG7426
     C                   DELETE    GLBTNOD0                                                  BUG7426
     C                   ENDIF                                                               BUG7426
                                                                                             BUG7426
     C/COPY WNCPYSRC,GLH00766
     C                   ELSE                                                                 CAP084

     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C**********         MOVE      B1BTSF        BRBTSF                                CAP084 239155
     C     CGL016        IFEQ      'Y'                                                     AR792734A
     C     CRE023        OREQ      'Y'                                                     AR792734A
     C                   MOVE      B1BTSF        BRBTSF                                    AR792734A
     C                   ENDIF                                                             AR792734A
     C                   MOVE      B1BIUF        BRBIUF                                      BUG1898
     C                   MOVE      B1WSID        BRWSID                                     BUG1175R
     C                   ENDIF                                                                CAP084
      *
      ** If Valid Indicator is 'N', move the value to file field.
      *
     C     B1VALI        IFEQ      'N'
     C                   MOVE      B1VALI        BRVALI
     C                   ENDIF
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
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      BRAUTH = B1AUTH                                            CAP086
     C                   ENDIF                                                                CAP086
      *
      ** Update header file
      *
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C                   UPDATE    @BRREAG                                                    CAP084
     C                   ELSE                                                                 CAP084
     C                   UPDATE    @BRREMA
     C                   ENDIF                                                                CAP084
      *                                                                                    AR992022A
      ** If Online Printing of Advice is on and is set in the system,                      AR992022A
      ** update READVCPD once batch is accepted                                            AR992022A
      *                                                                                    AR992022A
     C                   IF        CRE020 = 'Y'                                            AR992022A
     C                             AND PSysVal = 'Y'                                       AR992022A
     C                             AND B1BTSF = 'A'                                        AR992022A
     C                   EXSR      SrUpdAdvice                                             AR992022A
     C                   IF        CRE023 = 'Y'                                            AR992022A
     C                             AND CGL016 = 'Y'                                        AR992022A
     C                   CALL      'QCMDEXC'                                               AR992022A
     C                   PARM                    SBMAdvice                                 AR992022A
     C                   PARM                    SBMAdvLngth                               AR992022A
     C                   ENDIF                                                             AR992022A
     C                   ENDIF                                                             AR992022A
      *
     C/COPY OFCPYSRCZ,CGL135_016                                                             CGL135A
      *                                                                                       CAP084
      ** If batch status is accepted, submit batch for shadow                                 CAP084
      ** posting.                                                                             CAP084
      *                                                                                       CAP084
     C*****BRBTSF        IFEQ      'A'                                                 CAP084 239155
     C     B1BTSF        IFEQ      'A'                                                        239155
     C     BRSHPI        ANDNE     'Y'                                                        CAP084
     C     CGL016        ANDNE     'Y'                                                     AR792734A
     C*****B1BTSF        OREQ      'A'                                           AR792734A MD033630A
     C*****BRSHPI        ANDNE     'Y'                                           AR792734A MD033630A
     C*****CRE023        ANDNE     'Y'                                           AR792734A MD033630A
     C/COPY WNCPYSRC,GLH00303
     C                   CALL      'GLSBMBCH'                                                 CAP084
     C                   PARM      *BLANK        PRTCD             7                          CAP084
     C                   PARM      BRBTNB        PBTNB             3                          CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   ENDIF                                                                CAP084
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write New Header record                            *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
     C/COPY WNCPYSRC,GLH00069
      *
      ** Get next batch number.
      ** If batch number has not been entered by user                                         CAP084
      *
     C     B1BTNB        IFEQ      *BLANKS                                                    CAP084
     C     B1BTNB        ORNE      *BLANKS                                                    CAP084
     C     JAVAUSER      ANDNE     'Y'                                                        CAP084
     C/COPY WNCPYSRC,GLH00445
     C                   CALLB     'ZAGENBTCHN'
     C                   PARM                    PErrorFlag        1
     C                   PARM                    PBTNO             3
     C/COPY WNCPYSRC,GLH00446
      *
     C     PErrorFlag    IFEQ      'Y'
     C                   MOVEL     B1FRNT        DBKEY
     C                   MOVEL(P)  'GLJENHPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CAP084
     C                   ENDIF                                                                CAP084
     C/COPY WNCPYSRC,GLH00070
      *                                                                                     BUG1175R
      ** Set up user ID that has set the batch in use                                       BUG1175R
      *                                                                                     BUG1175R
     C     JAVAUSER      IFEQ      'Y'                                                        243743
     C                   Eval      B1WSID = USRID                                           BUG1175R
     C                   ENDIF                                                                243743
      *
      ** Move valid file details to update file details.
      *
     C                   MOVEL     PVBITH        WJENH
      *
     C     B1BTNB        IFEQ      *BLANKS                                                    CAP084
     C/COPY WNCPYSRC,GLH00071
     C                   MOVEL     PBTNO         B1BTNB                                    AR1027164
     C                   MOVEL     PBTNO         BRBTNB
     C/COPY WNCPYSRC,GLH00072
     C                   ENDIF                                                                CAP084
     C**********         MOVE      'Y'           BRBIUF                                     BUG13083
     C**********         MOVE      'N'           BRBIUF                           BUG13083 BUG13083A
     C                   IF        B1AUTH = 'Y'                                               249405
     C                   MOVE      ' '           BRBIUF                                       249405
     C                   ELSE                                                                 249405
     C                   MOVE      'Y'           BRBIUF                                    BUG13083A
     C                   ENDIF                                                                249405
      *                                                                                       CAP084
      ** If coming from JAVA front end then set up front office ID as 'APCTRANVU'             CAP084
      ** suffixed with the batch header number                                                CAP084
      ** And set up batch number for return to GLBITHVU                                       CAP084
      *                                                                                       CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
      *                                                                                       CSC054
      ** Front office only updated from 3rd party                                             CSC054
     C**********         IF        CGL125 = 'N'                                     CSC054 AR1092517
     C**********         IF        CAP209 = 'N'                                   AR1092517 MD045854
     C                   IF        CAP209 = 'N'                                             MD046910
     C                   MOVE      *BLANKS       FRNTID            9                          CAP084
     C                   MOVEL     B1FRNT        FRNTID                                       CAP084
     C     FRNTID        CAT       BRBTNB        BRFRNT                                       CAP084
     C**********         ENDIF                                                       CSC054 MD045854
     C                   ENDIF                                                              MD046910
                                                                                              CSC054
     C                   MOVE      BRBTNB        B1BTNB                                       CAP084
      *                                                                                      BUG9009
      ** If retail account access security is on....                                         BUG9009
     C                   If        CGL037 = 'Y'                                              BUG9009
      *                                                                                      BUG9009
      ** ... find out what the menu option taken was and suffix the                          BUG9009
      ** front office ID accordingly.                                                        BUG9009
     C                   In        ZMITEM                                                    BUG9009
      *                                                                                      BUG9009
      ** Front office only updated from 3rd party                                             CSC054
     C**********         IF        CGL125 = 'N'                                     CSC054 AR1092517
     C**********         IF        CAP209 = 'N'                                   AR1092517 MD045854
     C                   IF        CAP209 = 'N'                                             MD046910
                                                                                              CSC054
      ** Journal entry - non-retail                                                          BUG9009
     C                   If        INDX = '0000002745'                                       BUG9009
     C                   Eval      BRFRNT = %trimr(BRFRNT) + 'N'                             BUG9009
     C                   Else                                                                BUG9009
      *                                                                                      BUG9009
      ** Journal entry - all accounts                                                        BUG9009
     C                   Eval      BRFRNT = %trimr(BRFRNT) + 'Y'                             BUG9009
     C                   EndIf                                                               BUG9009
                                                                                              CSC054
     C**********         ENDIF                                                       CSC054 MD045854
     C                   ENDIF                                                              MD046910
                                                                                              CSC054
     C                   EndIf                                                               BUG9009
     C                   ENDIF                                                                CAP084
      *
      ** If Security on Journal Entry is *ON, set Last Insert
      ** User field to system user.  Use correct user field if java user
      *
     C     CGL008        IFEQ      'Y'
     C/COPY WNCPYSRC,GLBITHDC01                                                               GOC001
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C                   MOVE      USRID         BRUSRI                                       CAP084
     C                   ELSE                                                                 CAP084
     C                   MOVE      PSUser        BRUSRI
     C                   ENDIF                                                                CAP084
     C                   ENDIF
      *                                                                         186206
      ** Write to Today's batch numbers used                                    186206
      *                                                                         186206
     C/COPY WNCPYSRC,GLH00707
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
     C/COPY WNCPYSRC,GLH00708
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C**********                   AND CGL125 = 'N'                                 CSC054 AR1092517
     C**********                   AND CAP209 = 'N'                               AR1092517 MD045854
     C                             AND CAP209 = 'N'                                         MD046910
     C                   IF        BRFRNT = *BLANKS                                           CSC011
     C                   EVAL      BRFRNT = 'MD' + BRBTNB                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      BRAUTH = B1AUTH                                            CAP086
     C                   ENDIF                                                                CAP086
      *
     C                   WRITE     @BRREMA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      **                                                              *                       CSC011
      ** SRCONVERT - convert journal entry details to screen format   *                       CSC011
      ** ~~~~~~~     before writing to standard API log file.         *                       CSC011
      **                                                              *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRCONVERT     BEGSR                                                                CSC011
                                                                                              CSC011
      ** Input:                                                                               CSC011
      ** JE details in file format                                                            CSC011
                                                                                              CSC011
      ** Output parameters:                                                                   CSC011
      ** Return Code                                                                          CSC011
      ** JE details in screen format                                                          CSC011
     C                   CALLB     'GLBITHLOG'                                                CSC011
     C                   PARM                    ReturnCode                                   CSC011
     C                   PARM                    WJENH                                        CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If error occurred in program, return with an error code.                             CSC011
     C                   IF        ReturnCode <> *BLANKS                                      CSC011
     C                   EVAL      DBASE = 006                                                CSC011
     C                   EVAL      DBFILE = 'GLBITHLOG'                                       CSC011
     C                   EVAL      DBKEY = '*CALL'                                            CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      **                                                              *                       CSC011
      ** SRAPILOG - write trade details to API standard log file.     *                       CSC011
      **                                                              *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRAPILOG      BEGSR                                                                CSC011
                                                                                              CSC011
     C                   CLEAR                   PHead                                        CSC011
      ** Fill up other neccessary information in the header to be used                        CSC011
      ** by APITRANLOG                                                                        CSC011
     C                   EVAL      APTGTTYPE = 'GLBITH'                                       CSC011
     C                   EVAL      APFOTRANID = BRFRNT                                        CSC011
     C                   EVAL      APFOASOCID = BRAFRT                                        CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
                                                                                              CSC011
      ** Batch number                                                                         CSC011
     C                   EVAL      PDealNo = BRBTNB                                           CSC011
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
      *****************************************************************                       CAP084
      **                                                              *                       CAP084
      ** SRCGL008 - Check whether the user is authorised to accept    *                       CAP084
      **            a batch or not                                    *                       CAP084
      *****************************************************************                       CAP084
                                                                                              CAP084
     C     SRCGL008      BEGSR                                                                CAP084
                                                                                              CAP084
     C                   IF        B1AUTH = 'Y'  AND                                          CAP086
     C**********                   WOMEInd = 'Y' AND                                   CAP086 CSC054
     C**********                   CSC024 = 'Y'                                        CAP086 CSC054
     C                             WPEAInd = 'Y' AND                                          CSC054
     C                             CSC054 = 'Y'                                               CSC054
                                                                                              CAP086
      ***Bypass*validation*if*from*replay*and*in*OME*system                            CAP086 CSC054
      ** Bypass validation if from replay and in PEA system                                   CSC054
                                                                                              CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C     M_USRLVL      IFEQ      'Z'                                                        CAP084
     C*****BRUSRI        IFEQ      USRID                                             CAP084 MD031298
     C*****BRUSRA        OREQ      USRID                                             CAP084 MD031298
     C     BRUSRA        IFEQ      USRID                                                    MD031298
     C**********         MOVE      'CGL0002'     PRTCD                                CAP084 BUG1698
     C                   MOVE      'CGL0002'     JERRMSG                                     BUG1698
     C                   RETURN                                                               CAP084
     C                   ENDIF                                                                CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP084
     C     M_USRLVL      IFEQ      'E'                                                        CAP084
     C**********         MOVE      'CGL0003'     PRTCD                                CAP084 BUG1898
     C                   MOVE      'CGL0003'     JERRMSG                                     BUG1898
     C                   RETURN                                                               CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
      /EJECT                                                                                  CAP084
      *****************************************************************                       CAP084
      **                                                              *                       CAP084
      ** SRCHKTOT - Check input and calculated totals for integer     *                       CAP084
      **            and decimals match so batch can be accepted       *                       CAP084
      *****************************************************************                       CAP084
                                                                                              CAP084
     C     SRCHKTOT      BEGSR                                                                CAP084
                                                                                              CAP084
     C*****BRBIUF        IFNE      'Y'                                                CAP084 BUG1898
     C     B1BIUF        IFNE      'Y'                                                       BUG1898
      **Check*the GL ICD set up if Batch Totaling is mandatory or not.                 237512 245211
     C*****Retbkmhtn     IFEQ      'Y'                                                 237512 245211
                                                                                              CAP084
      * Hash integer/decimal input not zero                                                   245211
     C     BRHIIN        IFNE      0                                                          245211
     C     BRHDIN        ORNE      0                                                          245211
     C     BRHICC        IFNE      BRHIIN                                                     CAP084
     C     BRHDCC        ORNE      BRHDIN                                                     CAP084
     C                   MOVE      'GLX0075'     JERRMSG                                      245211
     C                   RETURN                                                               245211
     C                   ENDIF                                                                245211
     C                   ENDIF                                                                245211
      *                                                                                       245211
      * Hash item nbr input not zero                                                          245211
     C*****BRHINI        ORNE      BRHINC                                              CAP084 245211
     C     BRHINI        IFNE      0                                                          245211
     C     BRHINI        ANDNE     BRHINC                                                     245211
     C**********         MOVE      'GLX0075'     PRTCD                                CAP084 BUG1898
     C                   MOVE      'GLX0075'     JERRMSG                                     BUG1898
     C                   RETURN                                                               CAP084
     C                   ENDIF                                                                CAP084
      *****                                                                            237512 245211
     C*****              ENDIF                                                         237512 245211
     C     BRHINC        IFEQ      *ZEROS                                                     CAP084
     C**********         MOVE      'GLX0232'     PRTCD                                CAP084 BUG1898
     C                   MOVE      'GLX0232'     JERRMSG                                     BUG1898
     C                   RETURN                                                               CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
                                                                                              CAP084
     C**********         MOVE      'GLX0041'     PRTCD                                CAP084 BUG1898
     C                   MOVE      'GLX0041'     JERRMSG                                     BUG1898
     C                   RETURN                                                               CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
     C/COPY WNCPYSRC,GLH00635
      /EJECT                                                                                  CAP084
      *****************************************************************                       CAP084
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
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
      *                                                                                      BUG1898
      ** Parameter to contain error message for java user                                    BUG1898
     C                   PARM                    JERRMSG           7                         BUG1898
      *                                                                                       237512
      ** Parameter to contain BKHMTN from GL ICD                                              237512
     C                   PARM                    Retbkmhtn         1                          237512
      *
      ** Define key list for GLJENHL3.
      *
     C     KJENH         KLIST
     C                   KFLD                    B1FRNT
      *                                                                                       CAP084
      ** Define key list for GLJENHL0.                                                        CAP084
      *                                                                                       CAP084
     C     KJENH0        KLIST                                                                CAP084
     C                   KFLD                    B1BTNB                                       CAP084
      *                                                                                     BUG26246
      ***Define*key*list*for*GLMNARL6******************************               BUG26246 BUG26246A
      ** Define key list for GLMNARL7                                                      BUG26246A
      *                                                                                     BUG26246
     C     KLDLSB        KLIST                                                              BUG26246
     C                   KFLD                    BTBTNB                                     BUG26246
     C**********         KFLD                    BTBINB                           BUG26246 BUG26246A
      *                                                                                     MD042261
     C     KJEN1P        KLIST                                                              MD042261
     C                   KFLD                    BTPTDT                                     MD042261
     C                   KFLD                    BTBTNB                                     MD042261
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
     C                   EVAL      DBase = 005                                                CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTNC = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Check if Retail account security is installed.                                      BUG9009
     C                   CallB     'AOSARDR0'                                                BUG9009
     C                   Parm      *BLANKS       PRTNC                                       BUG9009
     C                   Parm      '*VERIFY'     POPTN                                       BUG9009
     C                   Parm      'CGL037'      PSARD                                       BUG9009
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG9009
                                                                                             BUG9009
      ** An NRF (No Record Found) return code is valid.                                      BUG9009
      ** Issue database error only for error return codes.                                   BUG9009
     C                   If        PRTNC <> *BLANKS and PRTNC <> '*NRF   '                   BUG9009
     C                   Eval      DBFile = 'SCSARDPD'                                       BUG9009
     C                   Eval      DBKey = 'CGL037'                                          BUG9009
     C                   Eval      DBase = 006                                               BUG9009
     C                   ExSr      *PSSR                                                     BUG9009
     C                   EndIf                                                               BUG9009
                                                                                             BUG9009
     C                   If        PRTNC = *BLANKS                                           BUG9009
     C                   Eval      CGL037 = 'Y'                                              BUG9009
     C                   Else                                                                BUG9009
     C                   Eval      CGL037 = 'N'                                              BUG9009
     C                   EndIf                                                               BUG9009
                                                                                             BUG9009
      ** Check if On Line Printing of Advice is on                                          AR992022
                                                                                            AR992022
     C                   CALLB     'AOSARDR0'                                               AR992022
     C                   PARM      *BLANKS       PRtnCode                                   AR992022
     C                   PARM      '*VERIFY'     POption                                    AR992022
     C                   PARM      'CRE020'      PSard                                      AR992022
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR992022
                                                                                            AR992022
     C                   IF        PRtnCode = *BLANKS                                       AR992022
     C                   EVAL      CRE020 = 'Y'                                             AR992022
     C                   ENDIF                                                              AR992022
                                                                                            AR992022
      ** Database Error for SAR File                                                        AR992022
                                                                                            AR992022
     C                   IF        PRtnCode <> *BLANKS AND                                  AR992022
     C                             PRtnCode <> '*NRF'                                       AR992022
     C                   EVAL      DBFILE = 'SCSARDPD'                                      AR992022
     C                   EVAL      DBASE = 036                                              AR992022
     C                   EVAL      DBKEY = 'CRE020'                                         AR992022
     C                   EXSR      *PSSR                                                    AR992022
     C                   ENDIF                                                              AR992022
                                                                                            AR992022
      ** Check if system value for the maintenance is on                                    AR992022
                                                                                            AR992022
     C                   IF        CRE020 = 'Y'                                             AR992022
                                                                                            AR992022
     C                   CALL      'AOSVALR0'                                               AR992022
     C                   PARM                    PRtnCode                                   AR992022
     C                   PARM                    PSValOpt                                   AR992022
     C                   PARM                    PSysVal                                    AR992022
     C                   PARM                    PSValOptB                                  AR992022
     C                   PARM                    PSysValB                                   AR992022
     C                   PARM                    PSValOptB                                  AR992022
     C                   PARM                    PSysValB                                   AR992022
     C                   PARM                    PSValOptB                                  AR992022
     C                   PARM                    PSysValB                                   AR992022
     C                   PARM                    PSValOptB                                  AR992022
     C                   PARM                    PSysValB                                   AR992022
     C                   PARM                    PSValOptB                                  AR992022
     C                   PARM                    PSysValB                                   AR992022
     C                   PARM                    PSValOptB                                  AR992022
     C                   PARM                    PSysValB                                   AR992022
     C                   PARM                    PSValOptB                                  AR992022
     C                   PARM                    PSysValB                                   AR992022
     C                   PARM                    PSValOptB                                  AR992022
     C                   PARM                    PSysValB                                   AR992022
     C                   PARM                    PSValOptB                                  AR992022
     C                   PARM                    PSysValB                                   AR992022
                                                                                            AR992022
      ** Database Error for System Values File                                              AR992022
                                                                                            AR992022
     C                   IF        PRtnCode <> *Blanks                                      AR992022
     C                   EVAL      DBFILE = 'SDSVALPD'                                      AR992022
     C                   EVAL      DBASE = 037                                              AR992022
     C                   EVAL      DBKEY = PsValOpt                                         AR992022
     C                   EXSR      *PSSR                                                    AR992022
     C                   ENDIF                                                              AR992022
                                                                                            AR992022
     C                   ENDIF                                                              AR992022
                                                                                            AR992022
     C/COPY WNCPYSRC,GLBITHDC02                                                               GOC001
      ** Check if enhancement CSC024 (Open Month End) is on                                   CAP086
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRTCD                                        CAP086
     C                   PARM      '*VERIFY'     POPTN                                        CAP086
     C**********         PARM      'CSC024'      PSARD                                 CAP086 CSC054
     C                   PARM      'CSC054'      PSARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C**********         EVAL      DBKey  = 'CSC024'                                   CAP086 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 9                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C**********         EVAL      CSC024 = 'N'                                        CAP086 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CAP086 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CAP086
     C                   IF        PRTCD = *BLANKS                                            CAP086
     C**********         EVAL      CSC024 = 'Y'                                        CAP086 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
                                                                                              CAP086
      ** Access System values                                                                 CAP086
                                                                                              CAP086
     C                   CALL      'AOSVALR0'                                                 CAP086
     C                   PARM      *BLANKS       PRetCode                                     CAP086
     C                   PARM      PSysVal1      P@OP01                                       CAP086
     C                   PARM      *BLANKS       P@VL01                                       CAP086
     C                   PARM      *BLANKS       P@OP02                                       CAP086
     C                   PARM      *BLANKS       P@VL02                                       CAP086
     C                   PARM      *BLANKS       P@OP03                                       CAP086
     C                   PARM      *BLANKS       P@VL03                                       CAP086
     C                   PARM      *BLANKS       P@OP04                                       CAP086
     C                   PARM      *BLANKS       P@VL04                                       CAP086
     C                   PARM      *BLANKS       P@OP05                                       CAP086
     C                   PARM      *BLANKS       P@VL05                                       CAP086
     C                   PARM      *BLANKS       P@OP06                                       CAP086
     C                   PARM      *BLANKS       P@VL06                                       CAP086
     C                   PARM      *BLANKS       P@OP07                                       CAP086
     C                   PARM      *BLANKS       P@VL07                                       CAP086
     C                   PARM      *BLANKS       P@OP08                                       CAP086
     C                   PARM      *BLANKS       P@VL08                                       CAP086
     C                   PARM      *BLANKS       P@OP09                                       CAP086
     C                   PARM      *BLANKS       P@VL09                                       CAP086
     C                   PARM      *BLANKS       P@OP10                                       CAP086
     C                   PARM      *BLANKS       P@VL10                                       CAP086
                                                                                              CAP086
     C                   IF        PRetCode  <> *BLANKS                                       CAP086
     C                   EVAL      DBFile = 'SDSVALPD'                                        CAP086
     C                   EVAL      DBKEy = '*KEY   '                                          CAP086
     C                   EVAL      DBase = 10                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
     C                   IF        P@VL01 = 'Y'                                               CAP086
     C**********         EVAL      WOMEInd = 'Y'                                       CAP086 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRTCD                                        CAP086
     C                   PARM      '*VERIFY'     POPTN                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRTCD <> *BLANKS AND                                       CAP086
     C                             PRTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'GLBITHUPD'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 8                                                 CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        PRTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                               BUG11437
     C                   EVAL      PRTCD = *BLANK                                           BUG11437
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Access SAR details for Projected Movements Update Prior to Auth.                  AR792734A
                                                                                           AR792734A
     C                   MOVEL     'N'           CGL016                                    AR792734A
     C                   CALLB     'AOSARDR0'                                              AR792734A
     C                   PARM      *BLANKS       PRTCD                                     AR792734A
     C                   PARM      '*VERIFY'     POPTN                                     AR792734A
     C                   PARM      'CGL016'      PSARD                                     AR792734A
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR792734A
                                                                                           AR792734A
     C     PRTCD         IFEQ      *BLANK                                                  AR792734A
     C                   MOVEL     'Y'           CGL016                                    AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
      ** Access SAR details file to see if CER030 is installed.                             BUG26246
      *                                                                                     BUG26246
     C                   CALLB     'AOSARDR0'                                               BUG26246
     C                   PARM      *BLANKS       PRTCD                                      BUG26246
     C                   PARM      '*VERIFY'     POPTN                                      BUG26246
     C                   PARM      'CER030'      PSARD                                      BUG26246
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG26246
                                                                                            BUG26246
     C                   IF        PRTCD <> *BLANKS AND                                     BUG26246
     C                             PRTCD <> '*NRF'                                          BUG26246
     C     *LOCK         IN        LDA                                                      BUG26246
     C                   EVAL      DBPGM = 'GLBITHUPD'                                      BUG26246
     C                   EVAL      DBKEY = 'CER030'                                         BUG26246
     C                   EVAL      DBFILE ='SCSARDPD'                                       BUG26246
     C                   EVAL      DBASE  = 11                                              BUG26246
     C                   OUT       LDA                                                      BUG26246
     C                   EXSR      *PSSR                                                    BUG26246
     C                   ENDIF                                                              BUG26246
                                                                                            BUG26246
     C     PRTCD         IFEQ      *BLANK                                                   BUG26246
     C                   MOVE      'Y'           CER030            1                        BUG26246
     C                   ELSE                                                               BUG26246
     C                   MOVE      'N'           CER030                                     BUG26246
     C                   ENDIF                                                              BUG26246
      *                                                                                     BUG26246
      ** Access SAR details file to see if CGL013 is installed.                             BUG26246
      *                                                                                     BUG26246
     C                   CALLB     'AOSARDR0'                                               BUG26246
     C                   PARM      *BLANKS       PRTCD                                      BUG26246
     C                   PARM      '*VERIFY'     POPTN                                      BUG26246
     C                   PARM      'CGL013'      PSARD                                      BUG26246
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG26246
                                                                                            BUG26246
     C                   IF        PRTCD <> *BLANKS AND                                     BUG26246
     C                             PRTCD <> '*NRF'                                          BUG26246
     C     *LOCK         IN        LDA                                                      BUG26246
     C                   EVAL      DBPGM = 'GLBITHUPD'                                      BUG26246
     C                   EVAL      DBKEY = 'CGL013'                                         BUG26246
     C                   EVAL      DBFILE ='SCSARDPD'                                       BUG26246
     C                   EVAL      DBASE  = 12                                              BUG26246
     C                   OUT       LDA                                                      BUG26246
     C                   EXSR      *PSSR                                                    BUG26246
     C                   ENDIF                                                              BUG26246
                                                                                            BUG26246
     C     PRTCD         IFEQ      *BLANK                                                   BUG26246
     C                   MOVE      'Y'           CGL013                                     BUG26246
     C                   ELSE                                                               BUG26246
     C                   MOVE      'N'           CGL013                                     BUG26246
     C                   ENDIF                                                              BUG26246
      *                                                                                     BUG26246
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
      *                                                                                       CGL148
      ** Access SAR details file to see if CGL125 is installed.                               CSC054
      *                                                                                       CSC054
     C                   CALLB     'AOSARDR0'                                                 CSC054
     C                   PARM      *BLANKS       PRTCD                                        CSC054
     C                   PARM      '*VERIFY'     POPTN                                        CSC054
     C                   PARM      'CGL125'      PSARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC054
      *                                                                                       CSC054
     C                   IF        PRTCD <> *BLANKS AND                                       CSC054
     C                             PRTCD <> '*NRF'                                            CSC054
     C     *LOCK         IN        LDA                                                        CSC054
     C                   EVAL      DBPGM = 'GLBITHUPD'                                        CSC054
     C                   EVAL      DBKEY = 'CGL125'                                           CSC054
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC054
     C                   EVAL      DBASE  = 13                                                CSC054
     C                   OUT       LDA                                                        CSC054
     C                   EXSR      *PSSR                                                      CSC054
     C                   ENDIF                                                                CSC054
      *                                                                                       CSC054
     C     PRTCD         IFEQ      *BLANK                                                     CSC054
     C                   MOVE      'Y'           CGL125            1                          CSC054
     C                   ELSE                                                                 CSC054
     C                   MOVE      'N'           CGL125                                       CSC054
     C                   ENDIF                                                                CSC054
      *                                                                                       CSC054
      ** Access SAR details file to see if CGL135 is installed.                             MD042261
      *                                                                                     MD042261
     C                   MOVE      'N'           CGL135            1                        MD042261
     C                   CALL      'AOSARDR0'                                               MD042261
     C                   PARM      *BLANKS       PRTCD                                      MD042261
     C                   PARM      '*VERIFY'     POPTN                                      MD042261
     C                   PARM      'CGL135 '     PSARD                                      MD042261
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD042261
      *                                                                                     MD042261
     C                   IF        PRTCD = *BLANKS                                          MD042261
     C                   EVAL      CGL135 = 'Y'                                             MD042261
     C                   ENDIF                                                              MD042261
     C**********         MOVE      *BLANKS       PRTCD                              BUG9713 MD020144
      **********                                                                    BUG9713 MD020144
     C/COPY WNCPYSRC,GLH00447
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER*-          CAP084 BUG6979
      **their*user*name*is*stored*in*ZMUSER                                           CAP084 BUG6979
     C**********         IN        ZMUSER                                             CAP084 BUG6979
      **********                                                                      CAP084 BUG6979
     C*****USRID         IFNE      *BLANKS                                            CAP084 BUG6979
     C*****USRID         ANDNE     PSUser                                             CAP084 BUG6979
     C**********         MOVE      'Y'           JAVAUSER          1                  CAP084 BUG6979
     C**********         ELSE                                                         CAP084 BUG6979
     C**********         MOVE      'N'           JAVAUSER                             CAP084 BUG6979
     C**********         ENDIF                                                        CAP084 BUG6979
      **********                                                                      CAP084 BUG6979
      ***Check*the*User*details*extension*to*retrieve*the*journal                     CAP084 BUG6979
      ***entry*authorisation*for*CGL008                                               CAP084 BUG6979
      **********                                                                      CAP084 BUG6979
     C*****CGL008        IFEQ      'Y'                                                CAP084 BUG6979
     C*****JAVAUSER      ANDEQ     'Y'                                                CAP084 BUG6979
     C**********         CALL      'AOUSERR0'                                         CAP084 BUG6979
     C**********         PARM      *BLANKS       PRTNC                                CAP084 BUG6979
     C**********         PARM      '*KEY   '     POPTN                                CAP084 BUG6979
     C**********         PARM      USRID         PUSRP            10                  CAP084 BUG6979
     C*****SDUSER        PARM      SDUSER        DSSDY                                CAP084 BUG6979
      **********                                                                      CAP084 BUG6979
      ***An*NRF*(No*Record*Found)*return*code*is*valid.                               CAP084 BUG6979
      ***Issue*database*error*only*for*error*return*codes.                            CAP084 BUG6979
     C**********         IF        PRTNC <> *BLANKS AND PRTNC <> '*NRF   '            CAP084 BUG6979
     C**********         EVAL      DBFile = 'ZMUSER'                                  CAP084 BUG6979
     C**********         EVAL      DBKey = USRID                                      CAP084 BUG6979
     C**********         EVAL      DBase = 006                                        CAP084 BUG6979
     C**********         EXSR      SRERR                                              CAP084 BUG6979
     C**********         ENDIF                                                        CAP084 BUG6979
      **********                                                                      CAP084 BUG6979
     C**********         ENDIF                                                        CAP084 BUG6979
      *                                                                                    AR792734A
      ** Check for 2 O'clock Flag SAR                                                      AR792734A
      *                                                                                    AR792734A
     C                   EVAL      CRE023 = 'N'                                            AR792734A
     C                   CALLB     'AOSARDR0'                                              AR792734A
     C                   PARM      *BLANKS       @RTCD                                     AR792734A
     C                   PARM      '*VERIFY'     @OPTN                                     AR792734A
     C                   PARM      'CRE023'      @SARD                                     AR792734A
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR792734A
      *                                                                                    AR792734A
      ** An NRF (No Record Found) return code is valid.  Issue database error              AR792734A
      ** only for error return codes.                                                      AR792734A
      *                                                                                    AR792734A
     C                   IF        (@RTCD <> *BLANKS) AND                                  AR792734A
     C                             (@RTCD <> '*NRF   ')                                    AR792734A
     C                   EVAL      DBKEY = 'CRE023'                                        AR792734A
     C                   EVAL      DBFILE = 'SCSARDPD'                                     AR792734A
     C                   EVAL      DBASE = 13                                              AR792734A
     C                   EXSR      *PSSR                                                   AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
     C                   IF        @RTCD = *BLANK                                          AR792734A
     C                   EVAL      CRE023 = 'Y'                                            AR792734A
     C                   OPEN      MEMOSL2                                                 AR792734A
     C                   OPEN      REMEMLL0                                                AR792734A
     C                   OPEN      RETTYPL0                                                AR792734A
     C                   ENDIF                                                             AR792734A
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
      *                                                                                    AR792734A
      ** Access Bank Details                                                               AR792734A
      *                                                                                    AR792734A
     C                   CALLB     'AOBANKR0'                                              AR792734A
     C                   PARM      *BLANKS       @RTCD                                     AR792734A
     C                   PARM      '*FIRST'      @OPTN                                     AR792734A
     C     SDBANK        PARM      SDBANK        DSFDY                                     AR792734A
      *                                                                                    AR792734A
      ** Database Error                                                                    AR792734A
      *                                                                                    AR792734A
     C                   IF        @RTCD <> *BLANKS                                        AR792734A
     C                   EVAL      DBKEY  = @OPTN                                          AR792734A
     C                   EVAL      DBFILE = 'SDBANKPD'                                     AR792734A
     C                   EVAL      DBASE  = 14                                             AR792734A
     C                   EXSR      *PSSR                                                   AR792734A
     C                   ENDIF                                                             AR792734A
      *****************************************************************           AR1092517 MD045854
      ***Access*SAR*details*file*to*see*if*CAP209*is*installed.********           AR1092517 MD045854
      *****************************************************************           AR1092517 MD045854
     C**********         MOVE      'N'           CAP209            1              AR1092517 MD045854
     C**********         CALL      'AOSARDR0'                                     AR1092517 MD045854
     C**********         PARM      *BLANKS       PRTCD                            AR1092517 MD045854
     C**********         PARM      '*VERIFY'     POPTN                            AR1092517 MD045854
     C**********         PARM      'CAP209'      PSARD                            AR1092517 MD045854
     C*****SCSARD        PARM      SCSARD        DSFDY                            AR1092517 MD045854
      *                                                                           AR1092517 MD045854
     C**********         IF        PRTCD <> *BLANKS AND                           AR1092517 MD045854
     C**********                   PRTCD <> '*NRF'                                AR1092517 MD045854
     C******LOCK         IN        LDA                                            AR1092517 MD045854
     C**********         EVAL      DBPGM = 'GLBITHVU'                             AR1092517 MD045854
     C**********         EVAL      DBKEY = 'CAP209'                               AR1092517 MD045854
     C**********         EVAL      DBFILE ='SCSARDPD'                             AR1092517 MD045854
     C**********         EVAL      DBASE  = 5                                     AR1092517 MD045854
     C**********         OUT       LDA                                            AR1092517 MD045854
     C**********         EXSR      *PSSR                                          AR1092517 MD045854
     C**********         ENDIF                                                    AR1092517 MD045854
      *                                                                           AR1092517 MD045854
     C**********         IF        PRTCD = *BLANKS                                AR1092517 MD045854
     C**********         EVAL      CAP209 = 'Y'                                   AR1092517 MD045854
     C**********         ENDIF                                                    AR1092517 MD045854
      **********                                                                  AR1092517 MD045854
      *****************************************************************                     MD046910
      ** Access SAR details file to*see if CAP209 is installed.                             MD046910
      *****************************************************************                     MD046910
     C                   MOVE      'N'           CAP209            1                        MD046910
     C                   CALL      'AOSARDR0'                                               MD046910
     C                   PARM      *BLANKS       PRTCD                                      MD046910
     C                   PARM      '*VERIFY'     POPTN                                      MD046910
     C                   PARM      'CAP209'      PSARD                                      MD046910
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD046910
      *                                                                                     MD046910
     C                   IF        PRTCD <> *BLANKS AND                                     MD046910
     C                             PRTCD <> '*NRF'                                          MD046910
     C     *LOCK         IN        LDA                                                      MD046910
     C                   EVAL      DBPGM = 'GLBITHVU'                                       MD046910
     C                   EVAL      DBKEY = 'CAP209'                                         MD046910
     C                   EVAL      DBFILE ='SCSARDPD'                                       MD046910
     C                   EVAL      DBASE  = 5                                               MD046910
     C                   OUT       LDA                                                      MD046910
     C                   EXSR      *PSSR                                                    MD046910
     C                   ENDIF                                                              MD046910
      *                                                                                     MD046910
     C                   IF        PRTCD = *BLANKS                                          MD046910
     C                   EVAL      CAP209 = 'Y'                                             MD046910
     C                   ENDIF                                                              MD046910
      *                                                                                     MD046910
      ** Access SAR details file to see if CGL182 is installed.                               CGL182
      *                                                                                       CGL182
     C                   CALL      'AOSARDR0'                                                 CGL182
     C                   PARM      *BLANKS       PRTCD                                        CGL182
     C                   PARM      '*VERIFY'     POPTN                                        CGL182
     C                   PARM      'CGL182'      PSARD                                        CGL182
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL182
      *                                                                                       CGL182
     C                   IF        PRTCD <> *BLANKS AND                                       CGL182
     C                             PRTCD <> '*NRF'                                            CGL182
     C     *LOCK         IN        LDA                                                        CGL182
     C                   EVAL      DBPGM = 'GLBITHVU'                                         CGL182
     C                   EVAL      DBKEY = 'CGL182'                                           CGL182
     C                   EVAL      DBFILE ='SCSARDPD'                                         CGL182
     C                   EVAL      DBASE  = 15                                                CGL182
     C                   OUT       LDA                                                        CGL182
     C                   EXSR      *PSSR                                                      CGL182
     C                   ENDIF                                                                CGL182
      *                                                                                       CGL182
     C                   IF        PRTCD = *BLANKS                                            CGL182
     C                   EVAL      CGL182 = 'Y'                                               CGL182
     C                   ENDIF                                                                CGL182
      *                                                                                       CGL182
     C/COPY WNCPYSRC,GLH00709
      *
     C/COPY OFCPYSRCZ,CGL135_015                                                             CGL135A
      *
     C                   MOVE      *BLANKS       PRTCD                                      MD020144
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      ****************************************************************                      AR992022
      /EJECT                                                                                AR992022
      *****************************************************************                     AR992022
      *                                                               *                     AR992022
      *  SrUpdAdvice - Handles the advice index of the current        *                     AR992022
      *                transaction.                                   *                     AR992022
      *                                                               *                     AR992022
      *****************************************************************                     AR992022
     C     SrUpdAdvice   BEGSR                                                              AR992022
      *                                                                                     AR992022
      ** Process all available batches.                                                     AR992022
      *                                                                                     AR992022
     C                   MOVE      BRBTNB        KBTNB             3                        AR992022
      *                                                                                     AR992022
     C                   OPEN      GLJENPL1                                                 AR992022
      *                                                                                     AR992022
     C     KBTNB         SETLL     GLJENPL1                                                 AR992022
     C     KBTNB         READE     GLJENPL1                               38                AR992022
      *                                                                                     AR992022
     C     *IN38         DOWNE     *ON                                                      AR992022
      *                                                                                     AR992022
     C                   MOVE      *BLANKS       WRefNo                                     AR992022
     C**********         MOVEL     BTBTNB        WRefNo                           AR992022 AR992022A
     C**********         MOVE      BTBINB        WRefNo                           AR992022 AR992022A
     C                   MOVEL     MBTBTNB       WRefNo                                    AR992022A
     C                   MOVE      MBTBINB       WRefNo                                    AR992022A
     C                   EVAL      RREFNO = *BLANKS                                         AR992022
     C                   EVAL      RREFNO = WRefNo                                          AR992022
     C                   EVAL      RPRGMN = *BLANKS                                         AR992022
     C                   EVAL      RPRGMN = 'GLBITHUPD '                                    AR992022
     C                   EVAL      RSEQNO = *BLANKS                                         AR992022
     C                   EVAL      RTRTYP = 'ME'                                            AR992022
     C                   EVAL      RCHTYP = 'I'                                             AR992022
     C                   EVAL      RAUTHI = 'Y'                                             AR992022
     C                   EVAL      RSAPIN = 'N'                                             AR992022
     C                   EVAL      RENARR = *BLANKS                                         AR992022
     C                   OPEN      READVCL1                                                 AR992022
     C                   WRITE     READVCD0                                                 AR992022
     C                   CLOSE     READVCL1                                                 AR992022
      *                                                                                     AR992022
     C     KBTNB         READE     GLJENPL1                               38                AR992022
     C                   ENDDO                                                              AR992022
      *                                                                                     AR992022
     C                   CLOSE     GLJENPL1                                                 AR992022
      *                                                                                     AR992022
     C                   ENDSR                                                              AR992022
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
      ** If current batch has dumped already, don't execute dump                186206
      *                                                                         186206
     C/COPY WNCPYSRC,GLH00710
     C     BRBTNB        CHAIN     GLBTNOL0                           21        186206
      *                                                                         186206
     C                   IF        *IN21 = *OFF AND B3DUMP <> 'Y'               186206
      *
     C                   DUMP
      *                                                                         186206
     C                   MOVE      'Y'           B3DUMP                         186206
     C                   UPDATE    GLBTNOD0                                     186206
     C                   ENDIF                                                  186206
      *
     C/COPY WNCPYSRC,GLH00711
      ** Terminate program.
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                    AR792734A
      *                                                               *                    AR792734A
      *  UPDPOST - Update MEMOS and REMEMLPD when header with items   *                    AR792734A
      *            is deleted.                                        *                    AR792734A
      *                                                               *                    AR792734A
      *****************************************************************                    AR792734A
      *                                                                                    AR792734A
     C     UPDPOST       BEGSR                                                             AR792734A
      *                                                                                    MD033630A
     C     BTRACN        CHAIN     MEMOSL2                                                 MD033630A
      *                                                                                    MD033630A
     C                   IF        (NOT(%FOUND)) OR                                        MD033630A
     C                             (%FOUND AND RECI <> 'D')                                MD033630A
     C                   UNLOCK    MEMOSL2                                                 MD033630A
     C                   LEAVESR                                                           MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update ledger balance of MEMOSL2                                                  MD033630A
      *                                                                                    MD033630A
     C                   IF        BTDCIN = 'D'                                            MD033630A
     C                   EVAL      LDBLN = LDBLN + BTPTAM                                  MD033630A
     C                   ELSE                                                              MD033630A
     C                   EVAL      LDBLN = LDBLN - BTPTAM                                  MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update the cleared balance                                                        MD033630A
      *                                                                                    MD033630A
     C                   IF        BTVLDT <= BJRDNB                                        MD033630A
      *                                                                                    MD033630A
     C                   IF        BTDCIN = 'D'                                            MD033630A
     C                   EVAL      CLBLN = CLBLN + BTPTAM                                  MD033630A
     C                   ELSE                                                              MD033630A
     C                   EVAL      CLBLN = CLBLN - BTPTAM                                  MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
     C                   ENDIF                                                             MD033630A
      *                                                                                    MD033630A
      ** Update MEMOS file                                                                 MD033630A
      *                                                                                    MD033630A
     C                   UPDATE    MEMOSMDF                                                MD033630A
      *                                                                                    AR792734A
      ** Setup posting amount fields of REMEMLL0                                           AR792734A
      *                                                                                    AR792734A
     C                   IF        BTVLDT > BJDNWD                                         AR792734A
     C                   LEAVESR                                                           AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
     C     BTTRTY        CHAIN     RETTYPL0                                                AR792734A
      *                                                                                    AR792734A
     C                   IF        (NOT(%FOUND)) OR                                        AR792734A
     C                             (%FOUND AND GRECI <> 'D')                               AR792734A
      *                                                                                     MD035554
      ** Exclude Outward Clearing Checks with Value Date equal to Run Date                  MD035554
      *                                                                                     MD035554
     C                             Or (%FOUND And GRECI = 'D'                               MD035554
     C                                And GOCLR = 'Y' and BTVLDT = BJRDNB)                  MD035554
     C                   LEAVESR                                                           AR792734A
     C**********         Else                                                     MD033630 MD033630A
     C**********         Move      'Y'           OUTWRD                           MD033630 MD033630A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
     C     BTRACN        CHAIN     REMEMLL0                                                AR792734A
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
     C                   EVAL      GTAMT = GTAMT - BTPTAM                                  AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
      ** If the transaction is a Reversal of Today's Outward Clearing                      AR792734A
      *                                                                                    AR792734A
     C                   IF        GRCLT = 'Y'                                             AR792734A
     C                   EVAL      GTAMT = GTAMT + BTPTAM                                  AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
      ** If the transaction is a Reversal of Previous Outward Clearing                     AR792734A
      *                                                                                    AR792734A
     C                   IF        GRCLP = 'Y'                                             AR792734A
     C                   EVAL      GPAMT = GPAMT + BTPTAM                                  AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
      ** Update REMEMLL0                                                                   AR792734A
      *                                                                                    AR792734A
     C                   UPDATE    REMEMLD0                                                AR792734A
      *                                                                                    AR792734A
     C                   ENDSR                                                             AR792734A
      *                                                                                    AR792734A
      *****************************************************************                    AR792734A
      /EJECT                                                                               AR792734A
      *****************************************************************                    AR792734A
      *                                                               *                    AR792734A
      *  REVPOST - Reverse postings when header with items deleted.   *                    AR792734A
      *                                                               *                    AR792734A
      *****************************************************************                    AR792734A
      *                                                                                    AR792734A
     C     REVPOST       BEGSR                                                             AR792734A
      *                                                                                    AR792734A
     C                   CALL      'AOACCTR0'                                              AR792734A
     C                   PARM      *BLANKS       UUAPRC                                    AR792734A
     C                   PARM      '*KEY'        UUAPOP                                    AR792734A
     C                   PARM      *BLANKS       UUACID                                    AR792734A
     C                   PARM                    BTCUST                                    AR792734A
     C                   PARM                    BTCYCD                                    AR792734A
     C                   PARM                    BTACCD                                    AR792734A
     C                   PARM                    BTACSN                                    AR792734A
     C                   PARM                    BTIBCA                                    AR792734A
     C     D@ACCT        PARM      *BLANKS       DSSDY                                     AR792734A
      *                                                                                    AR792734A
     C     ATYP          IFEQ      'R'                                                     AR792734A
      *                                                                                    AR792734A
     C                   MOVE      BTBTNB        LBTBTNB                                   AR792734A
     C                   Z-ADD     BTBINB        LBTBINB                                   AR792734A
     C                   MOVE      BTIBCA        LBTIBCA                                   AR792734A
     C                   MOVE      BTCUST        LBTCUST                                   AR792734A
     C                   MOVE      BTCYCD        LBTCYCD                                   AR792734A
     C                   MOVE      BTACCD        LBTACCD                                   AR792734A
     C                   MOVE      BTACSN        LBTACSN                                   AR792734A
     C                   MOVE      BTNNBI        LBTNNBI                                   AR792734A
     C                   Z-ADD     BTRACN        LBTRACN                                   AR792734A
     C                   MOVE      BTRINO        LBTRINO                                   AR792734A
     C                   MOVE      BTRINE        LBTRINE                                   AR792734A
     C                   MOVE      BTTRTY        LBTTRTY                                   AR792734A
     C                   Z-ADD     BTPTAM        LBTPTAM                                   AR792734A
     C                   Z-ADD     BTPTDT        LBTPTDT                                   AR792734A
     C                   Z-ADD     BTVLDT        LBTVLDT                                   AR792734A
     C                   MOVE      BTNVCD        LBTNVCD                                   AR792734A
     C                   MOVE      BTNRDC        LBTNRDC                                   AR792734A
     C                   MOVE      'RE'          LBTNRDC                                   AR792734A
     C                   MOVE      BTACTY        LBTACTY                                   AR792734A
     C                   MOVE      BTACNB        LBTACNB                                   AR792734A
     C                   MOVE      BTCQNB        LBTCQNB                                   AR792734A
     C                   MOVE      BTCOIN        LBTCOIN                                   AR792734A
     C                   MOVE      BTSWCR        LBTSWCR                                   AR792734A
     C                   MOVE      BTPRCN        LBTPRCN                                   AR792734A
     C                   MOVE      BTBCBH        LBTBCBH                                   AR792734A
     C                   MOVE      BTRADP        LBTRADP                                   AR792734A
     C                   MOVE      BTSHPI        LBTSHPI                                   AR792734A
     C                   Z-ADD     BTRRNM        LBTRRNM                                   AR792734A
     C                   MOVE      BTRNBE        LBTRNBE                                   AR792734A
     C                   MOVE      BTRARC        LBTRARC                                   AR792734A
     C                   MOVE      BTTSTY        LBTTSTY                                   AR792734A
     C                   MOVE      BTBKCD        LBTBKCD                                   AR792734A
     C                   Z-ADD     BTSPFC        LBTSPFC                                   AR792734A
     C                   MOVE      BTRVDI        LBTRVDI                                   AR792734A
     C                   Z-ADD     BTNITM        LBTNITM                                   AR792734A
     C                   MOVE      BTOCCY        LBTOCCY                                   AR792734A
     C                   Z-ADD     BTOAMT        LBTOAMT                                   AR792734A
     C                   MOVE      BTFRNT        LBTFRNT                                   AR792734A
     C                   MOVE      BTAFRT        LBTAFRT                                   AR792734A
     C                   MOVE      BTTMST        LBTTMST                                   AR792734A
     C                   MOVE      BTVALI        LBTVALI                                   AR792734A
     C                   MOVE      BTDUPC        LBTDUPC                                   AR792734A
     C                   MOVE      BTOUTR        LBTOUTR                                   AR792734A
      *                                                                                    AR792734A
     C     BTDCIN        IFEQ      'C'                                                     AR792734A
     C                   MOVE      'D'           LBTDCIN                                   AR792734A
     C                   ELSE                                                              AR792734A
     C                   MOVE      'C'           LBTDCIN                                   AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
     C                   CALL      'GL004446'                                              AR792734A
     C                   PARM      *BLANKS       UUAPRC                                    AR792734A
     C                   PARM                    LJENP                                     AR792734A
      *                                                                                    AR792734A
     C     UUAPRC        IFNE      *BLANKS                                                 AR792734A
     C                   EXSR      *PSSR                                                   AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
     C                   ENDIF                                                             AR792734A
      *                                                                                    AR792734A
     C                   ENDSR                                                             AR792734A
      *****************************************************************                    AR792734A
      /EJECT                                                                               AR792734A
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
** CMD1                                                                                      BUG3500
DLYJOB DLY(2)                                                                                BUG3500
