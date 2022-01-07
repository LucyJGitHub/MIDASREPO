     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas IR Calculate Next Rate Change Date')             *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IR001113 - Midas IR Calculate Next Rate Change Date          *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Function: This program will calculate the next future        *
      *            rate change date based on current IRS deal details *
      *            at the time when the procedure is called.          *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059362           Date 27Dec21               *
      *  Prev Amend No. MD059253 *CREATE   Date 19Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059362 - Calculator incorrectly processed deals under      *
      *             monthly frequency due to THEIR next rate change   *
      *             date is incorrectly computed. Use correct field   *
      *             to compute the next date.                         *
      *  MD059253 - Create a generic program to calculate IRS deal's  *
      *             next future rate change date.                     *
      *                                                               *
      *****************************************************************

     FDEALALL   IF A E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDGF)

     FDLDTSCPD  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F                                     PREFIX(SC_)

      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** Standard Subroutine Variables
     D/COPY ZSRSRC,ZDATE2Z1LE
     D/COPY ZSRSRC,ZFREQBZ1LE
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE

      ** Data Sructure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Sructure for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Data Sructure for switchable feature details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data Structure for OUR Leg Currencies for Payment Convention
     D                 DS
     D CCYPY1                  1     30
     D  L1CYP1                 1      3
     D  L1CYP2                 4      6
     D  L1CYP3                 7      9
     D  L1CYP4                10     12
     D  L1CYP5                13     15
     D  L1CYP6                16     18
     D  L1CYP7                19     21
     D  L1CYP8                22     24
     D  L1CYP9                25     27
     D  L1CYP0                28     30

      ** Data Structure for THEIR Leg Currencies for Payment Convention
     D                 DS
     D CCYPY2                  1     30
     D  L2CYP1                 1      3
     D  L2CYP2                 4      6
     D  L2CYP3                 7      9
     D  L2CYP4                10     12
     D  L2CYP5                13     15
     D  L2CYP6                16     18
     D  L2CYP7                19     21
     D  L2CYP8                22     24
     D  L2CYP9                25     27
     D  L2CYP0                28     30

      ** Parameters for calling access programs
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A

      ** Program Variables
     D CIR001          S              1A
     D CIR005          S              1A
     D CIR018          S              1A
     D WRUN            S              1A
     D PCallMode       S              1A
     D PDealRef        S              6A
     D PLeg            S              1A
     D PNextDate       S              5P 0
     D PBaseDate       S              5P 0
     D NICD            S                   LIKE(UNICD)
     D ICFR            S                   LIKE(UICFR)
     D ICBD            S                   LIKE(UICBD)
     D ICFD            S                   LIKE(UICFD)
     D CUCY            S                   LIKE(UCUCY)
     D CYP1            S                   LIKE(L1CYP1)
     D KDLNO           S                   LIKE(SC_DLNO)
     D KOTIN           S                   LIKE(SC_OTIN)
     D KRCIP           S                   LIKE(SC_RCIP)
     D KPRDT           S                   LIKE(SC_PRDT)

      ** Currencies for Payment Convention
     D PPayCurr        S             30A
     D PPayDateCon     S              2A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING

     C                   EVAL      PNextDate = 0
     C                   EVAL      PBaseDate = 0

     C     CIR001        IFEQ      'Y'
     C                   OPEN      DLDTSCPD
     C                   ENDIF

     C                   MOVEL     PDealRef      KDLNO
     C     KDLNO         CHAIN     DEALALL
     C                   IF        %FOUND(DEALALL)
     C
     C                   IF        PLeg = 'U'
     C                   MOVEL     UICFR         ICFR
     C                   Z-ADD     UNICD         NICD
     C                   Z-ADD     UICBD         ICBD
     C                   Z-ADD     UICFD         ICFD
     C                   MOVEL     UCUCY         CUCY
     C                   MOVEL     CCYPY1        PPayCurr
     C                   MOVEL     L1PDCN        PPayDateCon
     C                   MOVEL     L1CYP1        CYP1
     C                   ELSEIF    PLeg = 'T'
     C**********         MOVEL     UICFR         ICFR                                       MD059362
     C                   MOVEL     TICFR         ICFR                                       MD059362
     C                   Z-ADD     TNICD         NICD
     C**********         Z-ADD     UICBD         ICBD                                       MD059362
     C**********         Z-ADD     UICFD         ICFD                                       MD059362
     C**********         MOVEL     UCUCY         CUCY                                       MD059362
     C                   Z-ADD     TICBD         ICBD                                       MD059362
     C                   Z-ADD     TICFD         ICFD                                       MD059362
     C                   MOVEL     TCUCY         CUCY                                       MD059362
     C                   MOVEL     CCYPY2        PPayCurr
     C                   MOVEL     L2PDCN        PPayDateCon
     C                   MOVEL     L2CYP1        CYP1
     C                   IF        DTYP = 'RP' or DTYP = 'RR' or                            MD059362
     C                             DTYP = 'RF'                                              MD059362
     C                   MOVEL     CCYPY1        PPayCurr                                   MD059362
     C                   MOVEL     L1PDCN        PPayDateCon                                MD059362
     C                   MOVEL     L1CYP1        CYP1                                       MD059362
     C                   ENDIF                                                              MD059362
     C                   ENDIF

     C                   SELECT
     C                   WHEN      ICFR = *BLANKS and MDAT > 0
     C                   EVAL      PNextDate = MDAT
     C                   EVAL      PBaseDate = MDAT

     C                   WHEN      ICFR <> *BLANKS and NICD > 0
     C                   EXSR      SRCalcNext
     C                   IF        PCallMode = 'L' and PNextDate <= NICD
     C                   EVAL      PNextDate = BJDNWD - 1
     C                   EVAL      PBaseDate = BJDNWD - 1
     C                   ENDIF

     C                   OTHER
     C                   IF        PCallMode = 'L'
     C                   EVAL      PNextDate = BJDNWD - 1
     C                   EVAL      PBaseDate = BJDNWD - 1
     C                   ENDIF

     C                   ENDSL

     C                   ENDIF

     C     CIR001        IFEQ      'Y'
     C                   CLOSE     DLDTSCPD
     C                   ENDIF

      ** End program
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcNext - Calculate next rate change date                  *
      *                                                               *
      *****************************************************************
     C     SRCalcNext    BEGSR

     C                   MOVE      ICFR          ZFREQ
     C                   Z-ADD     ICBD          ZDAYNO
     C                   Z-ADD     ICFD          ZMDAY
     C                   MOVE      CUCY          ZCCY
     C                   MOVE      BJSLCD        ZLOC

      ** If Daily Rate Change Frequency then simply add 1
      ** to next change date
     C     CIR018        IFEQ      'Y'
     C     ZFREQ         ANDEQ     'D'
     C     NICD          ADD       1             ZDYNBR
     C     NICD          ADD       1             ZDAYNO
     C                   ELSE

      ** If CIR001 is on and Interest Frequency is Not 'Z',
      ** perform processing as at present using SR/ZFREQC, otherwise
      ** use SR/SRDetNxtDate.
     C     CIR001        IFEQ      'Y'
     C     ZFREQ         ANDNE     'Z'
     C     CIR001        ORNE      'Y'

     C     CIR005        IFEQ      'N'
     C     CYP1          OREQ      *BLANKS

     C                   EXSR      ZFREQC
     C                   Z-ADD     0             ZNRDYS
     C                   MOVE      BJSLCD        ZLOC
     C                   EXSR      ZFWDT

     C                   ELSE
     C                   EXSR      ZFRQB3

     C                   CALL      'DLZIRP'
     C                   PARM                    ZDAYNO
     C                   PARM      CCYPY1        PPayCurr
     C                   PARM      L1PDCN        PPayDateCon
     C                   PARM                    ZLOC
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PAJDT             5 0
     C                   PARM      *ZEROS        PBSDT             5 0
     C                   Z-ADD     PAJDT         ZDYNBR
     C                   Z-ADD     PBSDT         ZDAYNO

      ** Do not return adjusted date if it is equal to or earlier than
      ** previous date (only happens for 'previous' date calculations)
      ** instead use the base date
     C                   IF        ICBD >= ZDYNBR
     C                   Z-ADD     PBSDT         ZDYNBR
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

      ** If Frequency is Z, determine next date from Date Schedule File
     C                   Z-ADD     DLNO          KDLNO
     C                   MOVEL     PLeg          KOTIN
     C                   MOVEL     'R'           KRCIP
     C                   EXSR      SRDetNxtDate
     C                   Z-ADD     ZDAYNO        ZDYNBR

     C                   ENDIF

     C                   ENDIF

     C                   IF        ZDYNBR >= MDAT
     C                   EVAL      PNextDate = MDAT
     C                   EVAL      PBaseDate = MDAT
     C                   ELSE
     C                   EVAL      PNextDate = ZDYNBR
     C                   EVAL      PBaseDate = ZDAYNO
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetNxtDate - Determine next rate change date based from the *
      *                Date Schedule file                             *
      *                                                               *
      *****************************************************************
     C     SRDetNxtDate  BEGSR

     C                   Z-ADD     ZDAYNO        KPRDT
     C     KDTSL         SETGT     DLDTSCPD
     C     KDTSP         READE     DLDTSCPD                               99
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     SC_PRDT       ZDAYNO
     C                   ELSE
     C                   Z-ADD     MDAT          ZDAYNO
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZFREQ - SR. TO INCREMENT A DAY NUMBER DATE BY A               *
      *         PERIOD VALUE DETERMINED BY A CODE.                    *
      *                                                               *
      *****************************************************************
     C     ZFREQC        BEGSR

      ** CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C                   MOVE      ZFREQ         ZFREQ             1
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   Z-ADD     ZMDAY         ZMDAY             2 0
     C                   MOVE      ZCCY          ZCCY              3

      ** FIELDS USED FOR PERIOD CODES M,T,Q,X,Y
     C                   MOVE      '  '          ZINDE             2
     C                   Z-ADD     0             ZINTO             2 0

      ** CONVERT DAY NUMBER TO DATE.
     C                   EXSR      ZDATE2
     C                   SETOFF                                       90

      ** CHECK FOR AND INCREMENT FOR CODE D-DAILY-WORKING DAY.
     C     ZFREQ         COMP      'D'                                    91
     C   91ZDAYNO        ADD       1             ZDAYNO
     C   91              GOTO      ZFHCHK

      ** CHECK FOR AND INCREMENT FOR CODE W-WEEKLY.
     C     ZFREQ         COMP      'W'                                    91
     C   91ZDAYNO        ADD       7             ZDAYNO
     C   91              GOTO      ZFEND

      ** CHECK FOR AND INCREMENT FOR CODE F-FORTNIGHTLY.
     C     ZFREQ         COMP      'F'                                    91
     C   91ZDAYNO        ADD       14            ZDAYNO
     C   91              GOTO      ZFEND

      ** CHECK FOR AND INCREMENT FOR CODE S-SEMI-MONTHLY.
     C     ZFREQ         COMP      'S'                                    91
     C   91ZDAY          COMP      15                                 939292
     C   91
     CAN 92              Z-ADD     31            ZDAY
     C   91
     CAN 93              Z-ADD     15            ZDAY
     C   91
     CAN 93ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE

      ** CHECK FOR AND INCREMENT FOR CODE M-MONTHLY.
     C     ZFREQ         COMP      'M'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE

      ** CHECK FOR AND INCREMENT FOR CODE R-SIX DAYS BEFORE END OF MONTH
     C     ZFREQ         COMP      'R'                                    91
     C   91              Z-ADD     31            ZDAY
     C   91ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE

      ** CHECK FOR AND INCREMENT FOR CODE T-BIMONTHLY.
     C     ZFREQ         COMP      'T'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       2             ZMTH
     C   91              GOTO      ZFDATE

      ** CHECK FOR AND INCREMENT FOR CODE Q-QUARTERLY.
     C     ZFREQ         COMP      'Q'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       3             ZMTH
     C   91              GOTO      ZFDATE

      ** CHECK FOR AND INCREMENT FOR CODE X-SIX MONTHLY.
     C     ZFREQ         COMP      'X'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       6             ZMTH
     C   91              GOTO      ZFDATE

      ** CHECK FOR AND INCREMENT FOR CODE Y-YEARLY.
     C     ZFREQ         COMP      'Y'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZYEAR         ADD       1             ZYEAR
     C   91              GOTO      ZFDATE

      ** CHECK FOR AND INCREMENT FOR CODE L-LAST CALENDAR DAY OF MONTH.
     C     ZFREQ         COMP      'L'                                    91
     C   91              Z-ADD     31            ZDAY
     C   91ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE

      ** CHECK FOR AND INCREMENT FOR CODE B-LAST WORKING DAY OF MONTH.
     C     ZFREQ         COMP      'B'                                    91
     C   91              Z-ADD     31            ZDAY
     C   91ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE

      ** CHECK FOR AND INCREMENT FOR CODE A-MONTHLY ACCRUAL/PROFIT DATE.
     C     ZFREQ         COMP      'A'                                    91
     C   91              Z-ADD     BKAPDT        ZDAYNO

      ** BYPASS IF ZFREQ IS 'A' OR ANY OTHER VALUE
     C                   GOTO      ZFEND

      ** REFORMAT DATE AND ENSURE VALID.
     C     ZFDATE        TAG

      ** VALIDATE MONTH.
     C     ZMTH          COMP      12                                 91
     C   91ZMTH          SUB       12            ZMTH
     C   91ZYEAR         ADD       1             ZYEAR

      ** CHECK FOR LEAP YEAR.
     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0    92

      ** VALIDATE DAY NUMBER.
     C                   MOVE      ZFMD(ZMTH)    ZWRK2             2 0
     C     ZMTH          COMP      2                                      93
     C   92
     CAN 93              Z-ADD     29            ZWRK2

     C     ZDAY          COMP      ZWRK2                              94
     C   94              Z-ADD     ZWRK2         ZDAY

      ** CHECK IF CODE R, TO SUBTRACT 6 DAYS.
     C     ZFREQ         COMP      'R'                                    91
     C   91ZDAY          SUB       6             ZDAY

      ** REFORMAT DATE, DDMMYY OR MMDDYY, AND CONVERT TO DAY NUMBER.
     C                   MOVEL     ZDAY          ZWRK4             4 0
     C                   MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C   98              MOVE      ZDAY          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C                   EXSR      ZDATE1

      ** Store the Base Date (ie. before adjustment for holidays)
     C                   Z-ADD     ZDAYNO        ZBD               5 0

      **   CHECK IF CODE B, OR M,T,Q,X,Y TO BE CHECKED FOR HOLIDAY.
     C     ZFREQ         COMP      'B'                                    91
     C     ZINDE         COMP      'IN'                                   92

     C   92
     CANN99
     COR 91
     CANN99              GOTO      ZFHCHK

     C                   GOTO      ZFEND

      ** CHECK IF DAY NUMBER IS A HOLIDAY.
     C     ZFHCHK        TAG
     C                   SETOFF                                       94

     C     ZFREQ         COMP      'D'                                    91
     C     ZFREQ         COMP      'B'                                    92
     C   91
     COR 92              GOTO      ZSETK

      ** FOR CODES M,T,Q,X,Y, CHECK ZINDE - 'IN' TO INCREMENT,
      **                                  - 'DE' TO DECREMENT
     C     ZINDE         COMP      'IN'                                   90
     C     ZINDE         COMP      'IN'                                   91
     C     ZINDE         COMP      'DE'                                   92

     C     ZSETK         TAG

     C                   EXSR      ZCHKH

      ** CHECK IF CURRENCY ON HOLIDAY.
     C     ZIND          CABEQ     'W'           ZFEND

      ** BYPASS IF NOT HOLIDAY FOR CURRENCY.
     C   92              GOTO      ZDECR

      ** INCREMENT OR DECREMENT DAY NUMBER AS REQUIRED.
     C   91ZDAYNO        ADD       1             ZDAYNO

      ** ONLY FOR PERIOD CODE = M,T,Q,X OR Y, IF INCREMENTATION
      ** TAKES THE OUTPUT DATE INTO THE FOLLOWING MONTH, RETURN TO
      ** THE INPUT DATE AND DECREMENT - 92 ON.
     C   90
     CAN 91ZINTO         ADD       1             ZINTO
     C   90
     CAN 91ZINTO         ADD       ZDAY          ZINTOT            2 0
     C   90
     CAN 91              MOVE      ZINTOT        ZINTOA            2

      ** TO ALLOW 29 FEB ON LEAP YEARS TO PASS
     C                   SETOFF                                       93
     C   90
     CAN 91ZYEAR         DIV       4             ZLYR
     C   90
     CAN 91              MVR                     ZLY                      92
     C   90
     CAN 91
     CAN 92ZMTH          COMP      2                                      93
     C   93ZINTOA        COMP      '29'                               92
     C   90
     CAN 91
     CANN93ZINTOA        COMP      ZFMD(ZMTH)                         92
     C   90
     CAN 91
     CAN 92ZDAYNO        SUB       ZINTO         ZDAYNO
     C   90
     CAN 91
     CAN 92              MOVE      'DE'          ZINDE

     C     ZDECR         TAG
     C   92ZDAYNO        SUB       1             ZDAYNO
     C                   GOTO      ZFHCHK

     C     ZFEND         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PCallMode
     C                   PARM                    PDealRef
     C                   PARM                    PLeg
     C                   PARM                    PNextDate
     C                   PARM                    PBaseDate

      ** Key Fields for DLDTSCPD
     C     KDTSL         KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KOTIN
     C                   KFLD                    KRCIP
     C                   KFLD                    KPRDT

     C     KDTSP         KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KOTIN
     C                   KFLD                    KRCIP

      ** Initialize Work fields
     C                   EVAL      DBPGM = 'IR000113'

      ** Access Bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *IN98 = *OFF
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF

      ** Access General Ledger details
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Determine if CIR001 is installed
     C                   MOVE      'N'           CIR001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C     PRtCd         IFEQ      *BLANK
     C                   MOVE      'Y'           CIR001
     C                   ENDIF

      ** Determine if CIR005 is installed
     C                   MOVE      'N'           CIR005
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR005'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C     PRtCd         IFEQ      *BLANK
     C                   MOVE      'Y'           CIR005
     C                   ENDIF

      ** Determine if CIR018 is installed
     C                   MOVE      'N'           CIR018
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR018'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C     PRtCd         IFEQ      *BLANK
     C                   MOVE      'Y'           CIR018
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZBKDT_ILE
     C/COPY ZSRSRC,ZFWDT_ILE
     C/COPY ZSRSRC,ZDATE2Z4LE
     C/COPY ZSRSRC,ZDATE1Z2LE
     C/COPY ZSRSRC,ZFRQB3_ILE
     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZCHKHLE
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
