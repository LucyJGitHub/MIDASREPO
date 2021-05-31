     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Correspondence maintenance')                  *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG0010 - Edit Correspondent        Edit record(3 screens)    *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CCG024             Date 29Sep16               *
      *                 MD029030           Date 25Nov14               *
      *                 MD027306           Date 10Jun14               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 245085             Date 18Jan07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSD053             Date 01Jun06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2330            Date 29Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 217460             Date 28May03               *
      *                 CSD015             Date 14Oct02               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 09Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 117207             Date 21May01               *
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 115722             Date 12Feb98               *
     F*                 116605             DATE 09APR97               *
     F*                 100927             DATE 09APR97               *
     F*                 095468             DATE 24OCT95               *
     F*                 088575             DATE 02JUN95               *
     F*                 086588             DATE 21APR95               *
     F*                 086504             DATE 19APR95               *
     F*                 086503             DATE 19APR95               *
     F*                 086143             DATE 17MAR95               *
     F*                 082944             DATE 08FEB95               *
     F*                 082705             DATE 31JAN95               *
     F*                 079846             DATE 07DEC94               *
     F*                 079843             DATE 07DEC94               *
     F*                 S01522             DATE 21NOV94               *
     F*                                                               *
     F*---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD to readable  *
      *             unicode equivalent.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG024 - Use Atlernate Name and Address in Correspondence    *
      *  MD029030 - Unexpected error S.W.I.F.T. BIC not found in      *
      *             directory  (CFT007-BIC Database Plus is OFF)      *
      *           - do not validate SWIFT BIC if CFT007 is off        *
      *  MD027306 - Address line 1 is mandatory for relationship      *
      *             types of N, S, L.                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  245085 - Correct date validation.                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217460 - Validate Language code against Standing Data        *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSD012 - Standing Data Authorisation.                        *
      *  CCG015 - Correspondence Manager Phase 1                      *
     F*  117207 - Retention Period of maximum 99 days is too short.   *
     F*  115722 - Comment out references to CGUSRMSG/CGD1001          *
     F*  116605 - 'Print Addresss Label' should default to 'N' if     *
     F*           left blank.                                         *
     F*  100927 - Entering a Correspondent Type should not force an   *
     F*           entry of an Address.                                *
     F*  095468 - Decimal Data error if ? in Schedule print date      *
     F*  088575 - Default retention date is mandatory if correspondent*
     F*           is SYSTEM.                                          *
     F*  086588 - Correct conditions for charge processing            *
     F*  086504 - Limit addresses to 6 lines of 40 Characters         *
     F*  086503 - Ignore Address line Validation 1-4                  *
     F*  086143 - Correct chain to correspondent type file            *
     F*  082944 - Add Structure Type validation                       *
     F*  082705 - Allow Correspondent Type of "T"                     *
     F*  079846 - Post day number only allowed if frequency entered   *
     F*  079843 - Correct processing to look at item status           *
     F*  S01552 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*EDTRCD: Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,CG0010DFPG
     FCG0010DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Edit Correspondent        Edit record(3 screens)
      *
     FCGCORRL1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
     F/COPY WNCPYSRC,CG0010F001
      * RTV : Correspondent Details     Retrieval index
      *
     FCGCTYPL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Correspondent Type        Retrieval index
      *
     FCGPSCHL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Print Schedule Types      Retrieval index
      *
     FCGCSTRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Correspondent Structure   Retrieval index
      *
     FCGCORRL0  UF A E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     COMMIT
      * UPD : Correspondent Details     Update index
      *
     FCGCORRL3  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RSQ : Correspondent Details     By Branch and system
      *
     FCGCORRL4  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RSQ : Correspondent Details     By Customer
      *
     FCGCORRL5  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RSQ : Correspondent Details     By Counterparty nostro
      *
     FCGCORRLB  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RSQ : Correspondent Details     By SWIFT BIC
      *                                                                                       082705
     FCGCORRLC  IF   E           K DISK                                                       082705
     F                                     INFSR(SRFILE)                                      082705
      * RTV : Correspondent Details     By correspondent type                                 082705
      *
     FSDAULGL2  IF   E           K DISK
      * RTV : Authorisation Log - by Function                                                 CSD012
      *                                                                                       CSD012
     FSDAULGL3  UF A E           K DISK                                                       CSD012
     F                                     COMMIT                                             CSD012
     F                                     RENAME(SDAULGD0:SDAULG3)                           CSD012
      * UPD : Authorisation Log - by Function                                                 CSD012
      *                                                                                       CSD012
     FCGCDSHL0  UF A E           K DISK                                                       CSD012
     F                                     COMMIT                                             CSD012
      * UPD : Correspondent Details Shadow file                                               CSD012
      *                                                                                       CSD012
     FSDCWHTL1  IF   E           K DISK                                                       CSD015
      *                                                                                       CSD015
      ** Compliance Watch Hit List Logical File by function                                   CSD015
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
      *                                                                                       CSD015
     D OPNTAG          S             35    DIM(4) CTDATA PERRCD(1)                            CSD015
     D CLSTAG          S             35    DIM(4) CTDATA PERRCD(1)                            CSD015
      *                                                                                       CSD015
      ** Arrays containing the tag used for the XML parameter                                 CSD015
      *                                                                                       CSD015
     D***************** FIRST COMPILE TIME ARRAY *********************
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,CG0010DEPG
      * Screen one error indicator store
      * Screen two error indicator store
      * Screen three error indicator store
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)                                            CSC022
     D*COPY*CGCPYSRC,SRERRI                                                                 MD056543
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,CG0010DIPG
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC        E DS                  EXTNAME(CGCORRL0)
      * UPD : Correspondent Details     Update index
      * Current/previous master file format fields for change control
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SDLCD        E                     EXTFLD(LCD)
      * Switchable Features Details accessed via Access Program                               CCG015
      *                                                                                       CCG015
     D***#1DBRC*     DS                            759                                        CCG015
     D***#1DBRC*     DS                            819                                 CCG015 CSD053
     D #1DBRC          DS          1255                                                CCG015 CSD053
      * Stored master file format fields
     D  #1DB1                  1      1
      *                                                                                       CSD012
     D***#2DBRC*      DS                           819                                 CSD012 CSD053
     D #2DBRC          DS          1255                                                CSD012 CSD053
      * Stored master file format fields                                                      CSD012
      *
     D @@I1            DS
      * Screen one error indicator store
     D  @I1                    1    100
     D                                     DIM(100)
     D  INSCR1                31     50
     D @@I2            DS
      * Screen two error indicator store
     D  @I2                    1    100
     D                                     DIM(100)
     D**********                             31  46 INSCR2                                    CCG015
     D  INSCR2                31     47                                                       CCG015
     D @@I3            DS
      * Screen three error indicator store
     D  @I3                    1    100
     D                                     DIM(100)
     D  INSCR3                31     39
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      *  Branch Details *
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      *  Customer Details *
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      *  Counterparty Nostros *
      *
     D SDLANG        E DS                  EXTNAME(SDLANGPD)
      *
      *  Languages *
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                  217460
      *                                                                                       217460
      *  Country Code *                                                                       217460
      *                                                                                       217460
     D*COPY*CGCPYSRC,CGCOV                                                           082944 MD056543
     D/COPY CGCPYSRC,CGCOVLE                                                                MD056543
      *                                                                                       082944
      * Plist DS for CG0011                                                                   082944
      *                                                                                       082944
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  ACRECI       E                     EXTFLD(RECI)
     D  ACLCD        E                     EXTFLD(LCD)
     D  ACCHTP       E                     EXTFLD(CHTP)
     D  ACTNLU       E                     EXTFLD(TNLU)
     D**********                              2  16 ##ACCT                                    CGL029
     D ##ACCT          DS                                                                     CGL029
     D  WCNUM                  1      6                                                       CGL029
     D  WCCY                   7      9                                                       CGL029
     D  WACOD                 10     19                                                       CGL029
     D  WACSQ                 20     21                                                       CGL029
      *
      *  Accounts *
      *
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      *  SWIFT BIC identification
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      *
      *  Location Details *
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      *  Currency Details *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     S01194
     D*                                                                                       S01194
     D* Data Structures used by Access Programs                                               S01194
     D*                                                                                       S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     S01194
     D*                                                                                       S01194
     D* Data Structures used by Access Programs                                               S01194
     D*                                                                                       S01194
     D WDSJOB        E DS                  EXTNAME(SCCMTJOB)                                  CSC022
     D  WCMTNO       E                     EXTFLD(COMITNUM)                                   CSC022
     D  WJOB01       E                     EXTFLD(COMITJOB1)                                  CSC022
     D  WJOB02       E                     EXTFLD(COMITJOB2)                                  CSC022
     D  WJOB03       E                     EXTFLD(COMITJOB3)                                  CSC022
     D  WJOB04       E                     EXTFLD(COMITJOB4)                                  CSC022
     D  WJOB05       E                     EXTFLD(COMITJOB5)                                  CSC022
     D  WJOB06       E                     EXTFLD(COMITJOB6)                                  CSC022
     D  WJOB07       E                     EXTFLD(COMITJOB7)                                  CSC022
     D  WJOB08       E                     EXTFLD(COMITJOB8)                                  CSC022
     D  WJOB09       E                     EXTFLD(COMITJOB9)                                  CSC022
     D  WJOB10       E                     EXTFLD(COMITJOB10)                                 CSC022
     D  WCJOBS                 4    103                                                       CSC022
      ** Commitment Control dataarea                                                          CSC022
      *                                                                                       CSC022
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS            10
      * KEY: Correspondent Details     Retrieval index
      * I : MAP Correspondent
     D  P2CORR                 1     10
     D O2PARM          DS            10
      * KEY: Correspondent Structure   Retrieval index
      * I : MAP Structure Type
     D  O2CSTR                 1     10
     D O3PARM          DS            10
      * KEY: Correspondent Type        Retrieval index
      * I : MAP Correspondent type
     D  O3CTYP                 1     10
     D O4PARM          DS             6
      * KEY: Print Schedule Types      Retrieval index
      * I : MAP Print Schedule
     D  O4PSCH                 1      6
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code (FT)'
      * Action Code
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
      *  Defined Constants
      *
      *
     D DIGITS          C                   CONST('0123456789')
     D ##HOLD          C                   CONST('HOLDMAIL')
     D ##SPRS          C                   CONST('SUPPRESS')
     D ##IMED          C                   CONST('IMMEDIATE')
      *
      * Data structure for AOSVALR0 string                                                    CSD012
     D                 DS                                                                     CSD012
     D  SVAL1                  1    200                                                       CSD012
     D  SVAL11                 1      1                                                       CSD012
      *                                                                                       CSD012
      * System Value                                                                          CSD012
     D                 DS                                                                     CSD012
     D  SVALK1                 1     20    INZ('AuthReqCorrespondent')                        CSD012
      *                                                                                       CSD012
      * Function Description                                                                  CSD012
     D FUNCD           DS            21    OCCURS(1)                                          CSD012
     D  FUNCD1                 1     13    INZ('CORRESPONDENT')                               CSD012
     D  FUNCD2                15     21    INZ('DETAILS')                                     CSD012
      *                                                                                       CSD012
      * Data structure for AOSVALR0 string                                                    CCG024
     D                 DS                                                                     CCG024
     D  SVAL2                  1    200                                                       CCG024
     D  SVAL21                 1      1                                                       CCG024
      *                                                                                       CCG024
      * System Value                                                                          CCG024
     D                 DS                                                                     CCG024
     D  SVALK2                 1     20    INZ('RecipientSpecialChar')                        CCG024
      *                                                                                       CCG024
      /EJECT
      *
      * Data to be passed to window processing
      *
     D/COPY QWINDSRC,CG0010WDTA
      *                                                                                       CSD015
      ** Data Structure for getting the main branch                                           CSD015
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CSD015
      *                                                                                       CSD015
      ** Data Structure for Watch List Configuration Data file                                CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
      *                                                                                       CSD015
      ** Data Structure used as parameter for the Compliance Engine                           CSD015
     D PDSWLT        E DS                  EXTNAME(SDWLTOPD)                                  CSD015
     D PDSXML          DS          9999                                                       CSD015
      *                                                                                       CSD015
      ** Data Structure for Watch List Checking Details                                       CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
      *                                                                                       CSD015
      ** DS for getting the system prefix if CSC011 is not installed                          CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT)                                    CSD015
      *                                                                                       CSD015
      ** DS for getting the system prefix if CSC011 is installed                              CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7)                                    CSD015
      *                                                                                       CSD015
      ** DS for getting the counter party using nostro code                                   CSD015
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSD015
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Correspond
      *                                                                                       082944
      * CG0011 Plist                                                                          082944
      *                                                                                       082944
     C     PL0011        PLIST                                                                082944
     C                   PARM      *BLANKS       P@RTN             7                          082944
     C                   PARM                    CGCOV                                        082944
      *
      *  Set up primary reference
      *
     C                   MOVEL     P2PARM        W0PREF
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Check passed parameters
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
      *
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Set control to display first screen
     C                   Z-ADD     1             W0SCR             3 0
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1CORR        IFEQ      *BLANK                                       Correspondent
      * One or more key fields is blank
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen
     C     W0BYP         IFNE      'Y'
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      * Process key screen input
     C                   CAS                     BEPRKY
     C                   END
     C     W0TRN         DOWEQ     'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSAK
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
      * Update screen time
     C                   TIME                    ##TME
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen input
      *================================================================
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Validate key fields
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    CDCORR                         Correspondent
      * Setup key
     C                   MOVEL     #1CORR        CDCORR                         Correspondent
     C     KRTV          CHAIN     @CORRL1                            9091      *
      *
      * Send message 'Record Exists'
      *
     C     *IN90         IFEQ      '0'
     C     P1ACTC        ANDEQ     'I'
     C                   MOVEL     'CGD1124'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If CCG024 is on, check that Correspondent name does not contain special char          CCG024
     C     CCG024        IFEQ      'Y'                                                        CCG024
     C     SVAL21        SCAN      #1CORR                                 99                  CCG024
     C     *IN99         IFEQ      *ON                                                        CCG024
     C                   MOVEL     'CGD1912'     ZAMSID                                       CCG024
     C                   EXSR      ZASNMS                                                     CCG024
     C                   SETON                                        9931      *             CCG024
     C                   GOTO      BEEXIT                                                     CCG024
     C                   ENDIF                                                                CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialize detail screen (new record)
      * EDTRCD: Init. det. scr NW - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl New Rcd
     C/COPY WNCPYSRC,CG0010DISN
     C                   ELSE
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG0010DSFF
      * USER: Initialize detail screen (existing record)
      * EDTRCD: Init. det. scr EX - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,CG0010DISE
     C                   END
      *..................................................
     C   99              GOTO      BEEXIT
      *
      * No error: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields
      *================================================================
      * USER: Validate key screen
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Key Screen
     C/COPY WNCPYSRC,CG0010DVKS
      * Correspondent required
     C     #1CORR        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1442'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *                                                                                       CSD012
      * Check if unathorised record exists for this Correspondent                             CSD012
      * on the Authorisation Log.                                                             CSD012
     C     CSD012        IFEQ      'Y'                                                        CSD012
     C     SVAL11        ANDEQ     'Y'                                                        CSD012
     C     *IN99         ANDNE     *ON                                                        CSD012
     C     P1ACTC        ANDNE     'E'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     FUNCD         K1FUNC                                       CSD012
     C                   MOVEL     #1CORR        K1CORR                                       CSD012
     C     KAULG         CHAIN     SDAULGL2                           90                      CSD012
      *                                                                                       CSD012
      * If record exists then prevent amendment                                               CSD012
     C     *IN90         IFEQ      *OFF                                                       CSD012
      * Setup message data for message                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     'USR9265'     ZAMSID                                       CSD012
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                       CSD012
     C                   SETON                                        9931      *             CSD012
     C                   EXSR      ZASNMS                                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0TRN
     C                   Z-ADD     1             W0SCR
     C                   EXSR      MAIZ#1
     C                   END
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
     C     W0ROL         DOUEQ     'N'
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
     C     W0SCR         IFEQ      1
      * Set error
     C                   MOVEA     INSCR1        *IN(31)
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
     C                   ELSE
     C     W0SCR         IFEQ      2
      * Set error
     C                   MOVEA     INSCR2        *IN(31)
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT3
     C                   EXFMT     #RCDDTL2
     C                   ELSE
     C     W0SCR         IFEQ      3
      * Set error
     C                   MOVEA     INSCR3        *IN(31)
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT4
     C                   EXFMT     #RCDDTL3
     C                   END
     C                   END
     C                   END
      * Reset roll flag
     C                   MOVEL     'N'           W0ROL             1
      * Show next page of details
     C   27              EXSR      CDNXSC
      * Show previous page of details
     C   28              EXSR      CEPVSC
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * EDTRCD: Process key req. - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Key Screen Rqst
     C/COPY WNCPYSRC,CG0010DPKR
     C   05              MOVEL     'R'           W0TRN
      *
      * If insert go to key screen else exit
      *
     C     *IN12         IFEQ      '1'
     C     P1ACTC        IFEQ      'I'
     C                   MOVEL     'K'           W0TRN
     C                   ELSE
     C                   EXSR      ZXEXPG
     C                   END
     C                   END
      * Initialise error memories
     C                   MOVE      *ZERO         INSCR1
     C                   MOVE      *ZERO         INSCR2
     C                   MOVE      *ZERO         INSCR3
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CDNXSC        BEGSR
      *================================================================
      * Display next screen
      *================================================================
      * Set roll flag
     C                   MOVEL     'Y'           W0ROL             1
     C     W0SCR         IFLT      3
     C                   ADD       1             W0SCR
     C                   END
      *================================================================
     CSR   CDEXIT        ENDSR
      /EJECT
     CSR   CEPVSC        BEGSR
      *================================================================
      * Display previous screen
      *================================================================
      * Set roll flag
     C                   MOVEL     'Y'           W0ROL             1
     C     W0SCR         IFGT      1
     C                   SUB       1             W0SCR
     C                   END
      *================================================================
     CSR   CEEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
     C     P1ACTC        IFEQ      'I'
     C     P1ACTC        OREQ      'A'
     C     *IN10         IFEQ      '0'
      * Validate details
     C                   MOVE      *ZEROS        INSCR1
     C                   MOVE      *ZEROS        INSCR2
     C                   MOVE      *ZEROS        INSCR3
     C                   EXSR      DCVLDL
      * Display first screen in error
     C     INSCR1        IFNE      *ZERO
     C                   Z-ADD     1             W0SCR
     C                   ELSE
     C     INSCR2        IFNE      *ZERO
     C                   Z-ADD     2             W0SCR
     C                   ELSE
     C     INSCR3        IFNE      *ZERO
     C                   Z-ADD     3             W0SCR
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
      *  Check referential integrity if delete
      *
     C     P1ACTC        IFEQ      'D'
     C                   EXSR      SRREFI
     C                   END
      *
      *  Call window processing
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRWIND
     C                   END
      * QUIT if error:
     C     *IN99         CABEQ     '1'           CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: update record
     C     P1ACTC        IFEQ      'A'
     C     P1ACTC        OREQ      'I'
     C     P1ACTC        OREQ      'D'
     C     *IN10         ANDEQ     '1'
     C                   EXSR      EBPR##
     C                   END
      *
      * Exit if enquire
      *
     C     P1ACTC        IFEQ      'E'
     C                   MOVEL     'N'           W0RPT
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * USER: Validate detail screen fields
      * EDTRCD: Valid det. scrn - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Detail Screen
     C/COPY WNCPYSRC,CG0010DVSF
      * Check relations
      * Check reference to Midas Customer detail
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(31)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Midas Counterparty No
     C                   EXSR      VBCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(32)
     C                   SETON                                        99        *
     C                   END
      * Check reference to BIC Directory
     C                   EXSR      VCCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(34)
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(35)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Midas Branch codes
     C                   EXSR      VDCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(33)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Correspondent Type
     C                   EXSR      VECKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(37)
     C                   SETON                                        99        *
     C                   END
     ***Check*reference*to*Midas*SD*Languages*co************                                  217460
     C***********          EXSR VFCKRL                                                        217460
      * Check Language code against Midas SD Country Codes file                               217460
     C                   EXSR      VMCKRL                                                     217460
      *                                                                                       217460
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(40)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Print Schedule Types
     C                   EXSR      VGCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(31)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Midas Branch codes
     C                   EXSR      VHCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(32)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Correspondent Structure
     C                   EXSR      VICKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(39)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Midas Location Codes
     C                   EXSR      VJCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(34)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Midas Currency Codes
     C                   EXSR      VKCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I3(31)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Midas Account
     C                   EXSR      VLCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I3(39)
     C                   SETON                                        99        *
     C                   END
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs   R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG0010DSFF
      * USER: Validate detail screen relations
      * EDTRCD: Detail scrn rels - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Screen Relns
     C/COPY WNCPYSRC,CG0010DVSR
      *
      * Validate Midas information
      *
     C                   EXSR      SRMINF
      *
      * Validate Correspondent Set Up
      *
     C                   EXSR      SRCORR
      *
      * Validate Address information
      *
     C                   EXSR      SRADDR
      *
      * Validate Default Print information
      *
     C                   EXSR      SRDPRT
      *
      * Validate Other information
      *
     C                   EXSR      SROINF
      *
      * Validate Charge information
      *
     C                   EXSR      SRCINF
      *
      * Cross Validations
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRXVAL
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRMINF   : Validate Midas Information                        *
      *                                                               *
      *================================================================
     CSR   SRMINF        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMINF'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0010MINF
      *
      *  Set up map for valid combinations
      *
     C                   MOVEL     *BLANKS       ##005             5
     C     #1CUST        IFEQ      *BLANK                                       IF
     C                   MOVEL     'N'           ##005
     C                   ELSE                                                   FI
     C                   MOVEL     'Y'           ##005
     C                   END                                                    FI
      *
     C     #1CPNC        IFEQ      *BLANK                                       IF
     C     'N'           CAT       ##005:0       ##005
     C                   ELSE                                                   FI
     C     'Y'           CAT       ##005:0       ##005
     C                   END                                                    FI
      *
     C     #1BRCA        IFEQ      *BLANK                                       IF
     C     'N'           CAT       ##005:0       ##005
     C                   ELSE                                                   FI
     C     'Y'           CAT       ##005:0       ##005
     C                   END                                                    FI
      *
     C     #1BICC        IFEQ      *BLANK                                       IF
     C     'N'           CAT       ##005:0       ##005
     C                   ELSE                                                   FI
     C     'Y'           CAT       ##005:0       ##005
     C                   END                                                    FI
      *
     C     #1BICB        IFEQ      *BLANK                                       IF
     C     'N'           CAT       ##005:0       ##005
     C                   ELSE                                                   FI
     C     'Y'           CAT       ##005:0       ##005
     C                   END                                                    FI
      *
      *  Check valid combinations
      *
     C     ##005         IFNE      'NNNNN'                                      IF
     C     ##005         ANDNE     'NNNNY'                                      IF
     C     ##005         ANDNE     'NNNYN'                                      IF
     C     ##005         ANDNE     'NNYNN'                                      IF
     C     ##005         ANDNE     'NYNNN'                                      IF
     C     ##005         ANDNE     'YYNNN'                                      IF
     C                   SETON                                        99        *
      * Send message 'Invalid combination'
     C                   MOVEL     'CGD1174'     ZAMSID
     C                   EXSR      ZASNMS
      *
      * Set highlight depending on fields shown.
      *
      * Customer Number        SD required
     C     #1CUST        IFNE      *BLANK                                       IF
     C                   MOVEL     '1'           @I1(31)
     C                   END                                                    FI
      * Counterparty Nostro Code required
     C     #1CPNC        IFNE      *BLANK                                       IF
     C                   MOVEL     '1'           @I1(32)
     C                   END                                                    FI
      * Branch Code required
     C     #1BRCA        IFNE      *BLANK                                       IF
     C                   MOVEL     '1'           @I1(33)
     C                   END                                                    FI
      * BIC (Bank, Country, & Loc required
     C     #1BICC        IFNE      *BLANK                                       IF
     C                   MOVEL     '1'           @I1(34)
     C                   END                                                    FI
      * BIC (Branch Code) required
     C     #1BICB        IFNE      *BLANK                                       IF
     C                   MOVEL     '1'           @I1(35)
     C                   END                                                    FI
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXMINF        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRCORR   : Validate Correspondent Set Up                     *
      *                                                               *
      *================================================================
     CSR   SRCORR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCORR'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0010CORR
      *
      * Correspondent Name required
      *
     C     #1CORN        IFEQ      *BLANK                                       IF
     C                   MOVEL     '1'           @I1(36)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1175'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Correspondent type required
      *
     C     #1CTYP        IFEQ      *BLANK                                       IF
     C                   MOVEL     '1'           @I1(37)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Relationship type required
      *
     C     #1RTYP        IFNE      'D'                                          IF
     C     #1RTYP        ANDNE     'B'
     C     #1RTYP        ANDNE     'C'
     C     #1RTYP        ANDNE     'S'
     C     #1RTYP        ANDNE     'N'
     C     #1RTYP        ANDNE     'L'
     C     #1RTYP        ANDNE     'T'                                                         08270
     C                   MOVEL     '1'           @I1(38)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1168'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Structure Type required
      *
     C     #1CSTR        IFEQ      *BLANK                                       IF
     C                   MOVEL     '1'           @I1(39)
     C                   SETON                                        99        *
      *
      * Send message '*Value required'
      *
     C                   MOVEL     'CGD1177'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXCORR        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRADDR   : Validate Address Fields                           *
      *                                                               *
      *================================================================
     CSR   SRADDR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRADDR'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0010ADDR
      * For Attention of required
      * Address Line 5
      * Address Line 6
      * address line 7
      * address line 8
      * ZIP code
      *
      *  Unwind subroutine stack name
      *
     C     EXADDR        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRDPRT   : Validate Default Print Information                *
      *                                                               *
      *================================================================
     CSR   SRDPRT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDPRT'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0010DPRT
      *
      * Default print day number required
      *
     C     #SDYNB        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SDYNB        ZFIELD
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      0             ZADEC             1 0          I:No Of Decs
     C                   PARM      2             ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(33)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1426'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1DYNB
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1DYNB
     C                   END                                                    FI
      *
      * Validate Default Print Date
      *
     C     #SDPDT        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C***********          MOVE #SDPDT    ZDATE                                               095468
      *
     C     DIGITS        CHECK     #SDPDT                                 90
      *
      * Check to see if field is numeric
      *
     C     *IN90         IFEQ      '1'                                          IF
     C                   MOVEL     '1'           @I2(35)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1443'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
      * Validate as a date
      *
     C                   MOVE      #SDPDT        ZDATE                                        095468
     C                   CALL      'ZDATE1'                                     Entry parameter
     C                   PARM      *BLANKS       ZERR              7            error code (Z r
     C                   PARM                    ZDATE             6 0          Value date
     C**********           PARM           ZDATFM  1                             Date format  245085
     C                   PARM      WUDFF         ZDATFM            1            Date format  245085
     C                   PARM                    ZDAYNO            5 0          Value date
      *
      * Check to see if field is a valid date
      *
     C     ZERR          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(35)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1444'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   Z-ADD     ZDAYNO        #1DPDT
     C                   END                                                    FI
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1DPDT
     C                   END                                                    FI
      *
      * Validate Default Retention period
      *
     C     #SDRET        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SDRET        ZFIELD
     C/COPY WNCPYSRC,CG0010C005
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      0             ZADEC             1 0          I:No Of Decs
     C**********           PARM 2         ZADIG   20                            I:No Of Digit 117207
     C                   PARM      4             ZADIG             2 0          I:No Of Digit 117207
     C                   PARM                    ZAFLD            16            O:Check Field
     C/COPY WNCPYSRC,CG0010C006
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(36)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1441'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1DRET
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1DRET
     C                   END                                                    FI
      *
      * Print Address Label required
      * (it will default to 'N' if it is left blank)                                          116605
      *                                                                                       116605
     C     #1PLAB        IFEQ      *BLANK                                       IF            116605
     C                   MOVEL     'N'           #1PLAB                                       116605
     C                   ENDIF                                                  FI            116605
      *
     C     #1PLAB        IFNE      'Y'                                          IF
     C     #1PLAB        ANDNE     'N'                                          IF
     C                   MOVEL     '1'           @I2(37)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1425'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Validate Activation date
      *
      *
      * Check to see if field is a valid date
      *
      * Must be entered
      *
     C     #SATDT        IFEQ      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1447'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
     C     #SATDT        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C***********          MOVE #SATDT    ZDATE
      *
     C     DIGITS        CHECK     #SATDT                                 90
      *
      * Check to see if field is numeric
      *
     C     *IN90         IFEQ      '1'                                          IF
     C                   MOVEL     '1'           @I2(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1445'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
      * Validate as a date
      *
     C                   MOVE      #SATDT        ZDATE
     C                   CALL      'ZDATE1'                                     Entry parameter
     C                   PARM      *BLANKS       ZERR              7            error code (Z r
     C                   PARM                    ZDATE             6 0          Value date
     C**********           PARM           ZDATFM  1                             Date format   245085
     C                   PARM      WUDFF         ZDATFM            1            Date format   245085
     C                   PARM                    ZDAYNO            5 0          Value date
      *
      * Check to see if field is a valid date
      *
     C     ZERR          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1446'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   Z-ADD     ZDAYNO        #1ATDT
     C                   END                                                    FI
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1ATDT
     C                   END                                                    FI
      *
      * Validate De-Activation Date
      *
     C     #SDADT        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C***********          MOVE #SDADT    ZDATE
      *
     C     DIGITS        CHECK     #SDADT                                 90
      *
      * Check to see if field is numeric
      *
     C     *IN90         IFEQ      '1'                                          IF
     C                   MOVEL     '1'           @I2(40)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1448'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
      * Validate as a date
      *
     C                   MOVE      #SDADT        ZDATE
     C                   CALL      'ZDATE1'                                     Entry parameter
     C                   PARM      *BLANKS       ZERR              7            error code (Z r
     C                   PARM                    ZDATE             6 0          Value date
     C**********           PARM           ZDATFM  1                             Date format   245085
     C                   PARM      WUDFF         ZDATFM            1            Date format   245085
     C                   PARM                    ZDAYNO            5 0          Value date
      *
      * Check to see if field is a valid date
      *
     C     ZERR          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(40)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1449'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   Z-ADD     ZDAYNO        #1DADT
     C                   END                                                    FI
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1DADT
     C                   END                                                    FI
      *
      * Description required
      *
     C     #1DESC        IFEQ      *BLANK                                       IF
     C                   MOVEL     '1'           @I2(41)
     C                   SETON                                        99        *
      * Send message '*Value required'
     C                   MOVEL     'CGD1348'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXDPRT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SROINF   : Validate Other Information                        *
      *                                                               *
      *================================================================
     CSR   SROINF        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROINF'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0010OINF
      * Fax Number required
      * Telephone Number required
      * Clearing Reference required
      * Electronic route code required
      * Creation date required
      * Default Mail Shot code required
      *                                                                                       CCG015
      ** If Correspondence Manager Phase 1 Enhancement is switched on,                        CCG015
      ** validate E-mail Address.                                                             CCG015
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C     #1EML         ANDNE     *BLANKS                                                    CCG015
      *                                                                                       CCG015
     C                   CALL      'CG3637'                                                   CCG015
     C                   PARM                    #1EML            60                          CCG015
     C                   PARM                    P@RETN           10                          CCG015
     C                   PARM                    P@TYPE            2                          CCG015
      *                                                                                       CCG015
     C     P@RETN        IFNE      *BLANK                                                     CCG015
     C                   MOVEL     '1'           @I2(47)                                      CCG015
     C                   SETON                                        99                      CCG015
     C                   MOVEL     'CGD2622'     ZAMSID                                       CCG015
     C                   EXSR      ZASNMS                                                     CCG015
     C                   ENDIF                                                                CCG015
     C                   ENDIF                                                                CCG015
      *
      *  Unwind subroutine stack name
      *
     C     EXOINF        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRCINF   : Validate Charge Information                       *
      *                                                               *
      *================================================================
     CSR   SRCINF        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCINF'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0010CINF
      *
      * Validate Post Charges day number
      *
     C     #SPDAY        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SPDAY        ZFIELD
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      0             ZADEC             1 0          I:No Of Decs
     C                   PARM      2             ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I3(36)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1450'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1PDAY
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1PDAY
     C                   END                                                    FI
      *
      * Validate Next Post Date
      *
     C     #SNTDT        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C***********          MOVE #SNTDT    ZDATE                                               095468
      *
     C     DIGITS        CHECK     #SNTDT                                 90
      *
      * Check to see if field is numeric
      *
     C     *IN90         IFEQ      '1'                                          IF
     C                   MOVEL     '1'           @I3(37)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1451'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
      * Validate as a date
      *
     C                   MOVE      #SNTDT        ZDATE                                        095468
     C                   CALL      'ZDATE1'                                     Entry parameter
     C                   PARM      *BLANKS       ZERR              7            error code (Z r
     C                   PARM                    ZDATE             6 0          Value date
     C**********           PARM           ZDATFM  1                             Date format   245085
     C                   PARM      WUDFF         ZDATFM            1            Date format   245085
     C                   PARM                    ZDAYNO            5 0          Value date
      *
      * Check to see if field is a valid date
      *
     C     ZERR          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I3(37)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1452'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   Z-ADD     ZDAYNO        #1NTDT
     C                   END                                                    FI
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1NTDT
     C                   END                                                    FI
      *
      * Apply Charge required
      *
     C     #1ACHG        IFNE      'N'                                          IF
     C     #1ACHG        ANDNE     'Y'                                          IF
     C     #1ACHG        ANDNE     'S'                                          IF
     C     #1ACHG        ANDNE     *BLANKS                                      IF
     C                   MOVEL     '1'           @I3(38)
     C                   SETON                                        99        *
      * Send message '*Value required'
     C                   MOVEL     'CGD1453'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXCINF        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRXVAL   : Validate Cross Validations                        *
      *                                                               *
      *================================================================
     CSR   SRXVAL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRXVAL'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0010XVAL
      *
      *  Check valid combinations with relationship type
      *
     C     ##005         IFEQ      'NNNNN'                                      IF
     C     #1RTYP        ANDNE     'L'
     C     #1RTYP        ANDNE     'D'
     C     #1RTYP        ANDNE     'T'                                                        082705
     C     ##005         OREQ      'NNNNY'                                      IF
     C     #1RTYP        ANDNE     'C'
     C     ##005         OREQ      'NNNYN'                                      IF
     C     #1RTYP        ANDNE     'N'
     C     ##005         OREQ      'NNYNN'                                      IF
     C     #1RTYP        ANDNE     'B'
     C     ##005         OREQ      'NYNNN'                                      IF
     C     #1RTYP        ANDNE     'S'
     C     ##005         OREQ      'YYNNN'                                      IF
     C     #1RTYP        ANDNE     'S'
     C                   MOVEL     '1'           @I1(38)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1179'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
      *
      * Default Print Schedule required
      *
     C     #1DPRT        IFEQ      *BLANK                                       IF
     C     #1RTYP        ANDEQ     'D'
     C                   MOVEL     '1'           @I2(31)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1427'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      **Address*Line*1*required                                                             MD027306
      **Address*Line*2*required**if*not*customer*definition                                 MD027306
      **Address*Line*3*required                                                             MD027306
      **Address*Line*4*required                                                             MD027306
      ** Address Line 1 required for Relationship types of N, S, L                          MD027306
     C/COPY WNCPYSRC,CG0010SO01                                                               086503
      **********                                                                              086503
     C     #1ADD1        IFEQ      *BLANKS
     C********** #1ADD2    OREQ *BLANKS                                                     MD027306
     C********** #1ADD3    OREQ *BLANKS                                                     MD027306
     C********** #1ADD4    OREQ *BLANKS                                                     MD027306
     C     #1RTYP        IFNE      'C'
     C     #1RTYP        ANDNE     'B'
     C     #1RTYP        ANDNE     'D'
     C     #1RTYP        ANDNE     'T'                                                        100927
     C/COPY WNCPYSRC,CG0010C002
     C                   MOVEL     '1'           @I1(42)
     C**********           MOVEL'1'       @I1,43                                            MD027306
     C**********           MOVEL'1'       @I1,44                                            MD027306
     C**********           MOVEL'1'       @I1,45                                            MD027306
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1414'     ZAMSID
     C                   EXSR      ZASNMS
     C/COPY WNCPYSRC,CG0010C003
     C                   END
     C                   END
     C/COPY WNCPYSRC,CG0010EO01                                                               086503
     C/COPY WNCPYSRC,CG0010ADDV                                                               086504
      *
      * Language identifier required
      *
     C     #1LGID        IFEQ      *BLANK                                       IF
     C     #1RTYP        ANDEQ     'D'
     C                   MOVEL     '1'           @I1(40)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1415'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Check that Midas Info not already defined
      *
     C                   SELECT
      * Customer defined
     C     #1CUST        WHENNE    *BLANK
     C     #1CUST        CHAIN     @CORRL4                            90
     C     *IN90         IFEQ      '0'
     C     CDCORR        ANDNE     #1CORR
     C                   MOVEL     '1'           @I1(31)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1416'     ZAMSID
     C                   MOVEL     CDCORR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Counterparty Nostro defined
     C     #1CPNC        WHENNE    *BLANK
     C     #1CPNC        CHAIN     @CORRL5                            90
     C     *IN90         IFEQ      '0'
     C     CDCORR        ANDNE     #1CORR
     C                   MOVEL     '1'           @I1(32)
     C                   SETON                                        99        *
     C                   MOVEL     CDCORR        ZAMSDA
     C                   MOVEL     'CGD1419'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * SWIFT BIC defined
     C     #1BICC        WHENNE    *BLANK
     C     KBIC          KLIST
     C                   KFLD                    #1BICC
     C                   KFLD                    #1BICB
     C     KBIC          CHAIN     @CORRLB                            90
     C     *IN90         IFEQ      '0'
     C     CDCORR        ANDNE     #1CORR
     C                   MOVEA     '11'          @I1(34)
     C                   SETON                                        99        *
     C                   MOVEL     CDCORR        ZAMSDA
     C                   MOVEL     'CGD1420'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Branch defined
     C     #1BRCA        WHENNE    *BLANK
     C     #1BRCA        CHAIN     @CORRL3                            90
     C     *IN90         IFEQ      '0'
     C     CDCORR        ANDNE     #1CORR
     C                   MOVEL     '1'           @I1(33)
     C                   SETON                                        99        *
     C                   MOVEL     CDCORR        ZAMSDA
     C                   MOVEL     'CGD1421'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Default System entry defined
     C     #1RTYP        WHENEQ    'D'
     C     #1BRCA        CHAIN     @CORRL3                            90
     C     *IN90         IFEQ      '0'
     C     CDCORR        ANDNE     #1CORR
     C                   MOVEL     '1'           @I1(38)
     C                   SETON                                        99        *
     C                   MOVEL     CDCORR        ZAMSDA
     C                   MOVEL     'CGD1422'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Correspondent Type Defined                                                            082705
     C     #1RTYP        WHENEQ    'T'                                                        082705
     C***********CDCTYP    CHAIN@CORRLC              90                                082705 086143
     C     #1CTYP        CHAIN     @CORRLC                            90                      086144
     C     *IN90         IFEQ      '0'                                                        082705
     C     CDCORR        ANDNE     #1CORR                                                     082705
     C                   MOVEL     '1'           @I1(37)                                      082705
     C                   SETON                                        99        *             082705
     C                   MOVEL     CDCORR        ZAMSDA                                       082705
     C                   MOVEL     'CGD1797'     ZAMSID                                       082705
     C                   EXSR      ZASNMS                                                     082705
     C                   END                                                    FI            082705
     C                   ENDSL
      * Correspondent external validation
     C                   CLEAR                   CGCOV                                        082944
     C                   MOVE      #1CORR        W0COR1                                       082944
     C                   MOVE      #1CSTR        W0CSTR                                       082944
     C                   MOVE      'C'           W0FIL                                        082944
     C                   MOVE      'A'           W0ACTP                                       082944
     C                   MOVE      ##PGM         W0PGM                                        082944
      *                                                                                       082944
     C                   CALL      'CG0011'      PL0011                 9090                  082944
      *                                                                                       082944
     C     *IN90         IFEQ      '1'                                                        082944
     C                   MOVEL     'CG0011'      W0FILE                                       082944
     C                   MOVEL     '*CALL'       W0KEY                          **************082944
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 05 082944
     C                   MOVEL     'MEM5003'     W0MSGD                         **************082944
     C                   MOVEL     'MIDAS  '     W0MSGF                                       082944
     C                   EXSR      SRERR                                                      082944
     C                   END                                                                  082944
      *                                                                                       082944
     C     P@RTN         IFNE      *BLANKS                                                    082944
     C                   MOVEL     '1'           @I1(31)                                      082944
     C                   SETON                                        99                      082944
     C                   END                                                    FI            082944
      *
      * Validate if default print schedule and day number are valid
      *
      * Day number may only be specified if print schedule defined
      *
     C     #1DPRT        IFEQ      *BLANK                                       IF
     C     #SDYNB        ANDNE     *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(33)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1454'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Check that print schedule is valid
      *
     C     #1DPRT        IFNE      *BLANK                                       IF
      *
      * Call access object to validate frequency specification
      *
     C                   CALL      'CG99FREQ'
     C                   PARM      *BLANKS       O1RTN             7
     C                   PARM      '*VERIFY'     O1ACT             8
     C                   PARM      STFREQ        O1FREQ           10
     C                   PARM      *ZEROS        O1RDNB            5 0
     C                   PARM      #1DYNB        O1MDAY            2 0
     C                   PARM      *BLANKS       O1CCY             3
     C                   PARM      *BLANKS       O1LOC             3
     C                   PARM      *BLANKS       O1EXT           256
      *
     C     O1RTN         IFNE      *BLANK                                       IF
     C                   MOVEL     '1'           @I2(31)
     C                   MOVEL     '1'           @I2(33)
     C                   SETON                                        99        *
     C                   MOVEL     O1RTN         ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Default print date must be greater than or eqaul to today
      *
     C     #1DPRT        IFNE      *BLANK                                       IF
     C                   SELECT
     C     #1DPDT        WHENGT    0
     C     STFREQ        ANDEQ     ##HOLD
     C     #1DPDT        ORGT      0
     C     STFREQ        ANDEQ     ##SPRS
     C     #1DPDT        ORGT      0
     C     STFREQ        ANDEQ     ##IMED
     C                   MOVEL     '1'           @I2(35)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1457'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C     STFREQ        WHENEQ    ##HOLD
     C     STFREQ        OREQ      ##SPRS
     C                   Z-ADD     -1            #1DPDT
      *
     C     STFREQ        WHENEQ    ##IMED
     C                   Z-ADD     0             #1DPDT
      *
     C                   OTHER
     C                   ENDSL                                                  FI
     C                   END
      *
     C     #SDPDT        IFNE      *BLANKS
     C     #1DPDT        ANDLT     WURDNB                                       IF
     C                   MOVEL     '1'           @I2(35)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1465'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       079843
      * Print date is mandatory if schedule input and not SPECIAL                             079843
      *                                                                                       079843
     C     #SDPDT        IFEQ      *BLANKS                                                    079843
     C     #1DPRT        ANDNE     *BLANKS                                      IF            079843
     C     STFREQ        ANDNE     ##HOLD                                                     079843
     C     STFREQ        ANDNE     ##SPRS                                                     079843
     C     STFREQ        ANDNE     ##IMED                                                     079843
     C                   MOVEL     '1'           @I2(35)                                      079843
     C                   SETON                                        99        *             079843
     C                   MOVEL     'CGD1653'     ZAMSID                                       079843
     C                   EXSR      ZASNMS                                                     079843
     C                   END                                                                  079843
      *                                                                                       079843
      * If not frequency then print date must be blank                                        079843
      *                                                                                       079843
     C     #SDPDT        IFNE      *BLANKS                                                    079843
     C     #1DPRT        ANDEQ     *BLANKS                                      IF            079843
     C                   MOVEL     '1'           @I2(35)                                      079843
     C                   SETON                                        99        *             079843
     C                   MOVEL     'CGD1657'     ZAMSID                                       079843
     C                   EXSR      ZASNMS                                                     079843
     C                   END                                                                  079843
      *                                                                                       088575
      * Default retention period is mandatory when correspondent is                           088575
      * SYSTEM.                                                                               088575
      *                                                                                       088575
     C     #1CORR        IFEQ      'SYSTEM'                                                   088575
     C     #SDRET        ANDEQ     *BLANKS                                                    088575
     C                   MOVEL     '1'           @I2(36)                                      088575
     C                   SETON                                        99        *             088575
     C                   MOVEL     'CGD2519'     ZAMSID                                       088575
     C                   EXSR      ZASNMS                                                     088575
     C                   END                                                                  088575
      *
      * Check that activation date greater than creation date
      *
     C     #1ATDT        IFLT      #1CDTE                                       IF
     C                   MOVEL     '1'           @I2(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1455'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Check that de-activation date greater than activation date
      *
     C     #1DADT        IFLT      #1ATDT                                       IF
     C     #1DADT        ANDGT     0
     C                   MOVEA     '11'          @I2(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1456'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Charge Currency required if charge per item specified
      * Charge Currency required if charge not posted specified
      * Charge Currency required if charge account specified
      * Charge Currency required if post charge frequency specified
      *
     C     #1CCCY        IFEQ      *BLANK                                       IF
     C***********#SCITM    ANDEQ*ZERO                      IF                                 086588
     C     #SCITM        ANDNE     *BLANKS                                      IF            086588
     C     #1CCCY        OREQ      *BLANK                                       IF
     C***********#SBSNB    ANDEQ*ZERO                      IF                                 086588
     C     #SBSNB        ANDNE     *BLANKS                                      IF            086588
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #1CACT        ANDNE     *BLANKS                                      IF
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #1CFRQ        ANDNE     *BLANKS                                      IF
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #SPDAY        ANDNE     *BLANKS                                      IF
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #SNTDT        ANDNE     *BLANKS                                      IF
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #1ACHG        ANDNE     *BLANKS                                      IF
     C                   MOVEL     '1'           @I3(31)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1459'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EXXVAL
     C                   END                                                    FI
      *                                                                                       079846
      * Apply Charge required if currency specified                                           079846
      *                                                                                       079846
     C     #1ACHG        IFEQ      *BLANKS                                      IF            079846
     C     #1CCCY        ANDNE     *BLANKS                                      IF            079846
     C                   MOVEL     '1'           @I3(31)                                      079846
     C                   MOVEL     '1'           @I3(38)                                      079846
     C                   SETON                                        99        *             079846
      * Send message '*Value required'                                                        079846
     C                   MOVEL     'CGD1813'     ZAMSID                                       079846
     C                   EXSR      ZASNMS                                                     079846
     C                   END                                                    FI            079846
      *
      * Charge Account must not be specified if apply charge "N"
      * or blank
      *
     C     #1CACT        IFNE      *BLANK                                       IF
     C     #1ACHG        ANDEQ     *BLANK                                       IF
     C     #1CACT        ORNE      *BLANK                                       IF
     C     #1ACHG        ANDEQ     'N'                                          IF
     C                   MOVEL     '1'           @I3(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1460'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Charge Account must be in charge currency
      *
     C     #1CACT        IFNE      *BLANK                                       IF
     C     #1CCCY        ANDNE     CCY                                          IF
     C                   MOVEL     '1'           @I3(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1461'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Next posting date must be greater than or equal to run date
      *
     C     #SNTDT        IFNE      *BLANK                                       IF
     C     #1NTDT        ANDLT     WURDNB                                       IF
     C                   MOVEL     '1'           @I3(37)
     C                   SETON                                        99        *
     C***********          MOVEL'CGD1461' ZAMSID                                              079843
     C                   MOVEL     'CGD1814'     ZAMSID                                        07984
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *                                                                                       079843
      * Post date is mandatory if schedule input                                              079843
      *                                                                                       079843
     C     #SNTDT        IFEQ      *BLANKS                                                    079843
     C     #1CFRQ        ANDNE     *BLANKS                                      IF            079843
     C                   MOVEL     '1'           @I3(37)                                      079843
     C                   SETON                                        99        *             079843
     C                   MOVEL     'CGD1654'     ZAMSID                                       079843
     C                   EXSR      ZASNMS                                                     079843
     C                   END                                                                  079843
      *                                                                                       079843
      * Post date must be blank if no frequency                                               079843
      *                                                                                       079843
     C     #SNTDT        IFNE      *BLANKS                                                    079843
     C     #1CFRQ        ANDEQ     *BLANKS                                      IF            079843
     C                   MOVEL     '1'           @I3(37)                                      079843
     C                   SETON                                        99        *             079843
     C                   MOVEL     'CGD1658'     ZAMSID                                       079843
     C                   EXSR      ZASNMS                                                     079843
     C                   END                                                                  079843
      *                                                                                       079846
      * Day number may only be specified if frequency defined                                 079846
      *                                                                                       079846
     C     #1CFRQ        IFEQ      *BLANK                                       IF            079846
     C     #SPDAY        ANDNE     *BLANKS                                      IF            079846
     C                   MOVEL     '1'           @I3(37)                                      079846
     C                   SETON                                        99        *             079846
     C                   MOVEL     'CGD1664'     ZAMSID                                       079846
     C                   EXSR      ZASNMS                                                     079846
     C                   END                                                    FI            079846
      *
      * Post charge frequency required
      *
     C     #1CFRQ        IFNE      *BLANK                                       IF
      *
      * Call access object to validate frequency specification
      *
     C                   MOVEL     *BLANKS       O1FREQ
     C                   MOVEL     #1CFRQ        O1FREQ
      *
     C                   CALL      'CG99FREQ'
     C                   PARM      *BLANKS       O1RTN             7
     C                   PARM      '*VERIFY'     O1ACT             8
     C                   PARM                    O1FREQ           10
     C                   PARM      *ZEROS        O1RDNB            5 0
     C                   PARM      #1PDAY        O1MDAY            2 0
     C                   PARM      *BLANKS       O1CCY             3
     C                   PARM      *BLANKS       O1LOC             3
     C                   PARM      *BLANKS       O1EXT           256
      *
     C     O1RTN         IFNE      *BLANK                                       IF
     C                   MOVEA     '11'          @I3(35)
     C                   SETON                                        99        *
     C                   MOVEL     O1RTN         ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Charge per item must be numeric
      *
     C     #SCITM        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SCITM        ZFIELD
     C     13            SUB       A6NBDP        ZADIG
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      A6NBDP        ZADEC             1 0          I:No Of Decs
     C                   PARM                    ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I3(32)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1462'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1CITM
     C                   END                                                    FI
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1CITM
     C                   END                                                    FI
      *
      * Charge per item required if charge currency entered
      *
     C     #1CITM        IFLT      1
     C     #1CCCY        ANDNE     *BLANKS                                      IF
     C                   MOVEL     '1'           @I3(32)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1463'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Charge not posted must be numeric
      *
     C     #SBSNB        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SBSNB        ZFIELD
     C     13            SUB       A6NBDP        ZADIG
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      A6NBDP        ZADEC             1 0          I:No Of Decs
     C                   PARM                    ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I3(33)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1464'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1BSNB
     C                   END                                                    FI
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1BSNB
     C                   END                                                    FI
      *
      * Re format charges accumlated to date
      *
     C     CDCACC        IFGT      0
     C     P1ACTC        ANDNE     'I'                                                        079846
     C     #1CCCY        ANDNE     *BLANKS
     C                   Z-ADD     CDCACC        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C                   MOVE      ZOUT21        #SCACC
     C                   ELSE
     C                   MOVEL     *BLANKS       #SCACC
      *
      * Zeroise charges accumlated to date
      *
     C                   Z-ADD     0             #1CACC
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXXVAL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRREFI   : Referential Integrity Check                       *
      *                                                               *
      *================================================================
     CSR   SRREFI        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRREFI'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0010REFI
      *
      *  Call referential integrity check process
      *
     C                   CALL      'CG0170'                             9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      #1CORR        P@CORR           10
     C                   PARM      ##PGM         P@CPGM           10
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'CG0170'      W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  If return code non-blank send message
      *
     C     P@RTCD        IFNE      *BLANK                                       IF
     C                   SETON                                        99        *
      * Send message '*Value required'
     C                   MOVEL     P@RTCD        ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EXREFI
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXREFI        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'                                                        CSC022
     C     WCMTSK        ANDEQ     'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'                                                        CSC022
     C     WCMTSK        ANDEQ     'N'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * EDTRCD: Process cmds - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Command Keys
     C/COPY WNCPYSRC,CG0010DPCK
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'R'           W0RPT
     C                   END
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Correspondent - Correspondent Details  *
     C                   EXSR      SACRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Correspondent - Correspondent Details  *
     C                   EXSR      SCCHRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Correspondent - Correspondent Details  *
     C                   EXSR      SDCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P2CORR        IFEQ      *BLANK                                       Correspondent
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen
     C                   SETON                                        88        *
     C     W0SCR         IFNE      1
     C                   MOVEL     '0'           *IN79
     C                   END
     C     W0SCR         IFNE      2
     C                   MOVEL     '0'           *IN79
     C                   END
     C     W0SCR         IFNE      3
     C                   MOVEL     '0'           *IN79
     C                   MOVEL     '0'           *IN78
     C                   END
     C     W0SCR         IFEQ      1
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'E'                                          *IF
     C     P1ACTC        OREQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   ELSE
     C     W0SCR         IFEQ      2
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'E'                                          *IF
     C     P1ACTC        OREQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   ELSE
     C     W0SCR         IFEQ      3
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'E'                                          *IF
     C     P1ACTC        OREQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   END
     C                   END
     C                   END
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   MOVEL     *BLANK        #1RECI                         Record Identifi
     C                   MOVEL     *BLANK        #1LCCD                         Location Code
     C                   MOVEL     *BLANK        #1EML                          E-mail Addres CCG015
     C                   MOVEL     *BLANK        #1FAX                          Fax Number
     C                   MOVEL     *BLANK        #1TEL                          Telephone Numbe
     C                   MOVEL     *BLANK        #1CREF                         Clearing Refere
     C                   Z-ADD     *ZERO         #1DYNB                         Default print d
     C                   MOVEL     *BLANK        #1DPRT                         Default Print S
     C                   Z-ADD     *ZERO         #1DPDT                         Default Print D
     C                   Z-ADD     *ZERO         #1CDTE                         Creation date
     C                   MOVEL     *BLANK        #1OBRC                         Override Branch
     C                   Z-ADD     *ZERO         #1DRET                         Default Retenti
     C                   MOVEL     *BLANK        #1PLAB                         Print Address L
     C                   Z-ADD     *ZERO         #1ATDT                         Activation Date
     C                   Z-ADD     *ZERO         #1DADT                         De-Activation D
     C                   MOVEL     *BLANK        #1ERT                          Electronic rout
     C                   MOVEL     *BLANK        #1DMSH                         Default Mail Sh
     C                   MOVEL     *BLANK        #1CCCY                         Charge Currency
     C                   Z-ADD     *ZERO         #1CITM                         Charge per item
     C                   Z-ADD     *ZERO         #1BSNB                         Charge Not Post
     C                   Z-ADD     *ZERO         #1CACC                         Charge Accumlat
     C                   MOVEL     *BLANK        #1CFRQ                         Post charge fre
     C                   Z-ADD     *ZERO         #1NTDT                         Next Post Date
     C                   MOVEL     *BLANK        #1ACHG                         Apply Charge
     C                   MOVEL     *BLANK        #1CACT                         Charge Account
     C                   Z-ADD     *ZERO         #1PDAY                         Post Charges da
     C                   MOVEL     *BLANK        #1DESC                         Description
     C                   MOVEL     *BLANK        #1AJOB                         Job name
     C                   MOVEL     *BLANK        #1AUSR                         User name
     C                   Z-ADD     *ZERO         #1ATIM                         Action Time
     C                   MOVEL     *BLANK        #1ARDT                         Action Date
     C                   MOVEL     *BLANK        #1AACT                         Action Type
     C                   Z-ADD     *ZERO         #1RDNB                         Run day number
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     *BLANK        #1CUST                         Customer Number
     C                   MOVEL     *BLANK        #1CPNC                         Counterparty No
     C                   MOVEL     *BLANK        #1BRCA                         Branch Code
     C                   MOVEL     *BLANK        #1BICC                         BIC (Bank, Coun
     C                   MOVEL     *BLANK        #1BICB                         BIC (Branch Cod
     C                   MOVEL     *BLANK        #1CORN                         Correspondent N
     C                   MOVEL     *BLANK        #1CTYP                         Correspondent t
     C                   MOVEL     *BLANK        #1RTYP                         Relationship ty
     C                   MOVEL     *BLANK        #1CSTR                         Structure Type
     C                   MOVEL     *BLANK        #1LGID                         Language identi
     C                   MOVEL     *BLANK        #1FATT                         For Attention o
     C                   MOVEL     *BLANK        #1ADD1                         Address Line 1
     C                   MOVEL     *BLANK        #1ADD2                         Address Line 2
     C                   MOVEL     *BLANK        #1ADD3                         Address Line 3
     C                   MOVEL     *BLANK        #1ADD4                         Address Line 4
     C                   MOVEL     *BLANK        #1ZIP                          ZIP code
     C                   MOVEL     *BLANK        #1ADD5                         Address Line 5
     C                   MOVEL     *BLANK        #1ADD6                         Address Line 6
     C                   MOVEL     *BLANK        #1ADD7                         address line 7
     C                   MOVEL     *BLANK        #1ADD8                         address line 8
      *                                                                                       079846
      * Initialise screen numeric fields                                                      079846
      *                                                                                       079846
     C                   MOVEL     *BLANK        #SDYNB                         Day Number    079846
     C                   MOVEL     *BLANK        #SDPDT                         Print Date    079846
     C                   MOVEL     *BLANK        #SDRET                         Retention Per 079846
     C                   MOVEL     *BLANK        #SCDTE                         Creation Date 079846
     C                   MOVEL     *BLANK        #SATDT                         Activiation D 079846
     C                   MOVEL     *BLANK        #SDADT                         Deactivation  079846
     C                   MOVEL     *BLANK        #SCITM                         Item Charge   079846
     C                   MOVEL     *BLANK        #SBSNB                         Not Posted    079846
     C                   MOVEL     *BLANK        #SCACC                         Accum. To Dat 079846
     C                   MOVEL     *BLANK        #SPDAY                         Post Day Numb 079846
     C                   MOVEL     *BLANK        #SNTDT                         Next Date     079846
      *
      * Fill Command lines and narrative text from messages
      *
     C                   SELECT
      *
      * Insert screen
      *
     C     P1ACTC        WHENEQ    'I'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1130'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys
      *
     C                   MOVEL     'CGD1134'     ##PG1
     C                   MOVEL     'CGD1135'     ##PG2
     C                   MOVEL     'CGD1136'     ##PG3
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1131'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys
      *
     C                   MOVEL     'CGD1134'     ##PG1
     C                   MOVEL     'CGD1135'     ##PG2
     C                   MOVEL     'CGD1136'     ##PG3
      *
      *
      * Amendment screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1132'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys
      *
     C                   MOVEL     'CGD1134'     ##PG1
     C                   MOVEL     'CGD1135'     ##PG2
     C                   MOVEL     'CGD1136'     ##PG3
      *
      *
      * Delete screen
      *
     C     P1ACTC        WHENEQ    'D'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1133'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys and allow delete key
      *
     C                   MOVEL     'CGD1137'     ##PG1
     C                   MOVEL     'CGD1138'     ##PG2
     C                   MOVEL     'CGD1139'     ##PG3
     C                   MOVEL     '1'           *IN77
      *
     C                   ENDSL
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       #ACMD1
     C                   MOVEL     *BLANKS       #BCMD1
     C                   MOVEL     *BLANKS       #CCMD1
      *
      * Function keys page 1
      *
     C     *LIKE         DEFINE    #MSGID        ##PG1
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      ##PG1         #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #ACMD2
      *
      * Function keys page 2
      *
     C     *LIKE         DEFINE    #MSGID        ##PG2
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      ##PG2         #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #BCMD2
      *
      * Function keys page 3
      *
     C     *LIKE         DEFINE    #MSGID        ##PG3
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      ##PG3         #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #CCMD2
      *
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @CORRL1 fields to screen
      *================================================================
     C                   MOVEL     CDRECI        #1RECI                         Record Identifi
     C                   MOVEL     CDLCCD        #1LCCD                         Location Code
     C                   MOVEL     CDEML         #1EML                          E-mail Addres CCG015
     C                   MOVEL     CDFAX         #1FAX                          Fax Number
     C                   MOVEL     CDTEL         #1TEL                          Telephone Numbe
     C                   MOVEL     CDCREF        #1CREF                         Clearing Refere
     C                   Z-ADD     CDDYNB        #1DYNB                         Default print d
     C                   MOVEL     CDDPRT        #1DPRT                         Default Print S
     C                   Z-ADD     CDDPDT        #1DPDT                         Default Print D
     C                   Z-ADD     CDCDTE        #1CDTE                         Creation date
     C                   MOVEL     CDOBRC        #1OBRC                         Override Branch
     C                   Z-ADD     CDDRET        #1DRET                         Default Retenti
     C                   MOVEL     CDPLAB        #1PLAB                         Print Address L
     C                   Z-ADD     CDATDT        #1ATDT                         Activation Date
     C                   Z-ADD     CDDADT        #1DADT                         De-Activation D
     C                   MOVEL     CDERT         #1ERT                          Electronic rout
     C                   MOVEL     CDDMSH        #1DMSH                         Default Mail Sh
     C                   MOVEL     CDCCCY        #1CCCY                         Charge Currency
     C                   Z-ADD     CDCITM        #1CITM                         Charge per item
     C                   Z-ADD     CDBSNB        #1BSNB                         Charge Not Post
     C                   Z-ADD     CDCACC        #1CACC                         Charge Accumlat
     C                   MOVEL     CDCFRQ        #1CFRQ                         Post charge fre
     C                   Z-ADD     CDNTDT        #1NTDT                         Next Post Date
     C                   MOVEL     CDACHG        #1ACHG                         Apply Charge
     C                   MOVEL     CDCACT        #1CACT                         Charge Account
     C                   Z-ADD     CDPDAY        #1PDAY                         Post Charges da
     C                   MOVEL     CDDESC        #1DESC                         Description
     C                   MOVEL     CDAJOB        #1AJOB                         Job name
     C                   MOVEL     CDAUSR        #1AUSR                         User name
     C                   Z-ADD     CDATIM        #1ATIM                         Action Time
     C                   MOVEL     CDARDT        #1ARDT                         Action Date
     C                   MOVEL     CDAACT        #1AACT                         Action Type
     C                   Z-ADD     CDRDNB        #1RDNB                         Run day number
     C                   MOVEL     CDCORR        #1CORR                         Correspondent
     C                   MOVEL     CDCUST        #1CUST                         Customer Number
     C                   MOVEL     CDCPNC        #1CPNC                         Counterparty No
     C                   MOVEL     CDBRCA        #1BRCA                         Branch Code
     C                   MOVEL     CDBICC        #1BICC                         BIC (Bank, Coun
     C                   MOVEL     CDBICB        #1BICB                         BIC (Branch Cod
     C                   MOVEL     CDCORN        #1CORN                         Correspondent N
     C                   MOVEL     CDCTYP        #1CTYP                         Correspondent t
     C                   MOVEL     CDRTYP        #1RTYP                         Relationship ty
     C                   MOVEL     CDCSTR        #1CSTR                         Structure Type
     C                   MOVEL     CDLGID        #1LGID                         Language identi
     C                   MOVEL     CDFATT        #1FATT                         For Attention o
     C                   MOVEL     CDADD1        #1ADD1                         Address Line 1
     C                   MOVEL     CDADD2        #1ADD2                         Address Line 2
     C                   MOVEL     CDADD3        #1ADD3                         Address Line 3
     C                   MOVEL     CDADD4        #1ADD4                         Address Line 4
     C                   MOVEL     CDZIP         #1ZIP                          ZIP code
     C                   MOVEL     CDADD5        #1ADD5                         Address Line 5
     C                   MOVEL     CDADD6        #1ADD6                         Address Line 6
     C                   MOVEL     CDADD7        #1ADD7                         address line 7
     C                   MOVEL     CDADD8        #1ADD8                         address line 8
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *
      * Delete screen
      *
     C     P1ACTC        IFEQ      'D'
     C                   MOVEL     '1'           *IN77
     C                   END
      *
      *  Default Print date
      *
     C     CDDPDT        IFGT      0
     C                   Z-ADD     CDDPDT        W2DAYN                         Creation date
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2DATE        #SDPDT                         Creation date
     C                   ELSE
     C                   MOVEL     *BLANKS       #SDPDT                         Creation date
     C                   END
      *
      *  Format creation date
      *
     C     CDCDTE        IFGT      0
     C                   Z-ADD     CDCDTE        W2DAYN                         Creation date
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2FDAT        #SCDTE                         Creation date
     C                   ELSE
     C                   MOVEL     *BLANKS       #SCDTE                         Creation date
     C                   END
      *
      *  Activation date
      *
     C     CDATDT        IFGT      0
     C                   Z-ADD     CDATDT        W2DAYN
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2DATE        #SATDT
     C                   ELSE
     C                   MOVEL     *BLANKS       #SATDT
     C                   END
      *
      *  De-Activation date
      *
     C     CDDADT        IFGT      0
     C                   Z-ADD     CDDADT        W2DAYN
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2DATE        #SDADT
     C                   ELSE
     C                   MOVEL     *BLANKS       #SDADT
     C                   END
      *
      *  Next Posting  date
      *
     C     CDNTDT        IFGT      0
     C                   Z-ADD     CDNTDT        W2DAYN
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2DATE        #SNTDT
     C                   ELSE
     C                   MOVEL     *BLANKS       #SNTDT
     C                   END
      *
      *  Format default day number
      *
     C     CDDYNB        IFGT      0
     C                   Z-ADD     CDDYNB        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     2             SUBST     ZOUT21:19     #SDYNB
     C                   ELSE
     C                   MOVEL     *BLANKS       #SDYNB
     C                   END
      *
      *  Format default retention period
      *
     C     CDDRET        IFGT      0
     C                   Z-ADD     CDDRET        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
     C/COPY WNCPYSRC,CG0010C007
      *
     C********** 2         SUBSTZOUT21:19 #SDRET                                              117207
     C     4             SUBST     ZOUT21:17     #SDRET                                       117207
     C/COPY WNCPYSRC,CG0010C008
     C                   ELSE
     C                   MOVEL     *BLANKS       #SDRET
     C                   END
      *
      *  Obtain Currency decimal places.
      *
     C     CDCCCY        IFNE      *BLANKS
      *
      *  Format Post day number
      *
     C     CDPDAY        IFGT      0
     C                   Z-ADD     CDPDAY        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     2             SUBST     ZOUT21:19     #SPDAY
     C                   ELSE
     C                   MOVEL     *BLANKS       #SPDAY
     C                   END
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CDCCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      *  Format Charge per item
      *
     C     CDCITM        IFGT      0
     C                   Z-ADD     CDCITM        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     14            SUBST     ZOUT21:7      #SCITM
     C                   ELSE
     C                   MOVEL     *BLANKS       #SCITM
     C                   END
      *
      *  Format Charge not posted
      *
     C     CDBSNB        IFGT      0
     C                   Z-ADD     CDBSNB        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     14            SUBST     ZOUT21:7      #SBSNB
     C                   ELSE
     C                   MOVEL     *BLANKS       #SBSNB
     C                   END
      *
      *  Format Charge accumulated to date
      *
     C     CDCACC        IFGT      0
     C                   Z-ADD     CDCACC        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C                   MOVE      ZOUT21        #SCACC
     C                   ELSE
     C                   MOVEL     *BLANKS       #SCACC
     C                   END
      *
     C                   END
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     P2CORR        #1CORR                         Correspondent
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1130'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONKY
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       #KCMD1
      *
      * Function keys
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1021'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #KCMD2
      * USER: Initialize key screen
      * EDTRCD: Init. key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Key Screen
     C/COPY WNCPYSRC,CG0010DIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Correspondent - Correspondent Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      *                                                                                       CSD015
      ** Clear working variables of old values of Watch List Fields                           CSD015
      *                                                                                       CSD015
     C                   MOVE      *BLANKS       WBCORN           30                          CSD015
     C                   MOVE      *BLANKS       WBADD1           50                          CSD015
     C                   MOVE      *BLANKS       WBADD2           50                          CSD015
     C                   MOVE      *BLANKS       WBADD3           50                          CSD015
     C                   MOVE      *BLANKS       WBADD4           50                          CSD015
     C                   MOVE      *BLANKS       WBADD5           50                          CSD015
     C                   MOVE      *BLANKS       WBADD6           50                          CSD015
     C                   MOVE      *BLANKS       WBADD7           50                          CSD015
     C                   MOVE      *BLANKS       WBADD8           50                          CSD015
     C                   MOVE      *BLANKS       WBZIP            10                          CSD015
     C                   MOVE      *BLANKS       WBFATT           30                          CSD015
      * Move all fields to @CORRL0
     C                   MOVEL     #1CORR        CDCORR                         Correspondent
     C                   MOVEL     'D'           CDRECI                         Record Identifi
     C                   MOVEL     #1CUST        CDCUST                         Customer Number
     C                   MOVEL     #1CPNC        CDCPNC                         Counterparty No
     C                   MOVEL     #1BICC        CDBICC                         BIC (Bank, Coun
     C                   MOVEL     #1BICB        CDBICB                         BIC (Branch Cod
     C                   MOVEL     #1BRCA        CDBRCA                         Branch Code
     C                   MOVEL     #1CTYP        CDCTYP                         Correspondent t
     C                   MOVEL     #1RTYP        CDRTYP                         Relationship ty
     C                   MOVEL     #1LGID        CDLGID                         Language identi
     C                   MOVEL     #1CORN        CDCORN                         Correspondent N
     C                   MOVEL     #1FATT        CDFATT                         For Attention o
     C                   MOVEL     #1ADD1        CDADD1                         Address Line 1
     C                   MOVEL     #1ADD2        CDADD2                         Address Line 2
     C                   MOVEL     #1ADD3        CDADD3                         Address Line 3
     C                   MOVEL     #1ADD4        CDADD4                         Address Line 4
     C                   MOVEL     #1ADD5        CDADD5                         Address Line 5
     C                   MOVEL     #1ADD6        CDADD6                         Address Line 6
     C                   MOVEL     #1ADD7        CDADD7                         address line 7
     C                   MOVEL     #1ADD8        CDADD8                         address line 8
     C                   MOVEL     #1ZIP         CDZIP                          ZIP code
     C                   MOVEL     #1DPRT        CDDPRT                         Default Print S
     C                   Z-ADD     #1DPDT        CDDPDT                         Default Print D
     C                   Z-ADD     WURDNB        CDCDTE                         Creation date
     C                   MOVEL     #1OBRC        CDOBRC                         Override Branch
     C                   Z-ADD     #1DRET        CDDRET                         Default Retenti
     C                   MOVEL     #1PLAB        CDPLAB                         Print Address L
     C                   Z-ADD     #1ATDT        CDATDT                         Activation Date
     C                   Z-ADD     #1DADT        CDDADT                         De-Activation D
     C                   MOVEL     #1CSTR        CDCSTR                         Structure Type
     C                   MOVEL     #1LCCD        CDLCCD                         Location Code
     C                   MOVEL     #1EML         CDEML                          E-mail Addres CCG015
     C                   MOVEL     #1FAX         CDFAX                          Fax Number
     C                   MOVEL     #1TEL         CDTEL                          Telephone Numbe
     C                   MOVEL     #1CREF        CDCREF                         Clearing Refere
     C                   Z-ADD     #1DYNB        CDDYNB                         Default print d
     C                   MOVEL     #1ERT         CDERT                          Electronic rout
     C                   MOVEL     #1DMSH        CDDMSH                         Default Mail Sh
     C                   MOVEL     #1CCCY        CDCCCY                         Charge Currency
     C                   Z-ADD     #1CITM        CDCITM                         Charge per item
     C                   Z-ADD     #1BSNB        CDBSNB                         Charge Not Post
     C                   Z-ADD     #1CACC        CDCACC                         Charge Accumlat
     C                   MOVEL     #1CFRQ        CDCFRQ                         Post charge fre
     C                   Z-ADD     #1NTDT        CDNTDT                         Next Post Date
     C                   MOVEL     #1ACHG        CDACHG                         Apply Charge
     C                   MOVEL     #1CACT        CDCACT                         Charge Account
     C                   Z-ADD     #1PDAY        CDPDAY                         Post Charges da
     C                   MOVEL     #1DESC        CDDESC                         Description
     C                   MOVEL     ##JOB         CDAJOB                         Job name
     C                   MOVEL     ##USR         CDAUSR                         User name
     C                   Z-ADD     ##JTM         CDATIM                         Action Time
     C                   MOVEL     WUMRDT        CDARDT                         Action Date
     C                   MOVEL     'I'           CDAACT                         Action Type
     C                   Z-ADD     WURDNB        CDRDNB                         Run day number
      *
     C     KLCRSA        KLIST
     C                   KFLD                    CDCORR                         Correspondent
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @CORRL0                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1124'     W0RTN             7
      * USER: Processing if Data record already exists
      * Change Correspondent Deta - Correspondent Details  *
     C                   EXSR      SBCHRC
     C                   GOTO      SAEXIT
     C                   END
      *
      ** If watch list checking is applied                                                    CSD015
      *                                                                                       CSD015
     C     CSD015        IFEQ      'Y'                                                        CSD015
     C     W1EWLC        ANDEQ     'Y'                                                        CSD015
      *                                                                                       CSD015
      ** If user is in the main system                                                        CSD015
      *                                                                                       CSD015
     C     CSC011        IFEQ      'N'                                                        CSD015
     C     CSC011        OREQ      'Y'                                                        CSD015
     C     S1MAIN        ANDEQ     LIBR                                                       CSD015
      *                                                                                       CSD015
      ** If any of the watch list fields have been entered                                    CSD015
      *                                                                                       CSD015
     C     #1CORN        IFNE      *BLANKS                                                    CSD015
     C     #1ADD1        ORNE      *BLANKS                                                    CSD015
     C     #1ZIP         ORNE      *BLANKS                                                    CSD015
     C     #1FATT        ORNE      *BLANKS                                                    CSD015
      *                                                                                       CSD015
      ** Initialize Hit Unconfirmed Flag since it will not be used in                         CSD015
      ** Insert and will retain its value after an Ammend transaction                         CSD015
      *                                                                                       CSD015
     C                   MOVE      *BLANKS       WUNCF1                                       CSD015
      *                                                                                       CSD015
     C                   EXSR      SRWTCH                                                     CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      * If CSD012 is ON and Correspondent Authorisation is On write                           CSD012
      * details to Shadow file and Authoristion Log then exit.                                CSD012
     C     CSD012        IFEQ      'Y'                                                        CSD012
     C     SVAL11        ANDEQ     'Y'                                                        CSD012
      *                                                                                       CSD012
     C     KLCRSA        CHAIN     CGCDSHL0                           90                      CSD012
     C     *IN90         IFEQ      *ON                                                        CSD012
     C                   WRITE     CGCDSHD0                             91                    CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     KAULG         CHAIN     SDAULGL3                           90                      CSD012
      *                                                                                       CSD012
      * If record does not exist write details to Authoristion Log                            CSD012
     C     *IN90         IFEQ      *ON                                                        CSD012
     C                   MOVEL     K1CORR        ALKEY                                        CSD012
     C                   MOVEL     FUNCD         ALFUNC                                       CSD012
     C                   MOVE      'I'           ALACTN                                       CSD012
     C                   MOVE      ##USR         ALUSER                                       CSD012
     C                   WRITE     SDAULG3                                                    CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C                   WRITE     @CORRL0                              91      *
     C                   ENDIF
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Correspondent Deta - Correspondent Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CORRL0
     C                   MOVEL     #1CORR        CDCORR                         Correspondent
      *
     C     KLCHSB        KLIST
     C                   KFLD                    CDCORR                         Correspondent
     C     KLCHSB        CHAIN     @CORRL0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *                                                                                       CSD015
      ** Store old values of Watch List Fields for comparison                                 CSD015
      *                                                                                       CSD015
     C                   MOVE      CDCORN        WBCORN                                       CSD015
     C                   MOVE      CDADD1        WBADD1                                       CSD015
     C                   MOVE      CDADD2        WBADD2                                       CSD015
     C                   MOVE      CDADD3        WBADD3                                       CSD015
     C                   MOVE      CDADD4        WBADD4                                       CSD015
     C                   MOVE      CDADD5        WBADD5                                       CSD015
     C                   MOVE      CDADD6        WBADD6                                       CSD015
     C                   MOVE      CDADD7        WBADD7                                       CSD015
     C                   MOVE      CDADD8        WBADD8                                       CSD015
     C                   MOVE      CDZIP         WBZIP                                        CSD015
     C                   MOVE      CDFATT        WBFATT                                       CSD015
      *
      * Move non-key fields to @CORRL0
     C                   MOVEL     'D'           CDRECI                         Record Identifi
     C                   MOVEL     #1CUST        CDCUST                         Customer Number
     C                   MOVEL     #1CPNC        CDCPNC                         Counterparty No
     C                   MOVEL     #1BICC        CDBICC                         BIC (Bank, Coun
     C                   MOVEL     #1BICB        CDBICB                         BIC (Branch Cod
     C                   MOVEL     #1CTYP        CDCTYP                         Correspondent t
     C                   MOVEL     #1RTYP        CDRTYP                         Relationship ty
     C                   MOVEL     #1LGID        CDLGID                         Language identi
     C                   MOVEL     #1CORN        CDCORN                         Correspondent N
     C                   MOVEL     #1FATT        CDFATT                         For Attention o
     C                   MOVEL     #1ADD1        CDADD1                         Address Line 1
     C                   MOVEL     #1ADD2        CDADD2                         Address Line 2
     C                   MOVEL     #1ADD3        CDADD3                         Address Line 3
     C                   MOVEL     #1ADD4        CDADD4                         Address Line 4
     C                   MOVEL     #1ADD5        CDADD5                         Address Line 5
     C                   MOVEL     #1ADD6        CDADD6                         Address Line 6
     C                   MOVEL     #1ADD7        CDADD7                         address line 7
     C                   MOVEL     #1ADD8        CDADD8                         address line 8
     C                   MOVEL     #1ZIP         CDZIP                          ZIP code
     C                   MOVEL     #1DPRT        CDDPRT                         Default Print S
     C                   Z-ADD     #1DPDT        CDDPDT                         Default Print D
     C                   Z-ADD     #1CDTE        CDCDTE                         Creation date
     C                   MOVEL     #1OBRC        CDOBRC                         Override Branch
     C                   Z-ADD     #1DRET        CDDRET                         Default Retenti
     C                   MOVEL     #1PLAB        CDPLAB                         Print Address L
     C                   Z-ADD     #1ATDT        CDATDT                         Activation Date
     C                   Z-ADD     #1DADT        CDDADT                         De-Activation D
     C                   MOVEL     #1CSTR        CDCSTR                         Structure Type
     C                   MOVEL     #1BRCA        CDBRCA                         Branch Code
     C                   MOVEL     #1ERT         CDERT                          Electronic rout
     C                   MOVEL     #1DMSH        CDDMSH                         Default Mail Sh
     C                   MOVEL     #1CCCY        CDCCCY                         Charge Currency
     C                   Z-ADD     #1CITM        CDCITM                         Charge per item
     C                   Z-ADD     #1BSNB        CDBSNB                         Charge Not Post
     C                   Z-ADD     #1CACC        CDCACC                         Charge Accumlat
     C                   MOVEL     #1CFRQ        CDCFRQ                         Post charge fre
     C                   Z-ADD     #1NTDT        CDNTDT                         Next Post Date
     C                   MOVEL     #1ACHG        CDACHG                         Apply Charge
     C                   MOVEL     #1CACT        CDCACT                         Charge Account
     C                   MOVEL     #1DESC        CDDESC                         Description
     C                   MOVEL     ##JOB         CDAJOB                         Job name
     C                   MOVEL     ##USR         CDAUSR                         User name
     C                   Z-ADD     ##JTM         CDATIM                         Action Time
     C                   MOVEL     WUMRDT        CDARDT                         Action Date
     C                   MOVEL     'I'           CDAACT                         Action Type
     C                   Z-ADD     WURDNB        CDRDNB                         Run day number
      *
      ** If watch list checking is applied                                                    CSD015
      *                                                                                       CSD015
     C     CSD015        IFEQ      'Y'                                                        CSD015
     C     W1EWLC        ANDEQ     'Y'                                                        CSD015
      *                                                                                       CSD015
      ** If user is in the main system                                                        CSD015
      *                                                                                       CSD015
     C     CSC011        IFEQ      'N'                                                        CSD015
     C     CSC011        OREQ      'Y'                                                        CSD015
     C     S1MAIN        ANDEQ     LIBR                                                       CSD015
      *                                                                                       CSD015
      ** Access SDCWHTPD to determine Hit Unconfirmed Flag                                    CSD015
      *                                                                                       CSD015
     C     KCWHTL        KLIST                                                                CSD015
     C                   KFLD                    KFUNT             8                          CSD015
     C                   KFLD                    KIDEN            40                          CSD015
     C                   KFLD                    KBRCH             3                          CSD015
      *                                                                                       CSD015
     C                   MOVEL     'CGCORRPD'    KFUNT                                        CSD015
     C                   MOVEL     CDCORR        KIDEN                                        CSD015
     C                   MOVEL     BKMABR        KBRCH                                        CSD015
      *                                                                                       CSD015
     C     KCWHTL        CHAIN     SDCWHTL1                           06                      CSD015
     C     *IN06         IFEQ      '1'                                                        CSD015
     C                   MOVE      *BLANKS       WUNCF1            1                          CSD015
     C                   ELSE                                                                 CSD015
     C     W3UNCF        IFEQ      'Y'                                                        CSD015
     C                   MOVE      'Y'           WUNCF1                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** If any of the watch list fields has changed or if Unconfirmed                        CSD015
      *                                                                                       CSD015
     C     WBCORN        IFNE      CDCORN                                                     CSD015
     C     WBADD1        ORNE      CDADD1                                                     CSD015
     C     WBADD2        ORNE      CDADD2                                                     CSD015
     C     WBADD3        ORNE      CDADD3                                                     CSD015
     C     WBADD4        ORNE      CDADD4                                                     CSD015
     C     WBADD5        ORNE      CDADD5                                                     CSD015
     C     WBADD6        ORNE      CDADD6                                                     CSD015
     C     WBADD7        ORNE      CDADD7                                                     CSD015
     C     WBADD8        ORNE      CDADD8                                                     CSD015
     C     WBZIP         ORNE      CDZIP                                                      CSD015
     C     WBFATT        ORNE      CDFATT                                                     CSD015
     C     WUNCF1        OREQ      'Y'                                                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRWTCH                                                     CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      * If CSD012 is ON and Correspondent Authorisation is On write                           CSD012
      * details to Shadow file and Authoristion Log then exit.                                CSD012
     C     CSD012        IFEQ      'Y'                                                        CSD012
     C     SVAL11        ANDEQ     'Y'                                                        CSD012
      *                                                                                       CSD012
     C     KLCHSB        CHAIN     CGCDSHL0                           90                      CSD012
     C     *IN90         IFEQ      *ON                                                        CSD012
     C                   WRITE     CGCDSHD0                             91                    CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     KAULG         CHAIN     SDAULGL3                           90                      CSD012
      *                                                                                       CSD012
      * If record does not exist write details to Authoristion Log                            CSD012
     C     *IN90         IFEQ      *ON                                                        CSD012
     C                   MOVEL     K1CORR        ALKEY                                        CSD012
     C                   MOVEL     FUNCD         ALFUNC                                       CSD012
     C                   MOVE      'I'           ALACTN                                       CSD012
     C                   MOVE      ##USR         ALUSER                                       CSD012
     C                   WRITE     SDAULG3                                                    CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C                   UPDATE    @CORRL0                              91      *
     C                   ENDIF
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Delete Correspondent - Correspondent Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CORRL0
     C                   MOVEL     #1CORR        CDCORR                         Correspondent
      *
     C     KLCHSC        KLIST
     C                   KFLD                    CDCORR                         Correspondent
     C     KLCHSC        CHAIN     @CORRL0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSC        SETLL     @CORRL0                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before Data update
     C     CSD012        IFEQ      'Y'                                                        CSD012
     C     SVAL11        ANDEQ     'Y'                                                        CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     '*'           CDRECI                         Record Identifi
     C                   ENDIF                                                                CSD012
     C                   MOVEL     ##JOB         CDAJOB                         Job name
     C                   MOVEL     ##USR         CDAUSR                         User name
     C                   Z-ADD     ##JTM         CDATIM                         Action Time
     C                   MOVEL     WUMRDT        CDARDT                         Action Date
     C                   MOVEL     'D'           CDAACT                         Action Type
     C                   Z-ADD     WURDNB        CDRDNB                         Run day number
      *                                                                                       CSD012
      * If CSD012 is ON and Holidays is ON, output                                            CSD012
      * details to Shadow file and Authoristion Log then exit.                                CSD012
     C     CSD012        IFEQ      'Y'                                                        CSD012
     C     SVAL11        ANDEQ     'Y'                                                        CSD012
      *                                                                                       CSD012
     C     KLCHSC        CHAIN     CGCDSHL0                           90                      CSD012
     C     *IN90         IFEQ      *ON                                                        CSD012
     C                   WRITE     CGCDSHD0                             91                    CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     KAULG         CHAIN     SDAULGL3                           90                      CSD012
      *                                                                                       CSD012
      * If record does not exist write details to Authoristion Log                            CSD012
     C     *IN90         IFEQ      *ON                                                        CSD012
     C                   MOVEL     K1CORR        ALKEY                                        CSD012
     C                   MOVEL     FUNCD         ALFUNC                                       CSD012
     C                   MOVE      'D'           ALACTN                                       CSD012
     C                   MOVE      ##USR         ALUSER                                       CSD012
     C                   WRITE     SDAULG3                                                    CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C                   UPDATE    @CORRL0                              91      *
     C                   ENDIF
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Correspondent - Correspondent Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CORRL0
     C                   MOVEL     #1CORR        CDCORR                         Correspondent
      *
     C     KLCHSD        KLIST
     C                   KFLD                    CDCORR                         Correspondent
     C     KLCHSD        CHAIN     @CORRL0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSD        SETLL     @CORRL0                            9091      *
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      *                                                                                       CSD015
      ** Store old values of Watch List Fields for comparison                                 CSD015
      *                                                                                       CSD015
     C                   MOVE      CDCORN        WBCORN                                       CSD015
     C                   MOVE      CDADD1        WBADD1                                       CSD015
     C                   MOVE      CDADD2        WBADD2                                       CSD015
     C                   MOVE      CDADD3        WBADD3                                       CSD015
     C                   MOVE      CDADD4        WBADD4                                       CSD015
     C                   MOVE      CDADD5        WBADD5                                       CSD015
     C                   MOVE      CDADD6        WBADD6                                       CSD015
     C                   MOVE      CDADD7        WBADD7                                       CSD015
     C                   MOVE      CDADD8        WBADD8                                       CSD015
     C                   MOVE      CDZIP         WBZIP                                        CSD015
     C                   MOVE      CDFATT        WBFATT                                       CSD015
      *                                                                                       CSD012
      * If CSD012 is ON and Correspondent Authorisation is ON,                                CSD012
      * save details updating non entered fields                                              CSD012
     C     CSD012        IFEQ      'Y'                                                        CSD012
     C     SVAL11        ANDEQ     'Y'                                                        CSD012
     C                   MOVEL     ##JOB         CDAJOB                         Job name      CSD012
     C                   MOVEL     ##USR         CDAUSR                         User name     CSD012
     C                   Z-ADD     ##JTM         CDATIM                         Action Time   CSD012
     C                   MOVEL     WUMRDT        CDARDT                         Action Date   CSD012
     C                   MOVEL     'A'           CDAACT                         Action Type   CSD012
     C                   Z-ADD     WURDNB        CDRDNB                         Run day numbe CSD012
     C                   MOVE      @1DBRC        #2DBRC                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      * Move non-key fields to @CORRL0
     C                   MOVEL     'D'           CDRECI                         Record Identifi
     C                   MOVEL     #1CUST        CDCUST                         Customer Number
     C                   MOVEL     #1CPNC        CDCPNC                         Counterparty No
     C                   MOVEL     #1BICC        CDBICC                         BIC (Bank, Coun
     C                   MOVEL     #1BICB        CDBICB                         BIC (Branch Cod
     C                   MOVEL     #1BRCA        CDBRCA                         Branch Code
     C                   MOVEL     #1CTYP        CDCTYP                         Correspondent t
     C                   MOVEL     #1RTYP        CDRTYP                         Relationship ty
     C                   MOVEL     #1LGID        CDLGID                         Language identi
     C                   MOVEL     #1CORN        CDCORN                         Correspondent N
     C                   MOVEL     #1FATT        CDFATT                         For Attention o
     C                   MOVEL     #1ADD1        CDADD1                         Address Line 1
     C                   MOVEL     #1ADD2        CDADD2                         Address Line 2
     C                   MOVEL     #1ADD3        CDADD3                         Address Line 3
     C                   MOVEL     #1ADD4        CDADD4                         Address Line 4
     C                   MOVEL     #1ADD5        CDADD5                         Address Line 5
     C                   MOVEL     #1ADD6        CDADD6                         Address Line 6
     C                   MOVEL     #1ADD7        CDADD7                         address line 7
     C                   MOVEL     #1ADD8        CDADD8                         address line 8
     C                   MOVEL     #1ZIP         CDZIP                          ZIP code
     C                   MOVEL     #1DPRT        CDDPRT                         Default Print S
     C                   Z-ADD     #1DPDT        CDDPDT                         Default Print D
     C                   Z-ADD     #1CDTE        CDCDTE                         Creation date
     C                   MOVEL     #1OBRC        CDOBRC                         Override Branch
     C                   Z-ADD     #1DRET        CDDRET                         Default Retenti
     C                   MOVEL     #1PLAB        CDPLAB                         Print Address L
     C                   Z-ADD     #1ATDT        CDATDT                         Activation Date
     C                   Z-ADD     #1DADT        CDDADT                         De-Activation D
     C                   MOVEL     #1CSTR        CDCSTR                         Structure Type
     C                   MOVEL     #1LCCD        CDLCCD                         Location Code
     C                   MOVEL     #1EML         CDEML                          E-mail Addres CSD015
     C                   MOVEL     #1FAX         CDFAX                          Fax Number
     C                   MOVEL     #1TEL         CDTEL                          Telephone Numbe
     C                   MOVEL     #1CREF        CDCREF                         Clearing Refere
     C                   Z-ADD     #1DYNB        CDDYNB                         Default print d
     C                   MOVEL     #1ERT         CDERT                          Electronic rout
     C                   MOVEL     #1DMSH        CDDMSH                         Default Mail Sh
     C                   MOVEL     #1CCCY        CDCCCY                         Charge Currency
     C                   Z-ADD     #1CITM        CDCITM                         Charge per item
     C                   Z-ADD     #1BSNB        CDBSNB                         Charge Not Post
     C                   Z-ADD     #1CACC        CDCACC                         Charge Accumlat
     C                   MOVEL     #1CFRQ        CDCFRQ                         Post charge fre
     C                   Z-ADD     #1NTDT        CDNTDT                         Next Post Date
     C                   MOVEL     #1ACHG        CDACHG                         Apply Charge
     C                   MOVEL     #1CACT        CDCACT                         Charge Account
     C                   Z-ADD     #1PDAY        CDPDAY                         Post Charges da
     C                   MOVEL     #1DESC        CDDESC                         Description
     C                   MOVEL     ##JOB         CDAJOB                         Job name
     C                   MOVEL     ##USR         CDAUSR                         User name
     C                   Z-ADD     ##JTM         CDATIM                         Action Time
     C                   MOVEL     WUMRDT        CDARDT                         Action Date
     C                   MOVEL     'A'           CDAACT                         Action Type
     C                   Z-ADD     WURDNB        CDRDNB                         Run day number
      *
      ** If watch list checking is applied                                                    CSD015
      *                                                                                       CSD015
     C     CSD015        IFEQ      'Y'                                                        CSD015
     C     W1EWLC        ANDEQ     'Y'                                                        CSD015
      *                                                                                       CSD015
      ** If user is in the main system                                                        CSD015
      *                                                                                       CSD015
     C     CSC011        IFEQ      'N'                                                        CSD015
     C     CSC011        OREQ      'Y'                                                        CSD015
     C     S1MAIN        ANDEQ     LIBR                                                       CSD015
      *                                                                                       CSD015
      ** Access SDCWHTPD to determine Hit Unconfirmed Flag                                    CSD015
      *                                                                                       CSD015
     C                   MOVEL     'CGCORRPD'    KFUNT                                        CSD015
     C                   MOVEL     CDCORR        KIDEN                                        CSD015
     C                   MOVEL     BKMABR        KBRCH                                        CSD015
      *                                                                                       CSD015
     C     KCWHTL        CHAIN     SDCWHTL1                           06                      CSD015
     C     *IN06         IFEQ      '1'                                                        CSD015
     C                   MOVE      *BLANKS       WUNCF1                                       CSD015
     C                   ELSE                                                                 CSD015
     C     W3UNCF        IFEQ      'Y'                                                        CSD015
     C                   MOVE      'Y'           WUNCF1                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** If any of the watch list fields has changed or if Unconfirmed                        CSD015
      *                                                                                       CSD015
     C     WBCORN        IFNE      CDCORN                                                     CSD015
     C     WBADD1        ORNE      CDADD1                                                     CSD015
     C     WBADD2        ORNE      CDADD2                                                     CSD015
     C     WBADD3        ORNE      CDADD3                                                     CSD015
     C     WBADD4        ORNE      CDADD4                                                     CSD015
     C     WBADD5        ORNE      CDADD5                                                     CSD015
     C     WBADD6        ORNE      CDADD6                                                     CSD015
     C     WBADD7        ORNE      CDADD7                                                     CSD015
     C     WBADD8        ORNE      CDADD8                                                     CSD015
     C     WBZIP         ORNE      CDZIP                                                      CSD015
     C     WBFATT        ORNE      CDFATT                                                     CSD015
     C     WUNCF1        OREQ      'Y'                                                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRWTCH                                                     CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      * If CSD012 is ON and Correspondent Authorisation is ON, output                         CSD012
      * details to Shadow file and Authoristion Log then exit.                                CSD012
     C     CSD012        IFEQ      'Y'                                                        CSD012
     C     SVAL11        ANDEQ     'Y'                                                        CSD012
      *                                                                                       CSD012
      * DS @1DBRC now contains data about to be written to shadow file.                       CSD012
     C                   MOVE      @1DBRC        #1DBRC                                       CSD012
      *                                                                                       CSD012
      * If differences between before and after than write to shadow file                     CSD012
      * otherwsie don't.                                                                      CSD012
     C     #1DBRC        IFNE      #2DBRC                                                     CSD012
      *                                                                                       CSD012
     C     KLCHSD        CHAIN     CGCDSHL0                           90                      CSD012
     C     *IN90         IFEQ      *ON                                                        CSD012
     C                   WRITE     CGCDSHD0                             91                    CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      * If record does not exist write details to Authoristion Log                            CSD012
     C     KAULG         CHAIN     SDAULGL3                           90                      CSD012
     C     *IN90         IFEQ      *ON                                                        CSD012
     C                   MOVEL     K1CORR        ALKEY                                        CSD012
     C                   MOVEL     FUNCD         ALFUNC                                       CSD012
     C                   MOVE      'A'           ALACTN                                       CSD012
     C                   MOVE      ##USR         ALUSER                                       CSD012
     C                   WRITE     SDAULG3                                                    CSD012
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ELSE                                                                 CSD012
      *                                                                                       CSD012
     C                   UPDATE    @CORRL0                              91      *
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C/COPY WNCPYSRC,CG0010C001
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check reference to Midas Customer detail
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1CUST        IFEQ      *BLANK                                       Customer Number
     C                   GOTO      VAEXIT
     C                   END
      *
      * Setup key
     C                   MOVEL     #1CUST        P@CUST                         Customer Number
     C  N99'?'           SCAN      #1CUST                                 99
      *
      *  Call to access pgm for Customer details
      *
     C                   CALL      'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@CUST           10
     C                   PARM      *BLANKS       P@KYST            7
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCUSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     BBCUST        #1CUST
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Send message 'Midas Customer det NF'
     C                   MOVEL     'CGD1275'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1275'     W0RTN
      *================================================================
     CSR   VAEXIT        ENDSR
     C/COPY WNCPYSRC,CG0010C004
      /EJECT
     CSR   VBCKRL        BEGSR
      *================================================================
      * Check reference to Midas Counterparty No
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1CPNC        IFEQ      *BLANK                                       Counterparty No
     C                   GOTO      VBEXIT
     C                   END
      *
      * Setup key
     C                   MOVEL     #1CPNC        P@CPNC                         Counterparty No
     C  N99'?'           SCAN      #1CPNC                                 99
      *
      *  Call to access pgm for Counterparty Nostro Details
      *
     C                   CALL      'AOCNSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD                         B:Return code
     C                   PARM      '*KEY'        P@OPTN                         I:Option
     C                   PARM                    P@CPNC            8            I:Key field
     C     SDCNST        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCNSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     3             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     AWCPNC        #1CPNC                         Counterparty No
     C                   GOTO      VBEXIT
     C                   END
      * Send message 'Midas Counterparty NF'
     C                   MOVEL     'CGD1276'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1276'     W0RTN
      *================================================================
     CSR   VBEXIT        ENDSR
      /EJECT
     CSR   VCCKRL        BEGSR
      *================================================================
      * Check reference to BIC Directory
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1BICC        IFEQ      *BLANK                                       Counterparty No
     C     #1BICB        ANDEQ     *BLANK                                       Counterparty No
     C     CFT007        OREQ      'N'                                                      MD029030
     C                   GOTO      VCEXIT
     C                   END
      *
      * Setup key
     C                   MOVEL     #1BICC        W9BICC                         BIC (Bank, Coun
     C                   MOVEL     #1BICB        W9BICB                         BIC (Branch Cod
      *
      *  Call to access pgm for BIC Information
      *
     C                   CALL      'ME1400'                             9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM                    W9BICC            8
     C                   PARM                    W9BICB            3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST            1
     C                   PARM      *BLANKS       W9CNST            1
     C                   PARM      *BLANKS       W9BICD            1
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ME1400'      W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 04 *
     C                   Z-ADD     4             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     W9BICD        ANDEQ     'Y'
      * Record found - move back any virtuals
     C                   MOVEL     BDBICC        #1BICC                         BIC (Bank, Coun
     C                   MOVEL     BDBICB        #1BICB                         BIC (Branch Cod
     C                   GOTO      VCEXIT
     C                   END
      * Send message 'BIC Directory          NF'
     C                   MOVEL     'CGD1277'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1277'     W0RTN
      *================================================================
     CSR   VCEXIT        ENDSR
      /EJECT
     CSR   VDCKRL        BEGSR
      *================================================================
      * Check reference to Midas Branch codes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1BRCA        IFEQ      *BLANK                                       Branch Code
     C                   GOTO      VDEXIT
     C                   END
      *
      * Setup key
     C                   MOVEL     #1BRCA        P@BRCA                         Branch
     C  N99'?'           SCAN      #1BRCA                                 99
      *
      *  Call to access pgm for Customer details
      *
     C**********           CALL 'AOBRCHR0'             9090                                   CGL029
     C                   CALL      'AOBRCHR1'                           9090                  CGL029
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@BRCA            3
     C     SDBRCH        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOBRCHR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     A8BRCD        #1BRCA                         Branch
     C                   GOTO      VDEXIT
     C                   END
      * Send message 'Midas Branch codes NF'
     C                   MOVEL     'CGD1278'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1278'     W0RTN
      *================================================================
     CSR   VDEXIT        ENDSR
      /EJECT
     CSR   VECKRL        BEGSR
      *================================================================
      * Check reference to Correspondent Type
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1CTYP        IFEQ      *BLANK                                       Correspondent t
     C                   GOTO      VEEXIT
     C                   END
      *
      * Check for selection
      *
     C     ' ?'          CHECK     #1CTYP                                 90
     C     *IN90         IFEQ      '0'
     C     #1CTYP        ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       O3PARM
     C                   CALL      'CG0040'                             9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      'S'           O3ACTC            1            Action Code
     C                   PARM                    O3PARM                         B:RDE
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found
     C                   MOVEL     O3CTYP        #1CTYP
      *
      * Delay
      *
     C                   MOVEL     '1'           *IN99
     C                   GOTO      VEEXIT
     C                   END
      *
     C                   END
      *
     C     KLVDCT        KLIST
     C                   KFLD                    CTCTYP                         Correspondent t
      * Setup key
     C                   MOVEL     #1CTYP        CTCTYP                         Correspondent t
     C     KLVDCT        CHAIN     @CTYPL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VEEXIT
     C                   END
      * Send message 'Correspondent Type     NF'
     C                   MOVEL     'CGD1279'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1279'     W0RTN
      *================================================================
     CSR   VEEXIT        ENDSR
      /EJECT
     CSR   VFCKRL        BEGSR
      *================================================================
      * Check reference to Midas SD Languages co
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1LGID        IFEQ      *BLANK                                       Language identi
     C                   GOTO      VFEXIT
     C                   END
      * Setup key
     C                   MOVEL     #1LGID        P@LGID                         Language identi
      *
      *  Call to access pgm for Counterparty Nostro Details
      *
     C                   CALL      'AOLANGR0'                           9090
     C                   PARM      *BLANKS       P@RTCD                         B:Return code
     C                   PARM      '*KEY'        P@OPTN                         I:Option
     C                   PARM                    P@LGID            2            I:Key field
     C     SDLANG        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOLANGR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 06 *
     C                   Z-ADD     6             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     SCUNT         #1LGID                         Language identi
     C                   GOTO      VFEXIT
     C                   END
      * Send message 'Midas SD Languages NF'
     C                   MOVEL     'CGD1280'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1280'     W0RTN
      *================================================================
     CSR   VFEXIT        ENDSR
      /EJECT
     CSR   VGCKRL        BEGSR
      *================================================================
      * Check reference to Print Schedule Types
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1DPRT        IFEQ      *BLANK                                       Print Schedule
     C                   GOTO      VGEXIT
     C                   END
      *
      * Check for selection
      *
     C     ' ?'          CHECK     #1DPRT                                 90
     C     *IN90         IFEQ      '0'
     C     #1DPRT        ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       O4PARM
     C                   CALL      'CG0160'                             9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      'S'           O4ACTC            1            Action Code
     C                   PARM                    O4PARM                         B:RDE
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found
     C                   MOVEL     O4PSCH        #1DPRT
      *
      * Delay
      *
     C                   MOVEL     '1'           *IN99
     C                   GOTO      VGEXIT
     C                   END
      *
     C                   END
      *
     C     KLVFST        KLIST
     C                   KFLD                    STPSCH                         Print Schedule
      * Setup key
     C                   MOVEL     #1DPRT        STPSCH                         Print Schedule
     C     KLVFST        CHAIN     @PSCHL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
      *
      * Schedule must be allowed as a default
      *
     C     STADSC        IFEQ      'N'
     C                   MOVEL     '1'           @I2(31)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1467'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   GOTO      VGEXIT
     C                   END
      * Send message 'Print Schedule Types   NF'
     C                   MOVEL     'CGD1281'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1281'     W0RTN
      *================================================================
     CSR   VGEXIT        ENDSR
      /EJECT
     CSR   VHCKRL        BEGSR
      *================================================================
      * Check reference to Midas Branch codes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1OBRC        IFEQ      *BLANK                                       Branch Code
     C                   GOTO      VHEXIT
     C                   END
      *
      * Setup key
     C                   MOVEL     #1OBRC        P@BRCA                         Branch
     C  N99'?'           SCAN      #1BRCA                                 99
      *
      *  Call to access pgm for Customer details
      *
     C**********           CALL 'AOBRCHR0'             9090                                   CGL029
     C                   CALL      'AOBRCHR1'                           9090                  CGL029
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@BRCA            3
     C     SDBRCH        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOBRCHR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 07 *
     C                   Z-ADD     7             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     A8BRCD        #1OBRC                         Branch
     C                   GOTO      VHEXIT
     C                   END
      * Send message 'Midas Branch codes NF'
     C                   MOVEL     'CGD1278'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1278'     W0RTN
      *================================================================
     CSR   VHEXIT        ENDSR
      /EJECT
     CSR   VICKRL        BEGSR
      *================================================================
      * Check reference to Correspondent Structure
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1CSTR        IFEQ      *BLANK                                       Structure Type
     C                   GOTO      VIEXIT
     C                   END
      *
      * Check for selection
      *
     C     ' ?'          CHECK     #1CSTR                                 90
     C     *IN90         IFEQ      '0'
     C     #1CSTR        ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       O2PARM
     C                   CALL      'CG0060'                             9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      'S'           O2ACTC            1            Action Code
     C                   PARM                    O2PARM                         B:RDE
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found
     C                   MOVEL     O2CSTR        #1CSTR
      *
      * Delay
      *
     C                   MOVEL     '1'           *IN99
     C                   GOTO      VIEXIT
     C                   END
      *
     C                   END
      *
     C     KLVGCS        KLIST
     C                   KFLD                    CSCSTR                         Structure Type
      * Setup key
     C                   MOVEL     #1CSTR        CSCSTR                         Structure Type
     C     KLVGCS        CHAIN     @CSTRL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VIEXIT
     C                   END
      * Send message 'Correspondent Structur NF'
     C                   MOVEL     'CGD1282'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1282'     W0RTN
      *================================================================
     CSR   VIEXIT        ENDSR
      /EJECT
     CSR   VJCKRL        BEGSR
      *================================================================
      * Check reference to Midas Location Codes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1LCCD        IFEQ      *BLANK                                       Location Code
     C                   GOTO      VJEXIT
     C                   END
      *
      * Setup key
     C                   MOVEL     #1LCCD        P@LCCD                         Location
     C  N99'?'           SCAN      #1LCCD                                 99
      *
      *  Call to access pgm for Location details
      *
     C                   CALL      'AOLOCNR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@LCCD            3
     C     SDLOCN        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOLOCNR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 08 *
     C                   Z-ADD     8             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     DVLCCD        #1LCCD                         Location
     C                   GOTO      VJEXIT
     C                   END
      * Send message 'Midas Location Cod NF'
     C                   MOVEL     'CGD1283'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1283'     W0RTN
      *================================================================
     CSR   VJEXIT        ENDSR
      /EJECT
     CSR   VKCKRL        BEGSR
      *================================================================
      * Check reference to Midas Currency Codes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1CCCY        IFEQ      *BLANK                                       Currency Code
     C                   GOTO      VKEXIT
     C                   END
      *
      * Setup key
     C                   MOVEL     #1CCCY        P@CYCD                         Location
     C  N99'?'           SCAN      #1CCCY                                 99
      *
      *  Call to access pgm for Currency details
      *
     C                   CALL      'AOCURRR0'                           9090    *1
     C                   PARM      *BLANKS       P@RTCD            7            *1
     C                   PARM      '*KEY   '     P@OPTN            7            *1
     C                   PARM                    P@CYCD            3            *1
     C     SDCURR        PARM      *BLANK        DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCURRR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 09 *
     C                   Z-ADD     9             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     A6CYCD        #1CCCY                         Location
     C                   GOTO      VKEXIT
     C                   END
      * Send message 'Midas Currency Cod NF'
     C                   MOVEL     'CGD1284'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1284'     W0RTN
      *================================================================
     CSR   VKEXIT        ENDSR
      /EJECT
     CSR   VLCKRL        BEGSR
      *================================================================
      * Check reference to Charge Account
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1CACT        IFEQ      *BLANK                                       Account Code
     C                   GOTO      VLEXIT
     C                   END
      *
      * Setup key
     C     6             SUBST     #1CACT:1      P@CNUM
     C     3             SUBST     #1CACT:7      P@CUCD
     C     10            SUBST     #1CACT:10     P@ACCD                                       CGL029
     C     2             SUBST     #1CACT:20     P@ACSQ                                       CGL029
     C     3             SUBST     #1CACT:22     P@BRCA                                       CGL029
     C********** 4         SUBST#1CACT:10 P@ACCD                                              CGL029
     C********** 2         SUBST#1CACT:14 P@ACSQ                                              CGL029
     C********** 3         SUBST#1CACT:16 P@BRCA                                              CGL029
      *
      *  Call to access pgm for Accounts
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C**********           PARM           P@ACCD  4        I:Key field 3                      CGL029
     C                   PARM                    P@ACCD           10                          CGL029
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5 S01117
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 10 *
     C                   Z-ADD     10            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVE      *BLANKS       ##ACCT                                       CGL029
     C                   MOVE      CNUM          WCNUM                                        CGL029
     C                   MOVE      CCY           WCCY                                         CGL029
     C                   MOVE      ACOD          WACOD                                        CGL029
     C                   MOVE      ACSQ          WACSQ                                        CGL029
     C     ##ACCT        CAT       BRCA          #1CACT
     C                   GOTO      VLEXIT
     C                   END
      * Send message 'Midas Account code NF'
     C                   MOVEL     'CGD1363'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1363'     W0RTN
      *================================================================
     CSR   VLEXIT        ENDSR
      /EJECT                                                                                  217460
     CSR   VMCKRL        BEGSR                                                                217460
      *================================================================                       217460
      * Check reference to Midas SD Country Code                                              217460
      *================================================================                       217460
     C                   MOVEL     *BLANK        W0RTN             7                          217460
      * If all low order keys not entered, exit                                               217460
     C     #1LGID        IFEQ      *BLANK                                       Language code 217460
     C                   GOTO      VMEXIT                                                     217460
     C                   END                                                                  217460
      * Setup key                                                                             217460
     C                   MOVEL     #1LGID        P@LGID                         Language code 217460
      *                                                                                       217460
      *  Call to access pgm for Country Code details.                                         217460
      *                                                                                       217460
     C                   CALL      'AOCTRYR0'                           9090                  217460
     C                   PARM      *BLANKS       P@RTCD                         B:Return code 217460
     C                   PARM      '*KEY'        P@OPTN                         I:Option      217460
     C                   PARM                    P@LGID            2            I:Key field   217460
     C     SDCTRY        PARM      *BLANKS       DSSDY                                        217460
      *                                                                                       217460
     C     *IN90         IFEQ      '1'                                                        217460
     C                   MOVEL     'AOCTRYR0'    W0FILE                         **************217460
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 06 217460
     C                   Z-ADD     14            W0ERNB                         **************217460
     C                   MOVEL     'MEM5003'     W0MSGD                                       217460
     C                   MOVEL     'MIDAS  '     W0MSGF                                       217460
     C                   EXSR      SRERR                                                      217460
     C                   END                                                                  217460
      *                                                                                       217460
     C     P@RTCD        IFEQ      *BLANKS                                                    217460
      * Record found - move back any virtuals                                                 217460
     C                   MOVEL     A4CNCD        #1LGID                         Language code 217460
     C                   GOTO      VMEXIT                                                     217460
     C                   END                                                                  217460
      * Send message 'Midas SD Languages NF'                                                  217460
     C                   MOVEL     'CGD1280'     ZAMSID                                       217460
     C                   EXSR      ZASNMS                                                     217460
     C                   MOVEL     'CGD1280'     W0RTN                                        217460
      *================================================================                       217460
     CSR   VMEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
      *
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   END                                                    *FI
      * CASE: CTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   END                                                    *FI
      *
      * USER: Exit program processing
      * EDTRCD: Exit program - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,CG0010DEPP
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'                                                        CSC022
     C     WCMTSK        ANDEQ     'N'                                                        CSC022
     C                   ROLBK                                          90
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
      *
      * Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'CGUSRMSG'    ZADFMF           10
      * Define work field Midas run date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
     C                   MOVEL     '0'           *IN77
     C                   MOVEL     *BLANKS       BBIN89
     C                   MOVEL     *BLANKS       CBIN89
      * Open files first time only
     C     W0OPN         IFEQ      *BLANK
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C                   OPEN      CGCORRL0
      * Signal that files are now open
     C                   MOVE      'Y'           W0OPN             1
     C                   END
     C                   MOVEL     'N'           W0PMT             1
      * Initialise error memories
     C                   MOVE      *ZERO         @@I1
     C                   MOVE      *ZERO         @@I2
     C                   MOVE      *ZERO         @@I3
      * Select initial mode
     C     @1NROP        IFEQ      *ZERO
      * Add mode
     C                   MOVEL     'ADD'         W0PMD             3
     C                   ELSE
      * Change mode
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Retrieve Midas Date - R10 Standard Functions  *
     C*
     C*  Set up copyright parameter
     C*
     C                   MOVEA     CPY@          ACT@             80
     C                   CLEAR                   @CORRL0                                      079846
     C*
     C* Get Rundate - Rundate  *
     C*
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   MOVE      'N'           CSC022            1                          CSC022
     C                   MOVE      'N'           WCMTSK            1                          CSC022
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C     PRTCD         IFEQ      *BLANKS                                                    CSC022
     C                   MOVE      'Y'           CSC022                                       CSC022
     C                   MOVE      'N'           WCMTSK                                       CSC022
      *                                                                                       CSC022
     C                   IN        WDSJOB                                                     CSC022
      *                                                                                       CSC022
     C     WCMTNO        IFGT      0                                                          CSC022
     C                   MOVEA     WCJOBS        WCMT                                         CSC022
     C                   Z-ADD     1             I                 2 0                        CSC022
      *                                                                                       CSC022
     C     ##JOB         LOOKUP    WCMT(I)                                51                  CSC022
     C     *IN50         IFEQ      *ON                                                        CSC022
     C                   MOVE      'Y'           WCMTSK                                       CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C                   ELSE                                                                 CSC022
     C     PRTCD         IFNE      '*NRF'                                                     CSC022
     C                   MOVEL     'CSC022'      W0KEY                                        CSC022
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CSC022
     C                   Z-ADD     21            W0ERNB                                       CSC022
     C                   EXSR      SRERR                                                      CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C************NAMVAR   DEFN           WDSJOB                                      CSC022 BUG2330
     C     *DTAARA       DEFINE    SCCMTJOB      WDSJOB                                       CSC022
      *                                                                                       CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                                       CCG015
      ** Determine if Correspondence Manager Phase 1 Development                              CCG015
      ** on iSeries is installed                                                              CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'                                                 CCG015
     C                   PARM      *BLANKS       PRTCD             7                          CCG015
     C                   PARM      '*VERIFY'     POPTN             7                          CCG015
     C                   PARM      'CCG015'      PSARD             6                          CCG015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CCG015
      *                                                                                       CCG015
     C     PRTCD         IFEQ      *BLANKS                                                    CCG015
     C                   MOVE      'Y'           CCG015            1                          CCG015
     C                   MOVE      '1'           *IN80                                        CCG015
     C                   ELSE                                                                 CCG015
     C                   MOVE      'N'           CCG015                                       CCG015
     C                   MOVE      '0'           *IN80                                        CCG015
      *                                                                                       CCG015
     C     PRTCD         IFNE      '*NRF    '                                                 CCG015
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CCG015
     C                   MOVEL(P)  '*CALL'       W0KEY                                        CCG015
     C                   Z-ADD     13            W0ERNB                                       CCG015
     C                   MOVEL     'MEM5003'     W0MSGD                                       CCG015
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG015
     C                   EXSR      SRERR                                                      CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CSD015
      ** Access SAR Details to see if Compliance Watch is installed                           CSD015
      *                                                                                       CSD015
     C                   CALL      'AOSARDR0'                                                 CCG015
     C                   PARM      *BLANKS       PRTCD                                        CCG015
     C                   PARM      '*VERIFY '    POPTN                                        CCG015
     C                   PARM      'CSD015'      PSARD                                        CCG015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CCG015
      *                                                                                       CSD015
     C     PRTCD         IFNE      *BLANKS                                                    CCG015
     C     PRTCD         ANDNE     '*NRF   '                                                  CCG015
     C                   MOVEL     'CSD015'      W0KEY                                        CCG015
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CCG015
     C                   Z-ADD     14            W0ERNB                                       CCG015
     C                   EXSR      SRERR                                                      CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CSD015
      ** If enhancement CSD015 is installed, access SDWLCCPD to                               CSD015
      ** see if 'SDCUSD' function code is available.                                          CSD015
      *                                                                                       CSD015
     C     PRTCD         IFEQ      *BLANKS                                                    CCG015
      *                                                                                       CSD015
     C                   MOVE      'Y'           CSD015            1                          CCG015
      *                                                                                       CSD015
     C                   CALL      'AOWLCCR0'                                                 CCG015
     C                   PARM      *BLANKS       PRTCD                                        CCG015
     C                   PARM      '*KEY    '    POPTN                                        CCG015
     C                   PARM      'CORRECIP'    PFNCCD            8                          CCG015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CCG015
      *                                                                                       CSD015
     C     PRTCD         IFNE      *BLANKS                                                    CCG015
     C     PRTCD         ANDNE     '*NRF'                                                     CCG015
     C                   MOVEL     'CORRECIP'    W0KEY                                        CCG015
     C                   MOVEL     'SDWLCCPD'    W0FILE                                       CCG015
     C                   Z-ADD     15            W0ERNB                                       CCG015
     C                   EXSR      SRERR                                                      CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CSD015
      ** Access SDGELRPD to get the main branch                                               CSD015
      *                                                                                       CSD015
     C**********           CALL 'AOGELRR0'                                             CSD015 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*FIRST'      POPTN                                        CSD015
     C********** SDGELR    PARM SDGELR    DSFDY                                        CSD015 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *                                                                                       CSD015
     C     PRTCD         IFNE      *BLANKS                                                    CSD015
     C                   MOVEL     POPTN         W0KEY                                        CSD015
     C                   MOVEL     'SDGELRPD'    W0FILE                                       CSD015
     C                   Z-ADD     20            W0ERNB                                       CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Access SDCWCDPD to get the 5 'Private Customer Industry Code'                        CSD015
      *                                                                                       CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*FIRST '     POPTN                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
      *                                                                                       CSD015
     C     PRTCD         IFNE      *BLANKS                                                    CSD015
     C                   MOVEL     POPTN         W0KEY                                        CSD015
     C                   MOVEL     'SDCWCDPD'    W0FILE                                       CSD015
     C                   Z-ADD     18            W0ERNB                                       CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Determine if enhancement CSC011 is installed                                         CSD015
      *                                                                                       CSD015
     C                   MOVE      'N'           CSC011            1                          CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*VERIFY '    POPTN                                        CSD015
     C                   PARM      'CSC011'      PSARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
      *                                                                                       CSD015
     C     PRTCD         IFNE      *BLANKS                                                    CSD015
     C     PRTCD         ANDNE     '*NRF   '                                                  CSD015
     C                   MOVEL     'CSC011'      W0KEY                                        CSD015
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CSD015
     C                   Z-ADD     16            W0ERNB                                       CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C     PRTCD         IFEQ      *BLANKS                                                    CSD015
     C                   MOVE      'Y'           CSC011                                       CSD015
     C     *DTAARA       DEFINE                  SC24X7                                       CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Define data area for system prefix                                                   CSD015
      *                                                                                       CSD015
     C     *DTAARA       DEFINE                  SDSTAT                                       CSD015
     C                   IN        SDSTAT                                                     CSD015
      *                                                                                       CSD015
      ** Access SAR Details to see if Concord Interface Development is installed              CSD015
      *                                                                                       CSD015
     C                   MOVE      'N'           CCF001            1                          CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*VERIFY '    POPTN                                        CSD015
     C                   PARM      'CCF001'      PSARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
      *                                                                                       CSD015
     C     PRTCD         IFNE      *BLANKS                                                    CSD015
     C     PRTCD         ANDNE     '*NRF   '                                                  CSD015
     C                   MOVEL     'CCF001'      W0KEY                                        CSD015
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CSD015
     C                   Z-ADD     17            W0ERNB                                       CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C     PRTCD         IFEQ      *BLANKS                                                    CSD015
     C                   MOVE      'Y'           CCF001                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD012
      * Define keylist for SDAULGL2                                                           CSD012
     C     KAULG         KLIST                                                                CSD012
     C                   KFLD                    K1FUNC           21                          CSD012
     C**********           KFLD           K1CORR 20                                    CSD012 CGL029
     C                   KFLD                    K1CORR           26                          CGL029
      *                                                                                       CSD012
      * Check if CSD012 is switched on                                                        CSD012
     C                   CALL      'AOSARDR0'                                                 CSD012
     C                   PARM                    PRTCD             7                          CSD012
     C                   PARM      '*VERIFY'     POPTN             7                          CSD012
     C                   PARM      'CSD012'      PSARD             6                          CSD012
      *                                                                                       CSD012
     C     PRTCD         IFEQ      *BLANKS                                                    CSD012
     C                   MOVE      'Y'           CSD012            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      * Check if Correspondent Authorisation is on                                            CSD012
     C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM      *BLANKS       RTNCDE            7                          CSD012
     C                   PARM                    SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     RTNCDE        IFNE      *BLANKS                                                    CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   MOVEL     'SDSVALR0'    W0FILE                         **************CSD012
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 14 CSD012
     C                   Z-ADD     14            W0ERNB                         **************CSD012
     C                   MOVEL     'MEM5003'     W0MSGD                                       CSD012
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CSD012
     C                   EXSR      SRERR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** Check if CFT007 is switched off                                                    MD029030
      *                                                                                     MD029030
     C                   CALL      'AOSARDR0'                                               MD029030
     C                   PARM                    PRTCD                                      MD029030
     C                   PARM      '*VERIFY'     POPTN                                      MD029030
     C                   PARM      'CFT007'      PSARD                                      MD029030
      *                                                                                     MD029030
     C     PRTCD         IFEQ      *BLANKS                                                  MD029030
     C                   MOVE      'Y'           CFT007            1                        MD029030
     C                   ELSE                                                               MD029030
     C                   MOVE      'N'           CFT007                                     MD029030
     C                   ENDIF                                                              MD029030
      *                                                                                       CCG024
      * Check if CCG024 is switched on                                                        CCG024
     C                   CALL      'AOSARDR0'                                                 CCG024
     C                   PARM                    PRTCD                                        CCG024
     C                   PARM      '*VERIFY'     POPTN                                        CCG024
     C                   PARM      'CCG024'      PSARD                                        CCG024
      *                                                                                       CCG024
     C     PRTCD         IFEQ      *BLANKS                                                    CCG024
     C                   MOVE      'Y'           CCG024            1                          CCG024
     C                   ELSE                                                                 CCG024
     C                   MOVE      'N'           CCG024                                       CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
      * Check System Value RecipientSpecialChar                                               CCG024
     C     CCG024        IFEQ      'Y'                                                        CCG024
      *                                                                                       CCG024
     C                   CALL      'AOSVALR0'                                                 CCG024
     C                   PARM      *BLANKS       RTNCDE            7                          CCG024
     C                   PARM      *BLANKS       SVALK1           20                          CCG024
     C                   PARM                    SVAL1           200                          CCG024
     C                   PARM                    SVALK2           20                          CCG024
     C                   PARM                    SVAL2           200                          CCG024
     C                   PARM      *BLANKS       SVALK3           20                          CCG024
     C                   PARM                    SVAL3           200                          CCG024
     C                   PARM      *BLANKS       SVALK4           20                          CCG024
     C                   PARM                    SVAL4           200                          CCG024
     C                   PARM      *BLANKS       SVALK5           20                          CCG024
     C                   PARM                    SVAL5           200                          CCG024
     C                   PARM      *BLANKS       SVALK6           20                          CCG024
     C                   PARM                    SVAL6           200                          CCG024
     C                   PARM      *BLANKS       SVALK7           20                          CCG024
     C                   PARM                    SVAL7           200                          CCG024
     C                   PARM      *BLANKS       SVALK8           20                          CCG024
     C                   PARM                    SVAL8           200                          CCG024
     C                   PARM      *BLANKS       SVALK9           20                          CCG024
     C                   PARM                    SVAL9           200                          CCG024
     C                   PARM      *BLANKS       SVALK0           20                          CCG024
     C                   PARM                    SVAL10          200                          CCG024
      *                                                                                       CCG024
     C     RTNCDE        IFNE      *BLANKS                                                    CCG024
     C     SVAL2         IFEQ      '*NRF'                                                     CCG024
     C                   MOVE      SVALK2        DBKEY                                        CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C                   MOVEL     'SDSVALR0'    W0FILE                         **************CCG024
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 14 CCG024
     C                   Z-ADD     21            W0ERNB                         **************CCG024
     C                   MOVEL     'MEM5003'     W0MSGD                                       CCG024
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG024
     C                   EXSR      SRERR                                                      CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
      * EDTRCD: Initialise prog - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,CG0010DCPG
      *================================================================
     CSR   ZZEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRWIND   : Control Window Processing                         *
      *                                                               *
      *================================================================
     CSR   SRWIND        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRWIND'      @STK(Q)
      *
      * If window processing call WN0010
      *
     C     BGWDPR        IFEQ      'Y'
      *
      *    /copy to move data into the data structure fields passed
      *     as a parameter to the window controller
      *
      /COPY WNCPYSRC,CG0010MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,CG0010MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,CG0010MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,CG0010MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,CG0010MOV5
     C                   ENDSL
      *
     C                   CALL      'WN0010'                             9190
     C                   PARM      ##PGM         O#PGM            10
     C                   PARM      *BLANKS       O#CMD             2
     C                   PARM      P1ACTC        O#ACTN            1
     C                   PARM                    DATA
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM                    EXTRA           256
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'WN0010'      W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     12            W0ERNB                         * DB ERROR 12 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *   /copy to move data back from the data structure fields passed
      *    as a parameter to the window controller and control user
      *    defined processing.
      *
      /COPY WNCPYSRC,CG0010MOV6
      *
     C     *LIKE         DEFINE    O#RTN         R#RTN
     C     R#RTN         CABEQ     *BLANKS       EXWIND
      *
      *  Check return code and send message on action
      *  - set no update as some action has been specified.
      *
     C                   MOVEL     'Y'           W0DCF
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'                                                        CSC022
     C     WCMTSK        ANDEQ     'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
      *
     C                   SELECT
      *
      * *Return code is *User QUIT requested
      *
     C     R#RTN         WHENEQ    'Y2U9999'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   MOVEL     'Y2U9999'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   EXSR      ZYEXPG
      *
      * *Return code is WN Window Error
      *
     C     R#RTN         WHENEQ    'USR0563'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
      * *Return code is *DBF update error
      *
     C     R#RTN         WHENEQ    'USR0567'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
      * *Return code is *Previous Screen
      *
     C***********R#RTN*****WHEQ 'USR0790'                                                     115722
     C*********************MOVEL'CGD1001' ZAMSID                                              115722
     C*********************EXSR ZASNMS                                                        115722
     C                   ENDSL
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXWIND        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWTCH - Subroutine that will call the watch list checking    *                       CSD015
      *          engine for Compliance Watch and format the watch     *                       CSD015
      *          list fields.                                         *                       CSD015
      * Called by: SACRRC (before writting to CGCORRPD)               *                       CSD015
      *            SBCHRC (before updating CGCORRPD)                  *                       CSD015
      *            SDCHRC (before updating CGCORRPD)                  *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWTCH        BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Set up first parameter for compliance engine                                         CSD015
      *                                                                                       CSD015
     C                   MOVE      *BLANKS       PDSWLT                                       CSD015
      *                                                                                       CSD015
      ** Move zeros to dates and amounts since they will not be used                          CSD015
      *                                                                                       CSD015
     C                   Z-ADD     0             W4DDAT                                       CSD015
     C                   Z-ADD     0             W4VDAT                                       CSD015
     C                   Z-ADD     0             W4MDAT                                       CSD015
     C                   Z-ADD     0             W4AMT1                                       CSD015
     C                   Z-ADD     0             W4AMT2                                       CSD015
      *                                                                                       CSD015
     C                   MOVEL     'CGRECP'      W4ITEM                                       CSD015
     C                   MOVEL     CDCORR        W4IDEN                                       CSD015
     C                   MOVEL     'CGCORRPD'    W4FUNT                                       CSD015
     C                   MOVEL     BKMABR        W4BRCH                                       CSD015
      *                                                                                       CSD015
      ** Get System Prefix from SC24X7 if CSC011 is installed                                 CSD015
      *                                                                                       CSD015
     C     CSC011        IFEQ      'Y'                                                        CSD015
     C                   MOVE      S1MAIN        W4SYSM                                       CSD015
     C                   ELSE                                                                 CSD015
      *                                                                                       CSD015
      ** else, get it from SDSTAT                                                             CSD015
      *                                                                                       CSD015
     C                   MOVE      LIBR          W4SYSM                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Get the counter party name and number by accessing                                   CSD015
      ** the customer details file if CDCUST is not blank                                     CSD015
      *                                                                                       CSD015
     C     CDCUST        IFNE      *BLANKS                                                    CSD015
      *                                                                                       CSD015
     C                   CALL      'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*KEY'        POPTN                                        CSD015
     C                   PARM      CDCUST        PCUST            10                          CSD015
     C                   PARM      *BLANKS       PSTKEY            7                          CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
      *                                                                                       CSD015
     C     PRTCD         IFNE      *BLANKS                                                    CSD015
     C                   MOVEL     CDCUST        W0KEY                                        CSD015
     C                   MOVEL     'SDCUSTPD'    W0FILE                                       CSD015
     C                   Z-ADD     19            W0ERNB                                       CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   MOVEL     BBCRNM        W4CUST                                       CSD015
     C                   MOVE      BBCRTN        W4CUST                                       CSD015
     C                   MOVE      CDCUST        W4CNUM            6                          CSD015
      *                                                                                       CSD015
      ** Get counterparty type depending on CCF001                                            CSD015
      *                                                                                       CSD015
     C     CCF001        IFEQ      'Y'                                                        CSD015
      *                                                                                       CSD015
      ** If corporate customer is 'Y'                                                         CSD015
      *                                                                                       CSD015
     C     BBCRPC        IFEQ      'Y'                                                        CSD015
     C                   MOVE      'C'           W4CTYP            1                          CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVE      'I'           W4CTYP                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ELSE                                                                 CSD015
      *                                                                                       CSD015
      ** If Local Industry Code is not blank and not equal                                    CSD015
      ** to any of the 5 Private Customer Industry Code                                       CSD015
      *                                                                                       CSD015
     C     BBLICD        IFNE      *BLANKS                                                    CSD015
     C     BBLICD        ANDNE     W1IND1                                                     CSD015
     C     BBLICD        ANDNE     W1IND2                                                     CSD015
     C     BBLICD        ANDNE     W1IND3                                                     CSD015
     C     BBLICD        ANDNE     W1IND4                                                     CSD015
     C     BBLICD        ANDNE     W1IND5                                                     CSD015
     C                   MOVE      'C'           W4CTYP                                       CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVE      'I'           W4CTYP                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Set-up second parameter (Customer Alternate Name)                                    CSD015
      *                                                                                       CSD015
     C                   MOVE      *BLANKS       PDSXML                                       CSD015
     C     WBCORN        IFNE      #1CORN                                                     CSD015
     C     WUNCF1        OREQ      'Y'                                                        CSD015
     C     CDCORN        IFNE      *BLANKS                                                    CSD015
     C                   MOVE      *BLANKS       CDCORNV          30
     C                   EVAL      CDCORNV = CDCORN                                         MD056543
     C                   CAT       OPNTAG(1):0   PDSXML                                       CSD015
     C**********         CAT       CDCORN:0      PDSXML                              CSD015 MD056543
     C                   CAT       CDCORNV:0     PDSXML                              CSD015 MD056543
     C                   CAT       CLSTAG(1):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Set-up second parameter (Customer Alternate Address)                                 CSD015
      *                                                                                       CSD015
     C     WBADD1        IFNE      #1ADD1                                                     CSD015
     C     WBADD2        ORNE      #1ADD2                                                     CSD015
     C     WBADD3        ORNE      #1ADD3                                                     CSD015
     C     WBADD4        ORNE      #1ADD4                                                     CSD015
     C     WBADD5        ORNE      #1ADD5                                                     CSD015
     C     WBADD6        ORNE      #1ADD6                                                     CSD015
     C     WBADD7        ORNE      #1ADD7                                                     CSD015
     C     WBADD8        ORNE      #1ADD8                                                     CSD015
     C     WUNCF1        OREQ      'Y'                                                        CSD015
     C                   MOVE      *BLANKS       WADDAL          200                          CSD015
     C**********         CAT       CDADD1:0      WADDAL          200                 CSD015 MD056543
     C**********         CAT       CDADD2:1      WADDAL                              CSD015 MD056543
     C**********         CAT       CDADD3:1      WADDAL                              CSD015 MD056543
     C**********         CAT       CDADD4:1      WADDAL                              CSD015 MD056543
     C**********         CAT       CDADD5:1      WADDAL                              CSD015 MD056543
     C**********         CAT       CDADD6:1      WADDAL                              CSD015 MD056543
     C**********         CAT       CDADD7:1      WADDAL                              CSD015 MD056543
     C**********         CAT       CDADD8:1      WADDAL                              CSD015 MD056543
     C                   MOVE      *BLANKS       CDADD1V          50                        MD056543
     C                   MOVE      *BLANKS       CDADD2V          50                        MD056543
     C                   MOVE      *BLANKS       CDADD3V          50                        MD056543
     C                   MOVE      *BLANKS       CDADD4V          50                        MD056543
     C                   MOVE      *BLANKS       CDADD5V          50                        MD056543
     C                   MOVE      *BLANKS       CDADD6V          50                        MD056543
     C                   MOVE      *BLANKS       CDADD7V          50                        MD056543
     C                   MOVE      *BLANKS       CDADD8V          50                        MD056543
      *                                                                                     MD056543
     C                   EVAL      CDADD1V = CDADD1                                         MD056543
     C                   EVAL      CDADD2V = CDADD2                                         MD056543
     C                   EVAL      CDADD3V = CDADD3                                         MD056543
     C                   EVAL      CDADD4V = CDADD4                                         MD056543
     C                   EVAL      CDADD5V = CDADD5                                         MD056543
     C                   EVAL      CDADD6V = CDADD6                                         MD056543
     C                   EVAL      CDADD7V = CDADD7                                         MD056543
     C                   EVAL      CDADD8V = CDADD8                                         MD056543
      *                                                                                     MD056543
     C                   CAT       CDADD1V:0     WADDAL                                     MD056543
     C                   CAT       CDADD2V:1     WADDAL                                     MD056543
     C                   CAT       CDADD3V:1     WADDAL                                     MD056543
     C                   CAT       CDADD4V:1     WADDAL                                     MD056543
     C                   CAT       CDADD5V:1     WADDAL                                     MD056543
     C                   CAT       CDADD6V:1     WADDAL                                     MD056543
     C                   CAT       CDADD7V:1     WADDAL                                     MD056543
     C                   CAT       CDADD8V:1     WADDAL                                     MD056543
      *                                                                                     MD056543
     C     WADDAL        IFNE      *BLANKS                                                    CSD015
     C                   CAT       OPNTAG(2):0   PDSXML                                       CSD015
     C                   CAT       WADDAL:0      PDSXML                                       CSD015
     C                   CAT       CLSTAG(2):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Set-up second parameter (Zip Code)                                                   CSD015
      *                                                                                       CSD015
     C     WBZIP         IFNE      #1ZIP                                                      CSD015
     C     WUNCF1        OREQ      'Y'                                                        CSD015
     C     CDZIP         IFNE      *BLANKS                                                    CSD015
     C                   CAT       OPNTAG(3):0   PDSXML                                       CSD015
     C                   CAT       CDZIP:0       PDSXML                                       CSD015
     C                   CAT       CLSTAG(3):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Set-up second parameter (For Attention of)                                           CSD015
      *                                                                                       CSD015
     C     WBFATT        IFNE      #1FATT                                                     CSD015
     C     WUNCF1        OREQ      'Y'                                                        CSD015
     C     CDFATT        IFNE      *BLANKS                                                    CSD015
     C                   CAT       OPNTAG(4):0   PDSXML                                       CSD015
     C                   CAT       CDFATT:0      PDSXML                                       CSD015
     C                   CAT       CLSTAG(4):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Call Watch List Engine Program                                                       CSD015
      *                                                                                       CSD015
     C     PDSXML        IFNE      *BLANKS                                                    CSD015
     C                   CALL      'SDWLCLOP'                                                 CSD015
     C                   PARM                    PDSWLT                                       CSD015
     C                   PARM                    PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      ****************************************************************                        CSD015
     C/EJECT
     C*
     C* File and Program Error Processing
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
     O*EDTRCD: Cpysrc Templates Initialise Program O-spec
     O/COPY WNCPYSRC,CG0010DOPG
**  CPY@
(c) Finastra International Limited 2001
** OPNTAG                                                                                     CSD015
<Recipient Name>                                                                              CSD015
<Recipient Address Lines>                                                                     CSD015
<Zip Code>                                                                                    CSD015
<For Attention of>                                                                            CSD015
** CLSTAG                                                                                     CSD015
</Recipient Name>                                                                             CSD015
</Recipient Address Lines>                                                                    CSD015
</Zip Code>                                                                                   CSD015
</For Attention of>                                                                           CSD015
