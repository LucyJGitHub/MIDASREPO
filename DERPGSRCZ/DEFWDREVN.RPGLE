     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Forward revaluation')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEFWDREVN - Forward Revaluation.                             *
      *                                                               *
      *  Function:  This module performs forward revaluation for      *
      *             FX deals for reporting profit/loss due to         *
      *             currency rate fluctuations.                       *
      *                                                               *
      *  Component of: DEPXTFXDL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 170442             Date 21Mar00               *
      *                 CDE001  *CREATE    Date 16Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (recompiled)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD006 - Recompiled over changed SDCURRPD.                   *
      *  170442 - Revaluation can not be reconciled with the          *
      *           interpolated value from Forward rates table.        *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
     FFWDRT     IF   F  611     3AIDISK    KEYLOC(2)  INFSR(*PSSR)
      *

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

     D ZHL1            S              1    DIM(366)
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
     D*DAT*************S              5  0 DIM(26) ASCEND                       170442
     D*RAT*************S             13  8 DIM(26)                              170442
     D DAT             S              5  0 DIM(27) ASCEND                       170442
     D RAT             S             13  8 DIM(27)                              170442
     D DFW             S              5  0 DIM(25)
     D RFW             S             13  8 DIM(25)
      *
     D ZHOLDS          DS
      *
      ** Data structure defined over holiday file fields
      *
     D  DGCYCD                 1      3
     D  DGLCCD                 4      6
     D  DGYRNB                 7     10  0
     D  DGJDNB                11     13P 0
     D  DGDDNB                14     16P 0
     D  ZDS1                  17    202
     D  ZDS2                 203    382
     D  ZHL                   17    382
     D                                     DIM(366)
      *
      *
     D ZVARS           DS
      *
      ** Data structure to define variables used in holiday sub-routines
      *
     D  ZIND                   1      1
     D  ZINDX                  2      4  0
     D  ZDAYNO                 5      7P 0
     D  ZDYNBR                 8     10P 0
     D  ZNRDYS                11     13  0
     D  @ZWRDY                14     15  0
      *
     D  ZCCY                  16     18
     D  ZLOC                  19     21
     D  @ZWRKI                16     21
      *
     D  ZSCCY                 22     24
     D  ZSLOC                 25     27
     D  ZSWEXX                28     31  0
     D  ZSJAN                 32     34P 0
     D  ZSDCM                 35     37P 0
     D  RTNCD                 38     44
     D  @ZWRKO                22     44
      *
     D  ZOPTN                 45     51
     D  ZZCCY                 52     54
     D  ZZLOC                 55     57
     D  ZZDYNO                58     60P 0
     D  ZSRTN                 61     67
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details

      *    FORWARD RATES FILE

     IFWDRT     NS  10    1 CD
     I                                  1    1  RECI
     I                                  2    4  CCY
     I                             P    5   79  DFW
     I                             P   80  254  RFW
     I                             P  255  257 0LCD
     I                                258  258  CHTP
     I                             P  259  261 0TNLU

      *    CATCHALL FOR DELETED RECORDS

     IFWDRT     NS

      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30

      * INPUTS
      * buy/sell
     C                   PARM                    BUYSELL           1
      * currency
     C                   PARM                    ECCY              3
      * date
     C                   PARM                    EDAT              5 0
      * amount
     C                   PARM                    EAMT             13 0
      * base ccy equiv.
     C                   PARM                    DBCE             13 0
      *
      * ICD
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJCYCD            3
     C                   PARM                    BCCDP             1 0
      * Currency details
     C                   PARM                    SDCURR
      * OUTPUTS
      * revalued amount,
      * rate, P/L amount
     C                   PARM                    REVA             13 0
     C                   PARM                    RATE             13 8
     C                   PARM                    PLAM             13 0
      *
      * IF EVENT CURRENCY IS BASE
      *
