     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*XBI *  OVRDBF FILE(SDYLDRBD) TOFILE(SDYLDRL0)                       *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Rebuild yield rate discount factor')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  RPGLE/ZADSFRBL - Rebuild Yield Rate Discount Factor          *
      *                                                               *
      *  Function: This program calculates discount factors for a     *
      *            Yield Curve/Currency and Interest Calculation      *
      *            Method and updates the discount factors on the     *
      *            Yield Rates File. This will be done for Yield      *
      *            Curves with a Zero coupon curve.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      *  Prev Amend No. BUG13149           Date 30Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12254           Date 19Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 228390             Date 14Jul04               *
      *                 228362             Date 07Jul04               *
      *                 CAS008             Date 16Jun04               *
      *                 224743             Date 15Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 208058             Date 08Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG13149 - Incorrect discount factor due to wrong spot date. *
      *  BUG12254 - Additional Calculation Method for FRA/IRS/CCF     *
      *           Method 9 - Actual/365 or 366 for Feb 29 period      *
      *           Applied CIR013.                                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *  228362 - Comment out COMMIT command which prevented delete   *
      *           of records in SDVYRATPD in RPG/SDYRATUPC since      *
      *           file pointer is reset after COMMIT.                 *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  224743 - If CIR004 is installed, system should               *
      *           allow interest calculation method '7'.              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  208058 - Incorrect Discount Factor calculated                *
      *           for leap year.                                      *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *  70-71          End-of-File indicator                         *
      *  98             Date format                                   *
      *  LR             End Call of program                           *
      *  U7-U8          Error handling                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine Index:                                            *
      *                                                               *
      *  SRLoad - Load Rates Arrays                                   *
      *  SRCalc - Calculate Discount Factors                          *
      *  SRCDat - Cash Flow Dates                                     *
      *  SRCFlw - Cash Flow Calculation                               *
      *  SRCPsV - Present Value Calculation                           *
      *  SRAdjs - Adjustments for monthend spotdays                   *
      *  SRBDys - Standard Subroutine to Calculate the Number of Days *
      *           between two Dates and the Number of Days in Year,   *
      *           for a Calculation Basis, (Dealing version).         *
      *  *PSSR - Error Subroutine                                     *
      *                                                               *
      *****************************************************************
 
     FSDYLDCL1  IF   E           K DISK    INFSR(*PSSR)
      ** Yield Curves File by Yield Curve
 
     FSDYLDRBD  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Yield Rates File
 
      ** Program Status Data Structure                                                        CSC022
      ** =============================                                                        CSC022
      ** The following /COPY line includes all the defined fields in the                      CSC022
      ** PSDS.  They have meaningful names, prefixed by 'PS'.                                 CSC022
      **                                                                                      CSC022
      /COPY ZACPYSRC,PSDS                                                                     CSC022
      **                                                                                      CSC022
      ** Array for Copyright Statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Array for Discount Factor
     D Wa              S             20  9 DIM(9999)
 
      ** Array for Cash flow dates
     D CDAT            S              5  0 DIM(9999)
 
      ** Array for Cash flows
     D CFLW            S             15  9 DIM(9999)
 
      ** Array for Present Values
     D CPSV            S             15  9 DIM(9999)
 
      ** Array Indexes
     D W               S              4  0
     D X               S              4  0
     D Z               S              4  0
                                                                                            BUG12254
     D ZZStartDate     S              8S 0                                                  BUG12254
     D ZZEndDate       S              8S 0                                                  BUG12254
     D @@Rtn           S              1A                                                    BUG12254
     D #29Feb          S              1A                                                    BUG12254
 
     D ZF29            S              5  0 DIM(32) CTDATA PERRCD(14)
 
      ** Data Structure for Cash Flow Dates
     D                 DS
     D  WCFDMY                 1      6  0
     D  WCFDAY                 1      2  0
     D  WCFMON                 3      4  0
     D  WCFYER                 5      6  0
 
      ** Data Structure for date
     D                 DS
     D WKDATE                  1      6
     D  Wfrst                  1      2
     D  Wsecd                  3      4
     D  Wthrd                  5      6
 
      ** Long data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Local Data area for database error
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
 
      ** Bank Details accessed via access program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details accessed via access program
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **                                                                                      CSC022
      ** Externally described DS for SAR details                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
                                                                                              CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
                                                                                              CSC022
      ** Commitment Control Array                                                             CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
 
      ** Define work variable for CAS008 enhancement                                          CAS008
     D CAS008          S              1                                                       CAS008
     D ZNRDYS          S              2  0                                                    CAS008
                                                                                              CAS008
      /EJECT
 
      ** Main Processing
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD             7
     C                   PARM                    PYLDN             5
     C                   PARM                    PCCY              3
     C                   PARM                    PICM              1
 
     C     KLYLDR        KLIST
     C                   KFLD                    PYLDN
     C                   KFLD                    PCCY
     C                   KFLD                    PICM
 
     C                   MOVEA     CPY@          BIS@             80
 
     C                   EVAL      DBPGM = 'ZADSFRBL'
      *                                                                                       224743
      ** Check if switchable feature CIR004 is switched on                                    224743
      *                                                                                       224743
     C                   CALLB     'AOSARDR0'                                                 224743
     C                   PARM      *BLANKS       @RTCD             7                          224743
     C                   PARM      '*VERIFY '    @OPTN             7                          224743
     C                   PARM      'CIR004'      @SARD             6                          224743
     C     SCSARD        PARM      SCSARD        DSFDY                                        224743
                                                                                              224743
     C     @RTCD         IFEQ      *BLANKS                                                    224743
     C                   MOVE      'Y'           CIR004            1                          224743
     C                   ELSE                                                                 224743
     C                   MOVE      'N'           CIR004                                       224743
     C                   ENDIF                                                                224743
                                                                                              CAS008
      ** Check if switchable feature CAS008 is switched on                                    CAS008
                                                                                              CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       @RTCD                                        CAS008
     C                   PARM      '*VERIFY '    @OPTN                                        CAS008
     C                   PARM      'CAS008'      @SARD                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
     C                   IF        @RTCD <> *BLANKS AND                                       CAS008
     C                             @RTCD <> '*NRF   '                                         CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE  = 6                                                 CAS008
     C                   EVAL      DBKEY  = 'CAS008'                                          CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        @RTCD = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   ENDIF                                                                CAS008
 
      ** Call access program for bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        WRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     WOPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       WRTCD                                        CSC022
     C                   Parm      '*VERIFY'     WOPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Database Error                                                                       CSC022
      *                                                                                       CSC022
     C                   If        WRTCD <> *BLANKS and                                       CSC022
     C                             WRTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 6                                                  CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        WRTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
      **  Set Date Format Indicator
 
     C                   IF        BJDFIN = 'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
 
      ** Initialize
 
     C                   MOVEL     *BLANK        WoYLDN            5
     C                   MOVEL     *BLANK        WoCCY             3
     C                   MOVEL     *BLANK        WoICM             1
     C                   MOVEL     *BLANK        WoCFRQ            1
     C                   MOVEL     'ALL'         WCCY              3
 
      ** Read the Yield Rates File
 
     C     *LOVAL        SETLL     SDYLDRBD
 
     C     PYLDN         IFEQ      *BLANKS
     C                   READ      SDYLDRBD                               70
     C                   ELSE
     C     KLYLDR        CHAIN     SDYLDRBD                           70
     C                   ENDIF
 
     C                   DOW       *IN70 = *OFF
 
      ** Don't calculate discount factor when yield curve is not a zero
      ** coupon yield curve.
 
     C                   IF        FSYLDC <> WkYLDN
     C                   MOVEL     FSYLDC        WkYLDN            5
     C     FSYLDC        CHAIN     SDYLDCL1                           71
 
     C                   IF        *IN71 = *ON
     C                   MOVEL     'SDYLDCL1'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     FSYLDC        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Process rates for zero coupon yield curves
 
     C                   IF        FSYLDT = 'Z'
     C                             OR FSYLDT = 'S'                                            228390
      *                                                                                       208058
      ** Get Rate Date DDMMYY Equivalent                                                      208058
      *                                                                                       208058
     C                   Z-ADD     FSMMDN        ZDAYNO                                       208058
     C                   CALL      'ZDATE2'                                                   208058
     C                   PARM                    ZDAYNO                                       208058
     C                   PARM                    BJDFIN                                       208058
     C                   PARM      *ZEROS        ZDATE                                        208058
     C                   PARM      *blanks       ZADATE                                       208058
     C                   MOVE      ZDATE         WKDATE                                       208058
     C                   MOVE      Wthrd         ZYEAR                                        208058
                                                                                              208058
     C                   IF        *IN98 = *ON                                                208058
     C                   MOVE      Wfrst         ZMTH                                         208058
     C                   MOVE      Wsecd         ZDAY                                         208058
     C                   ELSE                                                                 208058
     C                   MOVE      Wfrst         ZDAY                                         208058
     C                   MOVE      Wsecd         ZMTH                                         208058
     C                   ENDIF                                                                208058
                                                                                              208058
     C                   Z-ADD     ZDAY          WKDINT            2 0                        208058
 
      ** On change of currency
 
     C                   IF        FSYCCY <> WCCY
     C                   MOVEL     FSYCCY        WCCY
 
      ***If*rates*are*for*all*currencies,*spot*must*be*today                                BUG13149
 
     C**********         IF        FSYCCY = *BLANKS                                         BUG13149
     C**********         Z-ADD     BJRDNB        WkSPOT            5 0                      BUG13149
     C**********         ELSE                                                               BUG13149
 
      ** Retrieve Spot Days
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      FSYCCY        WCRKEY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        WRTCD <> *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     FSYCCY        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                              BUG13149
 
      **  Determine Spot Date
 
      ** If rates are for all currencies, spot must be today                                BUG13149
                                                                                            BUG13149
     C                   IF        FSYCCY = *BLANKS                                         BUG13149
     C                   Z-ADD     BJRDNB        WkSPOT            5 0                      BUG13149
     C                   ELSE                                                               BUG13149
                                                                                              CAS008
      ** If CAS008 is installed, use spot days defined for the yield                          CAS008
      ** rates instead of the one defined for the currency when                               CAS008
      ** calculating for spot date.                                                           CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      ZNRDYS = FSSPDY                                            CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      ZNRDYS = A6SPDY                                            CAS008
     C                   ENDIF                                                                CAS008
     C                   CALL      'ZFWDT'
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C**********         PARM      A6SPDY        ZNRDYS            2 0                        CAS008
     C                   PARM                    ZNRDYS                                       CAS008
     C                   PARM      0             ZDYNBR            5 0
     C                   PARM      FSYCCY        ZCCY              3
     C                   PARM      *blanks       ZLOC              3
 
     C                   Z-ADD     ZDYNBR        WkSPOT
     C                   ENDIF
 
     C**********         ENDIF                                                              BUG13149
 
      ** On change of yield curve, currency, int.cal.mth. or frequency code
 
     C                   IF        (FSYLDC <> WoYLDN) OR (FSYCCY <> WoCCY) OR
     C                             (FSYICM <> WoICM) OR (FSYCFQ <> WoCFRQ)
 
     C                   MOVEL     FSYLDC        WoYLDN
     C                   MOVEL     FSYCCY        WoCCY
     C                   MOVEL     FSYICM        WoICM
     C                   MOVEL     FSYCFQ        WoCFRQ
 
      ** Determine period 1 using spot date for
      ** discount factor calculation.
 
     C                   Z-ADD     WkSPOT        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *zeros        ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVE      ZDATE         WKDATE
     C                   MOVE      Wthrd         ZYEAR
     C                   IF        *IN98 = *ON
     C                   MOVE      Wfrst         ZMTH
     C                   MOVE      Wsecd         ZDAY
     C                   ELSE
     C                   MOVE      Wfrst         ZDAY
     C                   MOVE      Wsecd         ZMTH
     C                   ENDIF
 
     C                   Z-ADD     ZYEAR         WCFYER
     C                   Z-ADD     ZMTH          WCFMON
     C                   Z-ADD     ZDAY          WCFDAY
 
      ** For Daily compounding just add one day to spot
 
     C                   IF        FSYCFQ = 'D'
     C     WkSPOT        ADD       1             WPER1             5 0
     C                   ELSE
                                                                                              228390
     C                   IF        FSYCFQ = 'C'                                               228390
     C                   ELSE                                                                 228390
                                                                                              228390
     C*
     C                   SELECT
 
      **  Annual compounding
 
     C     FSYCFQ        WHENEQ    'Y'
     C                   ADD       1             WCFYER
 
      ** Semi-annual compounding
 
     C     FSYCFQ        WHENEQ    'X'
 
     C                   Z-ADD     WCFDAY        WPRVDY            2 0
     C                   Z-ADD     WCFMON        WPRVMO            2 0
     C                   Z-ADD     WCFYER        WPRVYR            2 0
 
     C                   ADD       6             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
      ***Call*subroutine to check if monthend and do adjustments                              208058
      **********                                                                              208058
     C**********         EXSR      SRAdjs                                                     208058
 
      ** Quarterly compounding
 
     C     FSYCFQ        WHENEQ    'Q'
 
     C                   Z-ADD     WCFDAY        WPRVDY
     C                   Z-ADD     WCFMON        WPRVMO
     C                   Z-ADD     WCFYER        WPRVYR
 
     C                   ADD       3             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
      ***Call*subroutine to check if monthend and do adjustments                              208058
      **********                                                                              208058
     C**********         EXSR      SRAdjs                                                     208058
 
     C                   OTHER
     C                   MOVEL     'FSYCFQ  '    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     *blanks       DBKEY
     C                   MOVEL     FSYCFQ        DBKEY
     C                   EXSR      *PSSR
 
     C                   ENDSL
 
     C                   EXSR      SRAdjs                                                     208058
                                                                                              208058
     C                   Z-ADD     WCFDMY        WDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    WERR              7
     C                   PARM                    WDATE             6 0
     C                   PARM      'D'           WDATFM            1
     C                   PARM                    WDAYNO            5 0
     C*
     C                   Z-ADD     WDAYNO        WPER1             5 0
     C                   ENDIF
     C                   ENDIF                                                                228390
 
      ** Initialise array index and arrays
 
     C                   Z-ADD     1             X
     C                   Z-ADD     *ZERO         Wa
 
      ** Initialise previous day number
 
     C                   Z-ADD     WkSPOT        WkMMDN            5 0
 
     C                   ENDif
 
      ** Load rates into an array
 
     C                   EXSR      SRLoad
 
      ** Calculate discount factors
 
     C                   EXSR      SRCalc
 
      ** Update the discount factor
 
     C                   Z-ADD     Wa(X)         FSDSCF
     C                   UPDATE    SDYLDRD0
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C**********         COMMIT                                                               228362
     C                   EndIf                                                                CSC022
 
     C                   ENDIF
 
      ** Read next rate
 
     C     PYLDN         IFEQ      *blanks
     C                   READ      SDYLDRBD                               70
     C                   ELSE
     C     KLYLDR        READE     SDYLDRBD                               70
     C                   ENDIF
 
     C                   ENDDO
 
      ** Terminate program
 
     C                   MOVEL     '1'           *INLR
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SRAdjs - Adjustments for monthend spotdays                    *
      *                                                               *
      * Called by: Main, SRCDat                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRAdjs        BEGSR
 
      ** For 30-day months,
 
     C                   IF        ((WCFMON = 4) OR (WCFMON = 6) OR
     C                             (WCFMON = 9) OR (WCFMON = 11)) AND
     C                             (WCFDAY > 30)
     C                   Z-ADD     30            WCFDAY
     C                   ENDIF
                                                                                              208058
      ** For 31-day months,                                                                   208058
                                                                                              208058
     C                   IF        ((WCFMON = 1) OR (WCFMON = 3) OR                           208058
     C                             (WCFMON = 5) OR (WCFMON = 7) OR                            208058
     C                             (WCFMON = 8) OR (WCFMON = 12) OR                           208058
     C                             (WCFMON = 10)) AND (WKDINT = 31)                           208058
     C                   Z-ADD     31            WCFDAY                                       208058
     C                   ENDIF                                                                208058
 
      ** For month of February,
 
     C                   IF        (WCFMON = 2)
     C                   MOVE      'N'           WKLEAP            1
     C                   Z-ADD     0             WKQUOT            2 2
     C                   MOVE      '00'          WKRMDR            2
     C     WCFYER        DIV       4             WKQUOT
     C                   MOVE      WKQUOT        WKRMDR
 
     C                   IF        WKRMDR = '00'
     C                   MOVE      'Y'           WKLEAP
     C                   ENDIF
 
     C**********         IF        WKLEAP = 'Y' AND WCFDAY > 29                               208058
     C                   IF        WKLEAP = 'Y'                                               208058
     C                   IF        WKDINT = 29 OR WCFDAY > 29                                 208058
     C                   Z-ADD     29            WCFDAY
     C                   ENDIF                                                                208058
     C                   ENDIF
 
     C                   IF        WKLEAP = 'N' AND WCFDAY > 28
     C                   Z-ADD     28            WCFDAY
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         IF        WCFMON = 1 OR WCFMON = 3 OR                                208058
     C**********                   WCFMON = 5 OR WCFMON = 7 OR                                208058
     C**********                   WCFMON = 8 OR WCFMON = 10 OR                               208058
     C**********                   WCFMON = 12                                                208058
     C**********         SELECT                                                               208058
      **********                                                                              208058
     C**********         WHEN      (WPRVMO = 4 OR WPRVMO = 6 OR                               208058
     C**********                   WPRVMO = 9 OR WPRVMO = 11) AND                             208058
     C**********                   WPRVDY = 30                                                208058
     C**********         Z-ADD     31            WCFDAY                                       208058
      **********                                                                              208058
     C**********         WHEN      (WPRVMO = 2)                                               208058
     C**********         MOVE      'N'           WKLEAP            1                          208058
     C**********         Z-ADD     0             WKQUOT            2 2                        208058
     C**********         MOVE      '00'          WKRMDR            2                          208058
     C*****WPRVYR        DIV       4             WKQUOT                                       208058
     C**********         MOVE      WKQUOT        WKRMDR                                       208058
      **********                                                                              208058
     C**********         IF        WKRMDR = '00'                                              208058
     C**********         MOVE      'Y'           WKLEAP                                       208058
     C**********         ENDIF                                                                208058
      **********                                                                              208058
     C**********         IF        (WKLEAP = 'Y' AND WPRVDY = 29) OR                          208058
     C**********                   (WKLEAP = 'N' AND WPRVDY = 28)                             208058
     C**********         Z-ADD     31            WCFDAY                                       208058
     C**********         ENDIF                                                                208058
      **********                                                                              208058
     C**********         ENDSL                                                                208058
      **********                                                                              208058
     C**********         ENDIF                                                                208058
      **********                                                                              208058
     C**********         IF        WCFMON = 4 OR WCFMON = 6 OR                                208058
     C**********                   WCFMON = 9 OR WCFMON = 11                                  208058
      **********                                                                              208058
     C**********         IF        (WPRVMO = 2)                                               208058
     C**********         MOVE      'N'           WKLEAP            1                          208058
     C**********         Z-ADD     0             WKQUOT            2 2                        208058
     C**********         MOVE      '00'          WKRMDR            2                          208058
     C*****WPRVYR        DIV       4             WKQUOT                                       208058
     C**********         MOVE      WKQUOT        WKRMDR                                       208058
      **********                                                                              208058
     C**********         IF        WKRMDR = '00'                                              208058
     C**********         MOVE      'Y'           WKLEAP                                       208058
     C**********         ENDIF                                                                208058
      **********                                                                              208058
     C**********         IF        (WKLEAP = 'Y' AND WPRVDY = 29) OR                          208058
     C**********                   (WKLEAP = 'N' AND WPRVDY = 28)                             208058
     C**********         Z-ADD     30            WCFDAY                                       208058
     C**********         ENDIF                                                                208058
      **********                                                                              208058
     C**********         ENDIF                                                                208058
      **********                                                                              208058
     C**********         ENDIF                                                                208058
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRLoad    - Load Rates Arrays                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRBDys                                                 *
      *                                                               *
      *****************************************************************
     C     SRLoad        BEGSR
 
      ** Increment array index by 1
 
     C                   ADD       1             X
 
      ** If within Period 1
      ** Calculate the number of days/divisor basis from spot date
 
     C                   IF        FSMMDN <= WPER1
     C                             OR FSYLDT = 'Z'                                            228390
     C                   Z-ADD     WkSPOT        WkMMDN
     C                   ENDIF
 
      ** Calculate the number of days/divisor basis in the period
 
     C                   Z-ADD     WkMMDN        ZCBSDT
     C                   Z-ADD     FSMMDN        ZCBEDT
     C                   MOVEL     FSYICM        ZCBCBS
     C                   EXSR      SRBDys
 
      ** Update previous day number
 
     C                   Z-ADD     FSMMDN        WkMMDN
     C*
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRCalc - Calculate Discount Factors                           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRCDat, SRCFlw, SRCPsV                                 *
      *                                                               *
      *****************************************************************
     C     SRCalc        BEGSR
 
     C                   IF        FSYLDT = 'Z'                                               228390
                                                                                              228390
     C                   IF        FSMMDN <= WkSPOT                                           228390
     C                   Z-ADD     1             Wa(X)                                        228390
     C                   ELSE                                                                 228390
                                                                                              228390
     C                   IF        FSYCFQ = 'C'                                               228390
     C                   EXSR      SRCfrq                                                     228390
     C                   ELSE                                                                 228390
     C                   EXSR      SRZtyp                                                     228390
     C                   ENDIF                                                                228390
     C                   ENDIF                                                                228390
                                                                                              228390
     C                   ELSE                                                                 228390
      ** Process for Period 1
      ** --------------------
 
     C                   IF        FSMMDN <= WPER1
 
     C                   IF        FSMMDN <= WkSPOT
     C                   Z-ADD     1             Wa(X)
     C                   ELSE
 
      ** Weight the rate by number of days/divisor basis in the period
 
     C     FSYRAT        DIV       100           WRTW             11 9
     C                   MULT      ZCBDAY        WRTW
     C                   DIV       ZCBDIV        WRTW
 
      ** Discount Factor = 1 / ( 1 + Weighted Rate)
 
     C     1             ADD       WRTW          WWFLD1           20 9
     C     1             DIV(H)    WWFLD1        Wa(X)
     C                   ENDIF
 
     C                   ELSE
 
      ** Process for Period 1 onwards
      ** -----------------------------
 
     C                   MOVEA     *ZEROS        CDAT
     C                   MOVEA     *ZEROS        CFLW
     C                   MOVEA     *ZEROS        CPSV
     C                   Z-ADD     1             Z
 
      ** First Cash Flow point is always Spot
 
     C                   Z-ADD     WkSPOT        CDAT(Z)
 
      ** Spot Date Cash Flow and Present Value will always be -100
 
     C                   Z-SUB     100           CFLW(Z)
     C                   Z-SUB     100           CPSV(Z)
 
      ** Succeeding cash flow points,
 
     C     CDAT(Z)       DOWLT     FSMMDN
     C                   ADD       1             Z
 
      ** Cash Flow dates
 
     C                   EXSR      SRCDat
 
      ** Cash Flows
 
     C                   EXSR      SRCFlw
 
      ** Present Values
 
     C                   EXSR      SRCPsV
 
      ** Calculate Discount Factor
 
     C                   IF        CDAT(Z) = FSMMDN
 
      **                    Maturity Date Present Value
      ** Discount Factor = -----------------------------
      **                      Maturity Date Cash Flow
 
     C     CPSV(Z)       DIV(H)    CFLW(Z)       Wa(X)
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF                                                                228390
 
     C     CALC9         ENDSR
      *****************************************************************
      *                                                               *
      *  SRCDat - Cash Flow Dates                                     *
      *                                                               *
      * Called by: SRCalc                                             *
      *                                                               *
      * Calls: SRAdjs                                                 *
      *                                                               *
      *****************************************************************
     C     SRCDat        BEGSR
 
      ** Daily Compounding Cash Flow Dates
 
     C                   IF        FSYCFQ = 'D'
 
      ** First Coupon Date
 
     C                   IF        Z = 2
     C     WkSPOT        ADD       1             WDCDAT            5 0
     C                   ELSE
 
      ** Succeeding Coupon Dates
 
     C                   ADD       1             WDCDAT
     C                   ENDIF
 
     C                   Z-ADD     WDCDAT        CDAT(Z)
 
     C                   ELSE
 
      ** First Coupon Date
 
     C                   IF        Z = 2
 
      ** Get Rate Date DDMMYY Equivalent
 
     C                   Z-ADD     FSMMDN        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *blanks       ZADATE
     C                   MOVE      ZDATE         WKDATE
     C                   MOVE      Wthrd         ZYEAR
 
     C                   IF        *IN98 = *ON
     C                   MOVE      Wfrst         ZMTH              2 0
     C                   MOVE      Wsecd         ZDAY              2 0
     C                   ELSE
     C                   MOVE      Wfrst         ZDAY
     C                   MOVE      Wsecd         ZMTH
     C                   ENDIF
 
     C                   Z-ADD     ZYEAR         WCFYER
     C                   Z-ADD     ZMTH          WCFMON
     C                   Z-ADD     ZDAY          WCFDAY
 
      ** Change year to spot year to come up with the first coupon date
 
     C                   Z-ADD     WkSPOT        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *blanks       ZADATE
     C                   MOVE      ZDATE         WKDATE
     C                   MOVE      Wthrd         ZYEAR             2 0
 
     C                   IF        *IN98 = *ON
     C                   MOVE      Wfrst         ZMTH
     C                   MOVE      Wsecd         ZDAY
     C                   ELSE
     C                   MOVE      Wfrst         ZDAY
     C                   MOVE      Wsecd         ZMTH
     C                   ENDIF
 
      ** Subtract 1 year from spot to cope up with semi-annual and quarterly
      ** compounding
 
     C                   IF        (FSYCFQ = 'X') OR (FSYCFQ = 'Q')
     C                   IF        ZYEAR = 00
     C                   Z-ADD     99            WCFYER
     C                   ELSE
     C     ZYEAR         SUB       1             WCFYER
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     ZYEAR         WCFYER
     C                   ENDIF
                                                                                              208058
     C                   EXSR      SRAdjs                                                     208058
 
      ** Convert to Midas date
 
     C                   Z-ADD     WCFDMY        WDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    WERR              7
     C                   PARM                    WDATE             6 0
     C                   PARM      'D'           WDATFM            1
     C                   PARM                    WDAYNO            5 0
 
     C                   SELECT
 
      ** Annual Compounding
 
     C     FSYCFQ        WHENEQ    'Y'
     C     WDAYNO        ANDLE     WkSPOT
     C                   ADD       1             WCFYER
     C                   EXSR      SRAdjs                                                     208058
     C                   Z-ADD     WCFDMY        WDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    WERR              7
     C                   PARM                    WDATE             6 0
     C                   PARM      'D'           WDATFM            1
     C                   PARM                    WDAYNO            5 0
 
      ** Semi-annual compounding
 
     C     FSYCFQ        WHENEQ    'X'
     C                   DOW       WDAYNO <= WkSPOT
 
     C                   Z-ADD     WCFDAY        WPRVDY
     C                   Z-ADD     WCFMON        WPRVMO
     C                   Z-ADD     WCFYER        WPRVYR
 
     C                   ADD       6             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
      ** Call subroutine to check if monthend and do adjustments
 
     C                   EXSR      SRAdjs
 
     C                   Z-ADD     WCFDMY        WDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    WERR
     C                   PARM                    WDATE
     C                   PARM      'D'           WDATFM
     C                   PARM                    WDAYNO
     C                   ENDDO
 
      ** Quarterly compounding
 
     C     FSYCFQ        WHENEQ    'Q'
 
     C                   DOW       WDAYNO <= WkSPOT
 
     C                   Z-ADD     WCFDAY        WPRVDY
     C                   Z-ADD     WCFMON        WPRVMO
     C                   Z-ADD     WCFYER        WPRVYR
 
     C                   ADD       3             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
      ** Call subroutine to check if monthend and do adjustments
 
     C                   EXSR      SRAdjs
 
     C                   Z-ADD     WCFDMY        WDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    WERR
     C                   PARM                    WDATE
     C                   PARM      'D'           WDATFM
     C                   PARM                    WDAYNO
     C                   ENDDO
 
     C                   ENDSL
 
      ** Succeeding Coupon Dates
 
     C                   ELSE
 
     C                   SELECT
 
      ** Annual compounding
 
     C     FSYCFQ        WHENEQ    'Y'
     C                   ADD       1             WCFYER
 
      ** Semi-annual compounding
 
     C     FSYCFQ        WHENEQ    'X'
 
     C                   Z-ADD     WCFDAY        WPRVDY
     C                   Z-ADD     WCFMON        WPRVMO
     C                   Z-ADD     WCFYER        WPRVYR
 
     C                   ADD       6             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
      ***Call*subroutine to check if monthend and do adjustments                              208058
      ********                                                                                208058
     C********           EXSR      SRAdjs                                                     208058
 
      ** Quarterly compounding
 
     C     FSYCFQ        WHENEQ    'Q'
 
     C                   Z-ADD     WCFDAY        WPRVDY
     C                   Z-ADD     WCFMON        WPRVMO
     C                   Z-ADD     WCFYER        WPRVYR
 
     C                   ADD       3             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
      ***Call*subroutine to check if monthend and do adjustments                              208058
      **********                                                                              208058
     C**********         EXSR      SRAdjs                                                     208058
 
     C                   ENDSL
 
     C                   EXSR      SRAdjs                                                     208058
                                                                                              208058
     C                   Z-ADD     WCFDMY        WDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    WERR              7
     C                   PARM                    WDATE             6 0
     C                   PARM      'D'           WDATFM            1
     C                   PARM                    WDAYNO            5 0
 
     C                   ENDIF
 
     C                   Z-ADD     WDAYNO        CDAT(Z)
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRCFlw - Cash Flow Calculation                                *
      *                                                               *
      * Called by: SRCalc                                             *
      *                                                               *
      * Calls: SRBDys                                                 *
      *                                                               *
      *****************************************************************
     C     SRCFlw        BEGSR
 
      ** Use spot date as start date when calculating number of days
      ** for the second cash flow point, otherwise
      ** calculate the number of days within the period.
 
     C                   IF        Z > 2
     C     Z             SUB       1             W
     C                   Z-ADD     CDAT(W)       ZCBSDT
     C                   ELSE
     C                   Z-ADD     WkSPOT        ZCBSDT
     C                   ENDIF
 
      ** Calculate the number of days/divisor basis
 
     C                   Z-ADD     CDAT(Z)       ZCBEDT
     C                   MOVEL     FSYICM        ZCBCBS
     C                   EXSR      SRBDys
 
      ** Cash Flows
 
     C     FSYRAT        MULT(H)   ZCBDAY        WCFLW            15 9
     C                   DIV(H)    ZCBDIV        WCFLW
 
      ** For Maturity Date, cash flow would be 100 + the final coupon
 
     C                   IF        CDAT(Z) = FSMMDN
     C                   ADD       100           WCFLW
     C                   ENDIF
 
     C                   Z-ADD     WCFLW         CFLW(Z)
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRCPsV - Present Value Calculation                            *
      *                                                               *
      * Called by: SRCalc                                             *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SRCPsV        BEGSR
 
     C                   SELECT
 
     C     CDAT(Z)       WHENNE    FSMMDN
 
      ** Retrieve Discount Factor for Cash Flow point
      ** Use FSNDRTV just to retrieve the Discount Factor
 
     C                   Z-ADD     CDAT(Z)       POPFDt
 
     C                   CALL      'ZADSFRTV'
     C                   PARM      *blanks       PORtCd            7
     C                   PARM      *blanks       PORatF            5
     C                   PARM      FSYLDC        POPYld            5
     C                   PARM      FSYCCY        POPCcy            3
     C                   PARM      FSYICM        POPInC            1
     C                   PARM                    POPFDt            5 0
     C                   PARM      *ZERO         PODsFc           13 9
 
     C                   IF        PORtCd = '*ERROR ' OR PORtCd = '*NRF   '
     C                   MOVE      'ZADSFRTV'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     PORtCd        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     CFLW(Z)       MULT(H)   PODsFc        WCPSV            15 9
 
      ** For Maturity Date, present value would be the sum of all previous
      ** present value cash flows subtracted from 0.
 
     C     CDAT(Z)       WHENEQ    FSMMDN
     C                   XFOOT(H)  CPSV          WCPSV
     C                   MULT      -1            WCPSV
 
     C                   ENDSL
 
     C                   Z-ADD     WCPSV         CPSV(Z)
 
     C                   ENDSR
      *****************************************************************                       228390
      *                                                               *                       228390
      * SRCfrq - Calculate discount factor for compounding freq C     *                       228390
      *                                                               *                       228390
      * Called by: SRCalc                                             *                       228390
      *                                                               *                       228390
      * Calls: None                                                   *                       228390
      *                                                               *                       228390
      *****************************************************************                       228390
     C     SRCfrq        BEGSR                                                                228390
                                                                                              228390
     C                   Z-ADD     2.718281828   WEXPN            10 9                        228390
     C                   Z-ADD     0             WRATP            11 9                        228390
     C     FSYRAT        DIV       100           WRATP                                        228390
     C                   Z-ADD     0             WTIMY            14 9                        228390
     C     ZCBDAY        DIV       ZCBDIV        WTIMY                                        228390
     C                   MULT      WRATP         WTIMY                                        228390
     C                   MULT      -1            WTIMY                                        228390
     C                   EVAL      Wa(X) = WEXPN ** WTIMY                                     228390
                                                                                              228390
     C                   ENDSR                                                                228390
      *****************************************************************                       228390
      *                                                               *                       228390
      * SRZtyp - Calculate discount factor for yield curve type Z     *                       228390
      *                                                               *                       228390
      * Called by: SRCalc                                             *                       228390
      *                                                               *                       228390
      * Calls: None                                                   *                       228390
      *                                                               *                       228390
      *****************************************************************                       228390
     C     SRZtyp        BEGSR                                                                228390
                                                                                              228390
     C                   SELECT                                                               228390
                                                                                              228390
     C     FSYCFQ        WHENEQ    'Y'                                                        228390
     C                   Z-ADD     1             WCFRQ             3 0                        228390
                                                                                              228390
     C     FSYCFQ        WHENEQ    'X'                                                        228390
     C                   Z-ADD     2             WCFRQ                                        228390
                                                                                              228390
     C     FSYCFQ        WHENEQ    'Q'                                                        228390
     C                   Z-ADD     4             WCFRQ                                        228390
                                                                                              228390
     C                   OTHER                                                                228390
                                                                                              228390
      ** Get Rate Date DDMMYY Equivalent                                                      228390
                                                                                              228390
     C                   Z-ADD     FSMMDN        ZDAYNO                                       228390
     C                   CALL      'ZDATE2'                                                   228390
     C                   PARM                    ZDAYNO                                       228390
     C                   PARM                    BJDFIN                                       228390
     C                   PARM      *ZEROS        ZDATE                                        228390
     C                   PARM      *blanks       ZADATE                                       228390
     C                   MOVE      ZDATE         WKDATE                                       228390
     C                   MOVE      Wthrd         ZYEAR                                        228390
                                                                                              228390
     C                   IF        *IN98 = *ON                                                228390
     C                   MOVE      Wfrst         ZMTH                                         228390
     C                   ELSE                                                                 228390
     C                   MOVE      Wsecd         ZMTH                                         228390
     C                   ENDIF                                                                228390
                                                                                              228390
     C                   IF        ZMTH <= 02                                                 228390
     C                   SUB       1             ZYEAR                                        228390
     C                   ENDIF                                                                228390
                                                                                              228390
     C     ZYEAR         DIV       4             WWNO              2 0                        228390
     C                   MVR                     WREM              1 0                        228390
     C                   IF        WREM = 0                                                   228390
     C                   Z-ADD     366           WCFRQ                                        228390
     C                   ELSE                                                                 228390
     C                   Z-ADD     365           WCFRQ                                        228390
     C                   ENDIF                                                                228390
                                                                                              228390
     C                   ENDSL                                                                228390
                                                                                              228390
     C     FSYRAT        DIV       100           WRATP                                        228390
     C                   DIV       WCFRQ         WRATP                                        228390
     C                   ADD       1             WRATP                                        228390
     C     ZCBDAY        DIV       ZCBDIV        WTIMY                                        228390
     C                   MULT      WCFRQ         WTIMY                                        228390
     C                   Z-ADD     0             WDENM            25 9                        228390
     C                   EVAL      WDENM =  WRATP ** WTIMY                                    228390
     C     1             DIV       WDENM         Wa(X)                                        228390
                                                                                              228390
     C                   ENDSR                                                                228390
      *****************************************************************
      *                                                               *
      * *PSSR - Error Subroutine                                      *
      *                                                               *
      * Called by: Main, SRCPsV                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** If not yet processed then process for a dump
 
     C                   MOVEL     '*ERROR* '    PRTCD
     C     WWRUN         IFNE      'Y'
     C                   MOVEL     'Y'           WWRUN             1
     C                   MOVEL     'ZADSFRBL'    DBPGM
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
     C                   MOVEL     *ON           *INU7
     C                   MOVEL     *ON           *INU8
     C                   MOVEL     *ON           *INLR
     C                   DUMP
     C                   ENDIF
     C*
     C                   MOVEL     *on           *INLR
     C                   RETURN
 
     C     PSSR9         ENDSR
      *****************************************************************
      *                                                               *
      *  SRBDys - Standard Subroutine to Calculate the Number of Days *
      *           between two Dates and the Number of Days in Year,   *
      *           for a Calculation Basis, (Dealing version).         *
      *                                                               *
      * Called by: SRLoad, SRCFlw                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRBDys        BEGSR
 
      ** Initialise fields.
 
     C                   Z-ADD     ZCBSDT        ZCBSDT            5 0
     C                   Z-ADD     ZCBEDT        ZCBEDT            5 0
     C                   Z-ADD     ZCBCBS        ZCBCBS            1 0
     C                   Z-ADD     0             ZCBDAY            5 0
     C                   Z-ADD     1             ZCBDIV            3 0
 
                                                                                            BUG12254
      ** If calculation method 9 for FRA/IRS/CCF, check if period                           BUG12254
      ** contains a Feb 29.                                                                 BUG12254
     C                   If        ZCBCBS = 9                                               BUG12254
                                                                                            BUG12254
      ** Convert start and end dates to YYYYMMDD                                            BUG12254
     C                   CallB     'ZDATE9'                                                 BUG12254
     C                   Parm                    ZCBSDT                                     BUG12254
     C                   Parm                    ZZStartDate                                BUG12254
     C                   Parm                    @@Rtn                                      BUG12254
                                                                                            BUG12254
     C                   CallB     'ZDATE9'                                                 BUG12254
     C                   Parm                    ZCBEDT                                     BUG12254
     C                   Parm                    ZZEndDate                                  BUG12254
     C                   Parm                    @@Rtn                                      BUG12254
                                                                                            BUG12254
     C                   CallB     'ZFEB29CHK'                                              BUG12254
     C                   Parm                    ZZStartDate                                BUG12254
     C                   Parm                    ZZEndDate                                  BUG12254
     C                   Parm                    #29Feb                                     BUG12254
                                                                                            BUG12254
     C                   Endif                                                              BUG12254
 
      ** First define the Number of Days in the Year.
      ** 365 Days - Calculation Basis = 1 or 4.
      ** Also for basis 9 if no Feb 29 within period.                                       BUG12254
 
     C                   IF        (ZCBCBS = 1) OR (ZCBCBS = 4)
     C                             or (ZCBCBS = 9 and #29Feb = 'N')                         BUG12254
     C                   Z-ADD     365           ZCBDIV
     C                   ENDIF
 
      ** 360 Days - Calculation Basis = 2, 3 or 5.
 
     C                   IF        (ZCBCBS = 2) OR (ZCBCBS = 3) OR
     C**********                   (ZCBCBS = 5)                                               224743
     C                             (ZCBCBS = 5) OR (ZCBCBS = 7 AND CIR004 = 'Y')              224743
     C                   Z-ADD     360           ZCBDIV
     C                   ENDIF
 
      ** 366 Days - Calculation Basis = 6.
      ** Also for basis 9 if Feb 29 within period.                                          BUG12254
 
     C                   IF        ZCBCBS = 6
     C                             or (ZCBCBS = 9 and #29Feb = 'Y')                         BUG12254
     C                   Z-ADD     366           ZCBDIV
     C                   ENDIF
 
      ** Then calculate the Number of Days in the Period.
      ** If the Start Date is Greater Than or Equal To the End Date,
      ** output the Number of Days in Period Equal to zero.
 
     C                   IF        ZCBSDT >= ZCBEDT
     C                   Z-ADD     0             ZCBDAY
     C                   GOTO      ZCBEND
     C                   ENDIF
 
      ** The Actual Number of Days in the Period is the difference
      ** between the Start Date and the End Date (Midas Date Format).
 
     C     ZCBEDT        SUB       ZCBSDT        ZCBDAY
 
      ** Calculation Bases 1, 2 and 6: Actual Number of Days.
      ** ----------------------------------------------------
      ** For these three, ZCBDAY already contains the final result,
      ** so no need for any further calculations.
      ** Same applies to basis 9.                                                           BUG12254
 
     C                   IF        (ZCBCBS = 1) OR (ZCBCBS = 2) OR
     C                             (ZCBCBS = 6)
     C                             or (ZCBCBS = 9)                                          BUG12254
     C                   GOTO      ZCBEND
     C                   ENDIF
 
      ** Calculation Bases 4 and 5: Actual Days, excluding 29th Feb.
      ** -----------------------------------------------------------
      ** Take Actual Days and subtract all the 29th February Days:
      ** This is done by checking the ZF29 array, (Midas Dates for
      ** 29th February), to get the indices of the first 29FEB after
      ** each of the Start Date and The End Date. The difference is
      ** the Number of 29FEBs in the Period.
 
     C                   IF        ZCBCBS = 4 OR ZCBCBS = 5
     C                   Z-ADD     1             ZS                2 0
     C                   Z-ADD     0             ZI1               2 0
     C                   Z-ADD     0             ZI2               2 0
 
      ** Find Index of first FEB29 after Start Date.
      ** (if Start Date is later than last FEB29 in array then set
      ** ZI1 to last index + 1 (= 33) ).
 
     C                   IF        ZF29(32) < ZCBSDT
     C                   Z-ADD     33            ZI1
     C                   ELSE
 
     C                   DOU       ZI1 <> 0
     C                   IF        ZF29(ZS) > ZCBSDT
     C                   Z-ADD     ZS            ZI1
     C                   ELSE
     C                   ADD       1             ZS
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C*
     C***  Continue, to find Index of first FEB29 after End Date. Note:
     C***  leave ZS as is, so as to continue in array from that point.
     C***  (if End Date is later than last FEB29 in array then set
     C***  ZI2 to last index + 1 (= 33) ).
     C*
     C                   IF        ZF29(32) < ZCBEDT
     C                   Z-ADD     33            ZI2
     C                   ELSE
 
     C                   DOU       ZI2 <> 0
     C                   IF        ZF29(ZS) > ZCBEDT
     C                   Z-ADD     ZS            ZI2
     C                   ELSE
     C                   ADD       1             ZS
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
     C     ZI2           SUB       ZI1           ZS
     C                   SUB       ZS            ZCBDAY
     C                   GOTO      ZCBEND
     C                   ENDIF
 
      ** Calculation Basis 3: 30 Day months, (including '30th Feb.')
      ** Convert Input Dates to DD/MM/YY or MM/DD/YY Format.
 
     C                   Z-ADD     ZCBSDT        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *zeros        ZDATE
     C                   PARM      *blanks       ZADATE            7
     C                   MOVE      ZDATE         WKDATE
     C                   MOVE      Wthrd         ZYEAR
 
     C                   IF        *IN98 = *ON
     C                   MOVE      Wfrst         ZMTH
     C                   MOVE      Wsecd         ZDAY
     C                   ELSE
     C                   MOVE      Wfrst         ZDAY
     C                   MOVE      Wsecd         ZMTH
     C                   ENDIF
 
     C                   MOVE      ZDATE         ZYR1              2 0
 
     C                   IF        *IN98 = *OFF
     C                   MOVEL     ZDATE         ZDY1              2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C                   MOVEL     ZWRK4         ZMT1              2 0
     C                   ELSE
     C                   MOVEL     ZDATE         ZMT1
     C                   MOVEL     ZDATE         ZWRK4
     C                   MOVE      ZWRK4         ZDY1
     C                   ENDIF
 
     C                   Z-ADD     ZCBEDT        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *zeros        ZDATE
     C                   PARM      *blanks       ZADATE            7
     C                   MOVE      ZDATE         WKDATE
     C                   MOVE      Wthrd         ZYEAR
 
     C                   IF        *IN98 = *ON
     C                   MOVE      Wfrst         ZMTH
     C                   MOVE      Wsecd         ZDAY
     C                   ELSE
     C                   MOVE      Wfrst         ZDAY
     C                   MOVE      Wsecd         ZMTH
     C                   ENDIF
 
     C                   MOVE      ZDATE         ZYR2              2 0
 
     C                   IF        *IN98 = *OFF
     C                   MOVEL     ZDATE         ZDY2              2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C                   MOVEL     ZWRK4         ZMT2              2 0
     C                   ELSE
     C                   MOVEL     ZDATE         ZMT2
     C                   MOVEL     ZDATE         ZWRK4
     C                   MOVE      ZWRK4         ZDY2
     C                   ENDIF
 
      ** Change Days to 30 if 31.
 
     C                   IF        ZDY1 = 31
     C                   MOVE      30            ZDY1
     C                   ENDIF
 
     C                   IF        ZDY2 = 31
     C                   MOVE      30            ZDY2
     C                   ENDIF
 
      ** To keep the Day Difference positive, if Start Day is Greater
      ** Than End Day, add 30 to End Day and reduce End Month by 1,
      ** (i.e. add one month's worth of days to End Day).
 
     C                   IF        ZDY1 > ZDY2
     C                   ADD       30            ZDY2
     C                   SUB       1             ZMT2
     C                   ENDIF
 
      ** Calculate Day Difference.
 
     C     ZDY2          SUB       ZDY1          ZDYDF             5 0
 
      ** Similarly, if Start Month Greater Than End Month, add 12
      ** to End Month and reduce End Year by 1.
 
     C                   IF        ZMT1 > ZMT2
     C                   ADD       12            ZMT2
     C                   IF        ZYR2 = 00
     C                   Z-ADD     99            ZYR2
     C                   ELSE
     C                   SUB       1             ZYR2
     C                   ENDIF
     C                   ENDIF
 
      ** Calculate Month Difference in Days.
 
     C     ZMT2          SUB       ZMT1          ZMTDF             5 0
     C                   MULT      30            ZMTDF
 
      ** Subtract Start Year from End Year: If result Less Than zero
      ** then End Date must be in the following century, so add 100.
 
     C     ZYR2          SUB       ZYR1          ZYRDF             5 0
     C                   IF        ZYRDF < 0
     C                   ADD       100           ZYRDF
     C                   ENDIF
 
      ** Calculate Year Difference in Days.
 
     C                   MULT      360           ZYRDF
 
      ** Total the three differences to get the Number of Days in
      ** the Period.
 
     C     ZDYDF         ADD       ZMTDF         ZCBDAY
     C                   ADD       ZYRDF         ZCBDAY
 
     C     ZCBEND        TAG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@   **      OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2001
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
