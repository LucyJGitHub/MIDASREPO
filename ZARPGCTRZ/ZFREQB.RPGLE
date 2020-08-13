     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Calc day num of next pymnt frq from curr dayno')       *
      *****************************************************************
      *                                                               *
      *  Midas - ZFREQB ILE Module                                    *
      *                                                               *
      *  ZFREQB                                                       *
      *                                                               *
      *  Function:                                                    *
      * ** +-------The comments from ZFREQBZTXT start here ---------+ *
      * Purpose:
      * ~~~~~~~~
      *  To calculate the day number of the next payment/statement date
      *  from current date/day in month and frequency code.
      *
      *  Input:
      *  ~~~~~
      *
      *  ZFREQ   -    A one character field containinh the frequency code.
      *
      *  ZDAYNO  -    A five digit field containing the base date
      *               (day number of current payment date.)
      *
      *  ZMDAY   -    A two digit field containing the day of the month
      *               (required only for certain frequencies:
      *               M R T Q X Y L B) on which payment should fall.
      *
      *  ZCCY    -    A three character field containing the currency code.
      *               For processing to check a working day has been found,
      *               this currency code is used.
 
      *  ZLOC    -    A three character field containing the location code.
      *               This may be left blank if no location is required.
 
      *  Procedure:
      *  ~~~~~~~~~
      *
      *  1.   ZDAYNO is converted using ZDATE2 into ZMTH, ZYEAR and ZDAY.
      *
      *  2.   The required number of days is added to ZDAYNO for any
      *       frequencies less than one month.
      *
      *  3.   For other frequencies, the required number of months/days is
      *       applied to ZMTH, ZDAY, ZYEAR as appropriate.
      *
      *  4.   ZDATE is converted using ZDATE1 into a MIDAS day number.
      *
      *  5.   If required, the next working day after that calculated is
      *       found, using ZCHKH.
      *
      *
      *  Output:
      *  ~~~~~~
      *
      *  ZDAYNO - a five digit field containing the MIDAS day no. for the
      *           next payment date calculated.
      *
      *  RetCodeIn - A 7 character field set to blanks if the module
      *              runs successfully and 'Error' if an error occurs.
      * ** +-------The comments from ZFREQBZTXT end  here ----------+ *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD055733           Date 03Jul20               *
      *  Prev Amend No. MD050139           Date 23Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL184             Date 07Dec16               *
      *                 CLE064             Date 06Dec10               *
      *                 AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG6491            Date 13Apr05               *
      *                 CGL029             Date 01Sep03               *
      *                 212408             Date 24Sep02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209772             Date 06Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 15Dec97               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055733 - COB: Multiple UTCHOBJEX calls in LEC06A           *
      *             components.                                       *
      *           - Redeliver of MD050139.                            *
      *  MD050139- AOSARDR0 called every time causing performance     *
      *            issue. Remove call and condition to CGL184 on copy *
      *            sources.                                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL184 - New Frequencies for Account Statements              *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  BUG6491 (00044842) - The next payment date is incorrect when *
      *           in leap year.  Applied fix 223537.                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  212408 - Array index is out of range                         *
      *  209772 - Date not correctly checked for holiday              *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Date data structure used for calculations in this module
     D  WrkDateDS      DS             6
     DZDAY                     1      2  0
     DZMTH                     3      4  0
     DZYEAR                    5      6  0
 
      ** General ledger data structure passed from calling program and to acces program
     D  SDGELR       E DS                  EXTNAME(SDGELRPD)
 
      ** Dummy data structure used to pass SDGELR to access program
     D  DSFDY        E DS                  EXTNAME(DSFDY)
 
      ** Array containing number of days in month.
     D  ZFMD           S              2  0 DIM(12) CTDATA PERRCD(12)
      **********                                                                     CGL184 MD050139
      ***EXTERNAL*DS*FOR*SAR*DETAILS***********************************              CGL184 MD050139
     D*SCSARD***     E DS                  EXTNAME(SCSARDPD)                         CGL184 MD050139
      **********                                                                     CGL184 MD050139
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Rate Change Frequency passed in as parameter from calling program
     D  ZFREQ          S              1A
 
      ** MIDAS day number passed in as parameter from calling program
     D  ZDAYNO         S              5  0
 
      ** Currency code passed in as parameter from calling program
     D  ZCCY           S              3A
 
      ** Rate frequency day passed as parameter from calling program
     D  ZMDAY          S              2  0
 
      ** Date format indicator passed as a parameter from calling program.
     D  BJDFIN         S              1A
 
      ** Location code passed as a parameter from calling program.
     D  ZLOC           S              3A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **  INCREMENTAL or DECREMENTAL variable used in module only
     D  ZINDE          S              2A
 
      **  Work field for leap year calculations based on period code. Used only in module
     D  ZINTO          S              2  0
 
      **  Date field passed to ZDATE1 to be converted to MIDAS day number.
     D  ZDATE          S              6A
 
      **  Error flag passed back as parameter from ZDATE1. Not used in this module.
     D  ErrorFlag      S              1A
 
      **  Date field returned from ZDATE2 after conversion from MIDAS day number.
     D  ZADATE         S              7A
 
      ** Numerical date format after conversion from MIDAS day number from ZDATE2
     D  ZNDATE         S              6  0
 
      ** Work field containing calendar day number from ZADATE
     D  ZZWRK2         S              2  0
 
      ** Return code from access programme AOGELRR0
     D  P@AORC         S              7A
 
      ** Option passed to access program as a parameter
     D  P@OPTN         S              7A
 
      ** Result of dividing ZYEAR by 4 for leap year caluculations
     D  ZLYR           S              2  0
 
      ** Work field containg remainder of ZYEAR divided by 4. Use for leap year caluculations
     D  ZLY            S              1  0
 
      ** Work field containing day value calculated from days in month array.
     D  ZWRK2          S              2  0
 
      ** Day number as numerical field.
     D  ZINTOT         S              2  0
 
      ** Day number as character field.
     D  ZINTOA         S              2A
 
      ** Holiday indicator pass to module from ZHCHK
     D  ZIND           S              1A
 
      ** Working variable for day                                                             212408
     D WZDAY           S              2  0                                                    212408
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      ErrorFound = 'N'
 
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      *OFF          *IN98
     C                   ELSE
     C                   MOVE      *ON           *IN98
     C                   ENDIF
 
     C                   EXSR      @FREQB
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
 
     C                   RETURN
     C
     C
      *-----------------Start of modified subroutine ZFREQB----------------*--------*
