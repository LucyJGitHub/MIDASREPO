     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Settle instructions screen input')            *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  ZASETINSIN - SETTLEMENT INSTRUCTIONS SCREEN INPUT            *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for extended settlement instructions.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD037023           Date 12Jan16               *
      *  Prev Amend No. MD036631           Date 27Nov15               *
      *                 MD036070           Date 19Oct15               *
      *                 MD029855           Date 25Nov14               *
      *                 MD029216           Date 25Nov14               *
      *                 MD029234           Date 25Nov14               *
      *                 MD029217           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 30May14               *
      *                 MD026923           Date 24May14               *
      *                 MD021872           Date 12Sep13               *
      *                 AR1015982          Date 06Aug12               *
      *                 AR1010565          Date 26Jul12               *
      *                 CSW212             Date 03May12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL036             Date 28Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 214967             Date 15Apr03               *
      *                 CAP076             Date 16May02               *
      *                 215792             Date 25Mar03               *
      *                 CRE008             Date 19Feb02               *
      *                 CDL011             Date 07Jul02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210013             Date 06Nov02               *
      *                 196461             Date 22Apr02               *
      *                 201096             Date 12Apr02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20MAy02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185751             Date 17Nov00               *
      *                 CPB002             DATE 19Oct00               *
      *                 CIR003             Date 12Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186433             Date 16Nov00               *
      *                 179510             Date 06Nov00               *
      *                 CDL008             Date 02May00               *
      *                 166888             Date 02May00               *
      *                 180500             DATE 11Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      *                 171873             Date 03Dec99               *
      *                 161504             Date 11Aug99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 164570             Date 16Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 160419             Date 17May99               *
      *                 152344             DATE 05Jan98               *
      *                 CAP003             Date 03Jun98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD037023 - Incorrect function keys on 2nd Settlement Details *
      *             Interest screen (Recompile)                       *
      *  MD036631 - F11 displays Reporting screen instead of going    *
      *             back to main screen                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  MD029855 - F12=Reporting Info Function Key Errors in Deals   *
      *             Enquiry Menu for FXDL transaction                 *
      *  MD029216 - Navigation Issues on Deals Enquiry for CIRS       *
      *             Transactions                                      *
      *  MD029234 - Version of ISDA Field in Deals Enquiry Screen has *
      *             defaulted value of 0000 instead of blank.         *
      *  MD029217 - Sender to Receiver Information (Definition Con -  *
      *             firmation) and ISDA Info are missing in Deals     *
      *             Enquiry for Completed CIRS Transaction            *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *  MD026923 - Use system value to display customer number or    *
      *             shortname                                         *
      *  MD021872 - No Reporting Information details in Deals enquiry *
      *  AR1015982 - The labels/screen of the FRA deal is retained    *
      *              upon enquiring an FX deal and vice versa.        *
      *  AR1010565 - The words Cover message and Confirmation is not  *
      *              written in the deals enquiry                     *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL036 - Prevent Trade input if CLS SSI missing              *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214967 - Move customer numbers as on the command key line.   *
      *           Recompile due to changes in ZASETINSDF.             *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Enable Pay/Rec to be protected if ##CALP is LEND    *
      *  215792 - Recompile due to changes in ZASETINSDF.             *
      *  CRE008 - Cash Management                                     *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  210013 - Make use of DDRONX and DDPONX instead of DDRONS and *
      *           DDPONS to determine if settlement is on its first   *
      *           validation or not.                                  *
      *  196461 - Additional parameter ##PREC and ##PPAY to ZASETINVAL*
      *  201096 - The Settlement Currency field is still displayed    *
      *           even if the currency used is not Euro or a Legacy   *
      *           currency.                                           *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  200400 - Reverse fix 179510                                  *
      *  185751 - Pass the action code as a parameter to ZASETINVAL,  *
      *           to be used in the validation.                       *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *           Protect Settlement Ccy (Payments and Receipts) when *
      *           deal for a Private Banking Customer                 *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *  186433 - Fix 166888 caused non-default of Ordering bank/     *
      *           customer and Beneficiary when SSIs are amended      *
      *           (after initially defaulted by system) but said      *
      *           fields have been left blank by the user             *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas our Receive/Pay instructions  respectively  not
      *           correctly  updated .  Introduced  new  Data Structure
      *           @MORPI  which is used  for that purpose .           *
      *  CDL008 - Continuous Linked Settlement                        *
      *  166888 - Settlement Instructions - Pay Ordering Bank returns *
      *           to defaulted value all the time. Apply GEMS 163745  *
      *           However, 163745 only fixes the problem for 'A' and  *
      *           'X' processing. Problem still exists for insert.    *
      *           Need to default only the 1st time validation is     *
      *           done. Do not re-default for subsequent validations. *
      *           Due to this 163745 in its original form is no       *
      *           longer required, now default required only for      *
      *           'first time insert'.                                *
      *  180500 - Allow amend to DDRSCY & DDPSCY                      *
      *  CSW200 - Swift 2000 Changes                                  *
      *  CSW097 - Swift 97 Changes for MT340s and MT360s              *
      *  171873 - Message handling improved                           *
      *  161504 - Recompiled over changed ZASETINSDF.                 *
      *  164570 - Initialize FRA/IRS extended instructions if         *
      *           switchable features CSW005/CSW011 are off           *
      *  160419 - Errors in settlement instructions if not X branching*
      *  152344 - Invalid pay/receipt settlement currencies accepted  *
      *  CAP003 - Phase II of Midas API conversions                   *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZASETINSDFCF   E             WORKSTN

     F/COPY WNCPYSRC,ZASETIN#F1
      *                                                                                       171873
      ** Table of field numbers and names                                                     171873
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)                                       171873
      *                                                                                       171873
                                                                                              171873
     FDLRPIFL1  IF   E           K DISK                                                     MD021872
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      ******* 61  Position cursor - receive settlement currency       *         CAP003
      ******* 62  Position cursor - receive settlement method         *         CAP003
      ******* 63  Position cursor - payment settlement currency       *         CAP003
      ******* 64  Position cursor - payment settlement method         *         CAP003
      ******* 65  Protect receipt fields                              *         CAP003
      ******* 66  Protect payment fields                              *         CAP003
      ******* 67  Protect EMU receipt fields                          *         CAP003
      ******* 68  Protect EMU payment fields                          *         CAP003
      *       69  Position Cursor - receive more account              *                       CDL018
      *       70  Position Cursor - pay more account                  *                       CDL018
      *       79  Protect CDL018 fields                               *                       CDL018
      *       81  Position cursor - receive settlement currency       *         CAP003
      *       82  Position cursor - receive settlement method         *         CAP003
      *       83  Position cursor - payment settlement currency       *         CAP003
      *       84  Position cursor - payment settlement method         *         CAP003
      *       85  Protect receipt fields                              *         CAP003
      *       86  Protect payment fields                              *         CAP003
      *       87  Protect EMU receipt fields                          *         CAP003
      *       88  Protect EMU payment fields                          *         CAP003
      *       80  System has multibranching flag set on               *
      *****************************************************************

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

      ** Include the ZA standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      * Added the following /copy members for new message handling.                           171873
     D/COPY ZACPYSRC,ERR_ARRAYS                                                               171873
                                                                                              171873
     D/COPY ZACPYSRC,APICTLARR                                                                171873
                                                                                              171873
     D/COPY ZACPYSRC,FVAL_ARRAY                                                               171873
                                                                                              171873
     D/COPY ZACPYSRC,MSGHNDDCL                                                                171873
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

      * Constant to hold input parameter for AOSVALR0.                                      MD026923
     D PCUSTD          C                   Const('DspCustSettDtls')                         MD026923
                                                                                            MD026923
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D*RER******       S              1    DIM(6)                                             CSW202
     D RER             S              1    DIM(7)                                             CSW202
     D PAR             S              1    DIM(28)
     D FRR             S              1    DIM(22)                              CAP003
     D FNA             S             10    DIM(75)
     D MIA             S              7    DIM(75)
     D UER             S              7    DIM(75) ASCEND
     D*@Z0*****        S              1    DIM(50) CTDATA PERRCD(50)            CAP003
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)            CAP003
     D WFldNameArr     S             10    DIM(75)                                            CRE008

     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      * FILE RECEIVE INSTRUCTIONS

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      * FILE PAYMENT INSTRUCTIONS

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      **FILE*FRA/IRS*INSTRUCTIONS**************************************                       CSW212
      * FILE EXTENDED SETTLEMENT INSTRUCTIONS                                                 CSW212

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      * SCREEN RECEIVE INSTRUCTIONS

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      * SCREEN PAYMENT INSTRUCTIONS

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      **SCREEN*FRA/IRS*INSTRUCTIONS************************************                       CSW212
      * SCREEN EXTENDED SETTLEMENT INSTRUCTIONS                                               CSW212

     D ##RECE        E DS                  EXTNAME(SDESERPD)
      * ERRORS IN RECEIVE INSTRUCTIONS

     D ##PAYE        E DS                  EXTNAME(SDESEPPD)
      * ERRORS IN PAYMENT INSTRUCTIONS

     D ##FRIE        E DS                  EXTNAME(SDESEFPD)
      **ERRORS*IN*FRA/IRS*INSTRUCTIONS*********************************                       CSW212
      * ERRORS IN EXTENDED SETTLEMENT INSTRUCTIONS                                            CSW212

     D RUNDAT          DS            13
     D  DDRUNA                 1      7
     D  @MBIN                 13     13


     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
                                                                                CPB002
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CPB002
      * DATA STRUCTURE FOR CUSTOMER DETAILS                                     CPB002
                                                                                CPB002
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    CPB002
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS                                  CPB002

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                CPB002
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB002
      ** THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE                 CPB002
                                                                                CDL011
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                    CDL011
     D SDNosAcc      E                     EXTFLD(QQACCD)                                     CGL029
      **  External DS for Nostro details                                        CDL011
                                                                                CDL011
     D SDACNT        E DS                  EXTNAME(ACCNTAB)                     CDL011
     D L_CD          E                     EXTFLD(LCD)                          CDL011
      **  External DS for Nostro details                                        CDL011

     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our Receive / Pay  Instructions (for Settl Meth = 04 )                  179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRSTM                          2S 0                                                    186433
     D WPSTM                          2S 0                                                    186433
                                                                                              186433
      ** Parameters for CDL011                                                  CDL011
     D CDL011          S              1A                                        CDL011
                                                                                CDL011
     D PRTCD           S              7A                                        CDL011
     D POPTN           S              7A                                        CDL011
     D PSARD           S              6A                                        CDL011
                                                                                CDL011
     D CSW213          S              1A                                                    MD021872
     D DLNO16          S             16A                                                    MD021872
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
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * Work With Extended Settlement Instructions
      *
     C                   EXSR      WRKSTI
      *
      *  Close down program
      *
     C     @INKC         IFEQ      '1'
     C     @INKK         OREQ      '1'                                                      MD036070
     C                   SETON                                        LR
     C                   END
      *
      *  Errors outstanding
      *
     C     ##ACTN        IFEQ      'I'
     C     ##ACTN        OREQ      'A'
     C     ##ACTN        OREQ      'X'
     C     @IDX          IFNE      *ZERO
     C                   MOVEL     '*ERRORS'     RetCodeIn
     C                   ELSE
      *                                                                                       CIR003
     C     CIR003        IFEQ      'N'                                                        CIR003
     C     CIR003        OREQ      'Y'                                                        CIR003
     C     ##TTYP        ANDNE     'RX'                                                       CIR003
     C                   MOVE      '0'           @INKL
     C                   ENDIF                                                                CIR003
     C                   END
     C                   END
      *
      *  Return
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
      *****************************************************************
      * WRKSTI - Work With Extended Settlement Instructions
      *****************************************************************
     C     WRKSTI        BEGSR
      *                                                                         CAP003
      * Set off roll indicators                                                 CAP003
      *                                                                         CAP003
     C                   MOVE      '0'           *IN07                          CAP003
     C                   MOVE      '0'           *IN08                          CAP003
      *                                                                         160419
      * If not multi-branching use appropriate pay/rec nostros                  160419
      *                                                                         160419
     C     @MBIN         IFNE      'Y'                                          160419
     C                   MOVEL     DDRONX        DDRONS                         160419
     C                   MOVEL     DDPONX        DDPONS                         160419
     C                   ENDIF                                                  160419
      *
      * Validate settlement Instructions if inset, amend or authorize
      *
     C     ##ACTN        IFEQ      'I'
     C     ##ACTN        OREQ      'A'
     C     ##ACTN        OREQ      'X'
      *                                                                                       CDL036
      ** To Prevent Trade input if CLS SSI missing bypass warning message                     CDL036
      ** if CDL036 is ON and use new error message in ZASETINVAL.                             CDL036
     C     CDL036        IFEQ      'N'                                                        CDL036
      *                                                                         CDL008
      ** Display warning message if this is a CLS (FX) transaction and          CDL008
      ** no default settlement instructions have been setup for                 CDL008
      ** receipts and/or payments side                                          CDL008
      *                                                                         CDL008
     C     CDL008        IFEQ      'Y'                                          CDL008
     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
     C     ##TTYP        ANDEQ     'CL'                                         CDL008
     C     ##ACTN        ANDEQ     'I'                                          CDL008
     C     DDPSTM        IFEQ      '00'                                         CDL008
     C     DDRSTM        OREQ      '00'                                         CDL008
     C                   MOVEL     'ESM0300'     ZAMSID                         CDL008
     C                   CALL      'ZA0240'                                     CDL008
     C                   PARM                    ZAMSID                         CDL008
     C                   ENDIF                                                  CDL008
     C                   ENDIF                                                  CDL008
     C                   ENDIF                                                                CDL036
      *                                                                         CDL008
     C                   MOVEL     '1ST'         ##ValIter         3                          166888
     C                   EXSR      VALSTI
     C                   END
      *
      * Write/Read Payment and Receive Screen
      *
     C                   EXSR      WRREPR
      *
      * DO WHILE COMMAND 3 OR COMMAND 12 NOT TAKEN
      *
     C     *INKC         DOWEQ     '0'
     C     *INKK         ANDEQ     '0'                                                      MD036070
     C     *INKL         ANDEQ     '0'
     C     *INKH         ANDEQ     '0'                                                        CIR003
     C     CIR003        OREQ      'Y'                                                        CIR003
     C     *INKH         ANDEQ     '1'                                                        CIR003
     C     @IDX          ANDNE     0                                                          CIR003
     C     ##ACTN        ANDNE     'X'                                                        CIR003
      *                                                                                       CIR003
     C                   MOVE      '0'           *INKH                                        CIR003
      *
      * Validate settlement Instructions if inset, amend or authorize
      *
     C     ##ACTN        IFEQ      'I'
     C     ##ACTN        OREQ      'A'
     C     ##ACTN        OREQ      'X'
     C                   MOVEL     '2ND'         ##ValIter                                    166888
     C                   MOVE      DDRSTM        WRSTM                                        186433
     C                   MOVE      DDPSTM        WPSTM                                        186433
     C**********         IF        WRSTM<>FLRSTM OR DDRONS<>FLRONS OR                  186433 210013
     C**********                   WPSTM<>FLPSTM OR DDPONS<>FLPONS                     186433 210013
     C     WRSTM         IFNE      FLRSTM                                                     210013
     C     DDRONX        ORNE      FLRONS                                                     210013
     C     WPSTM         ORNE      FLPSTM                                                     210013
     C     DDPONX        ORNE      FLPONS                                                     210013
     C                   MOVEL     '1ST'         ##ValIter                                    186433
     C                   ENDIF                                                                186433
     C                   EXSR      VALSTI
     C                   END
      *                                                                         CAP003
      * If rollup, output screen 2                                              CAP003
      *                                                                         CAP003
     C     *IN07         IFEQ      '1'                                          CAP003
     C                   EXSR      WRSCN2                                       CAP003
     C                   ENDIF                                                  CAP003
      *
      * Write/Read Payment and Receive Screen
      * If not processing second screen                                         CAP003
      *
     C     *IN07         IFEQ      '0'                                          CAP003
     C                   EXSR      WRREPR
     C                   END                                                    CAP003
      *                                                                         CAP003
      * If rolldown, set off roll indicators                                    CAP003
      *                                                                         CAP003
     C     *IN08         IFEQ      '1'                                          CAP003
     C                   MOVE      '0'           *IN07                          CAP003
     C                   MOVE      '0'           *IN08                          CAP003
     C                   IF        CSW213  = 'Y'                                            MD029216
     C                   IF        ##CALP = 'CIRS'                                          MD029216
     C                   EVAL      *IN76 = '0'                                              MD029216
     C                   ENDIF                                                              MD029216
     C                   ENDIF                                                              MD029216
     C                   ENDIF                                                  CAP003
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* WRREPR - WRITE/READ PAYMENT AND RECEIVE SCREEN
     C*****************************************************************
     C     WRREPR        BEGSR
      *
     C                   TIME                    DDTIME
      *
     C                   IF        CDL011 = 'Y'                                 CDL011
     C                   EXSR      WRNMEX                                       CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
      ** Display Customer Number if system value = 'N'                                      MD026923
      *                                                                                     MD026923
     C                   IF        WCUSTD = 'N'                                             MD026923
     C                   EXSR      CVTCUS                                                   MD026923
     C                   ENDIF                                                              MD026923
      *                                                                                     MD026923
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   WRITE     #RCDDTL1
      *
     C                   READ      #RCDDTL1                               99
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKK         @INKK                                      MD036070
     C                   MOVE      *INKL         @INKL
      *
      **  Clear screen message queue.
      *
     C                   CALL      'ZA0250'
      *
      * SET OFF POSITION CUSOR INDICATORS
      *
     C**********         MOVEA     '0000'        *IN(61)                        CAP003
     C                   MOVEA     '0000'        *IN(81)                        CAP003
      *
      * SET OFF ERROR INDICATORS
      *
     C                   MOVEA     @Z0           *IN(10)
     C                   MOVEA     '0'           *IN(70)                                      CDL018
     C                   MOVEA     @Z0           ##RECE
     C                   MOVEA     @Z0           ##PAYE
     C                   MOVEA     @Z0           ##FRIE
     C                   MOVEA     *BLANKS       FNA
     C                   MOVEA     *BLANKS       MIA
     C                   MOVEA     *BLANKS       WFldNameArr                                  CRE008
     C                   MOVEA     *BLANKS       WMsgIDArr                                    CRE008
     C                   MOVEA     *BLANKS       WMsgDtaArr                                   CRE008
      *                                                                         160419
      * If not multi-branching use appropriate pay/rec nostros                  160419
      *                                                                         160419
     C     @MBIN         IFNE      'Y'                                          160419
     C                   MOVEL     DDRONS        DDRONX                         160419
     C                   MOVEL     DDPONS        DDPONX                         160419
     C                   ENDIF                                                  160419
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT                                                                    CAP003
     C*****************************************************************         CAP003
     C* WRSCN2 - WRITE/READ SECOND SCREEN FOR MG34n/MG36n MSG GEN               CAP003
     C*****************************************************************         CAP003
     C     WRSCN2        BEGSR                                                  CAP003
      *                                                                         CAP003
     C                   TIME                    DDTIME                         CAP003
      *                                                                         CAP003
     C     DDISDA        IFEQ      '0000'                                                   MD029234
     C                   MOVE      *BLANKS       DDISDA                                     MD029234
     C                   ENDIF                                                              MD029234
      *                                                                                     MD029234
     C     DDAGDT        IFEQ      '000000'                                                 MD029234
     C                   MOVE      *BLANKS       DDAGDT                                     MD029234
     C                   ENDIF                                                              MD029234
      *                                                                                     MD029234
     C     DDAGVV        IFEQ      '0000'                                                   MD029234
     C                   MOVE      *BLANKS       DDAGVV                                     MD029234
     C                   ENDIF                                                              MD029234
      *                                                                                     MD029234
     C                   EVAL      *IN76 = '0'                                              MD029216
     C                   IF        CSW213  = 'Y'                                            MD029216
     C                   EVAL      DLNO16  = ##DLNO                                         MD029216
     C     RPIFKEY       SETLL     DLRPIFL1                                                 MD029216
     C                   IF        %EQUAL(DLRPIFL1)                                         MD029216
     C                   IF        ##CALP = 'CIRS'                                          MD029216
     C                             OR ##CALP = 'FXDL'                                       MD029855
     C                   EVAL      *IN76 = '1'                                              MD029216
     C                   ENDIF                                                              MD029216
     C                   IF        ##CALP = 'SIRS'                                          MD029216
     C                             OR ##CALP = 'FRA'                                        MD029216
     C                   EVAL      *IN76 = '1'                                              MD029216
     C                   ENDIF                                                              MD029216
     C                   ENDIF                                                              MD029216
     C                   ENDIF                                                              MD029216
                                                                                            MD029216
     C                   WRITE     #MSGCTL                                      CAP003
     C                   WRITE     #CMDTXT1                                     CAP003
     C                   WRITE     #HEAD2                                       CAP003
     C                   WRITE     #RCDDTL2                                     CAP003
      *                                                                         CAP003
     C                   READ      #RCDDTL2                               99    CAP003
      *                                                                         CAP003
     C                   MOVE      *INKC         @INKC                          CAP003
     C                   MOVE      *INKK         @INKK                                      MD036070
     C                   MOVE      *INKL         @INKL                          CAP003
      *                                                                         CAP003
      **  Clear screen message queue.                                           CAP003
      *                                                                         CAP003
     C                   CALL      'ZA0250'                                     CAP003
      *                                                                         CAP003
      * SET OFF POSITION CUSOR INDICATORS                                       CAP003
      *                                                                         CAP003
     C                   MOVEA     '0000'        *IN(81)                        CAP003
      *                                                                         CAP003
      * SET OFF ERROR INDICATORS                                                CAP003
      *                                                                         CAP003
     C                   MOVEA     @Z0           *IN(10)                        CAP003
     C                   MOVEA     '0'           *IN(70)                                      CDL018
     C                   MOVEA     @Z0           ##RECE                         CAP003
     C                   MOVEA     @Z0           ##PAYE                         CAP003
     C                   MOVEA     @Z0           ##FRIE                         CAP003
     C                   MOVEA     *BLANKS       FNA                            CAP003
     C                   MOVEA     *BLANKS       MIA                            CAP003
     C                   MOVEA     *BLANKS       WFldNameArr                                  CRE008
     C                   MOVEA     *BLANKS       WMsgIDArr                                    CRE008
     C                   MOVEA     *BLANKS       WMsgDtaArr                                   CRE008
      *                                                                         CAP003
     C                   ENDSR                                                  CAP003
     C*****************************************************************         CAP003
      /EJECT
     C*****************************************************************
     C* VALSTI - Validate Settlement Instructions
     C*****************************************************************
     C     VALSTI        BEGSR
      *
      * Default receive settle ccy to payment settle ccy if:
      * . receive side is protected but payment side is not
      * . transaction is not an FX type transaction
      *
     C******IN67***      IFEQ      '1'                                          CAP003
     C******IN68***      ANDEQ     '0'                                          CAP003
     C     *IN87         IFEQ      '1'                                          CAP003
     C     *IN88         ANDEQ     '0'                                          CAP003
     C     ##CALP        ANDNE     'FXDL'
     C     ##CALP        ANDNE     'CIRS'
     C     ##CALP        ANDNE     'CXSV'                                                     CIR003
     C     ##CALP        ANDNE     'CXSM'                                                     CIR003
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     ##CALP        ORNE      'LEND'                                                     CLE031
     C                   MOVEL     DDPSCY        DDRSCY
     C                   ENDIF                                                                CLE031
     C                   END
      *
      * Default payment settle ccy to receive settle ccy if:
      * . payment side is protected but receive side is not
      * . transaction is not an FX type transaction
      *
     C******IN68***      IFEQ      '1'                                          CAP003
     C******IN67***      ANDEQ     '0'                                          CAP003
     C     *IN88         IFEQ      '1'                                          CAP003
     C     *IN87         ANDEQ     '0'                                          CAP003
     C     ##CALP        ANDNE     'FXDL'
     C     ##CALP        ANDNE     'CIRS'
     C     ##CALP        ANDNE     'CXSV'                                                     CIR003
     C     ##CALP        ANDNE     'CXSM'                                                     CIR003
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     ##CALP        ORNE      'LEND'                                                     CLE031
     C                   MOVEL     DDRSCY        DDPSCY
     C                   ENDIF                                                                CLE031
     C                   END
      *
      ** Validate Settlement Instructions
      *
     C                   CALLB     'ZASETINVAL'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      * Calling program
     C                   PARM                    ##CALP            4
      *
      * Payment currency
     C                   PARM                    ##PCCY            3
      *
      * Receive currency
     C                   PARM                    ##RCCY            3
      *
      * Customer shortname
     C                   PARM                    ##CSNM           10
      *
      * Transaction Type
     C                   PARM                    ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM                    ##FFND            1
      *
      * Booking branch
     C                   PARM                    ##BRCA            3
      *
      * Receipt Date
      * (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATR            5 0
      *
      * Payment Date
      * (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATP            5 0
      *
      * Payment instructions
     C                   PARM                    ##PAYS
      *
      * Receive instructions
     C                   PARM                    ##RECS
      *
      **FRA/IRS*instructions*******************************************                       CSW212
      * Extended Settlement instructions                                                      CSW212
     C                   PARM                    ##FRIS
      *
      * Action Code                                                                           185751
     C                   PARM                    ##ACTN                                       185751
      * Protect Payment Field                                                                 196461
     C                   PARM                    ##PPAY            1                          196461
      * Protect Receipt Field                                                                 196461
     C                   PARM                    ##PREC            1                          196461
      *                                                                                       185751
      * OUTPUTS
      *
      * Errors in Payment instructions
     C                   PARM                    ##PAYE
      *
      * Errors in Receive instructions
     C                   PARM                    ##RECE
      *
      **Errors*in*FRA/IRS*instructions*********************************                       CSW212
      * Errors in Extended Settlement instructions                                            CSW212
     C                   PARM                    ##FRIE
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FNA
     C                   PARM                    MIA
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         @IDX              3 0
                                                                                              CRE008
      ** Warning Messages                                                                     CRE008
     C                   PARM                    WFldNameArr                                  CRE008
     C                   PARM                    WMsgIdArr                                    CRE008
     C                   PARM                    WMsgDtaArr                                   CRE008
     C                   PARM                    WIdx              3 0                        CRE008
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      **FRA/IRS*instructions*******************************************                       CSW212
      * Extended Settlement instructions                                                      CSW212
     C                   PARM                    ##FRIF
      ** Extra Input                                                                          166888
      ** Action Code used                                                                     166888
     C                   PARM                    ##ACTN                                       166888
      ** Validation Iteration                                                                 166888
     C                   PARM                    ##ValIter                                    166888
      ************                                                                     179510 200400
      **Midas*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      ************                                                                     179510 200400
     C/COPY WNCPYSRC,ZASETIN#C1
      *
      *  If settlement instructions not valid output error message
      *
     C                   MOVEA     MIA           UER
     C                   Z-ADD     1             Z                 2 0
     C     *BLANK        LOOKUP    UER(Z)                             99        *
     C     *IN99         IFEQ      '1'
      *
      ** SET ON RECEIVE ERROR INDICATORS
      *
     C                   MOVEA     ##RECE        RER
     C                   Z-ADD     1             CN                2 0
     C     *IN96         DOUEQ     '0'
     C     'N'           LOOKUP    RER(CN)                                96    *
     C   96              MOVEL     '1'           RER(CN)
     C                   END
     C                   MOVEA     RER           *IN(11)
      *                                                                                       CDL018
     C     @@RMAC        IFEQ      'N'                                                        CDL018
     C                   MOVE      '1'           *IN69                                        CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CLE031
     C     @@REXR        IFEQ      'N'                                                        CLE031
     C     @@REXI        OREQ      'N'                                                        CLE031
     C                   MOVE      '1'           *IN11                                        CLE031
     C                   ENDIF                                                                CLE031
      *
      ** SET ON PAYMENT ERROR INDICATORS
      *
     C                   MOVEA     ##PAYE        PAR
     C                   Z-ADD     1             CN                2 0
     C     *IN96         DOUEQ     '0'
     C     'N'           LOOKUP    PAR(CN)                                96    *
     C   96              MOVEL     '1'           PAR(CN)
     C                   END
     C                   MOVEA     PAR           *IN(18)
      *                                                                                       CDL018
     C     @@PMAC        IFEQ      'N'                                                        CDL018
     C                   MOVE      '1'           *IN70                                        CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CLE031
     C     @@PEXR        IFEQ      'N'                                                        CLE031
     C     @@PEXI        OREQ      'N'                                                        CLE031
     C                   MOVE      '1'           *IN18                                        CLE031
     C                   ENDIF                                                                CLE031
      *                                                                         CAP003
      ** SET ON FRA/IRS ERROR INDICATORS                                        CAP003
      *                                                                         CAP003
     C                   MOVEA     ##FRIE        FRR                            CAP003
     C                   Z-ADD     1             CN                2 0          CAP003
     C     *IN96         DOUEQ     '0'                                          CAP003
     C     'N'           LOOKUP    FRR(CN)                                96    CAP003
     C   96              MOVEL     '1'           FRR(CN)                        CAP003
     C                   END                                                    CAP003
     C                   MOVEA     FRR           *IN(45)                        CAP003
     C/COPY WNCPYSRC,ZASETIN#C2
     C/COPY ZACPYSRC,MSGHNDDSP1                                                               171873
     C/COPY WNCPYSRC,ZASETIN#C8
      *
      *  DO WHILE error codes returned remain to be processed
      *
     C     Z             DOWLT     51
     C     UER(Z)        ANDNE     *BLANKS
     C                   MOVEL     UER(Z)        @WERR             7
     C                   EXSR      ERROR
     C                   ADD       1             Z
     C                   END
     C/COPY WNCPYSRC,ZASETIN#C3
      *
      *  Position cursor on receive/payment currency and method
      *
     C                   SELECT
     C******IN67***      WHENEQ    '0'                                          CAP003
     C     *IN87         WHENEQ    '0'                                          CAP003
     C     *IN11         ANDEQ     '1'
     C*************      MOVE      '1'           *IN61                          CAP003
     C******IN65***      WHENEQ    '0'                                          CAP003
     C                   MOVE      '1'           *IN81                          CAP003
     C     *IN85         WHENEQ    '0'                                          CAP003
     C     *IN12         ANDEQ     '1'
     C*************      MOVE      '1'           *IN62                          CAP003
     C******IN68***      WHENEQ    '0'                                          CAP003
     C                   MOVE      '1'           *IN82                          CAP003
     C     *IN88         WHENEQ    '0'                                          CAP003
     C     *IN18         ANDEQ     '1'
     C*************      MOVE      '1'           *IN63                          CAP003
     C******IN66***      WHENEQ    '0'                                          CAP003
     C                   MOVE      '1'           *IN83                          CAP003
     C     *IN86         WHENEQ    '0'                                          CAP003
     C     *IN19         ANDEQ     '1'
     C*************      MOVE      '1'           *IN64                          CAP003
     C                   MOVE      '1'           *IN84                          CAP003
     C                   ENDSL
      *
     C                   ELSE
                                                                                              CRE008
      ** Send Warning Messages                                                                CRE008
                                                                                              CRE008
     C                   EVAL      Z = 1                                                      CRE008
                                                                                              CRE008
     C                   DOW       Z < 76 and WMsgIdArr(Z) <> *Blanks                         CRE008
     C                   EVAL      ZAMsgID = WMsgIdArr(Z)                                     CRE008
     C                   EVAL      ZAMsgDta = WMsgDtaArr(Z)                                   CRE008
     C                   EXSR      SRWarnMsg                                                  CRE008
     C                   ADD       1             Z                                            CRE008
     C                   END                                                                  CRE008
      *
      *  Position cursor on first input enabled field
      *
     C                   SELECT
     C******IN67***      WHENEQ    '0'                                          CAP003
     C*************      MOVE      '1'           *IN61                          CAP003
     C******IN65***      WHENEQ    '0'                                          CAP003
     C*************      MOVE      '1'           *IN62                          CAP003
     C******IN68***      WHENEQ    '0'                                          CAP003
     C*************      MOVE      '1'           *IN63                          CAP003
     C******IN66***      WHENEQ    '0'                                          CAP003
     C*************      MOVE      '1'           *IN64                          CAP003
     C     *IN87         WHENEQ    '0'                                          CAP003
     C                   MOVE      '1'           *IN81                          CAP003
     C     *IN85         WHENEQ    '0'                                          CAP003
     C                   MOVE      '1'           *IN82                          CAP003
     C     *IN88         WHENEQ    '0'                                          CAP003
     C                   MOVE      '1'           *IN83                          CAP003
     C     *IN86         WHENEQ    '0'                                          CAP003
     C                   MOVE      '1'           *IN84                          CAP003
     C                   ENDSL
      *
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C     ##TTYP        ANDEQ     'RX'                                                       CIR003
     C                   MOVEL     'ESM0807'     ZAMSID                                       CIR003
     C                   ELSE                                                                 CIR003
      *
      *  Display message "Validation Complete - Press F12 to Return"
      *
     C                   MOVEL     'ESM0800'     ZAMSID
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID
     C                   MOVEL     *BLANK        ZAMSID
     C/COPY WNCPYSRC,ZASETIN#C4
     C                   END
      *                                                                                       CSW214
      ** Display warning messages                                                             CSW214
      *                                                                                       CSW214
     C     *BLANK        LOOKUP    WMsgIdArr(Z)                           99                  CSW214
     C                   IF        *IN99 = '1'                                                CSW214
      *                                                                                       CSW214
      ** DO WHILE error codes returned remain to be processed - warning                       CSW214
      *                                                                                       CSW214
     C                   Z-ADD     1             Z                                            CSW214
     C     Z             DOWLT     75                                                         CSW214
      *                                                                                       CSW214
     C     WMsgIdArr(Z)  IFNE      *BLANKS                                                    CSW214
     C                   MOVEL     WMsgIdArr(Z)  @WERR                                        CSW214
     C                   EXSR      ERROR                                                      CSW214
     C                   ADD       1             Z                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   LEAVE                                                                CSW214
     C                   ENDIF                                                                CSW214
      *                                                                                       CSW214
     C                   ENDDO                                                                CSW214
      *                                                                                       CSW214
     C                   ENDIF                                                                CSW214
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************                       CRE008
      *                                                               *                       CRE008
      * SRWarnMsg - Call Program ZA0350 to send Warning Messages      *                       CRE008
      *                                                               *                       CRE008
      *****************************************************************                       CRE008
     C     SRWarnMsg     BEGSR                                                                CRE008
                                                                                              CRE008
     C                   CALL      'ZA0350'                                                   CRE008
     C                   PARM      'DRSMM'       ZAMsgFile        10                          CRE008
     C                   PARM                    ZAMsgId          10                          CRE008
     C                   PARM                    ZAMsgDta         45                          CRE008
                                                                                              CRE008
     C                   EVAL      ZAMsgId = *Blanks                                          CRE008
     C                   EVAL      ZAMsgDta = *Blanks                                         CRE008
                                                                                              CRE008
     C                   ENDSR                                                                CRE008
      *****************************************************************                       CRE008
      /EJECT                                                                                  CRE008
     C/COPY WNCPYSRC,ZASETIN#C5
     C*****************************************************************
      * ERROR    - CALL PROGRAM ZA0240 TO OUTPUT ERROR MESSAGES       *
     C*****************************************************************
     C     ERROR         BEGSR
     C*
     C*  Display error message
     C*
     C                   MOVEL     *BLANK        ZAMSID           10
     C                   MOVEL     @WERR         ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID
     C*
     C                   ENDSR
     C/COPY WNCPYSRC,ZASETIN#C6
     C********************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVEL     *BLANK        RetCodeIn
     C                   CLEAR                   ##PAYF
     C                   CLEAR                   ##RECF
     C                   CLEAR                   ##FRIF
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKK                                      MD036070
     C                   MOVE      '0'           @INKL
      *
      * DEAL NUMBER
      *
     C                   MOVEL     ##DLNO        DDDLNO
      *                                                                                       CIR003
      ** Set up Event Code                                                                    CIR003
      *                                                                                       CIR003
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C                   MOVE      *BLANKS       DDEVCD                                       CIR003
     C                   MOVE      '0'           *IN75                                        CIR003
     C                   MOVE      '0'           *IN78                                      MD029216
      *                                                                                       CIR003
     C     ##TTYP        IFEQ      'RX'                                                       CIR003
     C                   MOVE      '1'           *IN75                                        CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     ##CALP        IFEQ      'CXSV'                                                     CIR003
     C                   MOVE      'VALUE'       DDEVCD                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     ##CALP        IFEQ      'CXSM'                                                     CIR003
     C                   MOVE      'MATURITY'    DDEVCD                                       CIR003
     C                   MOVE      '1'           *IN78                                      MD029216
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     ##CALP        IFEQ      'CIRS'                                                     CIR003
     C                   MOVE      'INTEREST'    DDEVCD                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     CSW005        IFEQ      'Y'                                                        CIR003
      *                                                                                       CIR003
     C     ##CALP        IFEQ      'CIRS'                                                     CIR003
     C                   MOVE      '1'           *IN09                                        CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     ##CALP        IFEQ      'CXSV'                                                     CIR003
     C     ##CALP        OREQ      'CXSM'                                                     CIR003
     C                   MOVE      '0'           *IN09                                        CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *
      * SET SCREEN CONDITIONING INDICATORS
      *
     C                   EXSR      SETSCNIND
      *
      ** Set rollup indicator if FRA or IRS                                                AR1015982
      ** and FRA/IRS extended settlement instruction features are on.                      AR1015982
      *                                                                                    AR1015982
     C                   MOVE      '0'           *IN09                                     AR1015982
     C     ##CALP        IFEQ      'FRA '                                                  AR1015982
     C     ##CALP        OREQ      'SIRS'                                                  AR1015982
     C     ##CALP        OREQ      'CIRS'                                                  AR1015982
     C     ##CALP        OREQ      'FXDL'                                                  AR1015982
     C     CSW212        ANDEQ     'Y'                                                     AR1015982
                                                                                           AR1015982
     C*****##CALP        IFEQ      'FRA '                                         AR1015982 MD029217
     C*****CSW005        ANDEQ     'Y'                                            AR1015982 MD029217
     C     CSW005        IFEQ      'Y'                                                      MD029217
     C     ##CALP        OREQ      'FRA '                                                  AR1015982
     C     CSW011        ANDEQ     'Y'                                                     AR1015982
     C     ##CALP        OREQ      'FXDL'                                                  AR1015982
     C     CSW212        ANDEQ     'Y'                                                     AR1015982
     C                   MOVE      '1'           *IN09                                     AR1015982
     C                   ENDIF                                                             AR1015982
                                                                                           AR1015982
     C                   ENDIF                                                             AR1015982
                                                                                           AR1015982
      ** Enable CSW212-specific screen narrative                                           AR1015982
      **  ('Cover Message' and 'Confirmation')                                             AR1015982
                                                                                           AR1015982
     C                   MOVE      '1'           *IN72                                     AR1015982
     C                   MOVE      '0'           *IN73                                     AR1015982
                                                                                           AR1015982
     C     ##CALP        IFEQ      'FXDL'                                                  AR1015982
     C     CSW212        ANDEQ     'Y'                                                     AR1015982
     C                   MOVE      '0'           *IN72                                     AR1015982
     C                   MOVE      '1'           *IN73                                     AR1015982
     C                   ENDIF                                                             AR1015982
                                                                                           AR1015982
     C                   EVAL      *IN76 = '0'                                              MD021872
     C                   IF        CSW213  = 'Y'                                            MD021872
     C                   EVAL      DLNO16  = ##DLNO                                         MD021872
     C     RPIFKEY       SETLL     DLRPIFL1                                                 MD021872
     C                   IF        %EQUAL(DLRPIFL1)                                         MD021872
     C                   IF        ##CALP <> 'CXSV'                                         MD029216
     C                             AND ##CALP <> 'CIRS'                                     MD029216
     C                   EVAL      *IN76 = '1'                                              MD021872
     C                   ENDIF                                                              MD029216
     C                   IF        ##CALP = 'CXSM'                                          MD029216
     C                   EVAL      *IN75 = '0'                                              MD029216
     C                   ENDIF                                                              MD029216
     C                   ENDIF                                                              MD021872
     C                   ENDIF                                                              MD021872
                                                                                            MD021872
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * SETSCNIND - SET SCREEN CONDITIONING INDICATORS
      *****************************************************************
     C     SETSCNIND     BEGSR
      *
      * Reset screen 'protect' indicators
      *
     C**********         MOVEL     '0'           *IN65                          CAP003
     C**********         MOVEL     '0'           *IN66                          CAP003
     C**********         MOVEL     '0'           *IN67                          CAP003
     C**********         MOVEL     '0'           *IN68                          CAP003
     C                   MOVEL     '0'           *IN85                          CAP003
     C                   MOVEL     '0'           *IN86                          CAP003
     C                   MOVEL     '0'           *IN87                          CAP003
     C                   MOVEL     '0'           *IN88                          CAP003
     C                   MOVEL     '0'           *IN89                          CAP003
     C                   MOVEL     '0'           *IN79                                        CDL018
      *
      *  If action code is not insert or amend, protect all fields
      *
     C     ##ACTN        IFNE      'I'
     C     ##ACTN        ANDNE     'A'
     C**********         MOVEL     '1'           *IN65                          CAP003
     C**********         MOVEL     '1'           *IN66                          CAP003
     C**********         MOVEL     '1'           *IN67                          CAP003
     C**********         MOVEL     '1'           *IN68                          CAP003
     C                   MOVEL     '1'           *IN85                          CAP003
     C                   MOVEL     '1'           *IN86                          CAP003
     C                   MOVEL     '1'           *IN89                          CAP003
     C                   MOVEL     '1'           *IN87                          180500
     C                   MOVEL     '1'           *IN88                          180500
     C                   END
      *
      * If EMU Settlement Currency feature is on
      *
     C     CEU003        IFEQ      'Y'
      *
      * Get receive currency 'in' currency ind
      *
     C     ##RCCY        IFNE      *BLANK
     C                   MOVEL     ##RCCY        @CURR
     C                   EXSR      GETCCYDET
     C                   MOVEL     A6INCY        #RINCY            1
     C                   ELSE
     C                   MOVEL     *BLANK        #RINCY
     C                   END
      *
      * Get payment currency 'in' currency ind
      *
     C     ##PCCY        IFNE      *BLANK
     C                   MOVEL     ##PCCY        @CURR
     C                   EXSR      GETCCYDET
     C                   MOVEL     A6INCY        #PINCY            1
     C                   ELSE
     C                   MOVEL     *BLANK        #PINCY
     C                   END
     C                   END
      *
      *  Set indicator to protect receipt instructions if:
      *  . EMU switchable feature not installed
      *  . If calling function is Deal Amendments input
      *  . If calling function is NAs Sold input
      *  . If EMU installed & Rec currency is not an 'in' currency or Euros
      *
     C     ##PREC        IFEQ      'Y'
     C     CEU003        IFNE      'Y'
     C     ##CALP        OREQ      'DEAM'
     C     ##CALP        OREQ      'NASS'
     C     CEU003        OREQ      'Y'
     C     #RINCY        ANDNE     'Y'
     C     ##RCCY        ANDNE     BKEURO
     C**********         MOVEL     '1'           *IN65                          CAP003
     C                   MOVEL     '1'           *IN85                          CAP003
     C                   END
     C                   END
      *
      *  Set indicator to protect payment instructions if:
      *  . EMU switchable feature not installed
      *  . If calling function is Deal Amendments input
      *  . If calling function is NAs Sold input
      *  . If EMU installed & Pay currency is not an 'in' currency or Euros
      *
     C     ##PPAY        IFEQ      'Y'
     C     CEU003        IFNE      'Y'
     C     ##CALP        OREQ      'DEAM'
     C     ##CALP        OREQ      'NASS'
     C     CEU003        OREQ      'Y'
     C     #PINCY        ANDNE     'Y'
     C     ##PCCY        ANDNE     BKEURO
     C**********         MOVEL     '1'           *IN66                          CAP003
     C                   MOVEL     '1'           *IN86                          CAP003
     C                   END
     C                   END
      *
      *  Protect EMU receipt settlement currency if:
      *  . EMU switchable feature not installed
      *  . If EMU installed & Rec currency is not an 'in' currency or Euros
      *  . Receipt settlement details are protected
      *
     C     CEU003        IFNE      'Y'
     C     CEU003        OREQ      'Y'
     C     #RINCY        ANDNE     'Y'
     C     ##RCCY        ANDNE     BKEURO
     C*****##CALP        ANDNE     'FXDL'                                              152344 201096
     C     *IN85         OREQ      '1'                                                        201096
     C******IN65         OREQ      '1'                                          CAP003
     C**********         MOVEL     '1'           *IN67                          CAP003
     C                   MOVEL     '1'           *IN87                          CAP003
     C                   END
      *
      *  Protect EMU payment settlement currency if:
      *  . EMU switchable feature not installed
      *  . If EMU installed & Pay currency is not an 'in' currency or Euros
      *  . Payment settlement details are protected
      *
     C     CEU003        IFNE      'Y'
     C     CEU003        OREQ      'Y'
     C     #PINCY        ANDNE     'Y'
     C     ##PCCY        ANDNE     BKEURO
     C*****##CALP        ANDNE     'FXDL'                                              152344 201096
     C     *IN86         OREQ      '1'                                                        201096
      **********                                                                CAP003
     C******IN66         OREQ      '1'                                          CAP003
     C**********         MOVEL     '1'           *IN68                          CAP003
     C                   MOVEL     '1'           *IN88                          CAP003
     C                   END
      *                                                                         CAP003
      * If settlement fields are protected, then protect EMU fields             CAP003
      *                                                                         CAP003
     C     *IN85         IFEQ      '1'                                          CAP003
     C     *IN86         OREQ      '1'                                          CAP003
     C                   MOVEL     '1'           *IN89                          CAP003
     C                   END                                                    CAP003
      *                                                                         CPB002
      ** IF PRIVATE BANKING MODULE SWITCHED ON                                  CPB002
      *                                                                         CPB002
     C     BGN4ST        IFEQ      'Y'                                          CPB002
      *                                                                         CPB002
      ** CHECK FOR CUSTOMER NUMBER OR SHORTNAME                                 CPB002
      *                                                                         CPB002
     C                   MOVE      *BLANKS       @KEY1            10            CPB002
     C                   MOVEL     ##CSNM        @KEY1                          CPB002
     C                   CALL      'AOCUSTR1'                                   CPB002
     C                   PARM      *BLANKS       @RTCD                          CPB002
     C                   PARM      '*KEY   '     @OPTN                          CPB002
     C                   PARM                    @KEY1                          CPB002
     C                   PARM      *BLANKS       @KYST             7            CPB002
     C     SDCUST        PARM      *BLANKS       DSLDY                          CPB002
      *                                                                         CPB002
     C     BBPRBA        IFEQ      'Y'                                          CPB002
     C                   MOVEL     '1'           *IN87                          CPB002
     C                   MOVEL     '1'           *IN88                          CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
     C                   ENDIF                                                  CPB002
      *                                                                                       CDL018
      *  Set indicator to protect CDL018 fields if:                                           CDL018
      *  . Multiple Settlement Accounts not installed                                         CDL018
      *  . If calling function is not Loans/Deposits input                                    CDL018
      *  . If Deal types are not IT, IP, TD or TI                                             CDL018
     C     CDL018        IFNE      'Y'                                                        CDL018
     C                   MOVE      '1'           *IN79                                        CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C     CDL018        IFEQ      'Y'                                                        CDL018
      *                                                                                       CDL018
     C     ##CALP        IFNE      'LDNI'                                                     CDL018
     C                   MOVE      '1'           *IN79                                        CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C     ##CALP        IFEQ      'LDNI'                                                     CDL018
     C     ##CALP        OREQ      'DEAM'                                                     CDL018
     C     ##TTYP        IFNE      'IT'                                                       CDL018
     C     ##TTYP        ANDNE     'IP'                                                       CDL018
     C     ##TTYP        ANDNE     'TD'                                                       CDL018
     C     ##TTYP        ANDNE     'TI'                                                       CDL018
     C                   MOVE      '1'           *IN79                                        CDL018
     C                   ENDIF                                                                CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CLE031
      ** Set indicator to protect CLE031 fields if:                                           CLE031
      ** . Settlement Currency not installed                                                  CLE031
      ** . If calling function is not Lending                                                 CLE031
      *                                                                                       CLE031
     C                   SETOFF                                       71                      CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
     C                   SETON                                        71                      CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * GETCCYDET - Get currency details                              *
      *****************************************************************
     C     GETCCYDET     BEGSR
      *
      **  Access Currency Details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '800'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END

     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Parameters passed into the program
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Action code
     C                   PARM                    ##ACTN            1
      *
      * Deal number
     C                   PARM                    ##DLNO            6
      *
      * Protect Payment
     C                   PARM                    ##PPAY            1
      *
      * Protect Receive
     C                   PARM                    ##PREC            1
      *
      * Calling program
     C                   PARM                    ##CALP            4
      *
      * Payment currency
     C                   PARM                    ##PCCY            3
      *
      * Receive currency
     C                   PARM                    ##RCCY            3
      *
      * Customer shortname
     C                   PARM                    ##CSNM           10
      *
      * Transaction Type
     C                   PARM                    ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM                    ##FFND            1
      *
      * Booking branch
     C                   PARM                    ##BRCA            3
      *
      * Receipt Date
      * (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATR            5 0
      *
      * Payment Date
      * (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATP            5 0
      *
      * Payment instructions
     C                   PARM                    ##PAYS
      *
      * Receive instructions
     C                   PARM                    ##RECS
      *
      **FRA/IRS*instructions*******************************************                       CSW212
      * Extended Settlememt instructions                                                      CSW212
     C                   PARM                    ##FRIS
      *
      * OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      **FRA/IRS*instructions*******************************************                       CSW212
      * Extended Settlememt instructions                                                      CSW212
     C                   PARM                    ##FRIF
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKK             1                        MD036070
     C                   PARM                    @INKL             1
      ************                                                                     179510 200400
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      *                                                                                     MD021872
     C     RPIFKEY       KLIST                                                              MD021872
     C                   KFLD                    ##TTYP                                     MD021872
     C                   KFLD                    DLNO16                                     MD021872
      *
      **  Run date in DDMMMYY
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** If system is multibranched set on *in for display file use
      *
     C     @MBIN         COMP      'Y'                                    80    *
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                         CPB002
      ** GET MODULE DETAILS                                                     CPB002
      *                                                                         CPB002
     C                   CALLB     'AOMMODR0'                                   CPB002
     C                   PARM      *BLANKS       @RTCD                          CPB002
     C                   PARM      '*FIRST'      @OPTN                          CPB002
     C     SDMMOD        PARM      SDMMOD        DSFDY                          CPB002
      *                                                                         CPB002
      * DATABASE ERROR                                                          CPB002
      *                                                                         CPB002
     C     @RTCD         IFNE      *BLANK                                       CPB002
     C                   MOVEL     @OPTN         DBKEY                          CPB002
     C                   MOVEL     'SDMMODPD'    DBFILE                         CPB002
     C                   MOVEL     '901'         DBASE                          CPB002
     C                   EXSR      *PSSR                                        CPB002
     C                   END                                                    CPB002
      *
      ** ACCESS SAR DETAILS FILE
      ** (DATABASE ERROR HANDLING DONE IN ACCESS PROGRAM)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY '    @OPTN             7
     C                   PARM      'CEU003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** EMU Dealing Settlement Currency Conversion
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU003            1
     C                   ENDIF
      *                                                                         CAP003
      ** Access SAR Details file for Msg Gen feature                            CAP003
      *                                                                         CAP003
     C                   CALLB     'AOSARDR0'                                   CAP003
     C                   PARM      *BLANKS       @RTCD             7            CAP003
     C                   PARM      '*VERIFY '    @OPTN             7            CAP003
     C                   PARM      'CSW005'      @SARD             6            CAP003
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP003
      *                                                                         CAP003
      ** Message generation feature for extended settlements                    CAP003
      *                                                                         CAP003
     C     @RTCD         IFEQ      *BLANKS                                      CAP003
     C                   MOVE      'Y'           CSW005            1            CAP003
     C                   ENDIF                                                  CAP003
      *                                                                         164570
      ** Access SAR Details file for FRA Msg Gen feature                        164570
      *                                                                         164570
     C                   CALLB     'AOSARDR0'                                   164570
     C                   PARM      *BLANKS       @RTCD             7            164570
     C                   PARM      '*VERIFY '    @OPTN             7            164570
     C                   PARM      'CSW011'      @SARD             6            164570
     C     SCSARD        PARM      SCSARD        DSFDY                          164570
      *                                                                         164570
      ** Message generation feature for extended settlements                    164570
      *                                                                         164570
     C     @RTCD         IFEQ      *BLANKS                                      164570
     C                   MOVE      'Y'           CSW011            1            164570
     C                   ENDIF                                                  164570
      *                                                                         CDL008
      ** Check if switchable feature CDL008 is switched on                      CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY '    @OPTN                          CDL008
     C                   PARM      'CDL008'      @SARD                          CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
      *                                                                         CDL008
     C     @RTCD         IFNE      *BLANK                                       CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C                   MOVEL     @SARD         DBKEY                          CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '001'         DBASE                          CDL008
     C                   EXSR      *PSSR                                        CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C     @RTCD         IFEQ      *BLANKS                                      CDL008
     C                   MOVE      'Y'           CDL008            1            CDL008
     C                   ELSE                                                   CDL008
     C                   MOVE      'N'           CDL008                         CDL008
     C                   ENDIF                                                  CDL008
      *                                                                                       CIR003
      ** Check if switchable feature CIR003 is switched on                                    CIR003
      *                                                                                       CIR003
     C                   CALLB     'AOSARDR0'                                                 CIR003
     C                   PARM      *BLANKS       @RTCD                                        CIR003
     C                   PARM      '*VERIFY '    @OPTN                                        CIR003
     C                   PARM      'CIR003'      @SARD                                        CIR003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR003
      *                                                                                       CIR003
     C     @RTCD         IFNE      *BLANK                                                     CIR003
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR003
     C                   MOVEL     @SARD         DBKEY                                        CIR003
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR003
     C                   MOVEL     '002'         DBASE                                        CIR003
     C                   EXSR      *PSSR                                                      CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     @RTCD         IFEQ      *BLANKS                                                    CIR003
     C                   MOVE      'Y'           CIR003            1                          CIR003
     C                   ELSE                                                                 CIR003
     C                   MOVE      'N'           CIR003                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                         CDL011
      ** Check if switchable feature CDL011 is switched on                      CDL011
      *                                                                         CDL011
     C                   EVAL      CDL011 = 'N'                                 CDL011
     C                   CALLB     'AOSARDR0'                                   CDL011
     C                   PARM      *Blanks       PRTCD                          CDL011
     C                   PARM      '*VERIFY'     POPTN                          CDL011
     C                   PARM      'CDL011'      PSARD                          CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL011
                                                                                CDL011
     C                   IF        PRTCD = *Blanks                              CDL011
     C                   EVAL      CDL011 = 'Y'                                 CDL011
     C                   ENDIF                                                  CDL011
                                                                                CDL011
      ** Access SAR details file to determine if CDL018 is switched on                        CDL018
      ** (Multiple Settlement Accounts on Loans/Deposit)                                      CDL018
                                                                                              CDL018
     C                   CallB     'AOSARDR0'                                                 CDL018
     C                   Parm      *Blanks       PRTCD                                        CDL018
     C                   Parm      '*VERIFY'     POPTN                                        CDL018
     C                   Parm      'CDL018'      PSARD                                        CDL018
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL018
      *                                                                                       CDL018
     C                   Move      'N'           CDL018            1                          CDL018
     C                   If        PRTCD = *Blanks                                            CDL018
     C                   Eval      CDL018 = 'Y'                                               CDL018
     C                   Endif                                                                CDL018
      *                                                                         CSW200
      ** Access SAR details file to determine if CDL036 is switched on                        CDL036
      ** (CLS Enhancement 2)                                                                  CDL036
     C                   CallB     'AOSARDR0'                                                 CDL036
     C                   Parm      *Blanks       PRTCD                                        CDL036
     C                   Parm      '*VERIFY'     POPTN                                        CDL036
     C                   Parm      'CDL036'      PSARD                                        CDL036
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL036
      *                                                                                       CDL036
     C                   Move      'N'           CDL036            1                          CDL036
     C                   If        PRTCD = *Blanks                                            CDL036
     C                   Eval      CDL036 = 'Y'                                               CDL036
     C                   Endif                                                                CDL036
      *                                                                                       CLE031
      ** Access SAR details file to determine if CLE031 is switched on                        CLE031
      ** (Settlement Currency and Exchange Rate)                                              CLE031
      *                                                                                       CLE031
     C                   CallB     'AOSARDR0'                                                 CLE031
     C                   Parm      *Blanks       PRTCD                                        CLE031
     C                   Parm      '*VERIFY'     POPTN                                        CLE031
     C                   Parm      'CLE031'      PSARD                                        CLE031
     C     SCSARD        Parm      SCSARD        DSFDY                                        CLE031
      *                                                                                       CLE031
     C                   Move      'N'           CLE031            1                          CLE031
     C                   If        PRTCD = *Blanks                                            CLE031
     C                   Eval      CLE031 = 'Y'                                               CLE031
     C                   Endif                                                                CLE031
      *                                                                                       CDL094
      * Check if enhanced receive settlement instruction feature is ON                        CDL094
     C                   Move      'N'           CDL094            1                          CDL094
     C                   CallB     'AOSARDR0'                                                 CDL094
     C                   Parm      *Blanks       PRTCD                                        CDL094
     C                   Parm      '*VERIFY'     POPTN                                        CDL094
     C                   Parm      'CDL094'      PSARD                                        CDL094
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL094
      *                                                                                       CDL094
     C                   If        PRTCD = *Blanks                                            CDL094
     C                   IF        ##CALP = 'LDNI'                                            CDL094
     C                             OR ##CALP = 'FXDL'                                         CDL094
     C                   SETON                                        67                      CDL094
     C                   ENDIF                                                                CDL094
     C                   ENDIF                                                                CDL094
     C**********         DUMP                                                        CDL094 MD036631
      *                                                                                       CDL094
      *                                                                         CSW200
     C** Check if SWIFT 2000 Changes is on.                                     CSW200
      *                                                                         CSW200
     C                   CALL      'SWIF2000'                                   CSW200
     C                   PARM      *BLANKS       @RTCD                          CSW200
      *                                                                         CSW200
     C                   MOVEL     'N'           CSW200            1            CSW200
     C     @RTCD         IFEQ      'CSW200'                                     CSW200
     C                   MOVEL     'Y'           CSW200            1            CSW200
     C                   ENDIF                                                  CSW200
      *                                                                                       CSW212
      ** Check if SWIFT 2012  is on                                                           CSW212
      *                                                                                       CSW212
     C                   CALL      'SWIF2012'                                                 CSW212
     C                   PARM      *BLANKS       @RTCD                                        CSW212
      *                                                                                       CSW212
     C     @RTCD         IFEQ      'CSW2012'                                                  CSW212
     C                   MOVEL     'Y'           CSW212            1                          CSW212
     C                   ELSE                                                                 CSW212
     C                   MOVEL     'N'           CSW212                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                         164570
      ** Set rollup indicator if FRA or IRS                                     164570
      ** and FRA/IRS extended settlement instruction features are on.           164570
      *                                                                         164570
     C     ##CALP        IFEQ      'FRA '                                       164570
     C     ##CALP        OREQ      'SIRS'                                       164570
     C     ##CALP        OREQ      'CIRS'                                       164570
     C     ##CALP        OREQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C     CSW005        IFEQ      'Y'                                          164570
     C     CSW011        OREQ      'Y'                                          164570
     C     ##CALP        ANDEQ     'FRA '                                       164570
     C     ##CALP        OREQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C                   MOVE      '1'           *IN09                          164570
     C                   ENDIF                                                  164570
     C                   ENDIF                                                  164570
      *                                                                         164570
      ** Set field protection indicator if FRA                                  164570
      ** and CSW005 is on                                                       CSW097
      *                                                                         164570
     C     ##CALP        IFEQ      'FRA '                                       164570
     C     CSW005        ANDNE     'Y'                                          CSW097
     C     CSW011        ANDNE     'Y'                                          CSW200
     C     ##CALP        OREQ      'FRA'                                        CSW200
     C     CSW005        ANDNE     'Y'                                          CSW200
     C     CSW200        ANDNE     'Y'                                          CSW200
     C                   MOVE      '1'           *IN04                          164570
     C                   ENDIF                                                  164570
      *                                                                                       CSW212
      ** Enable CSW212-specific screen narrative                                              CSW212
      **  ('Cover Message' and 'Confirmation')                                                CSW212
      *                                                                                       CSW212
     C**********         MOVE      '1'           *IN70                              CSW212 AR1010565
     C**********         MOVE      '0'           *IN71                              CSW212 AR1010565
     C                   MOVE      '1'           *IN72                                     AR1010565
     C                   MOVE      '0'           *IN73                                     AR1010565
      *                                                                                       CSW212
     C     ##CALP        IFEQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C**********         MOVE      '0'           *IN70                              CSW212 AR1010565
     C**********         MOVE      '1'           *IN71                              CSW212 AR1010565
     C                   MOVE      '0'           *IN72                                     AR1010565
     C                   MOVE      '1'           *IN73                                     AR1010565
     C                   ENDIF                                                                CSW212
      *                                                                         CAP003
      ***Set*screen*indicators*if feature on                             CAP003 164570
      *******************                                                CAP003 164570
     C*****CSW005********IFEQ      'Y'                                   CAP003 164570
     C*****##CALP********IFEQ      'FRA '                                CAP003 164570
     C*****##CALP********OREQ      'SIRS'                                CAP003 164570
     C*****##CALP********OREQ      'CIRS'                                CAP003 164570
     C*******************MOVE      '1'           *IN09                   CAP003 164570
     C*****##CALP********IFEQ      'FRA '                                CAP003 164570
     C*******************MOVE      '1'           *IN04                   CAP003 164570
     C*******************ENDIF                                           CAP003 164570
     C*****##CALP********IFEQ      'SIRS'                                CAP003 164570
     C*******************MOVE      '1'           *IN05                   CAP003 164570
     C*******************ENDIF                                           CAP003 164570
     C*******************ENDIF                                           CAP003 164570
     C*******************ENDIF                                           CAP003 164570
      *                                                                                     MD021872
      ** Check if SWIFT 2013  is on                                                         MD021872
      *                                                                                     MD021872
     C                   CALL      'SWIF2013'                                               MD021872
     C                   PARM      *BLANKS       @RTCD                                      MD021872
      *                                                                                     MD021872
     C                   IF        @RTCD = 'CSW2013'                                        MD021872
     C                   EVAL      CSW213  = 'Y'                                            MD021872
     C                   ELSE                                                               MD021872
     C                   EVAL      CSW213  = 'N'                                            MD021872
     C                   ENDIF                                                              MD021872
      *                                                                                     MD026923
      ** Check Display Customer Number or Shortname in Settlement Details                   MD026923
      *                                                                                     MD026923
     C                   CALL      'AOSVALR0'                                               MD026923
     C                   PARM                    @RTCD                                      MD026923
     C                   PARM      PCUSTD        SVALK1           20                        MD026923
     C                   PARM                    SVAL1           200                        MD026923
     C                   PARM                    SVALK2           20                        MD026923
     C                   PARM                    SVAL2           200                        MD026923
     C                   PARM                    SVALK3           20                        MD026923
     C                   PARM                    SVAL3           200                        MD026923
     C                   PARM                    SVALK4           20                        MD026923
     C                   PARM                    SVAL4           200                        MD026923
     C                   PARM                    SVALK5           20                        MD026923
     C                   PARM                    SVAL5           200                        MD026923
     C                   PARM                    SVALK6           20                        MD026923
     C                   PARM                    SVAL6           200                        MD026923
     C                   PARM                    SVALK7           20                        MD026923
     C                   PARM                    SVAL7           200                        MD026923
     C                   PARM                    SVALK8           20                        MD026923
     C                   PARM                    SVAL8           200                        MD026923
     C                   PARM                    SVALK9           20                        MD026923
     C                   PARM                    SVAL9           200                        MD026923
     C                   PARM                    SVALK0           20                        MD026923
     C                   PARM                    SVAL10          200                        MD026923
      *                                                                                     MD026923
     C                   IF        @RTCD <> *BLANKS                                         MD026923
      *                                                                                     MD026923
     C                   IF        SVAL1  = '*NRF'                                          MD026923
     C                   EVAL      DBKEY  = SVALK1                                          MD026923
     C                   ENDIF                                                              MD026923
      *                                                                                     MD026923
     C                   EVAL      DBFILE = 'SDSVALPD'                                      MD026923
     C                   EVAL      DBASE  = 003                                             MD026923
     C                   EXSR      *PSSR                                                    MD026923
     C                   ENDIF                                                              MD026923
      *                                                                                     MD026923
     C                   MOVEL     SVAL1         WCUSTD            1                        MD026923
      *
      ** Initialize program name
      *
     C                   MOVEL     'ZASETINSIN'  DBPGM
     C                   MOVEL     'ZASETINSIN'  ##PGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWSID
      *
     C/COPY ZACPYSRC,MSGHNDDATA                                                               171873
     C/COPY WNCPYSRC,ZASETIN#C7
     C                   ENDSR
     C*****************************************************************
      /EJECT                                                                    CDL011
      *****************************************************************         CDL011
      * WRNMEX - Name Expansion routine                               *         CDL011
      *****************************************************************         CDL011
     C     WRNMEX        BEGSR                                                  CDL011
      *                                                                         CDL011
     C     DDROCN        IFNE      *BLANKS                                      CDL011
      *                                                                         CDL011
     C                   CALL      'AOCUSTR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*KEY   '     @OPTN                          CDL011
     C                   PARM      DDROCN        @KEY1                          CDL011
     C                   PARM      *BLANKS       @KYST                          CDL011
     C     SDCUST        PARM      *BLANKS       DSSDY                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFEQ      *BLANKS                                      CDL011
     C                   EVAL      DDROCN = BBCSSN                              CDL011
     C                   ENDIF                                                  CDL011
                                                                                CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C     DDPOCN        IFNE      *BLANKS                                      CDL011
      *                                                                         CDL011
     C                   CALL      'AOCUSTR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*KEY   '     @OPTN                          CDL011
     C                   PARM      DDPOCN        @KEY1                          CDL011
     C                   PARM      *BLANKS       @KYST                          CDL011
     C     SDCUST        PARM      *BLANKS       DSSDY                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFEQ      *BLANKS                                      CDL011
     C                   EVAL      DDPOCN = BBCSSN                              CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
      * Multibranch indicator                                                   CDL011
     C                   IF        @MBIN = 'Y'                                  CDL011
     C**********         MOVEL     DDRONX        WWRONS           15                   CDL011 CGL029
     C**********         MOVEL     DDPONX        WWPONS           15                   CDL011 CGL029
     C                   MOVEL     DDRONX        WWRONS           21                          CGL029
     C                   MOVEL     DDPONX        WWPONS           21                          CGL029
     C                   ELSE                                                   CDL011
     C                   MOVEL     DDRONS        WWRONS                         CDL011
     C                   MOVEL     DDPONS        WWPONS                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
      * Target fields reset                                                     CDL011
     C                   MOVE      *Blanks       DDRFNM                         CDL011
     C                   MOVE      *Blanks       DDPFNM                         CDL011
      *                                                                         CDL011
      * Receive side                                                            CDL011
      *                                                                         CDL011
     C                   IF        DDRSTM = '01' or DDRSTM = '08'               CDL011
      *                                                                         CDL011
     C                   CALL      'AONOSTR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*KEY   '     @OPTN                          CDL011
     C                   PARM      *BLANKS       P@CUST            6            CDL011
     C                   PARM      ##RCCY        P@CYCD            3            CDL011
     C**********         PARM      *BLANKS       P@ACCD            4                   CDL011 CGL029
     C                   PARM      *BLANKS       P@ACCD           10                          CGL029
     C                   PARM      *BLANKS       P@ACSN            2            CDL011
     C                   PARM      WWRONS        P@NONB            2            CDL011
     C                   PARM      *BLANKS       P@BRCD            3            CDL011
     C                   PARM      *BLANKS       P@CSSN           10            CDL011
     C                   PARM      *BLANKS       P@PNOI            1            CDL011
     C     SDNOST        PARM      SDNOST        DSFDY                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL(P)  A7NOSN        DDRFNM                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   IF        DDRSTM = '04' or DDRSTM = '14'               CDL011
      *                                                                         CDL011
     C                   CALL      'AOACCTR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*KEY   '     @OPTN                          CDL011
     C                   PARM      WWRONS        @RETL            10            CDL011
     C                   PARM      *BLANKS       @CNUM             6            CDL011
     C                   PARM      *BLANKS       @CYCD             3            CDL011
     C**********         PARM      *BLANKS       @ACCD             4                   CDL011 CGL029
     C                   PARM      *BLANKS       @ACCD            10                          CGL029
     C                   PARM      *BLANKS       @ACSN             2            CDL011
     C                   PARM      *BLANKS       @DSNB             3            CDL011
     C     SDACNT        PARM      SDACNT        DSSDY                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL(P)  ANAM          DDRFNM                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   IF        DDRSTM = '05'                                CDL011
      *                                                                         CDL011
     C**********         MOVEL     WWRONS        WTMP13           13                   CDL011 CGL029
     C**********         MOVEL     WTMP13        WTMP09            9                   CDL011 CGL029
     C                   MOVEL     WWRONS        WTMP19           19                          CGL029
     C                   MOVEL     WTMP19        WTMP09            9                          CGL029
     C                   MOVEL     WTMP09        WTMP03            3            CDL011
     C                   MOVE      WTMP09        WTMP06            6            CDL011
     C**********         MOVE      WTMP13        WTMP04            4                   CDL011 CGL029
     C                   MOVE      WTMP19        WTMP10           10                          CGL029
     C                   MOVE      WWRONS        WTMP02            2            CDL011
      *                                                                         CDL011
     C                   CALL      'AOACCTR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*KEY   '     @OPTN                          CDL011
     C                   PARM      *BLANKS       @RETL            10            CDL011
     C                   PARM      WTMP06        @CNUM             6            CDL011
     C                   PARM      ##RCCY        @CYCD             3            CDL011
     C**********         PARM      WTMP04        @ACCD             4                   CDL011 CGL029
     C                   PARM      WTMP10        @ACCD                                        CGL029
     C                   PARM      WTMP02        @ACSN             2            CDL011
     C                   PARM      WTMP03        @DSNB             3            CDL011
     C     SDACNT        PARM      SDACNT        DSSDY                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL(P)  ANAM          DDRFNM                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
      * Pay side                                                                CDL011
      *                                                                         CDL011
     C                   IF        DDPSTM = '01' or DDPSTM = '08'               CDL011
      *                                                                         CDL011
     C                   CALL      'AONOSTR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*KEY   '     @OPTN                          CDL011
     C                   PARM      *BLANKS       P@CUST            6            CDL011
     C                   PARM      ##PCCY        P@CYCD            3            CDL011
     C**********         PARM      *BLANKS       P@ACCD            4                   CDL011 CGL029
     C                   PARM      *BLANKS       P@ACCD                                       CGL029
     C                   PARM      *BLANKS       P@ACSN            2            CDL011
     C                   PARM      WWPONS        P@NONB            2            CDL011
     C                   PARM      *BLANKS       P@BRCD            3            CDL011
     C                   PARM      *BLANKS       P@CSSN           10            CDL011
     C                   PARM      *BLANKS       P@PNOI            1            CDL011
     C     SDNOST        PARM      SDNOST        DSFDY                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL(P)  A7NOSN        DDPFNM                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   IF        DDPSTM = '04' or DDPSTM = '14'               CDL011
      *                                                                         CDL011
     C                   CALL      'AOACCTR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*KEY   '     @OPTN                          CDL011
     C                   PARM      WWPONS        @RETL            10            CDL011
     C                   PARM      *BLANKS       @CNUM             6            CDL011
     C                   PARM      *BLANKS       @CYCD             3            CDL011
     C**********         PARM      *BLANKS       @ACCD             4                   CDL011 CGL029
     C                   PARM      *BLANKS       @ACCD                                        CGL029
     C                   PARM      *BLANKS       @ACSN             2            CDL011
     C                   PARM      *BLANKS       @DSNB             3            CDL011
     C     SDACNT        PARM      SDACNT        DSSDY                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL(P)  ANAM          DDPFNM                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   IF        DDPSTM = '05'                                CDL011
      *                                                                         CDL011
     C**********         MOVEL     WWPONS        WTMP13           13                          CGL029
     C**********         MOVEL     WTMP13        WTMP09            9                          CGL029
     C                   MOVEL     WWRONS        WTMP19                                       CGL029
     C                   MOVEL     WTMP19        WTMP09                                       CGL029
     C                   MOVEL     WTMP09        WTMP03            3
     C                   MOVE      WTMP09        WTMP06            6
     C**********         MOVE      WTMP13        WTMP04            4                          CGL029
     C                   MOVE      WTMP19        WTMP10                                       CGL029
     C                   MOVE      WWPONS        WTMP02            2
      *                                                                         CDL011
     C                   CALL      'AOACCTR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*KEY   '     @OPTN                          CDL011
     C                   PARM      *BLANKS       @RETL            10            CDL011
     C                   PARM      WTMP06        @CNUM             6            CDL011
     C                   PARM      ##PCCY        @CYCD             3            CDL011
     C**********         PARM      WTMP04        @ACCD             4                   CDL011 CGL029
     C                   PARM      WTMP10        @ACCD                                        CGL029
     C                   PARM      WTMP02        @ACSN             2            CDL011
     C                   PARM      WTMP03        @DSNB             3            CDL011
     C     SDACNT        PARM      SDACNT        DSSDY                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL(P)  ANAM          DDPFNM                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
     C                   ENDSR                                                  CDL011
     C********************************************************************      CDL011
      /EJECT
     C********************************************************************                  MD026923
     C* RTVCUS - RETRIEVE CUSTOMER                                                          MD026923
     C********************************************************************                  MD026923
     C     RTVCUS        BEGSR                                                              MD026923
      *                                                                                     MD026923
     C                   IF        @KEY1 <> *ZEROS AND                                      MD026923
     C                             @KEY1 <> *BLANKS                                         MD026923
      *                                                                                     MD026923
     C                   CALL      'AOCUSTR1'                                               MD026923
     C                   PARM      *BLANKS       @RTCD                                      MD026923
     C                   PARM      '*KEY   '     @OPTN                                      MD026923
     C                   PARM                    @KEY1                                      MD026923
     C                   PARM      *BLANKS       @KYST                                      MD026923
     C     SDCUST        PARM      *BLANKS       DSLDY                                      MD026923
      *                                                                                     MD026923
     C     @RTCD         IFEQ      *BLANKS                                                  MD026923
     C     @KYST         ANDNE     '*ERROR '                                                MD026923
     C                   EVAL      @KEY1 = BBCUST                                           MD026923
     C                   ENDIF                                                              MD026923
     C                   ENDIF                                                              MD026923
      *                                                                                     MD026923
     C                   ENDSR                                                              MD026923
     C********************************************************************                  MD026923
      /EJECT                                                                                MD026923
     C********************************************************************                  MD026923
     C* CVTCUS - CONVERT CUSTOMER TO NUMERIC                                                MD026923
     C********************************************************************                  MD026923
     C     CVTCUS        BEGSR                                                              MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDRIBN                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDRIBN = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDROBN                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDROBN = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDROCN                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDROCN = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDPIBN                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDPIBN = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDPOBN                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDPOBN = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDPOCN                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDPOCN = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDRCRN                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDRCRN = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDRVNO                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDRVNO = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDAWBN                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDAWBN = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   EVAL      @KEY1  = DDBENN                                          MD026923
     C                   EXSR      RTVCUS                                                   MD026923
     C                   EVAL      DDBENN = @KEY1                                           MD026923
      *                                                                                     MD026923
     C                   ENDSR                                                              MD026923
     C********************************************************************                  MD026923
      /EJECT                                                                                MD026923
     C********************************************************************                  MD026923
     C/COPY ZACPYSRC,MSGHNDDSP2                                                               171873
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
