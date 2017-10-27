     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Credit Lines Trans Facility History Proc')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000030 - Credit Lines Transaction Facility History         *
      *             Processing                                        *
      *                                                               *
      *  Function:  This module will process all non-Lending          *
      *             transactions linked to facilities in order to     *
      *             generate facility history actions for those       *
      *             transactions on a daily basis.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. MD023117           Date 13Jan15               *
      *                 MD026331           Date 13Jan15               *
      *                 MD026337           Date 13Jan15               *
      *                 CRE095             Date 25Apr14               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 MD020170           Date 24Apr13               *
      *                 AR1023928A         Date 07Jan13               *
      *                 253231             Date 07Jan13               *
      *                 CLE148             Date 23Jul12               *
      *                 AR788404           Date 21Jun11               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CER042             Date 11May11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 09Feb10               *
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11624           Date 28Jun06               *
      *                 BUG8222            Date 23Sep05               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8262            Date 29Aug05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6138            Date 02Mar05               *
      *                 CLE041             Date 11Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE040             Date 05Jul04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG4405            Date 12Oct04               *
      *                 BUG4377            Date 01Oct04               *
      *                 BUG3934            Date 05Aug04               *
      *                 BUG3035            Date 03Jun04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  MD023117 - Double postings of S1 event on a rollover deal.   *
      *             Ensure that only one S1 event will be created.    *
      *  MD026331 - Missing AS record in FACHISA. Write FACACT record *
      *  MD026337 - Wrong Branch in FACACT for CA facility            *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  MD020170 - Error in LE000030 00001                           *
      *  AR1023928A - Contingent entry for facility linked to retail  *
      *               account produces extra repayment account key.   *
      *               Reverse fix 253231 & instead apply part of fixes*
      *               AR669446, AR669446A and AR669447 to correct AS  *
      *               and AC movements. (Child: AR1023929A)           *
      *  253231 - Contingent entry for facility linked to retail acct *
      *           produces extra repayment account key. Prevent       *
      *           generation of account key if action amount is zero. *
      *         - Applied for AR1023928 (Child: AR1023929)            *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR788404 - Component failed due to DBASE 004 in file PEFCLFM.*
      *             Suppress DB error when facility is not in PEFCLFM.*
      *             (Child: AR788405)                                 *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11624 - LEC000030 00001, DB error encountered             *
      *  BUG8222 - If event date is earlier than take-on date, use    *
      *            take-on date instead. This is only for facilities  *
      *            existing prior to M+.                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG8262 - Do not generate any facility history event if      *
      *            event amount is zero.                              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG6138 - WRcvStr has a varying length, ensure that it has   *
      *            correct length during %SUBST operation.            *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  BUG3644 - Serious Error in Collateralised Lending            *
      *  BUG4405 - COB report shows calculator errors                 *
      *  BUG4377- DBASE error 1 in LER032 due to incorrect branch code*
      *           defined in FACACT file for Facility Attached to an  *
      *           a/c with branch code not equal to the facility      *
      *           branch code.                                        *
      *  BUG3934 - Reversal of BUG3035 in LE000030 report was         *
      *            removed                                            *
      *  BUG3035 - Error on calculation when a rate change is done    *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
     FDLDLDBL1  IF   E           K DISK    INFSR(*PSSR)
     FDLDLDCL1  IF   E           K DISK    INFSR(*PSSR)
     FDLDLDGLE  IF   E           K DISK    INFSR(*PSSR)
     FDLDEALL5  UF   E           K DISK    INFSR(*PSSR)
     FACCNTJ0   IF   E           K DISK    INFSR(*PSSR)
     FGLACNTL3  UF   E           K DISK    INFSR(*PSSR)
     FDKEYSDP   IF   E             DISK    INFSR(*PSSR)
     FFCLTYL3   IF   E           K DISK    INFSR(*PSSR)
     FFACHSAL4  IF   E           K DISK    INFSR(*PSSR)
     FFACHSAL5  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FACHISAF:FACHISA5)
     FDLFXMRL0  UF A E           K DISK    INFSR(*PSSR)
     FPEFCLFL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFMP)
     FFACACTL1  UF A E           K DISK    INFSR(*PSSR)
     FFACHISHL  UF   E           K DISK    INFSR(*PSSR)
     F***APOSTJ0   IF   E           K DISK    INFSR(*PSSR)                                AR1023928A
     FAPOSTJ2   IF   E           K DISK    INFSR(*PSSR)                                   AR1023928A
     F                                     RENAME(APOSTPDF:APOSTJD0)                      AR1023928A
     FRSACMTL3  IF   E           K DISK    INFSR(*PSSR)
     FHISACT    O    E             DISK    INFSR(*PSSR)
     FLE000030P1O    E             PRINTER INFDS(SPOOL1)  USROPN
     FLE000030P2O    E             PRINTER INFDS(SPOOL2)  USROPN
     FDEALSC    IF   E           K DISK    INFSR(*PSSR)                                     MD023117
     F                                     RENAME(DEALSDCF:DEALSDCFL1)                      MD023117
     F                                     PREFIX(DC_)                                      MD023117
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** | Automatically included D-specs       |
      ** | ==============================       |
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area Giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** | End of automatically included D-specs|
      ** | =====================================|
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** | Manually included D-specs            |
      ** | =========================            |
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** | Named constants                      |
      ** | ===============                      |
      ** +--------------------------------------+
 
     D WRPG            C                   CONST('rpg')
 
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
 
     D ArrUPPER        S              1    CTDATA DIM(26) PERRCD(26)
     D ArrLOWER        S              1    CTDATA DIM(26) PERRCD(26)
 
     D WSystem         DS
     D   WChar1                1      1
     D   WChar2                2      2
 
     D WACKEY          DS
     D   WMMEVNT               1      2
     D   WACKEY3               3      3
     D   WACKEY9               9      9
     D   WACKEY0              10     10
     D   WACKEYL               9     10
 
     D WFACILTY        DS
     D***WCUST**               1      6S 0                                                    CSD027
     D   WCUST                 1      6A                                                      CSD027
     D   WFCLT                 7      9S 0
     D   WFCSQ                10     11S 0
 
     D WDBKEY          DS
     D***WFCNUM*               1      6S 0                                                    CSD027
     D   WFCNUM                1      6A                                                      CSD027
     D   WFFACT                7      9S 0
     D   WFFCNO               10     11S 0
 
     D WDBKEY2         DS
     D***WACCNUM               1      6S 0                                                    CSD027
     D   WACCNUM               1      6A                                                      CSD027
     D   KACCCY                7      9
     D   WACACOD              10     19S 0
     D   WACACSQ              20     21S 0
     D   KACBRCA              22     24
 
     D WCOMPARE1       DS
     D***WCOMPF1               1      6S 0                                                    CSD027
     D   WCOMPF1               1      6A                                                      CSD027
     D   WCOMPF2               7     11S 0
 
     D WCOMPARE2       DS
     D***WCOMPFA               1      6S 0                                                    CSD027
     D   WCOMPFA               1      6A                                                      CSD027
     D   WCOMPFB               7     11S 0
 
     D WCOMPACC1       DS
     D   WCOMAC1                           LIKE(CNUM)
     D   WCOMAC2                           LIKE(CCY)
     D   WCOMAC3                           LIKE(APACOD)
     D   WCOMAC4                           LIKE(ACSQ)
     D   WCOMAC5                           LIKE(BRCA)
 
     D WCOMPACC2       DS
     D   WCOMACA                           LIKE(CNUM)
     D   WCOMACB                           LIKE(CCY)
     D   WCOMACC                           LIKE(APACOD)
     D   WCOMACD                           LIKE(ACSQ)
     D   WCOMACE                           LIKE(BRCA)
 
     D WCOMPFAC1       DS
     D   WCOMFC1                           LIKE(FACNUM)
     D   WCOMFC2                           LIKE(FAFCTY)
     D   WCOMFC3                           LIKE(FAACCU)
     D   WCOMFC4                           LIKE(FAACCY)
     D   WCOMFC5                           LIKE(FAACCD)
     D   WCOMFC6                           LIKE(FAACSQ)
     D   WCOMFC7                           LIKE(FAACBR)
 
     D WCOMPFAC2       DS
     D   WCOMFCA                           LIKE(FACNUM)
     D   WCOMFCB                           LIKE(FAFCTY)
     D   WCOMFCC                           LIKE(FAACCU)
     D   WCOMFCD                           LIKE(FAACCY)
     D   WCOMFCE                           LIKE(FAACCD)
     D   WCOMFCF                           LIKE(FAACSQ)
     D   WCOMFCG                           LIKE(FAACBR)
 
     D WACCOUNT        DS
     D  RCUST                  1      6
     D  RDASH1                 7      7
     D  RCCY                   8     10
     D  RDASH2                11     11
     D  RACOD                 12     21
     D  RDASH3                22     22
     D  RACSQ                 23     24
     D  RDASH4                25     25
     D  RBRCA                 26     28
 
     D WFCLTY          DS
     D  RFCCU                  1      6
     D  RDASH5                 7      7
     D  RFACT                  8     10
     D  RDASH6                11     11
     D  RFCNO                 12     13
 
     D SPOOL1          DS
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOL2          DS
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA
     D LERSTS        E DS                  EXTNAME(LERSTS) DTAARA                            BUG8222
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for account code details
 
     D SDPLIN        E DS                  EXTNAME(SDPLINPD)
     D                                     PREFIX(PL)
      ** External DS for instrument type details
 
     D SDWEIG        E DS                  EXTNAME(GPWEIGPD)
      ** External DS for instrument type details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for customer details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for currency details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for switchable details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
     D CurrKEY         DS                                                                   MD023117
     D  DLNO                                                                                MD023117
     D  AKEY                                                                                MD023117
      ** DS for Current Account Keys Read                                                   MD023117
                                                                                            MD023117
     D PrvKEY          DS                                                                   MD023117
     D  PrvDLNO                            LIKE(DLNO)                                       MD023117
     D  PrvAKEY                            LIKE(AKEY)                                       MD023117
      ** DS for Previous Account Keys Read                                                  MD023117
                                                                                            MD023117
 
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
 
      ** Calculator Parameters
 
     D PMODULE         S              2
     D PSMODULE        S              4
     D PVALAMT         S             15  0
     D PWEICDE         S              2S 0
     D PWCDPCT         S              3  0
     D PEXPCCY         S              3
     D PEXPOSR         S             15  0
     D POFFSET         S             15  0
     D PINCOFF         S              1
     D PMVALAM         S             15  0
     D PMRGPCT         S              3  0
     D PMRGTYP         S              3
     D PMRGREQ         S             15  0
     D PMEXPCY         S              3
     D PCNUM           S             10
     D PCNST           S              7
 
      ** Convert Variables
 
     D WINAMT          S             15  0
     D WRATE           S             13  8
     D WSPRT1          S             13  8
     D WSPRT2          S             13  8
     D XSPRT1          S             13  8
     D XSPRT2          S             13  8
     D WMDIN           S              1
     D WMDIN1          S              1
     D WMDIN2          S              1
     D XMDIN1          S              1
     D XMDIN2          S              1
     D WCCY1           S              3
     D WCCY2           S              3
     D WNBDP1          S              1  0
     D WNBDP2          S              1  0
     D WOUTAMT         S             15  0
 
      ** Access Object Variables
 
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PACOD           S             10
     D CLE023          S              1
 
      ** Key Field Variables
 
     D KFACNUM         S                   LIKE(FACNUM)
     D KFAFCTY         S                   LIKE(FAFCTY)
     D KFADEAL         S                   LIKE(FADEAL)
     D KFADATE         S                   LIKE(FADATE)
     D KFAACBR         S                   LIKE(FAACBR)
     D KFAACCU         S                   LIKE(FAACCU)
     D KFAACCY         S                   LIKE(FAACCY)
     D KFAACCD         S                   LIKE(FAACCD)
     D KFAACSQ         S                   LIKE(FAACSQ)
     D KMFCCU          S                   LIKE(F2FCCU)
     D KMFACT          S                   LIKE(F2FACT)
     D KMFCNO          S                   LIKE(F2FCNO)
     D KMMACY          S                   LIKE(F2MACY)
     D KBRCA           S                   LIKE(BRCA)
     D KCNUM           S                   LIKE(FCCNUM)
     D KFCTY           S                   LIKE(FCFCTY)
     D KHBRCA          S                   LIKE(BRCA)
     D KHCNUM          S                   LIKE(FHCNUM)
     D KHFACT          S                   LIKE(FHFTYP)
     D KHFCNO          S                   LIKE(FHFSEQ)
     D KACNUM          S                   LIKE(APCNUM)
     D KACCY           S                   LIKE(CCY)
     D KAACOD          S                   LIKE(APACOD)
     D KAACSQ          S                   LIKE(APACSQ)
     D KABRCA          S                   LIKE(BRCA)
     D KAPSTD          S                   LIKE(PSTD)
     D KACCNUM         S                   LIKE(ACCNUM)
     D KACACSQ         S                   LIKE(ACACSQ)
     D KACACOD         S                   LIKE(ACACOD)
     D KFCNUM          S                   LIKE(FHCNUM)
     D KFFACT          S                   LIKE(FHFTYP)
     D KFFCNO          S                   LIKE(FHFSEQ)
     D KDLNO           S              6
     D KNDLNO          S                   LIKE(DC_DLNO)                                    MD023117
     D WKFUID          S                   LIKE(DC_FUID)                                    MD023117
     D                                     INZ('N')                                         MD023117
 
      ** Work Variables
 
     D ORFCCY          S              3                                                      BUG3035
     D DIFLN1          S              3  0
     D RQDLN1          S              3  0
     D DIFLN2          S              3  0
     D RQDLN2          S              3  0
     D PFCCY           S              3
     D PCACY           S              3
     D RWRKDAT         S              5  0
     D WDATE           S              5  0
     D WTRANSID        S              6S 0
     D WFCCU           S              6
     D WFACT           S              3
     D WFCNO           S              2
     D WACTION         S              2
     D WACTDAT         S              5  0
     D WACTCCY         S              3
     D WREVAMT         S             15  0
     D WACTAMT         S             15  0
     D WACTBAL         S             15  0
     D WTRMDIN         S              1
     D WTRXRAT         S             13  8
     D WWEICDE         S              2S 0
     D WWCDPCT         S              3  0
     D WINCOFF         S              1
     D WEXPOFF         S             15  0
     D WTEOP           S             15  0
     D WTEOF           S             15  0
     D WTEOC           S             15  0
     D WACCRUE         S              5  0
     D WNMVMT          S              1                                                      BUG3035
 
     D GIVEN           S              1
     D WUPDAT          S              1
     D WKEY            S              1
     D WRUN            S              1
     D WERROR          S              1
     D WFolder         S              5
     D Idx             S              2  0
 
      ** Standard Subroutine Parameters
 
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
      ** +--------------------------------------+
      ** | Prototypes                           |
      ** | ==========                           |
      ** +--------------------------------------+
 
      ** Prototype for a Java String object
     D crtString       PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             *CONSTRUCTOR)
     D   value                        6A   CONST VARYING
 
      ** Prototype for RPGWrapper object creation (instantiation)
     D crtCalcClass    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper':                         CLE041
     D                                     wrapper.access.RPGWrapper':                        CLE041
     D                                     *CONSTRUCTOR)
     D   String                        O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
 
      ** Prototype for CalcClass' calculateTransactionExposure method
     D getValues1      PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper':                         CLE041
     D                                     wrapper.access.RPGWrapper':                        CLE041
     D                                     'calculateTransactionExposure')
     D                                     CLASS(*JAVA:'java.lang.String')
     D   Int1                        10I 0 VALUE
     D   String2                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   String3                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   Int9                        10I 0 VALUE
 
      ** Prototype for CalcClass' calculateCurrFxmrReqmt method
     D getValues2      PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper':                         CLE041
     D                                     wrapper.access.RPGWrapper':                        CLE041
     D                                     'calculateCurrFxmrReqmt')
     D                                     CLASS(*JAVA:'java.lang.String')
     D   String8                       O   CLASS(*JAVA:'java.lang.String')                   BUG3644
     D                                     CONST                                             BUG3644
     D***Int4***                     10I 0 VALUE                                              CSD027
     D   String4                       O   CLASS(*JAVA:'java.lang.String')                    CSD027
     D                                     CONST                                              CSD027
     D   Int5                        10I 0 VALUE
     D   Int6                        10I 0 VALUE
     D   String7                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   Int10                       10I 0 VALUE
 
      ** Prototype for java string's getBytes method
     D cvtToBytes      PR            55A   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             'getBytes')
     D                                     VARYING
 
      ** Create CalcClass object field
     D CalcClassObj    S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper')                         CLE041
     D                                     wrapper.access.RPGWrapper')                        CLE041
 
      ** Create string objects
     D Parm1           S             10I 0
     D Parm2           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm3           S               O   CLASS(*JAVA:'java.lang.String')
     D*Parm4****       S             10I 0                                                    CSD027
     D Parm4           S               O   CLASS(*JAVA:'java.lang.String')                    CSD027
     D Parm5           S             10I 0
     D Parm6           S             10I 0
     D Parm7           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm8           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm9           S             10I 0
     D Parm10          S             10I 0
     D Parm11          S               O   CLASS(*JAVA:'java.lang.String')                   BUG3644
     D RcvParms        S               O   CLASS(*JAVA:'java.lang.String')
 
     D*** WRcvStr         S             55A   VARYING                                        BUG4405
     D WRcvStr         S             87A   VARYING                                           BUG4405
     D WRcvFld0        S              1
     D WRcvFld1        S             15
     D WRcvFld2        S              1
     D WRcvFld3        S              2
     D WRcvFld4        S              3
     D WRcvFld5        S             15
     D WRcvFld6        S             15
     D WRcvFld7        S              3
     D WRcvFld8        S              1
     D WRcvFld9        S             15
     D WRcvFld10       S              1
     D WRcvFld11       S              3
     D WRcvFld12       S              3
     D WRcvFld13       S             15
     D WRcvFld14       S              3
 
      ** Rename fields
 
     IFACACTF
     I              BRCA                        RSBRCA
 
     IFCLTYFMF
     I              BRCA                        WSBRCA
     I              ORED                        FMORED                                       BUG8222
 
     IFCLTYFMP
     I              BRCA                        WSBRCA
 
     IACCNTJD0
     I              BRCA                        ACBRCA
     I              CNUM                        ACCNUM
     I              CCY                         ACCCY
     I              ACOD                        ACACOD
     I              ACSQ                        ACACSQ
     I              ACNO                        ACACNO
 
     IAPOSTJD0
     I              CNUM                        APCNUM
     I              ACOD                        APACOD
     I              ACSQ                        APACSQ
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Access DEALSDB/DLDLDBQD
 
     C                   EXSR      SRDLDBUPD
                                                                                             BUG3035
      ** Access DKEYSDP                                                                      BUG3035
                                                                                             BUG3035
     C                   EXSR      SRDKEYUPD                                                 BUG3035
 
      ** Access DEALSDC/DLDLDCQD
 
     C                   EXSR      SRDLDCUPD
 
      ***Access*DKEYSDP************************************************                      BUG3035
 
     C**********         EXSR      SRDKEYUPD                                                 BUG3035
 
      ** Access DEALSDG/DLDLDGQD
 
     C                   EXSR      SRDLDGUPD
 
      ** Access DEALSDB/DLDLDBQD
 
     C                   EXSR      SRDLDBUPD2
 
      ** Access DLFMRPD
 
     C                   EXSR      SRFXMRUPD
                                                                                             BUG3035
      ***Access*RSACMTPD***********************************************           BUG3035 AR1023928A
                                                                                             BUG3035
     C**********         EXSR      SRRSACUPD                                      BUG3035 AR1023928A
 
      ** Access ACCNTAB/GLACNTQD
 
     C                   EXSR      SRACCTUPD
                                                                                          AR1023928A
      ** Access RSACMTPD                                                                  AR1023928A
                                                                                          AR1023928A
     C                   EXSR      SRRSACUPD                                              AR1023928A
 
      ***Access*RSACMTPD***********************************************                      BUG3035
 
     C**********         EXSR      SRRSACUPD                                                 BUG3035
 
      ** Access DLDLDBQD/DLDLDCQD/DLDLDGQD
 
     C                   EXSR      SRDEALUPD
 
      ** Close report file
 
     C                   EXSR      SRENDRPT
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDLDBUPD - Access Records in DEALSDB/DLDLDBQD                *
      *                                                               *
      *****************************************************************
 
     C     SRDLDBUPD     BEGSR
 
     C     *LOVAL        SETLL     DLDLDBL1
     C                   READ      DLDLDBL1
 
      ** Read first record
 
     C                   DOW       NOT %EOF(DLDLDBL1)
 
     C                   MOVE      DLNO          KDLNO
 
     C     KDLNO         CHAIN     DLDLDBD0                           20
 
     C                   IF        *IN20 = *OFF
 
     C                   IF        RECI = 'D' or RECI = 'R'
 
     C                   EVAL      WCUST = F1FCCU
     C                   EVAL      WFCLT = F1FACT
     C                   EVAL      WFCSQ = F1FCNO
 
     C                   IF        RECI = 'R'
 
      ** Last Change Date = Rundate and Facility attached Yesterday = 'Y'
 
     C                   IF        LCD = BJRDNB and F1FACI = 'Y'
 
     C                   EVAL      KFACNUM = F1OFCC
     C                   MOVE      F1OFCN        KFAFCTY
     C                   MOVEL     F1OFAC        KFAFCTY
     C                   EVAL      KFADEAL = DLNO
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHISA      SETLL     FACHSAL4
     C                   READ      FACHSAL4                               18
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2 and FADEAL = DLNO and
     C                             *IN18 = *OFF
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1OFCC
     C                   EVAL      KFFACT = F1OFAC
     C                   EVAL      KFFCNO = F1OFCN
     C                   EVAL      WACTION = 'RV'
     C                   EVAL      WACTDAT = FADATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Facility = *BLANKS
 
     C**********         IF        WFACILTY = *ZEROS                                          CSD027
     C                   IF        WFACILTY = '      00000'                                   CSD027
     C                             OR WFACILTY = '00000000000'                              BUG11624
 
     C                   IF        F1FACI = 'Y'
 
     C                   EVAL      KFACNUM = F1OFCC
     C                   MOVE      F1OFCN        KFAFCTY
     C                   MOVEL     F1OFAC        KFAFCTY
     C                   EVAL      KFADEAL = DLNO
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHISA      SETLL     FACHSAL4
     C                   READ      FACHSAL4                               18
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2 and FADEAL = DLNO and
     C                             *IN18 = *OFF
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1OFCC
     C                   EVAL      KFFACT = F1OFAC
     C                   EVAL      KFFCNO = F1OFCN
     C                   EVAL      WACTION = 'RV'
     C                   EVAL      WACTDAT = FADATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Facility <> *BLANKS and Facility Attached Yesterday = *BLANKS
 
     C                   IF        F1FACI = *BLANKS
 
     C                   EVAL      KFACNUM = F1FCCU
     C                   MOVE      F1FCNO        KFAFCTY
     C                   MOVEL     F1FACT        KFAFCTY
     C                   EVAL      KFADEAL = DLNO
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHISA      SETLL     FACHSAL4
     C                   READ      FACHSAL4                               18
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2 and FADEAL = DLNO and
     C                             *IN18 = *OFF
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'RS'
     C                   EVAL      WACTDAT = FADATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        DTYP = 'OP'
     C                   EVAL      WDATE = OTDT
     C                   ELSE
     C                   EVAL      WDATE = VDAT
     C                   ENDIF
 
      ** Value Date = Rundate
 
     C                   IF        WDATE <= WACCRUE
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'F0'
     C                   EVAL      WACTCCY = F1EXCY
     C                   EVAL      WREVAMT = 0
     C                   EVAL      WACTDAT = WDATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
      ** Update record in DLDLDBQD
 
     C                   EVAL      F1TEXO = 0
     C                   EVAL      F1TEOF = 0
     C                   EVAL      F1TEOC = 0
     C                   UPDATE    DLDLDBD0
 
     C                   ENDIF
 
      ** Value Date > Rundate
 
     C                   IF        WDATE > WACCRUE
 
      ** Call FX Exposure Calculator
 
     C                   EVAL      PMODULE = 'DL'
     C                   EVAL      PSMODULE = 'FXDL'
     C                   EXSR      SRDLCALC
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'FX'
     C                   EVAL      WACTCCY = PEXPCCY
 
     C                   IF        POFFSET <> 0
     C                   EVAL      WREVAMT = POFFSET
     C                   ENDIF
 
     C                   IF        POFFSET = 0 and PEXPOSR = 0 or
     C                             PEXPOSR <> 0
     C                   EVAL      WREVAMT = PEXPOSR
     C                   ENDIF
 
     C                   EVAL      WACTDAT = BJRDNB
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
      ** Update record in DLDLDBQD
 
     C                   IF        POFFSET <> 0
     C                   EVAL      F1TEXO = POFFSET
     C                   ENDIF
 
     C                   IF        POFFSET = 0 and PEXPOSR = 0 or
     C                             PEXPOSR <> 0
     C                   EVAL      F1TEXO = PEXPOSR
     C                   ENDIF
 
      ** Convert amount
 
     C                   EVAL      WCCY1 = PEXPCCY
     C**********         EVAL      WCCY2 = FCCY                                              BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
 
     C                   IF        POFFSET <> 0
     C                   EVAL      WINAMT = POFFSET
     C                   ENDIF
 
     C                   IF        POFFSET = 0 and PEXPOSR = 0 or
     C                             PEXPOSR <> 0
     C                   EVAL      WINAMT = PEXPOSR
     C                   ENDIF
 
     C                   EXSR      SRCONVERT
     C                   EVAL      F1TEOF = WOUTAMT
 
      ** If facility is tranche
 
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
 
     C     KFCLTY        CHAIN     FCLTYL3                            17
 
      ** Convert amount
 
     C                   IF        *IN17 = *OFF and TRCA = 'TR'
     C**********         EVAL      WCCY1 = PEXPCCY                                           BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY
     C                   EVAL      WINAMT = F1TEOF
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SRCONVERT
     C                   EVAL      F1TEOC = WOUTAMT
     C                   ENDIF
 
     C                   IF        F1EXCY = *BLANKS
     C                   EVAL      F1EXCY = PEXPCCY
     C                   ENDIF
 
     C                   UPDATE    DLDLDBD0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DLDLDBL1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDLDCUPD - Access Records in DEALSDC/DLDLDCQD                *
      *                                                               *
      *****************************************************************
 
     C     SRDLDCUPD     BEGSR
 
     C     *LOVAL        SETLL     DLDLDCL1
     C                   READ      DLDLDCL1
 
      ** Read first record
 
     C                   DOW       NOT %EOF(DLDLDCL1)
 
     C                   MOVE      DLNO          KDLNO
 
     C     KDLNO         CHAIN     DLDLDCD0                           20
 
     C                   IF        *IN20 = *OFF
 
     C                   IF        RECI = 'R' or RECI = 'D'
 
     C                   EVAL      WCUST = F1FCCU
     C                   EVAL      WFCLT = F1FACT
     C                   EVAL      WFCSQ = F1FCNO
 
     C                   IF        RECI = 'R'
 
      ** Last Change Date = Rundate and Facility Attached Yesterday = 'Y'
 
     C                   IF        LCD = BJRDNB and F1FACI = 'Y'
 
     C                   EVAL      KFACNUM = F1OFCC
     C                   MOVE      F1OFCN        KFAFCTY
     C                   MOVEL     F1OFAC        KFAFCTY
     C                   EVAL      KFADEAL = DLNO
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHISA      SETLL     FACHSAL4
     C                   READ      FACHSAL4                               18
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2 and FADEAL = DLNO and
     C                             *IN18 = *OFF
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1OFCC
     C                   EVAL      KFFACT = F1OFAC
     C                   EVAL      KFFCNO = F1OFCN
     C                   EVAL      WACTION = 'RV'
     C                   EVAL      WACTDAT = FADATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Facility <> *BLANKS
 
     C**********         IF        WFACILTY = *ZEROS                                          CSD027
     C                   IF        WFACILTY = '      00000'                                   CSD027
     C                             OR WFACILTY = '00000000000'                              BUG11624
 
     C                   IF        F1FACI = 'Y'
 
     C                   EVAL      KFACNUM = F1OFCC
     C                   MOVE      F1OFCN        KFAFCTY
     C                   MOVEL     F1OFAC        KFAFCTY
     C                   EVAL      KFADEAL = DLNO
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHISA      SETLL     FACHSAL4
     C                   READ      FACHSAL4                               18
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2 and FADEAL = DLNO and
     C                             *IN18 = *OFF
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1OFCC
     C                   EVAL      KFFACT = F1OFAC
     C                   EVAL      KFFCNO = F1OFCN
     C                   EVAL      WACTION = 'RV'
     C                   EVAL      WACTDAT = FADATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Facility <> *BLANKS and Facility Attached Yesterday = *BLANKS
 
     C                   IF        F1FACI = *BLANKS
 
     C                   EVAL      KFACNUM = F1FCCU
     C                   MOVE      F1FCNO        KFAFCTY
     C                   MOVEL     F1FACT        KFAFCTY
     C                   EVAL      KFADEAL = DLNO
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHISA      SETLL     FACHSAL4
     C                   READ      FACHSAL4                               18
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2 and FADEAL = DLNO and
     C                             *IN18 = *OFF
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'RS'
     C                   EVAL      WACTDAT = FADATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ELSE
 
     C                   IF        ORED < BJRDNB and VDAT < BJDNWD
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'S1'
     C                   EVAL      WACTDAT = VDAT
     C                   EVAL      WACTCCY = CCY
     C                   EVAL      WREVAMT = PCPL
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        MDAT > BJRDNB or MDAT = 0                                 BUG3035
                                                                                             BUG3035
     C                   EVAL      WTRANSID = DLNO                                           BUG3035
     C                   EVAL      KFCNUM = F1FCCU                                           BUG3035
     C                   EVAL      KFFACT = F1FACT                                           BUG3035
     C                   EVAL      KFFCNO = F1FCNO                                           BUG3035
     C                   EVAL      WACTION = 'MR'                                            BUG3035
     C                   EVAL      WACTCCY = CCY                                             BUG3035
     C                   EVAL      WACTDAT = BJRDNB                                          BUG3035
     C                   EVAL      WREVAMT = F1TEXO                                          BUG3035
                                                                                             BUG3035
      ** Process Action                                                                      BUG3035
                                                                                             BUG3035
     C                   EXSR      SRPROCACT                                                 BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   EVAL      WCCY1 = WACTCCY                                           BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
     C                   EVAL      WINAMT = F1TEXO                                           BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOF = WOUTAMT                                          BUG3035
                                                                                             BUG3035
      ** If facility is tranche                                                              BUG3035
                                                                                             BUG3035
     C                   EVAL      KFCNUM = F1FCCU                                           BUG3035
     C                   EVAL      KFFACT = F1FACT                                           BUG3035
     C                   EVAL      KFFCNO = F1FCNO                                           BUG3035
                                                                                             BUG3035
     C     KFCLTY        CHAIN     FCLTYL3                            17                     BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   IF        *IN17 = *OFF and TRCA = 'TR'                              BUG3035
                                                                                             BUG3035
     C                   IF        ORFCCY = CACY                                             BUG3035
     C                   EVAL      F1TEOC = F1TEOF                                           BUG3035
     C                   ELSE                                                                BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY                                              BUG3035
     C                   EVAL      WINAMT = F1TEOF                                           BUG3035
     C                   EVAL      WRATE = WTRXRAT                                           BUG3035
     C                   EVAL      WMDIN = WTRMDIN                                           BUG3035
     C                   EVAL      GIVEN = 'Y'                                               BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOC = WOUTAMT                                          BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   UPDATE    DLDLDCD0                                                  BUG3035
                                                                                             BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DLDLDCL1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDKEYUPD - Access Records in DKEYSDP                         *
      *                                                               *
      *****************************************************************
 
     C     SRDKEYUPD     BEGSR
 
     C                   READ      DKEYSDP
 
      ** Read first record
 
     C                   DOW       NOT %EOF(DKEYSDP)
 
     C                   IF        REVI = 0
 
     C*******************EVAL      WACKEY = AKEY                                              CDL038
     C                   MOVEL     AKEY          WACKEY                                       CDL038
     C                   EVAL      WKEY = 'N'
 
     C                   IF        WMMEVNT = 'IP' or WMMEVNT = 'TI' or
     C                             WMMEVNT = 'CL' or WMMEVNT = 'DL' or
     C                             WMMEVNT = 'FL' or WMMEVNT = 'DP' or
     C                             WMMEVNT = 'LP'
 
     C                   IF        (WACKEY3 = 'V' and WACKEY0 = 'R')                        MD023117
     C                   EVAL      KNDLNO = DLNO                                            MD023117
     C     KNDLNO        CHAIN     DEALSC                                                   MD023117
     C                   IF        %FOUND(DEALSC)                                           MD023117
     C                   EVAL      WKFUID = DC_FUID                                         MD023117
     C                   ENDIF                                                              MD023117
     C                   ENDIF                                                              MD023117
                                                                                            MD023117
      ** Determine Action Type
 
     C                   IF        (WACKEY3 = 'V' and WACKEY0 = 'A') or
     C**********                   (WACKEY3 = 'V' and WACKEY0 = 'R') or                     MD023117
     C                             (WACKEY3 = 'V' and WACKEY0 = 'R' and                     MD023117
     C                              WKFUID  = 'N') or                                       MD023117
     C                             (WACKEY3 = 'V' and WACKEYL = 'XR')
     C                   EVAL      WACTION = 'S1'
     C                   EVAL      WKEY = 'Y'
                                                                                            MD023117
     C                   IF        (WACKEY3 = 'V' and WACKEY0 = 'R')                        MD023117
     C                   EVAL      WKFUID = 'N'                                             MD023117
     C                   IF        PrvKEY = CurrKEY                                         MD023117
     C                   EVAL      WKEY = 'N'                                               MD023117
     C                   ENDIF                                                              MD023117
     C                   IF        PrvKEY <> CurrKEY                                        MD023117
     C                   EVAL      PrvDLNO = DLNO                                           MD023117
     C                   EVAL      PrvAKEY = AKEY                                           MD023117
     C                   ENDIF                                                              MD023117
     C                   ENDIF                                                              MD023117
                                                                                            MD023117
     C                   ENDIF
 
     C                   IF        (WACKEY3 = 'M' and WACKEY0 = 'A') or
     C                             (WACKEY3 = 'R' and WACKEY0 = 'A') or
     C                             (WACKEY3 = 'R' and WACKEYL = 'XA')
     C                   EVAL      WACTION = 'M1'
     C                   EVAL      WKEY = 'Y'
     C                   ENDIF
 
     C                   IF        WACKEY3 = 'I' and WACKEY0 = 'C'
     C                   EVAL      WACTION = 'C1'
     C                   EVAL      WKEY = 'Y'
     C                   ENDIF
 
     C                   IF        WACKEY3 = 'V' and WACKEYL = 'IA'
     C                   EVAL      WACTION = 'I1'
     C                   EVAL      WKEY = 'Y'
     C                   ENDIF
 
     C                   IF        WACKEY3 = 'M' and WACKEYL = 'DA'
     C                   EVAL      WACTION = 'D1'
     C                   EVAL      WKEY = 'Y'
     C                   ENDIF
 
     C                   IF        WKEY = 'Y'
 
     C                   MOVE      DLNO          KDLNO
 
     C     KDLNO         CHAIN     DLDLDCD0                           15
 
      ** Database error
 
     C                   IF        *IN15 = *ON
 
     C                   EVAL      DBFILE = 'DLDLDCQD'
     C                   EVAL      DBASE = 3
     C                   MOVEL     DLNO          DBKEY
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      WCUST = F1FCCU
     C                   EVAL      WFCLT = F1FACT
     C                   EVAL      WFCSQ = F1FCNO
 
     C**********         IF        WFACILTY <> *ZEROS                                         CSD027
     C                   IF        WFACILTY <> '      00000'                                  CSD027
     C                             AND WFACILTY <> '00000000000'                            BUG11624
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTCCY = ECCY
                                                                                             BUG3035
     C                   IF        WACTION = 'M1'                                            BUG3035
     C                   EVAL      WREVAMT = 0                                               BUG3035
     C                   ELSE                                                                BUG3035
     C                   EVAL      WREVAMT = EAMT
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   EVAL      WACTDAT = EDAT
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
      ** Update record in DLDLDCQD                                                           BUG3035
                                                                                             BUG3035
     C                   IF        WACTION = 'M1'                                            BUG3035
     C                   EVAL      F1TEXO = 0                                                BUG3035
     C                   EVAL      F1TEOF = 0                                                BUG3035
     C                   EVAL      F1TEOC = 0                                                BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   IF        WACTION = 'I1' or WACTION = 'C1' or                       BUG3035
     C                             WACTION = 'S1'                                            BUG3035
                                                                                             BUG3035
     C                   EVAL      F1TEXO = F1TEXO + WREVAMT                                 BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   EVAL      WCCY1 = WACTCCY                                           BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
     C                   EVAL      WINAMT = WREVAMT                                          BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOF = WOUTAMT + F1TEOF                                 BUG3035
                                                                                             BUG3035
      ** If facility is tranche                                                              BUG3035
                                                                                             BUG3035
     C                   EVAL      KFCNUM = F1FCCU                                           BUG3035
     C                   EVAL      KFFACT = F1FACT                                           BUG3035
     C                   EVAL      KFFCNO = F1FCNO                                           BUG3035
                                                                                             BUG3035
     C     KFCLTY        CHAIN     FCLTYL3                            17                     BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   IF        *IN17 = *OFF and TRCA = 'TR'                              BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY                                              BUG3035
     C                   EVAL      WINAMT = F1TEOF                                           BUG3035
     C                   EVAL      WRATE = WTRXRAT                                           BUG3035
     C                   EVAL      WMDIN = WTRMDIN                                           BUG3035
     C                   EVAL      GIVEN = 'Y'                                               BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOC = WOUTAMT + F1TEOC                                 BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   IF        WACTION = 'D1'                                            BUG3035
                                                                                             BUG3035
     C                   EVAL      F1TEXO = F1TEXO - WREVAMT                                 BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   EVAL      WCCY1 = WACTCCY                                           BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
     C                   EVAL      WINAMT = WREVAMT                                          BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOF = WOUTAMT - F1TEOF                                 BUG3035
                                                                                             BUG3035
      ** If facility is tranche                                                              BUG3035
                                                                                             BUG3035
     C                   EVAL      KFCNUM = F1FCCU                                           BUG3035
     C                   EVAL      KFFACT = F1FACT                                           BUG3035
     C                   EVAL      KFFCNO = F1FCNO                                           BUG3035
                                                                                             BUG3035
     C     KFCLTY        CHAIN     FCLTYL3                            17                     BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   IF        *IN17 = *OFF and TRCA = 'TR'                              BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY                                              BUG3035
     C                   EVAL      WINAMT = F1TEOF                                           BUG3035
     C                   EVAL      WRATE = WTRXRAT                                           BUG3035
     C                   EVAL      WMDIN = WTRMDIN                                           BUG3035
     C                   EVAL      GIVEN = 'Y'                                               BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOC = WOUTAMT - F1TEOC                                 BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   UPDATE    DLDLDCD0                                                  BUG3035
                                                                                             BUG3035
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DKEYSDP
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDLDGUPD - Access Records in DEALSDG/DLDLDGQD                *
      *                                                               *
      *****************************************************************
 
     C     SRDLDGUPD     BEGSR
 
     C     *LOVAL        SETLL     DLDLDGLE
     C                   READ      DLDLDGLE
 
      ** Read first record
 
     C                   DOW       NOT %EOF(DLDLDGLE)
 
     C                   MOVE      DLNO          KDLNO
 
     C     KDLNO         CHAIN     DLDLDGD0                           20
 
     C                   IF        *IN20 = *OFF
 
     C                   IF        RECI = 'R' or RECI = 'D'
 
     C                   EVAL      WCUST = F1FCCU
     C                   EVAL      WFCLT = F1FACT
     C                   EVAL      WFCSQ = F1FCNO
 
     C                   IF        RECI = 'R'
 
      ** Last Change Date = Rundate and Facility attached Yesterday = 'Y'
 
     C                   IF        LCD = BJRDNB and F1FACI = 'Y'
 
     C                   EVAL      KFACNUM = F1OFCC
     C                   MOVE      F1OFCN        KFAFCTY
     C                   MOVEL     F1OFAC        KFAFCTY
     C                   EVAL      KFADEAL = DLNO
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHISA      SETLL     FACHSAL4
     C                   READ      FACHSAL4                               18
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2 and FADEAL = DLNO and
     C                             *IN18 = *OFF
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1OFCC
     C                   EVAL      KFFACT = F1OFAC
     C                   EVAL      KFFCNO = F1OFCN
     C                   EVAL      WACTION = 'RV'
     C                   EVAL      WACTDAT = FADATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Facility <> *BLANKS
 
     C**********         IF        WFACILTY = *ZEROS                                          CSD027
     C                   IF        WFACILTY = '      00000'                                   CSD027
     C                             OR WFACILTY = '00000000000'                              BUG11624
 
     C                   IF        F1FACI = 'Y'
 
     C                   EVAL      KFACNUM = F1OFCC
     C                   MOVE      F1OFCN        KFAFCTY
     C                   MOVEL     F1OFAC        KFAFCTY
     C                   EVAL      KFADEAL = DLNO
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHISA      SETLL     FACHSAL4
     C                   READ      FACHSAL4                               18
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2 and FADEAL = DLNO and
     C                             *IN18 = *OFF
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1OFCC
     C                   EVAL      KFFACT = F1OFAC
     C                   EVAL      KFFCNO = F1OFCN
     C                   EVAL      WACTION = 'RV'
     C                   EVAL      WACTDAT = FADATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Facility <> *BLANKS and Facility Attached Yesterday = *BLANKS
 
     C                   IF        F1FACI = *BLANKS
 
     C                   EVAL      KFACNUM = F1FCCU
     C                   MOVE      F1FCNO        KFAFCTY
     C                   MOVEL     F1FACT        KFAFCTY
     C                   EVAL      KFADEAL = DLNO
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHISA      SETLL     FACHSAL4
     C                   READ      FACHSAL4                               18
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2 and FADEAL = DLNO and
     C                             *IN18 = *OFF
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'RS'
     C                   EVAL      WACTDAT = FADATE
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If FRA transaction
 
     C                   IF        DTYP = 'FR'
 
      ** Value Date = Rundate
 
     C                   IF        VDAT <= WACCRUE
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'FV'
     C                   EVAL      WACTCCY = F1EXCY
     C                   EVAL      WREVAMT = 0
     C                   EVAL      WACTDAT = VDAT
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
      ** Update record in DLDLDGQD
 
     C                   EVAL      F1TEXO = 0
     C                   EVAL      F1TEOF = 0
     C                   EVAL      F1TEOC = 0
     C                   UPDATE    DLDLDGD0
 
     C                   ENDIF
 
      ** Value Date > Rundate
 
     C                   IF        VDAT > WACCRUE
 
      ** Call FRA/IRS Exposure Calculator
 
     C                   EVAL      PMODULE = 'DL'
     C                   EVAL      PSMODULE = 'FRAS'
     C                   EXSR      SRDLCALC
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'FW'
     C                   EVAL      WACTCCY = PEXPCCY
 
     C                   IF        POFFSET <> 0
     C                   EVAL      WREVAMT = POFFSET
     C                   ENDIF
 
     C                   IF        POFFSET = 0 and PEXPOSR = 0 or
     C                             PEXPOSR <> 0
     C                   EVAL      WREVAMT = PEXPOSR
     C                   ENDIF
 
     C                   EVAL      WACTDAT = BJRDNB
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
      ** Update record in DLDLDGQD
 
     C                   IF        POFFSET <> 0
     C                   EVAL      F1TEXO = POFFSET
     C                   ENDIF
 
     C                   IF        POFFSET = 0 and PEXPOSR = 0 or
     C                             PEXPOSR <> 0
     C                   EVAL      F1TEXO = PEXPOSR
     C                   ENDIF
 
      ** Convert amount
 
     C                   EVAL      WCCY1 = PEXPCCY
     C**********         EVAL      WCCY2 = FCCY                                              BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
 
     C                   IF        POFFSET <> 0
     C                   EVAL      WINAMT = POFFSET
     C                   ENDIF
 
     C                   IF        POFFSET = 0 and PEXPOSR = 0 or
     C                             PEXPOSR <> 0
     C                   EVAL      WINAMT = PEXPOSR
     C                   ENDIF
 
     C                   EXSR      SRCONVERT
     C                   EVAL      F1TEOF = WOUTAMT
 
      ** If facility is tranche
 
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
 
     C     KFCLTY        CHAIN     FCLTYL3                            17
 
      ** Convert amount
 
     C                   IF        *IN17 = *OFF and TRCA = 'TR'
     C**********         EVAL      WCCY1 = PEXPCCY                                           BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY
     C                   EVAL      WINAMT = F1TEOF
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SRCONVERT
     C                   EVAL      F1TEOC = WOUTAMT
     C                   ENDIF
 
     C                   IF        F1EXCY = *BLANKS
     C                   EVAL      F1EXCY = PEXPCCY
     C                   ENDIF
 
     C                   UPDATE    DLDLDGD0
 
     C                   ENDIF
 
      ** If IRS transaction
 
     C                   ELSE
 
      ** Maturity Date = Rundate
 
     C                   IF        MDAT <= WACCRUE
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'IS'
     C                   EVAL      WACTCCY = F1EXCY
     C                   EVAL      WREVAMT = 0
     C                   EVAL      WACTDAT = MDAT
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
      ** Update record in DLDLDGQD
 
     C                   EVAL      F1TEXO = 0
     C                   EVAL      F1TEOF = 0
     C                   EVAL      F1TEOC = 0
     C                   UPDATE    DLDLDGD0
 
     C                   ENDIF
 
      ** Maturity Date > Rundate
 
     C                   IF        MDAT > WACCRUE
 
      ** Call FRA/IRS Exposure Calculator
 
     C                   SELECT
 
     C                   WHEN      DTYP = 'RS'
     C                   EVAL      PSMODULE = 'SIRS'
     C
     C                   WHEN      DTYP = 'RX'
     C                   EVAL      PSMODULE = 'CIRS'
 
     C                   OTHER
     C                   EVAL      PSMODULE = 'CFCO'
 
     C                   ENDSL
 
     C                   EVAL      PMODULE = 'DL'
     C                   EXSR      SRDLCALC
 
     C                   EVAL      WTRANSID = DLNO
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
     C                   EVAL      WACTION = 'IR'
     C                   EVAL      WACTCCY = PEXPCCY
 
     C                   IF        POFFSET <> 0
     C                   EVAL      WREVAMT = POFFSET
     C                   ENDIF
 
     C                   IF        POFFSET = 0 and PEXPOSR = 0 or
     C                             PEXPOSR <> 0
     C                   EVAL      WREVAMT = PEXPOSR
     C                   ENDIF
 
     C                   EVAL      WACTDAT = BJRDNB
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
      ** Update record in DLDLDGQD
 
     C                   IF        POFFSET <> 0
     C                   EVAL      F1TEXO = POFFSET
     C                   ENDIF
 
     C                   IF        POFFSET = 0 and PEXPOSR = 0 or
     C                             PEXPOSR <> 0
     C                   EVAL      F1TEXO = PEXPOSR
     C                   ENDIF
 
      ** Convert amount
 
     C                   EVAL      WCCY1 = PEXPCCY
     C**********         EVAL      WCCY2 = FCCY                                              BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
 
     C                   IF        POFFSET <> 0
     C                   EVAL      WINAMT = POFFSET
     C                   ENDIF
 
     C                   IF        POFFSET = 0 and PEXPOSR = 0 or
     C                             PEXPOSR <> 0
     C                   EVAL      WINAMT = PEXPOSR
     C                   ENDIF
 
     C                   EXSR      SRCONVERT
     C                   EVAL      F1TEOF = WOUTAMT
 
      ** If facility is tranche
 
     C                   EVAL      KFCNUM = F1FCCU
     C                   EVAL      KFFACT = F1FACT
     C                   EVAL      KFFCNO = F1FCNO
 
     C     KFCLTY        CHAIN     FCLTYL3                            17
 
      ** Convert amount
 
     C                   IF        *IN17 = *OFF and TRCA = 'TR'
     C**********         EVAL      WCCY1 = PEXPCCY                                           BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY
     C                   EVAL      WINAMT = F1TEOF
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SRCONVERT
     C                   EVAL      F1TEOC = WOUTAMT
     C                   ENDIF
 
     C                   IF        F1EXCY = *BLANKS
     C                   EVAL      F1EXCY = PEXPCCY
     C                   ENDIF
 
     C                   UPDATE    DLDLDGD0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DLDLDGLE
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDLDBUPD2 - Access Records in DEALSDB/DLDLDBQD               *
      *                                                               *
      *****************************************************************
 
     C     SRDLDBUPD2    BEGSR
 
     C     *LOVAL        SETLL     DLDLDBL1
     C                   READ      DLDLDBL1
 
      ** Read first record
 
     C                   DOW       NOT %EOF(DLDLDBL1)
 
     C                   MOVE      DLNO          KDLNO
 
     C     KDLNO         CHAIN     DLDLDBD0                           20
 
     C                   IF        *IN20 = *OFF
 
     C                   EVAL      WCUST = F1FCCU
     C                   EVAL      WFCLT = F1FACT
     C                   EVAL      WFCSQ = F1FCNO
 
     C                   IF        RECI = 'R'
 
      ** Last Change Date = Rundate and Facility attached Yesterday = 'Y'
 
     C                   IF        LCD = BJRDNB and F1FACI = 'Y'
 
     C                   EVAL      KMFCCU = F1OFCC
     C                   EVAL      KMFACT = F1OFAC
     C                   EVAL      KMFCNO = F1OFCN
 
      ** Perform Flag for Margin Recalculation using Buy Currency
 
     C                   EVAL      KMMACY = PUCY
     C                   EXSR      SRMARGCAL
 
      ** Perform Flag for Margin Recalculation using Sell Currency
 
     C                   EVAL      KMMACY = SLCY
     C                   EXSR      SRMARGCAL
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Facility = *BLANKS
 
     C**********         IF        WFACILTY = *ZEROS                                          CSD027
     C                   IF        WFACILTY = '      00000'                                   CSD027
     C                             OR WFACILTY = '00000000000'                              BUG11624
 
     C                   IF        F1FACI = 'Y'
 
     C                   EVAL      KMFCCU = F1OFCC
     C                   EVAL      KMFACT = F1OFAC
     C                   EVAL      KMFCNO = F1OFCN
 
      ** Perform Flag for Margin Recalculation using Buy Currency
 
     C                   EVAL      KMMACY = PUCY
     C                   EXSR      SRMARGCAL
 
      ** Perform Flag for Margin Recalculation using Sell Currency
 
     C                   EVAL      KMMACY = SLCY
     C                   EXSR      SRMARGCAL
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DTYP = 'OP'
     C                   EVAL      WDATE = OTDT
     C                   ELSE
     C                   EVAL      WDATE = VDAT
     C                   ENDIF
 
     C                   IF        WDATE >= WACCRUE
 
     C                   EVAL      KMFCCU = F1FCCU
     C                   EVAL      KMFACT = F1FACT
     C                   EVAL      KMFCNO = F1FCNO
 
      ** Perform Flag for Margin Recalculation using Buy Currency
 
     C                   EVAL      KMMACY = PUCY
     C                   EXSR      SRMARGCAL
 
      ** Perform Flag for Margin Recalculation using Sell Currency
 
     C                   EVAL      KMMACY = SLCY
     C                   EXSR      SRMARGCAL
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DLDLDBL1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFXMRUPD - Access Records in DLFXMRPD                        *
      *                                                               *
      *****************************************************************
 
     C     SRFXMRUPD     BEGSR
 
     C     *LOVAL        SETLL     DLFXMRL0
     C                   READ      DLFXMRL0
 
      ** Read first record
 
     C                   DOW       NOT %EOF(DLFXMRL0)
 
     C                   IF        F2RCAL = 'Y'
 
      ** Call FX Margin Exposure Calculator
 
     C                   EXSR      SRFXMCALC
 
     C                   EVAL      WTRANSID = *ZEROS
     C                   EVAL      KFCNUM = F2FCCU
     C                   EVAL      KFFACT = F2FACT
     C                   EVAL      KFFCNO = F2FCNO
     C                   EVAL      WACTION = 'FM'
     C                   EVAL      WACTCCY = PMEXPCY
     C                   EVAL      WREVAMT = PMRGREQ
     C                   EVAL      WACTDAT = BJRDNB
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
      ** Update record in DLFXMRPD
 
     C                   EVAL      F2TMAR = PMRGREQ
 
      ** Convert amount
 
     C**********         EVAL      WCCY1 = F2MACY                                            BUG3035
     C                   EVAL      WCCY1 = PMEXPCY                                           BUG3035
     C**********         EVAL      WCCY2 = FCCY                                              BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
     C                   EVAL      WINAMT = PMRGREQ
     C                   EXSR      SRCONVERT
     C                   EVAL      F2TMAF = WOUTAMT
 
      ** If facility is tranche
 
     C                   EVAL      KFCNUM = F2FCCU
     C                   EVAL      KFFACT = F2FACT
     C                   EVAL      KFFCNO = F2FCNO
 
     C     KFCLTY        CHAIN     FCLTYL3                            17
 
      ** Convert amount
 
     C                   IF        *IN17 = *OFF and TRCA = 'TR'
     C**********         EVAL      WCCY1 = F2MACY                                            BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY
     C                   EVAL      WINAMT = F2TMAF
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SRCONVERT
     C                   EVAL      F2TMAC = WOUTAMT
     C                   ENDIF
 
     C                   EVAL      F2RCAL = *BLANKS
     C                   UPDATE    DLFXMRD0
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DLFXMRL0
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACCTUPD - Access Records in ACCNTAB/GLACNTQD                *
      *                                                               *
      *****************************************************************
 
     C     SRACCTUPD     BEGSR
 
     C     *LOVAL        SETLL     ACCNTJ0
     C                   READ      ACCNTJ0
 
      ** Read first record
 
     C                   DOW       NOT %EOF(ACCNTJ0)
 
     C                   IF        F1FCHD <> 0
 
     C                   EVAL      WCUST = PFCU
     C                   EVAL      WFCLT = PFTP
     C                   EVAL      WFCSQ = PFSQ
     C                   EVAL      KFCNUM = PFCU
     C                   EVAL      KFFACT = PFTP
     C                   EVAL      KFFCNO = PFSQ
     C                   EVAL      WFCNUM = PFCU
     C                   EVAL      WFFACT = PFTP
     C                   EVAL      WFFCNO = PFSQ
 
      ** If Previous Facility <> *BLANKS
 
     C**********         IF        WFACILTY <> *ZEROS                                         CLE041
     C**********         IF        WCUST <> *ZEROS AND WFCLT <> *ZEROS AND             CLE041 CSD027
     C                   IF        WCUST <> *BLANKS AND WFCLT <> *ZEROS AND                   CSD027
     C                             WCUST <> *ZEROS AND                                      BUG11624
     C                             WFCSQ <> *ZEROS                                            CLE041
 
     C     KFCLTY        CHAIN     FCLTYL3                            15
 
     C                   IF        *IN15 = *ON
 
     C     KFCLTY        CHAIN     PEFCLFL3                           16
 
      ***Database*error************************************************                     AR788404
      *****************************************************************                     AR788404
     C**********         IF        *IN16 = *ON                                              AR788404
     C**********         EVAL      DBFILE = 'PEFCLFM'                                       AR788404
     C**********         EVAL      DBASE = 8                                                AR788404
     C**********         EVAL      DBKEY = WDBKEY                                           AR788404
     C**********         EXSR      *PSSR                                                    AR788404
     C**********         ENDIF                                                              AR788404
 
     C                   ENDIF
 
      ** If record not found in PEFCLFM do not execute further                              AR788404
                                                                                            AR788404
     C                   IF        *IN15 = *OFF OR *IN16 = *OFF                             AR788404
                                                                                            AR788404
      ** If live record
 
     C                   IF        RECI <> 'R'
 
     C                   EVAL      KFACNUM = PFCU
     C                   MOVEL     PFTP          KFAFCTY
     C                   MOVE      PFSQ          KFAFCTY
     C                   EVAL      KFAACBR = ACBRCA
     C                   EVAL      KFAACCU = ACCNUM
     C                   EVAL      KFAACCY = ACCCY
     C                   EVAL      KFAACCD = ACACOD
     C                   EVAL      KFAACSQ = ACACSQ
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHIS1      SETLL     FACHSAL5
     C                   READ      FACHSAL5                               17
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        *IN17 = *OFF and WCOMPARE1 = WCOMPARE2
 
     C                   EVAL      RWRKDAT = FADATE
 
     C     KFACHIS1      SETLL     FACHSAL5
     C                   READ      FACHSAL5
 
      ** Update record in FACHISA
 
     C                   DOW       NOT %EOF(FACHSAL5)
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2
     C                   EVAL      FAREVI = 'R'
     C                   EVAL      FAGNDT = BJRDNB
     C                   EVAL      FACFGI = *BLANKS
     C                   UPDATE    FACHISA5
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      FACHSAL5
     C                   ENDDO
 
      ** Check if Previous Facility in FACACT
 
     C************       EVAL      KBRCA = ACBRCA                                            BUG4377
     C                   EVAL      KBRCA = WSBRCA                                            BUG4377
     C                   EVAL      KCNUM = PFCU
     C                   MOVE      PFSQ          KFCTY
     C                   MOVEL     PFTP          KFCTY
 
     C     KFACACT       CHAIN     FACACTL1                           17
 
     C                   IF        *IN17 = *OFF
 
     C                   IF        RWRKDAT < FCDATE
     C                   EVAL      FCDATE = RWRKDAT
     C                   UPDATE    FACACTF
     C                   ENDIF
 
     C                   ELSE
 
     C***********        EVAL      RSBRCA = ACBRCA                                           BUG4377
     C                   EVAL      RSBRCA = WSBRCA                                           BUG4377
     C                   EVAL      FCCNUM = PFCU
     C                   MOVE      PFSQ          FCFCTY
     C                   MOVEL     PFTP          FCFCTY
     C                   EVAL      FCDATE = RWRKDAT
     C                   WRITE     FACACTF
 
     C                   ENDIF
 
     C                   IF        CLE023 = 'Y' and RWRKDAT < BJRDNB
 
     C***********        EVAL      KHBRCA = ACBRCA                                           BUG4377
     C                   EVAL      KHBRCA = WSBRCA                                           BUG4377
     C                   EVAL      KHCNUM = PFCU
     C                   EVAL      KHFACT = PFTP
     C                   EVAL      KHFCNO = PFSQ
 
     C     KFACHISH      CHAIN     FACHISHL                           17
 
      ** Update FACHISH
 
     C                   IF        *IN17 = *OFF
 
     C                   EVAL      FHRWKR = 'Y'
     C                   EVAL      FHRWTP = 'B'
 
     C                   IF        FHRWDT = 0 or FHRWDT > RWRKDAT
     C                   EVAL      FHRWDT = RWRKDAT
     C                   ENDIF
 
     C                   UPDATE    FACHISHF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If facility is tranche
 
     C                   IF        TRCA = 'TR'
 
     C                   EVAL      KFACNUM = CANM
     C                   MOVEL     CAFT          KFAFCTY
     C                   MOVE      CAFN          KFAFCTY
     C                   EVAL      KFAACBR = ACBRCA
     C                   EVAL      KFAACCU = ACCNUM
     C                   EVAL      KFAACCY = ACCCY
     C                   EVAL      KFAACCD = ACACOD
     C                   EVAL      KFAACSQ = ACACSQ
     C                   EVAL      WCOMPF1 = KFACNUM
     C                   EVAL      WCOMPF2 = KFAFCTY
     C**********         EVAL      WCOMPFA = *ZEROS                                           CSD027
     C                   EVAL      WCOMPFA = *BLANKS                                          CSD027
     C                   EVAL      WCOMPFB = *ZEROS
 
     C     KFACHIS1      SETLL     FACHSAL5
     C                   READ      FACHSAL5                               17
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        *IN17 = *OFF and WCOMPARE1 = WCOMPARE2
 
     C                   EVAL      RWRKDAT = FADATE
 
     C     KFACHIS1      SETLL     FACHSAL5
     C                   READ      FACHSAL5
 
      ** Update record in FACHISA
 
     C                   DOW       NOT %EOF(FACHSAL5)
 
     C                   EVAL      WCOMPFA = FACNUM
     C                   EVAL      WCOMPFB = FAFCTY
 
     C                   IF        WCOMPARE1 = WCOMPARE2
     C                   EVAL      FAREVI = 'R'
     C                   EVAL      FAGNDT = BJRDNB
     C                   EVAL      FACFGI = *BLANKS
     C                   UPDATE    FACHISA5
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      FACHSAL5
     C                   ENDDO
 
      ** Check if Previous Facility in FACACT
 
     C***********        EVAL      KBRCA = ACBRCA                                            BUG4377
     C**********         EVAL      KBRCA = WSBRCA                                   BUG4377 MD026337
     C                   EVAL      KCNUM = CANM
     C**********         MOVE      CAFT          KFCTY                                    AR1023928A
     C**********         MOVEL     CAFN          KFCTY                                    AR1023928A
     C                   MOVEL     CAFT          KFCTY                                    AR1023928A
     C                   MOVE      CAFN          KFCTY                                    AR1023928A
 
     C                   EVAL      KFCNUM = CANM                                            MD026337
     C                   EVAL      KFFACT = CAFT                                            MD026337
     C                   EVAL      KFFCNO = CAFN                                            MD026337
                                                                                            MD026337
     C     KFCLTY        CHAIN     FCLTYL3                            15                    MD026337
     C                   IF        *IN15 = *ON                                              MD026337
     C     KFCLTY        CHAIN     PEFCLFL3                           16                    MD026337
                                                                                            MD026337
      ** Database error                                                                     MD026337
                                                                                            MD026337
     C                   IF        *IN16 = *ON                                              MD026337
     C                   EVAL      DBFILE = 'PEFCLFM'                                       MD026337
     C                   EVAL      DBASE = 13                                               MD026337
     C                   EVAL      DBKEY = WDBKEY                                           MD026337
     C                   EXSR      *PSSR                                                    MD026337
     C                   ENDIF                                                              MD026337
     C                   ENDIF                                                              MD026337
     C                   EVAL      KBRCA = WSBRCA                                           MD026337
                                                                                            MD026337
     C     KFACACT       CHAIN     FACACTL1                           17
 
     C                   IF        *IN17 = *OFF
 
     C                   IF        RWRKDAT < FCDATE
     C                   EVAL      FCDATE = RWRKDAT
     C                   UPDATE    FACACTF
     C                   ENDIF
 
     C                   ELSE
 
     C************       EVAL      RSBRCA = ACBRCA                                           BUG4377
     C                   EVAL      RSBRCA = WSBRCA                                           BUG4377
     C**********         EVAL      FCCNUM = CANM                                            MD026337
     C**********         MOVE      CAFN          FCFCTY                                     MD026337
     C**********         MOVEL     CAFT          FCFCTY                                     MD026337
     C                   EVAL      FCCNUM = KFCNUM                                          MD026337
     C                   MOVE      KFFCNO        FCFCTY                                     MD026337
     C                   MOVEL     KFFACT        FCFCTY                                     MD026337
     C                   EVAL      FCDATE = RWRKDAT
     C                   WRITE     FACACTF
 
     C                   ENDIF
 
     C                   IF        CLE023 = 'Y' and RWRKDAT < BJRDNB
 
     C**********         EVAL      KHBRCA = ACBRCA                                           BUG4377
     C                   EVAL      KHBRCA = WSBRCA                                           BUG4377
     C**********         EVAL      KHCNUM = CANM                                            MD026337
     C**********         EVAL      KHFACT = CAFT                                            MD026337
     C**********         EVAL      KHFCNO = CAFN                                            MD026337
     C                   EVAL      KHCNUM = KFCNUM                                          MD026337
     C                   EVAL      KHFACT = KFFACT                                          MD026337
     C                   EVAL      KHFCNO = KFFCNO                                          MD026337
 
     C     KFACHISH      CHAIN     FACHISHL                           17
 
      ** Update FACHISH
 
     C                   IF        *IN17 = *OFF
 
     C                   EVAL      FHRWKR = 'Y'
     C                   EVAL      FHRWTP = 'B'
 
     C                   IF        FHRWDT = 0 or FHRWDT > RWRKDAT
     C                   EVAL      FHRWDT = RWRKDAT
     C                   ENDIF
 
     C                   UPDATE    FACHISHF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF                                                              AR788404
                                                                                            AR788404
     C                   ENDIF
 
     C                   EVAL      WNMVMT = 'Y'                                              BUG3035
     C                   EVAL      WACTBAL = 0
     C                   EVAL      WTEOP = 0
     C                   EVAL      WTEOC = 0
     C                   EVAL      WTEOF = 0
 
     C                   EVAL      WCUST = FCCU
     C                   EVAL      WFCLT = FACT
     C                   EVAL      WFCSQ = FCNO
 
     C**********         IF        WFACILTY <> *ZEROS                                         CLE041
     C**********         IF        WCUST <> *ZEROS AND WFCLT <> *ZEROS AND             CLE041 CSD027
     C                   IF        WCUST <> *BLANKS AND WFCLT <> *ZEROS AND                   CSD027
     C                             WCUST <> *ZEROS AND                                      BUG11624
     C                             WFCSQ <> *ZEROS                                            CLE041
 
     C                   EVAL      WACTBAL = CLBL
 
      ** Access APOSTPD/GLACPHPD record
 
     C                   EVAL      KACNUM = ACCNUM
     C                   EVAL      KACCY = ACCCY
     C                   EVAL      KAACOD = ACACOD
     C                   EVAL      KAACSQ = ACACSQ
     C                   EVAL      KABRCA = ACBRCA
     C                   EVAL      KAPSTD = *LOVAL
     C                   EVAL      WCOMAC1 = ACCNUM
     C                   EVAL      WCOMAC2 = ACCCY
     C                   EVAL      WCOMAC3 = ACACOD
     C                   EVAL      WCOMAC4 = ACACSQ
     C                   EVAL      WCOMAC5 = ACBRCA
     C**********         EVAL      WCOMACA = *ZEROS                                           CSD027
     C                   EVAL      WCOMACA = *BLANKS                                          CSD027
     C                   EVAL      WCOMACB = *BLANKS
     C                   EVAL      WCOMACC = *ZEROS
     C                   EVAL      WCOMACD = *ZEROS
     C                   EVAL      WCOMACE = *BLANKS
 
     C*****KAPOST        SETLL     APOSTJ0                                                AR1023928A
     C**********         READ      APOSTJ0                                                AR1023928A
     C     KAPOST        SETLL     APOSTJ2                                                AR1023928A
     C                   READ      APOSTJ2                                                AR1023928A
 
     C**********         DOW       NOT %EOF(APOSTJ0)                                      AR1023928A
     C                   DOW       NOT %EOF(APOSTJ2)                                      AR1023928A
 
     C                   EVAL      WCOMACA = APCNUM
     C                   EVAL      WCOMACB = CCY
     C                   EVAL      WCOMACC = APACOD
     C                   EVAL      WCOMACD = APACSQ
     C                   EVAL      WCOMACE = BRCA
 
     C                   IF        WCOMPACC1 = WCOMPACC2 and PSTD > F1FCHD
 
     C                   IF        DRCR = 0
     C                   EVAL      WACTBAL = WACTBAL - PSTA
     C                   ELSE
     C                   EVAL      WACTBAL = WACTBAL + PSTA
     C                   ENDIF
 
     C                   ELSE
 
      *                                                                                   AR1023928A
      ** Compare the two details before leaving the loop to make sure no record in        AR1023928A
      ** APOSTJ2 was left behind in processing.                                           AR1023928A
      *                                                                                   AR1023928A
     C                   IF        WCOMPACC1 <> WCOMPACC2                                 AR1023928A
     C                   LEAVE
     C                   ENDIF                                                            AR1023928A
 
     C                   ENDIF
 
      ** Read next record
 
     C**********         READ      APOSTJ0                                                AR1023928A
     C                   READ      APOSTJ2                                                AR1023928A
     C                   ENDDO
 
      ** Generate 'AS' entry
 
     C                   EVAL      WTRANSID = *ZEROS
     C                   EVAL      KFCNUM = FCCU
     C                   EVAL      KFFACT = FACT
     C                   EVAL      KFFCNO = FCNO
     C                   EVAL      WNMVMT = 'N'                                              BUG3035
     C                   EVAL      WACTION = 'AS'
     C                   EVAL      WACTCCY = ACCCY
     C                   EVAL      WACTDAT = F1FCHD
 
      ** Determine Valuation Details
 
     C                   EXSR      SRVALDET
 
     C                   EVAL      WREVAMT = WEXPOFF
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   EVAL      WTEOP = WEXPOFF
 
      ** Convert amount
 
     C                   EVAL      WCCY1 = ACCCY
     C**********         EVAL      WCCY2 = FCCY                                              BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
     C                   EVAL      WINAMT = WEXPOFF
     C                   EXSR      SRCONVERT
     C                   EVAL      WTEOF = WOUTAMT
                                                                                             BUG3035
     C                   MOVE      WCUST         KFCNUM                                      BUG3035
     C                   MOVE      WFCLT         KFFACT                                      BUG3035
     C                   MOVE      WFCSQ         KFFCNO                                      BUG3035
                                                                                             BUG3035
     C     KFCLTY        CHAIN     FCLTYL3                            17                     BUG3035
 
      ** If facility is tranche
 
     C**********         IF        TRCA = 'TR'                                               BUG3035
     C                   IF        *IN17 = *OFF and TRCA = 'TR'                              BUG3035
     C**********         EVAL      WCCY1 = ACCCY                                             BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY
     C                   EVAL      WINAMT = WTEOF
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SRCONVERT
     C                   EVAL      WTEOC = WOUTAMT
     C                   ENDIF
                                                                                          AR1023928A
      ** Update GLACNTQD                                                                  AR1023928A
                                                                                          AR1023928A
     C                   EVAL      KACCNUM = ACCNUM                                       AR1023928A
     C                   EVAL      KACCCY = ACCCY                                         AR1023928A
     C                   EVAL      KACACOD = ACACOD                                       AR1023928A
     C                   EVAL      KACACSQ = ACACSQ                                       AR1023928A
     C                   EVAL      KACBRCA = ACBRCA                                       AR1023928A
                                                                                          AR1023928A
     C     KACCNT        CHAIN     GLACNTL3                           15                  AR1023928A
     C                                                                                    AR1023928A
     C                   IF        *IN15 = *OFF                                           AR1023928A
      *                                                                                   AR1023928A
     C                   EVAL      F1ACBL = WACTBAL                                       AR1023928A
     C                   EVAL      F1TEXO = WTEOP                                         AR1023928A
     C                   EVAL      F1TEOF = WTEOF                                         AR1023928A
      *                                                                                   AR1023928A
     C                   IF        TRCA = 'TR'                                            AR1023928A
     C                   EVAL      F1TEOC = WTEOC                                         AR1023928A
     C                   ENDIF                                                            AR1023928A
      *                                                                                   AR1023928A
     C                   UPDATE    GLACNTD0                                               AR1023928A
      *                                                                                   AR1023928A
     C                   ENDIF                                                            AR1023928A
 
      ** Access APOSTPD/GLACPHPD record
 
     C                   EVAL      KACNUM = ACCNUM
     C                   EVAL      KACCY = ACCCY
     C                   EVAL      KAACOD = ACACOD
     C                   EVAL      KAACSQ = ACACSQ
     C                   EVAL      KABRCA = ACBRCA
     C                   EVAL      KAPSTD = *LOVAL
     C                   EVAL      WCOMAC1 = ACCNUM
     C                   EVAL      WCOMAC2 = ACCCY
     C                   EVAL      WCOMAC3 = ACACOD
     C                   EVAL      WCOMAC4 = ACACSQ
     C                   EVAL      WCOMAC5 = ACBRCA
     C**********         EVAL      WCOMACA = *ZEROS                                           CSD027
     C                   EVAL      WCOMACA = *BLANKS                                          CSD027
     C                   EVAL      WCOMACB = *BLANKS
     C                   EVAL      WCOMACC = *ZEROS
     C                   EVAL      WCOMACD = *ZEROS
     C                   EVAL      WCOMACE = *BLANKS
 
     C*****KAPOST        SETLL     APOSTJ0                                                AR1023928A
     C**********         READ      APOSTJ0                                                AR1023928A
     C     KAPOST        SETLL     APOSTJ2                                                AR1023928A
     C                   READ      APOSTJ2                                                AR1023928A
 
     C**********         DOW       NOT %EOF(APOSTJ0)                                      AR1023928A
     C                   DOW       NOT %EOF(APOSTJ2)                                      AR1023928A
 
     C                   EVAL      WCOMACA = APCNUM
     C                   EVAL      WCOMACB = CCY
     C                   EVAL      WCOMACC = APACOD
     C                   EVAL      WCOMACD = APACSQ
     C                   EVAL      WCOMACE = BRCA
 
     C                   IF        WCOMPACC1 = WCOMPACC2 and PSTD > F1FCHD
 
     C                   IF        DRCR = 0
     C                   EVAL      WACTBAL = WACTBAL + PSTA
     C                   ELSE
     C                   EVAL      WACTBAL = WACTBAL - PSTA
     C                   ENDIF
 
      ** Generate 'AC' entry
 
     C                   EVAL      WTRANSID = *ZEROS
     C                   EVAL      KFCNUM = FCCU
     C                   EVAL      KFFACT = FACT
     C                   EVAL      KFFCNO = FCNO
     C                   EVAL      WNMVMT = 'N'                                              BUG3035
     C                   EVAL      WACTION = 'AC'
     C                   EVAL      WACTCCY = ACCCY
     C                   EVAL      WACTDAT = PSTD
 
      ** Determine Valuation Details
 
     C                   EXSR      SRVALDET
 
     C                   EVAL      WREVAMT = WEXPOFF
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
     C                   EVAL      WTEOP = WEXPOFF
 
      ** Convert amount
 
     C                   EVAL      WCCY1 = ACCCY
     C**********         EVAL      WCCY2 = FCCY                                              BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
     C                   EVAL      WINAMT = WEXPOFF
     C                   EXSR      SRCONVERT
     C                   EVAL      WTEOF = WOUTAMT
                                                                                             BUG3035
     C                   MOVE      WCUST         KFCNUM                                      BUG3035
     C                   MOVE      WFCLT         KFFACT                                      BUG3035
     C                   MOVE      WFCSQ         KFFCNO                                      BUG3035
                                                                                             BUG3035
     C     KFCLTY        CHAIN     FCLTYL3                            17                     BUG3035
 
      ** If facility is tranche
 
     C**********         IF        TRCA = 'TR'                                               BUG3035
     C                   IF        *IN17 = *OFF and TRCA = 'TR'                              BUG3035
     C**********         EVAL      WCCY1 = ACCCY                                             BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY
     C                   EVAL      WINAMT = WTEOF
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SRCONVERT
     C                   EVAL      WTEOC = WOUTAMT
     C                   ENDIF
 
     C**********         ELSE                                                             AR1023928A
 
     C**********         LEAVE                                                            AR1023928A
 
     C**********         ENDIF                                                            AR1023928A
 
      ***Read*next*record**********************************************                   AR1023928A
 
     C**********         READ      APOSTJ0                                                AR1023928A
     C**********         ENDDO                                                            AR1023928A
 
     C**********         ENDIF                                                            AR1023928A
 
      ** Update GLACNTQD
 
     C                   EVAL      KACCNUM = ACCNUM
     C                   EVAL      KACCCY = ACCCY
     C                   EVAL      KACACOD = ACACOD
     C                   EVAL      KACACSQ = ACACSQ
     C                   EVAL      KACBRCA = ACBRCA
 
     C     KACCNT        CHAIN     GLACNTL3                           15
 
     C                   IF        *IN15 = *OFF
 
     C                   EVAL      F1ACBL = WACTBAL
                                                                                          AR1023928A
     C                   IF        WTEOF >= 0 OR WINCOFF = 'Y'                            AR1023928A
     C                   EVAL      F1TEXO = WTEOP
     C                   EVAL      F1TEOF = WTEOF
     C                   ENDIF                                                            AR1023928A
 
     C                   IF        TRCA = 'TR'
     C                   EVAL      F1TEOC = WTEOC
     C                   ENDIF
 
     C                   UPDATE    GLACNTD0
 
     C                   ENDIF
     C                   ELSE                                                             AR1023928A
      *                                                                                   AR1023928A
      ** Compare the two details before leaving the loop to make sure no record in        AR1023928A
      ** APOSTJ2 was left behind in processing.                                           AR1023928A
      *                                                                                   AR1023928A
     C                   IF        WCOMPACC1 <> WCOMPACC2                                 AR1023928A
     C                   LEAVE                                                            AR1023928A
     C                   ENDIF                                                            AR1023928A
     C                   ENDIF                                                            AR1023928A
      *                                                                                   AR1023928A
      ** Read next record                                                                 AR1023928A
      *                                                                                   AR1023928A
     C                   READ      APOSTJ2                                                AR1023928A
     C                   ENDDO                                                            AR1023928A
     C                   ENDIF                                                            AR1023928A
                                                                                             BUG3035
     C**********         IF        WNMVMT = 'Y'                                      BUG3035 BUG3934
     C**********         IF        WNMVMT = 'Y' and WFACILTY <> *ZEROS               BUG3934  CLE041
     C                   IF        WNMVMT = 'Y' AND                                           CLE041
     C**********                   WCUST <> *ZEROS AND WFCLT <> *ZEROS AND             CLE041 CSD027
     C                             WCUST <> *BLANKS AND WFCLT <> *ZEROS AND                   CSD027
     C                             WCUST <> *ZEROS AND                                      BUG11624
     C                             WFCSQ <> *ZEROS                                            CLE041
                                                                                             BUG3035
     C                   EVAL      WTRANSID = *ZEROS                                         BUG3035
     C                   MOVE      WCUST         KFCNUM                                      BUG3035
     C                   MOVE      WFCLT         KFFACT                                      BUG3035
     C                   MOVE      WFCSQ         KFFCNO                                      BUG3035
     C                   EVAL      WACTION = 'AR'                                            BUG3035
     C                   EVAL      WACTCCY = ACCCY                                           BUG3035
     C                   EVAL      WACTDAT = BJRDNB                                          BUG3035
     C                   EVAL      WREVAMT = F1TEXO                                          BUG3035
                                                                                             BUG3035
      ** Process Action                                                                      BUG3035
                                                                                             BUG3035
     C                   EXSR      SRPROCACT                                                 BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   EVAL      WCCY1 = WACTCCY                                           BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
     C                   EVAL      WINAMT = F1TEXO                                           BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOF = WOUTAMT                                          BUG3035
                                                                                             BUG3035
      ** If facility is tranche                                                              BUG3035
                                                                                             BUG3035
     C                   MOVE      WCUST         KFCNUM                                      BUG3035
     C                   MOVE      WFCLT         KFFACT                                      BUG3035
     C                   MOVE      WFCSQ         KFFCNO                                      BUG3035
                                                                                             BUG3035
     C     KFCLTY        CHAIN     FCLTYL3                            17                     BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   IF        *IN17 = *OFF and TRCA = 'TR'                              BUG3035
                                                                                             BUG3035
     C                   IF        ORFCCY = CACY                                             BUG3035
     C                   EVAL      F1TEOC = F1TEOF                                           BUG3035
     C                   ELSE                                                                BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY                                              BUG3035
     C                   EVAL      WINAMT = F1TEOF                                           BUG3035
     C                   EVAL      WRATE = WTRXRAT                                           BUG3035
     C                   EVAL      WMDIN = WTRMDIN                                           BUG3035
     C                   EVAL      GIVEN = 'Y'                                               BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOC = WOUTAMT                                          BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   UPDATE    GLACNTD0                                                  BUG3035
                                                                                             BUG3035
     C                   ENDIF                                                               BUG3035
 
     C                   ELSE                                                                BUG3035
                                                                                             BUG3035
     C                   EVAL      WCUST = FCCU                                              BUG3035
     C                   EVAL      WFCLT = FACT                                              BUG3035
     C                   EVAL      WFCSQ = FCNO                                              BUG3035
                                                                                             BUG3035
     C**********         IF        WFACILTY <> *ZEROS                                 BUG3035 CLE041
     C**********         IF        WCUST <> *ZEROS AND WFCLT <> *ZEROS AND             CLE041 CSD027
     C                   IF        WCUST <> *BLANKS AND WFCLT <> *ZEROS AND                   CSD027
     C                             WCUST <> *ZEROS AND                                      BUG11624
     C                             WFCSQ <> *ZEROS                                            CLE041
                                                                                             BUG3035
     C                   EVAL      KACCNUM = ACCNUM                                          BUG3035
     C                   EVAL      KACCCY = ACCCY                                            BUG3035
     C                   EVAL      KACACOD = ACACOD                                          BUG3035
     C                   EVAL      KACACSQ = ACACSQ                                          BUG3035
     C                   EVAL      KACBRCA = ACBRCA                                          BUG3035
                                                                                             BUG3035
     C     KACCNT        CHAIN     GLACNTL3                           15                     BUG3035
                                                                                             BUG3035
     C                   IF        *IN15 = *OFF                                              BUG3035
                                                                                             BUG3035
     C                   MOVE      FCCU          KFCNUM                                      BUG3035
     C                   MOVE      FACT          KFFACT                                      BUG3035
     C                   MOVE      FCNO          KFFCNO                                      BUG3035
     C                   EVAL      WTRANSID = *ZEROS                                         BUG3035
     C                   EVAL      WACTION = 'AR'                                            BUG3035
     C                   EVAL      WACTCCY = ACCCY                                           BUG3035
     C                   EVAL      WACTDAT = BJRDNB                                          BUG3035
     C                   EVAL      WREVAMT = F1TEXO                                          BUG3035
                                                                                             BUG3035
      ** Process Action                                                                      BUG3035
                                                                                             BUG3035
     C                   EXSR      SRPROCACT                                                 BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   EVAL      WCCY1 = WACTCCY                                           BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
     C                   EVAL      WINAMT = F1TEXO                                           BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOF = WOUTAMT                                          BUG3035
                                                                                             BUG3035
      ** If facility is tranche                                                              BUG3035
                                                                                             BUG3035
     C                   MOVE      WCUST         KFCNUM                                      BUG3035
     C                   MOVE      WFCLT         KFFACT                                      BUG3035
     C                   MOVE      WFCSQ         KFFCNO                                      BUG3035
                                                                                             BUG3035
     C     KFCLTY        CHAIN     FCLTYL3                            17                     BUG3035
                                                                                             BUG3035
      ** Convert amount                                                                      BUG3035
                                                                                             BUG3035
     C                   IF        *IN17 = *OFF and TRCA = 'TR'                              BUG3035
                                                                                             BUG3035
     C                   IF        ORFCCY = CACY                                             BUG3035
     C                   EVAL      F1TEOC = F1TEOF                                           BUG3035
     C                   ELSE                                                                BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY                                              BUG3035
     C                   EVAL      WINAMT = F1TEOF                                           BUG3035
     C                   EVAL      WRATE = WTRXRAT                                           BUG3035
     C                   EVAL      WMDIN = WTRMDIN                                           BUG3035
     C                   EVAL      GIVEN = 'Y'                                               BUG3035
     C                   EXSR      SRCONVERT                                                 BUG3035
     C                   EVAL      F1TEOC = WOUTAMT                                          BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   UPDATE    GLACNTD0                                                  BUG3035
                                                                                             BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      ACCNTJ0
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRSACUPD - Access Records in RSACMTPD                        *
      *                                                               *
      *****************************************************************
 
     C     SRRSACUPD     BEGSR
 
     C     *LOVAL        SETLL     RSACMTL3
     C                   READ      RSACMTL3
 
      ** Read first record
 
     C                   DOW       NOT %EOF(RSACMTL3)
 
     C                   IF        VUDT < BJDNWD
 
     C                   EVAL      KACCNUM = CUSN
     C                   EVAL      KACCCY = CCYD
     C                   EVAL      KACACOD = ACDE
     C                   EVAL      KACACSQ = ASNC
     C                   EVAL      KACBRCA = BRCA
     C                   EVAL      WACCNUM = CUSN
     C                   EVAL      WACACOD = ACDE
     C                   EVAL      WACACSQ = ASNC
     C**********         EVAL      WCUST = FCCU                                              BUG3035
     C**********         EVAL      WFCLT = FACT                                              BUG3035
     C**********         EVAL      WFCSQ = FCNO                                              BUG3035
 
     C     KACCNT        CHAIN     ACCNTJ0                            15
 
      ** Database error
 
     C                   IF        *IN15 = *ON
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE = 9
     C                   EVAL      DBKEY = WDBKEY2
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   EVAL      WCUST = FCCU                                              BUG3035
     C                   EVAL      WFCLT = FACT                                              BUG3035
     C                   EVAL      WFCSQ = FCNO                                              BUG3035
 
     C**********         IF        WFACILTY <> *ZEROS                                         CLE041
     C**********         IF        WCUST <> *ZEROS AND WFCLT <> *ZEROS AND             CLE041 CSD027
     C                   IF        WCUST <> *BLANKS AND WFCLT <> *ZEROS AND                   CSD027
     C                             WCUST <> *ZEROS AND                                      BUG11624
     C                             WFCSQ <> *ZEROS                                            CLE041
 
      ** Initialise fields
 
     C                   EVAL      WACTBAL = F1ACBL
     C                   EVAL      WTEOP = F1TEXO
     C                   EVAL      WTEOF = F1TEOF
     C                   EVAL      WTEOC = F1TEOC
 
     C                   IF        DORC = 0
     C                   EVAL      WACTBAL = WACTBAL + MVAM
     C                   ELSE
     C                   EVAL      WACTBAL = WACTBAL - MVAM
     C                   ENDIF
 
      ** Generate 'AC' entry
 
     C                   EVAL      WTRANSID = *ZEROS
     C                   EVAL      KFCNUM = FCCU
     C                   EVAL      KFFACT = FACT
     C                   EVAL      KFFCNO = FCNO
     C                   EVAL      WACTION = 'AC'
     C                   EVAL      WACTCCY = ACCCY
     C                   EVAL      WACTDAT = BJRDNB
 
      ** Determine Current Valuation Details
 
     C                   EXSR      SRCVALDET
 
     C                   EVAL      WREVAMT = WEXPOFF
 
      ** Process Action
 
     C                   EXSR      SRPROCACT
 
      ** Update GLACNTQD
 
     C     KACCNT        CHAIN     GLACNTL3                           15
 
     C                   IF        *IN15 = *OFF
 
     C                   EVAL      F1ACBL = WACTBAL
     C                   EVAL      F1TEXO = WEXPOFF
 
     C                   EVAL      WCCY1 = CCYD
     C**********         EVAL      WCCY2 = FCCY                                              BUG3035
     C                   EVAL      WCCY2 = ORFCCY                                            BUG3035
     C                   EVAL      WINAMT = WEXPOFF
     C                   EXSR      SRCONVERT
     C                   EVAL      F1TEOF = WOUTAMT
 
      ** If facility is tranche
 
     C**********         EVAL      KFCNUM = FCCU                                             BUG3035
     C**********         EVAL      KFFACT = FACT                                             BUG3035
     C**********         EVAL      KFFCNO = FCNO                                             BUG3035
     C                   MOVE      WCUST         KFCNUM                                      BUG3035
     C                   MOVE      WFCLT         KFFACT                                      BUG3035
     C                   MOVE      WFCSQ         KFFCNO                                      BUG3035
 
     C     KFCLTY        CHAIN     FCLTYL3                            17
 
     C                   IF        *IN17 = *OFF and TRCA = 'TR'
     C**********         EVAL      WCCY1 = CCYD                                              BUG3035
     C                   EVAL      WCCY1 = ORFCCY                                            BUG3035
     C                   EVAL      WCCY2 = CACY
     C**********         EVAL      WINAMT = WTEOF                                            BUG3035
     C                   EVAL      WINAMT = F1TEOF                                           BUG3035
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SRCONVERT
     C                   EVAL      F1TEOC = WOUTAMT
     C                   ENDIF
 
     C                   UPDATE    GLACNTD0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      RSACMTL3
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEALUPD - Update Dealing Files                              *
      *                                                               *
      *****************************************************************
 
     C     SRDEALUPD     BEGSR
 
      ** Access DLDLDBQD
 
     C     *LOVAL        SETLL     DLDLDBD0
     C                   READ      DLDLDBD0                               15
 
     C                   DOW       *IN15 = *OFF
 
     C                   EVAL      WCUST = F1FCCU
     C                   EVAL      WFCLT = F1FACT
     C                   EVAL      WFCSQ = F1FCNO
 
      ** Update file
 
     C**********         IF        WFACILTY <> *ZEROS                                         CSD027
     C                   IF        WFACILTY <> '      00000'                                  CSD027
     C                             AND WFACILTY <> '00000000000'                            BUG11624
 
     C                   EVAL      WCUST = F1OFCC
     C                   EVAL      WFCLT = F1OFAC
     C                   EVAL      WFCSQ = F1OFCN
 
     C**********         IF        WFACILTY = *ZEROS                                          CSD027
     C                   IF        WFACILTY = '      00000'                                   CSD027
     C                             OR WFACILTY = '00000000000'                              BUG11624
     C                   EVAL      F1OFCC = F1FCCU
     C                   EVAL      F1OFAC = F1FACT
     C                   EVAL      F1OFCN = F1FCNO
     C                   ENDIF
 
     C                   EVAL      F1FACI = 'Y'
     C                   UPDATE    DLDLDBD0
 
     C                   ELSE
 
     C                   EVAL      F1FACI = *BLANKS
     C                   UPDATE    DLDLDBD0
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DLDLDBD0                               15
     C                   ENDDO
 
      ** Access DLDLDCQD
 
     C     *LOVAL        SETLL     DLDLDCD0
     C                   READ      DLDLDCD0                               15
 
     C                   DOW       *IN15 = *OFF
 
     C                   EVAL      WCUST = F1FCCU
     C                   EVAL      WFCLT = F1FACT
     C                   EVAL      WFCSQ = F1FCNO
 
      ** Update file
 
     C**********         IF        WFACILTY <> *ZEROS                                         CSD027
     C                   IF        WFACILTY <> '      00000'                                  CSD027
     C                             AND WFACILTY <> '00000000000'                            BUG11624
 
     C                   EVAL      WCUST = F1OFCC
     C                   EVAL      WFCLT = F1OFAC
     C                   EVAL      WFCSQ = F1OFCN
 
     C**********         IF        WFACILTY = *ZEROS                                          CSD027
     C                   IF        WFACILTY = '      00000'                                   CSD027
     C                             OR WFACILTY = '00000000000'                              BUG11624
     C                   EVAL      F1OFCC = F1FCCU
     C                   EVAL      F1OFAC = F1FACT
     C                   EVAL      F1OFCN = F1FCNO
     C                   ENDIF
 
     C                   EVAL      F1FACI = 'Y'
     C                   UPDATE    DLDLDCD0
 
     C                   ELSE
 
     C                   EVAL      F1FACI = *BLANKS
     C                   UPDATE    DLDLDCD0
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DLDLDCD0                               15
     C                   ENDDO
 
      ** Access DLDLDGQD
 
     C     *LOVAL        SETLL     DLDLDGD0
     C                   READ      DLDLDGD0                               15
 
     C                   DOW       *IN15 = *OFF
 
     C                   EVAL      WCUST = F1FCCU
     C                   EVAL      WFCLT = F1FACT
     C                   EVAL      WFCSQ = F1FCNO
 
      ** Update file
 
     C**********         IF        WFACILTY <> *ZEROS                                         CSD027
     C                   IF        WFACILTY <> '      00000'                                  CSD027
     C                             AND WFACILTY <> '00000000000'                            BUG11624
 
     C                   EVAL      WCUST = F1OFCC
     C                   EVAL      WFCLT = F1OFAC
     C                   EVAL      WFCSQ = F1OFCN
 
     C**********         IF        WFACILTY = *ZEROS                                          CSD027
     C                   IF        WFACILTY = '      00000'                                   CSD027
     C                             OR WFACILTY = '00000000000'                              BUG11624
     C                   EVAL      F1OFCC = F1FCCU
     C                   EVAL      F1OFAC = F1FACT
     C                   EVAL      F1OFCN = F1FCNO
     C                   ENDIF
 
     C                   EVAL      F1FACI = 'Y'
     C                   UPDATE    DLDLDGD0
 
     C                   ELSE
 
     C                   EVAL      F1FACI = *BLANKS
     C                   UPDATE    DLDLDGD0
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DLDLDGD0                               15
     C                   ENDDO
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDLCALC - Compute for Deal's Exposure                       *
      *                                                               *
      *****************************************************************
 
     C     SRDLCALC      BEGSR
 
      ** Create java string objects for all parameters to be passed
 
     C                   EVAL      Parm1 = DLNO
     C                   EVAL      Parm2 = crtString(PMODULE)
     C                   EVAL      Parm3 = crtString(PSMODULE)
     C                   EVAL      Parm9 = 0
 
      ** Invoke the calculateTransactionExposure method of the CalcClass object
 
     C                   EVAL      RcvParms = getValues1(CalcClassObj:
     C                                                  Parm1:
     C                                                  Parm2:
     C                                                  Parm3:
     C                                                  Parm9)
 
      ** Convert the received java string to RPG bytes (Varying alpha field)
 
     C                   EVAL      WRcvStr = cvtToBytes(RcvParms)
 
      ** Retrieve all fields from received string via substring function
 
     C                   EVAL      WRcvFld0 = %SUBST(WRcvStr:1:1)
 
      ** Report if error occurred in calculator processing
 
     C                   IF        WRcvFld0 = 'E'
 
     C                   MOVEL     *ZEROS        PVALAMT
     C                   MOVEL     *ZEROS        PWEICDE
     C                   MOVEL     *ZEROS        PWCDPCT
     C                   MOVEL     *ZEROS        PEXPOSR
     C                   MOVEL     *ZEROS        POFFSET
     C                   MOVEL     *BLANKS       PEXPCCY
     C                   MOVEL     *BLANKS       PINCOFF
 
      ** Produce report
 
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      RINPUT = KDLNO + '-' + PMODULE + '-' +
     C                                      PSMODULE
     C                   EVAL      RCALC = 'calculateTransactionExposure'
     C                   EXSR      SRREPORT2
 
     C                   ELSE
 
     C                   EVAL      WRcvFld1 = %SUBST(WRcvStr:1:15)
     C                   EVAL      WRcvFld2 = %SUBST(WRcvStr:16:1)
     C                   EVAL      WRcvFld3 = %SUBST(WRcvStr:17:2)
     C                   EVAL      WRcvFld4 = %SUBST(WRcvStr:19:3)
     C                   EVAL      WRcvFld5 = %SUBST(WRcvStr:22:15)
     C                   EVAL      WRcvFld6 = %SUBST(WRcvStr:37:15)
     C                   EVAL      WRcvFld7 = %SUBST(WRcvStr:52:3)
     C                   EVAL      WRcvFld8 = %SUBST(WRcvStr:55:1)
 
     C                   MOVEL     WRcvFld1      PVALAMT
 
     C                   IF        WRcvFld2 = 'D'
     C                   Z-SUB     PVALAMT       PVALAMT
     C                   ENDIF
 
     C                   MOVEL     WRcvFld3      PWEICDE
     C                   MOVEL     WRcvFld4      PWCDPCT
     C                   MOVEL     WRcvFld5      PEXPOSR
     C                   MOVEL     WRcvFld6      POFFSET
     C                   MOVEL     WRcvFld7      PEXPCCY
     C                   MOVEL     WRcvFld8      PINCOFF
 
     C                   Z-SUB     POFFSET       POFFSET
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFXMCALC - Compute for Margin Exposure                      *
      *                                                               *
      *****************************************************************
 
     C     SRFXMCALC     BEGSR
 
      ** Retrieve the branch of the facility                                                 BUG3644
     C                   EVAL      KFCNUM = F2FCCU                                           BUG3644
     C                   EVAL      KFFACT = F2FACT                                           BUG3644
     C                   EVAL      KFFCNO = F2FCNO                                           BUG3644
                                                                                             BUG3644
     C     KFCLTY        CHAIN     FCLTYL3                            17                     BUG3644
                                                                                             BUG3644
      ** Create java string objects for all parameters to be passed
 
     C*****              EVAL      Parm4 = F2FCCU                                             CSD027
     C                   EVAL      Parm4 = crtString(F2FCCU)                                  CSD027
     C                   EVAL      Parm5 = F2FACT
     C                   EVAL      Parm6 = F2FCNO
     C                   EVAL      Parm7 = crtString(F2MACY)
     C                   EVAL      Parm10 = 0
     C                   EVAL      Parm11 = crtString(WSBRCA)                                BUG3644
 
     C                   MOVE      F2FCCU        WFCCU
     C                   MOVE      F2FACT        WFACT
     C                   MOVE      F2FCNO        WFCNO
 
      ** Invoke the calculateCurrFxmrReqmt method of the CalcClass object
 
     C                   EVAL      RcvParms = getValues2(CalcClassObj:
     C                                                  Parm11:                              BUG3644
     C                                                  Parm4:
     C                                                  Parm5:
     C                                                  Parm6:
     C                                                  Parm7:
     C                                                  Parm10)
 
      ** Convert the received java string to RPG bytes (Varying alpha field)
 
     C                   EVAL      WRcvStr = cvtToBytes(RcvParms)
 
      ** Retrieve all fields from received string via substring function
 
     C                   EVAL      WRcvFld0 = %SUBST(WRcvStr:1:1)
 
      ** Report if error occurred in calculator processing
 
     C                   IF        WRcvFld0 = 'E'
 
     C                   MOVEL     *ZEROS        PMVALAM
     C                   MOVEL     *BLANKS       PMRGTYP
     C                   MOVEL     *ZEROS        PMRGPCT
     C                   MOVEL     *ZEROS        PMRGREQ
     C                   MOVEL     *BLANKS       PMEXPCY
 
      ** Produce report
 
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      RINPUT = WFCCU + '-' + WFACT + '-' +
     C                                      WFCNO + '-' + F2MACY
     C                   EVAL      RCALC = 'calculateCurrFxmrReqmt'
     C                   EXSR      SRREPORT2
 
     C                   ELSE
 
     C                   EVAL      WRcvFld9 = %SUBST(WRcvStr:1:15)
     C                   EVAL      WRcvFld10 = %SUBST(WRcvStr:16:1)
     C                   EVAL      WRcvFld11 = %SUBST(WRcvStr:17:3)
     C                   EVAL      WRcvFld12 = %SUBST(WRcvStr:20:3)
     C                   EVAL      WRcvFld13 = %SUBST(WRcvStr:23:15)
     C                   EVAL      WRcvFld14 = %SUBST(WRcvStr:38:3)
 
     C                   MOVEL     WRcvFld9      PMVALAM
 
     C**********         IF        WRcvFld2 = 'D'                                            BUG4405
     C                   IF        WRcvFld10 = 'D'                                           BUG4405
     C                   Z-SUB     PMVALAM       PMVALAM
     C                   ENDIF
 
     C                   MOVEL     WRcvFld11     PMRGTYP
     C                   MOVEL     WRcvFld12     PMRGPCT
     C                   MOVEL     WRcvFld13     PMRGREQ
     C                   MOVEL     WRcvFld14     PMEXPCY
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMARGCAL - Flag for Margin Recalculation Subroutine          *
      *                                                               *
      *****************************************************************
 
     C     SRMARGCAL     BEGSR
 
     C     KDLFXMR       CHAIN     DLFXMRL0                           15
 
      ** Update/Write details in file
 
     C                   IF        *IN15 = *OFF
     C                   EVAL      F2RCAL = 'Y'
     C                   UPDATE    DLFXMRD0
     C                   ELSE
     C                   EVAL      F2FCCU = KMFCCU
     C                   EVAL      F2FACT = KMFACT
     C                   EVAL      F2FCNO = KMFCNO
     C                   EVAL      F2MACY = KMMACY
     C                   EVAL      F2TMAR = 0
     C                   EVAL      F2TMAF = 0
     C                   EVAL      F2TMAC = 0
     C                   EVAL      F2RCAL = 'Y'
     C                   WRITE     DLFXMRD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROCACT - Process Action Subroutine                         *
      *                                                               *
      *****************************************************************
 
     C     SRPROCACT     BEGSR
 
     C                   EVAL      WFCNUM = KFCNUM
     C                   EVAL      WFFACT = KFFACT
     C                   EVAL      WFFCNO = KFFCNO
 
     C     KFCLTY        CHAIN     FCLTYL3                            15
 
     C                   IF        *IN15 = *ON
 
     C     KFCLTY        CHAIN     PEFCLFL3                           16
 
      ***Database*error************************************************                     AR788404
      *****************************************************************                     AR788404
     C**********         IF        *IN16 = *ON                                              AR788404
     C**********         EVAL      DBFILE = 'PEFCLFM'                                       AR788404
     C**********         EVAL      DBASE = 4                                                AR788404
     C**********         EVAL      DBKEY = WDBKEY                                           AR788404
     C**********         EXSR      *PSSR                                                    AR788404
     C**********         ENDIF                                                              AR788404
 
     C                   ENDIF
 
      ** If record not found in PEFCLFM do not execute further                              AR788404
                                                                                            AR788404
     C                   IF        *IN15 = *OFF OR *IN16 = *OFF                             AR788404
     C                   EVAL      ORFCCY = FCCY                                             BUG3035
                                                                                             BUG3035
     C                   IF        RECI <> 'R'
 
      ** Determine Action Amount
 
     C                   IF        WACTION = 'RS' or WACTION = 'RV'
     C                   EVAL      WACTAMT = 0
     C                   ELSE
 
     C                   IF        FCCY = WACTCCY
     C                   EVAL      WACTAMT = WREVAMT
     C                   ELSE
     C                   EVAL      WCCY1 = WACTCCY
     C                   EVAL      WCCY2 = FCCY
     C                   EVAL      WINAMT = WREVAMT
     C                   EXSR      SRCONVERT
     C                   EVAL      WACTAMT = WOUTAMT
     C                   ENDIF
 
     C                   IF        WACTION = 'FX' or WACTION = 'F0' or
     C                             WACTION = 'FW' or WACTION = 'FV' or
     C                             WACTION = 'IR' or WACTION = 'IS' or
     C**********                   WACTION = 'AS' or WACTION = 'AC'                       AR1023928A
     C                             WACTION = 'AC'                                         AR1023928A
     C                             or WACTION = 'MR' or WACTION = 'AR'                       BUG3035
     C**********         IF        WACTAMT <> 0                                    253231 AR1023928A
     C                   EVAL      WACTAMT = WACTAMT - F1TEOF
     C**********         ENDIF                                                     253231 AR1023928A
     C                   ENDIF
 
     C                   IF        WACTION = 'M1'                                            BUG3035
     C                   EVAL      WACTAMT = F1TEOF                                          BUG3035
     C                   ENDIF                                                               BUG3035
                                                                                             BUG3035
     C                   IF        WACTION = 'FM'
     C                   EVAL      WACTAMT = WACTAMT - F2TMAF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update History Actions Table
 
     C                   IF        WACTION = 'RV' or WACTION = 'RS' or
     C                             WACTION = 'F0' or WACTION = 'FV' or
     C                             WACTION = 'IS' or WACTION = 'AS' or
     C                             WACTION = 'AC' or WACTAMT <> 0
     C                             or WACTION = 'M1'                                         BUG3035
 
     C                   EVAL      WUPDAT = '1'
 
      ** Update HISACT
 
     C                   EXSR      SRHISACT
 
      ** Update FACACT
 
     C                   EVAL      KBRCA = BRCA
     C                   EVAL      KCNUM = KFCNUM
     C                   MOVE      KFFCNO        KFCTY
     C                   MOVEL     KFFACT        KFCTY
     C                   EXSR      SRFACACT
 
      ** Update FACHISH
 
     C                   EVAL      KHBRCA = BRCA
     C                   EVAL      KHCNUM = KFCNUM
     C                   EVAL      KHFACT = KFFACT
     C                   EVAL      KHFCNO = KFFCNO
     C                   EXSR      SRFACHISH
 
     C                   ENDIF
 
      ** If facility is tranche
 
     C                   IF        TRCA = 'TR'
 
     C                   EVAL      WTRXRAT = CAXR
     C                   EVAL      WTRMDIN = CMDI
 
     C                   EVAL      KFCNUM = CANM
     C                   EVAL      KFFACT = CAFT
     C                   EVAL      KFFCNO = CAFN
     C                   EVAL      WFCNUM = CANM
     C                   EVAL      WFFACT = CAFT
     C                   EVAL      WFFCNO = CAFN
     C                   EVAL      PFCCY = FCCY
     C                   EVAL      PCACY = CACY
 
     C     KFCLTY        CHAIN     FCLTYL3                            15
 
     C                   IF        *IN15 = *ON
 
     C     KFCLTY        CHAIN     PEFCLFL3                           16
 
      ***Database*error************************************************                     AR788404
      *****************************************************************                     AR788404
     C**********         IF        *IN16 = *ON                                              AR788404
     C**********         EVAL      DBFILE = 'PEFCLFM'                                       AR788404
     C**********         EVAL      DBASE = 5                                                AR788404
     C**********         EVAL      DBKEY = WDBKEY                                           AR788404
     C**********         EXSR      *PSSR                                                    AR788404
     C**********         ENDIF                                                              AR788404
 
     C                   ENDIF
 
      ** If record not found in PEFCLFM do not execute further                              AR788404
                                                                                            AR788404
     C                   IF        *IN15 = *OFF OR *IN16 =*OFF                              AR788404
     C                   IF        RECI <> 'R'
 
      ** Determine Action Amount
 
     C                   IF        WACTION = 'RV' OR WACTION = 'RS'
     C                   EVAL      WACTAMT = 0
     C                   ELSE
 
     C                   IF        PCACY = PFCCY
     C                   EVAL      WACTAMT = WACTAMT
     C                   ELSE
     C                   EVAL      WCCY1 = PFCCY
     C                   EVAL      WCCY2 = PCACY
     C                   EVAL      WINAMT = WACTAMT
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SRCONVERT
     C                   EVAL      WACTAMT = WOUTAMT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WACTION = 'RV' or WACTION = 'RS' or
     C                             WACTION = 'F0' or WACTION = 'FV' or
     C                             WACTION = 'IS' or WACTION = 'AS' or
     C                             WACTION = 'AC' or WACTAMT <> 0
     C                             or WACTION = 'M1'                                         BUG3035
 
     C                   EVAL      WUPDAT = '2'
 
      ** Update HISACT
 
     C                   EXSR      SRHISACT
 
      ** Update FACACT
 
     C                   EVAL      KBRCA = BRCA
     C                   EVAL      KCNUM = KFCNUM
     C                   MOVE      KFFCNO        KFCTY
     C                   MOVEL     KFFACT        KFCTY
     C                   EXSR      SRFACACT
 
      ** Update FACHISH
 
     C                   EVAL      KHBRCA = BRCA
     C                   EVAL      KHCNUM = KFCNUM
     C                   EVAL      KHFACT = KFFACT
     C                   EVAL      KHFCNO = KFFCNO
     C                   EXSR      SRFACHISH
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                            AR788404
     C                   ENDIF                                                              AR788404
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                            AR788404
     C                   ENDIF                                                              AR788404
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHISACT - Update HISACT File                                 *
      *                                                               *
      *****************************************************************
 
     C     SRHISACT      BEGSR
 
     C**********         IF        WACTAMT <> 0                                   BUG8262 AR1023928A
     C                   IF        WACTAMT <> 0 or                                        AR1023928A
     C                             WACTION = 'AS'                                         AR1023928A
      *                                                                                      BUG8262
     C                   EVAL      BRCA = WSBRCA
     C                   EVAL      HACNUM = KFCNUM
     C                   MOVEL     KFFACT        HAFCTY
     C                   MOVE      KFFCNO        HAFCTY
     C                   EVAL      HADATE = WACTDAT
      *                                                                                      BUG8222
     C                   IF        HADATE < FACHISD                                          BUG8222
     C                             AND FMORED < FACHISD                                      BUG8222
     C                   EVAL      HADATE = FACHISD                                          BUG8222
     C                   ENDIF                                                               BUG8222
      *                                                                                      BUG8222
     C**********         EVAL      HALOAN = *ZEROS                                            CLE148
     C                   EVAL      HALOAN = *BLANKS                                           CLE148
     C                   EVAL      HAACTN = WACTION
     C                   EVAL      HAAAMT = WACTAMT
     C                   EVAL      HAPART = *BLANKS
     C                   EVAL      HALCRF = *BLANKS
     C                   EVAL      GEDT = 0
     C                   EVAL      HASQNO = 0
     C                   EVAL      HAECIN = *BLANKS
     C                   EVAL      HAGASS = *BLANKS
     C                   EVAL      HATRRC = *BLANKS
     C                   EVAL      HAOLRC = *BLANKS
     C                   EVAL      HAPTYP = 0
     C                   EVAL      HARCSI = *BLANKS
     C                   EVAL      HALPFI = *BLANKS
     C                   EVAL      HADEAL = WTRANSID
 
     C                   IF        WACTION = 'RV' or WACTION = 'RS'
     C                   EVAL      HASEQ = 0
     C                   EVAL      HATSEQ = 0
     C                   ELSE
 
     C                   IF        WACTION = 'AS'
     C                   EVAL      HASEQ = 97
     C                   EVAL      HATSEQ = 97
     C                   ELSE
 
     C                   EVAL      HASEQ = 98
     C                   EVAL      HATSEQ = 98
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WACTION = 'RV' or WACTION = 'RS'
     C                   EVAL      HARCIN = *BLANKS
     C                   EVAL      HALUCY = *BLANKS
     C                   EVAL      HAEXRT = 0
     C                   EVAL      HARTMD = *BLANKS
     C                   EVAL      HAEXCY = *BLANKS
     C                   EVAL      HALUAM = 0
     C                   ELSE
 
     C                   EVAL      HARCIN = RVCR
     C                   EVAL      HAEXCY = WACTCCY
 
     C                   IF        WUPDAT = '1'
 
     C                   IF        FCCY <> WACTCCY
 
     C                   EVAL      HALUCY = WACTCCY
     C                   EVAL      HAEXRT = WRATE
     C                   EVAL      HARTMD = WMDIN
 
     C                   IF        WACTION = 'FX' or WACTION = 'F0' or
     C                             WACTION = 'FW' or WACTION = 'FV' or
     C                             WACTION = 'IR' or WACTION = 'IS'
     C                             or WACTION = 'MR' or WACTION = 'M1'                       BUG3035
     C                             or WACTION = 'AR'                                         BUG3035
     C                   EVAL      HALUAM = WREVAMT - F1TEXO
     C                   ELSE
 
     C                   IF        WACTION = 'FM'
     C                   EVAL      HALUAM = WREVAMT - F2TMAR
     C                   ELSE
 
     C                   IF        WACTION = 'AS' or WACTION = 'AC'
     C                   EVAL      HALUAM = WREVAMT - WTEOP
     C                   ELSE
     C                   EVAL      HALUAM = WREVAMT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      HALUCY = *BLANKS
     C                   EVAL      HAEXRT = 0
     C                   EVAL      HARTMD = *BLANKS
     C                   EVAL      HALUAM = 0
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PCACY <> PFCCY
     C                   EVAL      HALUCY = PFCCY
     C                   EVAL      HAEXRT = WTRXRAT
     C                   EVAL      HARTMD = WTRMDIN
     C                   EVAL      HALUAM = WACTAMT
     C                   ELSE
     C                   EVAL      HALUCY = *BLANKS
     C                   EVAL      HAEXRT = 0
     C                   EVAL      HARTMD = *BLANKS
     C                   EVAL      HALUAM = 0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WACTION = 'FM'
     C                   EVAL      HAMCY = WACTCCY
     C                   EVAL      HAFXMT = PMRGTYP
     C                   EVAL      HAFXPC = PMRGPCT
     C                   ELSE
     C                   EVAL      HAMCY = *BLANKS
     C                   EVAL      HAFXMT = *BLANKS
     C                   EVAL      HAFXPC = 0
     C                   ENDIF
 
     C                   IF        WACTION = 'AS' or WACTION = 'AC'
     C                             or WACTION = 'AR'                                         BUG3035
     C                   EVAL      HAACBR = ACBRCA
     C                   EVAL      HAACCU = ACCNUM
     C                   EVAL      HAACCY = ACCCY
     C                   EVAL      HAACCD = ACACOD
     C                   EVAL      HAACSQ = ACACSQ
     C                   EVAL      HAACNO = ACACNO
     C                   ELSE
     C                   EVAL      HAACBR = *BLANKS
     C**********         EVAL      HAACCU = *ZEROS                                            CSD027
     C                   EVAL      HAACCU = *BLANKS                                           CSD027
     C                   EVAL      HAACCY = *BLANKS
     C                   EVAL      HAACCD = *ZEROS
     C                   EVAL      HAACSQ = *ZEROS
     C                   EVAL      HAACNO = *ZEROS
     C                   ENDIF
 
     C                   IF        WACTION = 'FX' or WACTION = 'F0' or
     C                             WACTION = 'FV' or WACTION = 'FW' or
     C                             WACTION = 'IS' or WACTION = 'IR'
     C                             or WACTION = 'MR' or WACTION = 'M1'                       BUG3035
     C                             or WACTION = 'AR'                                         BUG3035
 
     C                   EVAL      HAWEIG = PWEICDE
     C                   EVAL      HAWCPC = PWCDPCT
     C                   EVAL      HAINOF = PINCOFF
     C                   EVAL      HATVAL =  PVALAMT
 
     C                   IF        WUPDAT = '1'
     C                   EVAL      HAPTEO = F1TEOF
     C                   ELSE
     C                   EVAL      HAPTEO = F1TEOC
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        WACTION = 'FM'
 
     C                   EVAL      HATVAL = PMVALAM
 
     C                   IF        WUPDAT = '1'
     C                   EVAL      HAPTEO = F2TMAF
     C                   ELSE
     C                   EVAL      HAPTEO = F2TMAC
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        WACTION = 'AS' or WACTION = 'AC'
     C                             or WACTION = 'AR'                                         BUG3035
 
     C                   EVAL      HAWEIG = WWEICDE
     C                   EVAL      HAWCPC = WWCDPCT
     C                   EVAL      HAINOF = WINCOFF
     C                   EVAL      HATVAL = WACTBAL
 
     C                   IF        WUPDAT = '1'
     C                   EVAL      HAPTEO = WTEOF
     C                   ELSE
     C                   EVAL      HAPTEO = WTEOC
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      HAWEIG = 0
     C                   EVAL      HAWCPC = 0
     C                   EVAL      HAINOF = *BLANKS
     C                   EVAL      HATVAL = 0
     C                   EVAL      HAPTEO = 0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WACTION = 'FX' or WACTION = 'F0' or
     C                             WACTION = 'FV' or WACTION = 'FW' or
     C                             WACTION = 'IS' or WACTION = 'IR' or
     C                             WACTION = 'FM' or WACTION = 'AS' or
     C                             WACTION = 'AC'
     C                             or WACTION = 'MR' or WACTION = 'M1'                       BUG3035
     C                             or WACTION = 'AR'                                         BUG3035
 
     C                   IF        WUPDAT = '1'
     C                   EVAL      WCCY1 = WACTCCY
     C                   EVAL      WCCY2 = FCCY
     C                   EVAL      WINAMT = WREVAMT
     C                   EXSR      SRCONVERT
     C                   EVAL      HATTEO = WOUTAMT
     C                   ELSE
     C                   EVAL      HATTEO = HAPTEO + WACTAMT
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      HATTEO = 0
 
     C                   ENDIF
 
     C                   WRITE     HISACTF
 
     C                   EXSR      SRREPORT
 
     C                   ENDIF                                                               BUG8262
      *                                                                                      BUG8262
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFACACT - Update FACACT File                                 *
      *                                                               *
      *****************************************************************
 
     C     SRFACACT      BEGSR
 
     C**********         IF        WACTAMT <> 0                                     BUG8262 MD026331
     C                   IF        WACTAMT <> 0 or                                          MD026331
     C                             WACTION = 'AS'                                           MD026331
                                                                                             BUG8262
      ** Check if facility exists in file
 
     C     KFACACT       CHAIN     FACACTL1                           15
 
     C                   IF        *IN15 = *OFF
 
     C                   IF        HADATE < FCDATE
     C                   EVAL      FCDATE = HADATE
     C                   UPDATE    FACACTF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      RSBRCA = BRCA
     C                   EVAL      FCCNUM = KFCNUM
     C                   MOVE      KFFCNO        FCFCTY
     C                   MOVEL     KFFACT        FCFCTY
     C                   EVAL      FCDATE = HADATE
 
     C                   WRITE     FACACTF
 
     C                   ENDIF
 
     C                   ENDIF                                                               BUG8262
                                                                                             BUG8262
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFACHISH - Update FACHISH File                               *
      *                                                               *
      *****************************************************************
 
     C     SRFACHISH     BEGSR
 
     C**********         IF        WACTAMT <> 0                                     BUG8262 MD026331
     C                   IF        WACTAMT <> 0 or                                          MD026331
     C                             WACTION = 'AS'                                           MD026331
                                                                                             BUG8262
     C                   IF        CLE023 = 'Y' and HADATE < BJRDNB
 
      ** Check if facility exists in file
 
     C     KFACHISH      CHAIN     FACHISHL                           15
 
     C                   IF        *IN15 = *OFF
 
     C                   EVAL      FHRWKR = 'Y'
     C                   EVAL      FHRWTP = 'B'
 
     C                   IF        FHRWDT = 0 or FHRWDT > HADATE
     C                   EVAL      FHRWDT = HADATE
     C                   ENDIF
 
     C                   UPDATE    FACHISHF
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                             BUG8262
     C                   ENDIF                                                               BUG8262
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALDET - Determine Valuation Details                        *
      *                                                               *
      *****************************************************************
 
     C     SRVALDET      BEGSR
 
     C                   EVAL      KFACNUM = PFCU
     C                   MOVEL     PFTP          KFAFCTY
     C                   MOVE      PFSQ          KFAFCTY
     C                   EVAL      KFAACBR = ACBRCA
     C                   EVAL      KFAACCU = ACCNUM
     C                   EVAL      KFAACCY = ACCCY
     C                   EVAL      KFAACCD = ACACOD
     C                   EVAL      KFAACSQ = ACACSQ
     C                   EVAL      KFADATE = WACTDAT
     C                   EVAL      WCOMFC1 = KFACNUM
     C                   EVAL      WCOMFC2 = KFAFCTY
     C                   EVAL      WCOMFC3 = KFAACCU
     C                   EVAL      WCOMFC4 = KFAACCY
     C                   EVAL      WCOMFC5 = KFAACCD
     C                   EVAL      WCOMFC6 = KFAACSQ
     C                   EVAL      WCOMFC7 = KFAACBR
     C**********         EVAL      WCOMFCA = *ZEROS                                           CSD027
     C                   EVAL      WCOMFCA = *BLANKS                                          CSD027
     C                   EVAL      WCOMFCB = *ZEROS
     C**********         EVAL      WCOMFCC = *ZEROS                                           CSD027
     C                   EVAL      WCOMFCC = *BLANKS                                          CSD027
     C                   EVAL      WCOMFCD = *BLANKS
     C                   EVAL      WCOMFCE = *ZEROS
     C                   EVAL      WCOMFCF = *ZEROS
     C                   EVAL      WCOMFCG = *BLANKS
 
      ** Determine if exact record exists
 
     C     KFACHIS2      CHAIN     FACHSAL5                           15
 
     C                   IF        *IN15 = *ON
     C                             or *IN15 = '0' and FAREVI = 'R'                        AR1023928A
 
      ** Read first previous record
 
     C     KFACHIS2      SETGT     FACHSAL5
     C                   READP     FACHSAL5                               16
 
     C                   EVAL      WCOMFCA = FACNUM
     C                   EVAL      WCOMFCB = FAFCTY
     C                   EVAL      WCOMFCC = FAACCU
     C                   EVAL      WCOMFCD = FAACCY
     C                   EVAL      WCOMFCE = FAACCD
     C                   EVAL      WCOMFCF = FAACSQ
     C                   EVAL      WCOMFCG = FAACBR
 
     C                   IF        WCOMPFAC1 <> WCOMPFAC2 or *IN16 = *ON
     C                             or WCOMPFAC1 = WCOMPFAC2 and FAREVI = 'R'              AR1023928A
 
      ** Read first next record
 
     C     KFACHIS2      SETLL     FACHSAL5
     C                   READ      FACHSAL5                               17
 
     C                   EVAL      WCOMFCA = FACNUM
     C                   EVAL      WCOMFCB = FAFCTY
     C                   EVAL      WCOMFCC = FAACCU
     C                   EVAL      WCOMFCD = FAACCY
     C                   EVAL      WCOMFCE = FAACCD
     C                   EVAL      WCOMFCF = FAACSQ
     C                   EVAL      WCOMFCG = FAACBR
 
     C                   IF        WCOMPFAC1 <> WCOMPFAC2 or *IN17 = *ON
     C                   EXSR      SRCVALDET
     C                   ELSE
 
     C                   EVAL      WWEICDE = FAWEIG
     C                   EVAL      WWCDPCT = FAWCPC
     C                   EVAL      WINCOFF = FAINOF
 
     C                   IF        WACTBAL >= 0
     C                   EVAL      WEXPOFF = WACTBAL
     C                   ELSE
 
     C                   IF        WINCOFF = 'Y'
     C                   EVAL      WEXPOFF = WACTBAL * (WWCDPCT / 100)
     C                   ELSE
     C                   EVAL      WEXPOFF = 0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCVALDET - Determine Current Valuation Details               *
      *                                                               *
      *****************************************************************
 
     C     SRCVALDET     BEGSR
 
      ** Access Account Code details
 
     C                   MOVE      ACACOD        PACOD
 
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PACOD
     C     SDACOD        PARM      SDACOD        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDACODPD'
     C                   EVAL      DBASE = 10
     C                   EVAL      DBKEY = PACOD
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Instrument Types
 
     C                   CALL      'AOPLINR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    A5INNR
     C     SDPLIN        PARM      SDPLIN        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      WWEICDE = *ZEROS
     C                   EVAL      WWCDPCT = 100
     C                   EVAL      WINCOFF = 'Y'
     C                   ELSE
 
     C                   EVAL      WINCOFF = PLPDINOF
 
     C                   IF        WINCOFF = 'C'
 
     C                   MOVEL     ACCNUM        PCNUM
 
      ** Access Customer details
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM                    PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 11
     C                   EVAL      DBKEY = PCNUM
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WINCOFF = BBINOF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Access Instrument Types
 
     C                   CALL      'GPAOWEIGR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PLPDWEIG
     C     SDWEIG        PARM      SDWEIG        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      WWEICDE = PLPDWEIG
     C                   EVAL      WWCDPCT = 100
     C                   ELSE
     C                   EVAL      WWEICDE = PLPDWEIG
     C                   EVAL      WWCDPCT = PDPERC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WACTBAL >= 0
     C                   EVAL      WEXPOFF = WACTBAL
     C                   ELSE
 
     C                   IF        WINCOFF = 'Y'
     C                   EVAL      WEXPOFF = WACTBAL * (WWCDPCT / 100)
     C                   ELSE
     C                   EVAL      WEXPOFF = 0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCONVERT - Convert Currency                                  *
      *                                                               *
      *****************************************************************
 
     C     SRCONVERT     BEGSR
 
      ** If one of currencies is blank, skip conversion
 
     C                   IF        WCCY1 = *BLANKS or WCCY2 = *BLANKS
     C                   EVAL      WOUTAMT = 0
     C                   EVAL      WRATE = 0
     C                   EVAL      WMDIN = *BLANKS
     C                   ELSE
 
      ** From currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY1
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = WCCY1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Save necessary details
 
     C                   EVAL      WSPRT1 = A6SPRT
     C                   EVAL      WMDIN1 = A6MDIN
     C                   EVAL      WNBDP1 = A6NBDP
 
      ** To currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY2
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = WCCY2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Save necessary details
 
     C                   EVAL      WSPRT2 = A6SPRT
     C                   EVAL      WMDIN2 = A6MDIN
     C                   EVAL      WNBDP2 = A6NBDP
 
     C                   IF        GIVEN = 'N'
 
      ** Get exchange rate
 
     C                   EVAL      XMDIN1 = WMDIN1
     C                   EVAL      XMDIN2 = WMDIN2
     C                   EVAL      XSPRT1 = WSPRT1
     C                   EVAL      XSPRT2 = WSPRT2
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    XSPRT1
     C                   PARM                    XMDIN1
     C                   PARM                    XSPRT2
     C                   PARM                    XMDIN2
     C                   PARM                    WRATE
     C                   PARM                    WMDIN
 
     C                   ENDIF
 
      ** Convert amount
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    WINAMT
     C                   PARM                    WRATE
     C                   PARM                    WMDIN
     C                   PARM                    WCCY1
     C                   PARM                    WCCY2
     C                   PARM                    WNBDP1
     C                   PARM                    WNBDP2
     C                   PARM                    WOUTAMT
 
     C                   ENDIF
 
     C                   EVAL      GIVEN = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREPORT - Write Details on Report                           *
      *                                                               *
      *****************************************************************
 
     C     SRREPORT      BEGSR
 
      ** Move details to report fields
 
     C                   IF        HADEAL = *ZEROS
     C                   EVAL      RDEAL = *BLANKS
     C                   ELSE
     C                   MOVE      HADEAL        RDEAL
     C                   ENDIF
 
     C                   EVAL      RACTION = HAACTN
 
      ** Format account
 
     C                   IF        HAACTN = 'AC' or HAACTN = 'AS'
     C                   MOVE      HAACCU        RCUST
     C                   MOVE      '-'           RDASH1
     C                   MOVE      HAACCY        RCCY
     C                   MOVE      '-'           RDASH2
     C                   MOVE      HAACCD        RACOD
     C                   MOVE      '-'           RDASH3
     C                   MOVE      HAACSQ        RACSQ
     C                   MOVE      '-'           RDASH4
     C                   MOVE      HAACBR        RBRCA
     C                   EVAL      RACCOUNT = WACCOUNT
     C                   ELSE
     C                   EVAL      RACCOUNT = *BLANKS
     C                   ENDIF
 
     ** Format facility
 
     C                   MOVE      KFCNUM        RFCCU
     C                   MOVE      '-'           RDASH5
     C                   MOVE      KFFACT        RFACT
     C                   MOVE      '-'           RDASH6
     C                   MOVE      KFFCNO        RFCNO
     C                   EVAL      RFACILTY = WFCLTY
 
      ** Format currency
 
     C                   IF        WUPDAT = '1'
     C                   EVAL      RVFCCY = FCCY
     C                   ELSE
     C                   EVAL      RVFCCY = PCACY
     C                   ENDIF
 
      ** Format date
 
     C                   EVAL      ZDAYNO = HADATE
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   EVAL      RVDATE = ZADATE
 
      ** Format amount
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    RVFCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   EVAL      ZFLD15 = HAAAMT
     C                   EVAL      ZDECS = A6NBDP
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
 
     C                   EVAL      RAMOUNT = ZOUT21
 
      ** Determine description
 
     C                   SELECT
     C                   WHEN      RACTION = 'RV'
     C                   EVAL      RDESC = 'REVERSAL'
     C                   WHEN      RACTION = 'RS'
     C                   EVAL      RDESC = 'REINSTATEMENT'
     C                   WHEN      RACTION = 'FX'
     C                   EVAL      RDESC = 'FX MARK-TO-MARKET REVALUATION'
     C                   WHEN      RACTION = 'F0'
     C                   EVAL      RDESC = 'FX EXPIRY'
     C                   WHEN      RACTION = 'S1'
     C                   EVAL      RDESC = 'MM LOAN START'
     C                   WHEN      RACTION = 'M1'
     C                   EVAL      RDESC = 'MM LOAN MATURITY'
     C                   WHEN      RACTION = 'C1'
     C                   EVAL      RDESC = 'MM LOAN INTEREST CAPITALISATION'
     C                   WHEN      RACTION = 'I1'
     C                   EVAL      RDESC = 'MM LOAN PRINCIPAL INCREASE'
     C                   WHEN      RACTION = 'D1'
     C                   EVAL      RDESC = 'MM LOAN PRINCIPAL DECREASE'
     C                   WHEN      RACTION = 'MR'                                            BUG3035
     C                   EVAL      RDESC = 'MM SPOT REVALUATION'                             BUG3035
     C                   WHEN      RACTION = 'FW'
     C                   EVAL      RDESC = 'FRA MARK-TO-MARKET REVALUATION'
     C                   WHEN      RACTION = 'FV'
     C                   EVAL      RDESC = 'FRA EXPIRY'
     C                   WHEN      RACTION = 'IR'
     C                   EVAL      RDESC = 'IRS MARK-TO-MARKET REVALUATION'
     C                   WHEN      RACTION = 'IS'
     C                   EVAL      RDESC = 'IRS EXPIRY'
     C                   WHEN      RACTION = 'FM'
     C                   EVAL      RDESC = 'FX MARGIN'
     C                   WHEN      RACTION = 'AS'
     C                   EVAL      RDESC = 'ACCOUNT START'
     C                   WHEN      RACTION = 'AC'
     C                   EVAL      RDESC = 'ACCOUNT MOVEMENT'
     C                   WHEN      RACTION = 'AR'                                            BUG3035
     C                   EVAL      RDESC = 'ACCOUNT SPOT REVALUATION'                        BUG3035
     C                   ENDSL
 
      ** Check that sufficient lines remain for the format
 
     C**********         EVAL      RQDLN1 = 2                                               MD020170
     C                   EVAL      RQDLN1 = 6                                               MD020170
      *                                                                                     MD020170
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRREPORT2 - Report Errors Encountered in Calculator           *
      *                                                               *
      *****************************************************************
 
     C     SRREPORT2     BEGSR
 
     C**********         EVAL      RDESC2 = 'ERROR OCCURRED IN CALCULATOR +                  BUG4405
     C**********                           PROCESSING'                                       BUG4405
                                                                                             BUG6138
     C                   EVAL      %LEN(WRcvStr) = 86                                        BUG6138
     C                   EVAL      RDESC2 = %SUBST(WRcvStr:7:80)                             BUG4405
 
      ** Check that sufficient lines remain for the format
 
     C                   EVAL      RQDLN2 = 2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
 
     C                   WRITE     DETAIL2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRENDRPT - Close Report File                                 *
      *                                                               *
      *****************************************************************
 
     C     SRENDRPT      BEGSR
 
      ** Check that sufficient lines remain for the format
 
     C                   EVAL      RQDLN1 = 1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   EVAL      RQDLN2 = 1
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
 
      ** Write 'No Details' if no error was reported
 
     C                   IF        WERROR = 'N'
     C                   WRITE     NODTLS
     C                   ENDIF
 
      ** Write out trailer format
 
     C                   WRITE     TRAILP1
     C                   WRITE     TRAILP2
 
     C                   CLOSE     LE000030P1
     C                   CLOSE     LE000030P2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      *                                                                                      BUG8222
      ** Retrieve LERSTS                                                                     BUG8222
      *                                                                                      BUG8222
     C                   IN        LERSTS                                                    BUG8222
      *                                                                                      BUG8222
     C                   EVAL      DBPGM = 'LE000030'
     C                   EVAL      GIVEN = 'N'
     C                   EVAL      WERROR = 'N'
 
     C     KFACHISA      KLIST
     C                   KFLD                    KFACNUM
     C                   KFLD                    KFAFCTY
     C                   KFLD                    KFADEAL
 
     C     KFACHIS1      KLIST
     C                   KFLD                    KFACNUM
     C                   KFLD                    KFAFCTY
     C                   KFLD                    KFAACBR
     C                   KFLD                    KFAACCU
     C                   KFLD                    KFAACCY
     C                   KFLD                    KFAACCD
     C                   KFLD                    KFAACSQ
 
     C     KFACHIS2      KLIST
     C                   KFLD                    KFACNUM
     C                   KFLD                    KFAFCTY
     C                   KFLD                    KFAACBR
     C                   KFLD                    KFAACCU
     C                   KFLD                    KFAACCY
     C                   KFLD                    KFAACCD
     C                   KFLD                    KFAACSQ
     C                   KFLD                    KFADATE
 
     C     KFCLTY        KLIST
     C                   KFLD                    KFCNUM
     C                   KFLD                    KFFACT
     C                   KFLD                    KFFCNO
 
     C     KDLFXMR       KLIST
     C                   KFLD                    KMFCCU
     C                   KFLD                    KMFACT
     C                   KFLD                    KMFCNO
     C                   KFLD                    KMMACY
 
     C     KFACACT       KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KFCTY
 
     C     KFACHISH      KLIST
     C                   KFLD                    KHBRCA
     C                   KFLD                    KHCNUM
     C                   KFLD                    KHFACT
     C                   KFLD                    KHFCNO
 
     C     KACCNT        KLIST
     C                   KFLD                    KACCNUM
     C                   KFLD                    KACCCY
     C                   KFLD                    KACACOD
     C                   KFLD                    KACACSQ
     C                   KFLD                    KACBRCA
 
     C     KAPOST        KLIST
     C                   KFLD                    KACNUM
     C                   KFLD                    KACCY
     C                   KFLD                    KAACOD
     C                   KFLD                    KAACSQ
     C                   KFLD                    KABRCA
     C                   KFLD                    KAPSTD
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WACCRUE = BJDNWD - 1
 
      ** Check if CLE023 is switched on
 
     C                   EVAL      CLE023 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE023'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = 'CLE023'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CLE023 = 'Y'
     C                   ENDIF
 
      ** Open report file
 
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      RQDLN2 = 0
     C                   EVAL      DIFLN2 = 0
 
     C                   OPEN      LE000030P1
     C                   WRITE     HEADP1
 
     C                   OPEN      LE000030P2
     C                   WRITE     HEADP2
 
      ** Get system prefix and convert it to lowercase
 
     C                   IN        SDSTAT
     C                   EVAL      WSystem = LIBR
 
     C                   EVAL      Idx = 1
     C     WChar1        LOOKUP    ArrUPPER(Idx)                          89
 
     C                   IF        *IN89 = *ON
     C                   EVAL      WChar1 = ArrLOWER(Idx)
     C                   ENDIF
 
     C                   EVAL      Idx = 1
     C     WChar2        LOOKUP    ArrUPPER(Idx)                          89
 
     C                   IF        *IN89 = *ON
     C                   EVAL      WChar2 = ArrLOWER(Idx)
     C                   ENDIF
 
     C     WSystem       CAT       WRPG          WFolder
 
     C                   EVAL      Parm8 = crtString(WFolder)
 
      ** Create/Instantiate "CalcClass" java object (one time only)
 
     C                   EVAL      CalcClassObj = crtCalcClass(Parm8)
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program Exception Error Routine                          *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** ArrUPPER
ABCDEFGHIJKLMNOPQRSTUVQXYZ
** ArrLOWER
abcdefghijklmnopqrstuvwxyz