3661 C*****      ZFREQB    BEGSR                           *** ZFREQB *** S01195
3661 C     @FREQB        BEGSR
3662 C**
3663 C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
3664 C                   MOVE      ZFREQ         ZFREQ             1
3665 C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
3666 C                   Z-ADD     ZMDAY         ZMDAY             2 0
3667 C                   MOVE      ZCCY          ZCCY              3
     C                   MOVE      ZCCY          ZCCY
     C                   MOVE      *BLANKS       ErrorFound
3674 C                   MOVE      '  '          ZINDE             2
3675 C                   Z-ADD     0             ZINTO             2 0
3676 C**
3677 C**   CONVERT DAY NUMBER TO DATE and places them into WRKDATEDS
3678 C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZNDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZNDATE        WRKDATEDS
                                                                                              212408
      ** For MMDDYY Dates                                                                     212408
     C                   IF        BJDFIN = 'M'                                               212408
     C                   EVAL      WZDAY = ZDAY                                               212408
     C                   EVAL      ZDAY = ZMTH                                                212408
     C                   EVAL      ZMTH = WZDAY                                               212408
     C                   ENDIF                                                                212408
 
      **If the day number input (ZMDAY) is zero set it equal to the day
      **number of the start day.
 
     C     ZMDAY         IFEQ      0
     C                   MOVEL     ZADATE        ZZWRK2
     C                   MOVE      ZZWRK2        ZMDAY
     C                   ENDIF
     C                   MOVE      *OFF          *IN90
3680 C**
3681 C**   CHECK FOR AND INCREMENT FOR CODE D-DAILY-WORKING DAY.
3682 C     ZFREQ         IFEQ      'D'
     C     ZFREQ         OREQ      'K'                                                        CGL184
     C*****CGL184        ANDEQ     'Y'                                               CGL184 MD050139
3683 C     ZDAYNO        ADD       1             ZDAYNO
     C                   GOTO      ZFHCHK
     C                   ENDIF
3685 C**
3686 C**   CHECK FOR AND INCREMENT FOR CODE W-WEEKLY.
3687 C     ZFREQ         IFEQ      'W'
3688 C     ZDAYNO        ADD       7             ZDAYNO
3689 C                   GOTO      ZFEND
     C                   ENDIF
