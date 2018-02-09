     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBI *  OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)               *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Retrieve a record')                           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GLAMADR - GL Account Maintenance retrieve a record           *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD044546           Date 20Mar17               *
      *                 222427             Date 05Dec16               *
      *                 MD039546           Date 26Jan17               *
      *                 LLN022A            Date 03Jun15               *
      *                 CRE101             Date 27Aug14               *
      *                 CGL165             Date 17Feb15               *
      *                 MD028970           Date 25Nov14               *
      *                 MD026979           Date 09Jun14               *
      *                 MD024398           Date 11May14               *
      *                 AR946674           Date 03Apr12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 AR802610           Date 15Jul11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 BUG23671           Date 02Apr09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      *                 260272             Date 15May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241027             Date 12Jul06               *
      *                 238625             Date 06Apr06               *
      *                 238839             Date 29Mar06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10280           Date 02Feb06               *
      *                 CER001             Date 25Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 LLN022             Date 24Jan05               *
      *                 BUG6218            Date 10Mar05               *
      *                 CSD023             Date 18Nov04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CRE010             Date 10Sep04               *
      *                 BUG4196            Date 09Sep04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA084             Date 16Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 17Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044546 - Enable the ABC flag when CAP205 is on.            *
      *  222427 - AMAN - 'Extra Daily Statement Commission' default   *
      *           value is 0.00.  Data structure which includes       *
      *           DDSTFQ should be included in the parameter list on  *
      *           call to module GLAMAD4DT.                           *
      *           Partially Applied for MD042713.                     *
      *  MD039546 - Ensure that the buffer take the correct timestamp.*
      *             Applied for MD-39522.                             *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  CRE101 - Interim Interest Statements on a Frequency          *
      *           Added hooks: CRE101_008, CRE101_009, CRE101_017,    *
      *                        CRE101_018, CRE101_019, CRE101_020     *
      *                        CRE101_063, CRE101_068                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD028970 - Added checking for feature CRE010 when processing *
      *             Account Balance Check.                            *
      *  MD026979 - Added field for Retail account and IBAN           *
      *             validation against WIP entries                    *
      *  MD024398 - API Performance Optimisation                      *
      *  AR946674 - Serious midas error has occured (Child: AR946675) *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  AR802610 - Add Interest Scale flag in API definition.        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  BUG23671 - Incorrect secondary account retrieved             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  260272 - DB Error in GLAMAD4DT. Do not call GLAMAD4DT when   *
      *           currency is blank. Patterned after fixes 240916 and *
      *           BUG13639 of GLAMADVU.                               *
      *  241027 - Do not show retail number for linked account if     *
      *           retail number is zero                               *
      *  238625 - DDICNST is incorrect, initialise field properly     *
      *  238839 - Pass parameter DDIBAN to GLAMADRTV.                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10280- Could not Amend record on AMAD                     *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  BUG6218- Extra data must be included in the buffer           *
      *  CSD023 - Automatic Customer Account Closure                  *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CRE010 - Retail Account Balance Check                        *
      *  BUG4196- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA084 - Change call to AOACOR0 to 10 digit account code.    *
      *           Also replaced the ExRIFilFmt parameter of GLAMADCVT *
      *           with GLVAMRI in order to match with th receiving    *
      *           parameter.  Moved contents of ExRIFilFmt to         *
      *           matching fields of GLVAMRI beforehand.              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTABTBRE   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
 
      ** BRT Customer Details
     FSDCBRTL1  IF   E           K DISK    INFSR(*PSSR)
 
     FRELINKL1  IF   E           K DISK    INFSR(*PSSR)
 
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
 
     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)  USROPN
     FACCPTFR   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCPTFRF)
     F                                     PREFIX(AC_)
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------
 
      * Incoming Transaction
     D AccnInMast    E DS                  EXTNAME(GLAMADPD)
     D AccnInDebi    E DS                  EXTNAME(GLAMDIPD)
     D AccnInCred    E DS                  EXTNAME(GLAMCIPD)
     D AccnInComm    E DS                  EXTNAME(GLAMCOPD)
     D AccnInOthe    E DS                  EXTNAME(GLAMODPD)
     D ExtData       E DS                  EXTNAME(GLAMEXPD)                                 BUG6218
     D AcctLUXFilFmt E DS                  EXTNAME(REACX1PD)                                  CER001
     D AccnInPena    E DS                  EXTNAME(GLAMPPPD)                                  CRE015
     D AccnInPena1   E DS                  EXTNAME(GLAMPP1PD) PREFIX(P1:2)                    CRE015
     D AccnInPena2   E DS                  EXTNAME(GLAMPP2PD) PREFIX(P2:2)                    CRE015
     D/COPY OFCPYSRCZ,CRE101_017                                                              CRE101
 
      **--------------------------------------------------------------------------------------------
      ** FILE FORMATS
      **--------------------------------------------------------------------------------------------
 
     D AccnFilFmt    E DS                  EXTNAME(ACCNTAB)
     D ExBXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(A_)
     D ExRIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(B_)
     D ExRIFilsh               1    144                                                       TDA084
     D ExRIFilex             146    218                                                       TDA084
     D ExCOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(C_)
     D ExPWFilFmt    E DS                  EXTNAME(REAPWDPD)
     D                                     PREFIX(D_)
     D ExPPFilFmt    E DS                  EXTNAME(REPENAPD)                                  CRE015
     D                                     PREFIX(P_)                                         CRE015
     D/COPY OFCPYSRCZ,CRE101_018                                                              CRE101
      * Current Account in File Format
     D CrAcFilFmt    E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(E_)
      * New Account in File Format (Extension File)
     D NABXFilFmt    E DS                  EXTNAME(GLVAMBXPD)
     D                                     PREFIX(A_)
     D QQACOD1       E                     EXTFLD(QQACOD)                                     CGL029
      * Current Account in File Format (Extension File)
     D CABXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(CA_)
     D                                                                                        TDA084
     D GLVAMRI       E DS                  EXTNAME(GLVAMRIPD)                                 TDA084
     D QQACODx       E                     EXTFLD(QQACOD)                                     CER001
     D GLVAMRIsh               1    144                                                       TDA084
     D GLVAMRIex             212    284                                                       TDA084
      **--------------------------------------------------------------------------------------------
     D/COPY WNCPYSRC,GLAMADAD01
      *                                                                                      LLN022A
      ** extension file/screen format                                                        LLN022A
      *                                                                                      LLN022A
     D AcctExFilFmt  E DS                  EXTNAME(BYACCTX0)                                 LLN022A
      *                                                                                      LLN022A
      ** parameter fields                                                                    LLN022A
      *                                                                                      LLN022A
     D PRetCodeIn      S             10                                                      LLN022A
     D PActn           S              1                                                      LLN022A
     D PFOTRID         S             40                                                      LLN022A
     D PRtlAcct        S             10                                                      LLN022A
 
     D RUNDAT          DS            13
      * Rundate data area
     D  AGMBIN                13     13
 
     D*WWLINK***       DS            18                                                       CGL029
     D WWLINK          DS            24                                                       CGL029
     D  WLTAB                  1      3
     D**WLTCUST*               4      9  0                                                    CSD027
     D  WLTCUST                4      9A                                                      CSD027
     D  WLTCCY                10     12
     D**WLTAC***              13     16  0                                                    CGL029
     D**WLTAS***              17     18  0                                                    CGL029
     D  WLTAC                 13     22  0                                                    CGL029
     D  WLTAS                 23     24  0                                                    CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CSC011          S              1A   INZ('N')
     D CRE015          S              1A   INZ('N')                                           CRE015
     D CRE010          S              1A   INZ('N')                                         MD028970
     D CAP205          S              1A   INZ('N')                                         MD044546
     D WProcDate       S                   LIKE(BJRDNB)
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX2           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX3           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX4           S              1    DIM(50) CTDATA PERRCD(50)
 
      ** Input parameters on call to AOPLCSR1
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
 
      ** Output parameters on call to AOPLCSR1
     D O@PARM          S            256
     D DDEABC          S              1A                                                      CRE010
     D DDZINS          S              1A                                                    AR802610
     D TranStamp       S            124A                                                      CER049
     D GLFullAcct      S             24A                                                    MD026979
 
      **--------------------------------------------------------------------------------------------
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR RETAIL DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
 
     D RETABLE       E DS                  EXTNAME(TABTBRE)
     D                                     PREFIX(R_)
      ** EXTERNAL DS FOR RETAIL TABLE FILE
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D QQACC2        E                     EXTFLD(QQACCD)                                     CGL029
      ** External DS for Account Code Details
 
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External DS for Portfolio Customer Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** External DS for Customer Details
 
      ** Externally described DS for Nostro Code details                                      CRE010
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CRE010
     D SDNOSTACCD    E                     EXTFLD(QQACCD)                                     CRE010
                                                                                              CRE010
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      * Third DS for access programs, very long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
     D RegData       E DS                  EXTNAME(GLAMRXPD)                                  CER001
 
     D InfData       E DS                  EXTNAME(GLAMIFPD) PREFIX(IF_)                    BUG10280
      ** GL Extra Data - Classe 1 Data - File (D/B) format                                  BUG10280
     D/COPY WNCPYSRC,GLH00639
 
      **--------------------------------------------------------------------------------------------
 
     C                   CLEAR                   AcctLUXFilFmt                                CER001
     C                   CLEAR                   AccnFilFmt
     C                   CLEAR                   ExBXFilFmt
     C                   CLEAR                   ExRIFilFmt
     C                   CLEAR                   ExCOFilFmt
     C                   CLEAR                   ExPWFilFmt
     C                   CLEAR                   ExPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_019                                                              CRE101
     C/COPY WNCPYSRC,GLH00640
     C     DDACTN        IFEQ      *BLANK
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
 
     C                   MOVE      *OFF          *IN30
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *ON           *IN30
     C                   ENDIF
      *
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      GLAMADRED
     C                   ELSE
     C                   MOVEL     DDACRF_In     @ACRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If account read
      * and no error message returned
      *
     C     @ACRED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve account details
      *
     C                   MOVEL     @ACRED        DDACRF
     C                   EVAL      DDBRCA = %SUBST(DDACRF:1:3)
     C                   EVAL      DDCUSN = %SUBST(DDACRF:4:6)
     C                   EVAL      DDCCY  = %SUBST(DDACRF:10:3)
     C**********         EVAL      DDACOD = %SUBST(DDACRF:13:4)                               CGL029
     C**********         EVAL      DDACSQ = %SUBST(DDACRF:17:2)                               CGL029
     C                   EVAL      DDACOD = %SUBST(DDACRF:13:10)                              CGL029
     C                   EVAL      DDACSQ = %SUBST(DDACRF:23:2)                               CGL029
 
      * Access Account type and suptype for conditioning screen display.
     C                   EXSR      GLVACSQ
 
     C                   EXSR      GLAMADRTV
     C                   IF        ULX606='Y'                                                 CER001
     C                   EXSR      GLAMAD2RV                                                  CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,GLAMADAC01
      *
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   CALLB     'GLAMADRTV1'                                              LLN022A
     C                   PARM                    PRetCodeIn                                  LLN022A
     C                   PARM                    PActn                                       LLN022A
     C                   PARM                    PFOTRID                                     LLN022A
     C                   PARM                    DDCUSN                                      LLN022A
     C                   PARM                    DDCCY                                       LLN022A
     C                   PARM                    DDACOD                                      LLN022A
     C                   PARM                    DDACSQ                                      LLN022A
     C                   PARM                    DDBRCA                                      LLN022A
     C                   PARM                    PRtlAcct                                    LLN022A
     C                   PARM                    AcctExFilFmt                                LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      * Convert to screen format
      *
     C     Ix            IFEQ      0
     C                   CLEAR                   GLVAMRI                                      TDA084
     C                   MOVEL     ExRIFilsh     GLVAMRIsh                                    TDA084
     C                   MOVEL     ExRIFilex     GLVAMRIex                                    TDA084
     C                   EXSR      GLAMADCVT
     C                   IF        ULX606='Y'                                                 CER001
     C                   EXSR      GLAMAD2CT                                                  CER001
     C                   ENDIF                                                                CER001
 
     C/COPY WNCPYSRC,GLAMADAC03
 
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   CALLB     'GLAMADCVT1'                                              LLN022A
     C                   PARM                    PRetCodeIn                                  LLN022A
     C                   PARM                    DDCUSN                                      LLN022A
     C                   PARM                    DDCCY                                       LLN022A
     C                   PARM                    DDACOD                                      LLN022A
     C                   PARM                    DDACSQ                                      LLN022A
     C                   PARM                    DDBRCA                                      LLN022A
     C                   PARM                    AcctExFilFmt                                LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF
      *
      * Validate miscellaneous screen fields.
     C                   EXSR      GLVALID
 
     C                   ENDIF
                                                                                              CSF011
      ** Populate Customer or Account Details                                                 CSF011
                                                                                              CSF011
     C                   EXSR      SrPopCust                                                  CSF011
 
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDACRF     ' FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      ** Please ensure that when setting up the buffer, new core fields                      BUG6218
      ** are added before the data structure ExtData                                         BUG6218
                                                                                             BUG6218
     C                   MOVE      TMST          @TimeStamp       26                         BUG4196
     C     *IN83         IFEQ      '0'                                                      MD039546
     C                   MOVE      TSTAMP        @TimeStamp                                 MD039546
     C                   ENDIF                                                              MD039546
     C                   MOVEL     AccnInPena    AccnInPena1                                  CRE015
     C                   MOVE      AccnInPena    AccnInPena2                                  CRE015
     C                   EVAL                    Buffer = AccnInMast
     C                                           + AccnInDebi + AccnInCred
     C                                           + AccnInComm + AccnInOthe
     C                                           + @TimeStamp                                BUG4196
     C                                           + DDFAMT + AMATYP + AMSTYP
     C                                           + DODRCD + DOCRCD + INCST
     C                                           + BRT + ALT + LTYP + LINK
     C                                           + IBA1 + DOPOLC + DOPOLE
     C                                           + DSPTFR + DDDRMG1 + DDCRMG1
     C                                           + DDCEXA1 + DDCEXB1 + DDCEXC1
     C                                           + DDCEXD1 + DDCEXE1 + DDCEXF1
     C                                           + DDCEXG1
     C**********                                 + DDEABC                              CRE010 CER001
     C**********                                 + DDEABC + Regdata                  CER001 BUG10280
     C**********                                 + DDEABC + InfData                  BUG10280 CRE015
     C                                           + DDEABC                                     CRE015
     C                                           + AccnInPena1                                CRE015
     C                                           + DDZINS                                   AR802610
     C                                           + TranStamp                                  CER049
     C                                           + GLFullAcct                               MD026979
     C/COPY OFCPYSRCZ,CRE101_020                                                              CRE101
     C                                           + InfData                                    CRE015
     C                                           + AccnInPena2                                CRE015
     C**********                                 + RegData                           BUG10280 CRE073
     C**********                                 + ExtData                            BUG6218 CRE073
     C**********         EVAL      Buffer2 = %SUBST(AccnInPena2:4973) +                CRE073 CSF011
     C**********         EVAL      Buffer2 = %SUBST(AccnInPena2:4933) +              CSF011 AR946674
     C/COPY OFCPYSRCZ,CRE101_063                                                              CRE101
     C                   EVAL      Buffer2 = %SUBST(AccnInPena2:4924) +                     AR946674
     C/COPY OFCPYSRCZ,CRE101_068                                                              CRE101
     C                                              RegData + ExtData                         CRE073
 
     C     *IN28         IFEQ      *ON
     C                   CLOSE     PMPORTLL
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrPopCust - Subroutine to Populate Customer Name Details     *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
      *                                                                                       CSF011
     C     SrPopCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Retrieve Customer Details                                                            CSF011
                                                                                              CSF011
     C                   IF        DDCUSN <> *BLANKS                                          CSF011
                                                                                              CSF011
     C                   EXSR      SrRtvCust                                                  CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrRtvCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Call AOCUSTR0 to get Customer Details                                                CSF011
                                                                                              CSF011
     C                   CALLB     'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     @OPTN                                        CSF011
     C                   PARM      DDCUSN        @KEY10                                       CSF011
     C                   PARM      *BLANKS       @KEY7                                        CSF011
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    FwdBck            1
     C**********         PARM                    DDACRF_In        18                          CGL029
     C                   PARM                    DDACRF_In        24                          CGL029
     C                   PARM                    Buffer         6000
     C                   PARM                    Buffer2        3999                          CRE073
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'REUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'SDUSRMSG'                                  CRE073
     C/COPY WNCPYSRC,GLH00641
 
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access RETAIL account details
      *
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDRETL        PARM      SDRETL        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   Z-ADD     7             DBASE                          * DBERR 007 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR file to determine if S01383 is present.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   MOVEL     'S01383'      DBKEY                          *************
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     'N'           S01383            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383
     C                   ENDIF
      *
      ** Portfolio Management
      ** or Private Banking Module
     C                   MOVE      *OFF          *IN28
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'
     C                   OPEN      PMPORTLL
     C                   MOVE      *ON           *IN28
     C                   ENDIF
      *
      ** Access Retail III Table file
     C     BGNXST        IFEQ      'Y'
     C     BGNYST        OREQ      'Y'
     C***********        READ      TABTBRE                                80                  CSD023
     C     1             SETLL     TABTBRE                              80                    CSD023
     C  N80              READ      TABTBRE                                80                  CSD023
     C     *IN80         IfEq      '1'
     C     R_RECI        OrNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVEL     'TABTBRE '    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     *Blanks       DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check commissions if present.
     C     R_CDTO        IFEQ      'Y'
     C     R_CHOV        OREQ      'Y'
     C     R_FXAC        OREQ      'Y'
     C     R_CNDS        OREQ      'Y'
     C     R_CDRI        OREQ      'Y'
     C     R_CMBL        OREQ      'Y'
     C     R_CINA        OREQ      'Y'
     C                   MOVE      'Y'           CommDisp          1
     C                   ELSE
     C                   MOVE      'N'           CommDisp
     C                   ENDIF
      *
      **  GET RUNDAT to access multi-branching indicator on.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      * Access SAR details file to determine if CSC011 switchable feature
      * is switched on
      ** CSC011 is a redundant Feature. No need to check                                    MD024398
 
     C**********         CALLB     'AOSARDR0'                                               MD024398
     C**********         PARM      *BLANKS       @RTCD                                      MD024398
     C**********         PARM      '*VERIFY'     @OPTN                                      MD024398
     C**********         PARM      'CSC011'      @SARD                                      MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                                      MD024398
      **********                                                                            MD024398
     C**********         IF        @RTCD = *Blanks                                          MD024398
      **********                                                                            MD024398
     C**********         EVAL      CSC011 = 'Y'                                             MD024398
      **********                                                                            MD024398
     C**********         IN        SC24X7                                                   MD024398
     C**********         IN        SDSTAT                                                   MD024398
      **********                                                                            MD024398
      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.
      **********                                                                            MD024398
     C**********         IF        CSC011 = 'Y' AND                                         MD024398
     C**********                   S1SUPP = LIBR                                            MD024398
     C**********         EVAL      WProcDate = S1DATE                                       MD024398
     C**********         ELSE                                                               MD024398
     C**********         EVAL      WProcDate = BJRDNB                                       MD024398
     C**********         ENDIF                                                              MD024398
     C**********         MOVEL     WProcDate     AProcDate         5                        MD024398
      **********                                                                            MD024398
     C**********         ELSE                                                               MD024398
      ***Database*error************************************************                     MD024398
      **********                                                                            MD024398
     C**********         IF        @RTCD <> '*NRF'                                          MD024398
     C******LOCK         IN        LDA                                                      MD024398
     C**********         EVAL      DBKEY = 'CSC011'                                         MD024398
     C**********         EVAL      DBFILE = 'SCSARDPD'                                      MD024398
     C**********         EVAL      DBASE = 900                                              MD024398
     C**********         OUT       LDA                                                      MD024398
     C**********         EXSR      *PSSR                                                    MD024398
     C**********         ENDIF                                                              MD024398
      **********                                                                            MD024398
     C**********         ENDIF                                                              MD024398
      *
      ** Access SAR details file to determine if CFT004 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVEL     'CFT004'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT004            1
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   END
      *
      ** Access SAR details file to determine if CDE002 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     12            DBASE
     C                   MOVEL     'CDE002'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDE002            1
     C                   ELSE
     C                   MOVEL     'N'           CDE002
     C                   END
                                                                                              CRE015
      ** Check if term and notice account feature is installed                                CRE015
                                                                                              CRE015
     C                   EVAL      CRE015 = 'N'                                               CRE015
     C                   CALL      'AOSARDR0'                                                 CRE015
     C                   PARM      *BLANKS       @RTCD                                        CRE015
     C                   PARM      '*VERIFY'     @OPTN                                        CRE015
     C                   PARM      'CRE015'      @SARD                                        CRE015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE015
                                                                                              CRE015
     C                   IF        @RTCD <> *BLANKS AND                                       CRE015
     C                             @RTCD <> '*NRF'                                            CRE015
     C     *LOCK         IN        LDA                                                        CRE015
     C                   EVAL      DBPGM = 'GLAMADR'                                          CRE015
     C                   EVAL      DBKEY = 'CRE015'                                           CRE015
     C                   EVAL      DBFILE ='SCSARDPD'                                         CRE015
     C                   EVAL      DBASE  = 903                                               CRE015
     C                   OUT       LDA                                                        CRE015
     C                   EXSR      *PSSR                                                      CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   IF        @RTCD = *BLANKS                                            CRE015
     C                   EVAL      CRE015 = 'Y'                                               CRE015
     C                   ENDIF                                                                CRE015
     C/COPY OFCPYSRCZ,CRE101_009                                                              CRE101
                                                                                            MD028970
      ** Check if Retail Account Balance Check feature is installed                         MD028970
                                                                                            MD028970
     C                   EVAL      CRE010 = 'N'                                             MD028970
     C                   CALL      'AOSARDR0'                                               MD028970
     C                   PARM      *BLANKS       @RTCD                                      MD028970
     C                   PARM      '*VERIFY'     @OPTN                                      MD028970
     C                   PARM      'CRE010'      @SARD                                      MD028970
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD028970
                                                                                            MD028970
     C                   IF        @RTCD <> *BLANKS AND                                     MD028970
     C                             @RTCD <> '*NRF'                                          MD028970
     C     *LOCK         IN        LDA                                                      MD028970
     C                   EVAL      DBPGM = 'GLAMADR'                                        MD028970
     C                   EVAL      DBKEY = 'CRE010'                                         MD028970
     C                   EVAL      DBFILE ='SCSARDPD'                                       MD028970
     C                   EVAL      DBASE  = 903                                             MD028970
     C                   OUT       LDA                                                      MD028970
     C                   EXSR      *PSSR                                                    MD028970
     C                   ENDIF                                                              MD028970
                                                                                            MD028970
     C                   IF        @RTCD = *BLANKS                                          MD028970
     C                   EVAL      CRE010 = 'Y'                                             MD028970
     C                   ENDIF                                                              MD028970
      *                                                                                     MD044546
      ** Check if CAP205 is installed.                                                      MD044546
      *                                                                                     MD044546
     C                   EVAL      CAP205 = 'N'                                             MD044546
     C                   CALL      'AOSARDR0'                                               MD044546
     C                   PARM      *BLANKS       @RTCD                                      MD044546
     C                   PARM      '*VERIFY'     @OPTN                                      MD044546
     C                   PARM      'CAP205'      @SARD                                      MD044546
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD044546
                                                                                            MD044546
     C                   IF        @RTCD <> *BLANKS AND                                     MD044546
     C                             @RTCD <> '*NRF'                                          MD044546
     C     *LOCK         IN        LDA                                                      MD044546
     C                   EVAL      DBPGM = 'GLAMADR'                                        MD044546
     C                   EVAL      DBKEY = 'CAP205'                                         MD044546
     C                   EVAL      DBFILE ='SCSARDPD'                                       MD044546
     C                   EVAL      DBASE  = 904                                             MD044546
     C                   OUT       LDA                                                      MD044546
     C                   EXSR      *PSSR                                                    MD044546
     C                   ENDIF                                                              MD044546
                                                                                            MD044546
     C                   IF        @RTCD = *BLANKS                                          MD044546
     C                   EVAL      CAP205 = 'Y'                                             MD044546
     C                   ENDIF                                                              MD044546
      *                                                                                     MD044546
     C/COPY WNCPYSRC,GLAMADAC02
      *
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** Key list to access Linked Accounts
     C     RELINK        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
      *
      ** Key list to access Account by Branch
     C     ACLINK        KLIST
     C                   KFLD                    LTAB
     C                   KFLD                    LTCUST
     C                   KFLD                    CCY
     C                   KFLD                    LTAC
     C                   KFLD                    LTAS
 
      **  Define key list to access ACCPTFR
     C     PTFRK         KLIST
     C                   KFLD                    WWPTFR            4
     C**********         KFLD                    WWCNUM            6 0                        CSD027
     C                   KFLD                    WWCNUM            6                          CSD027
     C                   KFLD                    WWCCY             3
     C                   KFLD                    WWACOD           10 0
     C                   KFLD                    WWACSQ            2 0
 
      * Overrride ACCNTL0
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
      * Overrride REIAC
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
      * Overrride RECOM
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX3
     C                   PARM                    MESLEN
      * Overrride REAPWDL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX4
     C                   PARM                    MESLEN
     C/COPY WNCPYSRC,GLH00642
      *                                                                                       CER001
      * Access SAR details file to determine if ULX606 switchable                             CER001
      * feature is installed.                                                                 CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX606            1                          CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX606'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        @RTCD = *Blanks                                            CER001
     C                   EVAL      ULX606 = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND                                      CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   Z-ADD     11            DBASE                                        CER001
     C                   MOVEL     'ULX606'      DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                  q
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,GLAMADM01
 
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLAMADRED     BEGSR
 
     C                   CALLB     'GLAMADRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account REF. POINTER
     C**********         PARM      DDACRF_In     DDACRF           18                          CGL029
     C                   PARM      DDACRF_In     DDACRF           24                          CGL029
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Account REF. READ
     C**********         PARM      *BLANK        @ACRED           18                          CGL029
     C                   PARM      *BLANK        @ACRED           24                          CGL029
     C                   PARM      *BLANK        @RERED           10
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLAMADRTV     BEGSR
 
     C                   CALLB     'GLAMADRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C**********         PARM                    FOTRID           20                          CER001
     C                   PARM                    FOTRID           40                          CER001
      * (Midas) Account Reference
     C                   PARM                    DDCUSN
     C                   PARM                    DDCCY
     C                   PARM                    DDACOD
     C                   PARM                    DDACSQ
     C                   PARM                    DDBRCA
     C                   PARM                    DDACNO
      * Commissions
     C                   PARM                    CommDisp
      * IBAN
     C                   PARM                    CFT004
     C                   PARM                    DDIBAN                                       238839
     C                   PARM                    CRE015                                       CRE015
     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
      *
      ** New Accounts Currency
      *
     C                   PARM                    WDCCY             3
      * OUTPUTS :
      * (Current) Account in file format
     C                   PARM                    AccnFilFmt
     C                   PARM                    ExBXFilFmt
     C                   PARM                    ExRIFilFmt
     C                   PARM                    ExCOFilFmt
     C                   PARM                    ExPWFilFmt
     C                   PARM                    ExPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_014                                                              CRE101
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      * OK - Account Reference
     C                   PARM                    DDCUSNOK          1
     C                   PARM                    DDCCYOK           1
     C                   PARM                    DDACODOK          1
     C                   PARM                    DDACSQOK          1
     C                   PARM                    DDBRCAOK          1
     C                   PARM                    DDACNOOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix
      * Base Rate Auth Req
     C                   PARM                    AUTHRQ            1
      * Authorisation Mode
     C                   PARM                    AUTHMD            1
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLVACSQ       BEGSR
 
     C                   CALLB     'GLVACSQ'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Account Screen Fields
     C**********         PARM                    DDACOD            4                          CGL029
     C                   PARM                    DDACOD           10                          CGL029
     C                   PARM                    DDACSQ            2
     C                   PARM                    DDCUSN            6
     C                   PARM                    A8BICN            6
     C                   PARM                    AGMBIN            1
      * OUTPUTS :
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
     C                   PARM                    AMATYP            1
     C                   PARM                    AMSTYP            1
     C                   PARM                    WWTOIN            1
     C                   PARM                    WWRETL            1
      * Account Code - OK
      * Account Sequence - OK
     C                   PARM      *ZERO         DDACODOK          1
     C                   PARM      *ZERO         DDACSQOK          1
 
      ** Access Account Code details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOACODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********         PARM      DDACOD        @ACOD             4                          TDA084
     C                   PARM      DDACOD        @ACOD            10                          TDA084
     C     SDACOD        PARM      SDACOD        DSFDY
      *
      * Not Found
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           DDACODOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACOD'      FldNameArr(Ix)
     C                   MOVEL     'RE71037'     MsgIdArr(Ix)
     C                   END
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLVALID       BEGSR
 
     C                   MOVEL     'N'           INCST             1
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   MOVEL     CCY           DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Display if is an In currency past the transition start date.
      *
     C     A6INCY        IFEQ      'Y'
     C     A6TPSD        ANDLE     WProcDate
     C     CSC011        ANDEQ     'Y'                                                        238625
     C     A6INCY        OREQ      'Y'                                                        238625
     C     A6TPSD        ANDLE     BJRDNB                                                     238625
     C     CSC011        ANDNE     'Y'                                                        238625
     C                   MOVEL     'Y'           INCST
     C                   ENDIF
      *
      * Validate BRT category extension record exists.
      *
     C                   MOVEL     'N'           BRT               1
     C**********         MOVE      DDCUSN        @CNUM6            6 0                        CSD027
     C                   MOVE      DDCUSN        @CNUM6            6                          CSD027
      *
     C     S01383        IFEQ      'Y'
     C     @CNUM6        CHAIN     SDCBRTL1                           81
     C     *IN81         IFEQ      *OFF
     C     XRECI         ANDEQ     'D'
     C                   MOVEL     'Y'           BRT
     C                   ENDIF
     C                   ENDIF
      *
      * If number of alterenates is *GT0 then this is an alternate account.
     C     B_NOALT       IFGT      0
     C                   MOVEL     'Y'           ALT               1
     C                   ELSE
     C                   MOVEL     'N'           ALT
     C                   ENDIF
      *
      ** Test the A/c if it is a prime account or a secondary account, also
      ** set up secondary account details to diplay
     C                   MOVEL     ' '           LTYP              1
     C                   MOVE      TMST          TSTAMP           26                        MD039546
     C     LTAS          IFEQ      99
     C                   MOVEL     'P'           LTYP
     C                   ELSE
     C     RELINK        CHAIN     RELINKL1                           82
     C     *IN82         IFEQ      *OFF
     C                   MOVEL     'S'           LTYP
     C                   MOVEL     *BLANKS       LINK             18
      *
     C                   MOVEL     LTAB          WLTAB
     C**********         Z-ADD     LTCUST        WLTCUST                                      CSD027
     C                   EVAL      WLTCUST = LTCUST                                           CSD027
     C                   MOVEL     CCY           WLTCCY
     C                   Z-ADD     LTAC          WLTAC
     C                   Z-ADD     LTAS          WLTAS
      *                                                                                     BUG23671
     C                   Z-ADD     ACSQ          LTAS                                       BUG23671
      *
      ** If RE number is being used, show RE number of the prime a/c.
      *
     C     BMRANR        IFEQ      'Y'
     C     ACLINK        CHAIN     ACCNTLXX                           83
     C     *IN83         IFEQ      '0'
     C     ACNO          ANDNE     0                                                          241027
     C                   MOVEL     ACNO          LINK
     C                   ELSE
     C                   MOVEL     WWLINK        DDLINK
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     WWLINK        DDLINK
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Access Branch details
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCA        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Not Found
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           DDBRCAOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'RE71040'     MsgIdArr(Ix)
     C                   MOVE      'Y'           IBA1              1
     C                   ELSE
     C     A8GENM        IFEQ      '1'
     C     A8GENM        OREQ      ' '
     C                   MOVE      'N'           IBA1
     C                   ELSE
     C                   MOVE      'Y'           IBA1
     C                   ENDIF
     C                   ENDIF
      *
      ** Restrict output of Portfolio Reference
     C     BGPFMG        IFEQ      'Y'
      *
     C                   MOVEL     DDCUSN        I#CUST
     C                   MOVEL     DDBRCA        I#BRCA
     C                   MOVEL     *BLANKS       I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
      *
     C                   CALLB     'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
      ** Default to display.
     C                   MOVE      'Y'           DSPTFR            1
     C     @RTCD         IFEQ      'PMA0008'
     C     @RTCD         OREQ      'PMA0009'
      *
     C     *IN30         ORNE      *ON
     C     I#PORS        ANDNE     'B'
     C     AMATYP        ANDNE     'R'
      *
     C     *IN30         ORNE      *ON
     C     I#PORS        ANDEQ     'B'
     C     AMATYP        ANDNE     'R'
     C     AMATYP        ANDNE     'N'
      *
     C     *IN30         OREQ      *ON
     C     I#PORS        ANDNE     'B'
     C     A5ACTY        ANDNE     'R'
      *
     C     *IN30         OREQ      *ON
     C     I#PORS        ANDEQ     'B'
     C     A5ACTY        ANDNE     'R'
     C     A5ACTY        ANDNE     'N'
      *
      ** Suppress Portfolio Referece.
     C                   MOVE      'N'           DSPTFR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Restrict output of Portfolio Reference
     C     BGN4ST        IFEQ      'Y'
     C                   MOVEL     DDCUSN        @KEY10
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY10           10
     C                   PARM      *BLANKS       @KEY7             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C     BBPRBA        ANDEQ     'Y'
      ** Default to display.
     C                   MOVE      'Y'           DSPTFR
     C                   ELSE
     C     BGPFMG        IFNE      'Y'
      ** Suppress Portfolio Referece.
     C                   MOVE      'N'           DSPTFR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     A5ACTY        IFEQ      'R'
     C     DSPTFR        ANDEQ     'Y'
     C     *IN28         ANDEQ     *ON
     C     DDPTFR        IFEQ      *BLANKS
     C**********         MOVEL     DDCUSN        KPCNUM            6 0                        CSD027
     C                   MOVEL     DDCUSN        KPCNUM            6                          CSD027
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVE      DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACSQ        WWACSQ
     C                   MOVE      'N'           WWVAL             1
     C     KPCNUM        SETLL     PMPORTLL
     C     KPCNUM        READE     PMPORTLL                               88
      *
     C     *IN88         DOWEQ     *OFF
     C     WWVAL         ANDEQ     'N'
     C     PNDPCL        IFEQ      0
     C                   MOVE      PNPTFR        WWPTFR            4
     C     PTFRK         CHAIN     ACCPTFR                            81
      *
     C     *IN81         IFEQ      '0'
     C     KPCNUM        READE     PMPORTLL                               88
     C                   ELSE
     C                   MOVE      PNPTFR        DDPTFR
     C                   MOVE      'Y'           WWVAL
     C                   ENDIF
      *
     C                   ELSE
     C     KPCNUM        READE     PMPORTLL                               88
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C*****DDACTN        IFNE      'I'                                                        260272
     C     DDACTN        IFEQ      'I'                                                        260272
     C     DDACTN        OREQ      'E'                                                      MD042713
     C                   EXSR      DFT@O
     C                   END
      *
      ** Set up Enable Account Balance Check Flag                                             CRE010
     C     CRE010        IFEQ      'Y'                                                      MD028970
     C     CAP205        OREQ      'Y'                                                      MD044546
     C                   EXSR      SREnableABC                                                CRE010
     C                   ENDIF                                                              MD028970
                                                                                              CRE010
     C                   ENDSR
      *****************************************************************                       CRE010
      /EJECT                                                                                  CRE010
      *****************************************************************                       CRE010
      *                                                               *                       CRE010
      *  SREnableABC - Subroutine to setup Enable Account Balance     *                       CRE010
      *                Check flag                                     *                       CRE010
      *                                                               *                       CRE010
      *****************************************************************                       CRE010
     C     SREnableABC   BEGSR                                                                CRE010
                                                                                              CRE010
      ** Initialise account flag to 'N'                                                       CRE010
     C                   EVAL      DDEABC = 'N'                                               CRE010
                                                                                              CRE010
      ** Set to 'Y' only if retail and non=nostro account                                     CRE010
                                                                                              CRE010
     C                   IF        AMATYP = 'R'                                               CRE010
     C                   CALLB     'AONOSTR0'                                                 CRE010
     C                   PARM      *BLANKS       PRTCD             7                          CRE010
     C                   PARM      '*KEY   '     POPTN             7                          CRE010
     C                   PARM      DDCUSN        PKCUST            6                          CRE010
     C                   PARM      DDCCY         PKCYCD            3                          CRE010
     C                   PARM      DDACOD        PKACCD           10                          CRE010
     C                   PARM      DDACSQ        PKACSN            2                          CRE010
     C                   PARM                    PKNONB            2                          CRE010
     C                   PARM      DDBRCA        PKBRCD            3                          CRE010
     C                   PARM                    PKUCSN           10                          CRE010
     C                   PARM                    PKPNOI            1                          CRE010
     C     SDNOST        PARM      SDNOST        DSFDY                                        CRE010
                                                                                              CRE010
     C                   IF        PRTCD <> *BLANKS                                           CRE010
     C                   EVAL      DDEABC = 'Y'                                               CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
     C                   ENDSR                                                                CRE010
      **********************************************************************
      /EJECT
      **********************************************************************
      * DFT@O   - DEFAULTING FOR COMMISSIONS & OVERRIDES SCREEN
      **********************************************************************
     C     DFT@O         BEGSR
      *
     C                   MOVEL     CABXFilFmt    NABXFilFmt
      *
     C                   CALL      'AOCUSTR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     BBCGRP        IFEQ      *BLANKS
     C     @RTCD         ORNE      *BLANKS
     C                   MOVEL     '1'           BBCGRP
     C                   ENDIF
      *
      ** Do not execute GLAMAD4DT when currency code is blanks,                               260272
      ** Serious midas error will be encountered                                              260272
      *                                                                                       260272
     C                   IF        DDCCY <> *Blanks                                           260272
      *
     C                   MOVEL     DDCCY         CCY                                          260272
     C                   CALLB     'GLAMAD4DT'
      *
      * INPUTS :
      * Response mode
     C                   PARM                    RetCodeIn
 
      * Customer Retail Group
     C                   PARM                    BBCGRP
      *
      ** CCRM Revenue Analysis
     C                   PARM                    CDE002
 
      * Account details (DS) in file format
     C                   PARM                    AccnFilFmt
     C                   PARM                    NABXFilFmt
     C                   PARM                    AccnInMast                                   222427
 
      * OUTPUTS :
      * Screen 4 Output
     C                   PARM                    DDCEXA1          11
     C                   PARM                    DDCEXB1          11
     C                   PARM                    DDCEXC1          11
     C                   PARM                    DDCEXD1           8
     C                   PARM                    DDCEXE1           8
     C                   PARM                    DDCEXF1           8
     C                   PARM                    DDCEXG1           8
     C                   PARM                    DDDRMG1
     C                   PARM                    DDCRMG1
     C                   ENDIF                                                                260272
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLAMADCVT     BEGSR
 
     C                   CALLB     'GLAMADCVT'
      *
      * INPUTS :
      * Return Code
      * Account in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    AccnFilFmt
     C                   PARM                    ExBXFilFmt
     C**********         PARM                    ExRIFilFmt                                   TDA084
     C                   PARM                    GLVAMRI                                      TDA084
     C                   PARM                    ExCOFilFmt
     C                   PARM                    ExPWFilFmt
     C                   PARM                    ExPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_014                                                              CRE101
      *
      * Commissions
     C                   PARM                    CommDisp
      * CCRM Revenue Analysis
     C                   PARM                    CDE002            1
      *
      * Retail Details
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      * OUTPUTS
      * Account - screen formats
     C                   PARM                    AccnInMast
     C                   PARM                    AccnInDebi
     C                   PARM                    AccnInCred
     C                   PARM                    AccnInComm
     C                   PARM                    AccnInOthe
     C                   PARM                    AccnInPena                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_022                                                              CRE101
      *
      * Screen 1 Output
     C                   PARM                    DDDACC            6
     C**********         PARM                    DDLINK           18                          CGL029
     C                   PARM                    DDLINK           24                          CGL029
     C                   PARM                    DDFAMT            8
      *
      * Screen 2 Output
     C                   PARM                    DODRCD            6
     C                   PARM                    DOPOLC            6
     C                   PARM                    DOPOLE            6
      *
      * Screen 3 Output
     C                   PARM                    DOCRCD            6
      *
      * Screen 4 Output
     C                   PARM                    DDCEXA1          11
     C                   PARM                    DDCEXB1          11
     C                   PARM                    DDCEXC1          11
     C                   PARM                    DDCEXD1           8
     C                   PARM                    DDCEXE1           8
     C                   PARM                    DDCEXF1           8
     C                   PARM                    DDCEXG1           8
     C                   PARM                    DDDRMG1          12
     C                   PARM                    DDCRMG1          12
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************                    CER001
      *                                                                  *                    CER001
      *  GLAMAD2RV - GL Account LUX Conversion (File to Screen Format)   *                    CER001
      *            - This subroutine converts extension file details     *                    CER001
      *              (REACX1PD) to screen format.                        *                    CER001
      *                                                                  *                    CER001
      ********************************************************************                    CER001
     C     GLAMAD2RV     BEGSR                                                                CER001
                                                                                              CER001
     C                   CALLB     'GLAMAD2RV'                                                CER001
      *                                                                                       CER001
      * INPUTS :                                                                              CER001
      * Return code                                                                           CER001
     C                   PARM      *BLANK        RetCodeOut                                   CER001
      * Action Code                                                                           CER001
     C                   PARM                    DDACTN                                       CER001
      * Front Office Transaction ID                                                           CER001
     C                   PARM                    FOTRID           40                          CER001
      * (Midas) Account Reference                                                             CER001
     C                   PARM                    DDCUSN                                       CER001
     C                   PARM                    DDCCY                                        CER001
     C                   PARM                    DDACOD                                       CER001
     C                   PARM                    DDACSQ                                       CER001
     C                   PARM                    DDBRCA                                       CER001
     C                   PARM                    DDACNO                                       CER001
      * OUTPUTS :                                                                             CER001
      * (Current) Account in file format                                                      CER001
     C                   PARM                    AcctLUXFilFmt                                CER001
                                                                                              CER001
     C                   ENDSR                                                                CER001
      ********************************************************************                    CER001
      /EJECT                                                                                  CER001
      ********************************************************************                    CER001
      *                                                                  *                    CER001
      *  GLAMAD2CT - GL Account LUX Retrieve                             *                    CER001
      *            - This subroutine retrieves the extension file details*                    CER001
      *              (REACX1PD).                                         *                    CER001
      *                                                                  *                    CER001
      ********************************************************************                    CER001
     C     GLAMAD2CT     BEGSR                                                                CER001
                                                                                              CER001
     C                   CALLB     'GLAMAD2CT'                                                CER001
      *                                                                                       CER001
      * INPUTS :                                                                              CER001
      * Return code                                                                           CER001
     C                   PARM      *BLANK        RetCodeOut                                   CER001
      * (Midas) Account Reference                                                             CER001
     C                   PARM                    DDCUSN                                       CER001
     C                   PARM                    DDCCY                                        CER001
     C                   PARM                    DDACOD                                       CER001
     C                   PARM                    DDACSQ                                       CER001
     C                   PARM                    DDBRCA                                       CER001
      *                                                                                       CER001
      * OUTPUTS :                                                                             CER001
      * (Current) Account in file format                                                      CER001
     C                   PARM                    AcctLUXFilFmt                                CER001
     C                   PARM                    Regdata                                      CER001
                                                                                              CER001
     C                   ENDSR                                                                CER001
      **********************************************************************                  CER001
      /EJECT                                                                                  CER001
      **********************************************************************                  CER001
     C/COPY WNCPYSRC,GLH00643
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
** ##OX1
OVRDBF FILE(ACCNTL1) TOFILE(ACCNTL0) SHARE(*NO)
** ##OX2
OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)
** ##OX3
OVRDBF FILE(RECOMXX) TOFILE(RECOM) SHARE(*NO)
** ##OX4
OVRDBF FILE(REAPWDL1) TOFILE(REAPWDL0) SHARE(*NO)
