     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Rate to Discount Factor Conversion')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprocedures                               *
      *                                                               *
      *  ZADSFCO2 - Midas ZA Rate to discount factor conversion       *
      *                                                               *
      *  Function: This program converts a rate to a discount factor. *
      *            It receives a Yield Rate and Date and recreates    *
      *            the discount factors for the Yield Curve for the   *
      *            passed rate and date. It will not update Yield     *
      *            Rates file.                                        *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 245132  *CREATE    Date 19Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  245132 - Amended to improve runtime. Copied from ZADSFCON.   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *  91-92          for file LF/SDYLDRL2                          *
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
 
      ** Yield Curves File by Yield Curve
 
     FSDYLDCL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Yield Rates File
 
     FSDYLDRL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Array for Copyright statement
 
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
 
     D ZZStartDate     S              8S 0
     D ZZEndDate       S              8S 0
     D @@Rtn           S              1A
     D #29Feb          S              1A
 
     D ZF29            S              5  0 DIM(32) CTDATA PERRCD(14)
 
      ** Data Structure for Cash Flow Dates
 
     D                 DS
     D  WCFDMY                 1      6  0
     D  WCFDAY                 1      2  0
     D  WCFMON                 3      4  0
     D  WCFYER                 5      6  0
 
     D                 DS
     D WKDATE                  1      6
     D  Wfrst                  1      2
     D  Wsecd                  3      4
     D  Wthrd                  5      6
 
      ** Long data structure for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Short data structure for access programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Local data area for database error
 
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
 
      ** Bank details accessed via access program
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency details accessed via access program
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for SAR Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Define work variable for CAS008 enhancement
 
     D CAS008          S              1
     D ZNRDYS          S              2  0
 
      /EJECT
 
      ** Main Processing
 
     C     *ENTRY        PLIST
     C                   PARM                    PNRTCD            7
     C                   PARM                    PNPRTC            5
     C                   PARM                    PYLDN             5
     C                   PARM                    PCCY              3
     C                   PARM                    PICM              1
     C                   PARM                    PNPFDT            5 0
     C                   PARM                    PRATE            13 9
     C                   PARM                    PNPDF            13 9
     C                   PARM                    CAS008
     C                   PARM                    CIR004
     C                   PARM                    ZNPSDT            5 0
 
     C     KRATE1        KLIST
     C                   KFLD                    PYLDN
     C                   KFLD                    PCCY
     C                   KFLD                    PICM
     C                   KFLD                    PNPFDT
 
     C     KRATE2        KLIST
     C                   KFLD                    PYLDN
     C                   KFLD                    PCCY
     C                   KFLD                    PICM
 
     C                   MOVEA     CPY@          BIS@             80
 
     C                   EVAL      DBPGM = 'ZADSFCON'
 
      ** Check if switchable feature CIR004 is switched on
 
     C                   IF        CIR004 = *BLANKS
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY '    @OPTN             7
     C                   PARM      'CIR004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR004            1
     C                   ELSE
     C                   MOVE      'N'           CIR004
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check if switchable feature CAS008 is switched on
 
     C                   IF        CAS008 = *BLANKS
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY '    @OPTN
     C                   PARM      'CAS008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 5
     C                   EVAL      DBKEY  = 'CAS008'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CAS008 = 'Y'
     C                   ELSE
     C                   EVAL      CAS008 = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Call access program for bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     WRTCD         IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     WOPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set Date Format Indicator
 
     C                   IF        BJDFIN = 'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
 
     C                   Z-ADD     1             PNPDF
 
      ** Get Rate Date DDMMYY Equivalent
 
     C                   Z-ADD     PNPFDT        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
     C                   MOVE      ZDATE         WKDATE
     C                   MOVE      Wthrd         ZYEAR
 
     C                   IF        *IN98 = *ON
     C                   MOVE      Wfrst         ZMTH
     C                   MOVE      Wsecd         ZDAY
     C                   ELSE
     C                   MOVE      Wfrst         ZDAY
     C                   MOVE      Wsecd         ZMTH
     C                   ENDIF
 
     C                   Z-ADD     ZDAY          WKDINT            2 0
 
      ** Read the Yield Rates File
 
     C     KRATE1        SETLL     SDYLDRL2                           91
 
      ** If not EOF, Read the last record of the yield, currency
      ** and Interest Calculation Method
 
     C                   IF        *IN91 = *OFF
     C     KRATE2        READPE    SDYLDRL2                               92
     C                   IF        *IN92 = *ON
     C     KRATE2        CHAIN     SDYLDRL2                           92
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN92 = *OFF
 
      ** If rates are for all currencies, spot must be today
 
     C                   IF        FSYCCY = *BLANKS
     C                   Z-ADD     BJRDNB        WkSPOT            5 0
     C                   ELSE
 
      ** Retrieve Spot Days
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      FSYCCY        @CRKEY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     WRTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     FSYCCY        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Determine Spot Date
 
      ** If CAS008 is installed, use spot days defined for the yield
      ** rates instead of the one defined for the currency when
      ** calculating for spot date.
 
     C                   IF        CAS008 = 'Y'
     C                   EVAL      ZNRDYS = FSSPDY
     C                   ELSE
     C                   EVAL      ZNRDYS = A6SPDY
     C                   ENDIF
 
     C                   CALL      'ZFWDT'
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM                    ZNRDYS
     C                   PARM      0             ZDYNBR            5 0
     C                   PARM      FSYCCY        ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
 
     C                   Z-ADD     ZDYNBR        WkSPOT
     C                   ENDIF
 
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
 
     C                   IF        FSYCFQ = 'C'
     C                   ELSE
 
 
     C                   SELECT
 
      **  Annual compounding
 
     C                   WHEN      FSYCFQ = 'Y'
     C                   ADD       1             WCFYER
 
      ** Semi-annual compounding
 
     C                   WHEN      FSYCFQ = 'X'
 
     C                   Z-ADD     WCFDAY        WPRVDY            2 0
     C                   Z-ADD     WCFMON        WPRVMO            2 0
     C                   Z-ADD     WCFYER        WPRVYR            2 0
 
     C                   ADD       6             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
      ** Quarterly compounding
 
     C                   WHEN      FSYCFQ = 'Q'
 
     C                   Z-ADD     WCFDAY        WPRVDY
     C                   Z-ADD     WCFMON        WPRVMO
     C                   Z-ADD     WCFYER        WPRVYR
 
     C                   ADD       3             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
     C                   OTHER
     C                   MOVEL     'FSYCFQ  '    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     FSYCFQ        DBKEY
     C                   EXSR      *PSSR
 
     C                   ENDSL
 
      ** Call subroutine to check if monthend and do adjustments
 
     C                   EXSR      SRAdjs
 
     C                   Z-ADD     WCFDMY        WDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    WERR              7
     C                   PARM                    WDATE             6 0
     C                   PARM      'D'           WDATFM            1
     C                   PARM                    WDAYNO            5 0
 
     C                   Z-ADD     WDAYNO        WPER1             5 0
     C                   ENDIF
     C                   ENDIF
 
      ** Determine yield curve type
 
     C     PYLDN         CHAIN     SDYLDCL1                           93
 
      ** Initialise array index and arrays
 
     C                   Z-ADD     1             X
     C                   Z-ADD     *ZERO         Wa
 
      ** Initialise previous day number
 
     C                   IF        PNPFDT <= WPER1
     C                             OR FSYLDT = 'Z'
     C                   Z-ADD     WkSPOT        WkMMDN            5 0
     C                   ELSE
     C                   z-add     FSMMDN        WkMMDN
     C                   ENDIF
 
      ** Set fields
 
     C                   Z-ADD     prate         FSYRAT
     C                   Z-ADD     pnpfdt        FSMMDN
 
      ** Load rates into an array
 
     C                   EXSR      SRLoad
 
      ** Calculate discount factors
 
     C                   EXSR      SRCalc
 
      ** Update the discount factor
 
     C                   Z-ADD     Wa(X)         PNPDF
 
     C                   ELSE
     C                   Z-ADD     0             PNPDF
     C                   ENDIF
 
      ** Terminate program
 
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
 
      ** For 31-day months,
 
     C                   IF        ((WCFMON = 1) OR (WCFMON = 3) OR
     C                             (WCFMON = 5) OR (WCFMON = 7) OR
     C                             (WCFMON = 8) OR (WCFMON = 12) OR
     C                             (WCFMON = 10)) AND (WKDINT = 31)
     C                   Z-ADD     31            WCFDAY
     C                   ENDIF
 
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
 
     C                   IF        WKLEAP = 'Y'
     C                   IF        WKDINT = 29 OR WCFDAY > 29
     C                   Z-ADD     29            WCFDAY
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WKLEAP = 'N' AND WCFDAY > 28
     C                   Z-ADD     28            WCFDAY
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRLoad - Load Rates Arrays                                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRBDys                                                 *
      *                                                               *
      *****************************************************************
     C     SRLoad        BEGSR
 
      ** Increment array index by 1
 
     C                   ADD       1             X
 
      ** Calculate the number of days/divisor basis in the period
 
     C                   Z-ADD     WkMMDN        ZCBSDT
     C                   Z-ADD     FSMMDN        ZCBEDT
     C                   MOVEL     FSYICM        ZCBCBS
     C                   EXSR      SRBDys
 
      ** Update previous day number
 
     C                   Z-ADD     FSMMDN        WkMMDN
 
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
 
     C                   IF        FSYLDT = 'Z'
 
     C                   IF        FSMMDN <= WkSPOT
     C                   Z-ADD     1             Wa(X)
     C                   ELSE
 
     C                   IF        FSYCFQ = 'C'
     C                   EXSR      SRCfrq
     C                   ELSE
     C                   EXSR      SRZtyp
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
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
     C                   ENDIF
 
     C                   ENDSR
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
     C                   PARM      *BLANKS       ZADATE
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
 
      ** Change year to spot year to come up with the first coupon date
 
     C                   Z-ADD     WkSPOT        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
     C                   MOVE      ZDATE         WKDATE
     C                   MOVE      Wthrd         ZYEAR             2 0
 
     C                   IF        *IN98 = *ON
     C                   MOVE      Wfrst         ZMTH              2 0
     C                   MOVE      Wsecd         ZDAY              2 0
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
 
      ** Convert to Midas date
 
     C                   EXSR      SRAdjs
 
     C                   Z-ADD     WCFDMY        WDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    WERR              7
     C                   PARM                    WDATE             6 0
     C                   PARM      'D'           WDATFM            1
     C                   PARM                    WDAYNO            5 0
 
     C                   SELECT
 
      ** Annual Compounding
 
     C                   WHEN      FSYCFQ = 'Y'  AND
     C                             WDAYNO <=  WkSPOT
     C                   ADD       1             WCFYER
     C                   EXSR      SRAdjs
     C                   Z-ADD     WCFDMY        WDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    WERR              7
     C                   PARM                    WDATE             6 0
     C                   PARM      'D'           WDATFM            1
     C                   PARM                    WDAYNO            5 0
 
      ** Semi-annual compounding
 
     C                   WHEN      FSYCFQ = 'X'
     C                   Z-ADD     WCFDAY        WPRVDY
 
     C                   DOW       WDAYNO <= WkSPOT
 
     C                   Z-ADD     WPRVDY        WCFDAY
 
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
 
     C                   WHEN      FSYCFQ = 'Q'
     C                   Z-ADD     WCFDAY        WPRVDY
 
     C                   DOW       WDAYNO <= WkSPOT
 
     C                   Z-ADD     WPRVDY        WCFDAY
 
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
 
     C                   WHEN      FSYCFQ = 'Y'
     C                   ADD       1             WCFYER
 
      ** Semi-annual compounding
 
     C                   WHEN      FSYCFQ = 'X'
 
     C                   Z-ADD     WCFDAY        WPRVDY
     C                   Z-ADD     WCFMON        WPRVMO
     C                   Z-ADD     WCFYER        WPRVYR
 
     C                   ADD       6             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
      ** Quarterly compounding
 
     C                   WHEN      FSYCFQ = 'Q'
 
     C                   Z-ADD     WCFDAY        WPRVDY
     C                   Z-ADD     WCFMON        WPRVMO
     C                   Z-ADD     WCFYER        WPRVYR
 
     C                   ADD       3             WCFMON
     C                   IF        WCFMON > 12
     C                   SUB       12            WCFMON
     C                   ADD       1             WCFYER
     C                   ENDIF
 
     C                   ENDSL
 
      ** Call subroutine to check if monthend and do adjustments
 
     C                   EXSR      SRAdjs
 
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
 
     C                   WHEN      CDAT(Z) <> FSMMDN
 
      ** Retrieve Discount Factor for Cash Flow point
      ** Use FSNDRTV just to retrieve the Discount Factor
 
     C                   Z-ADD     CDAT(Z)       POPFDt
 
     C                   CALL      'ZADSFRT2'
     C                   PARM      *BLANKS       PORtCd            7
     C                   PARM      *BLANKS       PORatF            5
     C                   PARM      FSYLDC        POPYld            5
     C                   PARM      FSYCCY        POPCcy            3
     C                   PARM      FSYICM        POPInC            1
     C                   PARM                    POPFDt            5 0
     C                   PARM      *ZERO         PODsFc           13 9
     C                   PARM                    CAS008
     C                   PARM                    ZNPSDT
 
     C                   IF        PORtCd = '*ERROR ' OR PORtCd = '*NRF   '
     C                   MOVE      'ZADSFRTV'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     PORtCd        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     CFLW(Z)       MULT(H)   PODsFc        WCPSV            15 9
 
      ** For Maturity Date, present value would be the sum of all previous
      ** present value cash flows subtracted from 0.
 
     C                   WHEN      CDAT(Z) =  FSMMDN
     C                   XFOOT(H)  CPSV          WCPSV
     C                   MULT      -1            WCPSV
 
     C                   ENDSL
 
     C                   Z-ADD     WCPSV         CPSV(Z)
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SRCfrq - Calculate discount factor for compounding freq C     *
      *                                                               *
      * Called by: SRCalc                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCfrq        BEGSR
 
     C                   Z-ADD     2.718281828   WEXPN            10 9
     C                   Z-ADD     0             WRATP            11 9
     C     FSYRAT        DIV       100           WRATP
     C                   Z-ADD     0             WTIMY            14 9
     C     ZCBDAY        DIV       ZCBDIV        WTIMY
     C                   MULT      WRATP         WTIMY
     C                   MULT      -1            WTIMY
     C                   EVAL      Wa(X) = WEXPN ** WTIMY
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRZtyp - Calculate discount factor for yield curve type Z     *
      *                                                               *
      * Called by: SRCalc                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRZtyp        BEGSR
 
     C                   SELECT
 
     C     FSYCFQ        WHENEQ    'Y'
     C                   Z-ADD     1             WCFRQ             3 0
 
     C     FSYCFQ        WHENEQ    'X'
     C                   Z-ADD     2             WCFRQ
 
     C     FSYCFQ        WHENEQ    'Q'
     C                   Z-ADD     4             WCFRQ
 
     C                   OTHER
 
      ** Get Rate Date DDMMYY Equivalent
 
     C                   Z-ADD     FSMMDN        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
     C                   MOVE      ZDATE         WKDATE
     C                   MOVE      Wthrd         ZYEAR
 
     C                   IF        *IN98 = *ON
     C                   MOVE      Wfrst         ZMTH
     C                   ELSE
     C                   MOVE      Wsecd         ZMTH
     C                   ENDIF
 
     C                   IF        ZMTH <= 02
     C                   SUB       1             ZYEAR
     C                   ENDIF
 
     C     ZYEAR         DIV       4             WWNO              2 0
     C                   MVR                     WREM              1 0
     C                   IF        WREM = 0
     C                   Z-ADD     366           WCFRQ
     C                   ELSE
     C                   Z-ADD     365           WCFRQ
     C                   ENDIF
 
     C                   ENDSL
 
     C     FSYRAT        DIV       100           WRATP
     C                   DIV       WCFRQ         WRATP
     C                   ADD       1             WRATP
     C     ZCBDAY        DIV       ZCBDIV        WTIMY
     C                   MULT      WCFRQ         WTIMY
     C                   Z-ADD     0             WDENM            25 9
     C                   EVAL      WDENM =  WRATP ** WTIMY
     C     1             DIV       WDENM         Wa(X)
 
     C                   ENDSR
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
 
     C                   EVAL      PNRTCD = '*ERROR '
     C                   IF        WWRUN <> 'Y'
     C                   MOVEL     'Y'           WWRUN             1
     C     *DTAARA       DEFINE    LDA           @LDA            256
     C     *LOCK         IN        @LDA
     C                   MOVEL     DBERR         @LDA
     C                   OUT       @LDA
     C                   EVAL      *INU7  = *ON
     C                   EVAL      *INU8  = *ON
     C                   EVAL      *INLR  = *ON
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR  = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRBDys - Standard Subroutine to Calculate the Number of Days  *
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
 
      ** If calculation method 9 for FRA/IRS/CCF, check if period
      ** contains a Feb 29.
 
     C                   IF        ZCBCBS = 9
 
      ** Convert start and end dates to YYYYMMDD
     C                   CALLB     'ZDATE9'
     C                   PARM                    ZCBSDT
     C                   PARM                    ZZStartDate
     C                   PARM                    @@Rtn
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    ZCBEDT
     C                   PARM                    ZZEndDate
     C                   PARM                    @@Rtn
 
     C                   CALLB     'ZFEB29CHK'
     C                   PARM                    ZZStartDate
     C                   PARM                    ZZEndDate
     C                   PARM                    #29Feb
 
     C                   ENDIF
 
      ** First define the Number of Days in the Year.
      ** 365 Days - Calculation Basis = 1 or 4.
      ** Also for basis 9 if no Feb 29 within period.
 
     C                   IF        (ZCBCBS = 1) OR (ZCBCBS = 4)
     C                             or (ZCBCBS = 9 and #29Feb = 'N')
     C                   Z-ADD     365           ZCBDIV
     C                   ENDIF
 
      ** 360 Days - Calculation Basis = 2, 3 or 5.
 
     C                   IF        (ZCBCBS = 2) OR (ZCBCBS = 3) OR
     C                             (ZCBCBS = 5) OR (ZCBCBS = 7 AND CIR004 = 'Y')
     C                   Z-ADD     360           ZCBDIV
     C                   ENDIF
 
      ** 366 Days - Calculation Basis = 6.
      ** Also for basis 9 if Feb 29 within period.
 
     C                   IF        ZCBCBS = 6
     C                             or (ZCBCBS = 9 and #29Feb = 'Y')
     C                   Z-ADD     366           ZCBDIV
     C                   ENDIF
 
      ** Then calculate the Number of Days in the Period.          *
 
 
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
      ** Same applies to basis 9.
 
     C                   IF        (ZCBCBS = 1) OR (ZCBCBS = 2) OR
     C                             (ZCBCBS = 6)
     C                             or (ZCBCBS = 9)
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
 
     C                   IF        ZF29(32) <  ZCBSDT
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
 
      ** Continue, to find Index of first FEB29 after End Date. Note:
      ** leave ZS as is, so as to continue in array from that point.
      ** (if End Date is later than last FEB29 in array then set
      ** ZI2 to last index + 1 (= 33) ).
 
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
      ** -----------------------------------------------------------
 
      ** Convert Input Dates to DD/MM/YY or MM/DD/YY Format.
 
     C                   Z-ADD     ZCBSDT        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *zeros        ZDATE
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
      ** the P
 
     C     ZDYDF         ADD       ZMTDF         ZCBDAY
     C                   ADD       ZYRDF         ZCBDAY
 
     C     ZCBEND        TAG
 
     C                   ENDSR
 
     C*****************************************************************
** CPY@
(c) Finastra International Limited 2011
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