3690 C**
3691 C**   CHECK FOR AND INCREMENT FOR CODE F-FORTNIGHTLY.
3692 C     ZFREQ         IFEQ      'F'
3693 C     ZDAYNO        ADD       14            ZDAYNO
3694 C                   GOTO      ZFEND
     C                   ENDIF
3695 C**
3696 C**   CHECK FOR AND INCREMENT FOR CODE S-SEMI-MONTHLY.
3697 C     ZFREQ         IFEQ      'S'
3698 C     ZDAY          IFLE      15
3699 C                   Z-ADD     31            ZDAY
     C                   ELSE
3700 C                   Z-ADD     15            ZDAY
3701 C     ZMTH          ADD       1             ZMTH
     C                   ENDIF
     C                   ENDIF
3703 C**
3704 C**   CHECK FOR AND INCREMENT FOR CODE M-MONTHLY.
3705 C     ZFREQ         IFEQ      'M'
     C     ZFREQ         OREQ      'G'                                                        CGL184
     C*****CGL184        ANDEQ     'Y'                                                CGL184 MD50139
3706 C                   MOVE      'IN'          ZINDE
3707 C                   Z-ADD     ZMDAY         ZDAY
3708 C     ZMTH          ADD       1             ZMTH
     C                   ENDIF
3710 C**
3711 C**   CHECK FOR AND INCREMENT FOR CODE R-SIX DAYS BEFORE END OF MONTH
3712 C     ZFREQ         IFEQ      'R'
3713 C                   Z-ADD     31            ZDAY
3714 C     ZMTH          ADD       1             ZMTH
3715 C                   ENDIF
3716 C**
3717 C**   CHECK FOR AND INCREMENT FOR CODE T-BIMONTHLY.
3718 C     ZFREQ         IFEQ      'T'
3719 C                   MOVE      'IN'          ZINDE
3720 C                   Z-ADD     ZMDAY         ZDAY
3721 C     ZMTH          ADD       2             ZMTH
3722 C                   ENDIF
3723 C**
3724 C**   CHECK FOR AND INCREMENT FOR CODE Q-QUARTERLY.
3725 C     ZFREQ         IFEQ      'Q'
     C     ZFREQ         OREQ      'H'                                                        CGL184
     C*****CGL184        ANDEQ     'Y'                                               CGL184 MD050139
3726 C                   MOVE      'IN'          ZINDE
3727 C                   Z-ADD     ZMDAY         ZDAY
3728 C     ZMTH          ADD       3             ZMTH
3729 C                   ENDIF
3730 C**
3731 C**   CHECK FOR AND INCREMENT FOR CODE X-SIX MONTHLY.
3732 C     ZFREQ         IFEQ      'X'
3733 C                   MOVE      'IN'          ZINDE
3734 C                   Z-ADD     ZMDAY         ZDAY
3735 C     ZMTH          ADD       6             ZMTH
3736 C                   ENDIF
3737 C**
3738 C**   CHECK FOR AND INCREMENT FOR CODE Y-YEARLY.
3739 C     ZFREQ         IFEQ      'Y'
     C     ZFREQ         OREQ      'O'                                                        CGL184
     C*****CGL184        ANDEQ     'Y'                                               CGL184 MD050139
3740 C                   MOVE      'IN'          ZINDE
3734 C                   Z-ADD     ZMDAY         ZDAY
3741 C     ZYEAR         ADD       1             ZYEAR
3742 C                   ENDIF
3743 C**
3744 C**   CHECK FOR AND INCREMENT FOR CODE L-LAST CALENDAR DAY OF MONTH.
3745 C     ZFREQ         IFEQ      'L'
3746 C                   Z-ADD     31            ZDAY
3747 C     ZMTH          ADD       1             ZMTH
3748 C                   ENDIF
3749 C*
3750 C**   CHECK FOR AND INCREMENT FOR CODE B-LAST WORKING DAY OF MONTH.
3751 C     ZFREQ         IFEQ      'B'
3752 C                   Z-ADD     31            ZDAY
3753 C     ZMTH          ADD       1             ZMTH
3754 C                   ENDIF
      *                                                                                       CLE064
      ** If frequency = '4' for 4-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '4'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       4             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = '5' for 5-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '5'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       5             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = '7' for 7-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '7'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       7             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = '8' for 8-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '8'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       8             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = '9' for 9-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '9'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       9             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'V' for 10-monthly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'V'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       10            ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'E' for 11-monthly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'E'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       11            ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'C' for two-yearly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'C'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       2             ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'I' for three-yearly.                                                 CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'I'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       3             ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'J' for four-yearly.                                                  CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'J'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       4             ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'N' for five-yearly.                                                  CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'N'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       5             ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'U' for ten-yearly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'U'                                                        CLE064
     C                   MOVE      'IN'          ZINDE                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       10            ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
