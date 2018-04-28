     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Fiduciary takings update module')             *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMFIDTUPF - MM Fiduciary Takings Update Module               *
      *                                                               *
      *  Function:  This program is called by MM0089 when feature     *
      *             CDL006 is activated to allow update of database DL*
      *                                                               *
      *  Called By: MM0089  - LDN Inputs                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CMM105             Date 22Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006 *Create     Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMFIDTUPC1                       *
      *           Core hooks added:MMFIDTUPD1                         *
      *  CLE025 - Credit Lines                                        *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  209905 - Fiduciary API Enhancement                           *
      *  CDL006 - Dealing Fiduciary                                   *
      *                                                               *
      *****************************************************************
     FMMDELDL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDELDP0:SW8LINJ)
     FMMWFIDDL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMWFIDDD0:SW8OUTP)
     F                                     COMMIT
     FMMDELDPP  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FSDCCGRL0  IF   E           K DISK    INFSR(*PSSR)
     FDLCCGDL0  IF   E           K DISK    INFSR(*PSSR)
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     FCADENQLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(FXDEALP0)
     F                                     IGNORE(ABDEALP0)
     F                                     IGNORE(ABDEALP1)
     F                                     RENAME(MMDELDP0:CADELDP0)
     F                                     PREFIX(CA)
     FMMVFIDTL0 UF   E           K DISK    INFSR(*PSSR)                                       209905
     F                                     RENAME(MMVFIDTD0:MMVFIDT)                          209905
     FAPVLOGL1  IF   E           K DISK    INFSR(*PSSR)                                       209905
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
                                                                                              209905
     D*WFIDTARR1       S             42A   DIM(99)                                     209905 CGL029
     D WFIDTARR1       S             48A   DIM(99)                                            CGL029
                                                                                              209905
     D*WFIDTARR2       S             42A   DIM(99)                                     209905 CGL029
     D WFIDTARR2       S             48A   DIM(99)                                            CGL029
                                                                                              209905
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     209905
      ** 24X7 status dataarea                                                                 209905
                                                                                              209905
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     209905
      ** SD data area                                                                         209905
                                                                                              209905
     D MMFIDTScn     E DS                  EXTNAME(MMFIDTPD)                                  209905
      ** Fiduciary screen details                                                             209905
                                                                                              209905
     D HeadIn        E DS                  EXTNAME(APHEADPD)                                  209905
      ** Header details                                                                       209905
                                                                                              209905
     D PAYFilFmt     E DS                  EXTNAME(SDESFPPD)                                  209905
      ** Midas SD File Extended Settlement Instruction - Pay                                  209905
                                                                                              209905
     D PAYScnFmt     E DS                  EXTNAME(SDESSPPD)                                  209905
      ** Midas SD Screen Extended Settlement Instruction - Pay                                209905
                                                                                              209905
     D RECFilFmt     E DS                  EXTNAME(SDESFRPD)                                  209905
      ** Midas SD File Extended Settlement Instruction - Receive                              209905
                                                                                              209905
     D RECScnFmt     E DS                  EXTNAME(SDESSRPD)                                  209905
      ** Midas SD Screen Extended Settlement Instruction - Receive                            209905
                                                                                              209905
     D FRIRFilFmt    E DS                  EXTNAME(SDESFFPD)                                  209905
      ** Midas SD File Extended Settlement Instruction - FRA/IRS                              209905
                                                                                              209905
     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)                                  209905
      ** Midas SD Screen Extended Settlement Instruction - FRA/IRS                            209905
                                                                                              209905
     D InfData       E DS                  EXTNAME(MMLDIFPD)                                  209905
      ** Midas MM LDNI Interface Data Format Definition Layout                                209905
                                                                                              209905
     D ExtData       E DS                  EXTNAME(MMLDEXPD)                                  209905
      ** Midas MM LDNI Extra Data Layout File                                                 209905
 
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D MMDEL         E DS                  EXTNAME(MMDELDPP)
     D MMDELRONS     E                     EXTFLD(QQRONS)                                     CGL029
     D @SLDS         E DS                  EXTNAME(MMWFIDDPD)
     D SLDSDORI      E                     EXTFLD(QQDORI)                                     CGL029
     D SLDSMORI      E                     EXTFLD(QQMORI)                                     CGL029
     D SLDSDOPI      E                     EXTFLD(QQDOPI)                                     CGL029
     D SLDSMOPI      E                     EXTFLD(QQMOPI)                                     CGL029
     D SLDSRONS      E                     EXTFLD(QQRONS)                                     CGL029
     D SLDSPONS      E                     EXTFLD(QQPONS)                                     CGL029
     D SLDSINSA      E                     EXTFLD(QQINSA)                                     CGL029
      **  Data structure of the standard deal, Loans/Deposits format.
     D @SBDS         E DS                  EXTNAME(MMSTDBPP)
     D SBDSDORI      E                     EXTFLD(QQDORI)                                     CGL029
     D SBDSMORI      E                     EXTFLD(QQMORI)                                     CGL029
     D SBDSDOPI      E                     EXTFLD(QQDOPI)                                     CGL029
     D SBDSMOPI      E                     EXTFLD(QQMOPI)                                     CGL029
     D SBDSRONS      E                     EXTFLD(QQRONS)                                     CGL029
     D SBDSPONS      E                     EXTFLD(QQPONS)                                     CGL029
      **  Data structure of the standard deal, NA's bought format.
     D @SSDS         E DS                  EXTNAME(MMSTDSPP)
     D SSDSDORI      E                     EXTFLD(QQDORI)                                     CGL029
     D SSDSMORI      E                     EXTFLD(QQMORI)                                     CGL029
     D SSDSBORI      E                     EXTFLD(QQBORI)                                     CGL029
     D SSDSBOPI      E                     EXTFLD(QQBOPI)                                     CGL029
     D SSDSRORI      E                     EXTFLD(QQRORI)                                     CGL029
     D SSDSROPI      E                     EXTFLD(QQROPI)                                     CGL029
     D SSDSRONS      E                     EXTFLD(QQRONS)                                     CGL029
     D SSDSPONS      E                     EXTFLD(QQPONS)                                     CGL029
      **  Data structure of the standard deal, NA's sold format.
     D @SADS         E DS                  EXTNAME(MMSTDAPP)
     D SADSDORI      E                     EXTFLD(QQDORI)                                     CGL029
     D SADSMORI      E                     EXTFLD(QQMORI)                                     CGL029
     D SADSDOPI      E                     EXTFLD(QQDOPI)                                     CGL029
     D SADSMOPI      E                     EXTFLD(QQMOPI)                                     CGL029
     D SADSBORI      E                     EXTFLD(QQBORI)                                     CGL029
     D SADSBOPI      E                     EXTFLD(QQBOPI)                                     CGL029
     D SADSRORI      E                     EXTFLD(QQRORI)                                     CGL029
     D SADSROPI      E                     EXTFLD(QQROPI)                                     CGL029
     D SADSRONS      E                     EXTFLD(QQRONS)                                     CGL029
     D SADSPONS      E                     EXTFLD(QQPONS)                                     CGL029
      **  Data structure of the standard deal, Deams format.
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Bank details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  Currency Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  Customer Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              209905
     D WFIDTDS         DS                                                                     209905
     D  WFDLNO                 1      6                                                       209905
     D  WFCNUM                 7     16                                                       209905
     D  WFPTFR                17     20                                                       209905
     D  WFAMNT                21     35                                                       209905
     D**WFACOD                36     39                                                209905 CGL029
     D**WFACSQ                40     41                                                209905 CGL029
     D**WFTRAS                42     42                                                209905 CGL029
     D  WFACOD                36     45                                                       CGL029
     D  WFACSQ                46     47                                                       CGL029
     D  WFTRAS                48     48                                                       CGL029
                                                                                              209905
     D WACCNT          DS                                                                     209905
     D  WCUST                  1      6                                                       209905
     D**WACOD                  7     10                                                209905 CGL029
     D**WACSQ                 11     12                                                209905 CGL029
     D  WACOD                  7     16                                                       CGL029
     D  WACSQ                 17     18                                                       CGL029
                                                                                              209905
      **  Dealing Details
     D @DFMT           DS
      **  Data structure to format separate dates into a 8N number
     D  @YEAR                  1      4  0
     D  @MNTH                  5      6  0
     D  @DAY                   7      8  0
     D  @DATE                  1      8  0
     D                 DS             6
      **  Data structure to change format to MMDDYY/DDMMYY
     D  @@DTOU                 1      6  0
     D  @@DAT1                 1      2  0
     D  @@DAT2                 3      4  0
     D  @@YYY                  5      6  0
     D                 DS
      **  Data structure for date in, to change format.
     D  @@DTIN                 1      8  0
     D  @@YY                   3      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
     D                 DS
     D  ZRA                    1    112P 0
     D                                     DIM(14)
     D  FDSTU1                 1      8P 0
     D  FDSTU2                 9     16P 0
     D  FDSTU3                17     24P 0
     D  FDSTU4                25     32P 0
     D  FDSTU5                33     40P 0
     D  FDSTU6                41     48P 0
     D  FDSTU7                49     56P 0
     D  FDSTU8                57     64P 0
     D  FDSTU9                65     72P 0
     D  FDST10                73     80P 0
     D  FDST11                81     88P 0
     D  FDST12                89     96P 0
     D  FDST13                97    104P 0
     D  FDST14               105    112P 0
     D                 DS
     D  ZFL                    1    120P 0
     D                                     DIM(15)
     D  FDFC01                 1      8P 0
     D  FDFC02                 9     16P 0
     D  FDFC03                17     24P 0
     D  FDFC04                25     32P 0
     D  FDFC05                33     40P 0
     D  FDFC06                41     48P 0
     D  FDFC07                49     56P 0
     D  FDFC08                57     64P 0
     D  FDFC09                65     72P 0
     D  FDFC10                73     80P 0
     D  FDFC11                81     88P 0
     D  FDFC12                89     96P 0
     D  FDFC13                97    104P 0
     D  FDFC14               105    112P 0
     D  FDFC15               113    120P 0
                                                                                              CDL033
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL033
      ** File - Payment Further Settlement Instructions                                       CDL033
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL033
      ** File - Receive Further Settlement Instructions                                       CDL033
                                                                                              CDL033
     D PAFRCD          S            100A                                                      CDL033
     D PBFRCD          S            100A                                                      CDL033
                                                                                              209905
     D  PAsocID        S             20A                                                      209905
     D  CSC011         S              1A   INZ('N')                                           209905
     D  TRANSDTL       S           5800A                                                      209905
     D**PDealNum       S             18A                                               209905 CGL029
     D**PADealNo       S             18A                                               209905 CGL029
     D  PDealNum       S             24A                                                      CGL029
     D  PADealNo       S             24A                                                      CGL029
     D  PRTCD          S              7A                                                      209905
     D  POPTN          S              7A                                                      209905
     D  PCCY           S              3A                                                      209905
     D  PSARD          S              6A                                                      209905
     D  WVLOG          S              1A                                                      209905
     D  W@DN38         S              6A                                                      209905
     D  X              S              3P 0                                                    209905
     D  WFNAR1         S             60A                                                      209905
     D  WFNAR2         S             60A                                                      209905
     D  WFNAR3         S             60A                                                      209905
     D  WFNAR4         S             60A                                                      209905
     D  KFRNT          S             20A                                                      209905
     D  KTRAN          S              8A                                                      209905
     D  WMSGTYPE       S              6A                                                      209905
     D  WFRONT1        S             20A                                                      209905
     D  WFRONT2        S             20A                                                      209905
     D  CTR            S              3P 0                                                    209905
                                                                                              209905
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Timestamp for the transaction                                                        209905
     D TimeStamp       S             26A                                                      209905
     C/COPY WNCPYSRC,MMFIDTUPD1
                                                                                              209905
      *****************************************************************
      *                                                               *
      *    Main Routine                                               *
      *                                                               *
      *****************************************************************
 
     C                   EXSR      #INIT
 
     C                   EXSR      #MAIN
 
     C                   EXSR      #TERM
 
      *****************************************************************
      *                                                               *
      *  SR/#INIT : Initial Processing                                *
      *                                                               *
      *  Called by   : Main Routine                                   *
      *                                                               *
      *  Calls       : *PSSR                                          *
      *                                                               *
      *****************************************************************
 
     C     #INIT         BEGSR
 
      ** Entry List
 
     C     *ENTRY        PLIST
     C                   PARM                    #PGM             10
     C                   PARM                    @@MODE            1
     C                   PARM                    @@DN38            6 0
     C                   PARM                    @@LNKN            6 0
     C                   PARM                    PAsocID                                      209905
     C                   PARM                    @@RTCD            7
 
      ** Define KLIST to access DLCCGDL0
 
     C     WWDLCC        KLIST
     C                   KFLD                    WWCCY             3
     C                   KFLD                    FDCCOM
 
      ** Access to Deal ICD file to retrieve Placing and Taking range
 
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @@RTCD
     C                   PARM      '*FIRST '     @@OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C     @@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   Z-ADD     001           DBASE                          ****************
     C                   MOVEL     'SDDEALPD'    DBFILE                         * DB ERROR 001 *
     C                   MOVEL     '*FIRST'      DBKEY                          ****************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @@RTCD
     C                   PARM      '*FIRST '     @@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   Z-ADD     002           DBASE                          ****************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERROR 002 *
     C                   MOVEL     '*FIRST'      DBKEY                          ****************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set indicator *IN98 to indicate which date format to use
 
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
                                                                                              209905
      ** Check if CDL006 is installed                                                         209905
                                                                                              209905
     C                   CALL      'AOSARDR0'                                                 209905
     C                   PARM      *BLANKS       PRTCD                                        209905
     C                   PARM      '*VERIFY'     POPTN                                        209905
     C                   PARM      'CSC011'      PSARD                                        209905
     C     SCSARD        PARM      SCSARD        DSFDY                                        209905
                                                                                              209905
     C                   IF        PRTCD = *BLANKS                                            209905
     C                   EVAL      CSC011 = 'Y'                                               209905
     C                   IN        SC24X7                                                     209905
     C                   ELSE                                                                 209905
     C                   EVAL      CSC011 = 'N'                                               209905
                                                                                              209905
     C                   IF        PRTCD <> '*NRF'                                            209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBKEY = 'CSC011'                                           209905
     C                   EVAL      DBFILE = 'SCSARDPD'                                        209905
     C                   EVAL      DBASE = 6                                                  209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IN        SDSTAT                                                     209905
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
     C                   EVAL      DBASE = 7                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
 
     C/COPY WNCPYSRC,MMFIDTUPC2
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SR/#MAIN : Main Processing                                   *
      *                                                               *
      *  Called by   : Main Routine                                   *
      *                                                               *
      *  Calls       : #DELET, #INSRT                                 *
      *                                                               *
      *****************************************************************
 
     C     #MAIN         BEGSR
 
      ** Initialize work field used to save deal number of first taking.
 
     C                   MOVE      *BLANK        WUFDEA            1
 
      ** Setup exit parameters WUFDNO (first deal number) and WULDNO
      ** (last deal number) with zeros.
 
     C                   Z-ADD     *ZEROS        WUFDNO
     C                   Z-ADD     *ZEROS        WULDNO
 
      ** Check if delete or insert
 
     C     @@MODE        IFEQ      'D'
     C                   EXSR      #DELET
     C                   ELSE
     C                   EXSR      #INSRT
     C                   ENDIF
 
      **  Setup entry parameters @@LNKN and @@DN38 with values of first
      **  deal number and last deal number.
 
     C                   Z-ADD     WUFDNO        @@LNKN
     C                   Z-ADD     WULDNO        @@DN38
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SR/#INSRT : Insert Processing                                *
      *                                                               *
      *  Called by   : #MAIN                                          *
      *                                                               *
      *  Calls       : #UPDAT                                         *
      *                                                               *
      *****************************************************************
 
     C     #INSRT        BEGSR
 
      ** Access details of the associated placing deal
 
     C     @@DN38        CHAIN     CADENQLL                           89
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   Z-ADD     3             DBASE                          ****************
     C                   MOVEL     'CADENQLL'    DBFILE                         * DB ERROR 001 *
     C                   MOVEL     @@DN38        DBKEY                          ****************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              209905
      ** Get Currency Decimal Places                                                          209905
                                                                                              209905
     C                   CALLB     'AOCURRR0'                                                 209905
     C                   PARM      *BLANKS       PRTCD                                        209905
     C                   PARM      '*KEY   '     POPTN                                        209905
     C                   PARM      CAHKCCY       PCCY                                         209905
     C     SDCURR        PARM      SDCURR        DSSDY                                        209905
                                                                                              209905
     C     PRTCD         IFNE      *BLANK                                                     209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBASE = 5                                                  209905
     C                   EVAL      DBFILE = 'SDCURRPD'                                        209905
     C                   EVAL      DBKEY = PCCY                                               209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
 
      ** Read first record with link reference from @SLDS
 
      ** When program name is MMLDNIUPC read from MMVFIDTPD else read from MMWFIDDPD          209905
                                                                                              209905
     C                   MOVEL     @@DN38        W@DN38                                       209905
                                                                                              209905
     C                   IF        #PGM = 'MMLDNIUPC'                                         209905
                                                                                              209905
     C     PAsocID       SETLL     MMVFIDTL0                                                  209905
     C     PAsocID       READE     MMVFIDTL0                              90                  209905
     C                   EVAL      KFRNT = *BLANK                                             209905
     C                   EVAL      KFRNT = PAsocID                                            209905
                                                                                              209905
     C                   ELSE                                                                 209905
                                                                                              209905
     C     @@DN38        SETLL     MMWFIDDL1
     C     @@DN38        READE     MMWFIDDL1                              90
     C                   EVAL      KFRNT = *BLANK                                             209905
     C                   EVAL      KFRNT = 'MD' + W@DN38                                      209905
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Check for the reference deal number if existing                                      209905
                                                                                              209905
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         209905
                                                                                              209905
     C     KVLOG         KLIST                                                                209905
     C                   KFLD                    KTRAN                                        209905
     C                   KFLD                    KFRNT                                        209905
                                                                                              209905
     C                   EVAL      KTRAN = 'MMLDNI'                                           209905
                                                                                              209905
     C     KVLOG         CHAIN     APVLOGL1                           30                      209905
                                                                                              209905
     C                   IF        *IN30 = *OFF                                               209905
     C                   EVAL      WVLOG = 'Y'                                                209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   EVAL      X = 1                                                      209905
     C                   EVAL      CTR = 1                                                    209905
     C                   EVAL      WFRONT1 = *BLANK                                           209905
     C                   EVAL      WFRONT2 = *BLANK                                           209905
     C                   ENDIF                                                                209905
 
     C     *IN90         DOWEQ     *OFF
     C                   EXSR      #UPDAT
                                                                                              209905
      ** If 24x7 Midas Availability is installed, write to the standard                       209905
      ** log file when support system is active                                               209905
                                                                                              209905
     C                   IF        WVLOG = 'Y'                                                209905
     C                   MOVEL     IKDORI        WACCNT                                       209905
     C                   MOVEL     IKDN38        WFDLNO                                       209905
     C                   MOVEL     IKCNUM        WFCNUM                                       209905
     C                   MOVEL     WACOD         WFACOD                                       209905
     C                   MOVEL     WACSQ         WFACSQ                                       209905
     C                   MOVEL     IKFTST        WFTRAS                                       209905
                                                                                              209905
     C                   IF        IKAMNP < 0                                                 209905
     C                   Z-SUB     IKAMNP        ZFLD15                                       209905
     C                   ELSE                                                                 209905
     C                   Z-ADD     IKAMNP        ZFLD15                                       209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   EXSR      SRFMTAM                                                    209905
     C                   MOVE      ZOUT21        WFAMNT                                       209905
                                                                                              209905
     C                   IF        CTR <= 88                                                  209905
     C                   EVAL      WFIDTARR1(X) = WFIDTDS                                     209905
     C                   IF        WFRONT1 = *BLANK                                           209905
     C                   EVAL      WFRONT1 = IKFRNT                                           209905
     C                   ENDIF                                                                209905
     C                   ELSE                                                                 209905
     C                   EVAL      WFIDTARR2(X) = WFIDTDS                                     209905
     C                   IF        WFRONT2 = *BLANK                                           209905
     C                   EVAL      WFRONT2 = IKFRNT                                           209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IF        (CAHKTYPE = 'LP') AND (X = 1) OR                           209905
     C                             (CAHKTYPE = 'DP') AND (X = 1)                              209905
     C                   MOVEL     IKFRN1        WFNAR1                                       209905
     C                   MOVEL     IKFRN2        WFNAR2                                       209905
     C                   MOVEL     IKFRN3        WFNAR3                                       209905
     C                   MOVEL     IKFRN4        WFNAR4                                       209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   EVAL      CTR = CTR + 1                                              209905
                                                                                              209905
     C                   IF        (CAHKTYPE = 'FL') AND (X = 88)                             209905
     C                   EVAL      X = 1                                                      209905
     C                   ELSE                                                                 209905
     C                   EVAL      X = X + 1                                                  209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
                                                                                              209905
                                                                                              209905
      ** When program name is MMLDNIUPC read MMVFIDTPD else read from MMWFIDDPD               209905
                                                                                              209905
     C                   IF        #PGM = 'MMLDNIUPC'                                         209905
                                                                                              209905
     C     PAsocID       READE     MMVFIDTL0                              90                  209905
                                                                                              209905
     C                   ELSE                                                                 209905
                                                                                              209905
     C     @@DN38        READE     MMWFIDDL1                              90
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDDO
                                                                                              209905
     C                   IF        WVLOG = 'Y'                                                209905
     C                   EXSR      SRLOGTRAN                                                  209905
     C                   ENDIF                                                                209905
 
     C                   ENDSR
                                                                                              209905
      *****************************************************************                       209905
      *                                                               *                       209905
      *  SRFMTAM - Format Amount                                      *                       209905
      *                                                               *                       209905
      *****************************************************************                       209905
                                                                                              209905
     C     SRFMTAM       BEGSR                                                                209905
                                                                                              209905
     C                   CALLB     'ZSEDIT'                                                   209905
     C                   PARM                    ZFLD15           15 0                        209905
     C                   PARM      A6NBDP        ZDECS             1 0                        209905
     C                   PARM      *BLANK        ZECODE            1                          209905
     C                   PARM                    ZOUT21           21                          209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
      *****************************************************************                       209905
      *                                                               *                       209905
      *  SRLOGTRAN - Log Valid Transaction to Log File                *                       209905
      *                                                               *                       209905
      *****************************************************************                       209905
                                                                                              209905
     C     SRLOGTRAN     BEGSR                                                                209905
                                                                                              209905
      ** Log Fiduciary Transaction                                                            209905
                                                                                              209905
     C                   EVAL      WMSGTYPE = 'MMFIDT'                                        209905
     C                   EVAL      APRPRLOCN = IKREPA                                         209905
     C                   EVAL      APFOTRANID = WFRONT1                                       209905
     C                   EVAL      APFOASOCID = KFRNT                                         209905
     C                   EVAL      PADealNo = *BLANKS                                         209905
     C                   EVAL      PDealNum = W@DN38 + 'FIDT1'                                209905
                                                                                              209905
     C                   EVAL      MMFIDTScn = *BLANK                                         209905
     C                   MOVEA     WFIDTARR1     MMFIDTScn                                    209905
     C                   EVAL      SFNARR01 = WFNAR1                                          209905
     C                   EVAL      SFNARR02 = WFNAR2                                          209905
     C                   EVAL      SFNARR03 = WFNAR3                                          209905
     C                   EVAL      SFNARR04 = WFNAR4                                          209905
     C                   EVAL      TRANSDTL = MMFIDTScn                                       209905
                                                                                              209905
     C                   EXSR      SRAPLOG                                                    209905
                                                                                              209905
     C                   IF        WFIDTARR2(1) <> *BLANK                                     209905
     C                   EVAL      APFOTRANID = WFRONT2                                       209905
     C                   EVAL      PDealNum = W@DN38 + 'FIDT2'                                209905
     C                   EVAL      MMFIDTScn = *BLANK                                         209905
     C                   MOVEA     WFIDTARR2     MMFIDTScn                                    209905
     C                   EVAL      SFNARR01 = *BLANK                                          209905
     C                   EVAL      SFNARR02 = *BLANK                                          209905
     C                   EVAL      SFNARR03 = *BLANK                                          209905
     C                   EVAL      SFNARR04 = *BLANK                                          209905
     C                   EVAL      TRANSDTL = MMFIDTScn                                       209905
                                                                                              209905
     C                   EXSR      SRAPLOG                                                    209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Log Trailer Transaction                                                              209905
                                                                                              209905
     C                   EVAL      APFOTRANID = *BLANK                                        209905
     C                   EVAL      PDealNum = W@DN38 + 'FITR'                                 209905
     C                   EVAL      WMSGTYPE = 'MMFITR'                                        209905
     C                   EXSR      SRSETD                                                     209905
     C                   EVAL      TRANSDTL =  RecScnFmt                                      209905
     C                                         + PayScnFmt                                    209905
     C                                         + InfData                                      209905
     C                                         + ExtData                                      209905
     C                   EXSR      SRAPLOG                                                    209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
      *****************************************************************                       209905
      /EJECT                                                                                  209905
      *****************************************************************                       209905
      *                                                               *                       209905
      * SRAPLOG - Calls APLOGTRAN to log the transaction              *                       209905
      *                                                               *                       209905
      *****************************************************************                       209905
                                                                                              209905
     C     SRAPLOG       BEGSR                                                                209905
                                                                                              209905
      ** If support system is active, write invalid transaction to                            209905
      ** log file via APLOGTRAN standard module                                               209905
                                                                                              209905
     C                   EVAL      APTGTTYPE = WMSGTYPE                                       209905
                                                                                              209905
     C                   CALLB     'APLOGTRAN'                                                209905
     C                   PARM      *BLANKS       RetCodeOut                                   209905
     C                   PARM                    HeadIn                                       209905
     C                   PARM                    TRANSDTL                                     209905
     C                   PARM      *BLANKS       Timestamp                                    209905
     C                   PARM                    PDealNum                                     209905
     C                   PARM      *BLANKS       PADealNo                                     209905
                                                                                              209905
     C                   IF        RetCodeOut <> *BLANKS                                      209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBKey = PDealNum                                           209905
     C                   EVAL      DBFile = 'APLOGTRAN'                                       209905
     C                   EVAL      DBase = 4                                                  209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
      *****************************************************************                       209905
      /EJECT                                                                                  209905
      *****************************************************************                       209905
      *                                                               *                       209905
      * SRSETD - Set Settlement Details                               *                       209905
      *                                                               *                       209905
      *****************************************************************                       209905
                                                                                              209905
     C     SRSETD        BEGSR                                                                209905
                                                                                              209905
      ** Payment Fields                                                                       209905
                                                                                              209905
     C                   EVAL      FLPSTM = CAHKPSTM                                          209905
     C                   EVAL      FLPONS = CAHKPONS                                          209905
     C                   EVAL      FLPIBN = CAHKPIBN                                          209905
     C                   EVAL      FLPIBA = CAHKPIBA                                          209905
     C                   EVAL      FLPOBN = CAHKPOBN                                          209905
     C                   EVAL      FLPOCN = CAHKPOCN                                          209905
     C                   EVAL      FLRCRN = CAHKRCRN                                          209905
     C                   EVAL      FLRCRA = CAHKRCRA                                          209905
     C                   EVAL      FLRVNO = CAHKRVNO                                          209905
     C                   EVAL      FLAWBN = CAHKAWBN                                          209905
     C                   EVAL      FLBENN = CAHKBENN                                          209905
     C                   EVAL      FLBENA = CAHKBENA                                          209905
     C                   EVAL      FLDTP1 = CAHKDTP1                                          209905
     C                   EVAL      FLDTP2 = CAHKDTP2                                          209905
     C                   EVAL      FLDTP3 = CAHKDTP3                                          209905
     C                   EVAL      FLDTP4 = CAHKDTP4                                          209905
     C                   EVAL      FLDCHG = CAHKDCHG                                          209905
     C                   EVAL      FLBTB1 = CAHKBTB1                                          209905
     C                   EVAL      FLBTB2 = CAHKBTB2                                          209905
     C                   EVAL      FLBTB3 = CAHKBTB3                                          209905
     C                   EVAL      FLBTB4 = CAHKBTB4                                          209905
     C                   EVAL      FLBTB5 = CAHKBTB5                                          209905
     C                   EVAL      FLBTB6 = CAHKBTB6                                          209905
     C                   EVAL      FLPOBR = CAHKPOBR                                          209905
     C                   EVAL      FLCVMR = CAHKCVMR                                          209905
     C                   EVAL      FLPSCY = CAHKSTCY                                          209905
     C                   EVAL      FLIC72 = CAHKIC72                                          209905
                                                                                              209905
      ** Receipt Fields                                                                       209905
                                                                                              209905
     C                   EVAL      FLRSTM = CAHKRSTM                                          209905
     C                   EVAL      FLRONS = CAHKRONS                                          209905
     C                   EVAL      FLRIBN = CAHKRIBN                                          209905
     C                   EVAL      FLRIBA = CAHKRIBA                                          209905
     C                   EVAL      FLROBN = CAHKROBN                                          209905
     C                   EVAL      FLROCN = CAHKROCN                                          209905
     C                   EVAL      FLROBR = CAHKROBR                                          209905
     C                   EVAL      FLRSCY = CAHKSTCY                                          209905
                                                                                              209905
      ** Inf Data                                                                             209905
                                                                                              209905
     C                   EVAL      BUSR = CAHKBUSR                                            209905
     C                   EVAL      AUTH = CAHKAUTH                                            209905
                                                                                              209905
     C                   CALLB     'ZASETINCVT'                                               209905
                                                                                              209905
     C                   PARM                    PAYFilFmt                                    209905
     C                   PARM                    RECFilFmt                                    209905
     C                   PARM      *BLANKS       FRIRFilFmt                                   209905
     C                   PARM      *BLANKS       PayScnFmt                                    209905
     C                   PARM      *BLANKS       RecScnFmt                                    209905
     C                   PARM      *BLANKS       FRIRScnFmt                                   209905
     C                   PARM      HKCCY         InRCCY                                      CSF011A
     C                   PARM      HKCCY         InPCCY                                      CSF011A
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
 
      *****************************************************************
      *                                                               *
      *  SR/#UPDAT : Update File                                      *
      *                                                               *
      *  Called by   : #INSRT, #DELET                                 *
      *                                                               *
      *  Calls       : #EXTE, *PSSR, ZA0770, ZA0270, CAGTNXTFID,      *
      *                MMLDNIUPM, MMLDNIUPD                           *
      *                                                               *
      *****************************************************************
 
     C     #UPDAT        BEGSR
 
      ** Generate deal number in insert mode only
 
     C     @@MODE        IFNE      'D'
 
      ** Generate Deal Number only if it's blanks
 
     C     IKDN38        IFEQ      *ZEROS
     C                   CALLB     'CAGTNXTFID'
     C                   PARM                    IKTYPE
     C                   PARM      IKDN38        PDealNo           6 0
     C                   Z-ADD     PDealNo       IKDN38
     C                   ENDIF
 
      ** Write a record to reserve one position in the file
 
     C                   CLEAR                   MMDELDP0
     C                   MOVEL     @SLDS         MMDEL
     C                   Z-ADD     IKDN38        HKDN38
     C                   MOVEL     '*'           HKDLTF
     C                   MOVEL     IKLACT        HKLACT                                       209905
     C                   MOVEL     IKFRNT        HKFRNT                                       209905
     C                   MOVEL     IKAFRT        HKAFRT                                       209905
 
      ** Write a record to extension file
 
     C                   EXSR      #EXTE
 
      ** Delete Mode
 
     C                   ELSE
     C                   MOVE      'IK'          IKRCID
     C                   MOVE      HKDLTF        IKDLTF
     C                   MOVE      HKDLUP        IKDLUP
     C                   MOVE      HKMLUP        IKMLUP
     C                   MOVE      HKYLUP        IKYLUP
     C                   MOVE      HKTLUP        IKTLUP
     C                   MOVE      HKCHTP        IKCHTP
     C                   MOVE      HKLCD         IKLCD
     C                   MOVE      HKLUID        IKLUID
     C                   MOVE      HKPCDN        IKPCDN
     C                   MOVE      HKDADN        IKDADN
     C                   Z-ADD     HKAMNP        IKRBAT
     C                   MOVE      HKBKCD        IKBKCD
     C                   MOVE      HKCCY         IKCCY
     C                   MOVE      HKCYDP        IKCYDP
     C                   MOVE      HKVDYY        IKVDYY
     C                   MOVE      HKVDMM        IKVDMM
     C                   MOVE      HKVDDD        IKVDDD
     C                   MOVE      HKDSTS        IKDSTS
     C                   MOVE      HKMTYP        IKMTYP
     C                   MOVE      HKRBSI        IKRBSI
     C                   MOVE      HKTYPE        IKTYPE
     C                   MOVE      HKSTYP        IKSTYP
     C                   MOVE      HKCSNM        IKCSNM
     C                   MOVE      HKCNUM        IKCNUM
     C                   MOVE      HKAMNP        IKAMNP
     C                   MOVE      HKINTR        IKINTR
     C                   MOVE      HKBRCA        IKBRCA
     C                   MOVE      HKDBRC        IKDBRC
     C                   MOVE      HKDDYY        IKDDYY
     C                   MOVE      HKDDMM        IKDDMM
     C                   MOVE      HKDDDD        IKDDDD
     C                   MOVE      HKBRKG        IKBRKG
     C                   MOVE      HKBKCY        IKBKCY
     C                   MOVE      HKBCDP        IKBCDP
     C                   MOVE      HKFEDF        IKFEDF
     C                   MOVE      HKPTFR        IKPTFR
     C                   MOVE      HKCDRF        IKCDRF
     C                   MOVE      HKPCTN        IKPCTN
     C                   MOVE      HKTIME        IKTIME
     C                   MOVE      HKDUSC        IKDUSC
     C                   MOVE      HKAOFR        IKAOFR
     C                   MOVE      HKSLYY        IKSLYY
     C                   MOVE      HKSLMM        IKSLMM
     C                   MOVE      HKSLDD        IKSLDD
     C                   MOVE      HKROBY        IKROBY
     C                   MOVE      HKSPRD        IKSPRD
     C                   MOVE      HKIIRT        IKIIRT
     C                   MOVE      HKNIYY        IKNIYY
     C                   MOVE      HKNIMM        IKNIMM
     C                   MOVE      HKNIDD        IKNIDD
     C                   MOVE      HKIPFQ        IKIPFQ
     C                   MOVE      HKICMT        IKICMT
     C                   MOVE      HKIPDM        IKIPDM
     C                   MOVE      HKCPTI        IKCPTI
     C                   MOVE      HKCNTI        IKCNTI
     C                   MOVE      HKACSQ        IKACSQ
     C                   MOVE      HKNGVI        IKNGVI
     C                   MOVE      HKMTTI        IKMTTI
     C                   MOVE      HKMTAX        IKMTAX
     C                   MOVE      HKMCDH        IKMCDH
     C                   MOVE      HKIAYY        IKIAYY
     C                   MOVE      HKIAMM        IKIAMM
     C                   MOVE      HKIADD        IKIADD
     C                   MOVE      HKBSRC        IKBSRC
     C                   MOVE      HKDBSR        IKDBSR
     C                   MOVE      HKMDYY        IKMDYY
     C                   MOVE      HKMDMM        IKMDMM
     C                   MOVE      HKMDDD        IKMDDD
     C                   MOVE      HKNTCE        IKNTCE
     C                   MOVE      HKIMAT        IKIMAT
     C                   MOVE      HKBRAT        IKBRAT
     C                   MOVE      HKMMDI        IKMMDI
     C                   MOVE      HKDORM        IKDORM
     C                   MOVE      HKORCM        IKORCM
     C                   MOVE      HKDORI        IKDORI
     C                   MOVE      HKMORI        IKMORI
     C                   MOVE      HKDCPI        IKDCPI
     C                   MOVE      HKMCPI        IKMCPI
     C                   MOVE      HKDOPM        IKDOPM
     C                   MOVE      HKMOPM        IKMOPM
     C                   MOVE      HKDOPI        IKDOPI
     C                   MOVE      HKMOPI        IKMOPI
     C                   MOVE      HKDCRI        IKDCRI
     C                   MOVE      HKMCRI        IKMCRI
     C                   MOVE      HKDFAC        IKDFAC
     C                   MOVE      HKMFAO        IKMFAO
     C                   MOVE      HKSPEC        IKSPEC
     C                   MOVE      HKFUID        IKFUID
     C                   MOVE      HKFLID        IKFLID
     C                   MOVE      HKRDFC        IKRDFC
     C                   MOVE      HKORBR        IKORBR
     C                   MOVE      HKPRFC        IKPRFC
     C                   MOVE      HKRSTM        IKRSTM
     C                   MOVE      HKRONS        IKRONS
     C                   MOVE      HKRIBN        IKRIBN
     C                   MOVE      HKRIBA        IKRIBA
     C                   MOVE      HKROBN        IKROBN
     C                   MOVE      HKROCN        IKROCN
     C                   MOVE      HKPSTM        IKPSTM
     C                   MOVE      HKPONS        IKPONS
     C                   MOVE      HKPIBN        IKPIBN
     C                   MOVE      HKPIBA        IKPIBA
     C                   MOVE      HKPOBN        IKPOBN
     C                   MOVE      HKPOCN        IKPOCN
     C                   MOVE      HKRCRN        IKRCRN
     C                   MOVE      HKRCRA        IKRCRA
     C                   MOVE      HKRVNO        IKRVNO
     C                   MOVE      HKAWBN        IKAWBN
     C                   MOVE      HKAWBA        IKAWBA
     C                   MOVE      HKBENN        IKBENN
     C                   MOVE      HKBENA        IKBENA
     C                   MOVE      HKDTP1        IKDTP1
     C                   MOVE      HKDTP2        IKDTP2
     C                   MOVE      HKDTP3        IKDTP3
     C                   MOVE      HKDTP4        IKDTP4
     C                   MOVE      HKDCHG        IKDCHG
     C                   MOVE      HKBTB1        IKBTB1
     C                   MOVE      HKBTB2        IKBTB2
     C                   MOVE      HKBTB3        IKBTB3
     C                   MOVE      HKBTB4        IKBTB4
     C                   MOVE      HKBTB5        IKBTB5
     C                   MOVE      HKBTB6        IKBTB6
     C                   MOVE      HKCVMR        IKCVMR
     C                   MOVE      HKROBR        IKROBR
     C                   MOVE      HKPOBR        IKPOBR
     C                   Z-ADD     HKVDYY        @YEAR
     C                   Z-ADD     HKVDMM        @MNTH
     C                   Z-ADD     HKVDDD        @DAY
     C                   MOVE      HKBOKC        IKBOKC
     C                   MOVE      HKLNKN        IKLNKN
     C                   MOVE      HKDRID        IKDRID
     C                   MOVE      HKDDMR        IKDDMR
     C                   MOVE      HKAURO        IKAURO
     C                   MOVE      HKIPDS        IKIPDS
     C                   MOVE      HKROFQ        IKROFQ
     C                   MOVE      HKRLDN        IKRLDN
     C                   MOVE      HKIMET        IKIMET
     C                   MOVE      HKINSA        IKINSA
     C                   MOVE      HKINOS        IKINOS
     C                   MOVE      HKCNNA        IKCNNA
     C                   MOVEL     HKLACT        IKLACT                                       209905
     C                   MOVEL     HKFRNT        IKFRNT                                       209905
     C                   MOVEL     HKAFRT        IKAFRT                                       209905
 
     C     @DATE         IFEQ      0
     C                   Z-ADD     0             IKDVSD
     C                   ELSE
     C                   Z-ADD     @DATE         @@DTIN
     C                   EXSR      ZA0770
     C                   MOVE      @@DTOU        @DAT              6 0
     C                   CALL      'ZA0270'
     C                   PARM                    @DAT
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE            1
     C                   PARM                    IKDVSD
     C                   ENDIF
 
     C                   Z-ADD     HKDDYY        @YEAR
     C                   Z-ADD     HKDDMM        @MNTH
     C                   Z-ADD     HKDDDD        @DAY
 
     C     @DATE         IFEQ      0
     C                   Z-ADD     0             IKDDND
     C                   ELSE
     C                   Z-ADD     @DATE         @@DTIN
     C                   EXSR      ZA0770
     C                   MOVE      @@DTOU        @DAT
     C                   CALL      'ZA0270'
     C                   PARM                    @DAT
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE
     C                   PARM                    IKDDND
     C                   ENDIF
 
     C                   Z-ADD     HKNIYY        @YEAR
     C                   Z-ADD     HKNIMM        @MNTH
     C                   Z-ADD     HKNIDD        @DAY
 
     C     @DATE         IFEQ      0
     C                   Z-ADD     0             IKNIPD
     C                   ELSE
     C                   Z-ADD     @DATE         @@DTIN
     C                   EXSR      ZA0770
     C                   MOVE      @@DTOU        @DAT
     C                   CALL      'ZA0270'
     C                   PARM                    @DAT
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE
     C                   PARM                    IKNIPD
     C                   ENDIF
 
     C                   Z-ADD     HKSLYY        @YEAR
     C                   Z-ADD     HKSLMM        @MNTH
     C                   Z-ADD     HKSLDD        @DAY
 
     C     @DATE         IFEQ      0
     C                   Z-ADD     0             IKSLID
     C                   ELSE
     C                   Z-ADD     @DATE         @@DTIN
     C                   EXSR      ZA0770
     C                   MOVE      @@DTOU        @DAT
     C                   CALL      'ZA0270'
     C                   PARM                    @DAT
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE
     C                   PARM                    IKSLID
     C                   ENDIF
 
     C                   Z-ADD     HKMDYY        @YEAR
     C                   Z-ADD     HKMDMM        @MNTH
     C                   Z-ADD     HKMDDD        @DAY
 
     C     @DATE         IFEQ      0
     C                   Z-ADD     0             IKMATD
     C                   ELSE
     C                   Z-ADD     @DATE         @@DTIN
     C                   EXSR      ZA0770
     C                   MOVE      @@DTOU        @DAT
     C                   CALL      'ZA0270'
     C                   PARM                    @DAT
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE
     C                   PARM                    IKMATD
     C                   ENDIF
 
     C                   Z-ADD     HKDTYY        IKDTYY
     C                   Z-ADD     HKDTMM        IKDTMM
     C                   Z-ADD     HKDTDD        IKDTDD
 
     C                   MOVE      'D'           IKDDLT
     C                   MOVE      HKDN38        IKDN38
     C                   ENDIF
 
     C                   CALLB     'MMLDNIUPM'
     C**********         PARM      *BLANK        @@RTCD                                       209905
     C                   PARM      'FIDTUPF'     @@RTCD                                       209905
     C                   PARM                    @SLDS
     C                   PARM                    #FPAYF                                       CDL033
     C                   PARM                    #FRECF                                       CDL033
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM      *BLANKS       PBFRCD                                       CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM      *BLANKS       PAFRCD                                       CDL033
     C/COPY WNCPYSRC,MMFIDTUPC1
 
      ** Error when update database
 
     C     @@RTCD        IFEQ      *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM      *BLANK        @@RTCD
     C                   PARM                    @SLDS
     C                   ENDIF
 
      ** Error when update database
 
     C     @@RTCD        IFNE      *BLANK
 
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   IF        #PGM = 'MMLDNIUPC'                                         209905
                                                                                              209905
     C                   DELETE    MMVFIDT                                                    209905
                                                                                              209905
     C                   ELSE                                                                 209905
                                                                                              209905
      ** Delete record from MMWFIDDPD when update is successful
     C                   DELETE    SW8OUTP
 
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
 
     C                   ENDIF
 
      ** Save Deal number of the first taking.
 
     C     WUFDEA        IFEQ      *BLANK
     C     *LIKE         DEFINE    @@LNKN        WUFDNO
     C                   Z-ADD     IKDN38        WUFDNO
     C                   MOVE      'Y'           WUFDEA
     C                   ENDIF
 
      ** Save Deal number of the last taking.
 
     C     *LIKE         DEFINE    @@DN38        WULDNO
     C                   Z-ADD     IKDN38        WULDNO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SR/#EXTE  : Output Record in File                            *
      *                                                               *
      *  Called by   : #UPDAT                                         *
      *                                                               *
      *  Calls       : None                                           *
      *                                                               *
      *****************************************************************
 
     C     #EXTE         BEGSR
 
     C                   MOVE      IKDN38        HKDN38
 
     C/COPY WNCPYSRC,MMFIDTUPC3
      ** Access charge/commission group
 
     C                   MOVE      IKCNUM        WWCNUM            6
     C     WWCNUM        CHAIN     SDCUSTL1                           91
 
      ** ------------------- **
      ** Charges calculation **
      ** ------------------- **
 
     C                   MOVE      *BLANKS       HKFCGC
     C                   MOVE      *BLANKS       IKFCGC
     C                   MOVE      *BLANKS       IKFCGD
     C                   Z-ADD     0             IKFCGA
     C                   Z-ADD     0             IKFCGT
 
     C     BNCHTK        IFEQ      'Y'
     C     BBCHRG        ANDNE     *BLANKS
     C     *IN91         ANDEQ     *OFF
 
     C     BBCHRG        CHAIN     SDCCGRL0                           90
     C     *IN90         IFEQ      *OFF
     C     CCRECI        ANDEQ     'D'
 
     C                   MOVEL     CCCHOD        HKFCGC
     C                   MOVEL     IKCCY         WWCCY
     C     BNCTBC        IFEQ      'Y'
     C                   MOVE      BJCYCD        WWCCY
     C                   ENDIF
     C                   MOVEL     HKFCGC        FDCCOM
     C     WWDLCC        CHAIN     DLCCGDL0                           90
 
     C     *IN90         IFEQ      *OFF
     C                   CALLB     'MMFIDTCHG'
     C                   PARM                    PSProcName
     C                   PARM                    @@MODE
     C                   PARM                    PDealNo           6 0
     C**********         PARM      IKCNUM        PCustNo           6 0                        CSD027
     C                   PARM      IKCNUM        PCustNo           6                          CSD027
     C                   PARM                    IKCCY
     C                   PARM      IKAMNP        PAMNP            13 0
     C                   PARM                    HKFCGC
     C                   PARM      *BLANKS       PFCGD            20
     C                   PARM      *ZERO         PFCGA            13 0
     C                   PARM      *BLANKS       PRTCD             7
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      HKFCGC        IKFCGC
     C                   MOVE      PFCGD         IKFCGD
     C                   Z-ADD     PFCGA         IKFCGA
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** ---------------------- **
      ** Commission calculation **
      ** ---------------------- **
 
     C                   MOVEL     *BLANKS       HKFCMC
     C                   MOVEL     *BLANKS       IKFCMC
     C                   MOVE      *BLANKS       IKFCMD
     C                   Z-ADD     0             IKFCMA
     C                   Z-ADD     0             IKFCMT
 
     C     BNCOTK        IFEQ      'Y'
     C     *IN91         ANDEQ     *OFF
     C     BBCOMG        ANDNE     *BLANKS
     C     IKMATD        ANDNE     *ZEROS
 
     C     BBCOMG        CHAIN     SDCCGRL0                           90
     C     *IN90         IFEQ      *OFF
     C     CCRECI        ANDEQ     'D'
 
     C                   MOVEL     CCCCOD        HKFCMC
     C                   MOVEL     IKCCY         WWCCY
     C     BNCTBC        IFEQ      'Y'
     C                   MOVE      BJCYCD        WWCCY
     C                   ENDIF
     C                   MOVEL     HKFCMC        FDCCOM
 
     C     WWDLCC        CHAIN     DLCCGDL0                           90
 
     C     *IN90         IFEQ      *OFF
     C                   CALLB     'MMFIDTCOM'
     C                   PARM                    PSProcName
     C                   PARM                    @@MODE
     C                   PARM      IKDN38        PDealNo           6 0
     C                   PARM      IKCNUM        PCustNo
     C                   PARM                    IKCCY
     C                   PARM                    IKTYPE
     C                   PARM      CAHKMATD      PMATD             5 0
     C                   PARM      CAHKVDDD      PVDDD             2 0
     C                   PARM      CAHKVDMM      PVDMM             2 0
     C                   PARM      CAHKVDYY      PVDYY             2 0
     C                   PARM                    CAHKRDFC
     C                   PARM                    CAHKICMT
     C                   PARM      IKAMNP        PAMNP15          15 0
     C                   PARM                    HKFCMC
     C                   PARM      *BLANKS       PFCMD            20
     C                   PARM      *ZEROS        PFCMA            13 0
     C                   PARM      *BLANKS       PRTCD
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      HKFCMC        IKFCMC
     C                   MOVE      PFCMD         IKFCMD
     C                   Z-ADD     PFCMA         IKFCMA
     C                   EndIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C/COPY WNCPYSRC,MMFIDTUPC4
     C                   Z-ADD     0             HKBCAM                                       CLE025
     C                   WRITE     MMDELDP0
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SR/#DELET : Delete Processing                                *
      *                                                               *
      *  Called by   : #MAIN                                          *
      *                                                               *
      *  Calls       : #UPDAT                                         *
      *                                                               *
      *****************************************************************
 
     C     #DELET        BEGSR
 
      ** Read first record with link reference from @SLDS
 
     C     @@DN38        SETLL     MMDELDL3
     C     @@DN38        READE     MMDELDL3                               90
 
     C     *IN90         DOWEQ     *OFF
     C                   EXSR      #UPDAT
     C     @@DN38        READE     MMDELDL3                               90
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SR/#TERM : Termination Processing                            *
      *                                                               *
      *  Called by   : Main Routine                                   *
      *                                                               *
      *  Calls       : None                                           *
      *                                                               *
      *****************************************************************
 
     C     #TERM         BEGSR
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SR/*PSSR : Error Handling                                    *
      *                                                               *
      *  Called by   : #INIT, #UPDAT                                  *
      *                                                               *
      *  Calls       : None                                           *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   MOVE      '*ERROR '     @@RTCD                                       209905
     C                   DUMP
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SR/ZA0770 : This subroutine receives a 8/0 input date -      *
      *              format YYYYMMDD and outputs a 6/0 date.          *
      *              If field date format (SDBANKPD) 'M', output      *
      *              format MMDDYY. If date format = 'D', output      *
      *              format DDMMYY.                                   *
      *                                                               *
      *  Called by   : #UPDAT                                         *
      *                                                               *
      *  Calls       : None                                           *
      *                                                               *
      *  Input       : @@DTIN  - Date Input (8,0)                     *
      *  Output      : @@DTOU  - Date Output (6,0)                    *
      *                                                               *
      *  Work Fields : @@YYY   - Year In (2,0)                        *
      *              : @@MM    - Month In (2,0)                       *
      *              : @@DD    - Day In (2,0)                         *
      *                                                               *
      *              : @@DAT1  - If Date DD/MM/YY Day else Month (2,0)*
      *              : @@DAT2  - If Date DD/MM/YY Month else Day (2,0)*
      *                                                               *
      *****************************************************************
 
     C     ZA0770        BEGSR
 
     C                   Z-ADD     @@YY          @@YYY
 
      ** Date format = 'D' convert to MMDDYY format
 
     C     BJDFIN        IFEQ      'D'
     C                   Z-ADD     @@DD          @@DAT1
     C                   Z-ADD     @@MM          @@DAT2
     C                   ENDIF
 
      ** Date format = 'M' convert to MMDDYY format
 
     C     BJDFIN        IFEQ      'M'
     C                   Z-ADD     @@DD          @@DAT2
     C                   Z-ADD     @@MM          @@DAT1
     C                   ENDIF
 
      ** Move year part of data structure
 
     C                   MOVE      @@YYY         @@YY
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
