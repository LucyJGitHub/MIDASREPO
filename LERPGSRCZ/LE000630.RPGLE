     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Validate Facility Amount from VDAT')          *
      *---------------------------------------------------------------*
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000630 - Validate Facility Amount on Input                 *
      *                                                               *
      *  Function: When a Customer Loan, Participation Purchased, or  *
      *            Principal Increase is entered, the respective      *
      *            input programs will call LE000630 to check if the  *
      *            transaction amount will exceed the available amt   *
      *            for the Facility/Tranche for the next 'n' days,    *
      *            starting with the value date of the transaction.   *
      *            The nth value defined in FctyExceedNoDaysFwd       *
      *            system value.                                      *
      *                                                               *
      *  Note:     A significant part of the processing of this       *
      *            new program is based on the core program LE1070.   *
      *                                                               *
      *  Called By: LECLIP1VL and LELOAMVAL                           *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD055657           Date 14May20               *
      *  Prev Amend No. MD027418           Date 18Jul18               *
      *                 MD026971           Date 18Jul18               *
      *                 MD025837A          Date 18Jul18               *
      *                 CLE158  *CREATE    Date 18Jul18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055657 - Manual transaction from FFC TI Interface went to  *
      *             repair queue because the facility exchange rate is*
      *             longer than the defined facility exchange rate in *
      *             Midas. Increase the field definition of the Midas *
      *             facility exchange rate.                           *
      *  MD027418 - Exclude loan if it is not yet authorised and      *
      *             last action was insert.                           *
      *  MD026971 - Issue either overridable error or warning         *
      *             Amend this program for correct calculation of     *
      *             available balance when checking for CLOANCL recs. *
      *  MD025837A - Do not issue warning when MDAT of loan is LT     *
      *             date on which facility will be exceeded           *
      *  CLE158 - Tranche and Facility Control                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   F U N C T I O N    O F    I N D I C A T O R S               *
      *                                                               *
      *  32       Record not found on CLOAN, MLOAN                    *
      *  50       LOKUP indicator (record found)                      *
      *  80       Read Indicator (SDCURRPD)                           *
      *  87       LEFCAML3 - record not found.                        *
      *  88       LEFCAML8 - record not found.                        *
      *  89       FCLTYFM  - record not found.                        *
      *  98       Used for Date Format                                *
      *  99       Used in Date routines                               *
      *  U7, U8   Error processing                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  ZEDIT  - Insert a decimal point into a numeric field and to  *
      *           blank out leading zeroes                            *
      *  ZACCH  - Access a holiday record for a particular currency   *
      *  ZFWDT  - Calculate Nth working day forward from given date   *
      *  BVALSR - Read LEFCAMPD for backvalued facility decr/incr     *
      *           which were entered today.                           *
      *  FCAMSR - Load array with the Daily Facility Available amt.   *
      *  SRCVAM - Convert Amount to Facility Currency                 *
      *  SRWKAM - Add/Subtract Work Amount                            *
      *  TRANSR - Validate the Transaction Amount entered.            *
      *  *INZSR - Initial Time Routine                                *
      *  *PSSR  - Error Processing                                    *
      *                                                               *
      *****************************************************************
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
      ** Facilities File

     FLEFCAML8  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(FSDS1)
      ** Facility Activity

     FLEFCAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(FSDS2)
     F                                     RENAME(LEFCAMPF:LEFCAMF3)
      ** Facility Amemdments only

     FSDCURRPD  IF   E             DISK    INFSR(*PSSR)
      ** Midas SD Currency Codes

     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     RENAME(CLOANCLF:CLONF)
     F                                     IGNORE(CLOANZ1F)
      ** Loans File
      *
     FMLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F                                     IGNORE(CLOANCKF)
     F                                     RENAME(CLOANCLF:MCLONCLF)
      ** Matured Loans File
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     D COD             S              3    DIM(150)
     D CYD             S             15    DIM(150)
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D XDAT            S              5  0 DIM(999)
     D XAMT            S             13  0 DIM(999)
     D/COPY ZSRSRC,ZHOLELE
      *****************************************************************
      /EJECT
      *****************************************************************

      ** File status(LEFCAML8) data structure - record format
     D FSDS1           DS
     D  FREC1            *RECORD

      ** File status(LEFCAML3) data structure - record format
     D FSDS2           DS
     D  FREC2            *RECORD

      ** Define Currency Information
     D                 DS
     D  CYDDS                  1     15
     D  WWSPR                  1     13  8
      ** Facility Spot Rate
     D  WWFDP                 14     14  0
      ** Facility Decimal Places
     D  WWMDV                 15     15
      ** Facility Mult/Div Indicator

      ** Data Structure for Facility Number
     D                 DS
     D  W$FACT                 1      3  0
     D  W$FCNO                 4      5  0
     D  W$FACL                 1      5  0

      ** Data Area for Rundate
     D RUNDT           DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      ** Multibranching Indicator.

      ** Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data Structure for LDA
     D LDA           E DS           256    EXTNAME(LDA)

     D PLVDAT          S              5S 0
     D NDayFwd         S              2S 0
      *
     I/COPY ZSRSRC,ZHOLILE
      ** Rename fields                                                                      MD055657
      *                                                                                     MD055657
     ILEFCAMPF                                                                              MD055657
     I              SQNO                        SQNOFA                                      MD055657
     ILEFCAMF3                                                                              MD055657
     I              SQNO                        SQNOFA                                      MD055657

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      * Main Processing  -  Single Cycle Program                      *
      *****************************************************************

      ** Access FACILITY record.
      ** ... facility must exist on facility file (A & B records)
     C                   MOVE      PLCNUM        W$CNUM
     C                   MOVE      PLFACT        W$FACT
     C                   MOVE      PLFCNO        W$FCNO

      ** N = Read record without locking. 89 = record not found.
     C                   MOVE      'A'           W$RCTP
     C     WKFAC         CHAIN(N)  FCLTY                              89

     C     *IN89         IFEQ      *OFF

      ** Retrieve Decimal Places, Spot Rate and Mult/Div Indicator
      ** for the Facility Currency.
     C                   Z-ADD     1             Z
     C     FCCY          LOOKUP    COD(Z)                                 20
     C                   MOVE      CYD(Z)        CYDDS
     C                   Z-ADD     WWFDP         FCDP              1 0
     C                   Z-ADD     WWSPR         FSPRT            13 8
     C                   MOVE      WWMDV         FMDIN             1

      ** Save Revolving Credit Indicator
     C                   MOVE      RVCR          @RV               1
     C                   ENDIF

     C                   MOVE      'B'           W$RCTP
     C  N89WKFAC         CHAIN(N)  FCLTY                              89

      ** Set up array of dates (including non-working days)
      ** starting from the RUNDATE.
      ** The last day of the array is the Expiry Date of the facility
      ** to a maximum number of days = 999.
     C                   MOVEA     *ZERO         XDAT
     C                   MOVEA     *ZERO         XAMT

     C                   Z-ADD     BJRDNB        WKVDAT            5 0

     C                   Z-ADD     1             X                 4 0

     C     WKVDAT        DOUGT     DTEX
     C     X             ORGT      999
     C                   Z-ADD     WKVDAT        XDAT(X)
     C                   ADD       1             WKVDAT
     C                   ADD       1             X
     C                   ENDDO

      ** Check for records which impact FACILITY ACTIVITY on LF/LEFCAML8
      ** The initial facility available amount as of rundate is
      ** equal to the Facility Amt less the Current Exposure Amt.
      ** (plus/minus any back-valued facility increases/decreases
      **  which were entered today.)
     C     FAMT          SUB       CAMD          DLYAMT           13 0
     C     PLACTN        IFEQ      'X'                                                      MD027418
     C     PLVDAT        ANDEQ     BJRDNB                                                   MD027418
     C                   ADD       PLCPAM        DLYAMT                                     MD027418
     C                   ENDIF                                                              MD027418

     C     *IN89         IFEQ      *OFF
     C                   EXSR      BVALSR
     C                   EXSR      FCAMSR
     C                   ENDIF

      ** Validation of Transaction Amount
     C                   EXSR      TRANSR

      ** End of processing
     C                   MOVE      '1'           *INLR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  BVALSR  -  Read through the Facility Amendments file for     *
      *             actions entered today which are back-valued       *
      *             and therefore not currently reflected on the      *
      *             FCLTYFM file (FAMT) until after COB.              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *****************************************************************
     C     BVALSR        BEGSR

      ** Read all of the facility amendments currenly on file for
      ** this Facility customer / Facility type / Facility number
     C     WKFAM3        SETLL     LEFCAML3
     C     WKFAM3        READE     LEFCAML3                               87

     C     *IN87         DOWEQ     *OFF

      ** If Original Entry Date is today and value date is back-valued,
      ** then increase/decrease the initial daily amount.
     C     ORED          IFEQ      BJRDNB
     C     VLDT          ANDLT     BJRDNB
     C     RECI          ANDEQ     'D'

      ** By definition, the Facility Amendment (increase/decrease) will
      ** be in the same currency as the facility.  Therefore, no
      ** currency conversion (SR/SRCVAM) is needed here.

      ** Facility Increase
     C     FATP          IFEQ      'FI'
      ** Add Work Amount to initial daily amount.
     C                   ADD       AAMT          DLYAMT
     C                   ENDIF

      ** Facility Decrease
     C     FATP          IFEQ      'FD'
      ** Subtract Work Amount from initial daily amount.
     C                   SUB       AAMT          DLYAMT
     C                   ENDIF

     C                   ENDIF

     C     WKFAM3        READE     LEFCAML3                               87
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  FCAMSR  -  Load array with the Daily Facility Available amt. *
      *                                                               *
      *             Daily Action Amount = net total for each day of   *
      *             the future valued transactions from LEFCAML8.     *
      *                                                               *
      *             Daily Facility Available amt =                    *
      *             Previous Facility Available Amount plus/minus     *
      *             Daily Action Amount.                              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *****************************************************************
     C     FCAMSR        BEGSR

      ** Find array element 'X' for this RUNDATE.
      ** Start/default to element 1.
     C                   Z-ADD     1             X
     C     BJRDNB        LOOKUP    XDAT(X)                                50

     C     X             DOUGT     999
     C     XDAT(X)       OREQ      0
     C                   Z-ADD     XDAT(X)       W$VLDT

      ** Initialisation Working Fields
     C                   Z-ADD     0             WKUNDR           15 0

     C     WKFAM2        SETLL     LEFCAML8
     C     WKFAM2        READE     LEFCAML8                               88

     C     *IN88         DOWEQ     *OFF

      *****************************************************************
      ** The following code is based on processing in core LE1070.
      *****************************************************************
     C                   Z-ADD     *ZERO         WKAMT            18 0
     C                   MOVE      'N'           FOUND             1
     C                   MOVEL     *BLANKS       LNRFSV            6

      ** If File record is Loan Amendment
     C     FREC1         IFEQ      'LOAMSDKF'
     C     VDAT          ANDGT     BJRDNB

      ** Since the current exposUre on FCLTYFN (CAMD) already includes
      ** lending transaction amounts for rundate, do not include the
      ** Loan Amendment amounts dated for today or earlier.
     C                   MOVE      LNRF          @@LNRF                                     MD027418
     C     RECI          IFEQ      'D'                                                      MD027418
     C     CHTP          ANDEQ     'I'                                                      MD027418
     C     ASTS          ANDEQ     'C'                                                      MD027418
     C     PLACTN        ANDEQ     'X'                                                      MD027418
     C     PLLNRF        ANDEQ     @@LNRF                                                   MD027418
     C     PLAMTP        ANDEQ     AMTP                                                     MD027418
     C     AMTP          ANDEQ     'PI'                                                     MD027418
     C                   ELSE                                                               MD027418

     C                   MOVEL     LNRF          LNRFSV

      ** Set Work Currency to Currency
     C                   MOVE      CCY           WKCCY             3

      ** If Amendment Type is Manual Repayment
     C     AMTP          IFEQ      'MR'

      ** Or Amendment Typ is Repayment Schedule and Repayment Type is 1
     C     AMTP          OREQ      'RE'
     C     REPT          ANDEQ     1

      ** Or Amendment Typ is Repayment Schedule and Repayment Type is 2
     C     AMTP          OREQ      'RE'
     C     REPT          ANDEQ     2

      ** Or Amendment Typ is Principal Increase.
     C     AMTP          OREQ      'PI'

      ** Set Work amount to Principal Amount
     C                   Z-ADD     PRAM          WKAMT
     C                   MOVE      'Y'           FOUND
      *
     C                   ENDIF

      ** Set Work Amendment Type to Amendment Type
     C                   MOVE      AMTP          WKAMTP            2

     C                   ENDIF                                                              MD027418
     C                   ENDIF

      ** Facility Amendment
     C     FREC1         IFEQ      'LEFCAMPF'

      ** Set Work Amendment Type to Facility Amendment Type
     C                   MOVE      FATP          WKAMTP

      ** Set Work Currency to Amendment Currency
     C                   MOVE      ACCY          WKCCY

      ** Set Work Amount to Amendment Amount
     C                   Z-ADD     AAMT          WKAMT
     C                   MOVE      'Y'           FOUND

     C                   ENDIF

      ** LOAN FOR PRIME FAC. & FOR PARTICIPANT FAC.
      ** If File Record is Loan for Prime (CLOANCL1)
      ** or for Participant Facility      (CLOANCL2)
     C     FREC1         IFEQ      'CLOANCL1'
     C     FREC1         OREQ      'CLOANCL2'

      ** Since the current exposyre on FCLTYFN (CAMD) already includes
      ** lending transaction amounts for rundate, do not include the
      ** Customer Loan amounts dated for today or earlier.
     C     VDAT          IFGT      BJRDNB
     C     RECI          ANDNE     'R'                                                      MD026971
     C     VDAT          ORGT      BJRDNB                                                   MD026971
     C     RECI          ANDEQ     'R'                                                      MD026971
     C     ORED          ANDNE     BJRDNB                                                   MD026971

     C                   MOVE      LNRF          @@LNRF            6                        MD027418
     C     RECI          IFEQ      'D'                                                      MD027418
     C     CHTP          ANDEQ     'I'                                                      MD027418
     C     LSTS          ANDEQ     'C'                                                      MD027418
     C     PLACTN        ANDEQ     'X'                                                      MD027418
     C     PLLNRF        ANDEQ     @@LNRF                                                   MD027418
     C                   ELSE                                                               MD027418
     C                   MOVEL     LNRF          LNRFSV

      ** If Record Identifier is reverse
     C     RECI          IFEQ      'R'

      ** Set Action type to Loan Reversal
     C                   MOVE      'RV'          WKAMTP
     C                   ELSE

      ** Set Action type to Start of Loan
     C                   MOVE      'ST'          WKAMTP
     C                   ENDIF

      ** Set Work Currency to Currency
     C                   MOVE      CCY           WKCCY

      ** Set Work Amount to Current Principal Amount
     C                   Z-ADD     CPAM          WKAMT
     C                   MOVE      'Y'           FOUND
     C                   ENDIF                                                              MD027418
     C                   ENDIF
     C                   ENDIF

      ** File Record is for future-valued maturity date
      ** of loans of the Prime Facility           (CLOANCL3)
      ** or of loans of the Participant Facility  (CLOANCL4)
     C     FREC1         IFEQ      'CLOANCL3'
     C     FREC1         OREQ      'CLOANCL4'

      ** Since the current exposyre on FCLTYFN (CAMD) already includes
      ** lending transaction amounts for rundate, do not include the
      ** Customer Loan amounts dated for today or earlier.
     C     MDAT          IFGT      BJRDNB
     C     RECI          ANDNE     'R'                                                      MD026971
     C     MDAT          ORGT      BJRDNB                                                   MD026971
     C     RECI          ANDEQ     'R'                                                      MD026971
     C     ORED          ANDNE     BJRDNB                                                   MD026971

     C                   MOVE      LNRF          @@LNRF            6                        MD027418
     C     RECI          IFEQ      'D'                                                      MD027418
     C     CHTP          ANDEQ     'I'                                                      MD027418
     C     LSTS          ANDEQ     'C'                                                      MD027418
     C     PLACTN        ANDEQ     'X'                                                      MD027418
     C     PLLNRF        ANDEQ     @@LNRF                                                   MD027418
     C                   ELSE                                                               MD027418
     C                   MOVEL     LNRF          LNRFSV

      ** Set work currency to currency
     C                   MOVE      CCY           WKCCY

      ** Set Work amount to current principal amount
     C                   Z-ADD     CPAM          WKAMT
     C                   MOVE      'Y'           FOUND

      ** Set Action tyoe to Loan Reversal or Maturity of Loan
     C     RECI          IFEQ      'R'
     C                   MOVE      'RV'          WKAMTP
     C                   ELSE
     C                   MOVE      'MT'          WKAMTP
     C                   ENDIF
      *
     C                   ENDIF                                                              MD027418
     C                   ENDIF
     C                   ENDIF

      ** Next repayment date.
     C     FREC1         IFEQ      'CLOANCL5'
     C     NRPD          ANDGT     BJRDNB
     C     RECI          ANDNE     'R'                                                      MD026971
     C     FREC1         OREQ      'CLOANCL5'                                               MD026971
     C     NRPD          ANDGT     BJRDNB                                                   MD026971
     C     RECI          ANDEQ     'R'                                                      MD026971
     C     ORED          ANDNE     BJRDNB                                                   MD026971
      *                                                                                     MD027418
     C                   MOVE      LNRF          @@LNRF            6                        MD027418
     C     RECI          IFEQ      'D'                                                      MD027418
     C     CHTP          ANDEQ     'I'                                                      MD027418
     C     LSTS          ANDEQ     'C'                                                      MD027418
     C     PLACTN        ANDEQ     'X'                                                      MD027418
     C     PLLNRF        ANDEQ     @@LNRF                                                   MD027418
     C                   ELSE                                                               MD027418

      ** Since the current exposyre on FCLTYFN (CAMD) already includes
      ** lending transaction amounts for rundate, do not include the
      ** Customer Loan amounts dated for today or earlier.
     C                   MOVEL     LNRF          LNRFSV

      ** Set work currency to currency
     C                   MOVE      CCY           WKCCY

      ** Set Work amount to rebate amount
     C                   Z-ADD     RAMT          WKAMT
     C                   MOVE      'Y'           FOUND

      ** Set Action tyoe to Loan Reversal or Repayment
     C     RECI          IFEQ      'R'
     C                   MOVE      'RV'          WKAMTP
     C                   ELSE
     C                   MOVE      'RE'          WKAMTP
     C                   ENDIF
     C                   ENDIF                                                              MD027418
     C                   ENDIF

     C     FOUND         IFEQ      'Y'

      ** Convert Amount
     C                   EXSR      SRCVAM

      ** Set Amount to work Amount
     C                   EXSR      SRWKAM

      ** Accumulate Daily available amount from undrawn amts.
     C                   ADD       WKUNDR        DLYAMT
     C                   Z-ADD     *ZERO         WKUNDR
     C                   ENDIF

     C     WKFAM2        READE     LEFCAML8                               88
     C                   ENDDO

     C                   Z-ADD     DLYAMT        XAMT(X)
     C                   ADD       1             X
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  TRANSR  -  Validate the Transaction Amount entered.          *
      *                                                               *
      *             Daily Action Amount = net total for each day of   *
      *             the future valued Facility Incr and Decr from     *
      *             LEFCAMPD.                                         *
      *                                                               *
      *             Daily Facility Available amt =                    *
      *             Previous Facility Available Amount plus/minus     *
      *             Daily Action Amount.                              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : ZFWDT                                             *
      *****************************************************************
     C     TRANSR        BEGSR

      ** Note:  The transaction amount passed from the input pgm
      **        to LE000630 (FCBAL /PLCPAM) was already converted to
      **        facility currency within the input pgm.

      ** If the transaction amount will cause the available amount
      ** of the Facility/Tranche to be exceeded for any of the next
      ** 'n' working days starting with the value date of the
      ** transaction, then issue an error message that will prevent
      ** the transaction from being accepted.
     C                   MOVE      *BLANK        PLRTCD

      **  Find array element 'X' for this value date.
      **  Start/default to element 1.
     C                   Z-ADD     1             X
     C     PLVDAT        LOOKUP    XDAT(X)                                50

      ** Check if amount is in error for value date.
      ** If an error is detected, exit pgm with 'error' return code.
     C     PLRTCD        IFEQ      *BLANK
     C     PLCPAM        ANDGT     XAMT(X)
     C                   MOVE      'E'           PLRTCD
     C                   GOTO      ENDTRN
     C                   ENDIF

      ** If date in array is a working day, validate amt for this day.
      ** If date in array is not a working day, then use SR/ZFWDT
      ** to find the date of the next working day.
      ** Process for 'n' working days.

      ** Applied 158541 logic from LE0461 to maintain consistency
      ** with current available fields in enquiries.
      ** Use Local CCY instead of Facility CCY to determine the
      ** next working day for 'n' days forward.

     C                   DO        NDayFwd

     C                   MOVE      BJLCCY        ZCCY
     C                   Z-ADD     XDAT(X)       ZDAYNO
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
     C                   EXSR      ZFWDT

      ** ZFWDT Output result: ZDYNBR
      ** Find array element 'X' for the next working day.
     C     ZDYNBR        LOOKUP    XDAT(X)                                50

      ** Once an error is detected, exit pgm with 'error' return code.
     C     PLRTCD        IFEQ      *BLANK
     C     PLCPAM        ANDGT     XAMT(X)
     C     PLMDAT        ANDEQ     0                                                       MD025837A
     C     PLRTCD        OREQ      *BLANK                                                  MD025837A
     C     PLCPAM        ANDGT     XAMT(X)                                                 MD025837A
     C     PLMDAT        ANDGT     XDAT(X)                                                 MD025837A
     C                   MOVE      'E'           PLRTCD
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO

     C     PLRTCD        IFEQ      *BLANK

      ** Reset 'X' to the day after 'n' working days.
      ** Check for warning msg.
     C                   Z-ADD     0             X
     C     NDayFwd       ADD       1             X
     C                   Z-ADD     0             XXVDAT            5 0
     C     PLVDAT        ADD       X             XXVDAT

      ** If the transaction amount will cause the available amount of
      ** the Facility/Tranche to be exceeded beyond the nth day
      ** (X greater than NDayFwd), then issue a warning message only.
     C     X             DOUGT     999

     C     XXVDAT        IFLE      DTEX

      ** Once a warning is detected, exit pgm with 'warning' return code.
     C     PLCPAM        IFGT      XAMT(X)
     C     PLMDAT        ANDEQ     0                                                       MD025837A
     C     PLCPAM        ORGT      XAMT(X)                                                 MD025837A
     C     PLMDAT        ANDGT     XDAT(X)                                                 MD025837A
     C                   MOVE      'W'           PLRTCD
     C                   LEAVE
     C                   ENDIF

      ** Once a transaction value date > facility expiry date, exit pgm.
     C                   ELSE
     C                   LEAVE
     C                   ENDIF

     C                   ADD       1             X
     C                   ADD       1             XXVDAT
     C                   ENDDO
     C                   ENDIF

     C     ENDTRN        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCVAM  -  Convert Amount to Facility Currency               *
      *                                                               *
      *  Called By: FCAMSR                                            *
      *                                                               *
      *  Calls    :                                                   *
      *****************************************************************
     C     SRCVAM        BEGSR

      ** If Facility currency is not the same as the work currency
     C     FCCY          IFNE      WKCCY

      ** Retrieve Decimal Places, Spot Rate and Mult/Div Indicator
      ** for the Work Currency.
     C                   Z-ADD     1             Z
     C     WKCCY         LOOKUP    COD(Z)                                 20
     C                   MOVE      CYD(Z)        CYDDS
     C                   Z-ADD     WWFDP         WKCDP             1 0
     C                   Z-ADD     WWSPR         WKSPRT           13 8
     C                   MOVE      WWMDV         WKMDIN            1

      ** If Facility Currency is different to Base Currency
     C     FCCY          IFNE      BJCYCD

      ** If Multiply/Divide Indicator is Multiply
     C     FMDIN         IFEQ      'M'
     C                   MOVE      'D'           WFMIN             1
     C                   ELSE
     C                   MOVE      'M'           WFMIN
     C                   ENDIF

      ** If Facility Mult/Div Ind. & Work Mult/Div Ind. are Multiply
     C     FMDIN         IFEQ      'M'
     C     WKMDIN        ANDEQ     'M'

      ** Or if they are Divide
     C     FMDIN         OREQ      'D'
     C     WKMDIN        ANDEQ     'D'

      ** Set rate to Facility Spot Rate divide by Work Spot Rate
     C     FSPRT         DIV(H)    WKSPRT        WRATE            13 8

      ** Set rate to Facility Spot Rate multiply by Work Spot Rate
     C                   ELSE
     C     FSPRT         MULT(H)   WKSPRT        WRATE
     C                   ENDIF

     C                   MOVE      'Y'           WFLAG             1

      ** If Facility Currency is equal to Base Currency
     C                   ELSE

      ** Set Rate to work Spot Rate
     C                   Z-ADD     WKSPRT        WRATE

      ** If Work Mult/Div Indicator is Multiply
     C     WKMDIN        IFEQ      'M'

      ** Set Work Mult/Div Indicator to Multiply
     C                   MOVE      'M'           WFMIN
     C                   MOVE      'N'           WFLAG
     C                   ELSE

      ** Set Work Mult/Div Indicator to Divide
     C                   MOVE      'D'           WFMIN
     C                   MOVE      'Y'           WFLAG
     C                   ENDIF

     C                   ENDIF

      ** Set dec. places to Facility dec. places minus Work dec. places
     C     FCDP          SUB       WKCDP         DP                1 0
     C                   ADD       4             DP

      ** If Work Mult/Div is Divide
     C     WFLAG         IFEQ      'Y'
     C     WFMIN         IFEQ      'D'

      ** Set exchange Rate to Rate divided by dec. places member of
      ** Power array
     C     WRATE         DIV(H)    POWR(DP)      WEXRT            13 8

      ** Inverse Exchange Rate
     C     1             DIV       WEXRT         WEXRT
     C                   ELSE

      ** Set exchange rate to rate mult. by dec. places member of
      ** Power array
     C     WRATE         MULT(H)   POWR(DP)      WEXRT
     C                   ENDIF

      ** If Flag WFLAG is 'N'
     C                   ELSE

      ** Set exchange rate to rate mult. by dec. places member of
      ** Power array
     C     WRATE         MULT(H)   POWR(DP)      WEXRT

     C                   ENDIF

      ** Use FCXR for loan events -- Apply GEMS 199389 from LE0211.
     C     LNRFSV        CHAIN     CLOAN                              32

     C     *IN32         IFEQ      '1'
     C     LNRFSV        CHAIN     MLOAN                              32
     C                   ENDIF

     C     FCXR          IFEQ      *ZEROS
     C     FCXR          OREQ      1
     C     *IN32         OREQ      '1'
     C                   MULT(H)   WEXRT         WKAMT
     C                   ELSE
     C     FMDI          IFEQ      'D'
     C     FCXR          DIV(H)    POWR(DP)      WFCXRT           15 9
     C     1             DIV       WFCXRT        WFCXRT
     C                   ELSE
     C     FCXR          MULT(H)   POWR(DP)      WFCXRT
     C                   ENDIF
     C                   MULT(H)   WFCXRT        WKAMT
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *    SRWKAM  -  Add/Subtract Work Amount                        *
      *                                                               *
      *    Called By: FCAMSR                                          *
      *                                                               *
      *    Calls    :                                                 *
      *****************************************************************
     C     SRWKAM        BEGSR

      ** UTILISATION START, UTILISATION INCREASE
     C     WKAMTP        IFEQ      'US'
     C     WKAMTP        OREQ      'UI'

      ** Subtract Work Amount from Work UnDrawn Amount
     C                   SUB       WKAMT         WKUNDR
     C                   ENDIF

      ** UTILISATION DECREASE, UTILISATION EXPIRY
     C     WKAMTP        IFEQ      'UD'
     C     WKAMTP        OREQ      'UE'
     C     @RV           IFEQ      'Y'

      ** Add Work Amount to Work UnDrawn Amount
     C                   ADD       WKAMT         WKUNDR
     C                   ELSE

      ** Subtract Work Amount
     C                   SUB       WKAMT         WKUNDR
     C                   ENDIF
     C                   ENDIF

      ** REPAYMENT, MATURITY, MANUAL REPAYMENT
     C     WKAMTP        IFEQ      'RE'
     C     WKAMTP        OREQ      'MT'
     C     WKAMTP        OREQ      'MR'

      ** If Saved Revolving Credit is Yes,
      ** Add Work Amount to Work UnDrawn Amount
     C     @RV           IFEQ      'Y'
     C                   ADD       WKAMT         WKUNDR
     C                   ELSE

      ** If Generated by Assignment,
      ** Subtract Work Amount from Work Facility Amount
     C     GASS          IFNE      'A'
     C                   SUB       WKAMT         WKUNDR
     C                   ELSE

      ** Add Work Amount to Work UnDrawn Amount
     C                   ADD       WKAMT         WKUNDR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** PRINCIPAL INCREASE, LOAN START
     C     WKAMTP        IFEQ      'PI'
     C     WKAMTP        OREQ      'ST'

      ** Subtract Work Amount from Work Undrawn Amount
     C                   SUB       WKAMT         WKUNDR
     C                   ENDIF

      ** LOAN REVERSAL
     C     WKAMTP        IFEQ      'RV'

      ** Add Work Amount to Work UnDrawn Amount
     C                   ADD       WKAMT         WKUNDR
     C                   ENDIF

      ** FACILITY INCREASE
     C     WKAMTP        IFEQ      'FI'

      ** Add Work Amount to Work UnDrawn Amount
     C                   ADD       WKAMT         WKUNDR
     C                   ENDIF

      ** FACILITY DECREASE
     C     WKAMTP        IFEQ      'FD'

      ** Subtract Work Amount from Work UnDrawn Amount
     C                   SUB       WKAMT         WKUNDR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   *INZSR        BEGSR
      *****************************************************************

      ***  Receive input parameters from the Transaction Input pgm.
     C     *ENTRY        PLIST
     C                   PARM                    PLCNUM            6
     C                   PARM                    PLFACT            3
     C                   PARM                    PLFCNO            2
     C                   PARM                    PLVDAT
     C                   PARM                    PLMDAT            5 0                     MD025837A
     C                   PARM                    PLCPAM           13 0
     C                   PARM                    NDayFwd
     C                   PARM                    PLACTN            1                        MD027418
     C                   PARM                    PLLNRF            6                        MD027418
     C                   PARM                    PLAMTP            2                        MD027418
     C                   PARM                    PLRTCD            1

      ** Define and access RUNDAT data area for current date
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT

     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'le000630'    DBPGM

      ** Use access program to read bank details file
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*VERIFY'     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check System Date Format, DDMMYY or MMDDYY.
     C     DATF          COMP      'M'                                    98

      ** Key list for LEFCAML3
     C     WKFAM3        KLIST
     C                   KFLD                    W$CNUM
     C                   KFLD                    W$FACT
     C                   KFLD                    W$FCNO

      ** Key list for LEFCAML8
     C     WKFAM2        KLIST
     C                   KFLD                    W$CNUM
     C                   KFLD                    W$FACL
     C                   KFLD                    W$VLDT            5 0

      ** Key list for Facilities file
     C     WKFAC         KLIST
     C                   KFLD                    W$CNUM            6
     C                   KFLD                    W$FACT            3 0
     C                   KFLD                    W$FCNO            2 0
     C                   KFLD                    W$RCTP            1

      ** Read information for dealing currencies
      ** Store in array/data structure
     C                   MOVE      *BLANK        WWMDV
     C                   Z-ADD     0             WWSPR
     C                   Z-ADD     0             WWFDP
     C                   Z-ADD     0             Z                 3 0
     C     *IN80         DOWEQ     '0'
     C                   READ      SDCURRPD                               80
     C     *IN80         IFEQ      '0'
     C     A6DLCI        ANDEQ     'Y'
     C                   ADD       1             Z

     C                   MOVE      A6CYCD        COD(Z)
     C                   MOVEL     A6SPRT        WWSPR
     C                   MOVE      A6NBDP        WWFDP
     C                   MOVE      A6MDIN        WWMDV
     C                   MOVE      CYDDS         CYD(Z)
     C                   ENDIF
     C                   ENDDO

     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZFWDT_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   *PSSR         BEGSR
      *****************************************************************

     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF

     C                   SETON                                        U7U8LR
     C                   RETURN

     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