3755 C**
3756 C**   CHECK FOR AND INCREMENT FOR CODE A-MONTHLY ACCRUAL/PROFIT DATE.
3757 C     ZFREQ         IFEQ      'A'
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANK        P@AORC            7
     C                   PARM      '*FIRST'      P@OPTN            7
     C*****SDGELR        PARM      *BLANK        DSFDY                                        CGL029
     C     SDGELR        PARM      *BLANK        DSSDY                                        CGL029
 
     C     P@AORC        IFEQ      *BLANK
     C                   Z-ADD     BKAPDT        ZDAYNO
     C                   ELSE
     C                   MOVEL     'Y'           ErrorFound
     C                   ENDIF
 
3763 C**
3764 C**   BYPASS IF ZFREQ IS 'A' OR ANY OTHER VALUE
3765 C                   GOTO      ZFEND
     C                   ENDIF
3766 C**
3767 C**
3768 C**   REFORMAT DATE AND ENSURE VALID.
      **
3771 C**   VALIDATE MONTH.
3772 C     ZMTH          IFGT      12
3773 C     ZMTH          SUB       12            ZMTH
3774 C     ZYEAR         ADD       1             ZYEAR
     C                   ENDIF
3775 C**
3776 C**   CHECK FOR LEAP YEAR.
3777 C     ZYEAR         DIV       4             ZLYR              2 0
3778 C                   MVR                     ZLY               1 0
3779 C**
3780 C**   VALIDATE DAY NUMBER.
3781 C                   MOVE      ZFMD(ZMTH)    ZWRK2             2 0
3782 C     ZMTH          IFEQ      2
     C     ZLY           ANDEQ     0
3783 C                   Z-ADD     29            ZWRK2
     C                   ENDIF
3784 C**
3785 C     ZDAY          IFGT      ZWRK2
3786 C                   Z-ADD     ZWRK2         ZDAY
     C                   ENDIF
3787 C**
3788 C**   CHECK IF CODE R, TO SUBTRACT 6 DAYS.
3789 C     ZFREQ         IFEQ      'R'
3790 C     ZDAY          SUB       6             ZDAY
     C                   ENDIF
3791 C**
3792 C**   REFORMAT DATE, DDMMYY OR MMDDYY, AND CONVERT TO DAY NUMBER.
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     ZDAY          ZWRK4             4 0
3794 C                   MOVE      ZMTH          ZWRK4
     C                   ELSE
3795 C                   MOVEL     ZMTH          ZWRK4
3796 C                   MOVE      ZDAY          ZWRK4
     C                   ENDIF
3797 C                   MOVEL     ZWRK4         ZDATE
3798 C                   MOVE      ZYEAR         ZDATE
 
3799 C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
3800 C**
3801 C**   CHECK IF CODE B, OR M,T,Q,X,Y TO BE CHECKED FOR HOLIDAY.
     C     ZFREQ         IFEQ      'B'
     C     ErrorFlag     ANDEQ     'N'
     C     ZINDE         OREQ      'IN'
     C     ErrorFlag     ANDEQ     'N'
     C                   GOTO      ZFHCHK
     C                   ENDIF
3806 C**
3807 C                   GOTO      ZFEND
3808 C**
3809 C**   CHECK IF DAY NUMBER IS A HOLIDAY.
3810 C**
3811 C     ZFHCHK        TAG                                                    ** ZFHCHK TAG *
     C     ZFREQ         IFEQ      'D'
     C     ZFREQ         OREQ      'B'
     C                   GOTO      ZSETK
     C                   ENDIF
3817 C*
3818 C*   FOR CODES M,T,Q,X,Y, CHECK ZINDE - 'IN' TO INCREMENT,
3819 C*                                    - 'DE' TO DECREMENT
3820 C*
 