0653 C     ECCY          IFEQ      BJCYCD
     C                   Z-ADD     EAMT          REVA
     C                   Z-ADD     A6SPRT        RATE
     C                   Z-ADD     *ZERO         PLAM
     C                   ELSE
      *
      *  SET UP DATE AND RATE ARRAYS.
      *
     C                   EXSR      SUDA
      *
      *  CONVERT EVENT AMOUNT TO BASE CURRENCY
      *
     C                   EXSR      CONVT
      *
      *  CALCULATE PROFIT/LOSS AMOUNT
      *
     C                   EXSR      CPRLO
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CONVERT EVENT AMOUNT TO BASE CURRENCY.
      ********************************************************************
     C     CONVT         BEGSR
      *
      *    IS THE EVENT DATE LESS THAN THE RUN DATE?
      *
     C     EDAT          IFLT      DAT(1)
     C                   Z-ADD     RAT(1)        RATE
     C                   GOTO      CREVA
     C                   ENDIF
      *
      *    COMPARE EVENT DATE WITH DATES IN ARRAY.
      *
     C                   Z-ADD     1             N                 2 0
     C     EDAT          LOOKUP    DAT(N)                             99        *
     C  N99              GOTO      CASE2
      *
      *    CHECK IF N-1 TH DATE MATCHES EVENT DATE
      *
     C     N             SUB       1             M                 2 0
     C     EDAT          COMP      DAT(M)                                 99    *
     C   99              GOTO      CASE1
      *
      *    THIRD  CASE - EVENT DATE IS BETWEEN TWO DATES IN
      *    THE ARRAY.
      *
     C     RAT(N)        SUB       RAT(M)        WKR1             12 8
      *
     C     EDAT          SUB       DAT(M)        WKD1              5 0
     C     DAT(N)        SUB       DAT(M)        WKD2              5 0
     C     WKR1          MULT      WKD1          WRK15            15 8
      *
     C     WRK15         DIV       WKD2          RATE
      *
     C     RATE          ADD       RAT(M)        RATE
     C                   GOTO      CREVA
      *
      *    FIRST CASE - EVENT DATE MATCHES A DATE IN THE ARRAY
      *
     C     CASE1         TAG
     C                   Z-ADD     RAT(M)        RATE
     C                   GOTO      CREVA
      *
      *    SECOND CASE - EVENT DATE IS AFTER LAST DATE IN
      *    THE ARRAY
      *
     C     CASE2         TAG
     C                   Z-ADD     RAT(LAST)     RATE
      *
      *    CALCULATE REVALUED AMOUNT.
      *
     C     CREVA         TAG
      *
     C     A6NBDP        SUB       BCCDP         K                 1 0
     C     K             ADD       4             K
      *
     C                   Z-ADD     RATE          W#RATE           13 8
     C                   EXSR      CLREVA
     C                   Z-ADD     W#REVA        REVA
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CALCULATE REVALUED EQUIVALENT FOR REPORT
      ********************************************************************
     C     CLREVA        BEGSR
      *
     C     A6MDIN        IFEQ      'D'
      *
     C     K             IFNE      1
     C     K             ANDNE     2
     C     W#RATE        MULT      POWER(K)      WK159            15 9
     C     EAMT          DIV(H)    WK159         W#REVA           13 0
     C                   END
     C     K             IFEQ      1
     C     W#RATE        MULT      100           RATE1            12 6
     C     RATE1         MULT      POWER(K)      WK129            12 9
     C     EAMT          DIV(H)    WK129         WK152            15 2
     C     WK152         MULT(H)   100           W#REVA
     C                   END
      *
     C     K             IFEQ      2
     C     W#RATE        MULT      10            RATE2            12 7
     C     RATE2         MULT      POWER(K)      WK129
     C     EAMT          DIV(H)    WK129         WK151            15 1
     C     WK151         MULT(H)   10            W#REVA
     C                   END
      *
     C                   ELSE
      *
     C     K             IFNE      6
     C     K             ANDNE     7
     C     W#RATE        DIV       POWER(K)      WK159
     C     EAMT          MULT(H)   WK159         W#REVA
     C                   END
     C     K             IFEQ      7
     C     W#RATE        MULT      100           RATE1
     C     RATE1         DIV       POWER(K)      WK129
      *
     C     EAMT          MULT(H)   WK129         W#REVA
     C                   DIV(H)    100           W#REVA
     C                   END
      *
     C     K             IFEQ      6
     C     W#RATE        MULT      10            RATE2
     C     RATE2         DIV       POWER(K)      WK129
      *
     C     EAMT          MULT(H)   WK129         W#REVA
     C                   DIV(H)    10            W#REVA
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CALCULATE PROFIT/LOSS.
      ********************************************************************
     C     CPRLO         BEGSR
      *
     C     BUYSELL       IFEQ      'B'
     C     REVA          SUB       DBCE          PLAM
     C                   ELSE
     C     DBCE          SUB       REVA          PLAM
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * SET UP DATE ARRAY.
      ********************************************************************
     C     SUDA          BEGSR
      *
     C                   Z-ADD     0             DAT
     C                   Z-ADD     0             RAT
     C                   Z-ADD     0             DFW
     C                   Z-ADD     0             RFW
      *
      *  IF THE EVENT DATE IS IN THE FUTURE
      *  ACCESS THE FORWARD RATES FILE.
      *
     C                   SETOFF                                       10
      *
     C     EDAT          IFGT      BJRDNB
     C     ECCY          CHAIN     FWDRT                              99
     C                   ENDIF
      *
      *  PUT THE RUN DATE IN THE FIRST ELEMENT.
      *  This is a default - will be overwritten with the first forward
      *  date specified on the currency record, if found.
      *
     C                   Z-ADD     BJRDNB        DAT(1)
      *
      **  If no record for this currency, bypass Forward Dates setup.
      *
     C  N10              Z-ADD     2             N
     C  N10              GOTO      ESUDA
      *
      **  Increment Run Date by No of Spot Days for Currency, taking any
      **  non-working days for the currency into account - Forward Days
      **  are calculated from spot date.
      *
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   MOVE      ECCY          ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     A6SPDY        ZNRDYS
     C                   EXSR      ZFWDTA
     C                   Z-ADD     ZDYNBR        @BASE             5 0
      *
      **  Increment Spot date by number of Forward Days
      *
     C                   Z-ADD     2             N
     C*****              Z-ADD     2             Y                 2 0          170442
     C                   Z-ADD     1             Y                 2 0          170442
      *                                                                         170442
     C                   Z-ADD     @BASE         DAT(N)                         170442
     C                   ADD       1             N                              170442
      *
     C     N             DOWLE     25
     C     DFW(Y)        ANDNE     0
     C     @BASE         ADD       DFW(Y)        DAT(N)
     C                   ADD       1             N
     C                   ADD       1             Y
     C                   ENDDO
      *
     C     ESUDA         TAG
      *
     C     N             SUB       1             LAST              2 0
      *
      *  ELEMENT 1 OF RATE ARRAY CONTAINS SPOT RATE.
      *
     C*****              MOVEA     RFW           RAT(2)                         170442
     C                   Z-ADD     A6SPRT        RAT(1)
     C                   Z-ADD     A6SPRT        RAT(2)                         170442
     C                   MOVEA     RFW           RAT(3)                         170442
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  Midas - Copy Source                                      *
     C*                                                               *
     C*  ZFWDTA - Calculate Working Days Forward.                     *
     C*                                                               *
      *  (c) Finastra International Limited 2001                      *
     C*                                                               *
     C*  LAST AMEND NO. 063791             DATE 15JUL94               *
     C*  PREV AMEND NO. 000000             DATE 0000000               *
     C*                                                               *
     C*---------------------------------------------------------------*
     C*                                                               *
     C*  063791 - Duplicated copy source ZFWDT and changed the        *
     C*           number of days to move forward from length of 2,0   *
     C*           to 3,0 to cater for days greater than 99.           *
     C*****************************************************************
     C     ZFWDTA        BEGSR
     C*
     C** Standard sub-routine to calculate up to 99 working days forward
     C** from a given start date.
     C** NB. Must be used in conjunction with ZACCH.
     C**
     C** NB: If required no. of working days forward is zero, then:-
     C**       if input date is a working day, then result is input date
     C**       else result is first working day after input date.
     C**
     C**     If required no. of working days forward is one, then:-
     C**       if input date is a working day, then result is next
     C**       working day
     C**       else result is first working day after input date.
     C**
     C** Thus, if input date is a holiday, then zero and one working day
     C** forward will return the same result.
     C*
     C*
     C** Define input parameters
     C*
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   MOVE      ZLOC          ZLOC              3
     C                   Z-ADD     ZNRDYS        ZNRDYS            3 0
     C*
     C** Define Output parameters
     C*
     C                   Z-ADD     0             ZDYNBR            5 0
     C*
     C** Move input date to output date
     C*
     C                   Z-ADD     ZDAYNO        ZDYNBR
     C*
     C** Save original value of ZDAYNO
     C*
     C                   Z-ADD     ZDAYNO        ZDAYNT            5 0
     C*
     C** Access holiday record
     C*
     C                   MOVE      '*SETGT '     ZOPTN
     C                   EXSR      ZACCH
     C*
     C** If no record was found, then just add no. of days forward
     C** required to input date to give output.
     C*
     C     RTNCD         IFEQ      '*NRF   '                                    IF 1
     C*
     C     ZDAYNO        ADD       ZNRDYS        ZDYNBR
     C*
     C                   ELSE                                                   ELSE 1
     C*
     C** Otherwise, a holiday record was found and so need to count days
     C** forward to get required result.
     C**
     C** Subtract 1st. Jan date from given date and add 1 to give the
     C** nth day in the year (ZINDX).
     C*
     C     ZDAYNO        SUB       DGJDNB        ZINDX
     C                   ADD       1             ZINDX
     C*
     C** If no. of working days forward wanted is zero, then check first
     C** that given date is not a holiday. If it is, then change no. of
     C** days forward wanted to one to get next working day.
     C*
     C     ZNRDYS        IFEQ      0                                             IF 2
     C     ZHL(ZINDX)    ANDEQ     'X'
     C                   ADD       1             ZNRDYS
     C                   END                                                     FI 2
     C*
     C** While no. of working days left to find is greater than zero
     C*
     C     ZNRDYS        DOWGT     0                                             DOW 1
     C*
     C** Add one to day in year index and to output date
     C*
     C                   ADD       1             ZINDX
     C                   ADD       1             ZDYNBR
     C*
     C** If output date is beyond stored 31st. Dec date, then need to
     C** get next holiday record with new parameters: output date is new
     C** input date; no. of days forward is current no. of days left to
     C** find.
     C*
     C     ZDYNBR        IFGT      DGDDNB                                         IF 1
     C*
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C*
     C                   MOVE      '*SETGT '     ZOPTN
     C                   EXSR      ZACCH
     C*
     C** If no record was found, then add no. of days left to find to
     C** output date and subtract 1 to give required result and change
     C** no. left to find to zero to terminate loop.
     C*
     C     RTNCD         IFEQ      '*NRF   '                                       IF 2
     C*
     C                   ADD       ZNRDYS        ZDYNBR
     C                   SUB       1             ZDYNBR
     C                   Z-ADD     0             ZNRDYS
     C*
     C                   ELSE                                                      ELSE 2
     C*
     C** Otherwise, reset day in year value to one.
     C*
     C                   Z-ADD     1             ZINDX
     C*
     C                   END                                                       FI 2
     C*
     C                   END                                                      FI 1
     C*
     C** If working day then no. left to find is one less
     C*
     C     ZNRDYS        IFNE      0                                              IF 1
     C     ZHL(ZINDX)    ANDEQ     ' '                                            AND1
     C                   SUB       1             ZNRDYS
     C                   END                                                      FI 1
     C*
     C                   END                                                     ENW 1
     C*
     C** Move back original value of ZDAYNO
     C*
     C                   Z-ADD     ZDAYNT        ZDAYNO
     C*
     C                   END                                                    FI 1
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZACCH         BEGSR
      *
      * This standard sub-routine is to be used in conjunction with
      * the holiday standard sub-routines. Its function is to
      * determine if the access program AOHOLS0 needs to be called and
      * sets up the holiday record appropriately. It is common to all
      * the new holiday sub-routines, but should only be included in
      * a program once, using /COPY.
      *
      *
      * If stored parameters from last call are not within the same
      * bounds - ie. same ccy/location and date is within 1st. Jan &
      * 31st. Dec of current holiday record - continue processing.
      *
      **
      *Define input parameters
      **
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   MOVE      ZLOC          ZLOC              3
     C                   MOVE      ZOPTN         ZOPTN             7
     C*
     C     ZOPTN         IFEQ      '*FREE  '                                      IF 2
     C*
     C                   CALL      'AOHOLS0'
     C                   PARM      *BLANK        RTNCD
     C                   PARM                    ZOPTN
     C                   PARM      ZCCY          ZZCCY
     C                   PARM      ZLOC          ZZLOC
     C                   PARM      ZDAYNO        ZZDYNO
     C     ZHOLDS        PARM      ZHOLDS        DSSDY                                      B
     C*
     C                   ELSE                                                                  S0119
     C*
     C     ZCCY          IFNE      ZSCCY                                        IF 1
     C     ZLOC          ORNE      ZSLOC                                         OR
     C     ZDAYNO        ORLT      ZSJAN                                         OR
     C     ZDAYNO        ORGT      ZSDCM                                         OR
      *
      * Get appropriate holiday record
      *
     C                   CALL      'AOHOLS0'
     C                   PARM      *BLANK        RTNCD
     C                   PARM                    ZOPTN
     C                   PARM      ZCCY          ZZCCY
     C                   PARM      ZLOC          ZZLOC
     C                   PARM      ZDAYNO        ZZDYNO            5 0
     C     ZHOLDS        PARM      ZHOLDS        DSSDY                                      B
      *
      * If no record was found, assume all days in year are working
      * days.
      *
     C     RTNCD         IFEQ      '*NRF   '                                      IF 2
      *
     C                   MOVE      *ALL' '       ZHL
      *
      * Save 1st. Jan/31st. Dec dates as input date as we cannot say
      * anything about this year in future calls.
      *
     C                   Z-ADD     ZDAYNO        ZSJAN
     C                   Z-ADD     ZDAYNO        ZSDCM
      *
     C                   ELSE                                                     ELSE 2
      *
      * Save 1st. Jan/31st. Dec for future calls
      *
     C                   Z-ADD     DGJDNB        ZSJAN
     C                   Z-ADD     DGDDNB        ZSDCM
      *
      * Left adjust the holiday array over FEB 29th if the
      * holiday record is not for a leap year.
      *
     C                   MOVE      DGYRNB        Z@YR              4 0
     C     Z@YR          DIV       4             Z@WK1             4 0
     C                   MVR                     Z@WK2             4 0
     C*
     C     Z@WK2         IFNE      0
     C*
     C                   MOVEA     ZHL           ZHL1
     C                   MOVEA     ZHL1(61)      ZHL(60)
     C*
     C                   END
     C*
     C                   END                                                      FI 2
      *
      * Save currency and location for future calls. Need to save
      * return code as well.
      *
     C                   MOVE      ZCCY          ZSCCY
     C                   MOVE      ZLOC          ZSLOC
     C                   MOVE      RTNCD         ZSRTN
      *
     C                   ELSE                                                   ELSE 1
      *
      * Move saved return code back again as there may have been no
      * record found last time.
      *
     C                   MOVE      ZSRTN         RTNCD
      *
     C                   END                                                    FI 1
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**   POWER - POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
