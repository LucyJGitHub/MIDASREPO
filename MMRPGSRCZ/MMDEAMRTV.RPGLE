000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas MM Deal amendment retr + act/deal validation')   *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Money Market Dealing Module                          *
000900200528      *                                                               *
001000200528      *  MMDEAMRTV - DEAL AMENDMENTS RETRIEVE                         *
001100200528      *              (WITH ACTION CODE VERSUS DEAM NUMBER VALIDATION  *
001200200528      *                                                               *
001300200528      *  Function:  This module retrieves a deal amendment from       *
001400200528      *             the database. As it does so, it validates the     *
001500200528      *             action code, deal number, value date & seq.       *
001600200528      *                                                               *
001700200528      *  (c) Finastra International Limited 2001                      *
001800200528      *                                                               *
001900200604      *  Last Amend No. 260173             Date 22May20               *
002000200528      *  Prev Amend No. AR806147           Date 21May18               *
002100200528      *                 MD046248           Date 27Oct17               *
002200200528      *                 CDL099             Date 06Oct17               *
002300200528      *                 CGL165             Date 17Feb15               *
002400200528      *                 CDL096             Date 22Sep14               *
002500200528      *                 CDL094             Date 11Jun14               *
002600200528      *                 MD021204           Date 12Jul13               *
002700200528      *                 MD000091           Date 14May13               *
002800200528      *                 CSC054             Date 23Feb12               *
002900200528      *                 CRE073             Date 06Dec10               *
003000200528      *                 CER059             Date 19Jul10               *
003100200528      *                 CER054             Date 07Apr09               *
003200200528      *                 CER043             Date 19May08               *
003300200528      *                 CSD083             Date 27May10               *
003400200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
003500200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
003600200528      *                 256564             Date 17Sep08               *
003700200528      *                 256482             Date 14Oct08               *
003800200528      *                 256795             Date 25Sep08               *
003900200528      *                 BUG16961           Date 14Mar08               *
004000200528      * Midas Plus 1.4 Base ------------------------------------------*
004100200528      * Midas Plus 1.3 ----------- Base ------------------------------*
004200200528      *                 CAP185             Date 21Apr06               *
004300200528      *                 CDL049             Date 11Jul06               *
004400200528      *                 CSD031             Date 10Apr06               *
004500200528      *                 CSD027             Date 09Dec05               *
004600200528      *                 237063             Date 20Nov05               *
004700200528      *                 BUG8584            Date 30Sep05               *
004800200528      *                 BUG8114            Date 09Aug05               *
004900200528      *                 CDL038             Date 10May05               *
005000200528      *                 BUG8360            Date 12Sep05               *
005100200528      *                 BUG7537            Date 15Jul05               *
005200200528      *                 CSC024             Date 07Feb05               *
005300200528      *                 CDL033             Date 10Feb05               *
005400200528      *                 BUG7411            Date 01Jun05               *
005500200528      *                 BUG6534            Date 15Apr04               *
005600200528      *                 CDL028             Date 07Feb05               *
005700200528      *                 229544             Date 15Sep04               *
005800200528      *                 BUG4849            Date 08Dec04               *
005900200528      *                 BUG5092            Date 10Dec04               *
006000200528      *                 BUG4422            Date 01Oct04               *
006100200528      *                 BUG3499            Date 30Jun04               *
006200200528      *                 CDL022             Date 03Feb04               *
006300200528      *                 CDL020             Date 03Feb04               *
006400200528      *                 CDL017             Date 03Feb04               *
006500200528      *                 CGL029             Date 01Sep03               *
006600200528      *                 222727             Date 05Nov03               *
006700200528      *                 CAP084             Date 25Jun03               *
006800200528      *                 191881             Date 26Feb03               *
006900200528      *                 CSD015             Date 14Oct02               *
007000200528      *                 208100             Date 05Aug02               *
007100200528      *                 CDL010             Date 02Aug02               *
007200200528      * Midas Release 4.01 -------------------------------------------*
007300200528      * Midas Release 4 --------------- Base -------------------------*
007400200528      * Midas DBA 3.05 -----------------------------------------------*
007500200528      *                 CPB002             Date 12Jan01               *
007600200528      *                 185658             Date 20Dec00               *
007700200528      * Midas DBA 3.04 -----------------------------------------------*
007800200528      *                 176841             DATE 09May00               *
007900200528      * Midas DBA 3.02 -----------------------------------------------*
008000200528      *                 CSE006             Date 08Nov99               *
008100200528      *                 CAP051             Date 12Nov99               *
008200200528      *                 CPB001             Date 01Jun99               *
008300200528      * Midas DBA 3.01 -----------------------------------------------*
008400200528      *                 CDL006             Date 26Apr99               *
008500200528      * Midas DBA 3.00 ---------------- Base -------------------------*
008600200528      *                 CPL002             Date 08Mar99               *
008700200528      *                 CAP002  *CREATE    Date 22Sep97               *
008800200528      *                                                               *
008900200528      *---------------------------------------------------------------*
009000200528      *                                                               *
009100200528      *  260173 - Introduce new parameter to be used in the vali-     *
009200200528      *           dation of action code when authorising a reversal   *
009300200528      *           transaction. Apply fix 258724.                      *
009400200528      *  AR806147 - Value date of any deal amendment must be less     *
009500200528      *             than the Early Maturity date if deal has a live   *
009600200528      *             Early Maturity deal amendment. (Child: AR806148)  *
009700200528      *           - Applied for MD-48300.                             *
009800200528      *  MD046248 - Finastra Rebranding                               *
009900200528      *  CDL099 - Split Value Date (Recompile)                        *
010000200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
010100200528      *  CDL096 - Business Day Conventions on MM Deals                *
010200200528      *           (Recompile)                                         *
010300200528      *  CDL094 - Enhance Receive Settlement Instructions             *
010400200528      *           (Recompile)                                         *
010500200528      *  MD021204 - Impossible to create deal amendment via JMS_MQ    *
010600200528      *  MD000091 - Event Codes Substitution                          *
010700200528      *  CSC054 - Period End Adjustments                              *
010800200528      *  CRE073 - Interest Rate Rounding (Recompile)                  *
010900200528      *  CER059 - German Feature Upgrade to Delhi                     *
011000200528      *  CER054 - German Features - Church Tax (Recompile)            *
011100200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
011200200528      *  CSD083 - Watch List Compliance Upgrade                       *
011300200528      *  256564 - Recompile due to PF changes done by fix 256330      *
011400200528      *  256482 - Correct Front Office Associated ID validation.      *
011500200528      *           Applied 250398                                      *
011600200528      *  256795 - Penalty Termination of Time deposits (CDL052).      *
011700200528      *  BUG16961 - Error in matured deal                             *
011800200528      *  CAP185 - MQ Series Interface                                 *
011900200528      *  CDL049 - Addition of a Reference Rate field (recompile)      *
012000200528      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
012100200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
012200200528      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
012300200528      *  BUG8584 - Cannot enter new deal amendment due to error       *
012400200528      *            message MMM0149. Replaced HNDLTF (Logical          *
012500200528      *            Delete Flag) with HNDDLT (Deal Deleted Ind) as     *
012600200528      *            this field is not used anymore. Another issue      *
012700200528      *            is incorrect validation done for initial screen    *
012800200528      *            (in subr/VALACF) which is copied from VALACI.      *
012900200528      *            Validation should just be simple as proper         *
013000200528      *            checking will be done in VALACI anyway.            *
013100200528      *            (Similar to BUG7537)                               *
013200200528      *  BUG8114- Added 'CF' deal type for CDL033.                    *
013300200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
013400200528      *  BUG8360- EM should be prohibited under these conditions:     *
013500200528      *           1. Rollover indicator is automatic.                 *
013600200528      *           2. Rollover indicator is 'Yes' and deal is flagged  *
013700200528      *              as collateral.                                   *
013800200528      *           3. Deal is already rolled over.                     *
013900200528      *  BUG7537 - Cannot enter new deal amendment due to error       *
014000200528      *            message MMM0149. Replaced HNDLTF (Logical          *
014100200528      *            Delete Flag) with HNDDLT (Deal Deleted Ind) as     *
014200200528      *            this field is not used anymore. Another issue      *
014300200528      *            is incorrect validation done for initial screen    *
014400200528      *            (in subr/VALACF) which is copied from VALACI.      *
014500200528      *            Validation should just be simple as proper         *
014600200528      *            checking will be done in VALACI anyway.            *
014700200528      *  CSC024 - Open Month End                                      *
014800200528      *  CDL033 - Floating Rate CDs Issued                            *
014900200528      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
015000200528      *  BUG6534- Add validation to new initial input screen          *
015100200528      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
015200200528      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
015300200528      *  BUG4849- Should be allow to delete DEAM even DEAL is not     *
015400200528      *           authorised.                                         *
015500200528      *  BUG5092- Amendment type 'EM' not allowed for Blocked Deals   *
015600200528      *  BUG4422- Authorisation Error on DEAM.  Retrieve contents of  *
015700200528      *           DTAARA/ZMUSER for each user authorisation check.    *
015800200528      *  BUG3499- Decimal Data Error (Recompile)                      *
015900200528      *  CDL022 - Deal Amendment Changes (Recompile)                  *
016000200528      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
016100200528      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
016200200528      *                                                               *
016300200528      *  CGL029 - Increase Account Code to 10 digits                  *
016400200528      *  222727 - Release 5.0 errors  (Recompile)                     *
016500200528      *  CAP084 - API Wrapper project                                 *
016600200528      *  191881 - Next amendment action date (NAAD) and Next amendment*
016700200528      *           sequence (NASN) are not properly updated when a deal*
016800200528      *           amendment is authorised and related deal amendments *
016900200528      *           with lower value date or sequence are not authorised*
017000200528      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
017100200528      *  208100 - Check for further errors in subroutine VALAX.       *
017200200528      *  CDL010 - Prevent last user that actioned the trade from      *
017300200528      *           authorising it.                                     *
017400200528      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
017500200528      *  185658 - During authorisation of SI deal amendment, settle-  *
017600200528      *           ment details disappear. This is due to the wrong    *
017700200528      *           side being protected upon insertion of the amend-   *
017800200528      *           ment. Fix is to save the HNOMDT value (deal type of *
017900200528      *           the associated deal) and restore back after reading *
018000200528      *           a record from LF/MMLVDMLL (MMDEAMPP).  This is to   *
018100200528      *           ensure that the correct deal type is passed back to *
018200200528      *           MMDEAMSIN.                                          *
018300200528      *  176841 - User should be able to re-authorise a deal if       *
018400200528      *           'MM Authorisation Required' is 'N' and              *
018500200528      *           'MM Reauthorise Amended deals' is 'Y'.              *
018600200528      *  CSE006 - Repos Maintenance                                   *
018700200528      *  CAP051 - Automatic Authorisation (MM Part)                   *
018800200528      *           Recompiled due to changes in MMDEAMPP               *
018900200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
019000200528      *           Recompiled due to changes in MMDEAMPP               *
019100200528      *  CDL006 - Dealing Fiduciary.                                  *
019200200528      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
019300200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
019400200528      *                                                               *
019500200528      *****************************************************************
019600200528      ** +--------------------------------------+
019700200528      ** ¦ F-specs                              ¦
019800200528      ** ¦ =======                              ¦
019900200528      ** +--------------------------------------+
020000200528     FMMDEAML0  IF   E           K DISK    INFSR(*PSSR)
020100200528     F                                     RENAME(MMDEAMP0:MMDEAMOI)
020200200528     FMMDEAML3  IF   E           K DISK    INFSR(*PSSR)                                       CDL017
020300200528     F                                     RENAME(MMDEAMP0:MMDEAMEM)                          CDL017
020400200528     FMMDEALL0  IF   E           K DISK    INFSR(*PSSR)
020500200528     F                                     INCLUDE(MMDELDP0)
020600200528     F                                     INCLUDE(MMDENBP0)
020700200528     F                                     RENAME(MMDELDP0:MMDELFOI)
020800200528     F                                     RENAME(MMDENBP0:MMDENBOI)
020900200528     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
021000200528     F                                     INFDS(INFDS)
021100200528     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
021200200528     F                                     RENAME(MMDEAMP0:MMDEAMP2)
021300200528     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
021400200528     F                                     RENAME(MMDEAMP0:MMDEAMP4)
021500200528     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
021600200528     FDEALSH    IF   E           K DISK    INFSR(*PSSR)
021700200528     F                                     RENAME(DEALSDBF:DEALSHBF)
021800200528     F                                     RENAME(DEALSDCF:DEALSHCF)
021900200528     F                                     RENAME(DEALSDDF:DEALSHDF)
022000200528     F                                     RENAME(DEALSDEF:DEALSHEF)
022100200528     F                                     RENAME(DEALSDGF:DEALSHGF)
022200200528     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
022300200528                                                                                              CAP185
022400200528      ** Midas AP API Configuration                                                           CAP185
022500200528     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
022600200528     F/COPY WNCPYSRC,MMDEAMIF01
022700200528
022800200528      *****************************************************************
022900200528      ** +--------------------------------------+
023000200528      ** ¦ Automatically included D-specs       ¦
023100200528      ** ¦ ==============================       ¦
023200200528      ** +--------------------------------------+
023300200528      **
023400200528      ** Standard D-specs
023500200528      ** ================
023600200528      **
023700200528      ** The following /COPY line includes the LDA layout,
023800200528      ** the copyright array definition,
023900200528      ** and the following named constants:
024000200528      **    True       logical = *on (for indcator processing)
024100200528      **    False      logical = *off (for indcator processing)
024200200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
024300200528      **                                    handler)
024400200528      ** and the following variables:
024500200528      **    RunBefore  1A (for the PSSR)
024600200528
024700200528     D/COPY ZACPYSRC,STD_D_SPEC
024800200528
024900200528      ** Include the MM standard declares
025000200528     D/COPY ZACPYSRC,STDDECLARE
025100200528
025200200528      ** Program Status Data Structure
025300200528      ** =============================
025400200528      ** The following /COPY line includes all the defined fields in the
025500200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
025600200528
025700200528     D/COPY ZACPYSRC,PSDS
025800200528
025900200528      **--------------------------------------------------------------------------------------------
026000200528      ** The following /COPY line includes the definitions for error and
026100200528      ** warning message arrays.
026200200528     D/COPY ZACPYSRC,ERR_ARRAYS
026300200528      **--------------------------------------------------------------------------------------------
026400200528
026500200528      ** +--------------------------------------+
026600200528      ** ¦ End of automatically included D-specs¦
026700200528      ** ¦ =====================================¦
026800200528      ** +--------------------------------------+
026900200528      *****************************************************************
027000200528      /EJECT
027100200528      *****************************************************************
027200200528
027300200528      ** +--------------------------------------+
027400200528      ** ¦ Manually included D-specs            ¦
027500200528      ** ¦ =========================            ¦
027600200528      ** +--------------------------------------+
027700200528
027800200528      ** +--------------------------------------+
027900200528      ** ¦ Named constants                      ¦
028000200528      ** ¦ ===============                      ¦
028100200528      ** +--------------------------------------+
028200200528
028300200528     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
028400200528     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
028500200528
028600200528      ** +--------------------------------------+
028700200528      ** ¦ Arrays and Data Structures           ¦
028800200528      ** ¦ ==========================           ¦
028900200528      ** +--------------------------------------+
029000200528
029100200528     D***@DT2***         S              2    DIM(15) CTDATA PERRCD(15)                        CDL033
029200200528     D @DT2            S              2    DIM(16) CTDATA PERRCD(16)                          CDL033
029300200528     D**  ARRAY TO LOOK UP MIDAS DEAL TYPE FOR VALIDATION.
029400200528     D*
029500200528     D FIDTYP          S              2    DIM(6) CTDATA PERRCD(6)              CDL006
029600200528      ** Array to look up fiduciary deal type for validation                    CDL006
029700200528                                                                                CDL006
029800200528      **  Data structure for file status of MM deals file.
029900200528     D INFDS           DS
030000200528     D  RECORD           *RECORD
030100200528
030200200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
030300200528      ** EXTERNAL DS FOR BANK DETAILS
030400200528
030500200528     D SDGELR        E DS                  EXTNAME(SDGELRPD)
030600200528      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
030700200528
030800200528     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
030900200528      ** EXTERNAL DS FOR DEALING DETAILS
031000200528     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
031100200528
031200200528
031300200528     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
031400200528      ** EXTERNAL DS FOR BRANCH DETAILS
031500200528
031600200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSE006
031700200528      ** EXTERNAL DS FOR SWITCHABLE FEATURES FILE                               CSE006
031800200528                                                                                CSE006
031900200528     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
032000200528      ** Watch List Configuration Data File                                                   CSD015
032100200528                                                                                              CSD015
032200200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
032300200528      ** 24X7 status data area                                                                CSD015
032400200528                                                                                              CSD015
032500200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
032600200528      ** SD data area                                                                         CSD015
032700200528                                                                                              CSD015
032800200528     D DSFDY         E DS                  EXTNAME(DSFDY)
032900200528      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
033000200528
033100200528     D ZMUSER          DS            17
033200200528     D  ZUSER                  1     10                                                       CDL010
033300200528     D  BRC                   11     13
033400200528     D  DEPT                  14     16
033500200528
033600200528     D DeamFilFmt    E DS                  EXTNAME(MMDEAMPP)
033700200528      ** Deam in File Format
033800200528     D  @DMVYR                51     52
033900200528     D  @DMVMT                53     54
034000200528     D  @DMVDY                55     56
034100200528
034200200528      **  Data Structure to split value date used in key to deams file
034300200528     D                 DS
034400200528     D  @KVALD                 1      8  0 INZ(0)
034500200528     D  @VDYY                  1      4  0
034600200528     D  @VYEAR                 3      4  0
034700200528     D  @VDMM                  5      6  0
034800200528     D  @VDDD                  7      8  0
034900200528
035000200528     D                 DS
035100200528      **  Data Structure for screen value date
035200200528     D  ValueDate              1      6
035300200528     D  @DSPD                  1      2
035400200528     D  @DSPM                  3      4
035500200528     D  @DSPY                  5      6
035600200528
035700200528     D                 DS
035800200528     D**  Data Structure for input start/last interest date
035900200528     D  H@SLDT                 1      8  0 INZ(0)
036000200528     D  H@SLYY                 1      4  0
036100200528     D  H@SLMM                 5      6  0
036200200528     D  H@SLDD                 7      8  0
036300200528     D*
036400200528     D                 DS
036500200528     D**  Data Structure for input interest accrual control date
036600200528     D  H@IADT                 1      8  0 INZ(0)
036700200528     D  H@IAYY                 1      4  0
036800200528     D  H@IAMM                 5      6  0
036900200528     D  H@IADD                 7      8  0
037000200528     D*
037100200528     D                 DS
037200200528     D**  Data Structure for input maturity date
037300200528     D  H@MATD                 1      8  0 INZ(0)
037400200528     D  H@MDYY                 1      4  0
037500200528     D  H@MDMM                 5      6  0
037600200528     D  H@MDDD                 7      8  0
037700200528     D*
037800200528     D                 DS
037900200528     D**  Data structure for convertion of YYMMDD to DDMMYY
038000200528     D  @DMVDT                 1      6
038100200528     D  @DMVD                  1      2
038200200528     D  @DMVM                  3      4
038300200528     D  @DMVY                  5      6
038400200528                                                                                              CSD015
038500200528      **  AOWLCCR0 Function Code Parameter.                                                   CSD015
038600200528     D  PFuncCode      S              8                                                       CSD015
038700200528                                                                                              CSD015
038800200528      **  AOSARDR0 Switchable Feature Parameter.                                              CSD015
038900200528     D  PSARD          S              6                                                       CSD015
039000200528                                                                                              CSD015
039100200528      **  Compliance Watch Enhancement Indicator.                                             CSD015
039200200528     D  CSD015         S              1    INZ('N')                                           CSD015
039300200528                                                                                              CSD015
039400200528      ** 24X7 Midas Availability Indicator                                                    CSD015
039500200528     D CSC011          S              1    INZ('N')                                           CSD015
039600200528                                                                                              CSD015
039700200528      **  Compliance Watch Hit List Key Fields.                                               CSD015
039800200528     D  KFuncType      S              8                                                       CSD015
039900200528     D  KIden          S             40                                                       CSD015
040000200528     D  KBranch        S              3                                                       CSD015
040100200528                                                                                              CSD015
040200200528      ** Fields defined for Enhancement CSD015                                                CSD015
040300200528                                                                                              CSD015
040400200528     D WHNDA3          S              6A                                                      CSD015
040500200528     D WHNVDY          S              4A                                                      CSD015
040600200528     D WHNVDM          S              2A                                                      CSD015
040700200528     D WHNVDD          S              2A                                                      CSD015
040800200528     D WHNDS3          S              3A                                                      CSD015
040900200528                                                                                              CSD015
041000200528     D/COPY WNCPYSRC,MMDEAMID01
041100200528      ** +--------------------------------------+
041200200528      ** ¦ Declared variables                   ¦
041300200528      ** ¦ ==================                   ¦
041400200528      ** +--------------------------------------+
041500200528
041600200528      ** Index for arrays of of error message ids etc
041700200528     D Ix              S              3P 0
041800200528
041900200528      ** Fields used by Module ZDATE10 to change date format.
042000200528     D DateIn          S              8S 0
042100200528     D DateOut         S              5  0
042200200528     D CDL006          S              1A   IMPORT                               CDL006
042300200528
042400200528      *                                                                                       CGL029
042500200528     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
042600200528      *                                                                                       CGL029
042700200528     D PRetCode        S              7A                                                      CSC024
042800200528     D P@OP01          S             20A                                                      CSC024
042900200528     D P@VL01          S            200A                                                      CSC024
043000200528     D P@OP02          S             20A                                                      CSC024
043100200528     D P@VL02          S            200A                                                      CSC024
043200200528     D P@OP03          S             20A                                                      CSC024
043300200528     D P@VL03          S            200A                                                      CSC024
043400200528     D P@OP04          S             20A                                                      CSC024
043500200528     D P@VL04          S            200A                                                      CSC024
043600200528     D P@OP05          S             20A                                                      CSC024
043700200528     D P@VL05          S            200A                                                      CSC024
043800200528     D P@OP06          S             20A                                                      CSC024
043900200528     D P@VL06          S            200A                                                      CSC024
044000200528     D P@OP07          S             20A                                                      CSC024
044100200528     D P@VL07          S            200A                                                      CSC024
044200200528     D P@OP08          S             20A                                                      CSC024
044300200528     D P@VL08          S            200A                                                      CSC024
044400200528     D P@OP09          S             20A                                                      CSC024
044500200528     D P@VL09          S            200A                                                      CSC024
044600200528     D P@OP10          S             20A                                                      CSC024
044700200528     D P@VL10          S            200A                                                      CSC024
044800200528                                                                                              CSC024
044900200528     D*CSC024***       S              1A                                               CSC024 CSC054
045000200528     D*WOMEInd**       S              1A                                               CSC024 CSC054
045100200528     D CSC054          S              1A                                                      CSC054
045200200528     D WPEAInd         S              1A                                                      CSC054
045300200528                                                                                              CSC024
045400200528     D CER043          S              1A                                                      CER043
045500200528                                                                                              CER043
045600200528      ** Parameters for Calling ZDATE2                                                        CER043
045700200528     D ZDAYNO          S              5  0                                                    CER043
045800200528     D ZDATE           S              6  0                                                    CER043
045900200528     D ZADATE          S              7A                                                      CER043
046000200528                                                                                              CER043
046100200528      **                                                                                    MD000091
046200200528     D BChar           DS                                                                   MD000091
046300200528     D   BLen                  1      2B 0                                                  MD000091
046400200528     D   LenStr                1      2                                                     MD000091
046500200528                                                                                            MD000091
046600200528      ** +--------------------------------------+
046700200528      ** ¦ End of D-specs                       ¦
046800200528      ** ¦ ==============                       ¦
046900200528      ** +--------------------------------------+
047000200528      *****************************************************************
047100200528     I*
047200200528     I** Rename fields on deals file with common names
047300200528     I** to simplify processing
047400200528     IMMDELDP0
047500200528     I              HKRCID                      H@RCID
047600200528     I              HKDSTS                      H@DSTS
047700200528     I              HKDLTF                      H@DLTF
047800200528     I              HKDN38                      H@DN38
047900200528     I              HKDDLT                      H@DDLT
048000200528     I              HKMTYP                      H@MTYP
048100200528     I              HKAMNP                      H@AMNP
048200200528     I              HKBRCA                      H@BRCA
048300200528     I              HKSLYY                      H@SLYY
048400200528     I              HKSLMM                      H@SLMM
048500200528     I              HKSLDD                      H@SLDD
048600200528     I              HKIAYY                      H@IAYY
048700200528     I              HKIAMM                      H@IAMM
048800200528     I              HKIADD                      H@IADD
048900200528     I              HKTYPE                      H@TYPE
049000200528     I              HKMDYY                      H@MDYY
049100200528     I              HKMDMM                      H@MDMM
049200200528     I              HKMDDD                      H@MDDD
049300200528     I              HKORBR                      H@ORBR
049400200528     I*
049500200528     IMMDENBP0
049600200528     I              HLRCID                      H@RCID
049700200528     I              HLDSTS                      H@DSTS
049800200528     I              HLDLTF                      H@DLTF
049900200528     I              HLDN38                      H@DN38
050000200528     I              HLDDLT                      H@DDLT
050100200528     I              HLMTYP                      H@MTYP
050200200528     I              HLAMNP                      H@AMNP
050300200528     I              HLBRCA                      H@BRCA
050400200528     I              HLLIYY                      H@SLYY
050500200528     I              HLLIMM                      H@SLMM
050600200528     I              HLLIDD                      H@SLDD
050700200528     I              HLIAYY                      H@IAYY
050800200528     I              HLIAMM                      H@IAMM
050900200528     I              HLIADD                      H@IADD
051000200528     I              HLTYPE                      H@TYPE
051100200528     I              HLORBR                      H@ORBR
051200200528     I*
051300200528      /EJECT
051400200528     C**************************************************************
051500200528      *
051600200528      * INITIALIZATION
051700200528      *
051800200528     C                   EXSR      INIT
051900200528      *                                                                         CPB002
052000200528      * Front Office Transaction ID                                             CPB002
052100200528     C                   MOVEL     FOTRID        WFRONTID          2            CPB002
052200200528      *                                                                         CPB002
052300200528     C     WFRONTID      IFEQ      'TO'                                         CPB002
052400200528     C                   MOVE      *BLANKS       ModeofOp                       CPB002
052500200528     C                   ENDIF                                                  CPB002
052600200528     C/COPY WNCPYSRC,MMDEAMIC04
052700200528      *
052800200528      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
052900200528      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
053000200528      *
053100200528     C     ModeofOp      IFEQ      '*FRONT'
053200200528     C                   EXSR      VFRNT
053300200528      *
053400200528      **  Carry out no further validation if errors have occurred.
053500200528      *
053600200528     C     OKACTN        IFEQ      'N'
053700200528     C     OKDLNO        OREQ      'N'
053800200528     C                   RETURN
053900200528     C                   END
054000200528     C                   END
054100200528      *
054200200528      * VALIDATE ACTION CODE, DEAL NUMBER, VALUE DATE & SEQUENCE NUMBER
054300200528      *
054400200528     C                   EXSR      VAL
054500200528     C/COPY WNCPYSRC,MMDEAMIC01
054600200528      *                                                                                      256795
054700200528     C     CDL052        IFEQ      'Y'                                                       256795
054800200528     C     DDACTN        IFEQ      'I'                                                       256795
054900200528     C     DDACTN        OREQ      'A'                                                       256795
055000200528      *                                                                                      256795
055100200528     C                   Z-ADD     @@DLNO        @DLNO             6 0                       256795
055200200528      *                                                                                      256795
055300200528     C                   CALL      'MM5294'                                                  256795
055400200528     C                   PARM                    @DLNO                                       256795
055500200528     C                   PARM      *Blanks       @ERR              1                         256795
055600200528     C                   PARM      *Blanks       @ERRM            55                         256795
055700200528      *                                                                                      256795
055800200528     C     @ERR          IFEQ      'Y'                                                       256795
055900200528     C                   MOVE      'N'           OKDLNO                                      256795
056000200528     C                   ADD       1             Ix                                          256795
056100200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              256795
056200200528     C                   MOVEL     'MMM5400'     MsgIdArr(Ix)                                256795
056300200528     C                   ENDIF                                                               256795
056400200528     C                   ENDIF                                                               256795
056500200528     C                   ENDIF                                                               256795
056600200528      *
056700200528      **  Carry out no further validation if errors have occurred.
056800200528      *
056900200528     C     OKACTN        IFEQ      'N'
057000200528     C     OKDLNO        OREQ      'N'
057100200528     C     OKVDAT        OREQ      'N'
057200200528     C     OKSEQN        OREQ      'N'
057300200528     C                   RETURN
057400200528     C                   END
057500200528      *
057600200528      *  *--------------------------------*
057700200528      *  * Validation for Action Code 'E' *
057800200528      *  *--------------------------------*
057900200528      *
058000200528     C     DDACTN        IFEQ      'E'
058100200528     C                   EXSR      VALACE
058200200528     C                   END
058300200528      *
058400200528      *  *--------------------------------*
058500200528      *  * Validation for Action Code 'X' *
058600200528      *  *--------------------------------*
058700200528      *
058800200528     C     DDACTN        IFEQ      'X'
058900200528     C                   EXSR      VALACX
059000200528     C                   END
059100200528      *
059200200528      *  *--------------------------------*
059300200528      *  * Validation for Action Code 'I' *
059400200528      *  *--------------------------------*
059500200528      *
059600200528     C     DDACTN        IFEQ      'I'
059700200528     C                   EXSR      VALACI
059800200528     C                   END
059900200528      *
060000200528      *  *--------------------------------*
060100200528      *  * Validation for Action Code 'A' *
060200200528      *  *--------------------------------*
060300200528      *
060400200528     C     DDACTN        IFEQ      'A'
060500200528     C                   EXSR      VALACA
060600200528     C                   END
060700200528      *
060800200528      *  *--------------------------------*
060900200528      *  * Validation for Action Code 'D' *
061000200528      *  *--------------------------------*
061100200528      *
061200200528     C     DDACTN        IFEQ      'D'
061300200528     C                   EXSR      VALACD
061400200528     C                   END
061500200528      *
061600200528      **  Carry out no further validation if errors occurred.
061700200528      *
061800200528     C     OKACTN        IFEQ      'N'
061900200528     C     OKDLNO        OREQ      'N'
062000200528     C                   RETURN
062100200528     C                   END
062200200528      *
062300200528      *  *-----------------------------------------------*
062400200528      *  * Access Security Checking                      *
062500200528      *  *-----------------------------------------------*
062600200528      *
062700200528     C     RespMode      IFEQ      'S'
062800200528     C                   EXSR      ACSSEC
062900200528     C                   END
063000200528                                                                                CAP051
063100200528      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'                     CAP051
063200200528      * DO AUTHORISATION ARE REQUIRED                                           CAP051
063300200528     C     ModeofOp      IFEQ      '      '                                     CAP051
063400200528     C                   MOVE      *BLANKS       HNAUTH                         CAP051
063500200528     C                   ENDIF                                                  CAP051
063600200528      *
063700200528      * Return
063800200528      *
063900200528     C                   RETURN
064000200528      *****************************************************************
064100200528      /EJECT
064200200528      *****************************************************************
064300200528      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
064400200528      *****************************************************************
064500200528     C     VFRNT         BEGSR
064600200528      *
064700200528      * ERROR IF ACTION CODE IS NOT 'I', 'A, 'D' or 'X'
064800200528      *
064900200528     C     DDACTN        IFNE      'I'
065000200528     C     DDACTN        ANDNE     'A'
065100200528     C     DDACTN        ANDNE     'D'
065200200528     C     DDACTN        ANDNE     'X'
065300200528     C                   MOVE      'N'           OKACTN
065400200528     C                   ADD       1             Ix
065500200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
065600200528     C                   MOVEL     'APM0100'     MsgIdArr(Ix)
065700200528     C                   GOTO      EVFRNT
065800200528     C                   END
065900200528      *
066000200528      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
066100200528      *
066200200528     C     FOTRID        IFEQ      *BLANK
066300200528     C                   MOVE      'N'           OKACTN
066400200528     C                   ADD       1             Ix
066500200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
066600200528     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
066700200528     C                   GOTO      EVFRNT
066800200528     C                   END
066900200528      **********                                                                            MD021204
067000200528      **ERROR*IF*FRONT*OFFICE*ASSOCIATED*TRANS*ID*(ORIGINAL*DEAL*NO)*********               MD021204
067100200528      **IS*BLANK*************************************************************               MD021204
067200200528      **********                                                                            MD021204
067300200528     C*****FOASID        IFEQ      *BLANK                                                   MD021204
067400200528     C**********         MOVE      'N'           OKACTN                                     MD021204
067500200528     C**********         ADD       1             Ix                                         MD021204
067600200528     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                             MD021204
067700200528     C**********         MOVEL     'APM0105'     MsgIdArr(Ix)                               MD021204
067800200528     C**********         GOTO      EVFRNT                                                   MD021204
067900200528     C**********         END                                                                MD021204
068000200528      *
068100200528      * ACCESS DEAL AMENDMENT WITH FRONT OFFICE TRANSACTION ID
068200200528      *
068300200528     C                   MOVE      FOASID        OrigDealNo       20
068400200528     C                   MOVE      FOTRID        UniqDeamID       20
068500200528
068600200528     C     FrntOfKey     CHAIN     MMDEAMOI                           99
068700200528      *
068800200528      * IF INSERT
068900200528      *
069000200528     C     DDACTN        IFEQ      'I'
069100200528      *
069200200528      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
069300200528      *
069400200528     C     *IN99         IFEQ      '0'
069500200528     C                   MOVE      'N'           OKACTN
069600200528     C                   ADD       1             Ix
069700200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
069800200528     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
069900200528     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
070000200528     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
070100200528     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
070200200528     C                   GOTO      EVFRNT
070300200528     C                   END
070400200528      *
070500200528     C                   ELSE
070600200528      *
070700200528      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
070800200528      *
070900200528     C     *IN99         IFEQ      '1'
071000200528     C                   MOVE      'N'           OKACTN
071100200528     C                   ADD       1             Ix
071200200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
071300200528     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
071400200528     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
071500200528     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
071600200528     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
071700200528     C                   GOTO      EVFRNT
071800200528     C                   END
071900200528      *
072000200528      * IF NOT INSERT, UPDATE SEQUENCE NUMBER
072100200528      *
072200200528     C                   MOVEL     HNDS38        DDDS38
072300200528     C                   END
072400200528      *
072500200528      * FRONT OFFICE ASSOCIATED TRANSACTION ID
072600200528      * MUST POINT TO A MIDAS DEAL
072700200528      *
072800200528     C     FOASID        IFNE      *BLANKS                                                  MD021204
072900200528      *                                                                                     MD021204
073000200528     C     FOASID        CHAIN     MMDELFOI                           99
073100200528     C     *IN99         IFEQ      '1'                                                        256482
073200200528     C                   MOVEL     FOASID        WDDLNO            6 0                        256482
073300200528     C     WDDLNO        CHAIN     MMDEALLL                           99                      256482
073400200528     C     *IN99         IFEQ      '1'
073500200528     C                   MOVE      'N'           OKACTN
073600200528     C                   ADD       1             Ix
073700200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
073800200528     C                   MOVEL     'APM0104'     MsgIdArr(Ix)
073900200528     C**********         MOVEL     FOASID        MsgDtaArr(Ix)                              MD000091
074000200528     C                   EVAL      BLen = %Len(%Trim(FOASID))                               MD000091
074100200528     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOASID)                    MD000091
074200200528     C                   GOTO      EVFRNT
074300200528     C                   ELSE                                                                 256482
074400200528     C                   MOVEL     H@DN38        DDDLNO                                       256482
074500200528     C                   END
074600200528      *
074700200528     C                   ELSE                                                                 256482
074800200528     C                   MOVEL     HKDN38        DDDLNO
074900200528     C                   ENDIF                                                                256482
075000200528      *                                                                                     MD021204
075100200528     C                   ENDIF                                                              MD021204
075200200528      *
075300200528     C     EVFRNT        ENDSR
075400200528      *****************************************************************
075500200528      /EJECT
075600200528      *****************************************************************
075700200528      * VAL - VALIDATION OF ACTION CODE AND DEAL NUMBER/VALUE DATE/SEQUENCE
075800200528      *****************************************************************
075900200528     C     VAL           BEGSR
076000200528     C*
076100200528     C**  Check that the action code is valid; if authorizations are
076200200528     C**  not in the system, then action code X is not allowed.
076300200528     C*
076400200528     C     BNMMAU        IFEQ      'N'
076500200528     C     BNMMRA        ANDEQ     'N'                                                        176841
076600200528     C     DDACTN        IFNE      *BLANK                                                     176841
076700200528     C     DDACTN        ANDNE     'I'
076800200528     C     DDACTN        ANDNE     'A'
076900200528     C     DDACTN        ANDNE     'D'
077000200528     C     DDACTN        ANDNE     'E'
077100200528     C                   MOVE      'N'           OKACTN
077200200528     C                   ADD       1             Ix
077300200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
077400200528     C                   MOVEL     'MMM0161'     MsgIdArr(Ix)
077500200528     C                   END
077600200528     C                   ELSE                                                             176841
077700200528     C*
077800200528     C*****BNMMAU        IFNE      'N'                                                    176841
077900200528     C     DDACTN        IFNE      *BLANK                                                 176841
078000200528     C     DDACTN        ANDNE     'I'
078100200528     C     DDACTN        ANDNE     'A'
078200200528     C     DDACTN        ANDNE     'D'
078300200528     C     DDACTN        ANDNE     'E'
078400200528     C     DDACTN        ANDNE     'X'
078500200528     C                   MOVE      'N'           OKACTN
078600200528     C                   ADD       1             Ix
078700200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
078800200528     C                   MOVEL     'MMM0160'     MsgIdArr(Ix)
078900200528     C                   END
079000200528     C                   END                                                                  176841
079100200528     C*
079200200528     C**  Validate that key fields are numeric or blank.
079300200528     C*
079400200528     C**  Validate that deal number is numeric & not blank.
079500200528     C*
079600200528     C                   TESTN                   DDDLNO               98
079700200528     C                   MOVE      DDDLNO        @@TEST            1
079800200528     C                   TESTZ                   @@TEST                   99
079900200528     C*
080000200528     C     DDDLNO        IFEQ      *BLANK
080100200528     C     *IN98         OREQ      '0'
080200200528     C     *IN99         OREQ      '0'
080300200528     C                   MOVE      'N'           OKDLNO
080400200528     C                   ADD       1             Ix
080500200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
080600200528     C                   MOVEL     'MMM0145'     MsgIdArr(Ix)
080700200528     C                   GOTO      EVAL
080800200528     C                   END
080900200528     C*
081000200528     C**  Set up the deal number as a numeric field.
081100200528     C*
081200200528     C                   MOVE      DDDLNO        @@DLNO            6 0
081300200528     C*                                                                                      BUG6534
081400200528     C**  Place the rest of the deal number validation here for it to be picked up           BUG6534
081500200528     C**  on the new DEAM first input screen.                                                BUG6534
081600200528     C*                                                                                      BUG6534
081700200528     C     DDACTN        IFEQ      'I'                                                       BUG6534
081800200528     C                   EXSR      VALACF                                                    BUG6534
081900200528     C                   END                                                                 BUG6534
082000200528                                                                                              CER043
082100200528      ** Default value date if CER043 is switched on and value date is blanks                 CER043
082200200528     C                   IF        CER043 = 'Y' AND DDVDAT = *BLANKS                          CER043
082300200528     C                   CALLB     'ZDATE2'                                                   CER043
082400200528     C                   PARM      BJRDNB        ZDAYNO                                       CER043
082500200528     C                   PARM                    BJDFIN                                       CER043
082600200528     C                   PARM      *ZEROS        ZDATE                                        CER043
082700200528     C                   PARM      *BLANK        ZADATE                                       CER043
082800200528     C                   MOVE      ZDATE         DDVDAT                                       CER043
082900200528     C                   ENDIF                                                                CER043
083000200528      *
083100200528      **  Validate that the value date is a valid date.
083200200528      *
083300200528     C                   MOVE      DDVDAT        ValueDate
083400200528     C*
083500200528     C                   TESTN                   DDVDAT               98
083600200528     C                   MOVE      DDVDAT        @@TEST
083700200528     C                   TESTZ                   @@TEST                   99
083800200528     C*
083900200528     C     *IN98         IFEQ      '1'
084000200528     C     *IN99         ANDEQ     '1'
084100200528     C                   MOVEL     DDVDAT        @DAT
084200200528     C                   CALL      'ZA0270'
084300200528     C                   PARM                    @DAT              6 0
084400200528     C                   PARM                    BJDFIN
084500200528     C                   PARM                    @RTCDE            1
084600200528     C                   PARM                    @VDYNO            5 0
084700200528     C                   END
084800200528     C*
084900200528     C**  If the return code is 1 then the input date is invalid or
085000200528     C**  non-numeric.
085100200528     C*
085200200528     C     @RTCDE        IFEQ      '1'
085300200528     C     DDVDAT        OREQ      *BLANKS
085400200528     C     *IN99         OREQ      '0'
085500200528     C     *IN98         OREQ      '0'
085600200528     C*
085700200528     C                   MOVE      'N'           OKVDAT
085800200528     C                   ADD       1             Ix
085900200528     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
086000200528     C                   MOVEL     'MMM0125'     MsgIdArr(Ix)
086100200528     C                   GOTO      EVAL
086200200528     C*
086300200528     C                   ELSE
086400200528     C*
086500200528     C** Load value date to numeric keyfield,in YYYYMMDD format
086600200528     C                   Z-ADD     0             @KVALD
086700200528     C                   MOVE      @DSPY         @VYEAR
086800200528     C     BJDFIN        IFEQ      'D'
086900200528     C                   MOVE      @DSPD         @VDDD
087000200528     C                   ELSE
087100200528     C                   MOVE      @DSPD         @VDMM
087200200528     C                   END
087300200528     C     BJDFIN        IFEQ      'D'
087400200528     C                   MOVE      @DSPM         @VDMM
087500200528     C                   ELSE
087600200528     C                   MOVE      @DSPM         @VDDD
087700200528     C                   END
087800200528     C*
087900200528     C** Century
088000200528     C     @VYEAR        IFGE      72
088100200528     C     @VDYY         ADD       1900          @VDYY
088200200528     C                   ELSE
088300200528     C     @VDYY         ADD       2000          @VDYY
088400200528     C                   END
088500200528     C                   END
088600200528      *
088700200528      ** Sequence no. must be numeric if entered
088800200528      *
088900200528     C     DDDS38        IFNE      *BLANKS
089000200528     C*
089100200528     C                   TESTN                   DDDS38               98
089200200528     C                   MOVE      DDDS38        @@TEST
089300200528     C                   TESTZ                   @@TEST                   99
089400200528     C                   END
089500200528     C*
089600200528     C     DDDS38        IFEQ      *BLANKS
089700200528     C*
089800200528     C     *IN98         OREQ      '1'
089900200528     C     *IN99         ANDEQ     '1'
090000200528     C*
090100200528     C     DDDS38        IFEQ      *BLANKS
090200200528     C                   Z-ADD     *LOVAL        @DEAMS
090300200528     C                   ELSE
090400200528     C                   MOVE      DDDS38        @DEAMS
090500200528     C                   END
090600200528     C*
090700200528     C                   ELSE
090800200528     C*
090900200528     C                   MOVE      'N'           OKSEQN
091000200528     C                   ADD       1             Ix
091100200528     C                   MOVEL     'DDDS38'      FldNameArr(Ix)
091200200528     C                   MOVEL     'MMM0196'     MsgIdArr(Ix)
091300200528     C                   GOTO      EVAL
091400200528     C                   END
091500200528     C*
091600200528     C** If action code is 'I' sequence no. NOT needed otherwise sequence
091700200528     C** number must be entered
091800200528     C     DDACTN        IFNE      'I'
091900200528     C     DDDS38        ANDEQ     *BLANKS
092000200528     C*
092100200528     C     DDACTN        OREQ      'I'
092200200528     C     DDDS38        ANDNE     *BLANKS
092300200528     C     WFRONTID      ANDNE     'TO'                                         CPB002
092400200528                                                                                              CSC024
092500200528      ***Allow*entry*for*Sequence*number*for*Insert*if*CSC024*is                       CSC024 CSC054
092600200528      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
092700200528      ** Allow entry for Sequence number for Insert if CSC054 is                              CSC054
092800200528      ** switched on and running on PEA system.                                               CSC054
092900200528                                                                                              CSC024
093000200528     C     DDACTN        IFNE      'I'                                                        CSC024
093100200528     C     DDACTN        OREQ      'I'                                                        CSC024
093200200528     C*****CSC024        ANDNE     'Y'                                                 CSC024 CSC054
093300200528     C     CSC054        ANDNE     'Y'                                                        CSC054
093400200528     C     DDACTN        OREQ      'I'                                                        CSC024
093500200528     C*****WOMEInd       ANDNE     'Y'                                                 CSC024 CSC054
093600200528     C     WPEAInd       ANDNE     'Y'                                                        CSC054
093700200528                                                                                              CSC024
093800200528     C                   MOVE      'N'           OKSEQN
093900200528     C                   ADD       1             Ix
094000200528     C                   MOVEL     'DDDS38'      FldNameArr(Ix)
094100200528     C                   MOVEL     'MMM0146'     MsgIdArr(Ix)
094200200528     C                   GOTO      EVAL
094300200528     C                   ENDIF                                                                CSC024
094400200528                                                                                              CSC024
094500200528     C                   END
094600200528     C*
094700200528     C     EVAL          ENDSR
094800200528      *****************************************************************
094900200528      /EJECT
095000200528      *****************************************************************
095100200528      * VALACE - VALIDATION OF ACTION CODE 'E'
095200200528      *****************************************************************
095300200528     C     VALACE        BEGSR
095400200528     C*
095500200528     C**  If the deal number is blank, it is an error.
095600200528     C*
095700200528     C     DDDLNO        IFEQ      *BLANKS
095800200528     C                   MOVE      'N'           OKDLNO
095900200528     C                   ADD       1             Ix
096000200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
096100200528     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
096200200528     C                   GOTO      EVALAE
096300200528     C                   END
096400200528     C*
096500200528     C**  If there is no valid record on MMDEAMLL, it is an error.
096600200528     C*
096700200528     C     @DEAMK        CHAIN     MMDEAMLL                           65
096800200528     C*
096900200528     C**  Check for a valid record.
097000200528     C*
097100200528     C     *IN65         IFEQ      '1'
097200200528     C     HNDLTF        ORNE      *BLANKS
097300200528     C                   MOVE      'N'           OKDLNO
097400200528     C                   MOVE      'N'           OKVDAT
097500200528     C                   MOVE      'N'           OKSEQN
097600200528     C                   ADD       1             Ix
097700200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
097800200528     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
097900200528     C                   GOTO      EVALAE
098000200528     C                   ELSE
098100200528     C*
098200200528     C**  If the deal status is not C,A or R, it is an error.
098300200528     C*
098400200528     C     HNDSTS        IFNE      'C'
098500200528     C     HNDSTS        ANDNE     'A'
098600200528     C     HNDSTS        ANDNE     'R'
098700200528     C                   MOVE      'N'           OKDLNO
098800200528     C                   MOVE      'N'           OKVDAT
098900200528     C                   MOVE      'N'           OKSEQN
099000200528     C                   ADD       1             Ix
099100200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
099200200528     C                   MOVEL     'MMM0148'     MsgIdArr(Ix)
099300200528     C                   GOTO      EVALAE
099400200528     C                   ELSE                                                   CSE006
099500200528     C*                                                                         CSE006
099600200528     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.          CSE006
099700200528     C*                                                                         CSE006
099800200528     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks           CSE006
099900200528     C                   MOVE      'N'           OKDLNO                         CSE006
100000200528     C                   MOVE      'N'           OKVDAT                         CSE006
100100200528     C                   MOVE      'N'           OKSEQN                         CSE006
100200200528     C                   ADD       1             Ix                             CSE006
100300200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                 CSE006
100400200528     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                   CSE006
100500200528     C                   GOTO      EVALAE                                       CSE006
100600200528     C                   END                                                    CSE006
100700200528     C                   END
100800200528     C                   END
100900200528     C*
101000200528     C     EVALAE        ENDSR
101100200528      *****************************************************************
101200200528      /EJECT
101300200528      *****************************************************************
101400200528      * VALACX - VALIDATION OF ACTION CODE 'X'
101500200528      *****************************************************************
101600200528     C     VALACX        BEGSR
101700200528     C*
101800200528     C**  If the deal number is blank, it is an error.
101900200528     C*
102000200528     C     DDDLNO        IFEQ      *BLANKS
102100200528     C                   MOVE      'N'           OKDLNO
102200200528     C                   ADD       1             Ix
102300200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
102400200528     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
102500200528     C                   GOTO      EVALAX
102600200528     C                   END
102700200528     C*
102800200528     C* CHECK IF PREVIOUS DEAMS ARE AUTHORISED OR DELETED
102900200528     C*
103000200528     C*****@DEAMK        SETLL     MMDEAMLL                           65                      191881
103100200528     C*****@DEAMK        READPE    MMDEAMLL                               65                  191881
103200200528     C     @@DLNO        SETLL     MMDEAMLL                           65                      191881
103300200528     C     @@DLNO        READPE    MMDEAMLL                               65                  191881
103400200528B2   C     *IN65         DOWEQ     '0'
103500200528B3   C     HNDSTS        IFNE      'A'
103600200528     C     HNDDLT        ANDEQ     ' '
103700200528     C                   MOVE      'N'           OKDLNO
103800200528     C                   MOVE      'N'           OKVDAT
103900200528     C                   MOVE      'N'           OKSEQN
104000200528     C                   ADD       1             Ix
104100200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
104200200528     C                   MOVEL     'MMM015A'     MsgIdArr(Ix)
104300200528     C                   GOTO      EVALAX
104400200528X3   C                   ELSE
104500200528     C*****@DEAMK        READPE    MMDEAMLL                               65                  191881
104600200528     C     @@DLNO        READPE    MMDEAMLL                               65                  191881
104700200528E3   C                   ENDIF
104800200528E2   C                   ENDDO
104900200528     C*
105000200528     C**  If there is no valid, undeleted record on MMDEAMLL, it is an
105100200528     C**  error.
105200200528     C*
105300200528     C     @DEAMK        CHAIN     MMDEAMLL                           65
105400200528     C*
105500200528     C     *IN65         IFEQ      '1'
105600200528     C     HNDLTF        ORNE      *BLANK
105700200528     C     HNDDLT        ORNE      *BLANK
105800200528     C                   MOVE      'N'           OKDLNO
105900200528     C                   MOVE      'N'           OKVDAT
106000200528     C                   MOVE      'N'           OKSEQN
106100200528     C                   ADD       1             Ix
106200200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
106300200528     C                   MOVEL     'MMM0147'     MsgIdArr(Ix)
106400200528     C                   GOTO      EVALAX
106500200528     C                   ELSE
106600200528     C/COPY WNCPYSRC,MMDEAMIC02
106700200528     C*
106800200528     C** Deam status indicator  must be 'C' or 'R'
106900200528     C*
107000200528     C     HNDSTS        IFNE      'C'
107100200528     C     HNDSTS        ANDNE     'R'
107200200528     C                   MOVE      'N'           OKDLNO
107300200528     C                   MOVE      'N'           OKVDAT
107400200528     C                   MOVE      'N'           OKSEQN
107500200528     C                   ADD       1             Ix
107600200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
107700200528     C                   MOVEL     'MMM0290'     MsgIdArr(Ix)
107800200528     C                   GOTO      EVALAX                                                     208100
107900200528     C                   ELSE
108000200528     C*
108100200528     C**  Access Original Deal:
108200200528     C**  If no valid record is found, or the record does not have a
108300200528     C**  status of 'A' or 'R', it is an error.
108400200528     C*
108500200528     C     HNDA38        CHAIN     MMDEALLL                           65
108600200528     C*
108700200528      **  If the deal status is not C, R or A it is an error.                                BUG6534
108800200528     C     *IN65         IFEQ      '1'
108900200528     C     H@DSTS        ORNE      'A'
109000200528     C     H@DSTS        ANDNE     'R'
109100200528     C     H@DSTS        ANDNE     'C'                                                       BUG6534
109200200528     C                   MOVE      'N'           OKDLNO
109300200528     C                   MOVE      'N'           OKVDAT
109400200528     C                   MOVE      'N'           OKSEQN
109500200528     C                   ADD       1             Ix
109600200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
109700200528     C                   MOVEL     'MMM0173'     MsgIdArr(Ix)
109800200528     C                   GOTO      EVALAX
109900200528     C                   ELSE                                                   CSE006
110000200528     C*                                                                         CSE006
110100200528     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.          CSE006
110200200528     C*                                                                         CSE006
110300200528     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks           CSE006
110400200528     C                   MOVE      'N'           OKDLNO                         CSE006
110500200528     C                   MOVE      'N'           OKVDAT                         CSE006
110600200528     C                   MOVE      'N'           OKSEQN                         CSE006
110700200528     C                   ADD       1             Ix                             CSE006
110800200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                 CSE006
110900200528     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                   CSE006
111000200528     C                   GOTO      EVALAX                                       CSE006
111100200528     C                   END                                                    CSE006
111200200528     C                   END
111300200528     C*
111400200528     C                   END
111500200528     C                   END
111600200528     C/COPY WNCPYSRC,MMDEAMIC08
111700200528                                                                                              CSD015
111800200528      ** If Compliance Watch is enabled, check for pending cases.                             CSD015
111900200528                                                                                              CSD015
112000200528     C                   IF        CSD015 = 'Y' AND                                           CSD015
112100200528     C                             W1EWLC = 'Y'                                               CSD015
112200200528                                                                                              CSD015
112300200528     C                   IF        CSC011 <> 'Y' OR                                           CSD015
112400200528     C                             (CSC011 = 'Y' AND                                          CSD015
112500200528     C                             S1MAIN = LIBR)                                             CSD015
112600200528                                                                                              CSD015
112700200528      ** Check if Deal Amendments details are being reviewed                                  CSD015
112800200528                                                                                              CSD015
112900200528     C                   EVAL      KFuncType = *BLANKS                                        CSD015
113000200528     C                   EVAL      KIden = *BLANKS                                            CSD015
113100200528     C                   EVAL      KBranch = *BLANKS                                          CSD015
113200200528                                                                                              CSD015
113300200528     C                   MOVEL     'MMDEAMPP'    KFuncType                                    CSD015
113400200528     C                   MOVE      HNDA38        WHNDA3                                       CSD015
113500200528     C                   MOVE      HNVDYY        WHNVDY                                       CSD015
113600200528     C                   MOVE      HNVDMM        WHNVDM                                       CSD015
113700200528     C                   MOVE      HNVDDD        WHNVDD                                       CSD015
113800200528     C                   MOVE      HNDS38        WHNDS3                                       CSD015
113900200528     C                   EVAL      KIden = WHNDA3 + WHNVDY + WHNVDM +                         CSD015
114000200528     C                             WHNVDD + WHNDS3                                            CSD015
114100200528     C                   MOVEL     HNBRCA        KBranch                                      CSD015
114200200528                                                                                              CSD015
114300200528     C     KCWHT         CHAIN     SDCWHTL1                                                   CSD015
114400200528                                                                                              CSD015
114500200528     C                   IF        %FOUND(SDCWHTL1) AND                                       CSD015
114600200528     C                             W3TREL <> 'Y'                                              CSD015
114700200528     C                   EVAL      OKACTN = 'N'                                               CSD015
114800200528     C                   EVAL      OKDLNO = 'N'                                               CSD015
114900200528     C                   EVAL      Ix = Ix + 1                                                CSD015
115000200528     C                   EVAL      FldNameArr(Ix) = 'DDDLNO'                                  CSD015
115100200528     C                   EVAL      MsgIdArr(Ix) = 'MMM0797'                                   CSD015
115200200528     C                   ENDIF                                                                CSD015
115300200528                                                                                              CSD015
115400200528     C                   ENDIF                                                                CSD015
115500200528                                                                                              CSD015
115600200528     C                   ENDIF                                                                CSD015
115700200528                                                                                              CSD015
115800200528      ** Retrieve latest content of DTAARA/ZMUSER                                            BUG4422
115900200528      *                                                                                      BUG4422
116000200528     C                   IN        ZMUSER                                                    BUG4422
116100200528     C                   UNLOCK    ZMUSER                                                    BUG4422
116200200528                                                                                             BUG4422
116300200528      ** Determine whether program is running interactively or in batch                       CAP185
116400200528      **  ( 0 = batch 1 = interactive)                                                        CAP185
116500200528      *                                                                                       CAP185
116600200528     C                   CALLB     'ZARTVJOBA'                                                CAP185
116700200528     C                   PARM                    @Return           6                          CAP185
116800200528     C                   PARM                    @Type             1                          CAP185
116900200528      *                                                                                       CAP185
117000200528     C                   IF        CAP185 = 'N' OR                                            CAP185
117100200528     C                             CAP185 = 'Y' AND                                           CAP185
117200200528     C                             @AUTHO = 'N' OR                                            CAP185
117300200528     C                             CAP185 = 'Y' AND                                           CAP185
117400200528     C                             @AUTHO = 'Y' AND                                           CAP185
117500200528     C                             @TYPE = '1'                                                CAP185
117600200528      *                                                                                       CDL010
117700200528      ** User cannot authorise an authorised deal or deal requires                            CDL010
117800200528      ** double authorisation.                                                                CDL010
117900200528      *                                                                                       CDL010
118000200528     C     CDL010        IFEQ      'Y'                                                        CDL010
118100200528     C     HNUSER        ANDEQ     ZUSER                                                      CDL010
118200200528     C                   MOVE      'N'           OKDLNO                                       CDL010
118300200528     C                   ADD       1             Ix                                           CDL010
118400200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL010
118500200528     C                   MOVEL     'MMM0702'     MsgIdArr(Ix)                                 CDL010
118600200528     C                   END                                                                  CDL010
118700200528     C                   ENDIF                                                                CAP185
118800200528     C*
118900200528     C     EVALAX        ENDSR
119000200528      *****************************************************************
119100200528      /EJECT
119200200528      *****************************************************************
119300200528      * VALACI - VALIDATION OF ACTION CODE 'I'
119400200528      *****************************************************************
119500200528     C     VALACI        BEGSR
119600200528     C*
119700200528     C**  Check that the deal does not exist on the
119800200528     C**  MMDEAMLL file; if it does it is an error.
119900200528     C     @DEAMK        CHAIN     MMDEAMLL                           65
120000200528     C     *IN65         IFEQ      '0'
120100200528     C*
120200200528     C** Record already exists
120300200528     C*****HNDLTF        IFEQ      *BLANKS                                                   BUG7537
120400200528     C     HNDDLT        IFEQ      *BLANKS                                                   BUG7537
120500200528     C                   MOVE      'N'           OKDLNO
120600200528     C                   ADD       1             Ix
120700200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
120800200528     C                   MOVEL     'MMM0149'     MsgIdArr(Ix)
120900200528     C                   GOTO      EVALAI
121000200528     C                   END
121100200528     C                   END
121200200528     C*                                                                                       CDL017
121300200528     C**  More that one EM amendment per Deal is not allowed                                  CDL017
121400200528     C     DDMTYP        IFEQ      'EM'                                                       CDL017
121500200528     C                   MOVE      DDDLNO        KeyDealNo                                    CDL017
121600200528     C                   MOVE      'EM'          KeyAmdTyp         2                          CDL017
121700200528     C     @DMKY3        CHAIN     MMDEAML3                           65                      CDL017
121800200528     C     *IN65         IFEQ      '0'                                                        CDL017
121900200528     C                   MOVE      'N'           OKDLNO                                       CDL017
122000200528     C                   ADD       1             Ix                                           CDL017
122100200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL017
122200200528     C                   MOVEL     'MMM0353'     MsgIdArr(Ix)                                 CDL017
122300200528     C                   GOTO      EVALAI                                                     CDL017
122400200528     C                   ENDIF                                                                CDL017
122500200528     C                   ENDIF                                                                CDL017
122600200528     C*
122700200528     C** check that the Original Deal record exists
122800200528     C     @@DLNO        CHAIN     MMDEALLL                           65
122900200528     C*
123000200528     C** Check deal type is valid
123100200528     C*
123200200528     C** INITIALISE INDICATORS
123300200528     C                   Z-ADD     1             @N                2 0
123400200528     C                   MOVE      '0'           *IN75
123500200528     C*
123600200528     C     H@MTYP        LOOKUP    @DT2(@N)                               75
123700200528                                                                                CDL006
123800200528      ** If Dealing Fiduciary is installed and the deal type not found          CDL006
123900200528      ** in the first deal type array(@DT2), lookup from the newly crea         CDL006
124000200528      ** ted fiduciary deal type array.                                         CDL006
124100200528                                                                                CDL006
124200200528     C                   If        CDL006 = 'Y' and *IN75 = *Off                CDL006
124300200528     C     H@MTYP        LookUp    FIDTYP(@N)                             75    CDL006
124400200528     C                   EndIf                                                  CDL006
124500200528     C*
124600200528     C     *IN65         IFEQ      '1'
124700200528     C     *IN75         OREQ      '0'
124800200528     C     H@DLTF        ORNE      ' '
124900200528     C     H@DDLT        ORNE      ' '
125000200528     C                   MOVE      'N'           OKDLNO
125100200528     C                   MOVE      'N'           OKVDAT
125200200528     C                   MOVE      'N'           OKSEQN
125300200528     C                   ADD       1             Ix
125400200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
125500200528     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)
125600200528     C                   GOTO      EVALAI
125700200528     C                   END
125800200528      *                                                                                      BUG5092
125900200528      ** Amendment type 'EM' not allowed for Blocked Deals                                   BUG5092
126000200528      *                                                                                      BUG5092
126100200528     C     DDMTYP        IFEQ      'EM'                                                      BUG5092
126200200528     C     HKBLKA        ANDEQ     'Y'                                                       BUG5092
126300200528     C                   MOVE      'N'           OKDLNO                                      BUG5092
126400200528     C                   ADD       1             Ix                                          BUG5092
126500200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG5092
126600200528     C                   MOVEL     'MMM0337'     MsgIdArr(Ix)                                BUG5092
126700200528     C                   GOTO      EVALAI                                                    BUG5092
126800200528     C                   ENDIF                                                               BUG5092
126900200528      *                                                                                      BUG8360
127000200528      ** 'EM' should not be allowed if rollover indicator is automatic.                      BUG8360
127100200528      *                                                                                      BUG8360
127200200528     C     DDMTYP        IFEQ      'EM'                                                      BUG8360
127300200528     C     HKAURO        ANDEQ     'A'                                                       BUG8360
127400200528     C                   MOVE      'N'           OKDLNO                                      BUG8360
127500200528     C                   ADD       1             Ix                                          BUG8360
127600200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG8360
127700200528     C                   MOVEL     'MMM0360'     MsgIdArr(Ix)                                BUG8360
127800200528     C                   GOTO      EVALAI                                                    BUG8360
127900200528     C                   ENDIF                                                               BUG8360
128000200528      *                                                                                      BUG8360
128100200528      ** 'EM' should not be allowed if Rollover indicator is 'Y' and deal is                 BUG8360
128200200528      ** collateral and CGL014 is installed.                                                 BUG8360
128300200528      *                                                                                      BUG8360
128400200528     C     DDMTYP        IFEQ      'EM'                                                      BUG8360
128500200528     C     HKAURO        ANDEQ     'Y'                                                       BUG8360
128600200528     C     HKCOLF        ANDEQ     'Y'                                                       BUG8360
128700200528     C     CGL014        ANDEQ     'Y'                                                       BUG8360
128800200528     C                   MOVE      'N'           OKDLNO                                      BUG8360
128900200528     C                   ADD       1             Ix                                          BUG8360
129000200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG8360
129100200528     C                   MOVEL     'MMM0361'     MsgIdArr(Ix)                                BUG8360
129200200528     C                   GOTO      EVALAI                                                    BUG8360
129300200528     C                   ENDIF                                                               BUG8360
129400200528      *                                                                                      BUG8360
129500200528      ** 'EM' is not allowed for rolled over deal.                                           BUG8360
129600200528      *                                                                                      BUG8360
129700200528     C     DDMTYP        IFEQ      'EM'                                                      BUG8360
129800200528     C     HKROBY        ANDNE     *BLANKS                                                   BUG8360
129900200528     C                   MOVE      'N'           OKDLNO                                      BUG8360
130000200528     C                   ADD       1             Ix                                          BUG8360
130100200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG8360
130200200528     C                   MOVEL     'MMM0362'     MsgIdArr(Ix)                                BUG8360
130300200528     C                   GOTO      EVALAI                                                    BUG8360
130400200528     C                   ENDIF                                                               BUG8360
130500200528     C*
130600200528     C** Output Midas deal type
130700200528     C*
130800200528     C                   MOVEL     H@MTYP        HNOMDT
130900200528     C*
131000200528     C** Check that the deal does not exist on
131100200528     C** DEALSH file else, it is an error
131200200528     C*
131300200528     C     @@DLNO        CHAIN     DEALSH                             65
131400200528     C*
131500200528     C** Record already exists in DEALSH file
131600200528     C     *IN65         IFEQ      '0'
131700200528     C                   MOVE      'N'           OKDLNO
131800200528     C                   MOVE      'N'           OKVDAT
131900200528     C                   MOVE      'N'           OKSEQN
132000200528     C                   ADD       1             Ix
132100200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
132200200528     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)
132300200528     C                   GOTO      EVALAI
132400200528     C                   ELSE                                                    CSE006
132500200528     C*                                                                          CSE006
132600200528     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.           CSE006
132700200528     C*                                                                          CSE006
132800200528     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks            CSE006
132900200528     C                   MOVE      'N'           OKDLNO                          CSE006
133000200528     C                   MOVE      'N'           OKVDAT                          CSE006
133100200528     C                   MOVE      'N'           OKSEQN                          CSE006
133200200528     C                   ADD       1             Ix                              CSE006
133300200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                  CSE006
133400200528     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                    CSE006
133500200528     C                   GOTO      EVALAI                                        CSE006
133600200528     C                   END                                                     CSE006
133700200528     C                   END
133800200528     C*
133900200528     C** Check valid deal for key fields
134000200528     C                   EXSR      CHKKEYFLDS
134100200528     C*
134200200528     C     EVALAI        ENDSR
134300200528      *****************************************************************
134400200528      /EJECT
134500200528      *****************************************************************                      BUG6534
134600200528      * VALACF - VALIDATION OF ACTION CODE 'I' FOR FIRST SCREEN                              BUG6534
134700200528      *****************************************************************                      BUG6534
134800200528     C     VALACF        BEGSR                                                               BUG6534
134900200528      *                                                                                      BUG7537
135000200528     C** Check that the deal exists on DEALS, otherwise                                      BUG7537
135100200528     C** issue an appropirate error message.                                                 BUG7537
135200200528     C*                                                                                      BUG7537
135300200528     C     @@DLNO        CHAIN     MMDEALLL                           65                     BUG7537
135400200528     C*                                                                                      BUG7537
135500200528     C** Record does not exist.                                                              BUG7537
135600200528     C     *IN65         IFEQ      '1'                                                       BUG7537
135700200528     C     H@DDLT        ORNE      ' '                                                       BUG7537
135800200528     C                   MOVE      'N'           OKDLNO                                      BUG7537
135900200528     C                   ADD       1             Ix                                          BUG7537
136000200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                              BUG7537
136100200528     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)                                BUG7537
136200200528     C                   GOTO      EVALAF                                                    BUG7537
136300200528     C                   END                                                                 BUG7537
136400200528      *                                                                                     BUG16961
136500200528      ** Check deal type is valid                                                           BUG16961
136600200528      ** Initialise indicators                                                              BUG16961
136700200528      *                                                                                     BUG16961
136800200528     C                   Z-ADD     1             @N                2 0                      BUG16961
136900200528     C                   MOVE      '0'           *IN75                                      BUG16961
137000200528      *                                                                                     BUG16961
137100200528     C     H@MTYP        LOOKUP    @DT2(@N)                               75                BUG16961
137200200528                                                                                            BUG16961
137300200528      *                                                                                     BUG16961
137400200528      ** If Dealing Fiduciary is installed and the deal type not found                      BUG16961
137500200528      ** in the first deal type array(@DT2), lookup from the newly created                  BUG16961
137600200528      ** fiduciary deal type array                                                          BUG16961
137700200528      *                                                                                     BUG16961
137800200528                                                                                            BUG16961
137900200528     C                   If        CDL006 = 'Y' and *IN75 = *Off                            BUG16961
138000200528     C     H@MTYP        LookUp    FIDTYP(@N)                             75                BUG16961
138100200528     C                   EndIf                                                              BUG16961
138200200528      *                                                                                     BUG16961
138300200528     C     *IN65         IFEQ      '1'                                                      BUG16961
138400200528     C     *IN75         OREQ      '0'                                                      BUG16961
138500200528     C     H@DLTF        ORNE      ' '                                                      BUG16961
138600200528     C     H@DDLT        ORNE      ' '                                                      BUG16961
138700200528     C                   MOVE      'N'           OKDLNO                                     BUG16961
138800200528     C                   MOVE      'N'           OKVDAT                                     BUG16961
138900200528     C                   MOVE      'N'           OKSEQN                                     BUG16961
139000200528     C                   ADD       1             Ix                                         BUG16961
139100200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                             BUG16961
139200200528     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)                               BUG16961
139300200528     C                   GOTO      EVALAF                                                   BUG16961
139400200528     C                   ENDIF                                                              BUG16961
139500200528      *                                                                                     BUG16961
139600200528      ** Check that the deal does not exist on                                              BUG16961
139700200528      ** DEALSH file else, it is an error                                                   BUG16961
139800200528      *                                                                                     BUG16961
139900200528     C     @@DLNO        CHAIN     DEALSH                             65                    BUG16961
140000200528      *                                                                                     BUG16961
140100200528      ** Record already exists in DEALSH file                                               BUG16961
140200200528      *                                                                                     BUG16961
140300200528     C     *IN65         IFEQ      '0'                                                      BUG16961
140400200528     C                   MOVE      'N'           OKDLNO                                     BUG16961
140500200528     C                   MOVE      'N'           OKVDAT                                     BUG16961
140600200528     C                   MOVE      'N'           OKSEQN                                     BUG16961
140700200528     C                   ADD       1             Ix                                         BUG16961
140800200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                             BUG16961
140900200528     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)                               BUG16961
141000200528     C                   GOTO      EVALAF                                                   BUG16961
141100200528     C                   ENDIF                                                              BUG16961
141200200528      *                                                                                      BUG7537
141300200528      ** Remove the rest of processing below as this will be                                 BUG7537
141400200528      ** handled in main screen validation subr/VALACI.                                      BUG7537
141500200528     C***********                                                                    BUG6534 BUG7537
141600200528     C****Check that the deal does not exist on the                                  BUG6534 BUG7537
141700200528     C****MMDEAMLL file; if it does it is an error.                                  BUG6534 BUG7537
141800200528     C*****@DEAMK        CHAIN     MMDEAMLL                           65             BUG6534 BUG7537
141900200528     C******IN65         IFEQ      '0'                                               BUG6534 BUG7537
142000200528     C***********                                                                    BUG6534 BUG7537
142100200528     C** Record already exists                                                       BUG6534 BUG7537
142200200528     C*****HNDLTF        IFEQ      *BLANKS                                           BUG6534 BUG7537
142300200528     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
142400200528     C***********        ADD       1             Ix                                  BUG6534 BUG7537
142500200528     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
142600200528     C***********        MOVEL     'MMM0149'     MsgIdArr(Ix)                        BUG6534 BUG7537
142700200528     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
142800200528     C***********        END                                                         BUG6534 BUG7537
142900200528     C***********        END                                                         BUG6534 BUG7537
143000200528     C***********                                                                    BUG6534 BUG7537
143100200528     C****More that one EM amendment per Deal is not allowed                         BUG6534 BUG7537
143200200528     C*****DDMTYP        IFEQ      'EM'                                              BUG6534 BUG7537
143300200528     C***********        MOVE      DDDLNO        KeyDealNo                           BUG6534 BUG7537
143400200528     C***********        MOVE      'EM'          KeyAmdTyp         2                 BUG6534 BUG7537
143500200528     C*****@DMKY3        CHAIN     MMDEAML3                           65             BUG6534 BUG7537
143600200528     C******IN65         IFEQ      '0'                                               BUG6534 BUG7537
143700200528     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
143800200528     C***********        ADD       1             Ix                                  BUG6534 BUG7537
143900200528     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
144000200528     C***********        MOVEL     'MMM0353'     MsgIdArr(Ix)                        BUG6534 BUG7537
144100200528     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
144200200528     C***********        ENDIF                                                       BUG6534 BUG7537
144300200528     C***********        ENDIF                                                       BUG6534 BUG7537
144400200528     C***********                                                                    BUG6534 BUG7537
144500200528     C***check that the Original Deal record exists                                  BUG6534 BUG7537
144600200528     C*****@@DLNO        CHAIN     MMDEALLL                           65             BUG6534 BUG7537
144700200528     C***********                                                                    BUG6534 BUG7537
144800200528     C***Check deal type is valid                                                    BUG6534 BUG7537
144900200528     C***********                                                                    BUG6534 BUG7537
145000200528     C***INITIALISE INDICATORS                                                       BUG6534 BUG7537
145100200528     C***********        Z-ADD     1             @N                2 0               BUG6534 BUG7537
145200200528     C***********        MOVE      '0'           *IN75                               BUG6534 BUG7537
145300200528     C***********                                                                    BUG6534 BUG7537
145400200528     C*****H@MTYP        LOOKUP    @DT2(@N)                               75         BUG6534 BUG7537
145500200528      ***********                                                                    BUG6534 BUG7537
145600200528      ***If Dealing Fiduciary is installed and the deal type not found               BUG6534 BUG7537
145700200528      ***in the first deal type array(@DT2), lookup from the newly crea              BUG6534 BUG7537
145800200528      ***ted fiduciary deal type array.                                              BUG6534 BUG7537
145900200528      ***********                                                                    BUG6534 BUG7537
146000200528     C***********        If        CDL006 = 'Y' and *IN75 = *Off                     BUG6534 BUG7537
146100200528     C*****H@MTYP        LookUp    FIDTYP(@N)                             75         BUG6534 BUG7537
146200200528     C***********        EndIf                                                       BUG6534 BUG7537
146300200528     C***********                                                                    BUG6534 BUG7537
146400200528     C******IN65         IFEQ      '1'                                               BUG6534 BUG7537
146500200528     C******IN75         OREQ      '0'                                               BUG6534 BUG7537
146600200528     C*****H@DLTF        ORNE      ' '                                               BUG6534 BUG7537
146700200528     C*****H@DDLT        ORNE      ' '                                               BUG6534 BUG7537
146800200528     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
146900200528     C***********        MOVE      'N'           OKVDAT                              BUG6534 BUG7537
147000200528     C***********        MOVE      'N'           OKSEQN                              BUG6534 BUG7537
147100200528     C***********        ADD       1             Ix                                  BUG6534 BUG7537
147200200528     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
147300200528     C***********        MOVEL     'MMM0150'     MsgIdArr(Ix)                        BUG6534 BUG7537
147400200528     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
147500200528     C***********        END                                                         BUG6534 BUG7537
147600200528      ***********                                                                    BUG6534 BUG7537
147700200528      ** Amendment type 'EM' not allowed for Blocked Deals                           BUG6534 BUG7537
147800200528      ************                                                                   BUG6534 BUG7537
147900200528     C*****DDMTYP        IFEQ      'EM'                                              BUG6534 BUG7537
148000200528     C*****HKBLKA        ANDEQ     'Y'                                               BUG6534 BUG7537
148100200528     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
148200200528     C***********        ADD       1             Ix                                  BUG6534 BUG7537
148300200528     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
148400200528     C***********        MOVEL     'MMM0337'     MsgIdArr(Ix)                        BUG6534 BUG7537
148500200528     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
148600200528     C***********        ENDIF                                                       BUG6534 BUG7537
148700200528     C***********                                                                    BUG6534 BUG7537
148800200528     C***Output Midas deal type                                                      BUG6534 BUG7537
148900200528     C***********                                                                    BUG6534 BUG7537
149000200528     C***********        MOVEL     H@MTYP        HNOMDT                              BUG6534 BUG7537
149100200528     C***********                                                                    BUG6534 BUG7537
149200200528     C***Check that the deal does not exist on                                       BUG6534 BUG7537
149300200528     C***DEALSH file else, it is an error                                            BUG6534 BUG7537
149400200528     C***********                                                                    BUG6534 BUG7537
149500200528     C*****@@DLNO        CHAIN     DEALSH                             65             BUG6534 BUG7537
149600200528     C***********                                                                    BUG6534 BUG7537
149700200528     C***Record already exists in DEALSH file                                        BUG6534 BUG7537
149800200528     C******IN65         IFEQ      '0'                                               BUG6534 BUG7537
149900200528     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
150000200528     C***********        MOVE      'N'           OKVDAT                              BUG6534 BUG7537
150100200528     C***********        MOVE      'N'           OKSEQN                              BUG6534 BUG7537
150200200528     C***********        ADD       1             Ix                                  BUG6534 BUG7537
150300200528     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
150400200528     C***********        MOVEL     'MMM0150'     MsgIdArr(Ix)                        BUG6534 BUG7537
150500200528     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
150600200528     C***********        ELSE                                                        BUG6534 BUG7537
150700200528     C***********                                                                    BUG6534 BUG7537
150800200528     C****If*CSE006*is*'Y'*and*deal*is*not*a*Repo*deal*it*is*an*error.               BUG6534 BUG7537
150900200528     C***********                                                                    BUG6534 BUG7537
151000200528     C***********        IF        CSE006 = 'Y' and HKDRID <> *Blanks                BUG6534 BUG7537
151100200528     C***********        MOVE      'N'           OKDLNO                              BUG6534 BUG7537
151200200528     C***********        MOVE      'N'           OKVDAT                              BUG6534 BUG7537
151300200528     C***********        MOVE      'N'           OKSEQN                              BUG6534 BUG7537
151400200528     C***********        ADD       1             Ix                                  BUG6534 BUG7537
151500200528     C***********        MOVEL     'DDDLNO'      FldNameArr(Ix)                      BUG6534 BUG7537
151600200528     C***********        MOVEL     'MMA0793'     MsgIdArr(Ix)                        BUG6534 BUG7537
151700200528     C***********        GOTO      EVALAF                                            BUG6534 BUG7537
151800200528     C***********        END                                                         BUG6534 BUG7537
151900200528     C***********        END                                                         BUG6534 BUG7537
152000200528     C*                                                                                      BUG6534
152100200528     C     EVALAF        ENDSR                                                               BUG6534
152200200528      *****************************************************************                      BUG6534
152300200528      /EJECT                                                                                 BUG6534
152400200528      *****************************************************************
152500200528      * VALACA - VALIDATION OF ACTION CODE 'A'
152600200528      *****************************************************************
152700200528     C     VALACA        BEGSR
152800200528     C*
152900200528     C**  If the deal number is blank, it is an error.
153000200528     C*
153100200528     C     DDDLNO        IFEQ      *BLANKS
153200200528     C                   MOVE      'N'           OKDLNO
153300200528     C                   ADD       1             Ix
153400200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
153500200528     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
153600200528     C                   GOTO      EVALAA
153700200528     C                   END
153800200528     C*
153900200528     C**  If there is no valid, undeleted record on MMDEAMLL, it is an
154000200528     C**  error.
154100200528     C*
154200200528     C     @DEAMK        CHAIN     MMDEAMLL                           65
154300200528     C*
154400200528     C     *IN65         IFEQ      '1'
154500200528     C     HNDLTF        ORNE      *BLANK
154600200528     C                   MOVE      'N'           OKDLNO
154700200528     C                   MOVE      'N'           OKVDAT
154800200528     C                   MOVE      'N'           OKSEQN
154900200528     C                   ADD       1             Ix
155000200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
155100200528     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
155200200528     C                   GOTO      EVALAA
155300200528     C                   END
155400200528     C*
155500200528     C**  If the deam has been deleted, then it may not be amended.
155600200528     C*
155700200528     C     HNDDLT        IFNE      *BLANK
155800200528     C                   MOVE      'N'           OKDLNO
155900200528     C                   MOVE      'N'           OKVDAT
156000200528     C                   MOVE      'N'           OKSEQN
156100200528     C                   ADD       1             Ix
156200200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
156300200528     C                   MOVEL     'MMM0151'     MsgIdArr(Ix)
156400200528     C                   GOTO      EVALAA
156500200528     C                   END
156600200528     C*
156700200528     C**  If the record exists, its status must be C,A or R.
156800200528     C*
156900200528     C     HNDSTS        IFNE      'C'
157000200528     C     HNDSTS        ANDNE     'A'
157100200528     C     HNDSTS        ANDNE     'R'
157200200528     C                   MOVE      'N'           OKDLNO
157300200528     C                   MOVE      'N'           OKVDAT
157400200528     C                   MOVE      'N'           OKSEQN
157500200528     C                   ADD       1             Ix
157600200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
157700200528     C                   MOVEL     'MMM0152'     MsgIdArr(Ix)
157800200528     C                   GOTO      EVALAA
157900200528     C                   ELSE                                                    CSE006
158000200528     C*                                                                          CSE006
158100200528     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.           CSE006
158200200528     C*                                                                          CSE006
158300200528     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks            CSE006
158400200528     C                   MOVE      'N'           OKDLNO                          CSE006
158500200528     C                   MOVE      'N'           OKVDAT                          CSE006
158600200528     C                   MOVE      'N'           OKSEQN                          CSE006
158700200528     C                   ADD       1             Ix                              CSE006
158800200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                  CSE006
158900200528     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                    CSE006
159000200528     C                   GOTO      EVALAA                                        CSE006
159100200528     C                   END                                                     CSE006
159200200528     C                   END
159300200528     C*
159400200528     C** Check valid deal for key fields
159500200528     C                   EXSR      CHKKEYFLDS
159600200528     C*
159700200528     C     EVALAA        ENDSR
159800200528      *****************************************************************
159900200528      /EJECT
160000200528      *****************************************************************
160100200528      * VALACD - VALIDATION OF ACTION CODE 'D'
160200200528      *****************************************************************
160300200528     C     VALACD        BEGSR
160400200528     C*
160500200528     C**  If the deal number is blank, it is an error.
160600200528     C*
160700200528     C     DDDLNO        IFEQ      *BLANKS
160800200528     C                   MOVE      'N'           OKDLNO
160900200528     C                   ADD       1             Ix
161000200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
161100200528     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
161200200528     C                   GOTO      EVALAD
161300200528     C                   END
161400200528     C*
161500200528     C**  If there is no valid, undeleted record on MMDEAMLL, it is an
161600200528     C**  error.
161700200528     C*
161800200528     C     @DEAMK        CHAIN     MMDEAMLL                           65
161900200528     C*
162000200528     C     *IN65         IFEQ      '1'
162100200528     C     HNDLTF        ORNE      *BLANK
162200200528     C                   MOVE      'N'           OKDLNO
162300200528     C                   MOVE      'N'           OKVDAT
162400200528     C                   MOVE      'N'           OKSEQN
162500200528     C                   ADD       1             Ix
162600200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
162700200528     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
162800200528     C                   GOTO      EVALAD
162900200528     C                   END
163000200528     C*
163100200528     C**  If a valid record exists and the deal deleted indicator is
163200200528     C**  not blank, it is an error.
163300200528     C*
163400200528     C     HNDDLT        IFNE      *BLANK
163500200528     C                   MOVE      'N'           OKDLNO
163600200528     C                   MOVE      'N'           OKVDAT
163700200528     C                   MOVE      'N'           OKSEQN
163800200528     C                   ADD       1             Ix
163900200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
164000200528     C                   MOVEL     'MMM0151'     MsgIdArr(Ix)
164100200528     C                   GOTO      EVALAD
164200200528     C                   END
164300200528     C*
164400200528     C** if the record exists the status must be C A or R
164500200528     C*
164600200528     C     HNDSTS        IFNE      'C'
164700200528     C     HNDSTS        ANDNE     'A'
164800200528     C     HNDSTS        ANDNE     'R'
164900200528     C                   MOVE      'N'           OKDLNO
165000200528     C                   MOVE      'N'           OKVDAT
165100200528     C                   MOVE      'N'           OKSEQN
165200200528     C                   ADD       1             Ix
165300200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
165400200528     C                   MOVEL     'MMM0156'     MsgIdArr(Ix)
165500200528     C                   GOTO      EVALAD
165600200528     C                   END
165700200528     C*
165800200528     C**If amendment type is 'PI' execute process 'Check deal amendment
165900200528     C** principle'   : MMP0082.
166000200528     C*
166100200528     C     DDMTYP        IFEQ      'PI'
166200200528     C     DDAMNP        IFNE      *BLANKS
166300200528     C*
166400200528     C                   EXSR      CHKDEAMPPL
166500200528     C*
166600200528     C** If invalid exit routine
166700200528     C     OKACTN        IFEQ      'N'
166800200528     C     OKDLNO        OREQ      'N'
166900200528     C                   GOTO      EVALAD
167000200528     C                   END
167100200528     C*
167200200528     C**  Reset deams file if amount passed principle validation check
167300200528     C**  Access only if current deam is not deam last accessed.
167400200528     C     @@DLNO        IFNE      HNDA38
167500200528     C     @VDYY         ORNE      HNVDYY
167600200528     C     @VDMM         ORNE      HNVDMM
167700200528     C     @VDDD         ORNE      HNVDDD
167800200528     C     @DEAMS        ORNE      HNDS38
167900200528     C*
168000200528     C** deam must exist
168100200528     C     @DEAMK        CHAIN     MMDEAMLL                           65
168200200528     C     *IN65         IFEQ      '1'
168300200528     C     HNDLTF        ORNE      *BLANK
168400200528     C                   MOVE      'N'           OKDLNO
168500200528     C                   MOVE      'N'           OKVDAT
168600200528     C                   MOVE      'N'           OKSEQN
168700200528     C                   ADD       1             Ix
168800200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
168900200528     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
169000200528     C                   GOTO      EVALAD
169100200528     C                   END
169200200528     C                   END
169300200528     C                   END
169400200528     C                   END
169500200528     C*                                                                         CSE006
169600200528     C     HNDA38        CHAIN     MMDEALLL                           65        CSE006
169700200528     C*                                                                         CSE006
169800200528     C**  If CSE006 is 'Y' and deal is not a Repo deal it is an error.          CSE006
169900200528     C*                                                                         CSE006
170000200528     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks           CSE006
170100200528     C                   MOVE      'N'           OKDLNO                         CSE006
170200200528     C                   MOVE      'N'           OKVDAT                         CSE006
170300200528     C                   MOVE      'N'           OKSEQN                         CSE006
170400200528     C                   ADD       1             Ix                             CSE006
170500200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                 CSE006
170600200528     C                   MOVEL     'MMA0793'     MsgIdArr(Ix)                   CSE006
170700200528     C                   GOTO      EVALAD                                       CSE006
170800200528     C                   END                                                    CSE006
170900200528     C*
171000200528     C     EVALAD        ENDSR
171100200528      *****************************************************************
171200200528      /EJECT
171300200528     C*****************************************************************
171400200528     C*      CHKKEYFLDS - Check valid deal for key fields
171500200528     C*****************************************************************
171600200528     C     CHKKEYFLDS    BEGSR
171700200528     C*
171800200528     C** Access MMDEALLL if this has not been done for this deal number
171900200528     C     @@DLNO        IFNE      H@DN38
172000200528     C     @@DLNO        CHAIN     MMDEALLL                           65
172100200528     C     *IN65         IFEQ      '1'
172200200528     C                   MOVE      'N'           OKDLNO
172300200528     C                   MOVE      'N'           OKVDAT
172400200528     C                   MOVE      'N'           OKSEQN
172500200528     C                   ADD       1             Ix
172600200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
172700200528     C                   MOVEL     'MMM0184'     MsgIdArr(Ix)
172800200528     C                   GOTO      CHKKEYEND
172900200528     C                   END
173000200528     C                   END
173100200528     C*
173200200528     C** Convert dates used in compares to midas day numbers
173300200528     C*
173400200528     C                   Z-ADD     H@SLDT        DateIn
173500200528     C                   CALLB     'ZDATE10'
173600200528     C                   PARM                    DateIn
173700200528     C                   PARM                    DateOut
173800200528     C                   Z-ADD     DateOut       @SLDYN            5 0
173900200528     C*
174000200528     C                   Z-ADD     H@IADT        DateIn
174100200528     C                   CALLB     'ZDATE10'
174200200528     C                   PARM                    DateIn
174300200528     C                   PARM                    DateOut
174400200528     C                   Z-ADD     DateOut       @IADYN            5 0
174500200528     C*
174600200528     C     H@RCID        IFEQ      'HK'
174700200528     C                   Z-ADD     H@MATD        DateIn
174800200528     C                   CALLB     'ZDATE10'
174900200528     C                   PARM                    DateIn
175000200528     C                   PARM                    DateOut
175100200528     C                   Z-ADD     DateOut       @MDAYN            5 0
175200200528     C                   ELSE
175300200528     C                   Z-ADD     0             @MDAYN
175400200528     C                   END
175500200528     C*
175600200528     C     @VDYNO        IFLT      @SLDYN
175700200528     C     @VDYNO        ORLT      @IADYN
175800200528     C/COPY WNCPYSRC,MMDEAMIC05
175900200528     C                   MOVE      'N'           OKVDAT
176000200528     C                   ADD       1             Ix
176100200528     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
176200200528     C                   MOVEL     'MMM0153'     MsgIdArr(Ix)
176300200528     C                   GOTO      CHKKEYEND
176400200528     C/COPY WNCPYSRC,MMDEAMIC06
176500200528     C                   END
176600200528      *                                                                                     AR806147
176700200528      ** Check for EM deal amendment.                                                       AR806147
176800200528      ** Value date must be =  or < than the early maturity date                            AR806147
176900200528      *                                                                                     AR806147
177000200528     C                   MOVE      DDDLNO        KeyDealNo                                  AR806147
177100200528     C                   MOVE      'EM'          KeyAmdTyp         2                        AR806147
177200200528     C     @DMKY3        CHAIN     MMDEAML3                           65                    AR806147
177300200528     C*
177400200528     C** Value date must be = or < than maturity date if maturity date
177500200528     C** is present
177600200528     C     @MDAYN        IFNE      0
177700200528     C     @VDYNO        ANDGE     @MDAYN
177800200528     C     HNEMDT        ORNE      0                                                        AR806147
177900200528     C     @VDYNO        ANDGE     HNEMDT                                                   AR806147
178000200528     C     *IN65         ANDEQ     '0'                                                      AR806147
178100200528     C                   MOVE      'N'           OKVDAT
178200200528     C                   ADD       1             Ix
178300200528     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
178400200528     C                   MOVEL     'MMM0154'     MsgIdArr(Ix)
178500200528     C                   GOTO      CHKKEYEND
178600200528     C                   END
178700200528     C*
178800200528     C** For deam type 'SI' the deam value date must not be the same
178900200528     C** as the value date of a deam already existing on the deal.
179000200528     C** Also applys to deam type 'CI'.
179100200528     C     DDMTYP        IFEQ      'SI'
179200200528     C     DDACTN        ANDEQ     'I'
179300200528     C     DDMTYP        OREQ      'CI'
179400200528     C     DDACTN        ANDEQ     'I'
179500200528      *                                                                                       185658
179600200528      ** Save HNOMDT value.                                                                   185658
179700200528      *                                                                                       185658
179800200528     C                   MOVE      HNOMDT        W@OMDT            2                          185658
179900200528     C*
180000200528     C** Check for all possible deam sequence  values
180100200528     C                   MOVE      *LOVAL        @DEAMS
180200200528     C     @DEAMK        SETLL     MMLVDMLL
180300200528     C                   READ      MMLVDMLL                               65
180400200528     C*
180500200528     C**  Place value date from files into same sequence as display (DDMMYY)
180600200528     C                   MOVE      @DMVYR        @DMVY
180700200528     C     BJDFIN        IFEQ      'D'
180800200528     C                   MOVE      @DMVMT        @DMVM
180900200528     C                   MOVE      @DMVDY        @DMVD
181000200528     C                   ELSE
181100200528     C                   MOVE      @DMVMT        @DMVD
181200200528     C                   MOVE      @DMVDY        @DMVM
181300200528     C                   END
181400200528     C*
181500200528     C**  If a live record is found then a deam already exists
181600200528     C**  for the value date & deal number
181700200528     C     *IN65         IFEQ      '0'
181800200528     C     @@DLNO        ANDEQ     HNDA38
181900200528     C     DDVDAT        ANDEQ     @DMVDT
182000200528      *
182100200528     C                   MOVE      'N'           OKDLNO
182200200528     C                   MOVE      'N'           OKVDAT
182300200528     C                   MOVE      'N'           OKSEQN
182400200528     C                   ADD       1             Ix
182500200528     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
182600200528     C     DDMTYP        IFEQ      'SI'
182700200528     C                   MOVEL     'MMM0577'     MsgIdArr(Ix)
182800200528     C                   ELSE
182900200528     C                   MOVEL     'MMM2548'     MsgIdArr(Ix)
183000200528     C                   END
183100200528     C                   END
183200200528      *                                                                                       185658
183300200528      ** Restore HNOMDT value.                                                                185658
183400200528      *                                                                                       185658
183500200528     C                   MOVE      W@OMDT        HNOMDT                                       185658
183600200528     C                   END
183700200528     C/COPY WNCPYSRC,MMDEAMIC09
183800200528     C*
183900200528     C     CHKKEYEND     ENDSR
184000200528     C*****************************************************************
184100200528     C/EJECT
184200200528     C*****************************************************************
184300200528     C*          CHKDEAMPPL      - Check deal amendment principle
184400200528     C*****************************************************************
184500200528     C     CHKDEAMPPL    BEGSR
184600200528     C*
184700200528     C**  Access Original Deal:
184800200528     C**  If no valid record is found, or the record does not have a
184900200528     C**  status of 'A' or 'R', it is an error.
185000200528     C*
185100200528     C     HNDA38        CHAIN     MMDEALLL                           65
185200200528     C*
185300200528     C     *IN65         IFEQ      '1'
185400200528     C     H@DSTS        ORNE      'A'
185500200528     C     H@DSTS        ANDNE     'R'
185600200528     C     H@DSTS        ANDNE     'C'                                                       BUG4849
185700200528     C                   MOVE      'N'           OKDLNO
185800200528     C                   MOVE      'N'           OKVDAT
185900200528     C                   MOVE      'N'           OKSEQN
186000200528     C                   ADD       1             Ix
186100200528     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
186200200528     C                   MOVEL     'MMM0165'     MsgIdArr(Ix)
186300200528     C                   GOTO      CHKDEAMEND
186400200528     C                   END
186500200528     C*
186600200528     C** If deal amount is -ve make +ve for calculation
186700200528     C     H@AMNP        IFLT      0
186800200528     C                   Z-SUB     H@AMNP        H@AMNP
186900200528     C                   END
187000200528     C*
187100200528     C** Process all deams on file for this deal
187200200528     C*
187300200528     C                   MOVE      DDDLNO        KeyDealNo         6 0
187400200528     C                   MOVE      *LOVAL        KeyValDatD        2 0
187500200528     C                   MOVE      *LOVAL        KeyValDatM        2 0
187600200528     C                   MOVE      *LOVAL        KeyValDatY        4 0
187700200528     C                   MOVE      *LOVAL        KeySeqNum         3 0
187800200528     C                   MOVE      'N'           ErrorFound
187900200528     C                   MOVE      *ALL' '       DlnoOnFile        6
188000200528     C     @DMKY2        SETLL     MMLVDMLL
188100200528     C     *IN65         DOUEQ     '1'
188200200528     C     ErrorFound    OREQ      'Y'
188300200528     C                   READ      MMLVDMLL                               65
188400200528     C                   MOVE      HNDA38        DlnoOnFile
188500200528     C*
188600200528     C**  If a live record is found then a deam exists
188700200528     C**  for the deal number
188800200528     C     *IN65         IFEQ      '0'
188900200528     C     DlnoOnFile    ANDEQ     DDDLNO
189000200528     C*
189100200528     C**  Place value date from files into same sequence as display (DDMMYY)
189200200528     C                   MOVE      @DMVYR        @DMVY
189300200528     C     BJDFIN        IFEQ      'D'
189400200528     C                   MOVE      @DMVMT        @DMVM
189500200528     C                   MOVE      @DMVDY        @DMVD
189600200528     C                   ELSE
189700200528     C                   MOVE      @DMVMT        @DMVD
189800200528     C                   MOVE      @DMVDY        @DMVM
189900200528     C                   END
190000200528     C*
190100200528     C** If DEAM amount is -ve make +ve for calculation
190200200528     C     HNAMNP        IFLT      0
190300200528     C                   Z-SUB     HNAMNP        HNAMNP
190400200528     C                   END
190500200528     C*
190600200528
190700200528     C     H@AMNP        IFLT      *ZERO
190800200528     C                   MOVE      'N'           OKACTN
190900200528     C                   MOVE      'Y'           ErrorFound
191000200528     C                   ADD       1             Ix
191100200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
191200200528     C                   MOVEL     'MMM0295'     MsgidArr(Ix)
191300200528     C                   GOTO      CHKDEAMEND
191400200528     C                   END
191500200528     C*
191600200528     C** If current transaction is a delete of a 'PI' & record read
191700200528     C** is record to be deleted ignore it
191800200528     C*
191900200528     C     DDMTYP        IFEQ      'PI'
192000200528     C*
192100200528     C** Place sequence number into alpha field for comparison
192200200528     C                   MOVE      *BLANKS       SeqNoAlpha
192300200528     C                   MOVE      HNDS38        SeqNoAlpha        3
192400200528     C     DDACTN        IFNE      'D'
192500200528     C*
192600200528     C     DDVDAT        ORNE      @DMVDT
192700200528     C     SeqNoAlpha    ORNE      DDDS38
192800200528     C*
192900200528     C** If record read is PI add deam amount to deal principle
193000200528     C     HNMTYP        IFEQ      'PI'
193100200528     C     H@AMNP        ADD       HNAMNP        H@AMNP
193200200528     C                   END
193300200528     C                   END
193400200528     C** Move end to after check if PCPL >= 0.
193500200528     C*
193600200528     C** If read transaction is a 'PD' subtract deam amount
193700200528     C** from deal principle
193800200528     C     HNMTYP        IFEQ      'PD'
193900200528     C     H@AMNP        SUB       HNAMNP        H@AMNP
194000200528     C                   END
194100200528     C*
194200200528     C** New principle must be = or > 0.
194300200528     C     H@AMNP        IFLT      *ZERO
194400200528     C                   MOVE      'N'           OKACTN
194500200528     C                   MOVE      'Y'           ErrorFound
194600200528     C                   ADD       1             Ix
194700200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
194800200528     C                   MOVEL     'MMM0295'     MsgidArr(Ix)
194900200528     C                   GOTO      CHKDEAMEND
195000200528     C                   END
195100200528     C                   END
195200200528     C                   END
195300200528     C                   END
195400200528     C*
195500200528     C/COPY WNCPYSRC,MMDEAMIC10
195600200528     C*
195700200528     C     CHKDEAMEND    ENDSR
195800200528     C*
195900200528     C/EJECT
196000200528      *****************************************************************
196100200528      * ACSSEC - ACCESS SECURITY CHECKING
196200200528      *****************************************************************
196300200528     C     ACSSEC        BEGSR
196400200528     C*
196500200528     C* If not multi-branching, check authority to only action code
196600200528     C*
196700200528     C     BJSBRC        IFNE      *BLANK
196800200528     C                   CALL      'ZVACTU'
196900200528     C                   PARM      DDACTN        ZACTN             1
197000200528     C                   PARM                    @@ERR             1 0
197100200528     C     @@ERR         IFEQ      1
197200200528     C                   MOVE      'N'           OKACTN
197300200528     C                   MOVE      'N'           OKDLNO
197400200528     C                   ADD       1             Ix
197500200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
197600200528     C                   MOVEL     'FXM0292'     MsgIdArr(Ix)
197700200528     C                   GOTO      EACSSE
197800200528     C                   END
197900200528     C                   END
198000200528     C*
198100200528     C* If multi-branching, check authority to booking branch
198200200528     C*
198300200528     C     BJSBRC        IFEQ      *BLANK
198400200528     C*
198500200528     C*  Access file for deal associated  branch code
198600200528     C*  for validation.
198700200528     C     @@DLNO        CHAIN     MMDEALLL                           65
198800200528      *                                                                                       260173
198900200528      ** For reversal transaction, use @ACTRV instead of DDACTN in access security checking   260173
199000200528     C                   MOVE      *BLANK        WACTN             1                          260173
199100200528     C     @ACTRV        IFEQ      'X'                                                        260173
199200200528     C                   MOVE      @ACTRV        WACTN                                        260173
199300200528     C                   ELSE                                                                 260173
199400200528     C                   MOVE      DDACTN        WACTN                                        260173
199500200528     C                   ENDIF                                                                260173
199600200528     C*
199700200528     C                   CALL      'ZVACTBU'
199800200528     C**********         PARM      DDACTN        ZACTN             1                          260173
199900200528     C                   PARM      WACTN         ZACTN             1                          260173
200000200528     C                   PARM      H@BRCA        ZBR               3
200100200528     C                   PARM                    @@ERR             1 0
200200200528     C*
200300200528     C     @@ERR         IFEQ      1
200400200528     C                   MOVE      'N'           OKACTN
200500200528     C                   MOVE      'N'           OKDLNO
200600200528     C                   MOVE      'N'           OKVDAT
200700200528     C                   MOVE      'N'           OKSEQN
200800200528     C                   ADD       1             Ix
200900200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
201000200528     C                   MOVEL     'FXM0290'     MsgIdArr(Ix)
201100200528     C                   GOTO      EACSSE
201200200528     C                   END
201300200528     C*
201400200528     C     @@ERR         IFEQ      2
201500200528     C                   MOVE      'N'           OKACTN
201600200528     C                   MOVE      'N'           OKDLNO
201700200528     C                   MOVE      'N'           OKVDAT
201800200528     C                   MOVE      'N'           OKSEQN
201900200528     C                   ADD       1             Ix
202000200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
202100200528     C                   MOVEL     'FXM0291'     MsgIdArr(Ix)
202200200528     C                   GOTO      EACSSE
202300200528     C                   END
202400200528     C*
202500200528     C* Check authority to originating branch
202600200528     C*
202700200528     C     BKOBUV        IFEQ      'Y'
202800200528     C     DDACTN        ANDNE     'E'
202900200528     C     DDACTN        ANDNE     'I'
203000200528     C                   CALL      'ZVOBU'
203100200528     C                   PARM      H@ORBR        ZOBRX             3
203200200528     C                   PARM                    @@ERR             1 0
203300200528     C     @@ERR         IFEQ      1
203400200528     C                   MOVE      'N'           OKACTN
203500200528     C                   MOVE      'N'           OKDLNO
203600200528     C                   MOVE      'N'           OKVDAT
203700200528     C                   MOVE      'N'           OKSEQN
203800200528     C                   ADD       1             Ix
203900200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
204000200528     C                   MOVEL     'FXM0287'     MsgIdArr(Ix)
204100200528     C                   GOTO      EACSSE
204200200528     C                   END
204300200528     C     @@ERR         IFEQ      2
204400200528     C                   MOVE      'N'           OKACTN
204500200528     C                   MOVE      'N'           OKDLNO
204600200528     C                   MOVE      'N'           OKVDAT
204700200528     C                   MOVE      'N'           OKSEQN
204800200528     C                   ADD       1             Ix
204900200528     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
205000200528     C                   MOVEL     'FXM0288'     MsgIdArr(Ix)
205100200528     C                   GOTO      EACSSE
205200200528     C                   END
205300200528     C                   END
205400200528     C                   END
205500200528     C*
205600200528     C/COPY WNCPYSRC,MMDEAMIC11
205700200528     C     EACSSE        ENDSR
205800200528      *****************************************************************
205900200528      /EJECT
206000200528     C*****************************************************************
206100200528     C* INIT - INITIALIZATION
206200200528     C*****************************************************************
206300200528     C     INIT          BEGSR
206400200528      *
206500200528     C     *DTAARA       DEFINE                  ZMUSER                         CAP084
206600200528     C                   IN        ZMUSER                                       CAP084
206700200528     C                   UNLOCK    ZMUSER                                       CAP084
206800200528      *
206900200528      * CLEAR OUTPUTS
207000200528      *
207100200528     C                   CLEAR                   DeamFilFmt
207200200528     C                   MOVEL     'Y'           OKACTN
207300200528     C                   MOVEL     'Y'           OKDLNO
207400200528     C                   MOVEL     'Y'           OKVDAT
207500200528     C                   MOVEL     'Y'           OKSEQN
207600200528      *
207700200528     C                   ENDSR
207800200528     C********************************************************************
207900200528      /EJECT
208000200528      *****************************************************************
208100200528      * *INZSR - INITIAL PROCESSING
208200200528      *****************************************************************
208300200528     C     *INZSR        BEGSR
208400200528      *
208500200528      * Parameters
208600200528      *
208700200528     C     *ENTRY        PLIST
208800200528      *
208900200528      * INPUTS
209000200528      *
209100200528      * Return code
209200200528     C                   PARM                    RetCodeIn
209300200528      *
209400200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
209500200528      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
209600200528      *
209700200528     C                   PARM                    ModeofOp          6
209800200528      *
209900200528      * Response mode
210000200528     C                   PARM                    RespMode          1
210100200528      *
210200200528      * Action Code
210300200528     C                   PARM                    DDACTN            1
210400200528      *
210500200528      * Front Office Transaction ID
210600200528     C                   PARM                    FOTRID           20
210700200528      *
210800200528      * Front Office Associated Transaction Id
210900200528     C                   PARM                    FOASID           20
211000200528      *
211100200528      * (Midas) Deal Number
211200200528     C                   PARM                    DDDLNO            6
211300200528      *
211400200528      * Value Date
211500200528     C                   PARM                    DDVDAT            6
211600200528      *
211700200528      * Sequence Number
211800200528     C                   PARM                    DDDS38            3
211900200528      *
212000200528      * Deal Amendment Amount
212100200528     C                   PARM                    DDAMNP           15
212200200528      *
212300200528      * Deal Amendment Type
212400200528     C                   PARM                    DDMTYP            2
212500200528      * Action Code (Reversal transaction)                                                    260173
212600200528     C                   PARM                    @ACTRV            1                          260173
212700200528      *
212800200528      * OUTPUTS
212900200528      *
213000200528      * (Current) deal in file format
213100200528     C                   PARM                    DeamFilFmt
213200200528      *
213300200528      * OK - Action code
213400200528     C                   PARM                    OKACTN            1
213500200528      *
213600200528      * OK - Deal Number
213700200528     C                   PARM                    OKDLNO            1
213800200528      *
213900200528      * OK - Value Date
214000200528     C                   PARM                    OKVDAT            1
214100200528      *
214200200528      * OK - Sequence Number
214300200528     C                   PARM                    OKSEQN            1
214400200528      *
214500200528      * Error fields/message IDs/message data (arrays) from/to caller
214600200528     C                   PARM                    FldNameArr
214700200528     C                   PARM                    MsgIdArr
214800200528     C                   PARM                    MsgDtaArr
214900200528      *
215000200528      * Array index (3P0) from/to caller
215100200528     C                   PARM                    Ix
215200200528      *
215300200528      ** Initialize program name
215400200528      *
215500200528     C                   MOVEL     'MMDEAMRTV'   DBPGM
215600200528      *
215700200528      * Key Lists
215800200528      *
215900200528      * Deal Amendments
216000200528     C     @DEAMK        KLIST
216100200528     C********           KFLD                    @DEAMN            6 0
216200200528     C                   KFLD                    @@DLNO            6 0
216300200528     C                   KFLD                    @VDYY             4 0
216400200528     C                   KFLD                    @VDMM             2 0
216500200528     C                   KFLD                    @VDDD             2 0
216600200528     C                   KFLD                    @DEAMS            3 0
216700200528      *
216800200528      * Deal Amendments 2
216900200528     C     @DMKY2        KLIST
217000200528     C                   KFLD                    KeyDealNo
217100200528     C                   KFLD                    KeyValDatY
217200200528     C                   KFLD                    KeyValDatM
217300200528     C                   KFLD                    KeyValDatD
217400200528     C                   KFLD                    KeySeqNum
217500200528      *                                                                                       CDL017
217600200528      * Deal Amendments 3                                                                     CDL017
217700200528     C     @DMKY3        KLIST                                                                CDL017
217800200528     C                   KFLD                    KeyDealNo                                    CDL017
217900200528     C                   KFLD                    KeyAmdTyp                                    CDL017
218000200528     C*
218100200528     C** Key List for MMDEAML0
218200200528     C     FrntOfKey     KLIST
218300200528     C                   KFLD                    UniqDeamID       20
218400200528     C                   KFLD                    OrigDealNo       20
218500200528                                                                                              CSD015
218600200528      ** Compliance Watch Hit List Key                                                        CSD015
218700200528     C     KCWHT         KLIST                                                                CSD015
218800200528     C                   KFLD                    KFuncType                                    CSD015
218900200528     C                   KFLD                    KIden                                        CSD015
219000200528     C                   KFLD                    KBranch                                      CSD015
219100200528                                                                                              CSD015
219200200528     C*
219300200528      ** ACCESS BANK DETAILS
219400200528      *
219500200528     C                   CALL      'AOBANKR0'
219600200528     C                   PARM      *BLANKS       @RTCD             7
219700200528     C                   PARM      '*FIRST '     @OPTN             7
219800200528     C     SDBANK        PARM      SDBANK        DSFDY
219900200528      *
220000200528      * DATABASE ERROR
220100200528      *
220200200528     C     @RTCD         IFNE      *BLANKS
220300200528     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
220400200528     C                   MOVEL     '901'         DBASE                          * DBERR 901*
220500200528     C                   MOVEL     @OPTN         DBKEY                          ************
220600200528     C                   EXSR      *PSSR
220700200528     C                   END
220800200528      *
220900200528      ** ACCESS GENERAL LEDGER DETAILS
221000200528      *
221100200528     C**********         CALL      'AOGELRR0'                                                 CGL029
221200200528     C                   CALL      'AOGELRR1'                                                 CGL029
221300200528     C                   PARM      *BLANKS       @RTCD             7
221400200528     C                   PARM      '*FIRST '     @OPTN             7
221500200528     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
221600200528     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
221700200528      *
221800200528      * DATABASE ERROR
221900200528      *
222000200528     C     @RTCD         IFNE      *BLANKS
222100200528     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
222200200528     C                   MOVEL     '902'         DBASE                          * DBERR 902*
222300200528     C                   MOVEL     @OPTN         DBKEY                          ************
222400200528     C                   EXSR      *PSSR
222500200528     C                   END
222600200528      *
222700200528      ** ACCESS DEALING DETAILS
222800200528      *
222900200528     C**********         CALL      'AODEALR0'                                                 CGL029
223000200528     C                   CALL      'AODEALR1'                                                 CGL029
223100200528     C                   PARM      *BLANKS       @RTCD             7
223200200528     C                   PARM      '*FIRST '     @OPTN             7
223300200528     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
223400200528     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
223500200528      *
223600200528      * DATABASE ERROR
223700200528      *
223800200528     C     @RTCD         IFNE      *BLANK
223900200528     C                   MOVEL     @OPTN         DBKEY
224000200528     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
224100200528     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
224200200528     C                   EXSR      *PSSR                                        *************
224300200528     C                   END
224400200528      *
224500200528      ** ACCESS DEAL NUMBER RECORD
224600200528      *
224700200528     C     1             CHAIN     FDDLNMLL                           99
224800200528      *
224900200528      * DATABASE ERROR
225000200528      *
225100200528     C     *IN99         IFEQ      '1'
225200200528     C     NODLTF        OREQ      '*'
225300200528     C                   MOVEL     '1     '      DBKEY
225400200528     C                   MOVEL     'FDDLNMLL'    DBFILE                         *************
225500200528     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
225600200528     C                   EXSR      *PSSR                                        *************
225700200528     C                   END
225800200528      *                                                                         CSE006
225900200528      ** Access SAR details file to determine if CSE006 is on.                  CSE006
226000200528      ** (Repurchase Agreement Enhancements)                                    CSE006
226100200528      *                                                                         CSE006
226200200528     C                   CALLB     'AOSARDR0'                                   CSE006
226300200528     C                   PARM      *BLANKS       @RTCD                          CSE006
226400200528     C                   PARM      '*VERIFY'     @OPTN                          CSE006
226500200528     C                   PARM      'CSE006'      @SARD                          CSE006
226600200528     C     @RTCD         IFNE      *BLANKS                                      CSE006
226700200528     C     @RTCD         ANDNE     '*NRF   '                                    CSE006
226800200528     C     *LOCK         IN        LDA                                          CSE006
226900200528     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
227000200528     C                   MOVEL     '905'         DBASE                          CSE006
227100200528     C                   MOVEL     'CSE006'      DBKEY                          CSE006
227200200528     C                   OUT       LDA                                          CSE006
227300200528     C                   SETON                                        U7U8LR    CSE006
227400200528     C                   EXSR      *PSSR                                        CSE006
227500200528     C                   END                                                    CSE006
227600200528     C     @RTCD         IFEQ      *BLANK                                       CSE006
227700200528     C                   MOVEL     'Y'           CSE006            1            CSE006
227800200528     C                   END                                                    CSE006
227900200528                                                                                              CSD015
228000200528      **  Access the SDSTAT Data Area.                                                        CSD015
228100200528     C                   IN        SDSTAT                                                     CSD015
228200200528                                                                                              CSD015
228300200528      **  Access SAR details to see if CSD015 is switched on.                                 CSD015
228400200528     C                   EVAL      CSD015 = 'N'                                               CSD015
228500200528     C                   CALLB     'AOSARDR0'                                                 CSD015
228600200528     C                   PARM      *BLANKS       @RtCd                                        CSD015
228700200528     C                   PARM      '*VERIFY'     @Optn                                        CSD015
228800200528     C                   PARM      'CSD015'      PSARD                                        CSD015
228900200528     C     SCSARD        PARM      *BLANKS       DSFDY                                        CSD015
229000200528                                                                                              CSD015
229100200528     C                   IF        @RtCd = *BLANKS                                            CSD015
229200200528                                                                                              CSD015
229300200528     C                   EVAL      CSD015 = 'Y'                                               CSD015
229400200528     C                   ELSE                                                                 CSD015
229500200528                                                                                              CSD015
229600200528     C                   IF        @RtCd <> '*NRF'                                            CSD015
229700200528     C     *LOCK         IN        LDA                                                        CSD015
229800200528     C                   EVAL      DBKey = 'CSD015'                                           CSD015
229900200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
230000200528     C                   EVAL      DBase = 906                                                CSD015
230100200528     C                   OUT       LDA                                                        CSD015
230200200528     C                   EXSR      *PSSR                                                      CSD015
230300200528     C                   ENDIF                                                                CSD015
230400200528                                                                                              CSD015
230500200528     C                   ENDIF                                                                CSD015
230600200528                                                                                              CSD015
230700200528     C                   IF        CSD015 = 'Y'                                               CSD015
230800200528                                                                                              CSD015
230900200528      ** Check if transactions are being monitored by Compliance Watch.                       CSD015
231000200528     C                   CALL      'AOWLCCR0'                                                 CSD015
231100200528     C                   PARM      *BLANKS       @RtCd                                        CSD015
231200200528     C                   PARM      '*KEY   '     @Optn                                        CSD015
231300200528     C                   PARM      'DEALING '    PFuncCode                                    CSD015
231400200528     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
231500200528                                                                                              CSD015
231600200528     C                   IF        @RtCd <> *BLANKS AND                                       CSD015
231700200528     C                             @RtCd <> '*NRF'                                            CSD015
231800200528     C     *LOCK         IN        LDA                                                        CSD015
231900200528     C                   EVAL      DBKey = 'DEALING'                                          CSD015
232000200528     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
232100200528     C                   EVAL      DBase = 907                                                CSD015
232200200528     C                   OUT       LDA                                                        CSD015
232300200528     C                   EXSR      *PSSR                                                      CSD015
232400200528     C                   ENDIF                                                                CSD015
232500200528                                                                                              CSD015
232600200528     C                   ENDIF                                                                CSD015
232700200528                                                                                              CSD015
232800200528      **  Access SAR details to see if CSC011 is switched on.                                 CSD015
232900200528     C                   EVAL      CSC011 = 'N'                                               CSD015
233000200528     C                   CALLB     'AOSARDR0'                                                 CSD015
233100200528     C                   PARM      *BLANKS       @RtCd                                        CSD015
233200200528     C                   PARM      '*VERIFY'     @Optn                                        CSD015
233300200528     C                   PARM      'CSC011'      PSARD                                        CSD015
233400200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
233500200528                                                                                              CSD015
233600200528     C                   IF        @RtCd = *BLANKS                                            CSD015
233700200528                                                                                              CSD015
233800200528     C                   EVAL      CSC011 = 'Y'                                               CSD015
233900200528     C                   IN        SC24X7                                                     CSD015
234000200528     C                   ELSE                                                                 CSD015
234100200528                                                                                              CSD015
234200200528     C                   IF        @RtCd <> '*NRF'                                            CSD015
234300200528     C     *LOCK         IN        LDA                                                        CSD015
234400200528     C                   EVAL      DBKey = 'CSC011'                                           CSD015
234500200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
234600200528     C                   EVAL      DBase = 908                                                CSD015
234700200528     C                   OUT       LDA                                                        CSD015
234800200528     C                   EXSR      *PSSR                                                      CSD015
234900200528     C                   ENDIF                                                                CSD015
235000200528                                                                                              CSD015
235100200528     C                   ENDIF                                                                CSD015
235200200528                                                                                              CSD015
235300200528      *                                                                                       CDL010
235400200528      ** Access SAR details file to determine if CDL010 is on.                                CDL010
235500200528      ** (Dealing Transaction Authorisation)                                                  CDL010
235600200528      *                                                                                       CDL010
235700200528     C                   CALLB     'AOSARDR0'                                                 CDL010
235800200528     C                   PARM      *BLANKS       @RTCD             7                          CDL010
235900200528     C                   PARM      '*VERIFY'     @OPTN             7                          CDL010
236000200528     C                   PARM      'CDL010'      @SARD             6                          CDL010
236100200528      *                                                                                       CDL010
236200200528     C     @RTCD         IFEQ      *BLANK                                                     CDL010
236300200528     C                   MOVE      'Y'           CDL010            1                          CDL010
236400200528     C                   ELSE                                                                 CDL010
236500200528     C     @RTCD         IFEQ      '*NRF'                                                     CDL010
236600200528     C                   MOVE      'N'           CDL010                                       CDL010
236700200528     C                   ELSE                                                                 CDL010
236800200528      *                                                                                       CDL010
236900200528      **    Database error processing                                                         CDL010
237000200528      *                                                                                       CDL010
237100200528     C     *LOCK         IN        LDA                                                        CDL010
237200200528     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CDL010
237300200528     C                   MOVEL     '906'         DBASE                          * DBERR 906 * CDL010
237400200528     C                   MOVEL     'CDL010'      DBKEY                          ************* CDL010
237500200528     C                   OUT       LDA                                                        CDL010
237600200528     C                   SETON                                        U7U8LR                  CDL010
237700200528     C                   EXSR      *PSSR                                                      CDL010
237800200528     C                   END                                                                  CDL010
237900200528     C                   END                                                                  CDL010
238000200528                                                                                              CSC024
238100200528      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
238200200528      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
238300200528                                                                                              CSC024
238400200528     C                   CALLB     'AOSARDR0'                                                 CSC024
238500200528     C                   PARM      *BLANKS       @RTCD                                        CSC024
238600200528     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
238700200528     C**********         PARM      'CSC024'      @SARD                                 CSC024 CSC054
238800200528     C                   PARM      'CSC054'      @SARD                                        CSC054
238900200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
239000200528                                                                                              CSC024
239100200528     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
239200200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
239300200528     C**********         EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
239400200528     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
239500200528     C                   EVAL      DBase  = 3                                                 CSC024
239600200528     C                   EXSR      *PSSR                                                      CSC024
239700200528     C                   ENDIF                                                                CSC024
239800200528                                                                                              CSC024
239900200528     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
240000200528     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
240100200528     C                   EVAL      CSC054 = 'N'                                               CSC054
240200200528     C                   EVAL      WPEAInd = 'N'                                              CSC054
240300200528                                                                                              CSC024
240400200528     C                   IF        @RTCD = *BLANKS                                            CSC024
240500200528     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
240600200528     C                   EVAL      CSC054 = 'Y'                                               CSC054
240700200528                                                                                              CSC024
240800200528      ** Access System values                                                                 CSC024
240900200528                                                                                              CSC024
241000200528     C                   CALL      'AOSVALR0'                                                 CSC024
241100200528     C                   PARM      *BLANKS       PRetCode                                     CSC024
241200200528     C                   PARM      PSysVal1      P@OP01                                       CSC024
241300200528     C                   PARM      *BLANKS       P@VL01                                       CSC024
241400200528     C                   PARM      *BLANKS       P@OP02                                       CSC024
241500200528     C                   PARM      *BLANKS       P@VL02                                       CSC024
241600200528     C                   PARM      *BLANKS       P@OP03                                       CSC024
241700200528     C                   PARM      *BLANKS       P@VL03                                       CSC024
241800200528     C                   PARM      *BLANKS       P@OP04                                       CSC024
241900200528     C                   PARM      *BLANKS       P@VL04                                       CSC024
242000200528     C                   PARM      *BLANKS       P@OP05                                       CSC024
242100200528     C                   PARM      *BLANKS       P@VL05                                       CSC024
242200200528     C                   PARM      *BLANKS       P@OP06                                       CSC024
242300200528     C                   PARM      *BLANKS       P@VL06                                       CSC024
242400200528     C                   PARM      *BLANKS       P@OP07                                       CSC024
242500200528     C                   PARM      *BLANKS       P@VL07                                       CSC024
242600200528     C                   PARM      *BLANKS       P@OP08                                       CSC024
242700200528     C                   PARM      *BLANKS       P@VL08                                       CSC024
242800200528     C                   PARM      *BLANKS       P@OP09                                       CSC024
242900200528     C                   PARM      *BLANKS       P@VL09                                       CSC024
243000200528     C                   PARM      *BLANKS       P@OP10                                       CSC024
243100200528     C                   PARM      *BLANKS       P@VL10                                       CSC024
243200200528                                                                                              CSC024
243300200528     C                   IF        PRetCode  <> *BLANKS                                       CSC024
243400200528     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
243500200528     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
243600200528     C                   EVAL      DBase = 4                                                  CSC024
243700200528     C                   EXSR      *PSSR                                                      CSC024
243800200528     C                   ENDIF                                                                CSC024
243900200528     C                   IF        P@VL01 = 'Y'                                               CSC024
244000200528     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
244100200528     C                   EVAL      WPEAInd = 'Y'                                              CSC054
244200200528     C                   ENDIF                                                                CSC024
244300200528     C                   ENDIF                                                                CSC024
244400200528      *                                                                                      BUG8360
244500200528      ** Access CGL014 details in SCSARDPD.                                                  BUG8360
244600200528      *                                                                                      BUG8360
244700200528     C                   CALLB     'AOSARDR0'                                                BUG8360
244800200528     C                   PARM      *BLANKS       @RTCD                                       BUG8360
244900200528     C                   PARM      '*VERIFY'     @OPTN                                       BUG8360
245000200528     C                   PARM      'CGL014'      @SARD                                       BUG8360
245100200528     C     @RTCD         IFNE      *BLANKS                                                   BUG8360
245200200528     C     @RTCD         ANDNE     '*NRF   '                                                 BUG8360
245300200528     C     *LOCK         IN        LDA                                                       BUG8360
245400200528     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG8360
245500200528     C                   MOVEL     '909'         DBASE                                       BUG8360
245600200528     C                   MOVEL     'CGL014'      DBKEY                                       BUG8360
245700200528     C                   OUT       LDA                                                       BUG8360
245800200528     C                   SETON                                        U7U8LR                 BUG8360
245900200528     C                   EXSR      *PSSR                                                     BUG8360
246000200528     C                   END                                                                 BUG8360
246100200528     C     @RTCD         IFEQ      *BLANK                                                    BUG8360
246200200528     C                   MOVEL     'Y'           CGL014            1                         BUG8360
246300200528     C                   END                                                                 BUG8360
246400200528                                                                                              CAP185
246500200528      ** Check if CAP185 is installed                                                         CAP185
246600200528     C                   CALLB     'AOSARDR0'                                                 CAP185
246700200528     C                   PARM      *BLANKS       @RTCD             7                          CAP185
246800200528     C                   PARM      '*VERIFY'     @OPTN             7                          CAP185
246900200528     C                   PARM      'CAP185'      @SARD             6                          CAP185
247000200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP185
247100200528     C*                                                                                       CAP185
247200200528     C                   IF        @RTCD = *BLANK                                             CAP185
247300200528     C                   MOVE      'Y'           CAP185            1                          CAP185
247400200528      *                                                                                       CAP185
247500200528      ** Determine if Auto-authorise                                                          CAP185
247600200528     C     *LIKE         DEFINE    APNAME        @APINAME                                     CAP185
247700200528     C                   MOVEL     'DEAM'        @APINAME                                     CAP185
247800200528     C     @APINAME      CHAIN     APICFGL0                                                   CAP185
247900200528     C                   IF        %FOUND(APICFGL0)                                           CAP185
248000200528     C                   MOVE      APAUT         @AUTHO            1                          CAP185
248100200528     C                   ENDIF                                                                CAP185
248200200528      *                                                                                       CAP185
248300200528     C                   ELSE                                                                 CAP185
248400200528     C                   IF        @RTCD = '*NRF'                                             CAP185
248500200528     C                   MOVE      'N'           CAP185                                       CAP185
248600200528     C                   ELSE                                                                 CAP185
248700200528     C*                                                                                       CAP185
248800200528     C**    Database error processing                                                         CAP185
248900200528     C*                                                                                       CAP185
249000200528     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CAP185
249100200528     C                   MOVEL     '185'         DBASE                          * DBERR 185 * CAP185
249200200528     C                   MOVEL     'CAP185'      DBKEY                          ************* CAP185
249300200528     C                   EXSR      *PSSR                                                      CAP185
249400200528     C                   END                                                                  CAP185
249500200528     C                   END                                                                  CAP185
249600200528      *                                                                                       CAP185
249700200528      ** Check if CER043 is switched on                                                       CER043
249800200528                                                                                              CER043
249900200528     C                   CALL      'AOSARDR0'                                                 CER043
250000200528     C                   PARM      *BLANKS       @RTCD                                        CER043
250100200528     C                   PARM      '*VERIFY'     @OPTN                                        CER043
250200200528     C                   PARM      'CER043'      @SARD                                        CER043
250300200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
250400200528                                                                                              CER043
250500200528     C                   IF        @RTCD = *BLANKS                                            CER043
250600200528     C                   EVAL      CER043 = 'Y'                                               CER043
250700200528     C                   ELSE                                                                 CER043
250800200528     C                   EVAL      CER043 = 'N'                                               CER043
250900200528                                                                                              CER043
251000200528     C                   IF        @RTCD <> '*NRF'                                            CER043
251100200528     C     *LOCK         IN        LDA                                                        CER043
251200200528     C                   EVAL      DBKEY = 'CER043'                                           CER043
251300200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
251400200528     C                   EVAL      DBASE = 001                                                CER043
251500200528     C                   OUT       LDA                                                        CER043
251600200528     C                   EXSR      *PSSR                                                      CER043
251700200528     C                   ENDIF                                                                CER043
251800200528                                                                                              CER043
251900200528     C                   ENDIF                                                                CER043
252000200528                                                                                              CER043
252100200528     C/COPY WNCPYSRC,MMDEAMIC03
252200200528      *                                                                                       256795
252300200528     C                   CALLB     'AOSARDR0'                                                 256795
252400200528     C                   PARM      *BLANKS       @RTCD                                        256795
252500200528     C                   PARM      '*VERIFY'     @OPTN                                        256795
252600200528     C                   PARM      'CDL052'      @SARD                                        256795
252700200528     C     @RTCD         IFEQ      *BLANK                                                     256795
252800200528     C                   MOVEL     'Y'           CDL052            1                          256795
252900200528     C                   else                                                                 256795
253000200528     C                   MOVEL     'N'           CDL052            1                          256795
253100200528     C                   ENDIF                                                                256795
253200200528                                                                                              CSD083
253300200528      ** Check if Watch List Element (CSD083) is on                                           CSD083
253400200528                                                                                              CSD083
253500200528     C                   CALL      'AOSARDR0'                                                 CSD083
253600200528     C                   PARM      *BLANKS       @RTCD                                        CSD083
253700200528     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
253800200528     C                   PARM      'CSD083'      PSARD                                        CSD083
253900200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
254000200528                                                                                              CSD083
254100200528     C                   IF        @RTCD <> *BLANKS AND                                       CSD083
254200200528     C                             @RTCD <> '*NRF   '                                         CSD083
254300200528     C     *LOCK         IN        LDA                                                        CSD083
254400200528     C                   EVAL      DBASE = 910                                                CSD083
254500200528     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
254600200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
254700200528     C                   OUT       LDA                                                        CSD083
254800200528     C                   EXSR      *PSSR                                                      CSD083
254900200528     C                   ENDIF                                                                CSD083
255000200528                                                                                              CSD083
255100200528     C                   IF        @RTCD = *BLANKS                                            CSD083
255200200528     C                   EVAL      CSD015 = 'N'                                               CSD083
255300200528     C                   ENDIF                                                                CSD083
255400200528      *                                                                                       256795
255500200528      **  GET ZMUSER to access default branch.
255600200528      *
255700200528     C******DTAARA       DEFINE                  ZMUSER                                       CAP084
255800200528     C*****              IN        ZMUSER                                                     CAP084
255900200528     C*****              UNLOCK    ZMUSER                                                     CAP084
256000200528     C/COPY WNCPYSRC,MMDEAMIC07
256100200528      *
256200200528     C                   ENDSR
256300200528      *****************************************************************
256400200528      /EJECT
256500200528      ********************************************************************
256600200528      ** Program, module and procedure names for database error processing.
256700200528      ** =================================================================
256800200528      ** The following /COPY sets these values, and also defines LDA as
256900200528      ** an external data area
257000200528      ********************************************************************
257100200528     C/COPY ZACPYSRC,PSSR_ILE
257200200528      ********************************************************************
257300200528**  CPY@
257400200528(c) Finastra International Limited 2001
257500200528** @DT2  ARRAY OF POSSIBLE MIDAS DEAL TYPES
257600200528ITIPTDTICILNCDCLDLC1C2BPBDILIDCF                                                             BUG8114
257700200528** FIDTYP Array for Fiduciary Deal Types                                        CDL006
257800200528FLFTDPDTLPLT                                                                    CDL006
