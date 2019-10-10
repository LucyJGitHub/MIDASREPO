     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *  OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)               *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Accnt. conversion - file to screen format')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADCVT - GL Account Conversion: File to Screen Format     *
      *                                                               *
      *  Function:  This module converts the fields of an Account     *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054028           Date 05Sep19               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD034725           Date 27Jul16               *
      *                 CRE101             Date 27Aug14               *
      *                 CGL165             Date 23Feb15               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 AR740293           Date 31Mar11               *
      *                 AR582286           Date 26Jul10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 BUG23352           Date 12Mar09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243129             Date 27Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11914           Date 17Aug06               *
      *                 241027             Date 12Jul06               *
      *                 221603             Date 06Jun06               *
      *                 220101             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA084             Date 16Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 213342             Date 27Jun03               *
      *                 208921             Date 20Feb03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Feb00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 176842             Date 02Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 18Oct99               *
      *                 CFT004             Date 05Nov99               *
      *                 CAP035  *CREATE    Date 30Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate                          *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034725 - Single CCY + Branch available in BFM and TI Plus  *
      *  CRE101 - Interim Interest Statements on a Frequency          *
      *           Added hooks: CRE101_010, CRE101_011, CRE101_012,    *
      *                         CRE101_013, CRE101_014, CRE101_015,   *
      *                         CRE101_016                            *
      *  CGL165 - Dual Withholding Tax                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CRE075 - Effective Date for Retail Accounts                  *
      *  AR740293 - Error validating IBAN field (Child: AR740294)     *
      *  AR582286 - The system was not able to generate IBAN for      *
      *             the customer. Applied fix 206824.                 *
      *  206824 - IBAN field not displayed and updated correctly      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y                            *
      *  BUG23352 - Do not blank out zero DR/CR calculation basis     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  243129 - Do not access currencies file when currency is      *
      *           blank.                                              *
      *  BUG11914 - Facility Customer not properly converted.         *
      *  241027 - Do not show retail number for linked account if     *
      *           retail number is zero                               *
      *  221603 - Exempt commissions are shown as 50,000.00 instead   *
      *           of 'E'.                                             *
      *  220101 - Currency of primary account is not set up           *
      *           causing incorrect primary to be displayed for a     *
      *           secondary account.                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines                                        *
      *  TDA084 - Display Debit/Credit Interest Margin fields with    *
      *           no values as blanks instead of zeroes.              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  213342 - Default statement fee amount should be displayed if *
      *           statement charges (TSTMC) is 'Y' in RE ICD by CCY.  *
      *  208921 - Only call AORETLR0 if Retail is on.                 *
      *           Move access of Retail ICD details until after access*
      *           of Module details (Apply 213829)                    *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  CDE002 - CCRM Revenue Analysis - Addition of Margin Int. Flds*
      *  176842 - Module GLAMAD4DT added in SIN & Repair for          *
      *           defaulting values to 4th screen-Comment out process *
      *  CPB001 - 'Private Banking' Module                            *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CAP035 - Midas API Conversion for ToF                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FRELINKL1  IF   E           K DISK    INFSR(*PSSR)
 
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
 
     FRESTCHPD  IF   E           K DISK    INFSR(*PSSR)
 
      ** Customer Group Code
     FTABLEV4   IF   E             DISK    INFSR(*PSSR)
                                                                                              CRE015
     FSDACD1L0  IF   E           K DISK    INFSR(*PSSR)                                       CRE015
 
     FREAPRHI0  IF   E           K DISK    INFSR(*PSSR)                                       CER050
     FREAPRHI1  IF   E           K DISK    INFSR(*PSSR)                                       CER050
     F                                     RENAME(REAPRHD0:REAPRHD1)                          CER050
     F****RECCY     IF   E           K DISK    INFSR(*PSSR)                     176842
 
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
 
      ** Include the GL standard declares
     D/COPY GLCPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D Idx1            S              2P 0 INZ(0)
 
      ** Client Group Code
     D GRP             S              1    DIM(8)
      ** Account Commission Indicators
     D AIN1            S              1    DIM(8)
      ** Max. Dr. Balance Commission Indicators
     D AIN2            S              1    DIM(8)
      ** Debit Interest Commission Indicators
     D AIN3            S              1    DIM(8)
      ** Inactive Commission Indicators
     D AIN4            S              1    DIM(8)
      ** Minimum Balance Indicators
     D AIN5            S              1    DIM(8)
      ** Daily Statement Commission Indicators
     D AIN6            S              1    DIM(8)
      ** Fixed Commission Indicators
     D AIN7            S              1    DIM(8)
 
     D   ZFIELD        S             16A
 
     D   ZADEC         S              1P 0
 
      ** DATA STRUCTURE TO GET THE RIGHT CUSTOMER GROUP
     D                 DS
     D  ZZ010                  1     10
     D  CGRP                  10     10
 
 
     D***WWLINK*         DS            18                                                     CGL029
     D WWLINK          DS            24                                                       CGL029
     D  WWLTAB                 1      3
     D**LTCUST**               4      9  0                                                    CSD027
     D  LTCUST                 4      9                                                       CSD027
     D  LTCCY                 10     12
     D***WWLTAC*               13     16  0                                                   CGL029
     D***WWLTAS*               17     18  0                                                   CGL029
     D  WWLTAC                13     22  0                                                    CGL029
     D  WWLTAS                23     24  0                                                    CGL029
 
      * Account in File Format
     D AccnFilFmt    E DS                  EXTNAME(GLVAMADPD)
     D ExBXFilFmt    E DS                  EXTNAME(GLVAMBXPD)
     D GLBXACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D ExRIFilFmt    E DS                  EXTNAME(GLVAMRIPD)
     D GLRIACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D ExCOFilFmt    E DS                  EXTNAME(GLVAMCOPD)
     D GLCOACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D ExPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)
     D GLPWACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D ExPPFilFmt    E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
 
      * Account in Screen Format
     D AccScnMast    E DS                  EXTNAME(GLAMADPD)
     D AccScnDebi    E DS                  EXTNAME(GLAMDIPD)
     D AccScnCred    E DS                  EXTNAME(GLAMCIPD)
     D AccScnComm    E DS                  EXTNAME(GLAMCOPD)
     D AccScnOthe    E DS                  EXTNAME(GLAMODPD)
     D AccScnPena    E DS                  EXTNAME(GLAMPPPD)                                  CRE015
     D  ScnPenaRows           33   4166                                                       CRE015
 
 
     D/COPY OFCPYSRCZ,CRE101_010                                                              CRE101
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** EXTERNAL DS FOR RETAIL DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR Customer DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** Array DS for screen definition                                                       CRE015
                                                                                              CRE015
     D ArrScn        E DS                  DIM(26) QUALIFIED                                  CRE015
     D                                     EXTNAME(GLAMPRPD)                                  CRE015
                                                                                              CRE015
     D ArrScnBuf       S                   DIM(26) LIKE(ArrScn)                               CRE015
                                                                                              CRE015
      ** Array DS for file definition                                                         CRE015
                                                                                              CRE015
     D ArrFil        E DS                  DIM(26) QUALIFIED                                  CRE015
     D                                     EXTNAME(REPRPNPD)                                  CRE015
                                                                                              CRE015
     D ArrFilBuf       S                   DIM(26) LIKE(ArrFil)                               CRE015
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD101
      ** SD data area                                                                         CSD101
                                                                                              CSD101
     D CHKACC2         DS            24                                                       CSD101
     D KCNUM2                  1      6                                                       CSD101
     D KCCY2                   7      9                                                       CSD101
     D KACOD2                 10     19                                                       CSD101
     D KACSQ2                 20     21                                                       CSD101
     D KBRCA2                 22     24                                                       CSD101

     D PReturnCode     S              7A                                                      CSD101
     D PAction         S              1A                                                      CSD101
     D PValidList      S             10A   INZ('SDINTFVL')                                    CSD101
     D PLibrary        S             10A                                                      CSD101
     D PIDName         S            100A                                                      CSD101
     D PPass1          S            128A                                                      CSD101
     D PDescr          S           1000A                                                      CSD101
                                                                                              CSD101
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CLE025          S              1                                                       CLE025
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D CRE015          S              1                                                       CRE015
     D X               S              3  0                                                    CRE015
     D W#DRDY          S              4S 0                                                    CRE015
     D W#DD            S              2                                                       CRE015
     D W#MM            S              2                                                       CRE015
     D W#DATE          S              6                                                       CRE015
     D C#TRMDAT        C                   CONST(26664)                                       CRE015
 
     D CER047          S              1A                                                      CER047
     D CRE075          S              1A                                                      CRE075
     D CER055          S              1A                                                      CER055
     D CRE073          S              1A                                                      CRE073
     D CGL165          S              1A                                                      CGL165
     D CTI006          S              1A                                                    MD034725
     D CER050          S              1A                                                      CER050
     D APRDrRate       S              6S 0                                                    CER050
     D APRCrRate       S              6S 0                                                    CER050
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      ** Set output screen fields for first screen
     C                   EXSR      SETFLD1
      *
      ** Set output screen fields for second screen if Retail
     C                   IF        AMATYP='R'
     C                   EXSR      SETFLD2
     C                   ENDIF
      *
      ** Set output screen fields for third screen if Retail
     C                   IF        AMATYP='R'
     C                   EXSR      SETFLD3
     C                   ENDIF
      *
      ** Set output screen fields for fourth screen if Commisions exist
      ** OR if CDE002 is installed                                              CDE002
     C                   IF        CommDisp='Y' and AMATYP='R'
     C                             OR (CDE002 = 'Y' and AMATYP = 'R')           CDE002
     C                   EXSR      SETFLD4
     C                   ENDIF
      *
      ** Set output screen fields for fifth screen if Retail
     C                   IF        AMATYP='R'
     C                   EXSR      SETFLD5
     C/COPY OFCPYSRCZ,CRE101_011                                                              CRE101
     C                   ENDIF
                                                                                              CRE015
      ** Setup output screen for period and penalty details                                   CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND A5ATTY = 'P'                                           CRE015
     C                   EXSR      SETFLD6                                                    CRE015
     C                   ENDIF                                                                CRE015
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD1 - Set output for screen one(Account Master details)
      *****************************************************************
     C     SETFLD1       BEGSR
      *
      * Branch Code
      *
     C                   EVAL      DDBRCA=AMBRCA
      *
      * Customer Number
      *
     C                   MOVEL(P)  AMCNUM        DDCUSN
      *
      * Currency
      *
     C                   EVAL      DDCCY=AMCCY
      *
      * Account Code
      *
     C                   MOVEL(P)  AMACOD        DDACOD
      *
      * Account Sequence
      *
     C                   MOVEL(P)  AMACSQ        DDACSQ
      *
      * Account Number
      *
     C                   EVAL      %SUBST(DDACCN:1:3)=DDBRCA
     C                   EVAL      %SUBST(DDACCN:4:6)=DDCUSN
     C                   EVAL      %SUBST(DDACCN:10:3)=DDCCY
     C**********         EVAL      %SUBST(DDACCN:13:4)=DDACOD                                 CGL029
     C**********         EVAL      %SUBST(DDACCN:17:2)=DDACSQ                                 CGL029
     C                   EVAL      %SUBST(DDACCN:13:10)=DDACOD                                CGL029
     C                   EVAL      %SUBST(DDACCN:23:2)=DDACSQ                                 CGL029
      *
      * Retail Number
      *
     C                   IF        AMACNO=*ZERO
     C                   EVAL      DDACNO=*BLANKS
     C                   ELSE
     C                   IF        BMRANR='Y'
     C                   MOVEL(P)  AMACNO        DDACNO
     C                   ENDIF
     C                   ENDIF
      *
      * Account Name
      *
     C                   EVAL      DDANAM=AMANAM
      *
      * Date Account opened
      *
     C                   IF        AMDACO=*ZERO
     C                   EVAL      DDDACO=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=AMDACO
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDDACO
     C                   END
      *
      * Date Account closed
      *
     C                   IF        AMDACC=*ZERO
     C                   EVAL      DDDACC=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=AMDACC
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDDACC
     C                   END
      *
      * Next Statement Date
      *
     C                   IF        AMNSTD=*ZEROS
     C                   EVAL      DDNSTD=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=AMNSTD
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDNSTD
     C                   END
      *
      * Frequency
      *
     C                   EVAL      DDSTFQ=AMSTFQ
      *
      * Number of Copies
      *
     C                   IF        AMENOC=*ZEROS
     C                   EVAL      DDENOC=*BLANKS
     C                   ELSE
     C                   MOVE (P)  AMENOC        DDENOC
     C                   ENDIF
      *
      * Next Statement Day
      *
     C                   IF        AMSTDY=*ZEROS
     C                   EVAL      DDNSDN=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  AMSTDY        DDNSDN
     C                   ENDIF
      *
      * Statement Balance in Euros
      *
     C                   EVAL      DDEUSB=AMEUSB
      *
      * Print Address
      *
     C                   TESTB     '2'           AMGLBT                   20
     C                   IF        *IN20
     C                   EVAL      DDPTAD='Y'
     C                   ELSE
     C                   EVAL      DDPTAD='N'
     C                   ENDIF
      *
      * Address References
      *
     C                   EVAL      DDREF=AMADREF1+AMADREF2
      *
      * Refer all Debits
      *
     C                   TESTB     '0'           AMRETB                   20
     C                   IF        *IN20
     C                   EVAL      DDRAD='Y'
     C                   ELSE
     C                   EVAL      DDRAD='N'
     C                   ENDIF
      *
      * Refer all Credits
      *
     C                   TESTB     '1'           AMRETB                   20
     C                   IF        *IN20
     C                   EVAL      DDRAC='Y'
     C                   ELSE
     C                   EVAL      DDRAC='N'
     C                   ENDIF
      *
      * Block all Debits
      *
     C                   TESTB     '2'           AMRETB                   20
     C                   IF        *IN20
     C                   EVAL      DDBAD='Y'
     C                   ELSE
     C                   EVAL      DDBAD='N'
     C                   ENDIF
      *
      * Block all Credits
      *
     C                   TESTB     '3'           AMRETB                   20
     C                   IF        *IN20
     C                   EVAL      DDBAC='Y'
     C                   ELSE
     C                   EVAL      DDBAC='N'
     C                   ENDIF
      *
      ** TI Account
      *
     C                   IF        CTI006 = 'Y'                                             MD034725
     C                   EVAL      DDTIAC = AMA5TIAC                                        MD034725
     C                   ENDIF                                                              MD034725
      *                                                                                     MD034725
     C                   IF        BGN3ST='Y'
     C                   IF        AMA5TIAC=*BLANK
     C                   EVAL      DDTIAC='N'
     C                   ELSE
     C                   EVAL      DDTIAC=AMA5TIAC
     C                   ENDIF
      *
      ** TI Account Number
      *
     C                   EVAL      DDTIAN=AMA5TIAN
      *
      ** TI Account Suffix
      *
     C                   EVAL      DDTIAS=AMA5TIAS
     C                   END
      *
      ** Profit Centre
      *
     C                   EVAL      DDPRFC=AMPRFC
      *
      * Archiving Frequency
      *
     C                   EVAL      DDMFFQ=AMMFFQ
      *                                                                         CFT004
      * International Bank Account Number                                       CFT004
      *                                                                         CFT004
     C*****AMIBAN        IFNE      *BLANKS                                           206824 AR740293
     C**********         CALLB     'AOIBANR3'                                        206824 AR740293
     C**********         PARM      *BLANKS       @RTCD             7                 206824 AR740293
     C**********         PARM      AMIBAN        @IBAN            47                 206824 AR740293
     C**********         PARM                    @IWITH           47                 206824 AR740293
     C**********         PARM                    @INOBL           34                 206824 AR740293
     C*****@RTCD         IFEQ      *BLANKS                                           206824 AR740293
     C**********         EVAL      DDIBAN=@IWITH                                     206824 AR740293
     C**********         ELSE                                                        206824 AR740293
     C**********         EVAL      DDIBAN=*BLANKS                                    206824 AR740293
     C**********         ENDIF                                                       206824 AR740293
     C**********         ENDIF                                                       206824 AR740293
      **********                                                                     206824 AR740293
     C**********         EVAL      DDIBAN=AMIBAN                                       CFT004 206824
     C                   EVAL      DDIBAN=AMIBAN                                            AR740293
      *
      * Linked Enquiry
      *
      ** Test the A/c if it is a prime account
     C     AMLTAS        IFNE      99
      *
      ** Test if it is a secondary account
     C     RELINK        CHAIN     RELINKL1                           80
     C     *IN80         IFEQ      *OFF
     C                   MOVEL     *BLANKS       DDLINK
      *
      ** If RE number is being used, show RE number of the prime a/c.
     C                   MOVE      CCY           LTCCY                                        220101
     C     BMRANR        IFEQ      'Y'
     C     ACLINK        CHAIN     ACCNTLXX                           80
     C     *IN80         IFEQ      '0'
     C     ACNO          ANDNE     0                                                          241027
     C                   MOVEL     ACNO          DDLINK
     C                   ELSE
     C                   MOVEL     WWLINK        DDLINK
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     WWLINK        DDLINK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Portfolio Reference
      *
     C                   IF        BGPFMG='Y'
     C                             OR BGN4ST='Y'                                              CPB001
     C                   IF        AMPTFR='9997'
     C                             AND BGN4ST <> 'Y'                                          CPB001
     C                   EVAL      DDPTFR=FCR997
     C                   ELSE
     C                   EVAL      DDPTFR=AMPTFR
     C                   ENDIF
     C                   ENDIF
      *
      * Midas Taxable Indicator
      *
     C**********         IF        BGWDPR='Y' and BGSWRT='Y' and AMATYP='R'                   213342
     C                   IF        BGWDPR='Y' and AMATYP='R'                                  213342
     C                   IF        BGSWRT='Y' or BGNTST='Y'                                   213342
     C                             or R_FACH='Y' or R_TSTMC='Y'                               213342
     C                   EVAL      DDITAX=BXITAX
      *
      * Statement Charge Indicator
      *
     C                   EVAL      DDSTCI=BXSTCI
      *
      * Statement Fee Amount
      *
     C     RESKEY        CHAIN     RESTCHPD                           80
     C                   IF        not *IN80
     C                   IF        STFAMT=*ZEROS
     C                   EVAL      DDFAMT=*BLANKS
     C                   ELSE
      *
     C                   MOVE      STFAMT        ZFLD15
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDFAMT
     C                   END
     C                   ELSE                                                                 213342
     C                   EVAL      DDFAMT=*BLANKS                                             213342
     C                   END
      *
      * Subject to Account Charge
      *
     C                   EVAL      DDCHIN=BXCHIN
      *
      * Account charge amount
      *
     C                   IF        BXCHAM=*ZEROS
     C                   EVAL      DDCHAM=*BLANKS
     C                   ELSE
      *
     C                   EVAL      ZFLD15=BXCHAM
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDCHAM
     C                   END
     C                   ENDIF                                                                213342
     C                   ENDIF
      *
      **                                                                                      CER050
     C                   If        CER050 = 'Y'                                               CER050
     C                             and AMATYP = 'R'                                           CER050
      *                                                                                       CER050
     C                   Eval      DDAPRC = BXAPRC                                            CER050
      *                                                                                       CER050
     C     AMACNO        Chain     REAPRHI0                           80                      CER050
     C                   If        *In80 = *Off                                               CER050
     C                             and IAPRR <> 0                                             CER050
     C                   Eval      ZFLD15 = IAPRR * 100                                       CER050
     C                   EVAL      ZDECS = 2                                                  CER050
     C                   Exsr      FMTAMT                                                     CER050
     C                   move      ZOUT21        DDAPDR                                       CER050
     C                   Else                                                                 CER050
     C                   move      *Blanks       DDAPDR                                       CER050
     C                   Endif                                                                CER050
      *                                                                                       CER050
     C     AMACNO        Chain     REAPRHI1                           80                      CER050
     C                   If        *In80 = *Off                                               CER050
     C                             and IAPRR <> 0                                             CER050
     C                   Eval      ZFLD15 = IAPRR * 100                                       CER050
     C                   EVAL      ZDECS = 2                                                  CER050
     C                   Exsr      FMTAMT                                                     CER050
     C                   move      ZOUT21        DDAPCR                                       CER050
     C                   Else                                                                 CER050
     C                   move      *Blanks       DDAPCR                                       CER050
     C                   Endif                                                                CER050
      *                                                                                       CER050
     C                   Endif                                                                CER050
      *                                                                                       CER050
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD2 - Output for screen 2(Debit Interest/Overdraft details)
      *****************************************************************
     C     SETFLD2       BEGSR
      *
      * Base Rate Type
      *
     C                   IF        AMDRIB=*ZERO
     C                   EVAL      DDDRIB=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  AMDRIB        DDDRIB
     C                   ENDIF
      *
      * Rate/Spread & Sign
      *
     C                   IF        AMDRIS=*ZEROS
     C                   EVAL      DDDRIS=*BLANKS
     C                   ELSE
     C                   IF        AMDRIS<*ZEROS
     C                   EVAL      DDDSIG='-'
     C                   ELSE
     C                   EVAL      DDDSIG='+'
     C                   END
     C                   EVAL      ZFLD15=AMDRIS*10000000
     C                   EVAL      ZDECS=7
     C                   EXSR      FMTAMT
     C                   EVAL      DDDRIS= %SUBST(ZOUT21:9:12)
     C                   END
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                                                                                        CRE073
      *                                                                                       CRE073
      ** DR Contractual Spread                                                                CRE073
      *                                                                                       CRE073
     C                   IF        AMDCSP <> *ZEROS                                           CRE073
     C                   MOVE      *BLANKS       ZFIELD                                       CRE073
     C                   MOVE(P)   AMDCSP        ZFIELD                                       CRE073
     C                   Z-ADD     7             ZADEC                                        CRE073
     C                   EXSR      ZEDIT                                                      CRE073
     C                   MOVE      ZFIELD        DDDCSP                                       CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** DR Contractual Spread Sign                                                           CRE073
      *                                                                                       CRE073
     C                   MOVEL     AMDCSG        DDDCSG                                       CRE073
      *                                                                                       CRE073
      ** DR Rounding Method                                                                   CRE073
      *                                                                                       CRE073
     C                   MOVEL     AMDRMT        DDDRMT                                       CRE073
      *                                                                                       CRE073
      ** DR Rounding Fraction/Decimal                                                         CRE073
      *                                                                                       CRE073
     C                   MOVEL     AMDRFD        DDDRFD                                       CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
     C*
      *
      * Interest Calculation Type
      *
     C                   IF        RIDICT=*ZEROS
     C                   EVAL      DDDICT=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  RIDICT        DDDICT
     C                   ENDIF
      *
      * Interest Calculation Subtype
      *
     C                   IF        RIDCST=*ZEROS
     C                   EVAL      DDDCST=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  RIDCST        DDDCST
     C                   ENDIF
      *
      * This Change Value Date
      *
     C                   EVAL      DDDRCD=*BLANKS
      *
      * Old Change Value Date
      *
     C                   IF        AMOLDR=*ZEROS
     C                   EVAL      DODRCD=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=AMOLDR
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DODRCD
     C                   ENDIF
      *
      * Calculation Basis
      *
     C**********         IF        AMDRIC=*ZEROS                                            BUG23352
     C**********         EVAL      DDDRIC=*BLANKS                                           BUG23352
     C**********         ELSE                                                               BUG23352
     C                   MOVEL(P)  AMDRIC        DDDRIC
     C**********         ENDIF                                                              BUG23352
      *
      * Next Capitalisation Date
      *
     C                   IF        AMNDID=*ZEROS
     C                   EVAL      DDNDID=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=AMNDID
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDNDID
     C                   ENDIF
      *
      * Next Capitalisation Frequency
      *
     C                   EVAL      DDDRIF=AMDRIF
      *
      * Next Capitalisation Day Number
      *
     C                   IF        AMDRDY=*ZERO
     C                   EVAL      DDDNCD=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  AMDRDY        DDDNCD
     C                   ENDIF
      *
      * Alternative Account (Branch) to Post Dr Interest
      *
     C                   EVAL      DDDRBR=RIDRBR
      *
      * Alternative Account to Post Dr Interest
      *
     C                   EVAL      DDDACP=RIDACP
      *
      * Overdraft Line
      *
     C                   IF        AMODLN=*ZEROS
     C                   EVAL      DDODLN=*BLANKS
     C                   ELSE
     C                   EVAL      ZFLD15=AMODLN
     C                   EVAL      ZDECS=0
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDODLN
     C                   END
      *
      * Overdraft secured
      *
     C                   EVAL      DDODSC=AMODSC
      *
      * Reversal Date (Limit or Rate)
      *
     C                   IF        BXITRD=*ZEROS
     C                   EVAL      DDITRD=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=BXITRD
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDITRD
     C                   ENDIF
      *
      * Overdraft Limit Charge Value Date
      *
     C                   IF        BXOLVD=*ZEROS
     C                   EVAL      DDOLVD=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=BXOLVD
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDOLVD
     C                   ENDIF
      *
      * Previous Overdraft Limit Charge Value Date
      *
     C                   IF        BXPOLC=*ZEROS
     C                   EVAL      DDPOLC=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=BXPOLC
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDPOLC
     C                   ENDIF
      *
      * Overdraft Limit Expiry Date
      *
     C                   IF        AMODED=*ZEROS
     C                   EVAL      DDODED=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=AMODED
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDODED
     C                   ENDIF
      *
      * Previous Overdraft Limit Expiry Date
      *
     C                   IF        BXPOLE=*ZEROS
     C                   EVAL      DDPOLE=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=BXPOLE
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDPOLE
     C                   ENDIF
      *
      * Additional Overdraft Rate & Sign
      *
     C                   IF        BXAODR=*ZEROS
     C                   EVAL      DDAODR=*BLANKS
     C                   ELSE
     C                   IF        BXAODR<*ZEROS
     C                   EVAL      DDAODRX='-'
     C                   ELSE
     C                   EVAL      DDAODRX=' '
     C                   END
     C                   EVAL      ZFLD15=BXAODR*10000000
     C                   EVAL      ZDECS=7
     C                   EXSR      FMTAMT
     C                   EVAL      DDAODR= %SUBST(ZOUT21:9:12)
     C                   END
      *
      * Change Value Date for Overdraft Rate
      *
     C                   IF        BXORTC=*ZEROS
     C                   EVAL      DDORTC=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=BXORTC
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDORTC
     C                   ENDIF
      *                                                                                       CER055
     C                   IF        CER055 = 'Y'                                               CER055
      *                                                                                       CER055
      ** Date of Overdraft Balance Excess                                                     CER055
      *                                                                                       CER055
     C                   IF        BXDOBE = *ZEROS                                            CER055
     C                   EVAL      DDDOBE = *BLANKS                                           CER055
     C                   ELSE                                                                 CER055
     C                   EVAL      DAYNO = BXDOBE                                             CER055
     C                   EXSR      CVTDAT                                                     CER055
     C                   MOVEL(P)  ZDATE         DDDOBE                                       CER055
     C                   ENDIF                                                                CER055
      *                                                                                       CER055
      ** Number of days in excess                                                             CER055
      *                                                                                       CER055
     C                   IF        BXNDYE = *ZEROS                                            CER055
     C                   EVAL      DDNDYE = *BLANKS                                           CER055
     C                   ELSE                                                                 CER055
     C                   MOVE      BXNDYE        DDNDYE                                       CER055
     C                   ENDIF                                                                CER055
      *                                                                                       CER055
      * Overdraft Line                                                                        CER055
      *                                                                                       CER055
     C                   IF        BXPOLA = *ZEROS                                            CER055
     C                   EVAL      DDPOLA = *BLANKS                                           CER055
     C                   ELSE                                                                 CER055
     C                   EVAL      ZFLD15 = BXPOLA                                            CER055
     C                   EVAL      ZDECS = 0                                                  CER055
     C                   EXSR      FMTAMT                                                     CER055
     C                   MOVE      ZOUT21        DDPOLA                                       CER055
     C                   END                                                                  CER055
     C                   ENDIF                                                                CER055
      *
      *                                                                                       CGL165
      * Tax Codes
     C                   IF        CGL165 = 'Y'                                               CGL165
     C                   EVAL      DDTXC1 = BXTXC1                                            CGL165
     C                   EVAL      DDTXC2 = BXTXC2                                            CGL165
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD3 - Output for screen 3 (Credit Interest/Charges details)
      *****************************************************************
     C     SETFLD3       BEGSR
      *
      * Base Rate Type
      *
     C                   IF        AMCRIB=*ZERO
     C                   EVAL      DDCRIB=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  AMCRIB        DDCRIB
     C                   ENDIF
      *
      * Rate/Spread & Sign
      *
     C                   IF        AMCRIS=*ZEROS
     C                   EVAL      DDCRIS=*BLANKS
     C                   ELSE
     C                   IF        AMCRIS<*ZEROS
     C                   EVAL      DDCSIG='-'
     C                   ELSE
     C                   EVAL      DDCSIG='+'
     C                   END
     C                   EVAL      ZFLD15=AMCRIS*10000000
     C                   EVAL      ZDECS=7
     C                   EXSR      FMTAMT
     C                   EVAL      DDCRIS= %SUBST(ZOUT21:9:12)
     C                   END
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                                                                                        CRE073
      *                                                                                       CRE073
      ** CR Contractual Spread                                                                CRE073
      *                                                                                       CRE073
     C                   IF        AMCCSP <> *ZEROS                                           CRE073
     C                   MOVE      *BLANKS       ZFIELD                                       CRE073
     C                   MOVE(P)   AMCCSP        ZFIELD                                       CRE073
     C                   Z-ADD     7             ZADEC                                        CRE073
     C                   EXSR      ZEDIT                                                      CRE073
     C                   MOVE      ZFIELD        DDCCSP                                       CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** CR Contractual Spread Sign                                                           CRE073
      *                                                                                       CRE073
     C                   MOVEL     AMCCSG        DDCCSG                                       CRE073
      *                                                                                       CRE073
      ** CR Rounding Method                                                                   CRE073
      *                                                                                       CRE073
     C                   MOVEL     AMCRMT        DDCRMT                                       CRE073
      *                                                                                       CRE073
      ** CR Rounding Fraction/Decimal                                                         CRE073
      *                                                                                       CRE073
     C                   MOVEL     AMCRFD        DDCRFD                                       CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
     C*
      *
      * Interest Calculation Type
      *
     C                   IF        RICICT=*ZEROS
     C                   EVAL      DDCICT=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  RICICT        DDCICT
     C                   ENDIF
      *
      * Interest Calculation Subtype
      *
     C                   IF        RICCST=*ZEROS
     C                   EVAL      DDCCST=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  RICCST        DDCCST
     C                   ENDIF
      *
      * This Change Value Date
      *
     C                   EVAL      DDCRCD=*BLANKS
      *
      * Old Change Value Date
      *
     C                   IF        AMOLCR=*ZEROS
     C                   EVAL      DOCRCD=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=AMOLCR
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DOCRCD
     C                   ENDIF
      *
      * Calculation Basis
      *
     C**********         IF        AMCRIC=*ZEROS                                            BUG23352
     C**********         EVAL      DDCRIC=*BLANKS                                           BUG23352
     C**********         ELSE                                                               BUG23352
     C                   MOVEL(P)  AMCRIC        DDCRIC
     C**********         ENDIF                                                              BUG23352
      *
      * Next Capitalisation Date
      *
     C                   IF        AMNCID=*ZEROS
     C                   EVAL      DDNCID=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=AMNCID
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDNCID
     C                   ENDIF
      *
      * Next Capitalisation Frequency
      *
     C                   EVAL      DDCRIF=AMCRIF
      *
      * Next Capitalisation Day Number
      *
     C                   IF        AMCRDY=*ZERO
     C                   EVAL      DDCNCD=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  AMCRDY        DDCNCD
     C                   ENDIF
      *
      * Alternative Account (Branch) to Post Cr Interest
      *
     C                   EVAL      DDCRBR=RICRBR
      *
      * Alternative Account to Post Dr Interest
      *
     C                   EVAL      DDCACP=RICACP
      *
      * Charges Calculation Type
      *
     C                   IF        RICHGT=*ZERO
     C                   EVAL      DDCHGT=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  RICHGT        DDCHGT
     C                   END
      *
      * Charges Calculation SubType
      *
     C                   IF        RICHST=*ZERO
     C                   EVAL      DDCHST=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  RICHST        DDCHST
     C                   END
      *
      * Alternative account Charges Branch
      *
     C                   EVAL      DDCHBR=RICHBR
      *
      * Alternative account Charges Account
      *
     C                   EVAL      DDCHCP=RICHAC
      *
      * Transaction Charges Override
      *
     C                   IF        RITCHO=*ZEROS
     C                   EVAL      DDTCHO=*BLANKS
     C                   ELSE
      *
     C                   EVAL      ZFLD15=RITCHO
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDTCHO= %SUBST(ZOUT21:13:9)
     C                   END
      *
      * Midas Taxable Indicator
      *
     C                   IF        BGWDPR='Y' and BGNTST='Y'
     C                             or BGWDPR='Y' and R_FACH='Y'
     C                             or BGWDPR='Y' and R_TSTMC='Y'
     C                   EVAL      DDITAX=BXITAX
      *
      * Statement Charge Indicator
      *
     C                   EVAL      DDSTCI=BXSTCI
      *
      * Subject to Account Charge
      *
     C                   EVAL      DDCHIN=BXCHIN
      *
      * Account charge amount
      *
     C                   IF        BXCHAM=*ZEROS
     C                   EVAL      DDCHAM=*BLANKS
     C                   ELSE
      *
     C                   EVAL      ZFLD15=BXCHAM
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDCHAM= %SUBST(ZOUT21:13:9)
     C                   END
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD4 - Output for screen 4 (Commissions & Override details)
      *****************************************************************
     C     SETFLD4       BEGSR
      *
      * Highest OD Commision
      *
     C                   IF        COCEXA=*BLANKS
     C                   EVAL      DDCEXA=*BLANKS
     C                   ELSE
      *                                                                                       221603
     C                   IF        COCEXA='E'                                                 221603
     C                   EVAL      DDCEXA=COCEXA                                              221603
     C                   ELSE                                                                 221603
      *
     C                   MOVE      COCEXA        ZFLD15
     C                   EVAL      ZDECS=8
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXA= %SUBST(ZOUT21:10:12)
     C                   END                                                                  221603
     C                   END
      *
      * Turnover Commission
      *
     C                   IF        COCEXB=*BLANKS
     C                   EVAL      DDCEXB=*BLANKS
     C                   ELSE
      *                                                                                       221603
     C                   IF        COCEXB='E'                                                 221603
     C                   EVAL      DDCEXB=COCEXB                                              221603
     C                   ELSE                                                                 221603
      *
     C                   MOVE      COCEXB        ZFLD15
     C                   EVAL      ZDECS=8
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXB= %SUBST(ZOUT21:10:12)
     C                   END                                                                  221603
     C                   END
     C*
      *
      * Debit Interest Commission
      *
     C                   IF        COCEXC=*BLANKS
     C                   EVAL      DDCEXC=*BLANKS
     C                   ELSE
      *                                                                                       221603
     C                   IF        COCEXC='E'                                                 221603
     C                   EVAL      DDCEXC=COCEXC                                              221603
     C                   ELSE                                                                 221603
      *
     C                   MOVE      COCEXC        ZFLD15
     C                   EVAL      ZDECS=8
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXC= %SUBST(ZOUT21:10:12)
     C                   END                                                                  221603
     C                   END
      *
      * Commission on Inactive Account
      *
     C                   IF        COCEXD=*BLANKS
     C                   EVAL      DDCEXD=*BLANKS
     C                   ELSE
      *                                                                                       221603
     C                   IF        COCEXD='E'                                                 221603
     C                   EVAL      DDCEXD=COCEXD                                              221603
     C                   ELSE                                                                 221603
      *
     C                   MOVE      COCEXD        ZFLD15
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXD= %SUBST(ZOUT21:13:9)
     C                   END                                                                  221603
     C                   END
      *
      * Maximum Credit Balance Commission
      *
     C                   IF        COCEXE=*BLANKS
     C                   EVAL      DDCEXE=*BLANKS
     C                   ELSE
      *                                                                                       221603
     C                   IF        COCEXE='E'                                                 221603
     C                   EVAL      DDCEXE=COCEXE                                              221603
     C                   ELSE                                                                 221603
      *
     C                   MOVE      COCEXE        ZFLD15
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXE= %SUBST(ZOUT21:13:9)
     C                   END                                                                  221603
     C                   END
      *
      * Extra Daily Statement Commission
      *
     C                   IF        COCEXF=*BLANKS
     C                   EVAL      DDCEXF=*BLANKS
     C                   ELSE
      *                                                                                       221603
     C                   IF        COCEXF='E'                                                 221603
     C                   EVAL      DDCEXF=COCEXF                                              221603
     C                   ELSE                                                                 221603
      *
     C                   MOVE      COCEXF        ZFLD15
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXF= %SUBST(ZOUT21:13:9)
     C                   END                                                                  221603
     C                   END
      *
      * Fixed Commission
      *
     C                   IF        COCEXG=*BLANKS
     C                   EVAL      DDCEXG=*BLANKS
     C                   ELSE
      *                                                                                       221603
     C                   IF        COCEXG='E'                                                 221603
     C                   EVAL      DDCEXG=COCEXG                                              221603
     C                   ELSE                                                                 221603
      *
     C                   MOVE      COCEXG        ZFLD15
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXG= %SUBST(ZOUT21:13:9)
     C                   END                                                                  221603
     C                   END
      *
      * Number of Copies Chargeable
      *
     C                   IF        CONOCC=*ZERO
     C                   EVAL      DDNOCC=*BLANKS
     C                   ELSE
     C                   MOVE (P)  CONOCC        DDNOCC
     C                   END
      *
     C                   EVAL      DDOVRD = BXOVRD                              CDE002
     C                   EVAL      DDOVRC = BXOVRC                              CDE002
                                                                                CDE002
      ** Convert file DR margin rate to character field with decimal pt         CDE002
                                                                                CDE002
     C**********         IF        BXDRMG = *ZEROS                                     CDE002 TDA084
     C**********                   and BXDMBR <> *BLANKS                               208221 TDA084
     C**************     EVAL      DDDRMG = *BLANKS                       CDE002208221
     C**********         EVAL      DDDRMG = BXDMBR                                     208221 TDA084
     C**********         ELSE                                                          CDE002 TDA084
     C                   IF        BXDRMG <>*ZEROS                                            TDA084
     C                   MOVE      BXDRMG        ZFLD15                         CDE002
     C                   EVAL      ZDECS= 7                                     CDE002
     C                   EXSR      FMTAMT                                       CDE002
     C**************     EVAL      DDDRMG= %SUBST(ZOUT21:9:12)            CDE002208221
     C                   EVAL      DDDRMG= %SUBST(ZOUT21:10:12)                 208221
     C                   ELSE                                                                 TDA084
     C                   EVAL      DDDRMG = *BLANKS                                           TDA084
     C                   IF        BXDMBR <>*BLANKS                                           TDA084
     C                   EVAL      DDDRMG = BXDMBR                                            TDA084
     C                   ENDIF                                                                TDA084
     C                   ENDIF                                                  CDE002
                                                                                CDE002
      ** Convert file CR margin rate to character field with decimal pt         CDE002
                                                                                CDE002
     C**********         IF        BXCRMG = *ZEROS                                     CDE002 TDA084
     C**********                   and BXCMBR <> *BLANKS                               208221 TDA084
     C**************     EVAL      DDCRMG = *BLANKS                       CDE002208221
     C**********         EVAL      DDCRMG = BXCMBR                                     208221 TDA084
     C**********         ELSE                                                          CDE002 TDA084
     C                   IF        BXCRMG <>*ZEROS                                            TDA084
     C                   MOVE      BXCRMG        ZFLD15                         CDE002
     C                   EVAL      ZDECS= 7                                     CDE002
     C                   EXSR      FMTAMT                                       CDE002
     C**************     EVAL      DDCRMG= %SUBST(ZOUT21:9:12)            CDE002208221
     C                   EVAL      DDCRMG= %SUBST(ZOUT21:10:12)                 208221
     C                   ELSE                                                                 TDA084
     C                   EVAL      DDCRMG = *BLANKS                                           TDA084
     C                   IF        BXCMBR <>*BLANKS                                           TDA084
     C                   EVAL      DDCRMG = BXCMBR                                            TDA084
     C                   ENDIF                                                                TDA084
     C                   ENDIF                                                  CDE002
                                                                                CDE002
      *
      ** Retrieve default commissions
     C*******************EXSR      SRRTVCG                                      176842
     C*******************EXSR      SRRTVCM                                      176842
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD5 - Output for screen 5 (Account Other details)
      *****************************************************************
     C     SETFLD5       BEGSR
      *
      * Minimum Balance
      *
     C                   IF        AMMINB=*ZERO
     C                   EVAL      DDMINB=*BLANKS
     C                   ELSE
     C                   MOVE      AMMINB        ZFLD15
     C                   EVAL      ZDECS=0
     C                   EXSR      FMTAMT
     C                   EVAL      DDMINB= %SUBST(ZOUT21:9:13)
     C                   END
      *
      * BRT Category
      *
     C                   EVAL      DDBRTCA=AMBRTCA
      *
      * Facility Type
      *
     C                   IF        AMFACT=*ZERO
     C                   EVAL      DDFACT=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  AMFACT        DDFACT
     C                   ENDIF
      *
      * Facility Number
      *
     C                   IF        AMFCNO=*ZERO
     C                   EVAL      DDFCNO=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  AMFCNO        DDFCNO
     C                   ENDIF
      *
      * Encashment Facility
      *
     C                   IF        AMEFAC=*ZERO
     C                   EVAL      DDEFAC=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  AMEFAC        DDEFAC
     C                   ENDIF
      *
      * Inactive Account Y/N
      *
     C                   TESTB     '4'           AMRETB                   20
     C                   IF        *IN20
     C                   EVAL      DDINAI='Y'
     C                   ELSE
     C                   EVAL      DDINAI='N'
     C                   ENDIF
      *
      * Bankrupt/Liquidated Y/N
      *
     C                   TESTB     '6'           AMRETB                   20
     C                   IF        *IN20
     C                   EVAL      DDBRLI='Y'
     C                   ELSE
     C                   EVAL      DDBRLI='N'
     C                   ENDIF
      *
      * Bad Debt Y/N
      *
     C                   TESTB     '7'           AMRETB                   20
     C                   IF        *IN20
     C                   EVAL      DDBADI='Y'
     C                   ELSE
     C                   EVAL      DDBADI='N'
     C                   ENDIF
      *
      * Print Transactions Advice Y/N
      *
     C                   EVAL      DDPTRA=RIPTRA
      *
      * Print Rate Change Advice Y/N
      *
     C                   EVAL      DDPRCH=RIPRCH
      *
      * Passbooks used on Account Y/N
      *
     C                   EVAL      DDPBKU=RIPBKU
      *
      * Savings Account Password
      *
     C**********         EVAL      DDPSWD=PWPSWD                                              CSD101
     C                   EVAL      KCNUM2 = AMCNUM                                            CSD101
     C                   EVAL      KCCY2  = AMCCY                                             CSD101
     C                   MOVE      AMACOD        KACOD2                                       CSD101
     C                   MOVE      AMACSQ        KACSQ2                                       CSD101
     C                   EVAL      KBRCA2 = AMBRCA                                            CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PIDName = 'ACCOUNTPASSWORD_'   + CHKACC2                   CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM      *Blanks       PPass1                                       CSD101
     C                   PARM      *Blanks       PDescr                                       CSD101
     C                   IF        PReturnCode =  *Blanks                                     CSD101
     C                   EVAL      PWPSWD = PPass1                                            CSD101
     C                   EVAL      DDPSWD = PPass1                                            CSD101
     C                   ENDIF                                                                CSD101
                                                                                              CSD101
                                                                                              CLE025
      ** Facility Customer                                                                    CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                   EVAL      DDFCCU = *BLANKS                                           CLE025
     C**********         IF        AMFCCU <> *ZERO                                     CLE025 CSD027
     C                   IF        AMFCCU <> *BLANKS                                          CSD027
     C                             AND AMFCCU <> '000000'                                   BUG11914
     C                   MOVEL(P)  AMFCCU        DDFCCU                                       CLE025
     C                   ENDIF                                                                CLE025
     C                   ENDIF                                                                CLE025
      *
      ** Subject to KWG §24c reporting                                                        CER047
      *                                                                                       CER047
     C                   IF        CER047 = 'Y'                                               CER047
     C**********         EVAL      DDK24C = AMK24C                                   CER047 BUG24157
     C                   EVAL      DD24C = AMK24C                                           BUG24157
     C                   ENDIF                                                                CER047
                                                                                              CER047
      *                                                                                       CRE075
      ** Effective Date for Retail Accounts                                                   CRE075
      *                                                                                       CRE075
     C                   IF        CRE075 = 'Y'                                               CRE075
     C                   EVAL      DAYNO = AMEFDT                                             CRE075
     C                   EXSR      CVTDAT                                                     CRE075
     C                   MOVEL(P)  ZDATE         DDEFDT                                       CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   ENDSR
     C/COPY OFCPYSRCZ,CRE101_012                                                              CRE101
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  SETFLD6 - Output for Period and Penalty Details                                      CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     SETFLD6       BEGSR                                                                CRE015
                                                                                              CRE015
      ** FIXED FIELDS                                                                         CRE015
                                                                                              CRE015
      ** Period type                                                                          CRE015
                                                                                              CRE015
     C                   EVAL      DD0TPRD = APATPRD                                          CRE015
                                                                                              CRE015
      ** Amount type (interest rollover indicator)                                            CRE015
                                                                                              CRE015
     C                   EVAL      DD0IRLI = APAIRLI                                          CRE015
                                                                                              CRE015
      ** Next date (maturity date)                                                            CRE015
                                                                                              CRE015
     C                   IF        APAVDAT > *ZEROS                                           CRE015
     C                             AND APAMDAT > *ZEROS                                       CRE015
     C                             AND APAMDAT < C#TRMDAT                                     CRE015
     C                   EVAL      DAYNO = APAMDAT                                            CRE015
     C                   EXSR      CVTDAT                                                     CRE015
     C                   MOVE      ZDATE         DD0MDAT                                      CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** Available date                                                                       CRE015
                                                                                              CRE015
     C                   IF        APAVDAT > *ZEROS                                           CRE015
     C                             AND APAMDAT > *ZEROS                                       CRE015
     C                             AND APAMDAT < C#TRMDAT                                     CRE015
                                                                                              CRE015
      ** Get the next working date after maturity date, that is, the                          CRE015
      ** first working day of the new term                                                    CRE015
                                                                                              CRE015
     C                   EVAL      ZDAYNO = APAMDAT                                           CRE015
     C                   EXSR      SRNxtFreq                                                  CRE015
                                                                                              CRE015
     C                   EVAL      DAYNO = ZDAYNO                                             CRE015
     C                   EXSR      CVTDAT                                                     CRE015
     C                   MOVE      ZDATE         DD0AVAL                                      CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** Current cleared balance - pos 1-16 amount, 17-18 sign (D or C)                       CRE015
                                                                                              CRE015
     C     RELINK        CHAIN     ACCNTLXX                                                   CRE015
     C                   IF        %FOUND(ACCNTLXX)                                           CRE015
     C                   EVAL      ZFLD15 = CLBL                                              CRE015
     C                   EVAL      ZDECS = A6NBDP                                             CRE015
     C                   EXSR      FMTAMT                                                     CRE015
     C                   IF        CLBL <> *ZEROS                                             CRE015
     C                   IF        %SUBST(ZOUT21:21:1) = '-'                                  CRE015
     C                   EVALR     DD0CLBL =                                                  CRE015
     C                             %TRIM(%SUBST(ZOUT21:1:20)) + 'C '                          CRE015
     C                   ELSE                                                                 CRE015
     C                   EVALR     DD0CLBL =                                                  CRE015
     C                             %TRIM(%SUBST(ZOUT21:1:20)) + 'D '                          CRE015
     C                   ENDIF                                                                CRE015
     C                   ELSE                                                                 CRE015
     C                   EVALR     DD0CLBL =                                                  CRE015
     C                             %TRIM(%SUBST(ZOUT21:1:20)) + '  '                          CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** REPEATING FIELDS                                                                     CRE015
                                                                                              CRE015
      ** Move the file format to the buffer array                                             CRE015
                                                                                              CRE015
     C                   MOVEA     ExPPFilFmt    ArrFilBuf                                    CRE015
                                                                                              CRE015
      ** Process each event of period and penalty (from A - Z)                                CRE015
                                                                                              CRE015
     C                   DO        26            X                                            CRE015
                                                                                              CRE015
      ** Move event details to file format DS array                                           CRE015
                                                                                              CRE015
     C                   EVAL      ArrFil(X) = ArrFilBuf(X)                                   CRE015
                                                                                              CRE015
      ** Initialise event details of screen format                                            CRE015
                                                                                              CRE015
     C                   CLEAR                   ArrScn(X)                                    CRE015
                                                                                              CRE015
      ** Format each field if the event is not blanks                                         CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2EVNT <> *BLANKS                                CRE015
                                                                                              CRE015
      ** Event type                                                                           CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWEVNT = ArrFil(X).E2EVNT                        CRE015
                                                                                              CRE015
      ** Period start date / value date                                                       CRE015
                                                                                              CRE015
     C                   EVAL      DAYNO = ArrFil(X).E2VDAT                                   CRE015
     C                   EXSR      CVTDAT                                                     CRE015
     C                   MOVE      ZDATE         W#DATE                                       CRE015
     C                   EVAL      ArrScn(X).RWVDAT = W#DATE                                  CRE015
                                                                                              CRE015
      ** Period end date or no. of remaining terms                                            CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2CEDE > 999                                     CRE015
     C                   EVAL      DAYNO = ArrFil(X).E2CEDE                                   CRE015
     C                   EXSR      CVTDAT                                                     CRE015
     C                   MOVE      ZDATE         W#DATE                                       CRE015
     C                   EVAL      ArrScn(X).RWCEDE = W#DATE                                  CRE015
     C                   ELSE                                                                 CRE015
     C                   EVALR     ArrScn(X).RWCEDE =                                         CRE015
     C                             %CHAR(ArrFil(X).E2CEDE)                                    CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** No. of days in period                                                                CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWNDPD =                                         CRE015
     C                             %EDITC(ArrFil(X).E2NDPD : '4')                             CRE015
                                                                                              CRE015
      ** No. of months in period                                                              CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWNMPD =                                         CRE015
     C                             %EDITC(ArrFil(X).E2NMPD : '4')                             CRE015
                                                                                              CRE015
      ** Rollover frequency                                                                   CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWFREQ = ArrFil(X).E2FREQ                        CRE015
                                                                                              CRE015
      ** Rollover day of the month                                                            CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWDAYM =                                         CRE015
     C                             %EDITC(ArrFil(X).E2DAYM : '4')                             CRE015
                                                                                              CRE015
      ** DR interest base rate type                                                           CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2DRIB <> *ZEROS                                 CRE015
     C                   EVAL      ArrScn(X).RWDRIB =                                         CRE015
     C                             %EDITC(ArrFil(X).E2DRIB : 'X')                             CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** DR interest rate spread and sign                                                     CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2DRIS <> *ZEROS                                 CRE015
     C                   EVAL      ArrScn(X).RWDRIS =                                         CRE015
     C                             %EDITC(ArrFil(X).E2DRIS : '4')                             CRE015
     C                   IF        ArrFil(X).E2DRIS > *ZEROS                                  CRE015
     C                   EVAL      ArrScn(X).RWSIGD = '+'                                     CRE015
     C                   ELSE                                                                 CRE015
     C                   EVAL      ArrScn(X).RWSIGD = '-'                                     CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
      *                                                                                       CRE073
      ** DR Contractual Spread                                                                CRE073
      *                                                                                       CRE073
     C                   IF        ArrFil(X).E2DCSP <> *ZEROS                                 CRE073
     C                   EVAL      ArrScn(X).RWDCSP =                                         CRE073
     C                             %EDITC(ArrFil(X).E2DCSP : '4')                             CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** DR Contractual Spread Sign                                                           CRE073
      *                                                                                       CRE073
     C                   EVAL      ArrScn(X).RWDCSG = ArrFil(X).E2DCSG                        CRE073
      *                                                                                       CRE073
      ** DR Rounding Method                                                                   CRE073
      *                                                                                       CRE073
     C                   EVAL      ArrScn(X).RWDRMT = ArrFil(X).E2DRMT                        CRE073
      *                                                                                       CRE073
      ** DR Rounding Fraction/Decimal                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      ArrScn(X).RWDRFD = ArrFil(X).E2DRFD                        CRE073
      *                                                                                       CRE073
      ** CR Contractual Spread                                                                CRE073
      *                                                                                       CRE073
     C                   IF        ArrFil(X).E2CCSP <> *ZEROS                                 CRE073
     C                   EVAL      ArrScn(X).RWCCSP =                                         CRE073
     C                             %EDITC(ArrFil(X).E2CCSP : '4')                             CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** CR Contractual Spread Sign                                                           CRE073
      *                                                                                       CRE073
     C                   EVAL      ArrScn(X).RWCCSG = ArrFil(X).E2CCSG                        CRE073
      *                                                                                       CRE073
      ** CR Rounding Method                                                                   CRE073
      *                                                                                       CRE073
     C                   EVAL      ArrScn(X).RWCRMT = ArrFil(X).E2CRMT                        CRE073
      *                                                                                       CRE073
      ** CR Rounding Fraction/Decimal                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      ArrScn(X).RWCRFD = ArrFil(X).E2CRFD                        CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE015
      ** DR interest type and subtype                                                         CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2DICT <> *ZEROS                                 CRE015
     C                   EVAL      ArrScn(X).RWDICT =                                         CRE015
     C                             %EDITC(ArrFil(X).E2DICT : 'X')                             CRE015
     C                   EVAL      ArrScn(X).RWDCST =                                         CRE015
     C                             %EDITC(ArrFil(X).E2DCST : 'X')                             CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** DR interest calculation basis                                                        CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWDRIC =                                         CRE015
     C                             %EDITC(ArrFil(X).E2DRIC : '4')                             CRE015
                                                                                              CRE015
      ** DR rate fixing indicator                                                             CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWDNIR = ArrFil(X).E2DNIR                        CRE015
                                                                                              CRE015
      ** DR capitalisation frequency                                                          CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWDRIF = ArrFil(X).E2DRIF                        CRE015
                                                                                              CRE015
      ** DR capitalisation day / month                                                        CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2DRDY <> *ZEROS                                 CRE015
     C                   EVAL      W#DRDY = ArrFil(X).E2DRDY                                  CRE015
     C                   MOVEL     W#DRDY        W#DD                                         CRE015
     C                   MOVE      W#DRDY        W#MM                                         CRE015
     C                   EVAL      ArrScn(X).RWDRDD = W#DD                                    CRE015
     C                   EVAL      ArrScn(X).RWDRMM = W#MM                                    CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** DR interest alternative account                                                      CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWDACP = ArrFil(X).E2DACP                        CRE015
                                                                                              CRE015
      ** DR penalty transaction type                                                          CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWRTTD = ArrFil(X).E2RTTD                        CRE015
                                                                                              CRE015
      ** DR penalty time basis                                                                CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWDYBD = ArrFil(X).E2DYBD                        CRE015
                                                                                              CRE015
      ** DR penalty restriction                                                               CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWDRST = ArrFil(X).E2DRST                        CRE015
                                                                                              CRE015
      ** CR interest base rate type                                                           CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2CRIB <> *ZEROS                                 CRE015
     C                   EVAL      ArrScn(X).RWCRIB =                                         CRE015
     C                             %EDITC(ArrFil(X).E2CRIB : 'X')                             CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** CR interest rate spread and sign                                                     CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2CRIS <> *ZEROS                                 CRE015
     C                   EVAL      ArrScn(X).RWCRIS =                                         CRE015
     C                             %EDITC(ArrFil(X).E2CRIS : '4')                             CRE015
     C                   IF        ArrFil(X).E2CRIS > *ZEROS                                  CRE015
     C                   EVAL      ArrScn(X).RWSIGC = '+'                                     CRE015
     C                   ELSE                                                                 CRE015
     C                   EVAL      ArrScn(X).RWSIGC = '-'                                     CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** CR interest type and subtype                                                         CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2CICT <> *ZEROS                                 CRE015
     C                   EVAL      ArrScn(X).RWCICT =                                         CRE015
     C                             %EDITC(ArrFil(X).E2CICT : 'X')                             CRE015
     C                   EVAL      ArrScn(X).RWCCST =                                         CRE015
     C                             %EDITC(ArrFil(X).E2CCST : 'X')                             CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** CR interest calculation basis                                                        CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWCRIC =                                         CRE015
     C                             %EDITC(ArrFil(X).E2CRIC : '4')                             CRE015
                                                                                              CRE015
      ** CR rate fixing indicator                                                             CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWCNIR = ArrFil(X).E2CNIR                        CRE015
                                                                                              CRE015
      ** CR capitalisation frequency                                                          CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWCRIF = ArrFil(X).E2CRIF                        CRE015
                                                                                              CRE015
      ** CR capitalisation day / month                                                        CRE015
                                                                                              CRE015
     C                   IF        ArrFil(X).E2CRDY <> *ZEROS                                 CRE015
     C                   EVAL      W#DRDY = ArrFil(X).E2CRDY                                  CRE015
     C                   MOVEL     W#DRDY        W#DD                                         CRE015
     C                   MOVE      W#DRDY        W#MM                                         CRE015
     C                   EVAL      ArrScn(X).RWCRDD = W#DD                                    CRE015
     C                   EVAL      ArrScn(X).RWCRMM = W#MM                                    CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** CR interest alternative account                                                      CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWCACP = ArrFil(X).E2CACP                        CRE015
                                                                                              CRE015
      ** CR penalty transaction type                                                          CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWRTTC = ArrFil(X).E2RTTC                        CRE015
                                                                                              CRE015
      ** CR penalty time basis                                                                CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWDYBC = ArrFil(X).E2DYBC                        CRE015
                                                                                              CRE015
      ** CR penalty restriction                                                               CRE015
                                                                                              CRE015
     C                   EVAL      ArrScn(X).RWCRST = ArrFil(X).E2CRST                        CRE015
                                                                                              CRE015
      ** Initial balance - pos 1-16 amount, 17-18 sign (D or C)                               CRE015
                                                                                              CRE015
     C                   EVAL      ZFLD15 = ArrFil(X).E2BALN                                  CRE015
     C                   EVAL      ZDECS = A6NBDP                                             CRE015
     C                   EXSR      FMTAMT                                                     CRE015
     C                   IF        ArrFil(X).E2BALN <> *ZEROS                                 CRE015
     C                   IF        %SUBST(ZOUT21:21:1) = '-'                                  CRE015
     C                   EVALR     ArrScn(X).RWBALN =                                         CRE015
     C                             %TRIM(%SUBST(ZOUT21:1:20)) + 'C '                          CRE015
     C                   ELSE                                                                 CRE015
     C                   EVALR     ArrScn(X).RWBALN =                                         CRE015
     C                             %TRIM(%SUBST(ZOUT21:1:20)) + 'D '                          CRE015
     C                   ENDIF                                                                CRE015
     C                   ELSE                                                                 CRE015
     C                   EVALR     ArrScn(X).RWBALN =                                         CRE015
     C                             %TRIM(%SUBST(ZOUT21:1:20)) + '  '                          CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** Move screen format DS array to buffer array                                          CRE015
                                                                                              CRE015
     C                   EVAL      ArrScnBuf(X) = ArrScn(X)                                   CRE015
                                                                                              CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
      ** Move array details to screen format data structure                                   CRE015
                                                                                              CRE015
     C                   MOVEA     ArrScnBuf     ScnPenaRows                                  CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRTVCG - Routine to retrieve and validate customer group
      *****************************************************************
     C*****SRRTVCG       BEGSR                                                  176842
      *
      ** ACCESS CUSTOMER GROUP IN SDCUSTPD
     C*******************CALL      'AOCUSTR0'                                   176842
     C*******************PARM      '*DBERR '     @RTCD                          176842
     C*******************PARM      '*KEY   '     @OPTN                          176842
     C*******************PARM      DDCUSN        @CNUM            10            176842
     C*******************PARM      *BLANKS       @CNST             7            176842
     C*****SDCUST        PARM      SDCUST        DSSDY                          176842
      *
     C*****@RTCD         IFEQ      *BLANKS                                      176842
     C*******************MOVE      BBCUST        DDCUSN                         176842
     C*******************ENDIF                                                  176842
      *
     C*****BBCGRP        IFEQ      *BLANKS                                      176842
     C*******************MOVEL     '1'           BBCGRP                         176842
     C*******************ENDIF                                                  176842
      *
      ** CHECK IF CUSTOMER GROUP IS OK
     C*******************Z-ADD     1             IDX1                           176842
     C*****BBCGRP        LOOKUP    GRP(Idx1)                              10    176842
      *
     C******IN10         IFNE      '1'                                          176842
     C******LOCK         IN        LDA                                          176842
     C*******************Z-ADD     2             DBASE                          176842
     C*******************MOVEL     'SDCUSTPD'    DBFILE                         176842
     C*******************MOVEL     DDCUSN        DBKEY                          176842
     C*******************OUT       LDA                                          176842
     C*******************SETON                                        U7U8LR    176842
     C*******************EXSR      *PSSR                                        176842
     C*******************ENDIF                                                  176842
      *
     C*******************ENDSR                                                  176842
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRTVCM - Routine to retrieve defaults for commissions
      *****************************************************************
     C*****SRRTVCM       BEGSR                                                  176842
      *
      ** Initialize/reset fields
     C*******************MOVEL     *BLANKS       DDCEXA1                        176842
     C*******************MOVEL     *BLANKS       DDCEXB1                        176842
     C*******************MOVEL     *BLANKS       DDCEXC1                        176842
     C*******************MOVEL     *BLANKS       DDCEXD1                        176842
     C*******************MOVEL     *BLANKS       DDCEXE1                        176842
     C*******************MOVEL     *BLANKS       DDCEXF1                        176842
     C*******************MOVEL     *BLANKS       DDCEXG1                        176842
      *
      ** Setup key
     C*******************MOVEL     *BLANKS       K1FLD1           12            176842
     C*******************MOVEL     *BLANKS       WU004A            4            176842
     C*******************MOVEL     DDCCY         WU004A                         176842
     C*******************MOVE      'D'           WU004A                         176842
     C*******************MOVE      WU004A        K1FLD1                         176842
      *
      ** Retrieve defaults
     C*****K1FLD1        CHAIN     RECCY                              99        176842
      *
     C******IN99         IFEQ      '0'                                          176842
      *
      ** A - Highest overdraft commission
     C*****AIN2(IDX1)    IFEQ      'Y'                                          176842
     C*******************MOVE      HORT          ZFLD15                         176842
     C*******************EVAL      ZDECS=8                                      176842
     C*******************EXSR      FMTAMT                                       176842
     C*******************EVAL      DDCEXA1= %SUBST(ZOUT21:10:12)                176842
     C*******************ENDIF                                                  176842
      *
      ** B - Turnover commission
     C*****AIN1(IDX1)    IFEQ      'Y'                                          176842
     C*******************MOVE      ACRT          ZFLD15                         176842
     C*******************EVAL      ZDECS=8                                      176842
     C*******************EXSR      FMTAMT                                       176842
     C*******************EVAL      DDCEXB1= %SUBST(ZOUT21:10:12)                176842
     C*******************ENDIF                                                  176842
      *
      ** C - Debit interest commission                                          176842
     C*****AIN3(IDX1)    IFEQ      'Y'                                          176842
     C*******************MOVE      DIRT          ZFLD15                         176842
     C*******************EVAL      ZDECS=8                                      176842
     C*******************EXSR      FMTAMT                                       176842
     C*******************EVAL      DDCEXC1= %SUBST(ZOUT21:10:12)                176842
     C*******************ENDIF                                                  176842
      *
      ** D - Inactive account commission
     C*****AIN4(IDX1)    IFEQ      'Y'                                          176842
     C*******************MOVE      INFC          ZFLD15                         176842
     C*******************EVAL      ZDECS=A6NBDP                                 176842
     C*******************EXSR      FMTAMT                                       176842
     C*******************EVAL      DDCEXD1= %SUBST(ZOUT21:13:9)                 176842
     C*******************ENDIF                                                  176842
      *
      ** E - Minimum CR balance commission
     C*****AIN5(IDX1)    IFEQ      'Y'                                          176842
      *
      ** Current or Savings?
     C*****AMSTYP        IFEQ      'S'                                          176842
     C*******************MOVE      MSFC          ZFLD15                         176842
     C*******************ELSE                                                   176842
     C*******************MOVE      MCFC          ZFLD15                         176842
     C*******************ENDIF                                                  176842
      *
     C*******************EVAL      ZDECS=A6NBDP                                 176842
     C*******************EXSR      FMTAMT                                       176842
     C*******************EVAL      DDCEXE1= %SUBST(ZOUT21:13:9)                 176842
     C*******************ENDIF                                                  176842
      *
      ** F - Extra daily statement commission                                   176842
     C*****AIN6(IDX1)    IFEQ      'Y'                                          176842
     C*****DDSTFQ        IFEQ      'E'                                          176842
     C*******************MOVE      DSFC          ZFLD15                         176842
     C*******************ELSE                                                   176842
     C*******************MOVE      *ZEROS        ZFLD15                         176842
     C*******************ENDIF                                                  176842
     C*******************EVAL      ZDECS=A6NBDP                                 176842
     C*******************EXSR      FMTAMT                                       176842
     C*******************EVAL      DDCEXF1= %SUBST(ZOUT21:13:9)                 176842
     C*******************ENDIF                                                  176842
      *
      ** G - Fixed commission                                                   176842
     C*****AIN7(IDX1)    IFEQ      'Y'                                          176842
     C*******************MOVE      FCFC          ZFLD15                         176842
     C*******************EVAL      ZDECS=A6NBDP                                 176842
     C*******************EXSR      FMTAMT                                       176842
     C*******************EVAL      DDCEXG1= %SUBST(ZOUT21:13:9)                 176842
     C*******************ENDIF                                                  176842
      *
     C*******************ENDIF                                                  176842
      *
     C*******************ENDSR                                                  176842
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM Midas no. to DDMMYY (OR MMDDYY)    *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    DAYNO             5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM      *ZEROS        ZADATE            7            Run-date in DDM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      ZFLD15 = *ZEROS
     C                   ENDSR
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  SRNxtFreq - Get Next Frequence Date                          *                       CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     SRNxtFreq     BEGSR                                                                CRE015
                                                                                              CRE015
     C                   CALL      'ZFRQB5'                                                   CRE015
     C                   PARM      'D'           ZFREQ             1                          CRE015
     C                   PARM                    ZDAYNO            5 0                        CRE015
     C                   PARM      *ZERO         ZMDAY             2 0                        CRE015
     C                   PARM      BJLCCY        ZCCY              3                          CRE015
     C                   PARM      *BLANKS       ZLOC              3                          CRE015
     C                   PARM      'F'           ZDIREC            1                          CRE015
     C                   PARM      *BLANKS       ZRTRN             7                          CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      * ZEDIT - Edit an unsigned field                                *                       CRE073
      *****************************************************************                       CRE073
     C     ZEDIT         BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   CALLB     'ZEDIT'                                                    CRE073
     C                   PARM                    ZFIELD                                       CRE073
     C                   PARM                    ZADEC                                        CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN ACCOUNT FORMAT)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        AccScnMast
     C                   MOVEL     *BLANK        AccScnDebi
     C                   MOVEL     *BLANK        AccScnCred
     C                   MOVEL     *BLANK        AccScnComm
     C                   MOVEL     *BLANK        AccScnOthe
     C                   MOVEL     *BLANK        AccScnPena                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_013                                                              CRE101
     C                   MOVEL     ##ACTN        DDACTN
      *
      ** Get the currency decimal places of accounting ccy
      *
     C                   IF        AMCCY <> '   '                                            243129
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      AMCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDIF                                                               243129
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     AMCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR                                        ************
     C                   END
                                                                                              CRE015
      ** Get account code extension for term and notice                                       CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                   MOVE      APAACOD       A5ACCD                                       CRE015
     C     A5ACCD        CHAIN     SDACD1L0                                                   CRE015
     C                   IF        NOT %FOUND(SDACD1L0)                                       CRE015
     C                   EVAL      A5ATTY = *BLANKS                                           CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
      *
      ** Key list to access Linked Accounts
      *
     C     RELINK        KLIST
     C                   KFLD                    AMBRCA
     C                   KFLD                    AMCNUM
     C                   KFLD                    AMCCY
     C                   KFLD                    AMACOD
     C                   KFLD                    AMACSQ
      *
      ** Key list to access Account by Branch
     C     ACLINK        KLIST
     C                   KFLD                    AMLTAB
     C                   KFLD                    LTCUST
     C                   KFLD                    LTCCY
     C                   KFLD                    AMLTAC
     C                   KFLD                    AMLTAS
     C                   MOVE      AMLTAB        WWLTAB
     C                   Z-ADD     AMLTAC        WWLTAC
     C                   Z-ADD     AMLTAS        WWLTAS
      *
      ** Key list to access RESTCHPD
     C     RESKEY        KLIST
     C                   KFLD                    AMCCY
     C                   KFLD                    AMSTFQ
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Account in file formats
     C                   PARM                    AccnFilFmt
     C                   PARM                    ExBXFilFmt
     C                   PARM                    ExRIFilFmt
     C                   PARM                    ExCOFilFmt
     C                   PARM                    ExPWFilFmt
     C                   PARM                    ExPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_014                                                              CRE101
      *
      * Commissions
     C                   PARM                    CommDisp          1
      * CCRM Revenue Analysis                                                   CDE002
     C                   PARM                    CDE002            1            CDE002
      *                                                                         CDE002
      * Retail Details
     C                   PARM                    R_FACH            1
     C                   PARM                    R_TSTMC           1
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPDR            8                        MD054028
     C                   PARM                    DDAPCR            8                        MD054028
      *
      * Output parameters
      *
      * Account in screen format
     C                   PARM                    AccScnMast
     C                   PARM                    AccScnDebi
     C                   PARM                    AccScnCred
     C                   PARM                    AccScnComm
     C                   PARM                    AccScnOthe
     C                   PARM                    AccScnPena                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_015                                                              CRE101
      *
      * Screen 1 Output
     C                   PARM                    DDDACC            6
     C**********         PARM                    DDLINK           18                          CGL029
     C                   PARM                    DDLINK           24                          CGL029
     C                   PARM                    DDFAMT            8
      *
      * Screen 2 Output
     C                   PARM                    DODRCD            6
     C                   PARM                    DDPOLC            6
     C                   PARM                    DDPOLE            6
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
     C                   PARM                    DDDRMG1          12            CDE002
     C                   PARM                    DDCRMG1          12            CDE002
      *
      ** Initialize program name
      *
     C                   MOVEL     'GLAMADCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ***Access*RETAIL account details                                                        208921
      **********                                                                              208921
     C**********         CALL      'AORETLR0'                                                 208921
     C**********         PARM      *BLANKS       @RTCD                                        208921
     C**********         PARM      '*FIRST  '    @OPTN                                        208921
     C*****SDRETL        PARM      SDRETL        DSSDY                                        208921
      **********                                                                              208921
      **DATABASE ERROR                                                                        208921
      **********                                                                              208921
     C*****@RTCD         IFNE      *BLANK                                                     208921
     C**********         MOVEL     @OPTN         DBKEY                          ************  208921
     C**********         MOVEL     'SDRETLPD'    DBFILE                         * DBERR 902*  208921
     C**********         MOVEL     '902'         DBASE                          ************  208921
     C**********         EXSR      *PSSR                                                      208921
     C**********         END                                                                  208921
      *
      ** ACCESS MIDAS MODULES
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** Access RETAIL account details                                                        208921
      *                                                                                       208921
     C     BGRTBN        IFEQ      'Y'                                                        208921
     C                   CALL      'AORETLR0'                                                 208921
     C                   PARM      *BLANKS       @RTCD                                        208921
     C                   PARM      '*FIRST  '    @OPTN                                        208921
     C     SDRETL        PARM      SDRETL        DSSDY                                        208921
      *                                                                                       208921
      * DATABASE ERROR                                                                        208921
      *                                                                                       208921
     C     @RTCD         IFNE      *BLANK                                                     208921
     C                   MOVEL     @OPTN         DBKEY                          ************  208921
     C                   MOVEL     'SDRETLPD'    DBFILE                         * DBERR 902*  208921
     C                   MOVEL     '902'         DBASE                          ************  208921
     C                   EXSR      *PSSR                                                      208921
     C                   END                                                                  208921
     C                   ENDIF                                                                208921
      *                                                                                       208921
      ** ACCESS PORTFOLIO MANAGEMNT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
                                                                                              CLE025
      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBKEY = 'CLE025'                                           CLE025
     C                   EVAL      DBASE = 905                                                CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CRE015
      ** Check if enhancement CRE015 (Term and Notice Accounts) is on                         CRE015
                                                                                              CRE015
     C                   CALLB     'AOSARDR0'                                                 CRE015
     C                   PARM      *BLANKS       PRTCD                                        CRE015
     C                   PARM      '*VERIFY'     POPTN                                        CRE015
     C                   PARM      'CRE015'      PSARD                                        CRE015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE015
                                                                                              CRE015
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CRE015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE015
     C                   EVAL      DBKEY = 'CRE015'                                           CRE015
     C                   EVAL      DBASE = 906                                                CRE015
     C                   EXSR      *PSSR                                                      CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   IF        PRTCD = *BLANKS                                            CRE015
     C                   EVAL      CRE015 = 'Y'                                               CRE015
     C                   ELSE                                                                 CRE015
     C                   EVAL      CRE015 = 'N'                                               CRE015
     C                   ENDIF                                                                CRE015
      *
     C/COPY OFCPYSRCZ,CRE101_016                                                              CRE101
      ** READ UP TO EIGHT GROUP RECORDS AND STORE RELEVANT DETAILS
      ** IN INTERNAL ARRAYS
      *
     C                   Z-ADD     0             IDX1
     C                   Move      *Off          *IN10
     C     1             SETLL     TABLEV4F
      *
     C     *IN10         DOUEQ     *On
     C                   READ      TABLEV4F                               10
     C     *IN10         IFEQ      *Off
     C                   ADD       1             Idx1
     C                   MOVE      CGRP          GRP(Idx1)
     C                   MOVE      ACMI          AIN1(Idx1)
     C                   MOVE      MDBI          AIN2(Idx1)
     C                   MOVE      DINI          AIN3(Idx1)
     C                   MOVE      INAI          AIN4(Idx1)
     C                   MOVE      MINI          AIN5(Idx1)
     C                   MOVE      DYSI          AIN6(Idx1)
     C                   MOVE      FIXI          AIN7(Idx1)
      *
      ** ONLY EIGHT CUSTOMER GROUP ARE POSSIBLE
      *
     C     Idx1          IFEQ      8
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *                                                                                       CER047
      ** Check if enhancement CER047 is on                                                    CER047
      *                                                                                       CER047
     C                   CALLB     'AOSARDR0'                                                 CER047
     C                   PARM      *BLANKS       PRTCD                                        CER047
     C                   PARM      '*VERIFY'     POPTN                                        CER047
     C                   PARM      'CER047'      PSARD                                        CER047
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER047
                                                                                              CER047
     C                   IF        PRTCD = *BLANKS                                            CER047
     C                   EVAL      CER047 = 'Y'                                               CER047
     C                   ELSE                                                                 CER047
     C                   EVAL      CER047 = 'N'                                               CER047
     C                   ENDIF                                                                CER047
                                                                                              CER047
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER047
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER047
     C                   EVAL      DBKEY = 'CER047'                                           CER047
     C                   EVAL      DBASE = 906                                                CER047
     C                   EXSR      *PSSR                                                      CER047
     C                   ENDIF                                                                CER047
                                                                                              CER047
      *                                                                                       CRE075
      ** Check if enhancement CRE075 is ON                                                    CRE075
      *                                                                                       CRE075
     C                   CALLB     'AOSARDR0'                                                 CRE075
     C                   PARM      *BLANKS       PRTCD                                        CRE075
     C                   PARM      '*VERIFY'     POPTN                                        CRE075
     C                   PARM      'CRE075'      PSARD                                        CRE075
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE075
                                                                                              CRE075
     C                   IF        PRTCD = *BLANKS                                            CRE075
     C                   EVAL      CRE075 = 'Y'                                               CRE075
     C                   ELSE                                                                 CRE075
     C                   EVAL      CRE075 = 'N'                                               CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CRE075
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE075
     C                   EVAL      DBKEY = 'CRE075'                                           CRE075
     C                   EVAL      DBASE = 907                                                CRE075
     C                   EXSR      *PSSR                                                      CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
      *                                                                                       CER055
      ** Check if enhancement CER055 is ON                                                    CER055
      *                                                                                       CER055
     C                   CALLB     'AOSARDR0'                                                 CER055
     C                   PARM      *BLANKS       PRTCD                                        CER055
     C                   PARM      '*VERIFY'     POPTN                                        CER055
     C                   PARM      'CER055'      PSARD                                        CER055
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER055
      *                                                                                       CER055
     C                   IF        PRTCD = *BLANKS                                            CER055
     C                   EVAL      CER055 = 'Y'                                               CER055
     C                   ELSE                                                                 CER055
     C                   EVAL      CER055 = 'N'                                               CER055
     C                   ENDIF                                                                CER055
      *                                                                                       CER055
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER055
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER055
     C                   EVAL      DBKEY = 'CER055'                                           CER055
     C                   EVAL      DBASE = 908                                                CER055
     C                   EXSR      *PSSR                                                      CER055
     C                   ENDIF                                                                CER055
                                                                                              CER055
      ** Check if enhancement CRE073 is ON                                                    CRE073
      *                                                                                       CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY'     POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CRE073
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
     C                   EVAL      DBASE = 909                                                CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CGL165
     C                   CALLB     'AOSARDR0'                                                 CGL165
     C                   PARM      *BLANKS       PRTCD                                        CGL165
     C                   PARM      '*VERIFY'     POPTN                                        CGL165
     C                   PARM      'CGL165'      PSARD                                        CGL165
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL165
                                                                                              CGL165
     C                   IF        PRTCD = *BLANKS                                            CGL165
     C                   EVAL      CGL165 = 'Y'                                               CGL165
     C                   ELSE                                                                 CGL165
     C                   EVAL      CGL165 = 'N'                                               CGL165
     C                   ENDIF                                                                CGL165
      *
      ** Check if enhancement CRE073 is ON                                                  MD034725
      *                                                                                     MD034725
     C                   CALLB     'AOSARDR0'                                               MD034725
     C                   PARM      *BLANKS       PRTCD                                      MD034725
     C                   PARM      '*VERIFY'     POPTN                                      MD034725
     C                   PARM      'CTI006'      PSARD                                      MD034725
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD034725
                                                                                            MD034725
     C                   IF        PRTCD = *BLANKS                                          MD034725
     C                   EVAL      CTI006 = 'Y'                                             MD034725
     C                   ELSE                                                               MD034725
     C                   EVAL      CTI006 = 'N'                                             MD034725
     C                   ENDIF                                                              MD034725
                                                                                            MD034725
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                MD034725
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD034725
     C                   EVAL      DBKEY = 'CTI006'                                         MD034725
     C                   EVAL      DBASE = 910                                              MD034725
     C                   EXSR      *PSSR                                                    MD034725
     C                   ENDIF                                                              MD034725
                                                                                              CER050
     C                   CALLB     'AOSARDR0'                                                 CER050
     C                   PARM      *BLANKS       PRTCD                                        CER050
     C                   PARM      '*VERIFY'     POPTN                                        CER050
     C                   PARM      'CER050'      PSARD                                        CER050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER050
                                                                                              CER050
     C                   IF        PRTCD = *BLANKS                                            CER050
     C                   EVAL      CER050 = 'Y'                                               CER050
     C                   ELSE                                                                 CER050
     C                   EVAL      CER050 = 'N'                                               CER050
     C                   ENDIF                                                                CER050
      *
     C                   IN        SDSTAT                                                     CSD101
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
