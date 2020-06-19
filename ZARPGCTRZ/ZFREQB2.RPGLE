000100200318     H DEBUG
000200200318     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
000300200318      *****************************************************************
000400200318/*STD *  RPGBASEMOD                                                   *
000500200318/*EXI *  TEXT('Calc day num of next pymnt frq from curr dayno')       *
000600200318      *****************************************************************
000700200318      *                                                               *
000800200318      *  Midas - ZFREQB2 ILE Module                                   *
000900200318      *                                                               *
001000200318      *  ZFREQB2                                                       *
001100200318      *                                                               *
001200200318      *  Function: Created to have exactly the same function as       *
001300200318      *            ZFREQB, except that the ZMTH is computed as the    *
001400200318      *            current month instead of next month in ZFREQB      *
001500200318      * Purpose:
001600200318      * ~~~~~~~~
001700200318      *  To calculate the day number of the next payment/statement date
001800200318      *  from current date/day in month and frequency code.
001900200318      *
002000200318      *  Input:
002100200318      *  ~~~~~
002200200318      *
002300200318      *  ZFREQ   -    A one character field containinh the frequency code.
002400200318      *
002500200318      *  ZDAYNO  -    A five digit field containing the base date
002600200318      *               (day number of current payment date.)
002700200318      *
002800200318      *  ZMDAY   -    A two digit field containing the day of the month
002900200318      *               (required only for certain frequencies:
003000200318      *               M R T Q X Y L B) on which payment should fall.
003100200318      *
003200200318      *  ZCCY    -    A three character field containing the currency code.
003300200318      *               For processing to check a working day has been found,
003400200318      *               this currency code is used.
003500200318
003600200318      *  ZLOC    -    A three character field containing the location code.
003700200318      *               This may be left blank if no location is required.
003800200318
003900200318      *  Procedure:
004000200318      *  ~~~~~~~~~
004100200318      *
004200200318      *  1.   ZDAYNO is converted using ZDATE2 into ZMTH, ZYEAR and ZDAY.
004300200318      *
004400200318      *  2.   The required number of days is added to ZDAYNO for any
004500200318      *       frequencies less than one month.
004600200318      *
004700200318      *  3.   For other frequencies, the required number of months/days is
004800200318      *       applied to ZMTH, ZDAY, ZYEAR as appropriate.
004900200318      *
005000200318      *  4.   ZDATE is converted using ZDATE1 into a MIDAS day number.
005100200318      *
005200200318      *  5.   If required, the next working day after that calculated is
005300200318      *       found, using ZCHKH.
005400200318      *
005500200318      *
005600200318      *  Output:
005700200318      *  ~~~~~~
005800200318      *
005900200318      *  ZDAYNO - a five digit field containing the MIDAS day no. for the
006000200318      *           next payment date calculated.
006100200318      *
006200200318      *  RetCodeIn - A 7 character field set to blanks if the module
006300200318      *              runs successfully and 'Error' if an error occurs.
006400200318      * ** +-------The comments from ZFREQBZTXT end  here ----------+ *
006500200318      *                                                               *
006600200318      *  (c) Misys International Banking Systems Ltd. 2001            *
006700200318      *                                                               *
006800200318      *    This source is centrally supported and must ONLY be        *
006900200318      *    amended by Core Development Personnel                      *
007000200318      *                                                               *
007100200318      *    /COPY, Client or Country amendments must not be            *
007200200318      *    applied to this source.                                    *
007300200318      *                                                               *
007400200604      *  Last Amend No. 250822  *CREATE    Date 22MAY20               *
007500200318      *                                                               *
007600200318      *---------------------------------------------------------------*
007700200318      *                                                               *
007800200318      *  250822 - For Freq 'B' and 'L', compute the date for the      *
007900200318      *           current month and not next month.                   *
008000200318      *                                                               *
008100200318      *****************************************************************
008200200318
008300200318      *****************************************************************
008400200318      ** +--------------------------------------+
008500200318      ** ¦ Automatically included D-specs       ¦
008600200318      ** ¦ ==============================       ¦
008700200318      ** +--------------------------------------+
008800200318      **
008900200318      ** Standard D-specs
009000200318      ** ================
009100200318      **
009200200318      ** The following /COPY line includes the LDA layout,
009300200318      ** the copyright array definition,
009400200318      ** and the following named constants:
009500200318      **    True       logical = *on (for indcator processing)
009600200318      **    False      logical = *off (for indcator processing)
009700200318      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
009800200318      **                                    handler)
009900200318      ** and the following variables:
010000200318      **    RunBefore  1A (for the PSSR)
010100200318
010200200318     D/COPY ZACPYSRC,STD_D_SPEC
010300200318
010400200318      ** Include the MM standard declares
010500200318     D/COPY ZACPYSRC,STDDECLARE
010600200318
010700200318      ** Program Status Data Structure
010800200318      ** =============================
010900200318      ** The following /COPY line includes all the defined fields in the
011000200318      ** PSDS.  They have meaningful names, prefixed by 'PS'.
011100200318
011200200318     D/COPY ZACPYSRC,PSDS
011300200318
011400200318      ** +--------------------------------------+
011500200318      ** ¦ End of automatically included D-specs¦
011600200318      ** ¦ =====================================¦
011700200318      ** +--------------------------------------+
011800200318
011900200318      *****************************************************************
012000200318      /EJECT
012100200318      *****************************************************************
012200200318
012300200318      ** +--------------------------------------+
012400200318      ** ¦ Manually included D-specs            ¦
012500200318      ** ¦ =========================            ¦
012600200318      ** +--------------------------------------+
012700200318
012800200318      ** +--------------------------------------+
012900200318      ** ¦ Arrays and Data Structures           ¦
013000200318      ** ¦ ==========================           ¦
013100200318      ** +--------------------------------------+
013200200318
013300200318      ** Date data structure used for calculations in this module
013400200318     D  WrkDateDS      DS             6
013500200318     DZDAY                     1      2  0
013600200318     DZMTH                     3      4  0
013700200318     DZYEAR                    5      6  0
013800200318
013900200318      ** General ledger data structure passed from calling program and to acces program
014000200318     D  SDGELR       E DS                  EXTNAME(SDGELRPD)
014100200318
014200200318      ** Dummy data structure used to pass SDGELR to access program
014300200318     D  DSFDY        E DS                  EXTNAME(DSFDY)
014400200318
014500200318      ** Array containing number of days in month.
014600200318     D  ZFMD           S              2  0 DIM(12) CTDATA PERRCD(12)
014700200318
014800200318      ** +--------------------------------------+
014900200318      ** ¦ Named constants                      ¦
015000200318      ** ¦ ===============                      ¦
015100200318      ** +--------------------------------------+
015200200318
015300200318      ** Rate Change Frequency passed in as parameter from calling program
015400200318     D  ZFREQ          S              1A
015500200318
015600200318      ** MIDAS day number passed in as parameter from calling program
015700200318     D  ZDAYNO         S              5  0
015800200318
015900200318      ** Currency code passed in as parameter from calling program
016000200318     D  ZCCY           S              3A
016100200318
016200200318      ** Rate frequency day passed as parameter from calling program
016300200318     D  ZMDAY          S              2  0
016400200318
016500200318      ** Date format indicator passed as a parameter from calling program.
016600200318     D  BJDFIN         S              1A
016700200318
016800200318      ** Location code passed as a parameter from calling program.
016900200318     D  ZLOC           S              3A
017000200318
017100200318      ** +--------------------------------------+
017200200318      ** ¦ Declared variables                   ¦
017300200318      ** ¦ ==================                   ¦
017400200318      ** +--------------------------------------+
017500200318
017600200318      **  INCREMENTAL or DECREMENTAL variable used in module only
017700200318     D  ZINDE          S              2A
017800200318
017900200318      **  Work field for leap year calculations based on period code. Used only in module
018000200318     D  ZINTO          S              2  0
018100200318
018200200318      **  Date field passed to ZDATE1 to be converted to MIDAS day number.
018300200318     D  ZDATE          S              6A
018400200318
018500200318      **  Error flag passed back as parameter from ZDATE1. Not used in this module.
018600200318     D  ErrorFlag      S              1A
018700200318
018800200318      **  Date field returned from ZDATE2 after conversion from MIDAS day number.
018900200318     D  ZADATE         S              7A
019000200318
019100200318      ** Numerical date format after conversion from MIDAS day number from ZDATE2
019200200318     D  ZNDATE         S              6  0
019300200318
019400200318      ** Work field containing calendar day number from ZADATE
019500200318     D  ZZWRK2         S              2  0
019600200318
019700200318      ** Return code from access programme AOGELRR0
019800200318     D  P@AORC         S              7A
019900200318
020000200318      ** Option passed to access program as a parameter
020100200318     D  P@OPTN         S              7A
020200200318
020300200318      ** Result of dividing ZYEAR by 4 for leap year caluculations
020400200318     D  ZLYR           S              2  0
020500200318
020600200318      ** Work field containg remainder of ZYEAR divided by 4. Use for leap year caluculations
020700200318     D  ZLY            S              1  0
020800200318
020900200318      ** Work field containing day value calculated from days in month array.
021000200318     D  ZWRK2          S              2  0
021100200318
021200200318      ** Day number as numerical field.
021300200318     D  ZINTOT         S              2  0
021400200318
021500200318      ** Day number as character field.
021600200318     D  ZINTOA         S              2A
021700200318
021800200318      ** Holiday indicator pass to module from ZHCHK
021900200318     D  ZIND           S              1A
022000200318
022100200318      ** +--------------------------------------+
022200200318      ** ¦ End of D-specs                       ¦
022300200318      ** ¦ ==============                       ¦
022400200318      ** +--------------------------------------+
022500200318      *****************************************************************
022600200318      /EJECT
022700200318      *****************************************************************
022800200318
022900200318     C
023000200318      ** +--- Start of Main processing -----------------------------------+
023100200318      ** ¦                                                                ¦
023200200318      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
023300200318      ** ¦ executed at program activation.                                ¦
023400200318      ** ¦                                                                ¦
023500200318      ** +----------------------------------------------------------------+
023600200318
023700200318     C                   EVAL      ErrorFound = 'N'
023800200318
023900200318     C     BJDFIN        IFEQ      'D'
024000200318     C                   MOVE      *OFF          *IN98
024100200318     C                   ELSE
024200200318     C                   MOVE      *ON           *IN98
024300200318     C                   ENDIF
024400200318
024500200318     C                   EXSR      @FREQB
024600200318     C                   IF        ErrorFound = 'Y'
024700200318     C                   EVAL      RetCodeIn = 'Error'
024800200318     C                   ENDIF
024900200318
025000200318
025100200318     C                   RETURN
025200200318     C
025300200318     C
025400200318      *-----------------Start of modified subroutine ZFREQB----------------*--------*
0255002003183661 C*****      ZFREQB    BEGSR                           *** ZFREQB *** S01195
0256002003183661 C     @FREQB        BEGSR
0257002003183662 C**
0258002003183663 C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
0259002003183664 C                   MOVE      ZFREQ         ZFREQ             1
0260002003183665 C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
0261002003183666 C                   Z-ADD     ZMDAY         ZMDAY             2 0
0262002003183667 C                   MOVE      ZCCY          ZCCY              3
026300200318     C                   MOVE      ZCCY          ZCCY
026400200318     C                   MOVE      *BLANKS       ErrorFound
0265002003183674 C                   MOVE      '  '          ZINDE             2
0266002003183675 C                   Z-ADD     0             ZINTO             2 0
0267002003183676 C**
0268002003183677 C**   CONVERT DAY NUMBER TO DATE and places them into WRKDATEDS
0269002003183678 C                   CALLB     'ZDATE2'
027000200318     C                   PARM                    ZDAYNO
027100200318     C                   PARM                    BJDFIN
027200200318     C                   PARM                    ZNDATE
027300200318     C                   PARM                    ZADATE
027400200318     C                   MOVEL     ZNDATE        WRKDATEDS
027500200318
027600200318      **If the day number input (ZMDAY) is zero set it equal to the day
027700200318      **number of the start day.
027800200318
027900200318     C     ZMDAY         IFEQ      0
028000200318     C                   MOVEL     ZADATE        ZZWRK2
028100200318     C                   MOVE      ZZWRK2        ZMDAY
028200200318     C                   ENDIF
028300200318     C                   MOVE      *OFF          *IN90
0284002003183680 C**
0285002003183681 C**   CHECK FOR AND INCREMENT FOR CODE D-DAILY-WORKING DAY.
0286002003183682 C     ZFREQ         IFEQ      'D'
0287002003183683 C     ZDAYNO        ADD       1             ZDAYNO
028800200318     C                   GOTO      ZFHCHK
028900200318     C                   ENDIF
0290002003183685 C**
0291002003183686 C**   CHECK FOR AND INCREMENT FOR CODE W-WEEKLY.
0292002003183687 C     ZFREQ         IFEQ      'W'
0293002003183688 C     ZDAYNO        ADD       7             ZDAYNO
0294002003183689 C                   GOTO      ZFEND
029500200318     C                   ENDIF
0296002003183690 C**
0297002003183691 C**   CHECK FOR AND INCREMENT FOR CODE F-FORTNIGHTLY.
0298002003183692 C     ZFREQ         IFEQ      'F'
0299002003183693 C     ZDAYNO        ADD       14            ZDAYNO
0300002003183694 C                   GOTO      ZFEND
030100200318     C                   ENDIF
0302002003183695 C**
0303002003183696 C**   CHECK FOR AND INCREMENT FOR CODE S-SEMI-MONTHLY.
0304002003183697 C     ZFREQ         IFEQ      'S'
0305002003183698 C     ZDAY          IFLE      15
0306002003183699 C                   Z-ADD     31            ZDAY
030700200318     C                   ELSE
0308002003183700 C                   Z-ADD     15            ZDAY
0309002003183701 C     ZMTH          ADD       1             ZMTH
031000200318     C                   ENDIF
031100200318     C                   ENDIF
0312002003183703 C**
0313002003183704 C**   CHECK FOR AND INCREMENT FOR CODE M-MONTHLY.
0314002003183705 C     ZFREQ         IFEQ      'M'
0315002003183706 C                   MOVE      'IN'          ZINDE
031600200318     C**
031700200318     C**   IF ZMDAY IS 31 AND ZDAY 25, NO USE TO INCREMENT ZMTH
031800200318     C     ZMDAY         IFLE      ZDAY
031900200318     C     ZMTH          ADD       1             ZMTH
032000200318     C                   ENDIF
0321002003183707 C                   Z-ADD     ZMDAY         ZDAY
032200200318     C                   ENDIF
0323002003183710 C**
0324002003183711 C**   CHECK FOR AND INCREMENT FOR CODE R-SIX DAYS BEFORE END OF MONTH
0325002003183712 C     ZFREQ         IFEQ      'R'
0326002003183713 C                   Z-ADD     31            ZDAY
0327002003183714 C     ZMTH          ADD       1             ZMTH
0328002003183715 C                   ENDIF
0329002003183716 C**
0330002003183717 C**   CHECK FOR AND INCREMENT FOR CODE T-BIMONTHLY.
0331002003183718 C     ZFREQ         IFEQ      'T'
0332002003183719 C                   MOVE      'IN'          ZINDE
0333002003183720 C                   Z-ADD     ZMDAY         ZDAY
0334002003183721 C     ZMTH          ADD       2             ZMTH
0335002003183722 C                   ENDIF
0336002003183723 C**
0337002003183724 C**   CHECK FOR AND INCREMENT FOR CODE Q-QUARTERLY.
0338002003183725 C     ZFREQ         IFEQ      'Q'
0339002003183726 C                   MOVE      'IN'          ZINDE
0340002003183727 C                   Z-ADD     ZMDAY         ZDAY
0341002003183728 C     ZMTH          ADD       3             ZMTH
0342002003183729 C                   ENDIF
0343002003183730 C**
0344002003183731 C**   CHECK FOR AND INCREMENT FOR CODE X-SIX MONTHLY.
0345002003183732 C     ZFREQ         IFEQ      'X'
0346002003183733 C                   MOVE      'IN'          ZINDE
0347002003183734 C                   Z-ADD     ZMDAY         ZDAY
0348002003183735 C     ZMTH          ADD       6             ZMTH
0349002003183736 C                   ENDIF
0350002003183737 C**
0351002003183738 C**   CHECK FOR AND INCREMENT FOR CODE Y-YEARLY.
0352002003183739 C     ZFREQ         IFEQ      'Y'
0353002003183740 C                   MOVE      'IN'          ZINDE
0354002003183734 C                   Z-ADD     ZMDAY         ZDAY
0355002003183741 C     ZYEAR         ADD       1             ZYEAR
0356002003183742 C                   ENDIF
0357002003183743 C**
0358002003183744 C**   CHECK FOR AND INCREMENT FOR CODE L-LAST CALENDAR DAY OF MONTH.
0359002003183745 C     ZFREQ         IFEQ      'L'
0360002003183746 C                   Z-ADD     31            ZDAY
0361002003183748 C                   ENDIF
0362002003183749 C*
0363002003183750 C**   CHECK FOR AND INCREMENT FOR CODE B-LAST WORKING DAY OF MONTH.
0364002003183751 C     ZFREQ         IFEQ      'B'
0365002003183752 C                   Z-ADD     31            ZDAY
0366002003183754 C                   ENDIF
0367002003183755 C**
0368002003183756 C**   CHECK FOR AND INCREMENT FOR CODE A-MONTHLY ACCRUAL/PROFIT DATE.
0369002003183757 C     ZFREQ         IFEQ      'A'
037000200318     C                   CALLB     'AOGELRR0'
037100200318     C                   PARM      *BLANK        P@AORC            7
037200200318     C                   PARM      '*FIRST'      P@OPTN            7
037300200318     C     SDGELR        PARM      *BLANK        DSFDY
037400200318
037500200318     C     P@AORC        IFEQ      *BLANK
037600200318     C                   Z-ADD     BKAPDT        ZDAYNO
037700200318     C                   ELSE
037800200318     C                   MOVEL     'Y'           ErrorFound
037900200318     C                   ENDIF
038000200318
0381002003183763 C**
0382002003183764 C**   BYPASS IF ZFREQ IS 'A' OR ANY OTHER VALUE
0383002003183765 C                   GOTO      ZFEND
038400200318     C                   ENDIF
0385002003183766 C**
0386002003183767 C**
0387002003183768 C**   REFORMAT DATE AND ENSURE VALID.
038800200318      **
0389002003183771 C**   VALIDATE MONTH.
0390002003183772 C     ZMTH          IFGT      12
0391002003183773 C     ZMTH          SUB       12            ZMTH
0392002003183774 C     ZYEAR         ADD       1             ZYEAR
039300200318     C                   ENDIF
0394002003183775 C**
0395002003183776 C**   CHECK FOR LEAP YEAR.
0396002003183777 C     ZYEAR         DIV       4             ZLYR              2 0
0397002003183778 C                   MVR                     ZLY               1 0
0398002003183779 C**
0399002003183780 C**   VALIDATE DAY NUMBER.
0400002003183781 C                   MOVE      ZFMD(ZMTH)    ZWRK2             2 0
0401002003183782 C     ZMTH          IFEQ      2
040200200318     C     ZLY           ANDEQ     0
0403002003183783 C                   Z-ADD     29            ZWRK2
040400200318     C                   ENDIF
0405002003183784 C**
0406002003183785 C     ZDAY          IFGT      ZWRK2
0407002003183786 C                   Z-ADD     ZWRK2         ZDAY
040800200318     C                   ENDIF
0409002003183787 C**
0410002003183788 C**   CHECK IF CODE R, TO SUBTRACT 6 DAYS.
0411002003183789 C     ZFREQ         IFEQ      'R'
0412002003183790 C     ZDAY          SUB       6             ZDAY
041300200318     C                   ENDIF
0414002003183791 C**
0415002003183792 C**   REFORMAT DATE, DDMMYY OR MMDDYY, AND CONVERT TO DAY NUMBER.
041600200318     C     *IN98         IFEQ      *OFF
041700200318     C                   MOVEL     ZDAY          ZWRK4             4 0
0418002003183794 C                   MOVE      ZMTH          ZWRK4
041900200318     C                   ELSE
0420002003183795 C                   MOVEL     ZMTH          ZWRK4
0421002003183796 C                   MOVE      ZDAY          ZWRK4
042200200318     C                   ENDIF
0423002003183797 C                   MOVEL     ZWRK4         ZDATE
0424002003183798 C                   MOVE      ZYEAR         ZDATE
042500200318
0426002003183799 C                   CALLB     'ZDATE1'
042700200318     C                   PARM                    ZDATE
042800200318     C                   PARM                    ZDAYNO
042900200318     C                   PARM                    BJDFIN
043000200318     C                   PARM                    ErrorFlag
0431002003183800 C**
0432002003183801 C**   CHECK IF CODE B, OR M,T,Q,X,Y TO BE CHECKED FOR HOLIDAY.
043300200318     C     ZFREQ         IFEQ      'B'
043400200318     C     ErrorFlag     ANDEQ     'N'
043500200318     C                   GOTO      ZFHCHK
043600200318     C                   ENDIF
0437002003183806 C**
0438002003183807 C                   GOTO      ZFEND
0439002003183808 C**
0440002003183809 C**   CHECK IF DAY NUMBER IS A HOLIDAY.
0441002003183810 C**
0442002003183811 C     ZFHCHK        TAG                                                    ** ZFHCHK TAG *
044300200318     C     ZFREQ         IFEQ      'D'
044400200318     C     ZFREQ         OREQ      'B'
044500200318     C                   GOTO      ZSETK
044600200318     C                   ENDIF
0447002003183817 C*
0448002003183818 C*   FOR CODES M,T,Q,X,Y, CHECK ZINDE - 'IN' TO INCREMENT,
0449002003183819 C*                                    - 'DE' TO DECREMENT
0450002003183820 C*
045100200318
0452002003183826 C     ZSETK         TAG                                                    ** ZSETK TAG **
0453002003183849 C*
045400200318     C                   CALLB     'ZCHKH'
045500200318     C                   PARM                    ZDAYNO
045600200318     C                   PARM                    ZCCY
045700200318     C                   PARM                    ZLOC
045800200318     C                   PARM                    ZIND
045900200318     C*
046000200318     C     ZIND          IFEQ      'W'
046100200318     C                   GOTO      ZFEND
046200200318     C                   ENDIF
046300200318     C     ZINDE         IFEQ      'DE'
0464002003183862 C                   GOTO      ZDECR
046500200318     C                   ENDIF
0466002003183863 C*
0467002003183864 C**   INCREMENT OR DECREMENT DAY NUMBER AS REQUIRED.
046800200318     C     ZINDE         IFEQ      'IN'
046900200318     C     ZFREQ         OREQ      'D'
047000200318     C     ZDAYNO        ADD       1             ZDAYNO
047100200318     C                   ENDIF
0472002003183866 C*
0473002003183867 C*    ONLY FOR PERIOD CODE = M,T,Q,X OR Y, IF INCREMENTATION
0474002003183868 C*    TAKES THE OUTPUT DATE INTO THE FOLLOWING MONTH, RETURN TO
0475002003183869 C*    THE INPUT DATE AND DECREMENT - 92 ON.
0476002003183870 C*
047700200318     C     ZINDE         IFEQ      'IN'
047800200318     C     ZINTO         ADD       1             ZINTO
047900200318     C     ZINTO         ADD       ZDAY          ZINTOT            2 0
048000200318     C                   MOVE      ZINTOT        ZINTOA
048100200318      ** TO allow 29 Feb on leapyears to pass
048200200318     C     ZYEAR         DIV       4             ZLYR
048300200318     C                   MVR                     ZLY
048400200318     C     ZLY           IFEQ      0
048500200318     C     ZMTH          ANDEQ     2
048600200318     C     ZINTOA        ANDLT     '29'
048700200318     C     ZDAYNO        SUB       ZINTO         ZDAYNO
048800200318     C                   MOVE      'DE'          ZINDE
048900200318     C                   ENDIF
049000200318     C     ZLY           IFEQ      0
049100200318     C     ZMTH          ANDNE     2
049200200318     C     ZINTOT        ANDLT     ZFMD(ZMTH)
049300200318     C     ZDAYNO        SUB       ZINTO         ZDAYNO
049400200318     C                   MOVE      'DE'          ZINDE
049500200318     C                   ENDIF
049600200318     C                   ENDIF
0497002003183877 c**
0498002003183878 C     ZDECR         TAG                                                    ** ZDECR TAG **
049900200318     C     ZINDE         IFEQ      'DE'
050000200318     C     ZFREQ         OREQ      'B'
050100200318     C     ZDAYNO        SUB       1             ZDAYNO
050200200318     C                   ENDIF
050300200318      *
050400200318     C                   GOTO      ZFHCHK
0505002003183882 C**
0506002003183883 C**
0507002003183884 C     ZFEND         ENDSR                                                  * ZFEND ENDSR *
0508002003183885 C**
050900200318
051000200318
051100200318      *****************************************************************
051200200318      /EJECT
051300200318      *****************************************************************
051400200318      *                                                               *
051500200318      * *INZSR - Program Initialisation routine                       *
051600200318      *                                                               *
051700200318      * Called by: Implicitly on program activation                   *
051800200318      *                                                               *
051900200318      * Calls: None                                                   *
052000200318      *                                                               *
052100200318      *****************************************************************
052200200318
052300200318     C     *INZSR        BEGSR
052400200318
052500200318     C     *entry        PLIST
052600200318     C                   PARM                    RetCodeIn
052700200318     C                   PARM                    ZFREQ
052800200318     C                   PARM                    ZDAYNO
052900200318     C                   PARM                    ZCCY
053000200318     C                   PARM                    ZMDAY
053100200318     C                   PARM                    BJDFIN
053200200318     C     SDGELR        PARM                    SDGELR
053300200318
053400200318      ** Program, module and procedure names for database error processing.
053500200318      ** =================================================================
053600200318      ** The following /COPY sets these values
053700200318
053800200318     C/COPY ZACPYSRC,DBFIELDS
053900200318
054000200318     C                   ENDSR
054100200318
054200200318      *****************************************************************
054300200318      /EJECT
054400200318      *****************************************************************
054500200318     C/COPY ZACPYSRC,PSSR_ILE
054600200318      ********************************************************************
054700200318**  CPY@
054800200318(c) Misys International Banking Systems Ltd. 2008
054900200318**  ZFMD
055000200318312831303130313130313031