3826 C     ZSETK         TAG                                                    ** ZSETK TAG **
3849 C*                                                                   S01195
     C                   CALLB     'ZCHKH'                                                     S0119
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*                                                                   S01195
     C     ZIND          IFEQ      'W'                                                         S0119
     C                   GOTO      ZFEND
     C                   ENDIF
     C     ZINDE         IFEQ      'DE'
3862 C                   GOTO      ZDECR
     C                   ENDIF
3863 C*
3864 C**   INCREMENT OR DECREMENT DAY NUMBER AS REQUIRED.
     C     ZINDE         IFEQ      'IN'
     C     ZFREQ         OREQ      'D'                                                        209772
     C     ZDAYNO        ADD       1             ZDAYNO
     C                   ENDIF
3866 C*
3867 C*    ONLY FOR PERIOD CODE = M,T,Q,X OR Y, IF INCREMENTATION
3868 C*    TAKES THE OUTPUT DATE INTO THE FOLLOWING MONTH, RETURN TO
3869 C*    THE INPUT DATE AND DECREMENT - 92 ON.
3870 C*
     C     ZINDE         IFEQ      'IN'
     C     ZINTO         ADD       1             ZINTO
     C     ZINTO         ADD       ZDAY          ZINTOT            2 0
     C                   MOVE      ZINTOT        ZINTOA
      ** TO allow 29 Feb on leapyears to pass
     C     ZYEAR         DIV       4             ZLYR
     C                   MVR                     ZLY
     C     ZLY           IFEQ      0
     C     ZMTH          ANDEQ     2
     C*****ZINTOA        ANDLT     '29'                                                      BUG6491
     C     ZINTOA        ANDGT     '29'                                                      BUG6491
     C     ZDAYNO        SUB       ZINTO         ZDAYNO
     C                   MOVE      'DE'          ZINDE
     C                   ENDIF
     C     ZLY           IFEQ      0
     C     ZMTH          ANDNE     2
     C*****ZINTOT        ANDLT     ZFMD(ZMTH)                                                BUG6491
     C     ZINTOT        ANDGT     ZFMD(ZMTH)                                                BUG6491
     C     ZDAYNO        SUB       ZINTO         ZDAYNO
     C                   MOVE      'DE'          ZINDE
     C                   ENDIF
      *                                                                                      BUG6491
     C     ZLY           IFNE      0                                                         BUG6491
     C     ZINTOT        ANDGT     ZFMD(ZMTH)                                                BUG6491
     C     ZDAYNO        SUB       ZINTO         ZDAYNO                                      BUG6491
     C                   MOVE      'DE'          ZINDE                                       BUG6491
     C                   ENDIF                                                               BUG6491
     C                   ENDIF
3877 c**
3878 C     ZDECR         TAG                                                    ** ZDECR TAG **
     C     ZINDE         IFEQ      'DE'
     C     ZFREQ         OREQ      'B'                                                        209772
     C     ZDAYNO        SUB       1             ZDAYNO
     C**********         GOTO      ZFHCHK                                                     209772
     C                   ENDIF
      *                                                                                       209772
     C                   GOTO      ZFHCHK                                                     209772
3882 C**
3883 C**
3884 C     ZFEND         ENDSR                                                  * ZFEND ENDSR *
3885 C**
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC                                       AR702741
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C     SDGELR        PARM                    SDGELR
      **********                                                                     CGL184 MD050139
      ***Check*if CGL184 is installed.                                               CGL184 MD050139
      **********                                                                     CGL184 MD050139
     C**********         CALLB     'AOSARDR0'                                        CGL184 MD050139
     C**********         PARM      *BLANKS       PRtCd             7                 CGL184 MD050139
     C**********         PARM      '*VERIFY'     POptn             7                 CGL184 MD050139
     C**********         PARM      'CGL184'      PSard             6                 CGL184 MD050139
     C*****SCSARD        PARM      SCSARD        DSFDY                               CGL184 MD050139
      **********                                                                     CGL184 MD050139
     C**********         MOVE      'N'           CGL184            1                 CGL184 MD050139
     C**********         IF        PRtCd = *BLANKS                                   CGL184 MD050139
     C**********         EVAL      CGL184 = 'Y'                                      CGL184 MD050139
     C**********         ENDIF                                                       CGL184 MD050139
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  ZFMD
312831303130313130313031
