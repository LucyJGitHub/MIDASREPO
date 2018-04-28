     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Invalid Repo delivery detail repair')         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPDMRPR - REPO DELIVERY DETAILS MAINTENANCE                *
      *                                                               *
      *  Function:  This subfile program is used when repairing       *
      *             Repurchase agreements and is used to maintain     *
      *             securities delivered/received as collateral.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249481             Date 31Jul07               *
      *                 247785             Date 15May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 233352             Date 06May05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 08Apr02               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249481 - Fix the dimension of arrays passed to some modules  *
      *           waiting for more than defined here                  *
      *  247785 - Recompile on MMTRPDMPD.                             *
      *           Pass correct Front Office reference to MMRPDMTUP.   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233352 - Problem in REPO API (Recompile)                     *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FMMRPDLDF  CF   E             WORKSTN
     F                                     SFILE(MMRPDLS1:RRN)
     F                                     INFSR(*PSSR)
     FMMIRPDDL0 IF   E           K DISK
     F                                     INFSR(*PSSR)
 
     FSEDPMVL3  IF   E           K DISK
     F                                     INFSR(*PSSR)
 
     FDPTMVDL1  IF   E           K DISK    PREFIX(A)
     F                                     INFSR(*PSSR)
     F                                     RENAME(DPTMVDF:DPTMVL1)
 
     FSECTY     IF   E           K DISK
     F                                     INFSR(*PSSR)
 
     FINVTP     IF   E           K DISK
     F                                     INFSR(*PSSR)
 
     FSECRTNTPPDUF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SECRTNF1:TEMPNF1)
     FSECRTTTPPDUF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SECRTTF1:TEMPTF1)
     FDEALS     IF A E           K DISK
     F                                     INFSR(*PSSR)
      *****************************************************************
     D ##OX1           S              1    DIM(74) CTDATA PERRCD(74)
     D ##OX2           S              1    DIM(74) CTDATA PERRCD(74)
     D ##OX3           S              1    DIM(74) CTDATA PERRCD(74)
     D ##OX4           S              1    DIM(74) CTDATA PERRCD(74)
     D ##JF1           S              1    DIM(71) CTDATA PERRCD(71)
     D ##EJ1           S              1    DIM(40) CTDATA PERRCD(40)
     D ##JF2           S              1    DIM(71) CTDATA PERRCD(71)
     D ##EJ2           S              1    DIM(40) CTDATA PERRCD(40)
     D ##ON1           S              1    DIM(76) CTDATA PERRCD(76)
     D ##OT1           S              1    DIM(76) CTDATA PERRCD(76)
     D ##DL1           S              1    DIM(41) CTDATA PERRCD(41)
     D ##DL2           S              1    DIM(41) CTDATA PERRCD(41)
     D ##JF3           S              1    DIM(73) CTDATA PERRCD(73)
     D ##EJ3           S              1    DIM(42) CTDATA PERRCD(42)
     D ##JF4           S              1    DIM(73) CTDATA PERRCD(73)
     D ##EJ4           S              1    DIM(42) CTDATA PERRCD(42)
     D
     D RPDL            S            280    DIM(100)
     D SRPDL           S            280    DIM(100)
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D @EI             S              1    DIM(19)
 
     D CrDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
     D DIACTN        E                     EXTFLD(DDACTN)
     D DICUST        E                     EXTFLD(DDCUST)
      * Parameter passed from MMREPOSIN with Deal Details
 
     D CrRpScnFmt    E DS                  EXTNAME(MMRPDDPD)
     D                                     PREFIX(D)
      * Current Repo in Screen Format
 
     D NwRpScnFmt    E DS                  EXTNAME(MMRPDDPD)
     D                                     PREFIX(IK:2)
     D VIKDLNO       E                     EXTFLD(DDDLNO)
      * New Repo delivery Screen format
 
     D MMEREP        E DS                  EXTNAME(MMERPDDPD)
      * Error indicators
 
     D CrRhScnFmt    E DS                  EXTNAME(MMRPDHPD)
     D DODLNO        E                     EXTFLD(DDDLNO)
     D DOCUST        E                     EXTFLD(DDCUST)
     D DOVDAT        E                     EXTFLD(DDVDAT)
     D DOMDAT        E                     EXTFLD(DDMDAT)
     D DOCCY         E                     EXTFLD(DDCCY)
      * Current Repo Header in Screen Format
 
     D NwRhScnFmt    E DS                  EXTNAME(MMRPDHPD)
     D                                     PREFIX(IK:2)
     D QQACC1        E                     EXTFLD(QQACCN)                                     CGL029
      * New Repo Header in Screen Format
     D MMIRPTR       E DS                  EXTNAME(MMIRPTRPD)
     D QQACC2        E                     EXTFLD(QQACCN)                                     CGL029
 
     D MMERHD        E DS                  EXTNAME(MMERPDHPD)
     D DLNOOK        E                     EXTFLD(OKDLNO)
 
      * New Repo Detail in File Format
 
     D NwRpFilFmt    E DS                  EXTNAME(MMVRPDDPD)
      * New Repo Header in File Format
 
     D NwRhFilFmt    E DS                  EXTNAME(MMVRPDHPD)
     D IFDEAL        E                     EXTFLD(IFDLNO)
     D QQACC3        E                     EXTFLD(QQACCN)                                     CGL029
      * Error indicators
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCLCD         E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR Switchable Features
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** EXTERNAL DS FOR Trading Data
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D**  Customer details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D**  Currency details
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D QQACC5        E                     EXTFLD(QQACCD)                                     CGL029
     D**  Retail ICD details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029
     D**  Branch Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  Branch Details
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D**  Securities Trading ICD Data
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D QQACC4        E                     EXTFLD(QQACCD)                                     CGL029
     D BFZONE        E                     EXTFLD(SEZONE)                                    BUG3122
     D**  Securities Trading ICD Data
 
     D MMTRPDM       E DS                  EXTNAME(MMTRPDMPD)
     D**  Temporary Depot Movement File DS
 
     D**  Security Details
     D SECTYD        E DS                  EXTNAME(SECTY)
     D SECRECI       E                     EXTFLD(RECI)
     D SECORED       E                     EXTFLD(ORED)
     D SECLCD        E                     EXTFLD(LCD)
     D SECCHTP       E                     EXTFLD(CHTP)
     D SECTNLU       E                     EXTFLD(TNLU)
     D SECREPI       E                     EXTFLD(REPI)
 
     D**  External Record format
     D RPDLS1          DS
     D  SDACTN                 1      1
     D  SDSECT                 2     11
     D  SDNOML                12     23
     D  SDVALP                24     39
     D  SDVDIN                40     55
     D  SDVDVL                56     71
     D  SDORDP                72     81
     D  SDCPDP                82     91
     D  SDEXCR                92    106
     D  SDMDIN               107    122
     D  SDMDVL               123    138
     D  SDDPRN               139    144
     D  S@SECT               145    154
     D  S@NOML               155    165  0
     D  S@VALP               166    180  8
     D  S@VDIN               181    195  0
     D  S@VDVL               196    210  0
     D**S@ORDP**             211    216  0                                                    CSD027
     D**S@CPDP**             217    222  0                                                    CSD027
     D  S@ORDP               211    216                                                       CSD027
     D  S@CPDP               217    222                                                       CSD027
     D  S@EXCR               223    235  8
     D  S@MDIN               236    250  0
     D  S@MDVL               251    265  0
     D  S@EXT1               266    266
     D  S@CHG                267    267
     D  S@OUTP               268    277
     D  S@NWRC               278    278
     D  S@IN51               279    279
     D  S@IN70               280    280
     D  S@FOAS               281    300
     D  S@FOID               301    320
 
     D PDATA         E DS                  EXTNAME(SE70DT)
     D PPTFR         E                     EXTFLD(PTFR)
     D**  Branch Details
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  Short data structure
 
     D DDDATA          DS            73
     D  DDSECT
     D  DDNOML
     D  DDVALP
     D  DDORDP
     D  DDCPDP
     D  DDEXCR
 
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDXX         E DS                  EXTNAME(DPTMVD) PREFIX(D)
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDX1         E DS                  EXTNAME(DPTMVDY1) PREFIX(D)
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDX2         E DS                  EXTNAME(DPTMVDY2) PREFIX(D)
     D**  Data structure of Depot Movement Extension File
     D DPTY          E DS                  EXTNAME(DPTMVDL1) PREFIX(A)
     D**  Data structure of Certificate Numbers Temporary File
     D TEMPTN        E DS                  EXTNAME(SECRTNTPPD)
     D**  Data structure of Certificate Numbers File
     D RTNT1         E DS                  EXTNAME(SECRTNL1) PREFIX(D)
     D**  Data structure of Certificates Units Temporary File
     D TEMPTT        E DS                  EXTNAME(SECRTTTPPD)
     D**  Data structure of Certificates Units File
     D RTTT1         E DS                  EXTNAME(SECRTTL1) PREFIX(D)
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
     D                 DS
      **  Data structure for dummy reference number for depo extension
     D  DRefNo                 1      6
     D  DumConst               1      1
     D  DumRef                 2      6
 
     D                 DS
      **  Data structure to split  fee account number into 12 and 3
     D***W#ACCN*                1     16                                                      CGL029
     D***DDACCA*                1     12                                                      CGL029
     D***DDACCB*               13     15                                                      CGL029
     D  W#ACCN                 1     22                                                       CGL029
     D  DDACCA                 1     18                                                       CGL029
     D  DDACCB                19     21                                                       CGL029
 
     D @OPSEL          S              1A
     D @@AFRT          S             20A
 
      ** Loan/Deposit Ccy
     D LoanCcy         S                            LIKE(DDCCY)
 
      ** Branch
     D Branch          S                            LIKE(DDBRCA)
 
      ** Midas Day No Formatted Value Date
     D ValueDate       S              5  0
 
      ** Midas Day No Formatted Maturity Date
     D MaturDate       S              5  0
 
      ** ErrorFlag for call to standard routines. (Equates to *IN99).
     D ErrorFlag       S              1A            INZ('N')
 
      ** Index for Arrays of Error message indicators etc.
     D Idx             S              3P 0
 
      ** Index for Arrays of Warning message indicators etc.
     D Widx            S              3P 0
 
      ** Respnose Mode, recieved as a parameter from the common header
     D RespMode        S              1A
 
      ** Value Date as a Midas Day number
     D ValDateMdn      S              5P 0
 
      ** FeeSave indicates whether FEe details have been saved from
      ** first depot movement.
     D FeeSave         S              1A
 
      ** Calling Program
     D CallPgm         S             10A
 
      ** Define Midas Day No format fields for maturity date and value date
     D W#DCAB          S                   LIKE(DCAB)
     D W#DCCE          S                   LIKE(DCCE)
     D W#DCHA          S                   LIKE(DCHA)
     D W#DCSE          S                   LIKE(DCSE)
     D W#DPNR          S                   LIKE(DPNR)
     D W#DLDT          S                   LIKE(BJRDNB)
     D W#DLNO          S              6S 0
     D W#DEAL          S              6S 0
     D W#PRAM          S             15P 0
     D ZAMT            S             15P 0
     D IRATE           S             15P 9
     D ZSDATE          S              5P 0
     D ZEDATE          S              5P 0
     D DADJN           S              1A
     D*NCD******       S              5P 0                                                    CSE031
     D NomCcyDec       S              1P 0
      ** Nominal
     D  NOML           S             11P 0
      ** Accrued indicator
     D  ZACIN          S              1A
      ** Day adjustment
     D  ZDADJ          S              3P 0
      ** Actual Difference indicator
     D  ZADIN          S              1A
      ** Coupon rate (trade)
     D TDCR            S             11P 7
      ** Overide Indicator
     D  ZCPOVR         S              1A
     D ZACCRD          S             15S 0
     D ZACCXD          S             15S 1
     D ZRP             S              1A
     D ZDDAYS          S              5P 0
     D ZINTDD          S              5P 0
     D TotNom          S             13S 0
     D TotVal          S             13S 0
     D W#VALU          S             13S 0
     D BenCust         S             10A
     D PortRef         S              4A
     D DealAmt         S             15S 0
     D ActMode         S              1A
     D DepRef          S              6A
     D W#ORED          S                   LIKE(ORED)
 
     D*XArrayMax       C                   CONST(20)                                          249481
     D XArrayMax       C                   CONST(40)                                          249481
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      *
      ** Backup arrays for error messages on Depot screen
     D GFldNameAr      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D GMsgIdAr        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
 
     D** Mode used when calling SEDMRPUPD module to update temp files
     D DMRPMode        S              7A
 
     D** Main program-loop indicator
     D LOOP            S              1A
 
     D*  Ready to update to Midas database indicator
     D RdyToUpd        S              1A
 
     D** Mode when calling module to update Temp
     D RPDMMode        S              1A
 
     D** Data Structure for PGM MM0011 entry parameter.
     D*
     D P#0010          DS           256
     D  P#NDCY                 1      3
     D  P#NDAM                 4     10P 0
     D  P#DBCY                11     13
     D  P#DBAM                14     20P 0
     D  P#DBDT                21     23P 0
     D  P#CRCY                24     26
     D  P#CRAM                27     33P 0
     D  P#PDCY                34     36
     D  P#PDAM                37     43P 0
     D  P#CRDT                44     46P 0
     D  P#RATE                47     53P 8
     D  P#MDIN                54     54  0
     D  P#OVRT                55     55
     D  P#SDIN                56     56
     D  P#RTDS                57     59P 4
      *
     D  P#FRCY                11     13
     D  P#FRAM                14     20P 0
     D  P#FRDT                21     23P 0
     D  P#TOCY                24     26
     D  P#TOAM                27     33P 0
     D  P#TODT                44     46P 0
      *
     D  P#PMSQ                60     69
     D  P#INDC                70     74
     D  P#RTCD                75     81
     D  P#INTC                82     99  3
     D  P#INTD               100    117  3
      *
      * Flags for trailer validation
     D TRFlagsDS       DS
     D  IHFoidOK                      1A
     D  IHFoasOK                      1A
     D  IHNodpOK                      1A
     D  IHCntnOK                      1A
     D  IHNarrOK                      1A
     D  IHFeamOK                      1A
     D  IHFecyOK                      1A
     D  IHFesmOK                      1A
     D  IHAccnOK                      1A
 
 
      **--------------------------------------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     C
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   RESET                   *INKC
     C                   RESET                   *INKI
     C                   RESET                   *INKJ
     C                   RESET                   *INKL
     C                   RESET                   *INKW
     C                   MOVE      *ON           *IN78
     C                   MOVE      'N'           RdyToUpd
 
      ** Get original entry date from Deals file.
      ** If no record found on Deals set W#ORED as Run day number
      *
     C                   MOVE      DDDLNO        W#DEAL
     C     W#DEAL        CHAIN     DEALS                              89
     C                   IF        *IN89 = *OFF and W#DEAL <> 0
     C                   EVAL      W#ORED = ORED
     C                   ELSE
     C                   EVAL      W#ORED = BJRDNB
     C                   ENDIF
      *
      ** Reset Flag
     C                   EVAL      ChgCmd = *Blank
     C                   EVAL      *IN89 = *ON
      *
      * Clear Message Subfile
      *
     C                   CALL      'ZA0250'
      *
      *  Do while error messages found
      *  Write error messages (with or without data) to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     GFldNameAr(C) ANDNE     *BLANKS
     C                   MOVEL     GMsgIdAr(C)   @MSGID            7
     C                   EXSR      ERRWOD
     C                   ADD       1             C
     C                   ENDDO
      *
      **Build Subfile to display Repo Delivery Details
      *
     C                   IF        *IN89 = *ON
     C                   EXSR      SEC_DEL
     C                   ENDIF
 
      **Display the subfile until end requested (LOOP='N')
 
     C                   MOVE      'Y'           LOOP
 
     C     LOOP          DOWNE     'N'
 
      **Display Message Subfile, Subfile Control
 
     C                   WRITE     MMRPDLM0
     C                   EXSR      FmtInd
 
      ** If Deal action is a Delete do not show screen. Deletion is automatic
 
     C                   IF        DIACTN <> 'D'
     C                   EXFMT     MMRPDLC1
     C                   ENDIF
 
      **Clear Message Subfile
 
     C                   CALL      'ZA0250'
 
      **inz_sfl option taken
 
     C                   SELECT
 
      *************************
      **If F3 is pressed (exit)
      *************************
 
     C     *INKC         WHENEQ    *ON
     C                   MOVE      'N'           LOOP
     C                   MOVEL     'F3'          RCODE
     C
 
      ***************************
      **If F9 is pressed (insert)
      ***************************
 
     C     *INKI         WHENEQ    *ON
     C                   MOVE      *INKI         @INKI             1
     C                   MOVE      *Blank        RdyToUpd
     C                   MOVE      *OFF          *IN18
     C                   EXSR      Inz_Sfl
 
      ************************************
      **If F10 is pressed (confirm delete)
      ************************************
 
     C     *INKJ         WHENEQ    *ON
     C                   MOVE      'Confirm'     Status            7
     C                   EXSR      DELET
     C                   IF        DIACTN = 'D'
     C                   EVAL      LOOP = 'N'
     C                   ENDIF
 
      ** Reallow the insert function
     C                   EVAL      *IN19 = *ON
 
      ****************************
      **If F12 is pressed (cancel)
      ****************************
 
     C     *INKL         WHENEQ    *ON
 
      ** User cancels on Add  creen
     C                   IF        @INKI = '1'
     C                   MOVE      *Blank        RdyToUpd
     C                   MOVE      *OFF          *IN18
     C                   EXSR      Con_Inp
     C                   ELSE
 
      ** User cancels on Confirm Delete Screen
     C                   IF        *IN20 = '1'
     C                   EXSR      Restore
     C                   MOVE      *Blank        RdyToUpd
     C                   MOVE      *OFF          *IN18
     C                   EVAL      *IN19 = *ON
     C                   EVAL      *IN77 = '0'
 
     C                   ELSE
     C                   MOVE      'N'           LOOP
     C                   MOVEL     'F12'         RCODE
     C                   MOVE      DDDLNO        LstDlNo           6
      *
      ** Set on flag to indicate that F12 has been pressed to cancel
      *
     C                   MOVE      'Y'           ChgCmd            1
     C                   MOVE      DIACTN        ChgActn           1
     C                   ENDIF
     C                   ENDIF
 
      ****************************
      ** F22 pressed (submit deal)
      ****************************
 
     C     *INKW         WHENEQ    *ON
 
      ** If the temporary Depot Movement file has been updated
      ** then we can return to calling module and validate the whole Repo deal
 
     C                   IF        RdyToUpd = 'Y'
     C                   MOVE      'N'           LOOP
     C                   MOVEL     'UPD'         RCODE
     C                   ENDIF
     C                   MOVE      *OFF          *INKW
 
      ****************
      ** Enter pressed
      ****************
     C                   OTHER
 
     C                   IF        @OPSEL <> 'N'
 
      ** Send error if enter pressed when confirm delete screen is displayed
     C                   IF        *IN20 = *On
     C                   MOVEL     'MMA0779'     @MSGID
     C                   EXSR      ERRWOD
 
     C                   ELSE
     C                   MOVE      *Blank        RdyToUpd
     C                   MOVE      *OFF          *IN18
     C                   EXSR      Con_Inp
     C                   IF        DIACTN <> 'D'
     C                   EXSR      Upd_Fee
     C                   ENDIF
 
     C                   ENDIF
 
      ** Enter has been pressed in Enquire mode so return to calling module
     C                   ELSE
     C                   MOVE      'N'           LOOP
     C                   MOVEL     'SFL'         RCODE
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *Pro_Inp - Process Input to Subfile                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Pro_Inp       BEGSR
 
      * Validate Subfile
      *
     C                   Z-ADD     0             W#NOML           15 0
     C                   Z-ADD     0             W#TOTV           15 0
     C                   Z-ADD     0             W#VLP            15 0
      *
     C                   Z-ADD     *Zero         PRRN
     C                   Z-ADD     1             RRN
     C                   Z-ADD     0             T#Idx
     C                   Z-ADD     0             Entries
      *
      ** Restore values of protect indicators
      *
     C                   EXSR      FmtInd
      *
      ** Set up export Parameteres for validation modules
      *
     C                   EVAL      ActMode = DIACTN
      *
      ** Validate all records in subfile
      *
     C                   DO        Zn
     C     RRN           CHAIN     MMRPDLS1                           99
      ** Validate Line id data has been input.
      *
     C                   EVAL      DDDDLNO = DDDLNO
     C                   EVAL      DDDSECT = DDSECT
     C                   EVAL      DDDNOML = DDNOML
     C                   EVAL      DDDVALP = DDVALP
     C                   EVAL      DDDVDIN = DDVDIN
     C                   EVAL      DDDVDVL = DDVDVL
     C                   EVAL      DDDORDP = DDORDP
     C                   EVAL      DDDCPDP = DDCPDP
     C                   EVAL      DDDEXCR = DDEXCR
     C                   EVAL      DDDMDIN = DDMDIN
     C                   EVAL      DDDMDVL = DDMDVL
     C                   EVAL      DDDACTN = DDACTN
     C
      *
      ** If subfile record has been altered and change indicator activated
      ** set D@CHG to 'Y'
      *
     C                   IF        *IN40 = '1' or *IN41 = '1' or
     C                             *IN42 = '1' or *IN43 = '1' or
     C                             *IN44 = '1' or *IN45 = '1'
     C                   MOVE      'Y'           D@CHG
     C                   ENDIF
      * Clear Error arrays
     C
     C                   CLEAR                   MMEREP
     C                   CLEAR                   MMERHD
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   Idx
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIdx
     C                   CLEAR                   @EI
     C                   MOVEA     '00000000000' *IN(50)
     C                   CLEAR                   NwRpScnFmt
     C                   CLEAR                   NwRpFilFmt
      *
     C                   IF        DDDATA <> *Blanks
      *
     C                   MOVEL     CrRpScnFmt    NwRpScnFmt
     C                   ADD       1             Entries           3 0
      *
      ** If no Depot Refernce number exists create a dummy one so that
      ** extension records and certificate records can be matched to
      ** depot movements in update module.
      *
     C                   IF        D@DPRN = *Blanks
 
      ** Set up dummy reference number
 
     C                   ADD       1             DRef              5 0
     C                   MOVE      DRef          DumRef
     C                   MOVEL     'X'           DumConst
     C                   MOVEL     DRefNo        D@DPRN
 
     C                   ENDIF
      *
      ** Set up Depot Reference number to export to module MMVACCD
      *
     C                   EVAL      DepRef = D@DPRN
     C                   EVAL      IKDPMV = D@DPRN
      *
      ** Call validation module to validate incdividual subfile entries
      *
     C                   CALLB     'MMRPDL1VL'
     C                   PARM                    RespMode
     C                   PARM                    NwRpScnFmt
     C                   PARM                    LoanCcy
     C                   PARM                    Branch
     C                   PARM                    ValueDate
     C                   PARM                    MaturDate
     C                   PARM                    BenCust
     C                   PARM                    PortRef
     C                   PARM                    ActMode
     C                   PARM                    DepRef
     C                   PARM                    MMEREP
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwRpFilFmt
     C                   ELSE
      *
      ** Set protect indicator on unless program is in insert mode
      ** or Add function of Rollover or Margin call modes is taken.
      *
     C                   IF        DIACTN <> 'I' and @INKI <> '1'
     C                   MOVE      *ON           *IN74
     C                   ENDIF
     C                   ENDIF
      *
      * Move 'OK' Flags into Array (For checking)
      *
     C                   MOVEA     MMEREP        @EI
      *
      * Set screen error indciators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     50            E                 2 0
      *
     C     C             DOUGT     11
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      *  Do while error messages found
      *  Write error messages (with or without data) to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   @MSGID            7
     C                   MOVEL     MsgDtaArr(C)  @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   END
     C                   ADD       1             C
     C                   END
      *
      *  Do while warning messages found
      *  write warning messages (with or without data) to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  @MSGID            7
     C                   MOVEL     WMsgDtaArr(C) @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   END
     C                   ADD       1             C
     C                   END
      *
     C                   ADD       Idx           T#Idx             3 0
     C                   IF        T#Idx > 1 and PRRN = 0
     C                   EVAL      PRRN = RRN
     C                   ENDIF
      *
      ** Move Formatted fields back to subfile
      *
     C                   EVAL      DDSECT = IKSECT
     C                   EVAL      DDNOML = IKNOML
     C                   EVAL      DDVALP = IKVALP
     C                   EVAL      DDVDIN = IKVDIN
     C                   EVAL      DDVDVL = IKVDVL
     C                   EVAL      DDORDP = IKORDP
     C                   EVAL      DDCPDP = IKCPDP
     C                   EVAL      DDEXCR = IKEXCR
     C                   EVAL      DDMDIN = IKMDIN
     C                   EVAL      DDMDVL = IKMDVL
     C
     C                   EVAL      D@SECT = IFSECT
     C                   EVAL      D@NOML = IFNOML
     C                   EVAL      D@VALP = IFVALP
     C                   EVAL      D@VDIN = IFVDIN
     C                   EVAL      D@VDVL = IFVDVL
     C                   EVAL      D@ORDP = IFORDP
     C                   EVAL      D@CPDP = IFCPDP
     C                   EVAL      D@EXCR = IFEXCR
     C                   EVAL      D@MDIN = IFMDIN
     C                   EVAL      D@MDVL = IFMDVL
     C
      ** Access Security Details
     C                   IF        Idx = 0 and DDSECT <> *Blanks
 
     C     DDSECT        CHAIN     SECTY                              88
 
     C                   CLEAR                   P#0010
     C                   MOVE      NMCY          P#DBCY
     C                   Z-ADD     IFVDVL        P#DBAM
     C                   MOVE      DDCCY         P#CRCY
     C                   Z-ADD     0             P#CRAM
     C                   Z-ADD     BJRDNB        P#DBDT
     C                   Z-ADD     BJRDNB        P#CRDT
     C                   MOVE      IFEXCR        P#RATE
     C                   MOVE      'Y'           P#OVRT
     C                   MOVE      'N'           P#SDIN
     C                   Z-ADD     0             P#RTDS
     C                   MOVEL     PSProcName    P#PMSQ
     C                   MOVE      *BLANKS       P#INDC
     C                   MOVE      *BLANKS       P#RTCD
      *
     C                   CALL      'MM0011'
     C                   PARM                    P#0010
      *
      ** Database error handling
     C     P#RTCD        IFEQ      '*ERROR*'
     C                   MOVEL     'MM0011  '    DBFILE
     C                   MOVEL     '*FIRST '     DBKEY
     C                   Z-ADD     01            DBASE
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   ADD       P#CRAM        W#VLP
      *
      ** Format Nominal to have 4 dp's irrespective of actual no.
      *
      ** If Nominal Decimal Places = 0 then Multiply by 10000
     C                   IF        NMDP = 0
     C     10000         MULT      IFNOML        W#NML            15 0
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
      *
      ** If Nominal Decimal Places = 1 then Multiply by 1000
     C                   IF        NMDP = 1
     C     1000          MULT      IFNOML        W#NML            15 0
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
     C
      *
      ** If Nominal Decimal Places = 2 then Multiply by 100
     C                   IF        NMDP = 2
     C     100           MULT      IFNOML        W#NML            15 0
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
     C
      ** If Nominal Decimal Places = 3 then Multiply by 10
     C                   IF        NMDP = 3
     C     10            MULT      IFNOML        W#NML            15 0
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
      *
      ** If Nominal Decimal Places = 4 then Multiply by 1
     C                   IF        NMDP = 4
     C     1             MULT      IFNOML        W#NML            15 0
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
      *
      ** Default returned rate into exchange rate in case rate has been
      ** changed due to EMU rate requirements.
      *
     C                   Z-ADD     0             IFEXCR
     C                   MOVE      P#RATE        IFEXCR
     C                   Z-ADD     0             ZFLD15           15 0
     C                   MOVE      P#RATE        ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      8             ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      *BLANKS       IKEXCR
     C                   MOVE      ZOUT21        IKEXCR
     C                   MOVE      ZOUT21        DDEXCR
     C                   ENDIF
     C                   ENDIF
      *
      ** If *IN51 is on with a warning message save error indicator
      ** as it will otherwise be lost in Depot Extension update.
      *
     C                   IF        *IN51 = *On
     C                   EVAL      D@IN51 = 'Y'
     C                   ENDIF
      *
     C                   IF        D@IN70 = 'Y'
     C                   EVAL      *IN70 = *On
     C                   ELSE
     C                   EVAL      *IN70 = *Off
     C                   ENDIF
      *
      ** Default DDACTN to be 'D' if DIACTN = 'D'
     C                   IF        DIACTN = 'D'
     C                   EVAL      DDACTN = 'D'
     C                   ENDIF
      *
     C                   IF        DDSECT = *BLANKS
     C                   EVAL      DDOUTP = *BLANKS
     C                   END
      *
     C                   UPDATE    MMRPDLS1
      *
     C                   ADD       1             RRN
      *
     C                   ENDDO
 
     C                   IF        PRRN = 0
     C                   EVAL      PRRN = 1
     C                   ENDIF
      *
      * Set screen error indicator to off for all header details
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     52            E                 2 0
      *
     C     C             DOUGT     19
     C                   MOVEL     '0'           *IN(E)
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      ** If no error returned and at least one record has been entered
      ** call MMRPDL2VL.
      *
     C                   IF        T#Idx = 0
     C                   IF        Entries > 0
      *
      * Clear Error arrays
     C
     C                   CLEAR                   MMERHD
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   Idx
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIdx
     C                   CLEAR                   @EI
     C                   MOVEA     '00000000'    *IN(61)
      *
     C                   EVAL      DDACCN = W#ACCN
      *
     C                   Z-ADD     W#NOML        IFTOTN
     C                   Z-ADD     W#VLP         IFTOTV
     C
     C                   EVAL      IKCNTN = DDCNTN
     C                   EVAL      IKNARR = DDNARR
     C                   EVAL      IKTOTN = DDTOTN
     C                   EVAL      IKTOTV = DDTOTV
     C                   EVAL      IKFECY = DDFECY
     C                   EVAL      IKFESM = DDFESM
     C                   EVAL      IKACCN = DDACCN
     C                   EVAL      IKFEAM = DDFEAM
 
      *
      ** Set up deal amount in case amount has been ameneded
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      LoanCcy       @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   MOVE      A6NBDP        LoanDP            1 0
     C                   MOVE      *Blanks       ZFIELD
     C                   MOVE      DDAMNP        ZFIELD
     C                   Z-ADD     LoanDP        ZADEC
     C     15            SUB       ZADEC         ZADIG
 
     C                   IF        LoanDp <> 0
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C
     C                   MOVE      ZFIELD        DealAmt
     C
     C                   ELSE
     C                   MOVE      DDAMNP        DealAmt
     C                   ENDIF
     C
      *
     C                   CALLB     'MMRPDL2VL'
     C                   PARM                    RespMode
     C                   PARM                    NwRhScnFmt
     C                   PARM                    LoanCcy
     C                   PARM                    Branch
     C                   PARM                    DealAmt
     C                   PARM                    MMERHD
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwRhFilFmt
     C                   PARM                    @INKI
      *
     C                   MOVEA     MMERHD        @EI
      *
      * Set screen error indciators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     52            E                 2 0
      *
     C     C             DOUGT     19
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
      *
      *  Do while error messages found
      *  Write error messages (with or without data) to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   @MSGID            7
     C                   MOVEL     MsgDtaArr(C)  @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
      *
      *  Do while warning messages found
      *  write warning messages (with or without data) to subfile
      *
     C                   Z-ADD     1             C
 
     C     C             DOWLE     ArrayMax
 
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  @MSGID            7
     C                   MOVEL     WMsgDtaArr(C) @MSGDT           45
 
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   ENDIF
 
     C                   ADD       1             C
 
     C                   ENDDO
      *
     C                   ADD       Idx           T#Idx             3 0
     C
      ** Return values to screen fields
     C
     C                   EVAL      DDCNTN = IKCNTN
     C                   EVAL      DDNARR = IKNARR
     C                   EVAL      DDTOTN = IKTOTN
     C                   EVAL      DDTOTV = IKTOTV
     C                   EVAL      DDFECY = IKFECY
     C                   EVAL      DDFESM = IKFESM
     C                   EVAL      DDACCN = IKACCN
     C                   EVAL      DDFEAM = IKFEAM
 
     C                   EVAL      W#ACCN = DDACCN
      *
     C                   ELSE
      *
      ** Send Error message if no records have been entered
     C                   IF        *INKL <> *On
 
     C                   EVAL      T#Idx = 1
     C                   MOVEL     'MMA0778'     @MSGID
 
     C                   EXSR      ERRWOD
 
     C                   EVAL      IKCNTN = *BLANKS
     C                   EVAL      IKTOTN = *BLANKS
     C                   EVAL      IKTOTV = *BLANKS
     C                   EVAL      DDCNTN = IKCNTN
     C                   EVAL      DDTOTN = IKTOTN
     C                   EVAL      DDTOTV = IKTOTV
     C                   MOVE      '0.0000'      DDCNTN
     C                   MOVE      '0.0000'      DDTOTN
     C                   MOVE      '0.00'        DDTOTV
 
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      ** If no error returned change mode to confirm, call SE1807 to
      ** generate MT5xx messages if S01401 is on and end subroutine.
      *
     C                   IF        T#Idx=0
      *
      ** Set indicators to allow input to action code and disable input
      ** to other fields.
      *
     C     S01401        IFEQ      'Y'
     C                   Z-ADD     0             RRN
     C                   DO        Zn
     C                   ADD       1             RRN
     C     RRN           CHAIN     MMRPDLS1                           99
     C                   IF        DDDATA <> *Blanks
     C                   IF        D@EXT1 <> 'Y' or D@CHG ='Y'
      *
      ** Restore warning error message to Security Shortname Field
      *
     C                   IF        D@IN51 = 'Y'
     C                   EVAL      *IN51 = *On
     C                   EVAL      D@IN51 = *Blank
     C                   MOVEL     'MMA0756'     @MSGID
     C                   EXSR      ERRWOD
     C                   ENDIF
      *
     C                   IF        D@IN70 = 'Y'
     C                   EVAL      *IN70 = *On
     C                   ELSE
     C                   EVAL      *IN70 = *Off
     C                   ENDIF
 
     C                   UPDATE    MMRPDLS1
     C                   MOVE      *Blank        D@EXT1
     C                   MOVE      ' '           D@NWRC
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Val_Trl - Validate data inside the Repo Trailer File         *
      *                                                               *
      * Called by: Con_Inp                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Val_Trl       BEGSR
     C
      * Clear Error arrays
     C                   CLEAR                   TRFlagsDS
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   Idx
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIdx
     C
      * Retrieve Trailer details
     C                   CALLB     'MMRPTRIRD'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    @@AFRT
     C                   PARM                    MMIRPTR
     C
      * Validate Trailer details
     C                   CALLB     'MMREPOVAL'
     C                   PARM                    RespMode
     C                   PARM                    MMIRPTR
     C                   PARM      'MMREPORPR '  CallPgm
     C                   PARM                    TRFlagsDS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      *
      **Populate indicators to Reverse Image fields in error
      *
     C                   IF        IHCntnOK <> *BLANKS
     C                   EVAL      *IN62 = *ON
     C                   ELSE
     C                   EVAL      *IN62 = *OFF
     C                   ENDIF
      *
     C                   IF        IHFeamOK <> *BLANKS
     C                   EVAL      *IN65 = *ON
     C                   ELSE
     C                   EVAL      *IN65 = *OFF
     C                   ENDIF
      *
     C                   IF        IHFecyOK <> *BLANKS
     C                   EVAL      *IN66 = *ON
     C                   ELSE
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
      *
     C                   IF        IHFesmOK <> *BLANKS
     C                   EVAL      *IN67 = *ON
     C                   ELSE
     C                   EVAL      *IN67 = *OFF
     C                   ENDIF
      *
     C                   IF        IHAccnOK <> *BLANKS
     C                   EVAL      *IN68 = *ON
     C                   ELSE
     C                   EVAL      *IN68 = *OFF
     C                   ENDIF
      *
      *  Do while error messages found
      *  Write error messages (with or without data) to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   @MSGID            7
     C                   MOVEL     MsgDtaArr(C)  @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
      *
      *  Do while warning messages found
      *  write warning messages (with or without data) to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  @MSGID            7
     C                   MOVEL     WMsgDtaArr(C) @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   END
     C                   ADD       1             C
     C                   END
      *
     C                   ADD       Idx           T#Idx             3 0
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Con_Inp - Process actions against validated subfile records  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Con_Inp       BEGSR
     C
      * Validate whole subfile
     C                   EXSR      Pro_Inp
      *
      ** Process if there are no validation errors. Rebuild whole subfile
      ** for action code 'M' if F9 has been pressed and new records entered.
      *
     C                   IF        T#Idx = 0 and @INKI = '1' and DIACTN<>'D'
     C                             or @INKI = '1' and *INKL = *On
     C                             and DIACTN<>'D'
      *
     C                   EVAL      @INKI = *Blanks
      *
      ** If input is valid and record is newly inserted
      *
     C                   Z-ADD     0             RRN
 
     C                   IF        *INKL = *Off
     C                   DO        Zn
 
     C                   ADD       1             RRN
 
     C     RRN           CHAIN     MMRPDLS1                           86
      *
     C                   IF        DDDATA <> *Blanks
      *
      ** Save records in array
      *
     C                   EVAL      SDACTN = DDACTN
     C                   EVAL      SDSECT = DDSECT
     C                   EVAL      SDNOML = DDNOML
     C                   EVAL      SDVALP = DDVALP
     C                   EVAL      SDVDIN = DDVDIN
     C                   EVAL      SDVDVL = DDVDVL
     C                   EVAL      SDORDP = DDORDP
     C                   EVAL      SDCPDP = DDCPDP
     C                   EVAL      SDEXCR = DDEXCR
     C                   EVAL      SDMDIN = DDMDIN
     C                   EVAL      SDMDVL = DDMDVL
     C                   EVAL      SDDPRN = D@DPRN
     C                   EVAL      S@SECT = D@SECT
     C                   EVAL      S@NOML = D@NOML
     C                   EVAL      S@VALP = D@VALP
     C                   EVAL      S@VDIN = D@VDIN
     C                   EVAL      S@VDVL = D@VDVL
     C                   EVAL      S@ORDP = D@ORDP
     C                   EVAL      S@CPDP = D@CPDP
     C                   EVAL      S@EXCR = D@EXCR
     C                   EVAL      S@MDIN = D@MDIN
     C                   EVAL      S@MDVL = D@MDVL
     C                   EVAL      S@EXT1 = D@EXT1
     C                   EVAL      S@CHG = D@CHG
     C                   EVAL      S@OUTP = DDOUTP
     C                   EVAL      S@NWRC = D@NWRC
     C                   EVAL      S@IN51 = D@IN51
     C                   EVAL      S@IN70 = D@IN70
     C
      *
      ** On entry to this routine En wiil be set at value of number of
      ** record stored in array in SR/Inz_Sfl
      *
     C                   ADD       1             En                3 0
     C                   MOVEL     RPDLS1        SRPDL(En)
     C                   ENDIF
 
     C                   ENDDO
 
      ** Save Control Nominal
      *
     C                   ENDIF
 
      ** Set *IN19 back on to allow further input of records
      *
     C                   EVAL      *IN19 = '1'
      *
 
      ** Need to clear subfile to clear records before rewriting array
      *
     C                   MOVEA     '000'         *IN(1)
     C                   WRITE     MMRPDLC1
     C                   MOVEA     '111'         *IN(1)
 
      ** Write Arrays back in to subfile for further processing
 
     C                   Z-ADD     0             Zn
     C                   Z-ADD     0             RRN
 
      ** Make action code input capable again
     C                   EVAL      *IN76 = '0'
 
     C                   DO        En
     C                   ADD       1             Zn
     C                   ADD       1             RRN
     C                   MOVEL     SRPDL(Zn)     RPDLS1
     C                   CLEAR                   SRPDL(Zn)
      *
      ** Restore values to Subfile Fields
      *
     C                   EVAL      DDACTN = SDACTN
     C                   EVAL      DDSECT = SDSECT
     C                   EVAL      DDNOML = SDNOML
     C                   EVAL      DDVALP = SDVALP
     C                   EVAL      DDVDIN = SDVDIN
     C                   EVAL      DDVDVL = SDVDVL
     C                   EVAL      DDORDP = SDORDP
     C                   EVAL      DDCPDP = SDCPDP
     C                   EVAL      DDEXCR = SDEXCR
     C                   EVAL      DDMDIN = SDMDIN
     C                   EVAL      DDMDVL = SDMDVL
     C                   EVAL      D@DPRN = SDDPRN
     C                   EVAL      D@SECT = S@SECT
     C                   EVAL      D@NOML = S@NOML
     C                   EVAL      D@VALP = S@VALP
     C                   EVAL      D@VDIN = S@VDIN
     C                   EVAL      D@VDVL = S@VDVL
     C                   EVAL      D@ORDP = S@ORDP
     C                   EVAL      D@CPDP = S@CPDP
     C                   EVAL      D@EXCR = S@EXCR
     C                   EVAL      D@MDIN = S@MDIN
     C                   EVAL      D@MDVL = S@MDVL
     C                   EVAL      D@EXT1 = S@EXT1
     C                   EVAL      D@CHG = S@CHG
      *
      ** If S@OUTP <> *blanks move to DDOUTP
      *
     C     S@OUTP        IFNE      *BLANKS
     C                   EVAL      DDOUTP = S@OUTP
     C                   END
      *
     C                   EVAL      D@NWRC = S@NWRC
     C                   EVAL      D@IN51 = S@IN51
     C                   EVAL      D@IN70 = S@IN70
      *
      ** Restore values of protect indicators
      *
     C                   EXSR      FmtInd
 
     C                   WRITE     MMRPDLS1
 
     C                   ENDDO
 
      ** Revalidate subfile to calculate new totals
 
     C                   EXSR      Pro_Inp
 
     C                   ENDIF
      *
      ** If there are no errors
      *
     C                   IF        T#Idx = 0 or DIACTN = 'D'
     C                             or MsgIdArr(1) = 'MMA0763'
     C                             and T#Idx = 1
      *
     C
      ** Reset array count for subfile storage
      *
     C                   Z-ADD     0             Zn
      *
      ** Reset relative record count
      *
     C                   Z-ADD     0             RRN
      *
      ** Reset deleted record count
      *
     C                   Z-ADD     0             DelCount
     C                   Z-ADD     0             Xn
      *
      ** Read through Subfile to pick up action codes
      *
     C                   DO        En
      *
     C                   ADD       1             RRN
      *
     C     RRN           CHAIN     MMRPDLS1                           89
     C
     C                   IF        DDACTN <> *BLANKS and DDDATA <> *BLANKS
     C
     C                   SELECT
     C
     C     DDACTN        WHENEQ    'D'
     C                   EXSR      DELET
     C                   ENDSL
     C
     C                   ENDIF
 
      ** Execute Subroutine to update temporary depot movements file
 
     C                   IF        DDACTN <> 'D' and DDDATA <> *Blanks
     C                   EXSR      UPTEMP
     C                   ENDIF
 
      *
      ** Save all records that are not to be deleted in an array so that
      ** they can used to update subfile after deletion of records
      *
     C                   IF        DDACTN <> 'D'
      *
     C                   ADD       1             Zn                3 0
      *
     C                   EVAL      SDACTN = DDACTN
     C                   EVAL      SDSECT = DDSECT
     C                   EVAL      SDNOML = DDNOML
     C                   EVAL      SDVALP = DDVALP
     C                   EVAL      SDVDIN = DDVDIN
     C                   EVAL      SDVDVL = DDVDVL
     C                   EVAL      SDORDP = DDORDP
     C                   EVAL      SDCPDP = DDCPDP
     C                   EVAL      SDEXCR = DDEXCR
     C                   EVAL      SDMDIN = DDMDIN
     C                   EVAL      SDMDVL = DDMDVL
     C                   EVAL      SDDPRN = D@DPRN
     C                   EVAL      S@SECT = D@SECT
     C                   EVAL      S@NOML = D@NOML
     C                   EVAL      S@VALP = D@VALP
     C                   EVAL      S@VDIN = D@VDIN
     C                   EVAL      S@VDVL = D@VDVL
     C                   EVAL      S@ORDP = D@ORDP
     C                   EVAL      S@CPDP = D@CPDP
     C                   EVAL      S@EXCR = D@EXCR
     C                   EVAL      S@MDIN = D@MDIN
     C                   EVAL      S@MDVL = D@MDVL
     C                   EVAL      S@EXT1 = D@EXT1
     C                   EVAL      S@CHG = D@CHG
     C                   EVAL      S@OUTP = DDOUTP
     C                   EVAL      S@NWRC = D@NWRC
     C                   EVAL      S@IN51 = D@IN51
     C                   EVAL      S@IN70 = D@IN70
      *
     C                   MOVEL     RPDLS1        SRPDL(Zn)
      *
     C                   ENDIF
     C
     C                   ENDDO
 
      ** Validate the Repo trailer file (only warnings are produced)
      *
     C                   IF        DIACTN <> 'X' and DDACTN <> 'D'
     C                   EXSR      Val_Trl
     C                   ENDIF
      *
      ** If no records are to be deleted set endrequested counter to 0
     C                   IF        Zn = En and T#Idx = 0
     C                   EVAL      RdyToUpd = 'Y'
     C                   EVAL      *IN18 = *ON
     C
     C                   IF        WIdx = 0
     C                   MOVEL     'MMM9020'     @MSGID
     C                   EXSR      ERRWOD
     C                   ENDIF
 
     C                   ENDIF
     C
 
     C                   IF        DELCOUNT > 0
     C                   EVAL      DELCOUNT = 100
     C                   EXSR      DELET
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DELET - Delete subfile records                               *
      *                                                               *
      *  This SR called 3 times when user deletes individual Depots   *
      *  1. Move selected record into an array (repeated as needed)   *
      *  2. Move array into subfile to be shown to user               *
      *  3. User has confirmed to delete so perform delete            *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DELET         BEGSR
 
      ** F10 has not yet been pressed
     C                   IF        Status <> 'Confirm'
      *
     C                   IF        DELCOUNT <> 100
     C                   ADD       1             DELCOUNT          3 0
     C                   ADD       1             Xn                3 0
      *
      ** Save deleted record in array for redisplay
      *
     C                   EVAL      SDACTN = *BLANKS
     C                   EVAL      SDSECT = DDSECT
     C                   EVAL      SDNOML = DDNOML
     C                   EVAL      SDVALP = DDVALP
     C                   EVAL      SDVDIN = DDVDIN
     C                   EVAL      SDVDVL = DDVDVL
     C                   EVAL      SDORDP = DDORDP
     C                   EVAL      SDCPDP = DDCPDP
     C                   EVAL      SDEXCR = DDEXCR
     C                   EVAL      SDMDIN = DDMDIN
     C                   EVAL      SDMDVL = DDMDVL
     C                   EVAL      SDDPRN = D@DPRN
     C                   EVAL      S@SECT = D@SECT
     C                   EVAL      S@NOML = D@NOML
     C                   EVAL      S@VALP = D@VALP
     C                   EVAL      S@VDIN = D@VDIN
     C                   EVAL      S@VDVL = D@VDVL
     C                   EVAL      S@ORDP = D@ORDP
     C                   EVAL      S@CPDP = D@CPDP
     C                   EVAL      S@EXCR = D@EXCR
     C                   EVAL      S@MDIN = D@MDIN
     C                   EVAL      S@MDVL = D@MDVL
     C                   EVAL      S@EXT1 = D@EXT1
     C                   EVAL      S@CHG = D@CHG
     C                   EVAL      S@OUTP = DDOUTP
     C                   EVAL      S@NWRC = D@NWRC
     C                   EVAL      S@IN51 = D@IN51
     C                   EVAL      S@IN70 = D@IN70
     C                   EVAL      S@FOAS = D@FOAS
     C                   EVAL      S@FOID = D@FOID
      *
     C                   MOVEL     RPDLS1        RPDL(Xn)
      *
     C                   ELSE
      *
      ** If all deleted records have been processed clear Subfile and
      ** Redisplay records to be deleted
      *
     C                   MOVEA     '000'         *IN(01)
     C                   WRITE     MMRPDLC1
     C                   MOVEA     '111'         *IN(01)
     C                   Z-ADD     1             PRRN
     C                   Z-ADD     *ZERO         RRN
     C                   Z-ADD     Xn            DELCOUNT
     C                   Z-ADD     *ZERO         Xn
      *
      ** Protect all screen input fields
     C                   MOVE      *ON           *IN71
      *
      ** Protect Control nominal and Action code
     C                   MOVE      *ON           *IN76
     C                   MOVE      *ON           *IN77
      *
      ** Process all 100 records of Array
      *
     C                   DO        DELCOUNT
 
     C                   ADD       1             Xn
     C                   ADD       1             RRN
      *
     C                   MOVEL     RPDL(Xn)      RPDLS1
     C                   CLEAR                   RPDL(Xn)
      *
      ** Restore values to Subfile Fields
      *
     C                   EVAL      DDACTN = SDACTN
     C                   EVAL      DDSECT = SDSECT
     C                   EVAL      DDNOML = SDNOML
     C                   EVAL      DDVALP = SDVALP
     C                   EVAL      DDVDIN = SDVDIN
     C                   EVAL      DDVDVL = SDVDVL
     C                   EVAL      DDORDP = SDORDP
     C                   EVAL      DDCPDP = SDCPDP
     C                   EVAL      DDEXCR = SDEXCR
     C                   EVAL      DDMDIN = SDMDIN
     C                   EVAL      DDMDVL = SDMDVL
     C                   EVAL      D@DPRN = SDDPRN
     C                   EVAL      D@SECT = S@SECT
     C                   EVAL      D@NOML = S@NOML
     C                   EVAL      D@VALP = S@VALP
     C                   EVAL      D@VDIN = S@VDIN
     C                   EVAL      D@VDVL = S@VDVL
     C                   EVAL      D@ORDP = S@ORDP
     C                   EVAL      D@CPDP = S@CPDP
     C                   EVAL      D@EXCR = S@EXCR
     C                   EVAL      D@MDIN = S@MDIN
     C                   EVAL      D@MDVL = S@MDVL
     C                   EVAL      D@EXT1 = S@EXT1
     C                   EVAL      D@CHG = S@CHG
      *
      ** If S@OUTP <> *blanks move to DDOUTP
     C     S@OUTP        IFNE      *BLANKS
     C                   EVAL      DDOUTP = S@OUTP
     C                   END
      *
     C                   EVAL      D@NWRC = S@NWRC
     C                   EVAL      D@IN51 = S@IN51
     C                   EVAL      D@IN70 = S@IN70
     C                   EVAL      D@FOAS = S@FOAS
     C                   EVAL      D@FOID = S@FOID
 
     C                   WRITE     MMRPDLS1
 
     C                   ENDDO
      *
      ** Set on indicator tp display F10 = Delete option
      *
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN19 = *OFF
      *
      ** Set on F10 if module is in called in Delete mode
      *
     C                   IF        DIACTN = 'D'
     C                   EVAL      *INKJ = *ON
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
 
 
 
      ** F10 has been pressed to confirm Delete
     C                   IF        Status = 'Confirm'
     C                   EVAL      Status = *Blanks
      *
     C                   Z-ADD     0             RRN
      *
      ** Process loop for each record stored in array RPDL
      *
     C                   DO        DelCount
      *
     C                   ADD       1             RRN
     C     RRN           CHAIN     MMRPDLS1                           90
      *
     C                   IF        DIACTN = 'D'
      *
     C     D@DPRN        CHAIN     DPTMVDL1                           88
     C                   MOVEL     DPTY          SEDXX
     C                   EVAL      DRECI = '*'
     C                   EVAL      DCHTP = 'D'
     C                   EVAL      DLCD = BJRDNB
      *
      *  Set Pay/Receive processed indicators to N if Other Settlement
      *  record already printed.
      *
     C     DPR1          IFEQ      'Y'
     C                   MOVE      'N'           DPR1
     C                   ELSE
     C                   MOVE      'Y'           DPR1
     C                   END
      *
     C     DPR2          IFEQ      'Y'
     C                   MOVE      'N'           DPR2
     C                   ELSE
     C                   MOVE      'Y'           DPR2
     C                   END
      *
     C                   TESTB     '0'           DPMS                     99
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           DCFR
     C                   ELSE
     C                   MOVE      'Y'           DCFR
     C                   END
      *
     C                   CALLB     'SEDMRPUPD'
     C                   PARM                    ReturnCode
     C                   PARM      '*WrtXX'      DMRPMode
     C                   PARM                    SEDXX
     C                   PARM                    SEDX1
     C                   PARM                    SEDX2
      *
     C                   ENDIF
      *
     C                   CLEAR                   MMTRPDM
     C                   MOVE      DDSECT        DPSS
     C                   MOVE      @@AFRT        DMAFRT
     C                   CALLB     'MMRPDMTUP'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      'R'           RPDMMode
     C                   PARM                    MMTRPDM
      *
     C                   ENDDO
      *
      ** Clear Subfile of records
      *
     C                   MOVEA     '000'         *IN(1)
     C                   WRITE     MMRPDLC1
     C                   MOVEA     '111'         *IN(1)
      *
      ** Redisplay all records which are not deleted
      *
     C     En            SUB       DelCount      NumRec            3 0
     C                   Z-ADD     0             DelCount
     C                   Z-ADD     0             RRN
     C                   Z-ADD     0             Zn
     C                   MOVE      *ON           *IN71
      *
      ** Write out all records which have not been deleted
      *
     C                   DO        NumRec
     C                   ADD       1             RRN
     C                   ADD       1             Zn
     C                   MOVEL     SRPDL(Zn)     RPDLS1
     C                   CLEAR                   SRPDL(Zn)
      *
      ** Restore values to Subfile Fields
      *
     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      DDSECT = SDSECT
     C                   EVAL      DDNOML = SDNOML
     C                   EVAL      DDVALP = SDVALP
     C                   EVAL      DDVDIN = SDVDIN
     C                   EVAL      DDVDVL = SDVDVL
     C                   EVAL      DDORDP = SDORDP
     C                   EVAL      DDCPDP = SDCPDP
     C                   EVAL      DDEXCR = SDEXCR
     C                   EVAL      DDMDIN = SDMDIN
     C                   EVAL      DDMDVL = SDMDVL
     C                   EVAL      D@DPRN = SDDPRN
     C                   EVAL      D@SECT = S@SECT
     C                   EVAL      D@NOML = S@NOML
     C                   EVAL      D@VALP = S@VALP
     C                   EVAL      D@VDIN = S@VDIN
     C                   EVAL      D@VDVL = S@VDVL
     C                   EVAL      D@ORDP = S@ORDP
     C                   EVAL      D@CPDP = S@CPDP
     C                   EVAL      D@EXCR = S@EXCR
     C                   EVAL      D@MDIN = S@MDIN
     C                   EVAL      D@MDVL = S@MDVL
     C                   EVAL      D@EXT1 = S@EXT1
     C                   EVAL      D@CHG = S@CHG
      *
      ** If S@OUTP <> *blanks move to DDOUTP
      *
     C     S@OUTP        IFNE      *BLANKS
     C                   EVAL      DDOUTP = S@OUTP
     C                   END
      *
     C                   EVAL      D@NWRC = S@NWRC
     C                   EVAL      D@IN51 = S@IN51
     C                   EVAL      D@IN70 = S@IN70
     C                   EVAL      D@FOAS = S@FOAS
     C                   EVAL      D@FOID = S@FOID
      *
     C                   IF        D@IN70 = 'Y'
     C                   EVAL      *IN70 = *On
     C                   ELSE
     C                   EVAL      *IN70 = *Off
     C                   ENDIF
      *
 
     C                   WRITE     MMRPDLS1
 
     C                   ENDDO
      *
      ** Set off indicator to display F10 = Delete option
      *
     C                   EVAL      *IN20 = *OFF
     C                   IF        DIACTN = 'M' or DIACTN = 'R'
     C                   EVAL      *IN19 = *ON
     C                   ENDIF
      *
     C                   IF        DIACTN = 'A' and BJRDNB = W#ORED
     C                   EVAL      *IN19 = *ON
     C                   ENDIF
      *
      ** Set subfile record counter En to equal Zn
      *
     C                   EVAL      En = Zn
      *
      ** Reset DelCount
      *
     C                   EVAL      DELCOUNT = 0
      *
      ** Set off *IN76
      *
     C                   EVAL      *IN76 = '0'
      *
      ** Set off *IN77
      *
     C                   EVAL      *IN77 = '0'
      *
      ** Revalidate subfile totals
      *
     C                   EXSR      Pro_Inp
      *
      ** If there are no errros then set indicator to exit program else
      ** allow control nominal to be amended
      *
     C                   IF        T#Idx = 0 or DIACTN = 'D'
     C                   EVAL      RdyToUpd = 'Y'
     C                   EVAL      *IN18 = *ON
     C                   ENDIF
     C
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPTEMP - Update Temporary Depot Movements File               *
      *                                                               *
      * Called by: Con_Inp                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     UPTEMP        BEGSR
 
     C                   IF        DIACTN = 'I' or DIACTN = 'A'
     C                             or DIACTN = 'R' or DIACTN = 'M'
 
      ** Write out record to temporary file. Module MMRPDLUPD will check
      ** whether Depot Movement has been changed.
 
     C                   EXSR      WRTDEP
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      * WRTDEP - Write to Temporary Depot Movements File
      ********************************************************************
     C     WRTDEP        BEGSR
 
     ** Initialise all fields prior to update
 
     C                   CLEAR                   MMTRPDM
      *
      **Reaccess Security Details
     C     DDSECT        CHAIN     SECTY                              88
 
     C                   EVAL      RECI = 'D'
 
      ** If a Rollover, DPRN needs to be blanked so that MMRPDLUPD writes
      ** a new Depot Movement rather than updating the original one.
     C                   IF        DPRN = *BLANKS and DIACTN <> 'R'
     C                   EVAL      DPRN = D@DPRN
     C                   ENDIF
 
     C                   EVAL      DPSS = DDSECT
     C                   EVAL      DPMV = DDTRTP
     C                   EVAL      DPID = D@ORDP
 
     C                   IF        DDTRTP = 'RR' or DDTRTP = 'BB'
     C                             or DDTRTP = 'PL'
     C                   EVAL      DPMD = ValueDate
     C                   ELSE
      *
      ** If this is a call deposit maturity date may not have been entered
      ** Therefore set Depot Out date to maturity of security. If there
      ** is no Maturity date e.g with shares set it to 99999.
      *
     C                   IF        DDTYPE = 'CD'
     C                   IF        MaturDate <> *ZERO
     C                   EVAL      DPMD = MaturDate
     C                   ELSE
     C                   IF        MATY <> *ZEROS
     C                   EVAL      DPMD = MATY
     C                   ELSE
     C                   EVAL      DPMD = 99999
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DPMD = Maturdate
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      DPOD = D@CPDP
 
     C                   IF        DDTRTP = 'RP' or DDTRTP = 'BL'
     C                             or DDTRTP = 'PD'
     C                   EVAL      DPDO = ValueDate
     C                   ELSE
      *
      ** If this is a call loan maturity date will not have been entered
      ** Therefore set Depot In date to maturity of security. If there
      ** is no Maturity date e.g with shares set it to 99999.
      *
     C                   IF        DDTYPE = 'CL'
     C                   IF        MaturDate <> *ZERO
     C                   EVAL      DPDO = MaturDate
     C                   ELSE
     C                   IF        MATY <> *ZEROS
     C                   EVAL      DPDO = MATY
     C                   ELSE
     C                   EVAL      DPDO = 99999
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   ENDIF
     C                   EVAL      DPDO = MaturDate
     C                   ENDIF
 
     C                   EVAL      DPBA = DDBRCA
 
     C                   EVAL      ORBR = *BLANKS
 
      *
      ** If CAC005 is on convert Book Code to Pseudo Book
     C                   IF        CAC005 = 'Y'
     C                   CALL      'AOBKPCR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*PSEUDO'     POPTN             7
     C                   PARM      DDBOKC        PBOOK             2
     C                   PARM      DDPRFC        PPRFC             4
     C                   PARM                    PPSCD             2
      *
     C                   EVAL      DPBK = PPSCD
      *
     C                   ELSE
     C                   EVAL      DPBK = DDBOKC
     C                   ENDIF
 
     C                   EVAL      DPMK = MKTI
 
     C                   EVAL      DPBN = W#CNPT
 
     C                   EVAL      DPNA = D@NOML
 
     C                   EVAL      DPNR = DDNARR
 
     C                   EVAL      MKTP = D@VALP
 
     C                   MOVE      DDDLNO        DPAD
 
     C                   EVAL      DCFR = 'Y'
 
     C                   IF        DIACTN = 'I'
     C                   EVAL      CHTP = 'I'
     C                   ELSE
     C                   EVAL      CHTP = 'A'
     C                   ENDIF
 
     C                   IF        DDTRTP = 'RP' or DDTRTP = 'RR'
     C                   EVAL      RPIN = 'R'
 
     C                   ELSE
 
     C                   IF        DDTRTP = 'PL' or DDTRTP = 'PD'
     C                   EVAL      RPIN = 'P'
 
     C                   ELSE
 
     C                   EVAL      RPIN = 'B'
 
     C                   ENDIF
     C                   ENDIF
 
      ** Only update Fee Details for first depot movement
     C                   IF        RRN = 1
 
     C                   EVAL      DCCE = IFFECY
 
     C                   EVAL      DCHA = IFFEAM
 
     C                   EVAL      DCSE = IFFESM
 
     C                   EVAL      DCAB = IFBRCA
 
     C                   EVAL      DCAT = IFACCN
 
     C                   ENDIF
 
     C                   EVAL      DVIN = D@VDIN
 
     C                   EVAL      DMIN = D@MDIN
 
     C                   EVAL      DEXRT = D@EXCR
 
     C                   EVAL      DFROM = 'R'
 
      *
      ** Set Switch in-out indicator to be 'I' if depot movement is added
      ** via Margin Call program
     C                   EVAL      DRefNo = D@DPRN
     C                   IF        DIACTN = 'M' and DumConst = 'X'
     C                   EVAL      SIOI = 'I'
     C                   ENDIF
 
     C                   EVAL      DMAFRT = @@AFRT
     C                   EVAL      DMFRNT = D@FOID
 
     C                   CALLB     'MMRPDMTUP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'I'           RPDMMode
     C                   PARM                    MMTRPDM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sec_Det - Set up Detail for Subfile                          *
      *                                                               *
      * Called by: Sec_Del                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Sec_Det       BEGSR
 
     C                   CLEAR                   CrRpScnFmt
 
     ** NOW SET UP FIELDS FOR THE SUBFILE RECORD FROM MMIRPDDPD
     **                                               (Invalid Deliver Details)
 
     ** ********************
     ** Set Action to Blanks
     ** ********************
 
     C                   EVAL      DDACTN = *BLANKS
 
     ** **********************************************************
     ** Set up Associated Front Office Transaction Number (Hidden)
     ** **********************************************************
 
     C                   EVAL      D@FOAS = DDFOAS
 
     ** ***********************************************
     ** Set up Front Office Transaction Number (Hidden)
     ** ***********************************************
 
     C                   EVAL      D@FOID = DDFOID
 
     ** **************************************
     ** Set up Reference Number (hidden field)
     ** **************************************
 
     C                   EVAL      D@DPRN = DDDPMV
 
     ** ***********************
     ** Calculate Total Nominal
     ** ***********************
      *
     C                   MOVE      DDNOML        ZFIELD
     C
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC             1 0
     C                   PARM      12            ZADIG             2 0
     C
     C                   MOVE      ZFIELD        ZFLD15
     C                   MOVE      ZFIELD        W#NNOML          11 0
      *
      **  Access Security Details
     C     DDSECT        CHAIN     SECTY                              99
      *
      ** NO NEED TO CONTINUE PROCESSING IF SECURITY NOT FOUND
     C                   IF        *IN99 = '0'
      *
      ** If Nominal Decimal Places = 0 then Multiply by 10000
     C                   IF        NMDP = 0
     C     10000         MULT      ZFLD15        W#NML            15 0
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
      *
      ** If Nominal Decimal Places = 1 then Multiply by 1000
     C                   IF        NMDP = 1
     C     1000          MULT      ZFLD15        W#NML
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
     C
      *
      ** If Nominal Decimal Places = 2 then Multiply by 100
     C                   IF        NMDP = 2
     C     100           MULT      ZFLD15        W#NML            15 0
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
     C
      *
      ** If Nominal Decimal Places = 3 then Multiply by 10
     C                   IF        NMDP = 3
     C     10            MULT      ZFLD15        W#NML            15 0
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
      *
      ** If Nominal Decimal Places = 4 then Multiply by 1
     C                   IF        NMDP = 4
     C     1             MULT      ZFLD15        W#NML            15 0
     C                   ADD       W#NML         W#NOML
     C                   ENDIF
 
     ** **************************
     ** Set Up Value Date Interest
     ** **************************
     C
     ** Access Investment Details
     C
     C     INVTPK        KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
     C
     C     INVTPK        CHAIN     INVTPDF                            90
     C
     C                   IF        PROT <> '2' and PROT <> '4' and PROT <> '7'
     C
     C                   CALLB     'SEVTACCRIN'
     C                   PARM                    ReturnCode
     C                   PARM      'Y'           Default           1
     C                   PARM      'N'           Validate          1
     C                   PARM      *Blank        DDACIN            1
     C                   PARM      ValueDate     TDVD              5 0
     C                   PARM                    SECTYD
     C                   PARM                    PROT
     C                   PARM                    BJDFIN
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDAcinOK          1
     C                   PARM                    ACIN              1
      *
     C                   CALLB     'ZPCINT'
     C                   PARM                    SECTYD
     C                   PARM      *BLANK        DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM      W#NNOML       NOML
     C                   PARM      DDACIN        ZACIN
     C                   PARM      *ZERO         ZDADJ
     C                   PARM      *BLANK        ZADIN
     C                   PARM      CPNR          TDCR
     C                   PARM      *BLANK        ZCPOVR
     C                   PARM                    BJDFIN
     C                   PARM      ValueDate     ECD               5 0
      *
     C                   PARM                    ZITRA
     C                   PARM                    ZTINA
      *
      **       Calculate cross currency rate
      *
     C                   MOVE      DDEXCR        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC             1 0
     C                   PARM      7             ZADIG             2 0
     C                   MOVE      ZFIELD        W#DDEXCR         15 8
     C
     C     ZITRA         MULT      W#DDEXCR      ZFLD15
     C                   MOVE      ZITRA         W#ITRA           13 0
 
      * PROT = 2, 4, or 7
     C                   ELSE
 
     C                   Z-ADD     0             W#ITRA           13 0
     C                   ENDIF
 
     C                   Z-ADD     0             ZADEC
     C                   MOVEL     *BLANK        ZFLD15
     C                   MOVE      W#ITRA        ZFLD15
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      LoanCcy       @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   MOVE      A6NBDP        ZADEC
     C                   MOVE      A6NBDP        LoanDP            1 0
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
 
     C                   MOVE      ZOUT21        DDVDIN
 
     ** ***********************
     ** Set Up Value Date Value
     ** ***********************
      *
      * Market Value
     C                   MOVE      DDVALP        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC             1 0
     C                   PARM      7             ZADIG             2 0
     C                   MOVE      ZFIELD        ZPRCIN           15 8
      * Value Date
     C                   MOVE      ValueDate     ZFDATE            5 0
      * Nominal
     C                   MOVE      DDNOML        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC             1 0
     C                   PARM      15            ZADIG             2 0
     C                   MOVE      ZFIELD        ZNOML            15 0
      *
      * Purchased Interest as fraction of Nominal
      *
     C     ZNOML         IFNE      0
     C     W#ITRA        DIV       ZNOML         WRKPI            15 9
     C                   ELSE
     C                   Z-ADD     0             WRKPI
     C                   END
 
     C                   EXSR      PRICD
      *
      ** Set up ZPRC. Multiply ZPRCOT by 10 first as ZPRC has an extra Decimal place
     C                   Z-ADD     0             ZPRC
     C                   MULT      10            ZPRCOT
     C                   MOVE      ZPRCOT        ZPRC
 
     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM                    SPBS
     C                   PARM                    NMDP
     C                   PARM                    NomCcyDec
      * OUTPUT: Consideration
     C                   PARM                    ZCONS            15 0
 
      **  Add consideration to any interest
     C     ZCONS         ADD       ZFLD15        W#VDVL           15 0
     C
     C                   MOVE      W#VDVL        ZFLD15           15 0
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      *BLANKS       DDVDVL
     C                   MOVE      ZOUT21        DDVDVL
      *
      ** Set up Total Value
     C                   CLEAR                   P#0010
     C                   MOVE      NMCY          P#DBCY
     C                   Z-ADD     W#VDVL        P#DBAM
     C                   MOVE      DDCCY         P#CRCY
     C                   Z-ADD     0             P#CRAM
     C                   Z-ADD     BJRDNB        P#DBDT
     C                   Z-ADD     BJRDNB        P#CRDT
     C                   MOVE      W#DDEXCR      P#RATE
     C                   MOVE      'Y'           P#OVRT
     C                   MOVE      'N'           P#SDIN
     C                   Z-ADD     0             P#RTDS
     C                   MOVEL     PSProcName    P#PMSQ
     C                   MOVE      *BLANKS       P#INDC
     C                   MOVE      *BLANKS       P#RTCD
      *
     C                   CALL      'MM0011'
     C                   PARM                    P#0010
      *Database error handling
     C     P#RTCD        IFEQ      '*ERROR*'
     C                   MOVEL     'MM0011  '    DBFILE
     C                   MOVEL     '*FIRST '     DBKEY
     C                   Z-ADD     02            DBASE
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   ADD       P#CRAM        W#VLP
      *
      ** Default returned rate into exchange rate in case rate has been
      ** changed due to EMU rate requirements.
     C                   Z-ADD     0             ZFLD15
     C                   MOVE      P#RATE        ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      8             ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        DDEXCR
     C                   ENDIF
 
 
     ********************************
     ** Set Up Maturity Date Interest
     ********************************
 
     C                   Z-ADD     0             W#ITRA
     C                   Z-ADD     0             W#VALU
 
     ** Set Up Maturity Date Interest if security is interest bearing
 
     C                   IF        PROT <> '2' and PROT <> '4' and PROT <> '7'
 
     C                   MOVE      W#NNOML       NOML
 
     C                   CALLB     'ZPCINT'
     C                   PARM                    SECTYD
     C                   PARM      *BLANK        DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    NOML
     C                   PARM      DDACIN        ZACIN
     C                   PARM      *ZERO         ZDADJ
     C                   PARM      *BLANK        ZADIN
     C                   PARM      CPNR          TDCR
     C                   PARM      *BLANK        ZCPOVR
     C                   PARM                    BJDFIN
     C                   PARM      MaturDate     ECD               5 0
     C                   PARM                    ZITRA
     C                   PARM                    ZTINA
      *
      ** Calculate cross currency rate
      *
     C     ZITRA         MULT      W#DDEXCR      ZFLD15
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      LoanCcy       @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   MOVE      A6NBDP        ZADEC
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      *BLANKS       DDMDIN
     C                   MOVE      ZOUT21        DDMDIN
     C
      * PROT is equal to 2, 4 or 7
     C                   ELSE
     C                   MOVE      A6NBDP        ZADEC
     C                   MOVE      *BLANKS       DDMDIN
     C                   Z-ADD     0             ZFLD15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        DDMDIN
     C                   ENDIF
 
 
     ** **************************
     ** Set Up Maturity Date Value
     ** **************************
 
      **  Add consideration to any interest
     C     ZCONS         ADD       ZFLD15        W#VDVL           15 0
     C
     C                   MOVE      W#VDVL        ZFLD15
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      *BLANKS       DDMDVL
     C                   MOVE      ZOUT21        DDMDVL
 
     C                   ENDIF
     **
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *Header - Set up Header Details for processing                *
      *                                                               *
      * Called by: Sec_Del                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Header        Begsr
     C
     ** ****************
     ** Set up Deal Type
     ** ****************
     C                   SELECT
     C
     C     DDTRTP        WHENEQ    'RP'
     C                   EVAL      D@TYPE = 'REPO'
     C
     C     DDTRTP        WHENEQ    'RR'
     C                   EVAL      D@TYPE = 'REVERSE REPO'
     C
     C     DDTRTP        WHENEQ    'BB'
     C                   EVAL      D@TYPE = 'BOND BORROWING'
     C
     C     DDTRTP        WHENEQ    'BL'
     C                   EVAL      D@TYPE = 'BOND LENDING'
     C
     C     DDTRTP        WHENEQ    'PL'
     C                   EVAL      D@TYPE = 'PLEDGE LOAN'
     C
     C     DDTRTP        WHENEQ    'PD'
     C                   EVAL      D@TYPE = 'PLEDGE DEPOSIT'
     C
     C                   ENDSL
 
      * Retrieve Header details from trailer file
     C                   CALLB     'MMRPTRIRD'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    @@AFRT
     C                   PARM                    MMIRPTR
 
     ** *********************
     ** Setup Narrative field
     ** *********************
     C                   EVAL      DDNARR = IHNARR
     C
     ** *********************
     ** Setup Control Nominal
     ** *********************
     C                   EVAL      DDCNTN = IHCNTN
     C
     ** ********************
     ** Set up Total Nominal
     ** ********************
     C                   MOVE      TotNom        DDTOTN
     C
     ** ************************
     ** Set up Total Value Price
     ** ************************
     C                   MOVEL     *BLANK        ZFIELD           16
     C                   MOVE      TotVal        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC
     C                   MOVE      ZFIELD        DDTOTV
     C
     ** ****************************************
     ** Set up Customer Number and Customer name
     ** ****************************************
     C                   MOVE      *BLANKS       @@KEY1
     C                   MOVEL     DICUST        @@KEY1
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM                    @@KEY1           10
     C                   PARM      *BLANKS       @@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   MOVEL     BBCUST        D@CUST
     C                   MOVEL     BBCRNM        D@CRNM
 
      ** ******************
      ** Set up Fee Details
      ** ******************
 
      * Charge currency
     C                   EVAL      DDFECY = W#DCCE
     C
      * Settlement Type
     C                   IF        W#DCSE > 0
     C                   MOVE      W#DCSE        DDFESM
     C                   ELSE
     C                   EVAL      DDFESM = *BLANKS
     C                   ENDIF
     C
      * Charge Amount
     C                   IF        W#DCCE <> *Blanks
      *
      * Access Currency details via Access Object
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*DBASE '     @@OPTN            7
     C                   PARM      W#DCCE        @@AJCD            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   MOVE      W#DCHA        ZFLD15
 
     C                   MOVE      A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        DDFEAM
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  Inz_Sfl - Initialize Subfile for entry of new records        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Inz_Sfl       BEGSR
      *
      ** Save all records currently in array for redisplay
     C                   Z-ADD     0             RRN
      *
     C                   DO        En
     C                   ADD       1             RRN
      *
     C     RRN           CHAIN     MMRPDLS1                           87
      *
      ** Save deleted records in array for redisplay
      *
     C                   EVAL      SDACTN = DDACTN
     C                   EVAL      SDSECT = DDSECT
     C                   EVAL      SDNOML = DDNOML
     C                   EVAL      SDVALP = DDVALP
     C                   EVAL      SDVDIN = DDVDIN
     C                   EVAL      SDVDVL = DDVDVL
     C                   EVAL      SDORDP = DDORDP
     C                   EVAL      SDCPDP = DDCPDP
     C                   EVAL      SDEXCR = DDEXCR
     C                   EVAL      SDMDIN = DDMDIN
     C                   EVAL      SDMDVL = DDMDVL
     C                   EVAL      SDDPRN = D@DPRN
     C                   EVAL      S@SECT = D@SECT
     C                   EVAL      S@NOML = D@NOML
     C                   EVAL      S@VALP = D@VALP
     C                   EVAL      S@VDIN = D@VDIN
     C                   EVAL      S@VDVL = D@VDVL
     C                   EVAL      S@ORDP = D@ORDP
     C                   EVAL      S@CPDP = D@CPDP
     C                   EVAL      S@EXCR = D@EXCR
     C                   EVAL      S@MDIN = D@MDIN
     C                   EVAL      S@MDVL = D@MDVL
     C                   EVAL      S@EXT1 = D@EXT1
     C                   EVAL      S@CHG = D@CHG
     C                   EVAL      S@OUTP = DDOUTP
     C                   EVAL      S@NWRC = D@NWRC
     C                   EVAL      S@IN51 = D@IN51
     C                   EVAL      S@IN70 = D@IN70
     C                   EVAL      S@FOAS = D@FOAS
     C                   EVAL      S@FOID = D@FOID
      *
     C                   MOVEL     RPDLS1        SRPDL(RRN)
 
     C                   ENDDO
      *
      ** Clear subfile
      *
      *
     C                   MOVEA     '000'         *IN(1)
     C                   WRITE     MMRPDLC1
     C                   MOVEA     '111'         *IN(1)
     C
     C                   Z-ADD     0             Zn
     C
      *
      * Load up 100 subfile Records minus number of records already
      * entered.
      *
     C     100           SUB       En            Zn
     C
     C                   Z-ADD     0             RRN
     C
     C                   DO        Zn
     C
     C                   MOVEA     '00'          *IN(70)
     C                   MOVE      '0'           *IN74
     C
     C                   ADD       1             RRN
     C                   CLEAR                   MMRPDLS1
     C                   MOVE      *ON           *IN76
     C                   WRITE     MMRPDLS1
 
     C                   ENDDO
 
     C                   MOVE      *OFF          *IN09
     C                   MOVE      *OFF          *IN19
     C                   MOVE      *OFF          *IN20
      *
      ** Save Control Nominal for later use
      *                  MOVE      DDCNTN        OldNoml          15 4
      *                  DIV       100           OldNoml
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  Sec_Del - Load Subfile on entry to program                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Sec_Del       BEGSR
     C
      ** Reset subfile indicators
     C                   RESET                   *IN70
     C                   RESET                   *IN71
     C                   RESET                   *IN73
     C                   RESET                   *IN74
     C                   RESET                   *IN75
     C                   RESET                   *IN76
     C                   RESET                   *IN77
     C
      ** Reset subfile
     C                   MOVEA     '000'         *IN(1)
      ** Write header of screen
     C                   WRITE     MMRPDLC1
     C                   MOVEA     '111'         *IN(1)
     C
      ** Reset indicators
      *
     C                   MOVEA     '00'          *IN(19)
     C                   MOVEA     '000000'      *IN(40)
     C                   MOVEA     '00000000000' *IN(50)
     C                   MOVEA     '00000000'    *IN(61)
     C                   MOVEA     '0000'        *IN(70)
     C                   Z-ADD     0             RRN
     C                   Z-ADD     0             W#VLP
     C                   Z-ADD     0             W#NOML
     C                   MOVE      '0'           Ind70             1
     C                   MOVE      '0'           Ind71
     C                   MOVE      '0'           Ind73             1
     C                   MOVE      '0'           Ind74
     C                   MOVE      '0'           Ind75
     C                   Z-ADD     0             Zn
     C                   MOVE      *Blank        FeeSave
     C
      *
      ** Access Customer data via access program
      *  (database error handling done in access program)
     C                   MOVE      *BLANKS       @@KEY1
     C                   MOVEL     DICUST        @@KEY1
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM                    @@KEY1           10
     C                   PARM      *BLANKS       @@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C**********         MOVE      BBCUST        W#CNPT            6 0                        CSD027
     C                   MOVE      BBCUST        W#CNPT            6                          CSD027
      *
      * Access Currency details via Access Object
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      '*KEY   '     @@OPTN
     C                   PARM      DDCCY         @@AJCD            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   Z-ADD     A6NBDP        NomCcyDec
      *
      **  Access Branch Details via Access Object
      *  (database error handling done in access program)
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBRCA        @BR               3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** Access securities trading details
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Do not display Fee Details if transaction type is 'PR' or 'RR'.
      *
     C                   IF        DDTRTP='RP' or DDTRTP='RR'
     C                   MOVE      *ON           *IN(72)
     C                   ENDIF
      *
      ***  Define and zeroize the Purchased Interest and Interest
      ***  Adjustment Output fields and Interest work fields.
      *
     C                   Z-ADD     *ZEROS        ZITRA            13 0
     C                   Z-ADD     *ZEROS        ZTINA            13 0
      *
      ** Set up deal Ccy from imported parameter
      *
     C                   MOVE      DDCCY         LoanCcy
      *
      * Convert Value Date to Midas Day Number
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDVDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
     C                   EVAL      ValueDate = ValDateMDN
     C                   EVAL      ValDateMDN=*Zeros
      *
      * Convert Maturity Date to Midas Day Number
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDMDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
     C                   EVAL      MaturDate = ValDateMDN
 
     C                   EVAL      Branch = DDBRCA
     C                   EVAL      BenCust = DICUST
     C                   EVAL      PortRef = DDPTFR
 
     C                   MOVE      DDAMNP        ZFIELD
     C                   Z-ADD     NomCcyDec     ZADEC
     C     15            SUB       ZADEC         ZADIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C
     C                   MOVE      ZFIELD        DealAmt
      *
      * We are about to CHAIN in the First Record (F RCD)
     C                   MOVE      'Y'           W#FRCD            1
      *
      * Load up 100 subfile Records
      *
     C                   DO        100
     C
     C                   ADD       1             RRN               4 0
      *
      ** Protect Security field from change to preserve key
      ** for extant depot movement extension records
      *  (update)
     C                   IF        @OPSEL = 'U' and DIACTN <> 'I'
     C                   EVAL      *IN75 = *ON
     C                   MOVE      '1'           Ind75             1
     C                   ENDIF
      *
     ** Enquire mode? Protect all subfile records and control record fields
     ** Non-display Control nominal
     C                   IF        @OPSEL = 'N'
     C                   MOVE      *ON           *IN71
     C                   MOVE      *ON           *IN76
     C                   MOVE      *ON           *IN77
     C                   MOVE      '1'           Ind71             1
     C                   ENDIF
 
     ** Use Associated FO Tran# to access depot movements
     ** First Record is to be CHAINed and subsequent records READEd
     C                   MOVE      *OFF          *IN89
 
     C     W#FRCD        IFEQ      'Y'
     C     @@AFRT        CHAIN     MMIRPDD0                           89
     C                   MOVE      'N'           W#FRCD
 
     C                   ELSE
     C     @@AFRT        READE     MMIRPDD0                               89
     C                   ENDIF
 
 
      ** Save value of Fee Details
     C                   IF        FeeSave<>'Y' and *IN72 <> *On
 
      *Retrieve Invalid Repo deal trailer information
     C                   CALLB     'MMRPTRIRD'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    DDFOAS
     C                   PARM                    MMIRPTR
 
     C                   MOVE      IHFEAM        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC             1 0
     C                   PARM      13            ZADIG             2 0
     C                   MOVE      ZFIELD        W#DCHA
     C
     C                   EVAL      W#DCCE=IHFECY
     C                   MOVE      IHFESM        W#DCSE
     C                   EVAL      W#ACCN=IHACCN
     C                   EVAL      FeeSave='Y'
     C                   ENDIF
 
      ** If a record is found set up the details of Depot Movements on
      ** file otherwise blank out the record format and do not write record
 
     C                   IF        *IN89 = *Off
 
      *(update)
     C                   IF        @OPSEL = 'U'
     C                   MOVE      *OFF          *IN74
     C                   MOVE      '0'           Ind74             1
     C                   EXSR      SEC_DET
     C                   ENDIF
 
     C                   ADD       1             Zn
 
     C                   WRITE     MMRPDLS1
 
      * *IN89 is *ON (Record is NOT found)
     C                   ELSE
     C                   CLEAR                   MMRPDLS1
     C                   SUB       1             RRN
     C                   ENDIF
 
 
     ** Set on indicator to allow F9 to be pressed if in update mode
     C                   IF        @OPSEL = 'U'
     C                   IF        W#ORED = BJRDNB
     C                   MOVE      *ON           *IN19
     C                   ENDIF
     C                   ENDIF
      *
      ** Reset Depot Extension indicator
     C                   EVAL      D@EXT1 = *Blank
      *
     C                   ENDDO
 
 
     C                   Z-ADD     1             PRRN
      *
      ** If no records were written write a blank record and display
      ** error message that no records exist
      *
     C                   IF        Zn = 0
     C                   MOVE      *ON           *IN71
     C                   MOVE      '1'           Ind71
     C                   ADD       1             RRN
     C                   CLEAR                   MMRPDLS1
     C                   MOVE      *ON           *IN71
     C                   MOVE      '1'           Ind71
     C                   MOVE      *ON           *IN76
     C                   WRITE     MMRPDLS1
     C                   MOVEL     'MMA0792'     @MSGID
     C                   EXSR      ERRWOD
     C                   ENDIF
      *
      ** Save number of records entered per subfile
     C                   Z-ADD     Zn            En                3 0
      *
      ** Write out Header details
     C                   EXSR      HEADER
      *
      ** Format Value Price and Control Nominal
     C                   MOVE      W#NOML        ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      4             ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   MOVE      ZOUT21        DDTOTN
 
      ** Access no of decimal places of Loan Ccy to format value price
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      LoanCcy       @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   MOVE      A6NBDP        ZADEC
     C                   MOVE      W#VLP         ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      *BLANKS       DDTOTV
     C                   MOVE      ZOUT21        DDTOTV
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ERRWOD  - OUTPUT ERROR MESSAGES WITHOUT DATA                  *
      *                                                               *
      *****************************************************************
     C     ERRWOD        BEGSR
      *
      *  Display error message
      *
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID           10
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ERRWID  - OUTPUT ERROR MESSAGES WITH DATA                     *
      *                                                               *
      *****************************************************************
     C     ERRWID        BEGSR
      *
      *  Display error message
      *
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C                   CALL      'ZA0440'
     C                   PARM                    ZAMSID           10
     C                   PARM      @MSGDT        ZAMDTA           45
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
     C                   PARM                    RCODE             7
     C                   PARM                    @OPSEL
     C                   PARM                    CrDlScnFmt
     C                   PARM                    @@AFRT
      *
      **ERRORS
     C                   PARM                    GFldNameAr
     C                   PARM                    GMsgIdAr
      *
      ** Access SAR details file to determine if MT5xx Message Generation
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01401'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     'S01401'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   SETON                                        14
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   ENDIF
      *
      ** Check if CAC005 is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CAC005'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CAC005            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CAC005
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMRPDLSFL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Trading data via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      ** Access Retail details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      **  Access Bank Details via Access Object
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
     C                   ENDSR
      ********************************************************************
      * Upd_Fee - Update the Fees information
      ********************************************************************
     C     Upd_Fee       BEGSR
      *
      * Retrieve Trailer details
     C                   CALLB     'MMRPTRIRD'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    @@AFRT
     C                   PARM                    MMIRPTR
      *
     C                   CLEAR                   MMTRPDM
      *Now take fee detail and plug into  DCAB, AND DCAT in MMTRPDM
      *
      *Fee Currency
     C                   MOVE      IHFECY        DCCE
      *
      *Fee Amount
     C                   MOVE      IHFEAM        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC             1 0
     C                   PARM      13            ZADIG             2 0
     C                   MOVE      ZFIELD        DCHA
      *
      *Fee Settlement Type
     C                   MOVE      IHFESM        DCSE
      *
      *Fee Account Branch
     C                   MOVE      IHACCN        DCAB
      *
      *Fee Account
     C                   MOVEL     IHACCN        DCAT
      *
     C                   EVAL      DMAFRT = IHFOAS                                            247785
     C                   EVAL      DMFRNT = IHFOID                                            247785
      *                                                                                       247785
     C                   CALLB     'MMRPDMTUP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'F'           RPDMMode
     C                   PARM                    MMTRPDM
 
     C                   ENDSR
      ********************************************************************
      * FmtInd - Restore indicator values prior to writing Header
      ********************************************************************
     C     FmtInd        BEGSR
      *
      * F9 not pressed
     C                   IF        @INKI <> '1'
      *
     C                   IF        Ind70 = '1'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      *In70 = *Off
     C                   ENDIF
 
     C                   IF        Ind71 = '1'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      *In71 = *Off
     C                   ENDIF
 
     C                   IF        Ind73 = '1'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      *In73 = *Off
     C                   ENDIF
 
     C                   IF        Ind74 = '1'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      *In74 = *Off
     C                   ENDIF
 
     C                   IF        Ind75 = '1'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      *In75 = *Off
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
      * Restore - Restore Deleted records back to subfile if F12 taken
      *           from Confirm delete screen
      ********************************************************************
     C     Restore       BEGSR
      *
      ** Redisplay all records
      *
     C     En            SUB       DelCount      NumRec            3 0
     C                   Z-ADD     0             DelCount
     C                   Z-ADD     0             Zn
      *
      ** Write out all records which have not been deleted
      *
     C                   DO        NumRec
     C                   ADD       1             RRN
     C                   ADD       1             Zn
     C                   MOVEL     SRPDL(Zn)     RPDLS1
     C                   CLEAR                   SRPDL(Zn)
      *
      ** Restore values to Subfile Fields
      *
     C                   EVAL      DDACTN = SDACTN
     C                   EVAL      DDSECT = SDSECT
     C                   EVAL      DDNOML = SDNOML
     C                   EVAL      DDVALP = SDVALP
     C                   EVAL      DDVDIN = SDVDIN
     C                   EVAL      DDVDVL = SDVDVL
     C                   EVAL      DDORDP = SDORDP
     C                   EVAL      DDCPDP = SDCPDP
     C                   EVAL      DDEXCR = SDEXCR
     C                   EVAL      DDMDIN = SDMDIN
     C                   EVAL      DDMDVL = SDMDVL
     C                   EVAL      D@DPRN = SDDPRN
     C                   EVAL      D@SECT = S@SECT
     C                   EVAL      D@NOML = S@NOML
     C                   EVAL      D@VALP = S@VALP
     C                   EVAL      D@VDIN = S@VDIN
     C                   EVAL      D@VDVL = S@VDVL
     C                   EVAL      D@ORDP = S@ORDP
     C                   EVAL      D@CPDP = S@CPDP
     C                   EVAL      D@EXCR = S@EXCR
     C                   EVAL      D@MDIN = S@MDIN
     C                   EVAL      D@MDVL = S@MDVL
     C                   EVAL      D@EXT1 = S@EXT1
     C                   EVAL      D@CHG = S@CHG
      *
      ** If S@OUTP <> *blanks move to DDOUTP
      *
     C     S@OUTP        IFNE      *BLANKS
     C                   EVAL      DDOUTP = S@OUTP
     C                   END
      *
     C                   EVAL      D@NWRC = S@NWRC
     C                   EVAL      D@IN51 = S@IN51
     C                   EVAL      D@IN70 = S@IN70
 
      *
      ** Restore protection to subfile for amend mode past entry date
     C                   IF        D@IN70 = 'Y'
     C                   EVAL      *IN70 = *On
     C                   ELSE
     C                   EVAL      *IN70 = *Off
     C                   ENDIF
 
     C                   WRITE     MMRPDLS1
 
     C                   ENDDO
      *
      ** Set off indicator to display F10 = Delete option
      *
     C                   EVAL      *IN20 = *OFF
     C                   IF        DIACTN = 'M' or DIACTN = 'R'
     C                   EVAL      *IN19 = *ON
     C                   ENDIF
      *
      ** Set subfile record counter En to equal RRN
      *
     C                   EVAL      En = RRN
     C                   EVAL      Zn = RRN
      *
      ** Set off *IN76
      *
     C                   EVAL      *IN76 = '0'
      *
      ** Reset DelCount
      *
     C                   EVAL      DELCOUNT = 0
      *
      ** Revalidate subfile totals
      *
     C                   EXSR      Pro_Inp
      *
      ** If there are no errros then set indicator to exit program else
      ** allow control nominal to be amended
      *
     C                   IF        T#Idx = 0
     C                   EVAL      RdyToUpd='Y'
     C                   EVAL      *IN18 = *ON
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** DEFAULTING                                                   *
      *****************************************************************
     C     PRICD         BEGSR
      *
      ** Setup Parameter list
      *
      * Cum/Ex ind.
      *
     C     DDACIN        IFEQ      'X'
     C                   MOVE      'X'           SCUMEX            1
     C                   ELSE
     C                   MOVE      'C'           SCUMEX
     C                   END
      *
      ** Calculate % price from yield
      *
     C                   CALLB     'ZPRCI'
     C                   PARM                    ZPRCIN
     C                   PARM                    ZFDATE
     C                   PARM                    SECTYD
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    ZNOML
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZYLDOk            1
     C                   PARM                    ZPRCOT           15 8
 
     C                   ENDSR
      ********************************************************************
      * *PSSR  - ERROR PROCESSING
      ********************************************************************
     C     *PSSR         BEGSR
     C                   MOVEL     '*Error'      RCODE
     C                   DUMP
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
 
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** ##OX1
OVRDBF FILE(DPTMVDY1) TOFILE(QTEMP/SEDMRPX1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX2
OVRDBF FILE(DPTMVDY2) TOFILE(QTEMP/SEDMRPX2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX3
OVRDBF FILE(DPTMVDZ1) TOFILE(QTEMP/SEDMRPX1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX4
OVRDBF FILE(DPTMVDZ2) TOFILE(QTEMP/SEDMRPX2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##JF1
STRJRNPF FILE(QTEMP/SEDMRPX1) JRN(ICJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)
** ##EJ1
ENDJRNPF FILE(QTEMP/SEDMRPX1) JRN(ICJRN)
** ##JF2
STRJRNPF FILE(QTEMP/SEDMRPX2) JRN(ICJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)
** ##EJ2
ENDJRNPF FILE(QTEMP/SEDMRPX2) JRN(ICJRN)
** ##ON1
OVRDBF FILE(SECRTNL1) TOFILE(QTEMP/SECRTNTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OT1
OVRDBF FILE(SECRTTL1) TOFILE(QTEMP/SECRTTTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##DL1
DLCOBJ OBJ((QTEMP/SEDMRPX1 *FILE *SHRRD))
** ##DL2
DLCOBJ OBJ((QTEMP/SEDMRPX2 *FILE *SHRRD))
** ##JF3
STRJRNPF FILE(QTEMP/SECRTNTPPD) JRN(ICJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)
** ##EJ3
ENDJRNPF FILE(QTEMP/SECRTNTPPD) JRN(ICJRN)
** ##JF4
STRJRNPF FILE(QTEMP/SECRTTTPPD) JRN(ICJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)
** ##EJ4
ENDJRNPF FILE(QTEMP/SECRTTTPPD) JRN(ICJRN)
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
