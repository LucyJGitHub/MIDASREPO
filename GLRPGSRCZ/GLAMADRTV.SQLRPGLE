     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*XBIA*  OVRDBF FILE(ACCNTL1) TOFILE(ACCNTL0) SHARE(*NO)              *
/*XBIB*  OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)                *
/*XBIC*  OVRDBF FILE(RECOMXX) TOFILE(RECOM) SHARE(*NO)                *
/*XBID*  OVRDBF FILE(REAPWDL1) TOFILE(REAPWDL0) SHARE(*NO)            *
/*S*D****RPGBASEMOD****************************************************                       CRE101
/*STD *  RPGSQLMOD                                                    *                       CRE101
/*EXI *  TEXT('Midas GL Account retrieve and acct/ref validation')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADRTV - General Ladger Account Retrieve                  *
      *              (WITH ACTION CODE VERSUS ACCOUNT VALIDATION)     *
      *                                                               *
      *  Function:  This module retrieves an Account from             *
      *             the database. As it does so, it validates the     *
      *             action code and Account Reference.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE101             Date 27Aug14               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 226364             Date 19Aug14               *
      *                 MD024951           Date 19Aug14               *
      *                 MD025198           Date 11May14               *
      *                 MD000091           Date 07May13               *
      *                 AR952677A          Date 26Nov12               *
      *                 AR801992           Date 27Jul12               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      *                 246760             Date 30Mar07               *
      *                 242011             Date 05Sep06               *
      *                 CRE030             Date 10Jul06               *
      *                 CGL062             Date 03Aug06               *
      *                 246627             Date 03Apr07               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13945           Date 16May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 224639             Date 06Jun06               *
      *                 238839             Date 29Mar06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 05Oct05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD012             Date 15Oct02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 194431             Date 22May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201922             Date 14Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 01Feb00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191833             Date 04Apr01               *
      *                 180721             Date 23Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136             Date 15Nov99               *
      *                 175479             Date 17Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CFT004             Date 08Nov99               *
      *                 CAP035  *CREATE    Date 06May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE101 - Interim Interest Statements on a Frequency          *
      *           Pgm type changed to be SQLRPGLE                     *
      *           Added hooks:  CRE101_008, CRE101_014, CRE101_019    *
      *                         CRE101_023, CRE101_024                *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  226364 - Allow accounts to have parent customers. Applied    *
      *           fix 213782.                                         *
      *           Applied for MD021329.                               *
      *  MD024951 - Unclear error message sent on amend via SOAP      *
      *  MD025198 - When ACSQ sent as blank system should default it  *
      *             to '01'. When testing this condition test also    *
      *             for '00' not only blank.                          *
      *  MD000091 - Event Codes Substitution                          *
      *  AR952677A - Performance issue when closing an account.       *
      *             Reversed fix AR801992. (Child: AR952678)          *
      *  AR801992 - Account was deleted even if an outstanding fee    *
      *             still uses it. Amend program such that deletion of*
      *             an error message would be encountered when an     *
      *             outstanding fee or loan still uses it. Patterned  *
      *             fix from 201604. (Child: AR801993)                *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  246760 - Moduls 11 Check does not work for action code R     *
      *  242011 - Moduls 11 Check only applies for Insert action      *
      *  CRE030 - Default RE Accounts by Currency                     *
      *  CGL062 - Moduls 11 Check on Retail Account Number            *
      *  246627 - Formalise fix, re-initialise OK fields to avoid     *
      *           processing valid records as a *RECUPD occurence.    *
      *  BUG13945 - Wholesale Internal Account errors                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  224639 - Allow amendment of Accounts even if IBAN is         *
      *           is linked to a incoming payments.                   *
      *  238839 - Allow update of account details even though account *
      *           is attached to an incoming payment, but do not      *
      *           allow update of IBAN number.                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation.                        *
      *  208221 - Default Margin from Rate/Spread changes (Recompile) *
      *  194431 - Retrieve account details of reference account if    *
      *           default account is set up.                          *
      *  201922 - Retail account number is generated for non-retail   *
      *           accounts                                            *
      *  CDE002 - CCRM Revenue Analysis - (Recompiled)                *
      *  191833 - Error msg "Retail number invalid" appears in case   *
      *           of Retail Number Used = N and Retail number zero    *
      *  180721 - Retail Account Number must be calculated            *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *           Recompiled over changed PF/INPAYDD.                 *
      *  175479 - Recompiled over changes in INPAYDD                  *
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *           Recompiled due to database changes.                 *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CAP035 - Midas API Conversion for ToF                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A1)
     F***GLAMADL0  IF   E           K DISK    INFSR(*PSSR)                                    CGL029
     FGLAMADL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL029
     F                                     RENAME(ACCNTABF:GLAMAFOI)
     F                                     PREFIX(H_)
     FACCNTBY0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(B1)
     FREIACXX   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(C1)
     FRECOMXX   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D1)
     FREAPWDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(E1)
      **********                                                                  AR801992 AR952677A
     F***CLOANLB   IF   E           K DISK    INFSR(*PSSR)                        AR801992 AR952677A
      **********                                                                  AR801992 AR952677A
     F***CLOAN**   IF   E           K DISK    INFSR(*PSSR)                        AR801992 AR952677A
     F**********                           IGNORE(CLOANHHF)                       AR801992 AR952677A
     F**********                           IGNORE(CLOANCLF)                       AR801992 AR952677A
     F**********                           IGNORE(CLOANZ1F)                       AR801992 AR952677A
      **********                                                                  AR801992 AR952677A
     F***LEFEEDL1  IF   E           K DISK    INFSR(*PSSR)                        AR801992 AR952677A
      **********                                                                  AR801992 AR952677A
      ** Retail Interest Details                                                              194431
     FREINT     IF   E           K DISK    INFSR(*PSSR)                                       194431
     F                                     PREFIX(RE)                                         194431
      ** Retail Charges Details                                                               194431
     FRECRG     IF   E           K DISK    INFSR(*PSSR)                                       194431
     F                                     IGNORE(RECRGAF)                                    194431
     F                                     IGNORE(RECRGZF)                                    194431
     F                                     PREFIX(RC)                                         194431
      ** Account Numbers                                                                      194431
     FACNUM     IF   E           K DISK    RENAME(ACCNTABF:ACNUMTBF)                          194431
     F                                     PREFIX(Y_)                                         194431
      ** Default Retail Account                                                               194431
     FREDEF     IF   E           K DISK    INFSR(*PSSR)                                       194431
     F                                     PREFIX(X_)                                         194431
     F                                     IGNORE(REDEFAF)                                    194431
     F                                     IGNORE(REDEFZF)                                    194431
      ** Retail Statement Charges file                                                        194431
     FRESTCHPD  IF   E           K DISK    INFSR(*PSSR)                                       194431
      *                                                                                       194431
     FINPAYIB   IF   E           K DISK    INFSR(*PSSR)                         CFT004
      *                                                                                       CSD012
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)                                       CSD012
      * RTV : Authorisation Log - by Key                                                      CSD012
     FSDACD1L0  IF   E           K DISK    INFSR(*PSSR)                                       CRE015
     F                                     PREFIX(X5:2)                                       CRE015
     FREPRPNPD  IF   E           K DISK    INFSR(*PSSR)                                       CRE015

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D SDCUST2       E DS                  EXTNAME(SDCUSTPD)                                  194431
     D                                     PREFIX(X_)                                         194431
      ** EXTERNAL DS FOR CURRENCY DETAILS 2                                                   194431
      *                                                                                       194431
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** EXTERNAL DS FOR ACCOUNT CODE DETAILS

     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR RETAIL ACCOUNT DETAILS
      *                                                                                       194431
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                  194431
     D                                     PREFIX(Z_)                                         194431
      ** EXTERNAL DS FOR BASE RATE DETAILS                                                    194431

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** Account in File Format
     D AccnFilFmt    E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A1)
     D ExBXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(B1)
     D ExRIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(C1)
     D ExCOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(D1)
     D ExPWFilFmt    E DS                  EXTNAME(REAPWDPD)
     D                                     PREFIX(E1)
     D***CLOAL#        E DS                  EXTNAME(CLOANCL)                     AR801992 AR952677A
     D***LSCCY         E                     EXTFLD(SCCY)                         AR801992 AR952677A
     D***CLOAK#        E DS                  EXTNAME(CLOANCK)                     AR801992 AR952677A
     D***KRECI         E                     EXTFLD(RECI)                         AR801992 AR952677A
     D***KLNRF         E                     EXTFLD(LNRF)                         AR801992 AR952677A
     D***KRCDT         E                     EXTFLD(RCDT)                         AR801992 AR952677A
     D***KMRIN         E                     EXTFLD(MRIN)                         AR801992 AR952677A
     D***KORED         E                     EXTFLD(ORED)                         AR801992 AR952677A
     D***KLCD          E                     EXTFLD(LCD)                          AR801992 AR952677A
     D***KCHTP         E                     EXTFLD(CHTP)                         AR801992 AR952677A
     D***KTNLU         E                     EXTFLD(TNLU)                         AR801992 AR952677A
     D***KFRNT         E                     EXTFLD(FRNT)                         AR801992 AR952677A
     D***KAFRT         E                     EXTFLD(AFRT)                         AR801992 AR952677A
     D***KREPA         E                     EXTFLD(REPA)                         AR801992 AR952677A
     D***KTMST         E                     EXTFLD(TMST)                         AR801992 AR952677A
     D ExPPFilFmt    E DS                  EXTNAME(REPENAPD)                                  CRE015
     D                                     PREFIX(F1)                                         CRE015
                                                                                              CRE015
     D/COPY OFCPYSRCZ,CRE101_023                                                              CRE101
      ** Array for file definition                                                            CRE015
                                                                                              CRE015
     D ArrFilBuf       S                   DIM(26) LIKE(REPRPN)                               CRE015
     D REPRPN        E DS                  EXTNAME(REPRPNPD)                                  CRE015

     D KEY             DS            12                                                       194431
     D BLANC                   1      1                                                       194431
     D TYPE                    2      3                                                       194431
     D SBTYPE                  4      8                                                       194431
     D CURR                    9     11                                                       194431
     D D                      12     12                                                       194431
      *                                                                                       194431
     D RUNDAT          DS
     D  @MBIN                 13     13
     DZMUSER           DS
     D  DBRN                  11     13
     D  BANK                  17     17
      **********                                                                  AR801992 AR952677A
     D***CLOAN1           DS          1300                                        AR801992 AR952677A
     D***CLOAN2           DS          1158                                        AR801992 AR952677A
     D                 DS                                                                     CRE015
     D WEIGHT                  1      2B 0                                                    CRE015
     D BYTE                    2      2                                                       CRE015

      ** Retail numeric field for compares to file value
     D RetailKey       S                   LIKE(A1ACNO)
      ** Key to CHAIN to Account file
     D KCNUM           S                   LIKE(A1CNUM)
     D KCCY            S                   LIKE(A1CCY)
     D KACOD           S                   LIKE(A1ACOD)
     D KACSQ           S                   LIKE(A1ACSQ)
     D KBRCA           S                   LIKE(A1BRCA)
     D K2BRCA          S                   LIKE(E2BRCA)                                       CRE015
     D K2CNUM          S                   LIKE(E2CNUM)                                       CRE015
     D K2CCY           S                   LIKE(E2CCY )                                       CRE015
     D K2ACOD          S                   LIKE(E2ACOD)                                       CRE015
     D K2ACSQ          S                   LIKE(E2ACSQ)                                       CRE015
     D K2EVNT          S                   LIKE(E2EVNT)                                       CRE015
     D K2ITEM          S                   LIKE(E2ITEM)                                       CRE015
                                                                                              CSD012
     D***@AULG**         DS            20                                              CSD012 CGL029
     D @AULG           DS            26                                                       CGL029
     D @DDBRCA                 1      3                                                       CSD012
     D @DDCNUM                 4      9                                                       CSD012
     D @DDCCY                 10     12                                                       CSD012
     D***@DDACOD                13     16                                              CSD012 CGL029
     D***@DDACSQ                17     18                                              CSD012 CGL029
     D @DDACOD                13     22                                                       CGL029
     D @DDACSQ                23     24                                                       CGL029
                                                                                              CSD012
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
     D DDACOD          S             10                                                       CGL029
     D WWACOD          S             10S 0                                                    CGL029
     D @ACOD           S             10                                                       CGL029
     D X               S              3  0                                                    CRE015
     D W#FOUND         S              1                                                       CRE015
     D MAINT           S              7                                                       CRE015
     D RUNCHG          S              5                                                       CRE015
     D PRCEDE          S              5  0                                                    CRE015
     D PRTCD           S              7                                                       CRE015

     D Mod11Chk        S              1                                                       CGL062
     D P@Rtcd          S              7A                                                      CGL062
     D P@Op01          S             20A                                                      CGL062
     D P@Vl01          S            200A                                                      CGL062
     D P@Op02          S             20A                                                      CGL062
     D P@Vl02          S            200A                                                      CGL062
     D P@Op03          S             20A                                                      CGL062
     D P@Vl03          S            200A                                                      CGL062
     D P@Op04          S             20A                                                      CGL062
     D P@Vl04          S            200A                                                      CGL062
     D P@Op05          S             20A                                                      CGL062
     D P@Vl05          S            200A                                                      CGL062
     D P@Op06          S             20A                                                      CGL062
     D P@Vl06          S            200A                                                      CGL062
     D P@Op07          S             20A                                                      CGL062
     D P@Vl07          S            200A                                                      CGL062
     D P@Op08          S             20A                                                      CGL062
     D P@Vl08          S            200A                                                      CGL062
     D P@Op09          S             20A                                                      CGL062
     D P@Vl09          S            200A                                                      CGL062
     D P@Op10          S             20A                                                      CGL062
     D P@Vl10          S            200A                                                      CGL062
                                                                                            MD000091
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
     I***CLOANCLF                                                                 AR801992 AR952677A
     I**********    SCCY                        LSCCY                             AR801992 AR952677A
     I**********    ICCY                        LICCY                             AR801992 AR952677A
     I***CLOANCKF                                                                 AR801992 AR952677A
     I**********    RECI                        KRECI                             AR801992 AR952677A
     I**********    LNRF                        KLNRF                             AR801992 AR952677A
     I**********    RCDT                        KRCDT                             AR801992 AR952677A
     I**********    MRIN                        KMRIN                             AR801992 AR952677A
     I**********    ORED                        KORED                             AR801992 AR952677A
     I**********    LCD                         KLCD                              AR801992 AR952677A
     I**********    CHTP                        KCHTP                             AR801992 AR952677A
     I**********    TNLU                        KTNLU                             AR801992 AR952677A
      /EJECT
      **************************************************************
      *
      ** Retrieve ZMUSER details                                                             BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
                                                                                             BUG8550
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   MOVEL     'Y'           OKACTN                                       246627
     C                   MOVEL     'Y'           OKCNUM                                       246627
     C                   MOVEL     'Y'           OKCCY                                        246627
     C                   MOVEL     'Y'           OKACOD                                       246627
     C                   MOVEL     'Y'           OKACSQ                                       246627
     C                   MOVEL     'Y'           OKBRCA                                       246627
     C                   MOVEL     'Y'           OKACNO                                       246627
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCNUM        OREQ      'N'
     C     OKCCY         OREQ      'N'
     C     OKACOD        OREQ      'N'
     C     OKACSQ        OREQ      'N'
     C     OKBRCA        OREQ      'N'
     C     OKACNO        OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        ModeofOp = '      '                                        CAP086
     C                   EVAL      A1AUTH = *BLANKS                                           CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * Validate Action code & Account Reference
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCNUM        OREQ      'N'
     C     OKCCY         OREQ      'N'
     C     OKACOD        OREQ      'N'
     C     OKACSQ        OREQ      'N'
     C     OKBRCA        OREQ      'N'
     C     OKACNO        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   IF        DDACTN='1'or DDACTN='2'or DDACTN='3'or
     C                             DDACTN='4'or DDACTN='5'
     C                   EVAL      ZACTN='E'
     C                   ELSE
     C                   EVAL      ZACTN=DDACTN
     C                   ENDIF
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      ACSSES
     C                   END
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'R'                                                        194431
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      ACSSEM
     C                   END
     C                   END
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C                   RETURN
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
      *  * Validation for Action Code 'E' *
      *  * '1' '2' '3' '4' '5'            *
      *  *--------------------------------*
      *
     C                   IF        DDACTN='1'or DDACTN='2'or DDACTN='3'or
     C                             DDACTN='4'or DDACTN='5'or DDACTN='E'
     C                   EXSR      VALACE
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
     C     OKCNUM        OREQ      'N'
     C     OKCCY         OREQ      'N'
     C     OKACOD        OREQ      'N'
     C     OKACSQ        OREQ      'N'
     C     OKBRCA        OREQ      'N'
     C     OKACNO        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Get Account Extension Details (if present)    *
      *  *-----------------------------------------------*
      *
     C     CHKACC        CHAIN     ACCNTBY0                           80
     C     *IN80         IFEQ      '1'
     C                   CLEAR                   ExBXFilFmt
     C                   ENDIF
     C     CHKACC        CHAIN     REIACXX                            80
     C     *IN80         IFEQ      '1'
     C                   CLEAR                   ExRIFilFmt
     C                   ENDIF
     C     CHKACC        CHAIN     REAPWDL1                           80
     C     *IN80         IFEQ      '1'
     C                   CLEAR                   ExPWFilFmt
     C                   ENDIF
     C     CHKCOM        CHAIN     RECOMXX                            80
     C     *IN80         IFEQ      '1'
     C                   CLEAR                   ExCOFilFmt
     C                   ENDIF
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                   EXSR      SRPPDetails                                                CRE015
     C                   ENDIF                                                                CRE015
     C/COPY OFCPYSRCZ,CRE101_024                                                              CRE101
      *                                                                                       194431
      *  *--------------------------------*                                                   194431
      *  * Validation for Action Code 'R' *                                                   194431
      *  *--------------------------------*                                                   194431
      *                                                                                       194431
     C     DDACTN        IFEQ      'R'                                                        194431
     C                   EXSR      VALACR                                                     194431
     C                   END                                                                  194431
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - Validation for Front Office Transaction Interface
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I','A','E','D','1','2','3','4','5'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     '1'
     C     DDACTN        ANDNE     '2'
     C     DDACTN        ANDNE     '3'
     C     DDACTN        ANDNE     '4'
     C     DDACTN        ANDNE     '5'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71001'     MsgIdArr(Ix)
     C                   END
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ACCESS TRADE WITH FRONT OFFICE TRANSACTION ID
      *
     C     FOTRID        CHAIN     GLAMAFOI                           80
      *
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN80         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
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
     C     *IN80         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      * If not INSERT, Update Midas Account reference
      *
     C                   MOVEL     H_CNUM        DDCUSN
     C                   MOVEL     H_CCY         DDCCY
     C                   MOVEL     H_ACOD        DDACOD
     C                   MOVEL     H_ACSQ        DDACSQ
     C                   MOVEL     H_BRCA        DDBRCA

     C                   IF        H_ACNO = *ZEROS
     C                   EVAL      DDACNO = *BLANKS
     C                   ELSE
     C                   MOVEL     H_ACNO        DDACNO
     C                   ENDIF

     C                   END
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - Validation of Action Code and Account Reference
      *****************************************************************
     C     VAL           BEGSR
      *
      * Action Code
      *
      *  .. must be 'I','A','D','E','1','2','3','4','5'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     '1'
     C     DDACTN        ANDNE     '2'
     C     DDACTN        ANDNE     '3'
     C     DDACTN        ANDNE     '4'
     C     DDACTN        ANDNE     '5'
     C     DDACTN        ANDNE     'R'                                                        194431
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71001'     MsgIdArr(Ix)
     C                   END
      *
      * Account Reference
      *
      *  If the Account reference is not blank, check that it is valid.
      *
      * Branch field should not be blank
     C     DDBRCA        IFEQ      *BLANKS
     C                   MOVEL     DBRN          DDBRCA
     C                   END
      *
      * Access Branch details
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCA        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      * Not Found
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           OKBRCA
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'RE71040'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C     DDCUSN        IFNE      *BLANKS
     C     DDCCY         ANDNE     *BLANKS
     C     DDACOD        ANDNE     *BLANKS
     C     DDACSQ        ANDNE     *BLANKS
      *
      * Customer field should not be blank & Customer can't be parent
      *
     C     DDCUSN        IFEQ      *BLANKS
     C                   MOVEL     'N'           OKCNUM
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'RE71030'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ELSE
      *
      * Access Customer details
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      * Not Found
     C     @RTCD         IFNE      *BLANKS
     C     BBDTDL        ORNE      *ZERO
     C                   MOVEL     'N'           OKCNUM
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'RE71031'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      **Customer*cannot*be*parent**************************************                       226364
     C*****BBPAIN        IFEQ      'P'                                                        226364
     C**********         MOVEL     'N'           OKCNUM                                       226364
     C**********         ADD       1             Ix                                           226364
     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                               226364
     C**********         MOVEL     'RE71032'     MsgIdArr(Ix)                                 226364
     C**********         GOTO      EVAL                                                       226364
     C**********         END                                                                  226364
     C                   END
      *
      * Currency field should not be blank
     C     DDCCY         IFEQ      *BLANKS
     C                   MOVEL     'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDCCY '      FldNameArr(Ix)
     C                   MOVEL     'RE71034'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ELSE
      *
      * Access Currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * Not Found
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDCCY '      FldNameArr(Ix)
     C                   MOVEL     'RE71033'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C                   END
      *
      * Account Code should not be blank
     C     DDACOD        IFEQ      *BLANKS
     C                   MOVEL     'N'           OKACOD
     C                   ADD       1             Ix
     C                   MOVEL     'DDACOD'      FldNameArr(Ix)
     C                   MOVEL     'RE71035'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ELSE
      *
      * Access Account Code details
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********         PARM      DDACOD        @ACOD             4                          CGL029
     C*****SDACOD        PARM      SDACOD        DSFDY                                        CGL029
     C                   PARM      DDACOD        @ACOD                                        CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029
      *
      * Not Found
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           OKACOD
     C                   ADD       1             Ix
     C                   MOVEL     'DDACOD'      FldNameArr(Ix)
     C                   MOVEL     'RE71037'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      * Account Code is Title only
     C     A5TOIN        IFEQ      'Y'
     C                   MOVEL     'N'           OKACOD
     C                   ADD       1             Ix
     C                   MOVEL     'DDACOD'      FldNameArr(Ix)
     C                   MOVEL     'RE71038'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C                   END
      *
      * Account Sequence should be numeric and not blank
     C**********         IF        DDACSQ=*BLANKS and @MBIN='Y'                             MD025198
     C                   IF        (DDACSQ = *BLANKS or DDACSQ = '00')                      MD025198
     C                             and @MBIN = 'Y'                                          MD025198
     C                   EVAL      DDACSQ='01'
     C                   END
     C                   TESTN                   DDACSQ               81
     C                   MOVE      DDACSQ        @@TEST            1
     C                   TESTZ                   @@TEST                   80
     C     DDACSQ        IFNE      *BLANKS
     C     *IN81         ANDEQ     '0'
     C     DDACSQ        ORNE      *BLANKS
     C     *IN80         ANDEQ     '0'
     C     DDACSQ        OREQ      '00'
     C                   MOVEL     'N'           OKACSQ
     C                   ADD       1             Ix
     C                   MOVEL     'DDACSQ'      FldNameArr(Ix)
     C                   MOVEL     'REL0020'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      * Retail Account only if Retail used and A/C type is Retail
      *
     C     DDACTN        IFEQ      'I'                                          180721
     C     BMRANR        ANDEQ     'Y'                                          180721
     C     BGN4ST        ANDEQ     'Y'                                          180721
     C     DDACNO        ANDEQ     *Blanks                                      180721
     C     A5ACTY        ANDEQ     'R'                                                        201922
     C     DDACTN        OREQ      'I'                                          180721
     C     BMRANR        ANDEQ     'Y'                                          180721
     C     BGN4ST        ANDEQ     'Y'                                          180721
     C     DDACNO        ANDEQ     '0         '                                 180721
     C     A5ACTY        ANDEQ     'R'                                                        201922
     C/COPY WNCPYSRC,GLAMADIC02
      *                                                                         180721
      * Call external program to generate to Midas Retail Number                180721
     C                   CALL      'PBACNOGN'                                   180721
      *                                                                         180721
      * Input parameters                                                        180721
      *                                                                         180721
     C                   PARM                    DDCUSN                         180721
     C                   PARM                    DDCCY                          180721
     C                   PARM                    DDACOD                         180721
     C                   PARM                    DDACSQ                         180721
     C                   PARM                    DDBRCA                         180721
     C*                                                                         180721
     C** Output parameter                                                       180721
     C                   PARM      *BLANKS       OOERR             1            180721
     C                   PARM      *BLANKS       OOACNO           10            180721
      *                                                                         180721
     C     OOERR         IFEQ      ' '                                          180721
     C                   MOVE      OOACNO        DDACNO                         180721
     C                   END                                                    180721
     C                   END                                                    180721
      *                                                                         180721
     C     BMRANR        IFEQ      'Y'
     C     DDACNO        IFNE      *BLANKS
     C     A5ACTY        IFNE      'R'
     C                   MOVEL     'N'           OKACNO
     C                   ADD       1             Ix
     C**********         MOVEL     'DDACNO'      FldNameArr(Ix)                             BUG13945
     C                   MOVEL     'DDACOD'      FldNameArr(Ix)                             BUG13945
     C                   MOVEL     'RE71047'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ELSE
      * Retail Account number must be numeric
     C                   TESTN                   DDACNO               81
     C                   MOVE      DDACNO        @@TEST
     C                   TESTZ                   @@TEST                   80
     C     DDACNO        IFNE      *BLANKS
     C     *IN81         ANDEQ     '0'
     C     DDACNO        ORNE      *BLANKS
     C     *IN80         ANDEQ     '0'
     C                   MOVEL     'N'           OKACNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACNO'      FldNameArr(Ix)
     C                   MOVEL     'RE71048'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   Z-ADD     0             NNACNO           10 0
     C                   MOVE      DDACNO        NNACNO           10 0
     C                   IF        NNACNO<1 or NNACNO>9999999999
     C                   MOVEL     'N'           OKACNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACNO'      FldNameArr(Ix)
     C                   MOVEL     'RE71046'     MsgIdArr(Ix)
     C                   GOTO      EVAL
                                                                                              CGL062
     C                   Else                                                                 CGL062
      ** If Modulus 11 Checking is enabled, perform this validation                           CGL062
                                                                                              CGL062
     C********           If        Mod11Chk = 'Y'                                      CGL062 242011
     C********           If        (Mod11Chk = 'Y' And DDACTN = 'I')                   242011 246760
     C                   If        (Mod11Chk = 'Y' And                                        246760
     C                              (DDACTN = 'I' Or DDACTN = 'R'))                           246760
     C                   Eval      @ACNO = DDAcno                                             CGL062
     C                   CALLB     'ZAMOD11VAL'                                               CGL062
     C                   PARM      *BLANKS       ReturnCode                                   CGL062
     C                   PARM                    @ACNO            10                          CGL062
     C                   PARM      *BLANKS       @AcNoOk           1                          CGL062
                                                                                              CGL062
     C                   If        ReturnCode <> *BLANKS                                      CGL062
     C                   Eval      DBFile = 'ZAMOD11VAL'                                      CGL062
     C                   Eval      DBKey  = @ACNO                                             CGL062
     C                   Eval      DBase  = 02                                                CGL062
     C                   Exsr      *PSSR                                                      CGL062
     C                   EndIf                                                                CGL062
                                                                                              CGL062
     C                   If        @AcNoOk <> 'Y'                                             CGL062
     C                   Move      'N'           OKACNO                                       CGL062
     C                   Add       1             Ix                                           CGL062
     C                   Movel     'DDACNO'      FldNameArr(Ix)                               CGL062
     C                   Movel     'RE62001'     MsgIdArr(Ix)                                 CGL062
     C                   GOTO      EVAL                                                       CGL062
     C                   EndIf                                                                CGL062
     C                   EndIf                                                                CGL062
     C                   END
     C                   END
     C                   END
     C                   ELSE
     C     A5ACTY        IFEQ      'R'
     C     DDACNO        ANDNE     *BLANKS                                                    191833
     C                   MOVEL     'N'           OKACNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACNO'      FldNameArr(Ix)
     C                   MOVEL     'RE71046'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C                   END
     C                   ENDIF
      *                                                                                       CSD012
      * If Authorisation check is on,                                                         CSD012
      * check if unathorised record exists on Authorisation Log.                              CSD012
     C     AUTHRQ        IFEQ      'Y'                                                        CSD012
     C     AUTHMD        ANDNE     'X'                                                        CSD012
     C     DDACTN        ANDNE     'E'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     KBRCA         @DDBRCA                                      CSD012
     C                   MOVEL     KCNUM         @DDCNUM                                      CSD012
     C                   MOVEL     KCCY          @DDCCY                                       CSD012
     C                   MOVEL     KACOD         @DDACOD                                      CSD012
     C                   MOVEL     KACSQ         @DDACSQ                                      CSD012
      *                                                                                       CSD012
     C     @AULG         CHAIN     SDAULGL0                           90                      CSD012
      *                                                                                       CSD012
      * If record exists then prevent amendment                                               CSD012
     C     *IN90         IFEQ      *OFF                                                       CSD012
     C                   MOVEL     'N'           OKACTN                                       CSD012
     C                   MOVE      1             Ix                                           CSD012
     C                   MOVEL     @AULG         FldNameArr(Ix)                               CSD012
     C                   MOVEL     'USR9265'     MsgIdArr(Ix)                                 CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      * Access trade from the trades file
      *
     C     CHKACC        CHAIN     ACCNTABF                           44
      *
      * Error if present already
      *
     C     *IN44         IFEQ      '0'
     C                   MOVEL     'N'           OKCNUM
     C                   MOVEL     'N'           OKCCY
     C                   MOVEL     'N'           OKACOD
     C                   MOVEL     'N'           OKACSQ
     C                   MOVEL     'N'           OKBRCA
     C                   ADD       1             Ix
     C**********         MOVEL     'DDACRF'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'DDACCN'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'RE71020'     MsgIdArr(Ix)
     C                   END
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
      *
      * Access Account from the Accounts file
      *
     C     CHKACC        CHAIN     ACCNTABF                           44
      *
      * Must reference a record on ACCNTAB
      *
     C     *IN44         IFEQ      '1'
     C                   MOVEL     'N'           OKCNUM
     C                   MOVEL     'N'           OKCCY
     C                   MOVEL     'N'           OKACOD
     C                   MOVEL     'N'           OKACSQ
     C                   MOVEL     'N'           OKBRCA
     C                   ADD       1             Ix
     C**********         MOVEL     'DDACRF'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'DDACCN'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'RE71022'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
      *
      ** If Action '2','3','4' OR '5' requested Account must be Retail
     C                   IF        DDACTN='2'or DDACTN='3'or DDACTN='4'or
     C                             DDACTN='5'
     C     A1ATYP        IFNE      'R'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71011'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
     C                   END
      *
      ** If Fourth screen requested and no Commission then forbidden
      *
     C                   IF        DDACTN='4' and CommDisp<>'Y'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71016'     MsgIdArr(Ix)
     C                   END
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
      *
      * Access Account from the accounts file
      *
     C     CHKACC        CHAIN     ACCNTABF                           44
      *
      * Must reference an Account that exists
     C     *IN44         IFEQ      '1'
     C                   MOVEL     'N'           OKCNUM
     C                   MOVEL     'N'           OKCCY
     C                   MOVEL     'N'           OKACOD
     C                   MOVEL     'N'           OKACSQ
     C                   MOVEL     'N'           OKBRCA
     C                   ADD       1             Ix
     C**********         MOVEL     'DDACRF'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'DDACCN'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'RE71022'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
      *
      * Must reference an Account that is not closed
     C                   IF        not *IN44 and A1ACST='C'
     C                   MOVE      'N'           OKCNUM
     C                   MOVE      'N'           OKCCY
     C                   MOVE      'N'           OKACOD
     C                   MOVE      'N'           OKACSQ
     C                   MOVE      'N'           OKBRCA
     C     A1RECI        IFEQ      'C'
     C                   ADD       1             Ix
     C**********         MOVEL     'DDACRF'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'DDACCN'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'RE71021'     MsgIdArr(Ix)
     C                   ELSE
      * or Flagged for Closure
     C                   ADD       1             Ix
     C**********         MOVEL     'DDACRF'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'DDACCN'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'RE71013'     MsgIdArr(Ix)
     C                   END
     C                   ENDIF
      *                                                                         CFT004
      * Access Account from the FT Incoming Payments file                       CFT004
      *                                                                         CFT004
     C**********         IF        CFT004 = 'Y'                                        CFT004 224639
     C*****A1IBAN        CHAIN     INPAYIB                            44               CFT004 224639
      **********                                                                       CFT004 224639
      **If*references*an*account*that*exists*then*Account*can't*be****                 CFT004 224639
      **Amended*or*Deleted.*******************************************                 CFT004 224639
     C******IN44         IFEQ      '0'                                                 CFT004 224639
     C**********         MOVEL     'N'           OKCNUM                                CFT004 224639
     C**********         MOVEL     'N'           OKCCY                                 CFT004 224639
     C**********         MOVEL     'N'           OKACOD                                CFT004 224639
     C**********         MOVEL     'N'           OKACSQ                                CFT004 224639
     C**********         MOVEL     'N'           OKBRCA                                CFT004 224639
     C**********         ADD       1             Ix                                    CFT004 224639
     C**********         MOVEL     'IBAN'        FldNameArr(Ix)                        CFT004 224639
     C**********         MOVEL     'RE72026'     MsgIdArr(Ix)                          CFT004 224639
     C**********         GOTO      EVALAA                                              CFT004 224639
     C**********         END                                                           CFT004 224639
     C**********         END                                                           CFT004 224639

     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
      * Access trade from the trades file
      *
     C     CHKACC        CHAIN     ACCNTABF                           4445
      *
      * Must reference an active Account
      *
     C     *IN44         IFEQ      '1'
     C     A1ACST        OREQ      'C'
     C                   MOVE      'N'           OKCNUM
     C                   MOVE      'N'           OKCCY
     C                   MOVE      'N'           OKACOD
     C                   MOVE      'N'           OKACSQ
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             Ix
     C**********         MOVEL     'DDACRF'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'DDACCN'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'RE71010'     MsgIdArr(Ix)
     C                   ELSE
     C     *IN45         IFEQ      '1'
     C                   MOVE      'N'           OKCNUM
     C                   MOVE      'N'           OKCCY
     C                   MOVE      'N'           OKACOD
     C                   MOVE      'N'           OKACSQ
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             Ix
     C**********         MOVEL     'DDACRF'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'DDACCN'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'RE71805'     MsgIdArr(Ix)
     C                   END
     C                   ENDIF
      * Error if Retail Account does not exist
      *
     C     DDACNO        IFNE      *BLANKS
     C                   MOVEL(P)  DDACNO        RetailKey
     C     RetailKey     IFNE      A1ACNO
     C                   MOVEL     'N'           OKACNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACNO'      FldNameArr(Ix)
     C                   MOVEL     'RE71046'     MsgIdArr(Ix)
     C                   END
     C                   END
      *                                                                         CFT004
      * Access Account from the FT Incoming Payments file                       CFT004
      *                                                                         CFT004
     C                   IF        CFT004 = 'Y'                                 CFT004
     C     A1IBAN        CHAIN     INPAYIB                            44        CFT004
      *                                                                         CFT004
      * If references an account that exists then Account can't be              CFT004
      * Amended or Deleted.                                                     CFT004
     C     *IN44         IFEQ      '0'                                          CFT004
     C                   MOVEL     'N'           OKCNUM                         CFT004
     C                   MOVEL     'N'           OKCCY                          CFT004
     C                   MOVEL     'N'           OKACOD                         CFT004
     C                   MOVEL     'N'           OKACSQ                         CFT004
     C                   MOVEL     'N'           OKBRCA                         CFT004
     C                   ADD       1             Ix                             CFT004
     C                   MOVEL     'IBAN'        FldNameArr(Ix)                 CFT004
     C                   MOVEL     'RE72027'     MsgIdArr(Ix)                   CFT004
     C                   GOTO      EVALAD                                       CFT004
     C                   END                                                    CFT004
     C                   END                                                    CFT004
                                                                                CFT004
      *****************************************************************           AR801992 AR952677A
      ***Store*any*fields*which*may*be*shared*with*other*files*********           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         MOVE      *IN76         IN76              1              AR801992 AR952677A
     C**********         MOVE      *IN77         IN77              1              AR801992 AR952677A
     C**********         MOVE      CLOAL#        CLOAN1                           AR801992 AR952677A
     C**********         MOVE      CLOAK#        CLOAN2                           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      ***Read*first*record*from*File.**********************************           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         READ      CLOANLB                                76      AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      ***Do*WHILE*not*end*of*file.*************************************           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C******IN76         DOWEQ     *OFF                                           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****RECI          IFNE      '*'                                            AR801992 AR952677A
     C*****RECI          ANDNE     'R'                                            AR801992 AR952677A
     C*****RECI          ANDNE     'M'                                            AR801992 AR952677A
     C**********         MOVEL     A1ACNO        XACCNT           10              AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      ***Start*Date****************************************************           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****SDST          IFEQ      14                                             AR801992 AR952677A
     C*****OSDA          ANDEQ     XACCNT                                         AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      ***Maturity*Date*************************************************           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****MDST          OREQ      14                                             AR801992 AR952677A
     C*****OMDA          ANDEQ     XACCNT                                         AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****RSTM          OREQ      14                                             AR801992 AR952677A
     C*****RONS          ANDEQ     XACCNT                                         AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****PSTM          OREQ      14                                             AR801992 AR952677A
     C*****ORED          ANDEQ     BJRDNB                                         AR801992 AR952677A
     C*****PONS          ANDEQ     XACCNT                                         AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         MOVEL     'N'           OKCNUM                           AR801992 AR952677A
     C**********         MOVEL     'N'           OKCCY                            AR801992 AR952677A
     C**********         MOVEL     'N'           OKACOD                           AR801992 AR952677A
     C**********         MOVEL     'N'           OKACSQ                           AR801992 AR952677A
     C**********         MOVEL     'N'           OKBRCA                           AR801992 AR952677A
     C**********         ADD       1             Ix                               AR801992 AR952677A
     C**********         MOVEL     'IBAN'        FldNameArr(Ix)                   AR801992 AR952677A
     C**********         MOVEL     'RE77102'     MsgIdArr(Ix)                     AR801992 AR952677A
     C**********         MOVEL     LNRF          MsgDtaArr(Ix)                    AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         ENDIF                                                    AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      ***Chain*to*CLOAN**for*extended*details.*************************           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****LNRF          CHAIN     CLOAN                              77          AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C******IN77         IFEQ      *OFF                                           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****RRST          IFEQ      14                                             AR801992 AR952677A
     C*****RRON          ANDEQ     XACCNT                                         AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      ***Pay*Settlement*Method*=*'14'.*********************************           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****RPST          OREQ      14                                             AR801992 AR952677A
     C*****RPON          ANDEQ     XACCNT                                         AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      ***Rollover*Settlement*Type*=*'14'.******************************           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****RDST          OREQ      14                                             AR801992 AR952677A
     C*****ORVD          ANDEQ     XACCNT                                         AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      ***Rollover*Pay*Settlement*Method*=*'14'.************************           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****RPSM          OREQ      14                                             AR801992 AR952677A
     C*****RPOS          ANDEQ     XACCNT                                         AR801992 AR952677A
     C**********         MOVEL     'N'           OKCNUM                           AR801992 AR952677A
     C**********         MOVEL     'N'           OKCCY                            AR801992 AR952677A
     C**********         MOVEL     'N'           OKACOD                           AR801992 AR952677A
     C**********         MOVEL     'N'           OKACSQ                           AR801992 AR952677A
     C**********         MOVEL     'N'           OKBRCA                           AR801992 AR952677A
     C**********         ADD       1             Ix                               AR801992 AR952677A
     C**********         MOVEL     'IBAN'        FldNameArr(Ix)                   AR801992 AR952677A
     C**********         MOVEL     'RE77102'     MsgIdArr(Ix)                     AR801992 AR952677A
     C**********         MOVEL     LNRF          MsgDtaArr(Ix)                    AR801992 AR952677A
     C**********         ENDIF                                                    AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         ENDIF                                                    AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         ENDIF                                                    AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         READ      CLOANLB                                76      AR801992 AR952677A
     C**********         ENDDO                                                    AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         MOVE      IN76          *IN76             1              AR801992 AR952677A
     C**********         MOVE      IN77          *IN77             1              AR801992 AR952677A
     C**********         MOVE      CLOAN1        CLOAL#                           AR801992 AR952677A
     C**********         MOVE      CLOAN2        CLOAK#                           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
      ***Check*if*account*is*still*used*by*outstanding*fees.***********           AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C******LOVAL        SETLL     LEFEEDF                                        AR801992 AR952677A
     C**********         READ      LEFEEDF                                78      AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C******IN78         DOWEQ     '0'                                            AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C*****FERECI        IFEQ      'D'                                            AR801992 AR952677A
     C*****FESTTL        ANDEQ     14                                             AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         MOVEL     FEOURS        WACNO            10 0            AR801992 AR952677A
     C*****WACNO         IFEQ      A1ACNO                                         AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         MOVEL     FECNUM        WTMP7             7              AR801992 AR952677A
     C**********         MOVE      '/'           WTMP7                            AR801992 AR952677A
     C**********         MOVEL     'N'           OKCNUM                           AR801992 AR952677A
     C**********         MOVEL     'N'           OKCCY                            AR801992 AR952677A
     C**********         MOVEL     'N'           OKACOD                           AR801992 AR952677A
     C**********         MOVEL     'N'           OKACSQ                           AR801992 AR952677A
     C**********         MOVEL     'N'           OKBRCA                           AR801992 AR952677A
     C**********         ADD       1             Ix                               AR801992 AR952677A
     C**********         MOVEL     'IBAN'        FldNameArr(Ix)                   AR801992 AR952677A
     C*****FEFACL        IFGT      0                                              AR801992 AR952677A
     C**********         MOVEL     'RE77103'     MsgIdArr(Ix)                     AR801992 AR952677A
     C**********         MOVEL     WTMP7         WTMP12           12              AR801992 AR952677A
     C**********         MOVE      FEFACL        WTMP12                           AR801992 AR952677A
     C**********         MOVEL     WTMP12        WTMP13           13              AR801992 AR952677A
     C**********         MOVE      '/'           WTMP13                           AR801992 AR952677A
     C**********         MOVEL     WTMP13        WTMP15           15              AR801992 AR952677A
     C**********         MOVE      FEFSEQ        WTMP15                           AR801992 AR952677A
     C**********         MOVEL     WTMP15        MsgDtaArr(Ix)                    AR801992 AR952677A
     C**********         ELSE                                                     AR801992 AR952677A
     C**********         MOVEL     'RE77104'     MsgIdArr(Ix)                     AR801992 AR952677A
     C**********         MOVEL     WTMP7         WTMP13                           AR801992 AR952677A
     C**********         MOVE      FELOAN        WTMP13                           AR801992 AR952677A
     C**********         MOVEL     WTMP13        WTMP14           14              AR801992 AR952677A
     C**********         MOVE      '/'           WTMP14                           AR801992 AR952677A
     C**********         MOVEL     WTMP14        WTMP16           16              AR801992 AR952677A
     C**********         MOVE      FEFSEQ        WTMP16                           AR801992 AR952677A
     C**********         MOVEL     WTMP16        MsgDtaArr(Ix)                    AR801992 AR952677A
     C**********         ENDIF                                                    AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         ENDIF                                                    AR801992 AR952677A
     C**********         ENDIF                                                    AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A
     C**********         READ      LEFEEDF                                78      AR801992 AR952677A
     C**********         ENDDO                                                    AR801992 AR952677A
      *****************************************************************           AR801992 AR952677A

     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT                                                                                  194431
      *****************************************************************                       194431
      * VALACR - VALIDATION OF ACTION CODE 'R'                                                194431
      *****************************************************************                       194431
     C     VALACR        BEGSR                                                                194431
      *                                                                                       194431
      ** Check if the Account Code is defined in the Default Retail                           194431
      ** Accounts.                                                                            194431
      *                                                                                       194431
     C                   MOVE      DDACOD        WWACOD                                       194431
     C                   MOVE      'D'           WWRECI                                       194431
      *                                                                                       194431
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   MOVE      DDCCY         WWACCY                                       CRE030
     C     ACODK2        CHAIN     REDEFDF                            50                      CRE030
     C                   ELSE                                                                 CRE030
     C*****ACODK         CHAIN     REDEF                              50               194431 CRE030
     C     ACODK         CHAIN     REDEFDF                            50                      CRE030
     C                   ENDIF                                                                CRE030
      *                                                                                       194431
     C     *IN50         IFEQ      '0'                                                        194431
     C     X_RECI        ANDEQ     'D'                                                        194431
      *                                                                                       194431
     C*****X_CNUM        IFEQ      *ZEROS                                              194431 CSD027
     C     X_CNUM        IFEQ      *BLANKS                                                    CSD027
      *                                                                                       194431
     C     X_RETN        CHAIN     ACNUM                              50                      194431
     C     *IN50         IFEQ      '0'                                                        194431
     C                   MOVE      Y_CNUM        KCNUM                                        194431
     C                   MOVE      Y_CCY         KCCY                                         194431
     C                   MOVE      Y_ACOD        KACOD                                        194431
     C                   MOVE      Y_ACSQ        KACSQ                                        194431
     C                   MOVE      Y_BRCA        KBRCA                                        194431
     C     CHKACC        CHAIN     ACCNTL1                            50                      194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
     C                   ELSE                                                                 194431
     C                   MOVE      X_CNUM        KCNUM                                        194431
     C                   MOVE      X_RCCY        KCCY                                         194431
     C                   MOVE      X_ACOD        KACOD                                        194431
     C                   MOVE      X_SEQR        KACSQ                                        194431
     C                   MOVE      X_BRCA        KBRCA                                        194431
     C     CHKACC        CHAIN     ACCNTL1                            50                      194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
      ** Access Customer details of Default Account                                           194431
      *                                                                                       194431
     C                   MOVE      A1CNUM        WCNUM             6                          194431
     C                   CALLB     'AOCUSTR0'                                                 194431
     C                   PARM      *BLANKS       @RTCD                                        194431
     C                   PARM      '*KEY   '     @OPTN                                        194431
     C                   PARM      WCNUM         @CNUM            10                          194431
     C                   PARM                    @CNST             7                          194431
     C     SDCUST2       PARM      SDCUST2       DSSDY                                        194431
      *                                                                                       194431
      ** Not Found                                                                            194431
      *                                                                                       194431
     C     @RTCD         IFNE      *BLANKS                                                    194431
     C     BBDTDL        ORNE      *ZERO                                                      194431
     C                   MOVEL     'N'           OKCNUM                                       194431
     C                   ADD       1             Ix                                           194431
     C                   MOVEL     'A1CNUM'      FldNameArr(Ix)                               194431
     C                   MOVEL     'RE71031'     MsgIdArr(Ix)                                 194431
     C                   END                                                                  194431
      *                                                                                       194431
      *  *-----------------------------------------------*                                    194431
      *  * Get Account Extension Details (if present)    *                                    194431
      *  *-----------------------------------------------*                                    194431
      *                                                                                       194431
     C     CHKACC        CHAIN     ACCNTBY0                           56                      194431
     C     *IN56         IFEQ      '1'                                                        194431
     C                   CLEAR                   ExBXFilFmt                                   194431
     C                   ENDIF                                                                194431
     C     CHKACC        CHAIN     REIACXX                            56                      194431
     C     *IN56         IFEQ      '1'                                                        194431
     C                   CLEAR                   ExRIFilFmt                                   194431
     C                   ENDIF                                                                194431
     C     CHKACC        CHAIN     REAPWDL1                           56                      194431
     C     *IN56         IFEQ      '1'                                                        194431
     C                   CLEAR                   ExPWFilFmt                                   194431
     C                   ENDIF                                                                194431
     C     CHKCOM        CHAIN     RECOMXX                            56                      194431
     C     *IN56         IFEQ      '1'                                                        194431
     C     WDCCY         ORNE      A1CCY                                                      194431
     C     X_BBCGRP      ORNE      BBCGRP                                                     194431
     C                   CLEAR                   ExCOFilFmt                                   194431
     C                   ENDIF                                                                194431
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                   EXSR      SRPPDetails                                                CRE015
     C                   ENDIF                                                                CRE015
     C/COPY OFCPYSRCZ,CRE101_024                                                              CRE101
      *                                                                                       194431
      ** Reinitialize fields which are supposed to be reset                                   194431
      *                                                                                       194431
     C                   MOVE      *BLANKS       B1ATCHIN                                     194431
     C                   MOVE      *BLANKS       B1ATCHAM                                     194431
     C                   MOVE      *BLANKS       B1ATAODR                                     194431
     C                   MOVE      *BLANKS       B1ATORTC                                     194431
     C                   MOVE      *BLANKS       B1ATPOLC                                     194431
     C                   MOVE      *BLANKS       B1ATPOLE                                     194431
     C                   MOVE      *BLANKS       C1DACP                                       194431
     C                   MOVE      *BLANKS       C1DRBR                                       194431
     C                   MOVE      *BLANKS       C1CACP                                       194431
     C                   MOVE      *BLANKS       C1CRBR                                       194431
     C                   MOVE      *BLANKS       C1CHAC                                       194431
     C                   MOVE      *BLANKS       C1CHBR                                       194431
     C                   MOVE      *BLANKS       A1OLCR                                       194431
     C                   MOVE      *BLANKS       A1OLDR                                       194431
      *                                                                                       194431
      ** Check the overdraft value dates/expiry date                                          194431
      *                                                                                       194431
     C     A1ODED        IFNE      *ZEROS                                                     194431
     C     A1ODED        ANDGT     BJRDNB                                                     194431
     C     WDCCY         ANDEQ     A1CCY                                                      194431
     C     B1ATITRD      IFNE      *ZEROS                                                     194431
     C     B1ATITRD      ANDLE     BJRDNB                                                     194431
     C     1             ADD       BJRDNB        B1ATITRD                                     194431
     C                   ENDIF                                                                194431
     C     B1ATOLVD      IFNE      *ZEROS                                                     194431
     C     B1ATOLVD      ANDLT     A1DACO                                                     194431
     C                   EVAL      B1ATOLVD=A1DACO                                            194431
     C                   ENDIF                                                                194431
     C                   ELSE                                                                 194431
     C                   MOVE      *BLANKS       A1ODED                                       194431
     C                   MOVE      *BLANKS       A1ODSC                                       194431
     C                   MOVE      *BLANKS       A1ODLN                                       194431
     C                   MOVE      *BLANKS       B1ATITRD                                     194431
     C                   MOVE      *BLANKS       B1ATOLVD                                     194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
      ** If New currency is different from reference account, check for                       194431
      ** default values in New currency.                                                      194431
      *                                                                                       194431
      ** Check for Base rate codes.                                                           194431
      *                                                                                       194431
     C                   MOVE      A1DRIB        WWDRIB            2                          194431
     C     A1DRIB        IFNE      *ZERO                                                      194431
     C     WDCCY         ANDNE     A1CCY                                                      194431
     C                   CALLB     'AOBSRTR0'                                                 194431
     C                   PARM      '*MSG   '     @RTCD                                        194431
     C                   PARM      '*KEY   '     @OPTN                                        194431
     C                   PARM      WDCCY         @CYCD             3                          194431
     C                   PARM      WWDRIB        @BSRC             2                          194431
     C     SDBSRT        PARM      SDBSRT        DSFDY                                        194431
     C                   ENDIF                                                                194431
     C     @RTCD         IFNE      *BLANKS                                                    194431
     C                   MOVE      *ZERO         A1DRIB                                       194431
     C                   MOVE      *ZERO         A1DRIS                                       194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
     C     A1CRIB        IFNE      *ZERO                                                      194431
     C     WDCCY         ANDNE     KCCY                                                       194431
     C                   MOVE      A1CRIB        WWCRIB            2                          194431
     C                   CALLB     'AOBSRTR0'                                                 194431
     C                   PARM      '*MSG   '     @RTCD                                        194431
     C                   PARM      '*KEY   '     @OPTN                                        194431
     C                   PARM      WDCCY         @CYCD             3                          194431
     C                   PARM      WWCRIB        @BSRC             2                          194431
     C     SDBSRT        PARM      SDBSRT        DSFDY                                        194431
     C                   ENDIF                                                                194431
     C     @RTCD         IFNE      *BLANKS                                                    194431
     C                   MOVE      *ZERO         A1CRIB                                       194431
     C                   MOVE      *ZERO         A1CRIS                                       194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
      ** Check for Interest Capitalisation type/subtype                                       194431
      *                                                                                       194431
     C     C1DICT        IFNE      *ZERO                                                      194431
     C     C1DCST        ANDNE     *ZERO                                                      194431
     C                   MOVE      C1DICT        TYPE                                         194431
     C                   MOVE      C1DCST        SBTYPE                                       194431
     C                   MOVE      WDCCY         CURR              3                          194431
     C                   MOVE      'D'           d                                            194431
     C     KEY           CHAIN     REINT                              51                      194431
     C     *IN51         IFEQ      '1'                                                        194431
     C                   MOVE      *ZERO         C1DICT                                       194431
     C                   MOVE      *ZERO         C1DCST                                       194431
     C                   ENDIF                                                                194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
     C     C1CICT        IFNE      *ZERO                                                      194431
     C     C1CCST        ANDNE     *ZERO                                                      194431
     C                   MOVE      C1CICT        TYPE                                         194431
     C                   MOVE      C1CCST        SBTYPE                                       194431
     C                   MOVE      WDCCY         CURR              3                          194431
     C                   MOVE      'D'           d                                            194431
     C     KEY           CHAIN     REINT                              51                      194431
     C     *IN51         IFEQ      '1'                                                        194431
     C                   MOVE      *ZERO         C1CICT                                       194431
     C                   MOVE      *ZERO         C1CCST                                       194431
     C                   ENDIF                                                                194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
      ** Check for Interest Charge type/subtype                                               194431
      *                                                                                       194431
     C     C1CHGT        IFNE      *ZERO                                                      194431
     C     C1CHST        ANDNE     *ZERO                                                      194431
     C                   MOVE      C1CHGT        TYPE                                         194431
     C                   MOVE      C1CHST        SBTYPE                                       194431
     C                   MOVE      WDCCY         CURR              3                          194431
     C                   MOVE      'D'           d                                            194431
     C     KEY           CHAIN     RECRGDF                            51                      194431
     C     *IN51         IFEQ      '1'                                                        194431
     C                   MOVE      *ZERO         C1CHGT                                       194431
     C                   MOVE      *ZERO         C1CHST                                       194431
     C                   MOVE      *ZERO         C1TCHO                                       194431
     C                   ENDIF                                                                194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
     C                   ELSE                                                                 194431
      *                                                                                       194431
     C     CHKACC        CHAIN     ACCNTABF                           44                      194431
      *                                                                                       194431
      ** Error if present already                                                             194431
      *                                                                                       194431
     C     *IN44         IFEQ      '0'                                                        194431
     C                   MOVEL     'N'           OKCNUM                                       194431
     C                   MOVEL     'N'           OKCCY                                        194431
     C                   MOVEL     'N'           OKACOD                                       194431
     C                   MOVEL     'N'           OKACSQ                                       194431
     C                   MOVEL     'N'           OKBRCA                                       194431
     C                   ADD       1             Ix                                           194431
     C**********         MOVEL     'DDACRF'      FldNameArr(Ix)                      194431 MD024951
     C                   MOVEL     'DDACCN'      FldNameArr(Ix)                             MD024951
     C                   MOVEL     'RE71020'     MsgIdArr(Ix)                                 194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
     C                   ENDIF                                                                194431
      *                                                                                       194431
     C     EVALAR        ENDSR                                                                194431
      *****************************************************************                       194431
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      **  Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='1'or DDACTN='2'or DDACTN='3'or
     C                             DDACTN='4'or DDACTN='5'or DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C                   PARM      DDBRCA        ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='1'or DDACTN='2'or DDACTN='3'or
     C                             DDACTN='4'or DDACTN='5'or DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  SRPPDetails - Period and Penalty Details                     *                       CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     SRPPDetails   BEGSR                                                                CRE015
                                                                                              CRE015
     C                   CLEAR                   ExPPFilFmt                                   CRE015
                                                                                              CRE015
      ** Process only term and notice (period) accounts                                       CRE015
                                                                                              CRE015
     C                   MOVE      KACOD         X5ACCD                                       CRE015
     C     X5ACCD        CHAIN     SDACD1L0                                                   CRE015
     C                   IF        %FOUND(SDACD1L0)                                           CRE015
     C                             AND X5ATTY = 'P'                                           CRE015
                                                                                              CRE015
      ** Check if active or default details will be returned                                  CRE015
                                                                                              CRE015
     C     CHKCOM        SETLL     REPRPNPD                                                   CRE015
     C                   IF        %EQUAL(REPRPNPD)                                           CRE015
     C                   EXSR      SRPPActive                                                 CRE015
     C                   ELSE                                                                 CRE015
     C                   EXSR      SRPPDefault                                                CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  SRPPActive - Active Period and Penalty Details               *                       CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     SRPPActive    BEGSR                                                                CRE015
                                                                                              CRE015
      ** Clear output array                                                                   CRE015
                                                                                              CRE015
     C                   CLEAR                   REPRPN                                       CRE015
     C                   DO        26            X                                            CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
     C                   EVAL      X = 0                                                      CRE015
     C     CHKCOM        SETLL     REPRPNPD                                                   CRE015
     C     CHKCOM        READE     REPRPNPD                                                   CRE015
     C                   DOW       NOT %EOF(REPRPNPD)                                         CRE015
                                                                                              CRE015
     C                   EVAL      X = X + 1                                                  CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
                                                                                              CRE015
     C     CHKCOM        READE     REPRPNPD                                                   CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
      ** Load array to output data structure                                                  CRE015
                                                                                              CRE015
     C                   MOVEA     ArrFilBuf     ExPPFilFmt                                   CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  SRPPDefault - Default Period and Penalty Details             *                       CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     SRPPDefault   BEGSR                                                                CRE015
                                                                                              CRE015
      ** Find period details according to weight                                              CRE015
      ** 01.  ACSQ                                                                            CRE015
      ** 02.  CNUM                                                                            CRE015
      ** 04.  BRCA                                                                            CRE015
      ** 08.  CCY                                                                             CRE015
      ** 16.  ACOD                                                                            CRE015
                                                                                              CRE015
     C                   EVAL      W#FOUND = 'N'                                              CRE015
     C                   EVAL      WEIGHT = 31                                                CRE015
                                                                                              CRE015
     C                   DOW       WEIGHT >= *ZEROS                                           CRE015
     C                             AND W#FOUND = 'N'                                          CRE015
                                                                                              CRE015
     C                   EVAL      K2ACSQ = *ZEROS                                            CRE015
     C                   EVAL      K2CNUM = *BLANKS                                           CRE015
     C                   EVAL      K2BRCA = *BLANKS                                           CRE015
     C                   EVAL      K2CCY  = *BLANKS                                           CRE015
     C                   EVAL      K2ACOD = *ZEROS                                            CRE015
     C                   EVAL      K2EVNT = 'A'                                               CRE015
     C                   EVAL      K2ITEM = *ZEROS                                            CRE015
                                                                                              CRE015
      ** From left to right bit setting relates to key fields                                 CRE015
                                                                                              CRE015
     C                   TESTB     '7'           BYTE                     81                  CRE015
     C                   IF        *IN81 = *ON                                                CRE015
     C                   EVAL      K2ACSQ = KACSQ                                             CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   TESTB     '6'           BYTE                     81                  CRE015
     C                   IF        *IN81 = *ON                                                CRE015
     C                   EVAL      K2CNUM = KCNUM                                             CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   TESTB     '5'           BYTE                     81                  CRE015
     C                   IF        *IN81 = *ON                                                CRE015
     C                   EVAL      K2BRCA = KBRCA                                             CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   TESTB     '4'           BYTE                     81                  CRE015
     C                   IF        *IN81 = *ON                                                CRE015
     C                   EVAL      K2CCY = KCCY                                               CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   TESTB     '3'           BYTE                     81                  CRE015
     C                   IF        *IN81 = *ON                                                CRE015
     C                   EVAL      K2ACOD = KACOD                                             CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C     K@PRPN1       SETLL     REPRPNPD                                                   CRE015
     C     K@PRPN2       READE     REPRPNPD                                                   CRE015
     C                   IF        NOT %EOF(REPRPNPD)                                         CRE015
     C                   EVAL      W#FOUND = 'Y'                                              CRE015
     C                   ELSE                                                                 CRE015
     C                   EVAL      WEIGHT = WEIGHT - 1                                        CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
     C                   IF        W#FOUND = 'Y'                                              CRE015
     C                   EXSR      SRLoadDflt                                                 CRE015
     C                   ELSE                                                                 CRE015
     C                   EXSR      SRForceDflt                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  SRLoadDflt - Load Default Details from File                  *                       CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     SRLoadDflt    BEGSR                                                                CRE015
                                                                                              CRE015
      ** Clear output array                                                                   CRE015
                                                                                              CRE015
     C                   CLEAR                   REPRPN                                       CRE015
     C                   DO        26            X                                            CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
     C                   EVAL      X = 0                                                      CRE015
     C                   EVAL      MAINT = '*NEW'                                             CRE015
     C                   EVAL      PRCEDE = BJRDNB                                            CRE015
                                                                                              CRE015
     C     K@PRPN1       SETLL     REPRPNPD                                                   CRE015
     C     K@PRPN2       READE     REPRPNPD                                                   CRE015
     C                   DOW       NOT %EOF(REPRPNPD)                                         CRE015
                                                                                              CRE015
     C                   EVAL      X = X + 1                                                  CRE015
     C                   EVAL      E2BRCA = KBRCA                                             CRE015
     C                   EVAL      E2CNUM = KCNUM                                             CRE015
     C                   EVAL      E2CCY  = KCCY                                              CRE015
     C                   EVAL      E2ACOD = KACOD                                             CRE015
     C                   EVAL      E2ACSQ = KACSQ                                             CRE015
     C                   IF        E2CEDE = 0                                                 CRE015
     C                   EVAL      E2CEDE = 1                                                 CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** Calculate event dates                                                                CRE015
                                                                                              CRE015
     C                   EXSR      SRCalDat                                                   CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
                                                                                              CRE015
     C     K@PRPN2       READE     REPRPNPD                                                   CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
      ** Load array to output data structure                                                  CRE015
                                                                                              CRE015
     C                   MOVEA     ArrFilBuf     ExPPFilFmt                                   CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  SRForceDflt - Create Default Details for the Account         *                       CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     SRForceDflt   BEGSR                                                                CRE015
                                                                                              CRE015
      ** Clear output array                                                                   CRE015
                                                                                              CRE015
     C                   CLEAR                   REPRPN                                       CRE015
     C                   DO        26            X                                            CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
     C                   EVAL      MAINT = '*NEW'                                             CRE015
     C                   EVAL      PRCEDE = BJRDNB                                            CRE015
                                                                                              CRE015
      ** Create initial period                                                                CRE015
                                                                                              CRE015
     C                   EVAL      E2BRCA = KBRCA                                             CRE015
     C                   EVAL      E2CNUM = KCNUM                                             CRE015
     C                   EVAL      E2CCY  = KCCY                                              CRE015
     C                   EVAL      E2ACOD = KACOD                                             CRE015
     C                   EVAL      E2ACSQ = KACSQ                                             CRE015
     C                   EVAL      E2EVNT = 'A'                                               CRE015
     C                   EVAL      E2ITEM = 1                                                 CRE015
     C                   EVAL      E2VDAT = 0                                                 CRE015
     C                   EVAL      E2MDAT = 364                                               CRE015
     C                   EVAL      E2CEDE = 1                                                 CRE015
     C                   EVAL      E2NDPD = 365                                               CRE015
     C                   EVAL      E2IRLI = 'F'                                               CRE015
     C                   EVAL      E2TPRD = 'T'                                               CRE015
     C                   EVAL      E2DRIC = 1                                                 CRE015
     C                   EVAL      E2DNIR = 'D'                                               CRE015
     C                   EVAL      E2DRIF = 'Z'                                               CRE015
     C                   EVAL      E2CRIC = 1                                                 CRE015
     C                   EVAL      E2CNIR = 'D'                                               CRE015
     C                   EVAL      E2CRIF = 'Z'                                               CRE015
     C                   EVAL      E2NDID = 26664                                             CRE015
     C                   EVAL      E2NCID = 26664                                             CRE015
                                                                                              CRE015
      ** Calculate event dates                                                                CRE015
                                                                                              CRE015
     C                   EXSR      SRCalDat                                                   CRE015
     C                   EVAL      ArrFilBuf(1) = REPRPN                                      CRE015
                                                                                              CRE015
      ** Create termination record                                                            CRE015
                                                                                              CRE015
     C                   EVAL      E2BRCA = KBRCA                                             CRE015
     C                   EVAL      E2CNUM = KCNUM                                             CRE015
     C                   EVAL      E2CCY  = KCCY                                              CRE015
     C                   EVAL      E2ACOD = KACOD                                             CRE015
     C                   EVAL      E2ACSQ = KACSQ                                             CRE015
     C                   EVAL      E2EVNT = 'Z'                                               CRE015
     C                   EVAL      E2ITEM = 1                                                 CRE015
     C                   EVAL      E2VDAT = 25204                                             CRE015
     C                   EVAL      E2MDAT = 26664                                             CRE015
     C                   EVAL      E2CEDE = 26664                                             CRE015
     C                   EVAL      E2NDPD = 0                                                 CRE015
     C                   EVAL      E2IRLI = 'F'                                               CRE015
     C                   EVAL      E2TPRD = 'T'                                               CRE015
     C                   EVAL      E2DRIC = 1                                                 CRE015
     C                   EVAL      E2DNIR = 'D'                                               CRE015
     C                   EVAL      E2DRIF = 'M'                                               CRE015
     C                   EVAL      E2CRIC = 1                                                 CRE015
     C                   EVAL      E2CNIR = 'D'                                               CRE015
     C                   EVAL      E2CRIF = 'M'                                               CRE015
     C                   EVAL      E2NDID = 26664                                             CRE015
     C                   EVAL      E2DRDY = 3101                                              CRE015
     C                   EVAL      E2NCID = 26664                                             CRE015
     C                   EVAL      E2CRDY = 3101                                              CRE015
                                                                                              CRE015
      ** Calculate event dates                                                                CRE015
                                                                                              CRE015
     C                   EXSR      SRCalDat                                                   CRE015
     C                   EVAL      ArrFilBuf(2) = REPRPN                                      CRE015
                                                                                              CRE015
      ** Load array to output data structure                                                  CRE015
                                                                                              CRE015
     C                   MOVEA     ArrFilBuf     ExPPFilFmt                                   CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  SRCalDat - Calculate Event Dates                             *                       CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     SRCalDat      BEGSR                                                                CRE015
                                                                                              CRE015
     C                   MOVE      BJRDNB        RUNCHG                                       CRE015
                                                                                              CRE015
     C                   CALL      'RETNDAT1'                                                 CRE015
     C                   PARM                    REPRPN                                       CRE015
     C                   PARM                    MAINT                                        CRE015
     C                   PARM                    RUNCHG                                       CRE015
     C                   PARM                    PRCEDE                                       CRE015
     C                   PARM      *BLANKS       PRTCD                                        CRE015
                                                                                              CRE015
     C                   IF        PRTCD <> *BLANKS                                           CRE015
     C                   EVAL      DBFILE = 'RETNDAT1'                                        CRE015
     C                   EVAL      DBKEY  = '*CALL'                                           CRE015
     C                   EVAL      DBASE  = 3                                                 CRE015
     C                   EXSR      *PSSR                                                      CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
     C                   CLEAR                   AccnFilFmt
     C                   CLEAR                   ExBXFilFmt
     C                   CLEAR                   ExRIFilFmt
     C                   CLEAR                   ExCOFilFmt
     C                   CLEAR                   ExPWFilFmt
     C                   CLEAR                   ExPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_019                                                              CRE101
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKCNUM
     C                   MOVEL     'Y'           OKCCY
     C                   MOVEL     'Y'           OKACOD
     C                   MOVEL     'Y'           OKACSQ
     C                   MOVEL     'Y'           OKBRCA
     C                   MOVEL     'Y'           OKACNO
      *
      ** Set up the keylist to check for existence of account.
      *
     C**********         Z-ADD     *ZERO         KCNUM                                        CSD027
     C                   EVAL      KCNUM = *BLANKS                                            CSD027
     C                   MOVE      *BLANKS       KCCY
     C                   Z-ADD     *ZERO         KACOD
     C                   Z-ADD     *ZERO         KACSQ
     C                   MOVE      *BLANKS       KBRCA
     C                   MOVEL     DDCUSN        KCNUM
     C                   MOVEL     DDCCY         KCCY
     C                   MOVEL     DDACOD        KACOD
     C                   MOVEL     DDACSQ        KACSQ
     C                   MOVEL     DDBRCA        KBRCA
      ** Set up the keylist to check for existence of account and
      ** Extension files ACCNTBXC, REIACD, REAPWDPD
     C     CHKACC        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
      ** Key list for extension file RECOMPD
     C     CHKCOM        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
      *                                                                                       194431
      ** Key list for Retail Default file                                                     194431
      *                                                                                       194431
     C     ACODK         KLIST                                                                194431
     C**********         KFLD                    WWACOD            4 0                 194431 CGL029
     C                   KFLD                    WWACOD                                       CGL029
     C                   KFLD                    WWRECI            1                          194431
      *                                                                                       CRE030
     C     ACODK2        KLIST                                                                CRE030
     C                   KFLD                    WWACOD                                       CRE030
     C                   KFLD                    WWRECI                                       CRE030
     C                   KFLD                    WWACCY            3                          CRE030
                                                                                              CRE015
     C     K@PRPN1       KLIST                                                                CRE015
     C                   KFLD                    K2BRCA                                       CRE015
     C                   KFLD                    K2CNUM                                       CRE015
     C                   KFLD                    K2CCY                                        CRE015
     C                   KFLD                    K2ACOD                                       CRE015
     C                   KFLD                    K2ACSQ                                       CRE015
     C                   KFLD                    K2EVNT                                       CRE015
     C                   KFLD                    K2ITEM                                       CRE015
                                                                                              CRE015
     C     K@PRPN2       KLIST                                                                CRE015
     C                   KFLD                    K2BRCA                                       CRE015
     C                   KFLD                    K2CNUM                                       CRE015
     C                   KFLD                    K2CCY                                        CRE015
     C                   KFLD                    K2ACOD                                       CRE015
     C                   KFLD                    K2ACSQ                                       CRE015
      *
     C                   ENDSR
      ********************************************************************
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
     C**********         PARM                    FOTRID           20                          CGL029
     C                   PARM                    FOTRID           40                          CGL029
      *
      * (Midas) Account Reference
     C                   PARM                    DDCUSN            6
     C                   PARM                    DDCCY             3
     C**********         PARM                    DDACOD            4                          CGL029
     C                   PARM                    DDACOD                                       CGL029
     C                   PARM                    DDACSQ            2
     C                   PARM                    DDBRCA            3
     C                   PARM                    DDACNO           10
      * Commissions
     C                   PARM                    CommDisp          1
      * IBAN                                                                    CFT004
     C                   PARM                    CFT004            1            CFT004
     C                   PARM                    DDIBAN           34                          238839
     C                   PARM                    CRE015            1                          CRE015
     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
      *                                                                                       194431
      ** New Accounts Currency                                                                194431
      *                                                                                       194431
     C                   PARM                    WDCCY             3                          194431
      *
      * OUTPUTS
      *
      * (Current) trade in file format
      * (Current) trade extension in file format
     C                   PARM                    AccnFilFmt
     C                   PARM                    ExBXFilFmt
     C                   PARM                    ExRIFilFmt
     C                   PARM                    ExCOFilFmt
     C                   PARM                    ExPWFilFmt
     C                   PARM                    ExPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_014                                                              CRE101
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      * OK - Account Reference
     C                   PARM                    OKCNUM            1
     C                   PARM                    OKCCY             1
     C                   PARM                    OKACOD            1
     C                   PARM                    OKACSQ            1
     C                   PARM                    OKBRCA            1
     C                   PARM                    OKACNO            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      * Base Rate Auth Req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
      ** Initialize program name
      *
     C                   MOVEL     'GLAMADRTV'   DBPGM
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
      *
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
      ** ACCESS MIDAS MODULES DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MIDAS RETAIL DETAILS
     C                   IF        BGRTBN='Y'
      *
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDRETLPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   ENDIF
      *                                                                                       CRE030
      ** Check if feature CRE030 is active                                                    CRE030
      *                                                                                       CRE030
     C                   CALL      'AOSARDR0'                                                 CRE030
     C                   PARM      '       '     @RTCD             7                          CRE030
     C                   PARM      '*VERIFY'     @OPTN             7                          CRE030
     C                   PARM      'CRE030'      @SARD             6                          CRE030
     C*                                                                                       CRE030
     C                   IF        @RTCD = *BLANKS                                            CRE030
     C                   MOVE      'Y'           CRE030            1                          CRE030
     C                   ELSE                                                                 CRE030
     C                   MOVE      'N'           CRE030                                       CRE030
     C                   ENDIF                                                                CRE030
                                                                                              CGL062
     C** Obtain System Value Modulus11lChk                                                    CGL062
     C                   Eval      P@Op01 = 'Modulus11Chk'                                    CGL062
                                                                                              CGL062
     C                   Call      'AOSVALR0'                                                 CGL062
     C                   Parm      *Blanks       P@Rtcd                                       CGL062
     C                   Parm                    P@Op01                                       CGL062
     C                   Parm      *Blanks       P@Vl01                                       CGL062
     C                   Parm      *Blanks       P@Op02                                       CGL062
     C                   Parm      *Blanks       P@Vl02                                       CGL062
     C                   Parm      *Blanks       P@Op03                                       CGL062
     C                   Parm      *Blanks       P@Vl03                                       CGL062
     C                   Parm      *Blanks       P@Op04                                       CGL062
     C                   Parm      *Blanks       P@Vl04                                       CGL062
     C                   Parm      *Blanks       P@Op05                                       CGL062
     C                   Parm      *Blanks       P@Vl05                                       CGL062
     C                   Parm      *Blanks       P@Op06                                       CGL062
     C                   Parm      *Blanks       P@Vl06                                       CGL062
     C                   Parm      *Blanks       P@Op07                                       CGL062
     C                   Parm      *Blanks       P@Vl07                                       CGL062
     C                   Parm      *Blanks       P@Op08                                       CGL062
     C                   Parm      *Blanks       P@Vl08                                       CGL062
     C                   Parm      *Blanks       P@Op09                                       CGL062
     C                   Parm      *Blanks       P@Vl09                                       CGL062
     C                   Parm      *Blanks       P@Op10                                       CGL062
     C                   Parm      *Blanks       P@Vl10                                       CGL062
                                                                                              CGL062
      **  If the Return Code is blank, set Modulus 11 Check Flag                              CGL062
     C                   If        P@Rtcd = *Blanks                                           CGL062
     C                   Eval      Mod11Chk = P@Vl01                                          CGL062
     C                   EndIf                                                                CGL062
      *
     C/COPY WNCPYSRC,GLAMADIC01
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C***/COPY ZACPYSRC,PSSR_ILE                                                              CRE101
     C/COPY ZACPYSRC,PSSR_ILEB                                                                CRE101
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
