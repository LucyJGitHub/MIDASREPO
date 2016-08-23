     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Determine working day for formula')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFDATE - Determine correct working day for a formula         *
      *           specified for each market/instrument/type/month/    *
      *           year.                                               *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the FFDATE        *
      *  subroutine.  The subroutine consists of 4 /COPY members.     *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).  The   *
      *  existing code has not been changed except to remove dead     *
      *  lines, and the boundaries of the original /COPY members have *
      *  been marked, to facilitate future maintenance of both the    *
      *  old members and this one.  If this member has to change, the *
      *  change should ALMOST CERTAINLY be implemented by changing    *
      *  the old /COPY member, reconverting it using CVTRPGSRC, and   *
      *  copying it into this member, replacing the existing section. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Last Amend No. 164573             Date 16Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  164573 - FF exchange traded and OTC trades inputs fail.      *
      *           (ZFWDT used is in TISRVPGM)                         *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
      ** +--- The converted FFDATEZ1 starts here --------------------------+
 
     D TABDY           S              1    DIM(7) CTDATA PERRCD(7)
     D TABNO           S              1  0 DIM(7) ALT(TABDY)
      **  ARRAY FOR SR FFDATE
 
      ** +--- The converted FFDATEZ1 ends here ----------------------------+
     D FFDATC          DS
      **   DATA STRUCTURE FOR SR. FFDATE TO DEFINE WORK FIELDS
     D  FFAA                   1      1
     D  FFAB                   1      2
     D  FFB                    2      2
     D  FFC                    3      3
     D  FFDEA                  4      5
     D  FFDEF                  4      6
     D  FFF                    6      6
     D  FFG                    7      7
 
      ** +--- The converted FFDATEZ2 starts here --------------------------+
 
 
      ** +--- The converted FFDATEZ2 ends here ----------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Date format indicator
     D BJDFIN          S              1A
 
      ** Error flag from ZDATE1 module
     D ErrorFlag       S              1A
 
      ** Currency
     D ZCCY            S              3A
 
      ** Date
     D ZDATE           S              6A
 
      ** Midas day number
     D ZDAYNO          S              5P 0
     D ZDYNBR          S                   LIKE(ZDAYNO)
 
      ** Holiday indicator
     D ZIND            S              1A
 
      ** Location code
     D ZLOC            S              3A
 
      ** Number of days
     D ZNRDYS          S              2P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Set the date format indicator used by the subroutine, based on
      ** the flag received.
     C                   IF        BJDFIN = 'D'
     C                   EVAL      *in98 = False
     C                   ELSE
     C                   EVAL      *in98 = True
     C                   ENDIF
 
     C                   EXSR      FFDATE
 
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- The converted FFDATEZ3 starts here --------------------------+
 
      *****************************************************************
      *                                                               *
      *  FFDATE SR.   TO DETERMINE THE CORRECT WORKING DAY AS A MIDAS *
      *               DAY NUMBER FOR A FORMULA SPECIFIED FOR EACH     *
      *               MARKET/INSTRUMENT TYPE/YEAR/MONTH               *
      *                                                               *
      *   INPUT   : FFDATC   DATE FORMULA           FORMAT (7A)       *
      *             FFMTH    MONTH OF REQD. DATE    FORMAT (2N)       *
      *             FFYR     YEAR OF REQD. DATE     FORMAT (2N)       *
      *             FFCCY1   MARKET CURRENCY        FORMAT (3A)       *
      *             FFLOC    MARKET LOCATION        FORMAT (3A)       *   S01195
      *             FFCCY2   INSTRUMENT CURRENCY    FORMAT (3A)       *
      *             FFCCY3   OTHER CURRENCY         FORMAT (3A)       *
      *                                                               *
      *   OUTPUT  : FFDAY    WORKING DAY DEFINED                      *
      *                      BY INPUT FIELDS        FORMAT (5N)       *
      *                                                               *
      *   SUBROUTINES USED:                                           *
      *                                                               *
      *             FFDE31   CALC LAST WORKING DAY IN MONTH           *
      *             FFDN31   CALC SPECIFIED WORKING DAY IN MONTH      *
      *             FFDAAD   ADJUST DAY WITH AN ACTUAL NO. OF DAYS    *
      *             FFDABD   ADJUST DAY WITH NO. OF BUSINESS DAYS IN  *
      *                      MARKET CENTRE CCY                        *
      *             FFDACD   ADJUST DAY WITH NO. OF BUSINESS DAYS IN  *
      *                      MARKET CENTRE CCY & INST CCY & OTHER CCY *
      *             FFDAWD   ADJUST DAY WITH BY 1 BUSINESS DAY IN     *
      *                      MARKET CENTRE CCY IF NOT A WORKING DAY   *
      *             ZCHKH    DETERMINE WHETHER CCY PASSED IS A WORKING*   S01195
      *                      DAY FOR THE LAST DAY OUPUT BY ZFWDT/ZBKDT*   S01195
      *                      IN THE SPECIFIED LOCATION.               *   S01195
      *                                                               *
      *             ZDATE1   CONVERT A DATE TO A NO. OF DAYS          *
      *             ZFWDT    DETERMINE WHETHER A DAY IS A WORKING DAY *   S01195
      *                      IN THE SPECIFIED LOCATION;               *   S01195
      *                      & FIND THE NEXT WORKING DAY IF IT IS NOT *   S01195
      *             ZBKDT    DETERMINE WHETHER A DAY IS A WORKING DAY *   S01195
      *                      IN THE SPECIFIED LOCATION;               *   S01195
      *                      & FIND THE PREV WORKING DAY IF IT IS NOT *   S01195
      *                                                               *
      *                                                               *
      *                                                               *
      * NB. THE DATE FORMULA COMPRISES:       ABCDEFG       WHERE     *
      *                                       -------                 *
      *  AB  =  BASE DATE.   =  a) DAY NO. IN MONTH                   *
      *                   OR =  b) WEEK NO. AND DAY CODE              *
      *                   OR =  c) LAST WORKING DAY IN MONTH  ("31")  *
      *                                                               *
      *  CDEFG = ADJUSTMENT                                           *
      *                                                               *
      *          IF NO ADJUSTMENT (DEFG = *BLANKS) AND BASE DATE IS   *
      *          a) OR b) ABOVE,                                      *
      *                                                               *
      *  C  =    "+"/"-" FOR NEXT/PREVIOUS WORKING DAY IF HOLIDAY     *
      *                                                               *
      *          OTHERWISE, IF ADJUSTMENT SPECIFIED:                  *
      *                                                               *
      *  C  =    "+"/"-" NUMBER OF DAYS FORWARDS/BACKWARDS            *
      *                                                               *
      *  DE =    NUMBER OF DAYS                                       *
      *                                                               *
      *  F  =    TYPE OF DAYS TO BE COUNTED                           *
      *                     "A" = ACTUAL DAYS                         *
      *                     "B" = BUSINESS DAYS IN CCY1               *
      *                     "C" = BUSINESS DAYS IN CCY1,CCY2 & CCY3   *
      *                                                               *
      *  G  =    "+"/"-" FOR NEXT/PREVIOUS WORKING DAY IF DAY FROM    *
      *          F IS A HOLIDAY  ( TYPE "A" ONLY )                    *
      *                                                               *
      *****************************************************************
 
     C     FFDATE        BEGSR                                                  ***FFDATE****
 
 
      **   DEFINE/INITIALISE FIELDS
 
     C                   MOVE      FFDATC        FFDATC            7
     C                   Z-ADD     FFMTH         FFMTH             2 0
     C                   Z-ADD     FFYR          FFYR              2 0
     C                   MOVE      FFCCY1        FFCCY1            3
     C                   MOVE      FFLOC         FFLOC             3                           S0119
     C                   MOVE      FFCCY2        FFCCY2            3
     C                   MOVE      FFCCY3        FFCCY3            3
 
     C                   Z-ADD     0             FFDAY             5 0
 
     C     *LIKE         DEFINE    FFMTH         FFTM
     C     *LIKE         DEFINE    FFYR          FFYRW
     C     *LIKE         DEFINE    FFDAY         DUMP
     C     *LIKE         DEFINE    FFDAY         FFMDY
     C     *LIKE         DEFINE    FFDAY         FFMDY1
     C     *LIKE         DEFINE    FFDAY         FFMDY2
     C     *LIKE         DEFINE    FFDAY         FFMDY3
 
      **  FIND DAY IN MONTH
      **  IF '31' SPECIFIED, FIND LAST WORKING DAY IN MONTH
      **  OTHERWISE FIND THE DAY SPECIFIED BY THE DAY NO. OR DAY CODE
 
     C     FFAB          CASEQ     '31'          FFDE31
     C     FFAB          CASNE     '31'          FFDN31
     C                   END
 
      *    CALCULATE ADJUSTMENTS SPECIFIED TO DATE
 
      **   ADJUSTMENTS TO DATE NEED TO BE MADE IF
      **   1.  A DAY NO. OR CODE WAS SPECIFIED ( AS THIS DAY MAY BE A
      **       HOLIDAY OR AN ADJUSTMENT MAY HAVE BEEN SPECIFIED )
      **   OR
      **   2.  ' MONTH END ' WAS SPECIFIED ( WHICH WILL BE A WORKING
      **       DAY ) AND AN ADJUSTMENT HAS BEEN SPECIFIED
 
     C     FFAB          IFNE      '31'
     C     FFAB          OREQ      '31'
     C     FFDEF         ANDNE     *BLANKS
 
      **   DETERMINE NO. OF DAYS FORWARDS/BACKWARDS DEPENDING ON CODE
      **            I.E. 'A' = ACTUAL DAYS
      **            I.E. 'B' = BUSINESS DAYS - MARKET CENTRE CCY
      **            I.E. 'C' = BUSINESS DAYS - MKT. CENTRE & INST. CCY
      **            I.E. ' ' = NO ADJUSTMENT
      **   NB  RESULT WILL BE A WORKING DAY
      **       ( BEFORE/AFTER DAY GIVEN IF HOLIDAY - DEP. IF +/- CODE )
 
     C     FFDEF         IFNE      *BLANK
     C                   MOVE      FFDEA         FFDE              2 0
     C                   ELSE
     C                   Z-ADD     *ZERO         FFDE
     C                   END
 
     C     FFF           CASEQ     'A'           FFDAAD
     C     FFF           CASEQ     'B'           FFDABD
     C     FFF           CASEQ     'C'           FFDACD
     C     FFF           CASEQ     ' '           FFDAWD
     C                   END
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  FFDE31 SR.   CALLED FROM STANDARD SUBROUTINE FFDATE          *
      *               CALCULATE LAST WORKING DAY IN MONTH             *
      *                                                               *
      *****************************************************************
 
     C     FFDE31        BEGSR                                                  ****FFDE31***
 
 
      **   DETERMINE MONTH NUMBER FOR NEXT MONTH
 
 
      **   IF NOT DECEMBER
 
     C     FFMTH         IFNE      12
     C     FFMTH         ADD       1             FFTM
     C                   Z-ADD     FFYR          FFYRW
 
      **   IF DECEMBER
 
     C                   ELSE
     C                   Z-ADD     1             FFTM
     C     FFYR          ADD       1             FFYRW
     C                   END
 
      **   DETERMINE MIDAS DAY NUMBER FOR 1ST OF NEXT MONTH
 
     C     *IN98         IFEQ      '1'
     C                   MOVE      '01'          FFWRK4            4 0
     C                   MOVEL     FFTM          FFWRK4
     C                   ELSE
     C                   MOVE      FFTM          FFWRK4
     C                   MOVEL     '01'          FFWRK4
     C                   END
 
     C                   MOVE      FFYRW         ZDATE
     C                   MOVEL     FFWRK4        ZDATE
 
     C                   EXSR      ZDATE1
 
     C                   Z-ADD     ZDAYNO        FFDAY
 
      **   SUBTRACT 1 TO GET LAST DAY OF MONTH REQUIRED
 
     C                   SUB       1             FFDAY
 
      **   IF THIS IS NOT A WORKING DAY, FIND LAST WORKING DAY IN MONTH
      **   IN THE MARKET CURRENCY
 
     C                   MOVE      FFDAY         ZDAYNO
     C                   Z-ADD     0             ZNRDYS                                        S0119
     C                   MOVE      FFCCY1        ZCCY
     C                   MOVE      FFLOC         ZLOC                                          S0119
     C                   EXSR      ZBKDT                                                       S0119
 
     C                   Z-ADD     ZDYNBR        FFDAY
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  FFDN31 SR.   CALLED FROM STANDARD SUBROUTINE FFDATE          *
      *               CALCULATE THE SPECIFIED DAY IN MONTH            *
      *                                                               *
      *****************************************************************
 
     C     FFDN31        BEGSR                                                  ****FFDN31***
 
 
      **  CONVERT THE FIRST TWO CHARACTERS
 
 
      **  DETERMINE MIDAS DATE FOR 1ST OF MONTH
 
 
     C     *IN98         IFEQ      '1'
     C                   MOVEL     FFMTH         FFWRK4
     C                   MOVE      '01'          FFWRK4
     C                   ELSE
     C                   MOVE      FFMTH         FFWRK4
     C                   MOVEL     '01'          FFWRK4
     C                   END
 
     C                   MOVEL     FFWRK4        ZDATE
     C                   MOVE      FFYR          ZDATE
 
     C                   EXSR      ZDATE1
 
     C                   Z-ADD     ZDAYNO        FFDAY
 
 
 
      **    DETERMINE WHETHER FIRST TWO CHARACTERS ARE DAY NO.OR
      **    DAY CODE
 
 
     C     FFB           LOOKUP    TABDY         TABNO                    81
 
      **    IF FIRST TWO CHARACTERS ARE DAY CODE
 
     C     *IN81         IFEQ      '1'
 
 
      **  DETERMINE DAY IN THE WEEK FOR THE 1ST OF THE MONTH FOR A
      **  GIVEN MIDAS DATE.
      **  ( THIS METHOD IS BASED ON THE FACT THAT THE DAY OF MIDAS DAY
      **  1 - 01/01/72 - IS KNOWN.  SEE SD1050 )
 
     C     FFDAY         DIV       7             DUMP
     C                   MVR                     FFDAYY            1 0
 
      **  DETERMINE THE NO. OF DAYS AFTER 1ST OF MONTH AND IT'S
      **     MIDAS DATE
 
     C                   Z-ADD     TABNO         FFDAYW            1 0
     C     FFDAYW        SUB       FFDAYY        FFDAYZ            1 0  82
     C   82              ADD       7             FFDAYZ
     C                   ADD       FFDAYZ        FFDAY
     C                   MOVE      FFAA          FFA               1 0
     C     2             DO        FFA
     C     FFDAY         ADD       7             FFDAY
     C                   END
 
     C                   ELSE
 
 
      **    IF FIRST TWO CHARACTERS ARE  NO. OF DAYS
 
 
      **    ADD NO. OF DAYS TO MIDAS DAY NO. OF FIRST DAY OF MONTH
 
     C                   MOVE      FFAB          FFABN             2 0
     C                   SUB       1             FFABN
     C                   ADD       FFABN         FFDAY
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  FFDAAD SR.   CALLED FROM STANDARD SUBROUTINE FFDATE          *
      *               TO ADJUST DAY WITH SPECIFIED NO. OF ACTUAL      *
      *               DAYS                                            *
      *                                                               *
      *****************************************************************
 
     C     FFDAAD        BEGSR
 
 
      **   ADD/SUBTRACT SPECIFIED NO. OF DAYS AS REQUIRED
 
     C     FFC           IFEQ      '+'
     C                   ADD       FFDE          FFDAY
     C                   ELSE
     C                   SUB       FFDE          FFDAY
     C                   END
 
      **   SET UP NO. OF DAYS AND LOCATION FOR ZFWDT/ZBKDT
 
     C                   Z-ADD     0             ZNRDYS
     C                   MOVE      FFLOC         ZLOC
 
      **   IF FFDAY IS HOLIDAY DETERMINE NEXT/PREVIOUS  WORKING DAY
 
     C     FFG           IFEQ      '+'
 
      **   IF HOLIDAY, DETERMINE NEXT WORKING DAY
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY1        ZCCY
     C                   EXSR      ZFWDT                                                       S0119
 
     C                   Z-ADD     ZDYNBR        FFDAY
 
     C                   ELSE
 
      **   IF HOLIDAY, DETERMINE PREVIOUS WORKING DAY
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY1        ZCCY
     C                   EXSR      ZBKDT                                                       S0119
 
     C                   Z-ADD     ZDYNBR        FFDAY
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  FFDABD SR.   CALLED FROM STANDARD SUBROUTINE FFDATE          *
      *               TO ADJUST DAY WITH SPECIFIED NO. OF BUSINESS    *
      *               DAYS FOR THE MARKET CENTRE                      *
      *                                                               *
      *****************************************************************
 
     C     FFDABD        BEGSR
 
      **   SET UP LOCATION FOR ZFWDT/ZBKDT
 
     C                   MOVE      FFLOC         ZLOC
 
 
      **   ADD/SUBTRACT SPECIFIED NO. OF DAYS AS REQUIRED
 
     C     FFC           IFEQ      '+'
 
      **   CALCULATE LIMIT FFDE WORKING DAYS AFTER DATE
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY1        ZCCY
     C                   Z-ADD     FFDE          ZNRDYS
     C                   EXSR      ZFWDT
 
     C                   Z-ADD     ZDYNBR        FFDAY
 
     C                   ELSE
 
      **   CALCULATE LIMIT FFDE WORKING DAYS BEFORE DATE
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY1        ZCCY
     C                   Z-ADD     FFDE          ZNRDYS
     C                   EXSR      ZBKDT                                                       S0119
 
     C                   Z-ADD     ZDYNBR        FFDAY
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  FFDACD SR.   CALLED FROM STANDARD SUBROUTINE FFDATE          *
      *               TO ADJUST DAY WITH SPECIFIED NO. OF BUSINESS    *
      *               DAYS IN CCY OF MARKET CENTRE & INSTRUMENT &     *
      *               ANY OTHER CCY                                   *
      *                                                               *
      *****************************************************************
 
     C     FFDACD        BEGSR
 
 
      **   DETERMINE SPECIFIED NEXT/PREVIOUS WORKING DAYS IN ALL CCYS
 
     C     FFC           IFEQ      '+'
 
 
      **   DETERMINE NEXT FFDE WORKING DAYS
 
      **   CALCULATE LIMIT FFDE WORKING DAYS AFTER DATE,IN CCY1
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY1        ZCCY
     C                   MOVE      FFLOC         ZLOC
     C                   Z-ADD     FFDE          ZNRDYS
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        FFMDY1
 
      **   CALCULATE LIMIT FFDE WORKING DAYS AFTER DATE,IN CCY2
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY2        ZCCY
     C                   MOVE      *BLANK        ZLOC                                          S0119
     C                   Z-ADD     FFDE          ZNRDYS
     C                   EXSR      ZFWDT                                                       S0119
     C                   Z-ADD     ZDYNBR        FFMDY2
 
      **   CALCULATE LIMIT FFDE WORKING DAYS AFTER DATE,IN CCY3
      **   IF PRESENT
 
     C     FFCCY3        IFNE      ' '
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY3        ZCCY
     C                   MOVE      *BLANK        ZLOC                                          S0119
     C                   Z-ADD     FFDE          ZNRDYS
     C                   EXSR      ZFWDT                                                       S0119
     C                   Z-ADD     ZDYNBR        FFMDY3
     C                   END
 
      **   TO FIND THE EARLIEST DAY ( TODAY OR LATER ) WHICH IS A
      **   WORKING DAY IN ALL CURRENCIES, FIRST FIND THE LATEST OF
      **   ALL THE DATES
 
     C     FFMDY1        IFGT      FFMDY2
     C                   Z-ADD     FFMDY1        FFMDY
     C                   ELSE
     C                   Z-ADD     FFMDY2        FFMDY
     C                   END
     C     FFCCY3        IFNE      *BLANKS
     C     FFMDY3        ANDGT     FFMDY
     C                   Z-ADD     FFMDY3        FFMDY
     C                   END
 
      **   CHECK IF FFMDY IS WORKING DAY IN ALL CURRENCIES
 
     C                   Z-ADD     FFMDY         ZDYNBR
 
     C                   MOVE      'N'           HOLF              1
 
      **   CONTINUE WHILE THE DATE IS A HOLIDAY IN ANY CCY
 
     C     HOLF          DOWEQ     'N'
 
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     0             ZNRDYS                                        S0119
 
      **   FIND NEXT WORKING DAY IN CCY1
 
     C                   MOVE      FFCCY1        ZCCY
     C                   MOVE      FFLOC         ZLOC                                          S0119
     C                   EXSR      ZFWDT                                                       S0119
 
      **   CHECK IF THIS DATE IS A HOLIDAY IN CCY2
 
     C                   MOVE      FFCCY2        ZCCY                                          S0119
     C                   MOVE      *BLANK        ZLOC                                          S0119
 
     C                   EXSR      ZCHKH                                                       S0119
 
      **   IF CCY2 A HOLIDAY,INCREMENT DAY AND REPEAT FROM CCY1 CHECK
 
     C     ZIND          IFEQ      'H'                                                         S0119
 
     C                   ADD       1             ZDYNBR
     C                   ELSE
 
      **   IF CCY2 NOT A HOLIDAY, CHECK CCY3 IF PRESENT
      **   IF CCY3 NOT PRESENT, DAY IS NOT A HOLIDAY IN ANY CCY
 
     C     FFCCY3        IFEQ      *BLANK
     C                   MOVE      'Y'           HOLF
     C                   ELSE
 
      **   CHECK IF THIS DATE IS A HOLIDAY IN CCY3
 
     C                   MOVE      FFCCY3        ZCCY                                          S0119
     C                   MOVE      *BLANK        ZLOC                                          S0119
 
     C                   EXSR      ZCHKH                                                       S0119
 
      **   IF CCY3 A HOLIDAY,INCREMENT DAY AND REPEAT FROM CCY1 CHECK
 
     C     ZIND          IFEQ      'H'                                                         S0119
     C                   ADD       1             ZDYNBR
 
     C                   ELSE
 
      **   IF CCY3 NOT A HOLIDAY, DAY IS NOT A HOLIDAY IN ANY CCY
 
     C                   MOVE      'Y'           HOLF
 
     C                   END
     C                   END
     C                   END
 
     C                   END
 
      **   ZDYNBR IS THE NEXT WORKING DAY NOT A HOLIDAY IN ANY CCY
 
     C                   Z-ADD     ZDYNBR        FFDAY
 
     C                   ELSE
 
 
      **   DETERMINE PREVIOUS FFDE WORKING DAYS
 
      **   CALCULATE LIMIT FFDE WORKING DAYS BEFORE DATE,IN CCY1
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY1        ZCCY
     C                   MOVE      FFLOC         ZLOC                                          S0119
     C                   Z-ADD     FFDE          ZNRDYS
     C                   EXSR      ZBKDT                                                       S0119
     C                   Z-ADD     ZDYNBR        FFMDY1
 
      **   CALCULATE LIMIT FFDE WORKING DAYS BEFORE DATE,IN CCY2
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY2        ZCCY
     C                   MOVE      *BLANK        ZLOC                                          S0119
     C                   Z-ADD     FFDE          ZNRDYS
     C                   EXSR      ZBKDT                                                       S0119
     C                   Z-ADD     ZDYNBR        FFMDY2
 
      **   CALCULATE LIMIT FFDE WORKING DAYS BEFORE DATE,IN CCY3
      **   IF PRESENT
 
     C     FFCCY3        IFNE      ' '
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY3        ZCCY
     C                   MOVE      *BLANK        ZLOC                                          S0119
     C                   Z-ADD     FFDE          ZNRDYS
     C                   EXSR      ZBKDT                                                       S0119
     C                   Z-ADD     ZDYNBR        FFMDY3
     C                   END
 
      **   TO FIND THE LATEST DAY ( TODAY OR EARLIER ) WHICH IS A
      **   WORKING DAY IN ALL CURRENCIES, FIRST FIND THE EARLIEST OF
      **   ALL THE DATES
 
     C     FFMDY1        IFLT      FFMDY2
     C                   Z-ADD     FFMDY1        FFMDY
     C                   ELSE
     C                   Z-ADD     FFMDY2        FFMDY
     C                   END
     C     FFCCY3        IFNE      *BLANKS
     C     FFMDY3        ANDLT     FFMDY
     C                   Z-ADD     FFMDY3        FFMDY
     C                   END
 
      **   CHECK IF FFMDY IS WORKING DAY IN ALL CURRENCIES
 
     C                   Z-ADD     FFMDY         ZDYNBR
 
     C                   MOVE      'N'           HOLF
 
      **   CONTINUE WHILE THE DATE IS A HOLIDAY IN ANY CCY
 
     C     HOLF          DOWEQ     'N'
 
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     0             ZNRDYS                                        S0119
 
      **   FIND PREVIOUS WORKING DAY IN CCY1
 
     C                   MOVE      FFCCY1        ZCCY
     C                   MOVE      FFLOC         ZLOC                                          S0119
     C                   EXSR      ZBKDT                                                       S0119
 
      **   CHECK IF THIS DATE IS A HOLIDAY IN CCY2
 
     C                   MOVE      FFCCY2        ZCCY                                          S0119
     C                   MOVE      *BLANK        ZLOC                                          S0119
 
     C                   EXSR      ZCHKH                                                       S0119
 
      **   IF CCY2 A HOLIDAY,INCREMENT DAY AND REPEAT FROM CCY1 CHECK
 
     C     ZIND          IFEQ      'H'                                                         S0119
 
     C                   SUB       1             ZDYNBR
     C                   ELSE
 
      **   IF CCY2 NOT A HOLIDAY, CHECK CCY3 IF PRESENT
      **   IF CCY3 NOT PRESENT, DAY IS NOT A HOLIDAY IN ANY CCY
 
     C     FFCCY3        IFEQ      *BLANK
     C                   MOVE      'Y'           HOLF
     C                   ELSE
 
      **   CHECK IF THIS DATE IS A HOLIDAY IN CCY3
 
     C                   MOVE      FFCCY3        ZCCY                                          S0119
     C                   MOVE      *BLANK        ZLOC                                          S0119
 
     C                   EXSR      ZCHKH                                                       S0119
 
      **   IF CCY3 A HOLIDAY,INCREMENT DAY AND REPEAT FROM CCY1 CHECK
 
     C     ZIND          IFEQ      'H'                                                         S0119
     C                   SUB       1             ZDYNBR
 
     C                   ELSE
 
      **   IF CCY3 NOT A HOLIDAY, DAY IS NOT A HOLIDAY IN ANY CCY
 
     C                   MOVE      'Y'           HOLF
 
     C                   END
     C                   END
     C                   END
 
     C                   END
 
      **   ZDYNBR IS THE PREVIOUS WORKING DAY NOT A HOLIDAY IN ANY CCY
 
     C                   Z-ADD     ZDYNBR        FFDAY
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  FFDAWD SR.   CALLED FROM STANDARD SUBROUTINE FFDATE          *
      *               RETURN DAY PASSED IF IT IS A WORKING DAY, ELSE  *
      *               RETURN NEXT/PREVIOUS WORKING DAY IN MARKET      *
      *               CENTRE CURRENCY AND LOCATION AS REQUIRED        *   S01195
      *                                                               *
      *****************************************************************
      *                                                               *
     C     FFDAWD        BEGSR
 
      **   SET UP NO. OF DAYS AND LOCATION FOR ZFWDT/ZBKDT
 
     C                   Z-ADD     0             ZNRDYS
     C                   MOVE      FFLOC         ZLOC
 
     C     FFC           IFEQ      '+'
 
      **   IF FFDAY IS HOLIDAY DETERMINE NEXT WORKING DAY
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY1        ZCCY
     C                   EXSR      ZFWDT
 
     C                   ELSE
 
      **  IF FFDAY IS HOLIDAY DETERMINE PREVIOUS WORKING DAY
 
     C                   Z-ADD     FFDAY         ZDAYNO
     C                   MOVE      FFCCY1        ZCCY
     C                   EXSR      ZBKDT                                                       S0119
     C                   END
 
     C                   Z-ADD     ZDYNBR        FFDAY
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************   S01195
 
      ** +--- The converted FFDATEZ3 ends here ----------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ZDATE1 - Subroutine to contain the call to the ZDATE1        *
      *           module without disturbing the converted FFDATE      *
      *           code                                                *
      *****************************************************************
 
     C     ZDATE1        BEGSR
 
      ** Reset the error indication
     C                   RESET                   ErrorFlag
     C                   RESET                   *in99
 
     C                   CALLB     'ZDATE1'
      **                                         Date input
     C                   PARM                    ZDATE
      **                                         Midas day number returned
     C                   PARM                    ZDAYNO
      **                                         Date format indicator
     C                   PARM                    BJDFIN
      **                                         Error flag
     C                   PARM                    ErrorFlag
 
      ** If an error was found, set on the indicator used by the old code
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      *in99 = True
     C                   ENDIF
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ZBKDT  - Subroutine to contain the call to the ZBKDT         *
      *           module without disturbing the converted FFDATE      *
      *           code                                                *
      *****************************************************************
 
     C     ZBKDT         BEGSR
 
     C                   CALLB     'ZBKDT'
      ** Inputs
      **                                      Midas day number
     C                   PARM                    ZDAYNO
      **                                      Currency
     C                   PARM                    ZCCY
      **                                      Location
     C                   PARM                    ZLOC
      **                                      Number of days back
     C                   PARM                    ZNRDYS
      ** Outputs
      **                                      Working day number ZNRDYS back
     C                   PARM                    ZDYNBR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ZFWDT  - Subroutine to contain the call to the ZFWDT         *
      *           module without disturbing the converted FFDATE      *
      *           code                                                *
      *****************************************************************
 
     C     ZFWDT         BEGSR
 
     C                   CALLB     'ZFWDT'
      ** Inputs
      **                                   Midas day number
     C                   PARM                    ZDAYNO
      *******************                  Currency                             164573
     C*******************PARM                    ZCCY                           164573
      *******************                  Location                             164573
     C*******************PARM                    ZLOC                           164573
      **                                   Number of days forward
     C                   PARM                    ZNRDYS
      ** Outputs
      **                                   Working day number ZNRDYS forward
     C                   PARM                    ZDYNBR
      **                                   Currency                             164573
     C                   PARM                    ZCCY                           164573
      **                                   Location                             164573
     C                   PARM                    ZLOC                           164573
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ZCHKH  - Subroutine to contain the call to the ZCHKH         *
      *           module without disturbing the converted FFDATE      *
      *           code                                                *
      *****************************************************************
 
     C     ZCHKH         BEGSR
 
     C                   CALLB     'ZCHKH'
      **                                         Date input
     C                   PARM                    ZDAYNO
      **                                         Currency
     C                   PARM                    ZCCY
      **                                         Location code
     C                   PARM                    ZLOC
      **                                         Holiday indicator
     C                   PARM                    ZIND
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Working day (5,0P)
     C                   PARM                    FFDAY
 
      ** Parameters received from caller
      ** -------------------------------
      ** Date formula (7A)
     C                   PARM                    FFDATC
      ** Month of required date (2,0P)
     C                   PARM                    FFMTH
      ** Year of required date (2,0P)
     C                   PARM                    FFYR
      ** Market currency (3A)
     C                   PARM                    FFCCY1
      ** Market location (3A)
     C                   PARM                    FFLOC
      ** Instrument currency (3A)
     C                   PARM                    FFCCY2
      ** Other currency (3A)
     C                   PARM                    FFCCY3
      ** Date format indicator (1A, from RUNDAT or SDBANKPD)
     C                   PARM                    BJDFIN
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
 
      ** +--- From copyright array to end is the converted FFDATEZ4 -------+
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   TABDY/TABNO - SHORTNAMES & DAY NUMBERS
F0S1X2M3U4W5T6
