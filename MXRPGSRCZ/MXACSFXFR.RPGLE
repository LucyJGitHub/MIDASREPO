     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Foreign Exchange Forward Rates')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSFXFR - Access Foreign Exchange Forward Rates            *
      *                                                               *
      *  Function:  This module determine forward FX rates            *
      *             for a supplied currency and date                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 241970             Data 05Sep06               *
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 226922             Date 06Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX005             Date 15Jan01               *
      *                 CMX004  *CREATE    Date 30Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  226922 - Error when FRDDAT and FRVDAT are the same as no     *
      *           rates are set up causing divide by zero error in    *
      *           CONVT.                                              *
      *  CMX005 - Meridian Export Enhancements - Phase 4              *
      *  CMX004 - Meridian Export Enhancements - Phase 3              *
      *                                                               *
      *****************************************************************
 
     FFWDRT     IF   F  611     3AIDISK    KEYLOC(2)  INFSR(*PSSR)
     FSDCUHSL2  IF   E           K DISK                                                       226922
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
     D ZHL1            S              1    DIM(366)
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
     D DAT             S              5  0 DIM(27) ASCEND
     D RAT             S             13  8 DIM(27)
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
 
 
 
     D                 DS
     D DDate5A                 1      5A
     D                 DS
     D DDate3A                 1      3A
     D DDate05P                1     03P 0
 
     D                 DS
     D VDate5A                 1      5A
     D                 DS
     D VDate3A                 1      3A
     D VDate05P                1     03P 0
 
     D                 DS
     D Amt13_13A               1     13A
     D                 DS
     D Amt13_7A                1      7A
     D Amt13_13P               1      7P 0
 
     D                 DS
     D Amt15_15A               1     15A
     D                 DS
     D Amt15_8A                1      8A
     D Amt15_8AL1              8      8A
     D Amt15_15P               1      8P 0
 
 
      * Foreign Exchange Forward Rates
     D FXFR          E DS                  EXTNAME(MXFXFRPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
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
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        Currency          3
     C                   MOVEL     I#LFD2        DDate5A
     C                   MOVEL     I#LFD2        DDate3A
     C                   MOVEL     I#LFD3        VDate5A
     C                   MOVEL     I#LFD3        VDate3A
     C                   MOVEL     I#LFD4        Amt13_13A
     C                   MOVEL     I#LFD4        Amt13_7A
     C                   MOVEL     I#LFD4        Amt15_15A
     C                   MOVEL     I#LFD4        Amt15_8A
 
      * Error if no currency is supplied
 
     C     Currency      IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK CURRENCY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no deal date is supplied
 
     C     DDate5A       IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK DEAL DATE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no value date is supplied
 
     C     VDate5A       IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK VALUE DATE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no amount is supplied
 
     C     Amt15_15A     IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK AMOUNT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Clear the output format
 
     C                   CLEAR                   FXFR
 
      * Currency
 
     C                   MOVEL     I#LFD1        FRCCY
 
      * Deal Date
 
     C                   TESTN                   DDate5A              9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     DDate5A       FRDDAT
     C                   ELSE
     C                   Z-ADD     DDate05P      FRDDAT
     C                   ENDIF
 
      * Value Date
 
     C                   TESTN                   VDate5A              9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     VDate5A       FRVDAT
     C                   ELSE
     C                   Z-ADD     VDate05P      FRVDAT
     C                   ENDIF
 
      *  Amount for Conversion
 
     C                   TESTN                   Amt15_15A            9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     Amt15_15A     FRAMTC
     C                   ELSE
     C                   TESTN                   Amt13_13A            9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     Amt13_13A     FRAMTC
     C                   ELSE
     C     Amt15_8AL1    IFEQ      *BLANK
     C                   Z-ADD     Amt13_13P     FRAMTC
     C                   ELSE
     C                   Z-ADD     Amt15_15P     FRAMTC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
 
      * Get the currency details
 
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     FRCCY         I#LFD1
     C                   CALLB     'MXACSCURR'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error if the currency was not found
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID CURRENCY:'
     C                             + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set the currency multiply/divide indicator and decimal places
 
     C                   EVAL      SDCURR = InData
     C                   MOVE      A6MDIN        FRMDIN
     C                   Z-ADD     A6NBDP        FRCDP
 
 
      * If the currency is base
 
0653 C     FRCCY         IFEQ      BJCYCD
     C                   Z-ADD     BJRDNB        FRNDAT
     C                   Z-ADD     1             FRNRAT
     C                   Z-ADD     BJRDNB        FRFDAT
     C                   Z-ADD     1             FRFRAT
     C                   Z-ADD     1             FRCRAT
     C                   Z-ADD     FRAMTC        FRBCYE
     C                   ELSE
 
      * Set up the date and rate arrays
 
     C                   EXSR      SUDA
 
      * Convert amount to base currency
 
     C                   EXSR      CONVT
      *
     C                   ENDIF
 
      * Determine if the deal is a forward deal
      * in deal currency
 
     C                   MOVEL     FRCCY         ZCCY
     C                   EXSR      Det_FWD
     C     Num_Days      IFGT      2
     C                   MOVEL     'Y'           FRFWDD
     C                   ELSE
     C                   MOVEL     'N'           FRFWDD
     C                   ENDIF
 
      * Determine if the deal is a forward deal
      * in base currency
 
     C                   MOVEL     BJCYCD        ZCCY
     C                   EXSR      Det_FWD
     C     Num_Days      IFGT      2
     C                   MOVEL     'Y'           FRFWDB
     C                   ELSE
     C                   MOVEL     'N'           FRFWDB
     C                   ENDIF
 
      * Determine if the deal is a forward deal
      * in local currency
 
     C                   MOVEL     BJLCCY        ZCCY
     C                   EXSR      Det_FWD
     C     Num_Days      IFGT      2
     C                   MOVEL     'Y'           FRFWDL
     C                   ELSE
     C                   MOVEL     'N'           FRFWDL
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = FXFR
 
 
      * Return
 
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * Set up the date and rate arrays
      ********************************************************************
     C     SUDA          BEGSR
      *
     C                   Z-ADD     0             DAT
     C                   Z-ADD     0             RAT
     C                   Z-ADD     0             DFW
     C                   Z-ADD     0             RFW
      *
      *  IF THE VALUE DATE IS IN THE FUTURE
      *  ACCESS THE FORWARD RATES FILE.
      *
     C                   SETOFF                                       10
      *
     C     FRVDAT        IFGT      BJRDNB
     C     FRCCY         CHAIN     FWDRT                              99
     C                   ELSE                                                                 226922
      *                                                                                       226922
      *  Access Historic Spot Rate to set initial rate                                        226922
     C     K0CUHS        KLIST                                                                226922
     C                   KFLD                    FRCCY                                        226922
     C                   KFLD                    FRDDAT                                       226922
     C     K0CUHS        SETLL     SDCUHSL2                           99                      226922
     C     FRCCY         READE     SDCUHSL2                               99                  226922
     C  N99              Z-ADD     G2SPRT        RFW(1)                                       226922
      *                                                                                       226922
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
     C                   MOVE      FRCCY         ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     A6SPDY        ZNRDYS
     C                   EXSR      ZFWDTA
     C                   Z-ADD     ZDYNBR        @BASE             5 0
      *
      **  Increment Spot date by number of Forward Days
      *
     C                   Z-ADD     2             N
     C                   Z-ADD     1             Y                 2 0
      *
     C                   Z-ADD     @BASE         DAT(N)
     C                   ADD       1             N
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
     C                   Z-ADD     A6SPRT        RAT(1)
     C                   Z-ADD     A6SPRT        RAT(2)
     C                   MOVEA     RFW           RAT(3)
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Amount to Base Currency
      ********************************************************************
     C     CONVT         BEGSR
      *
      *    IS THE VALUE DATE LESS THAN THE RUN DATE?
      *
     C     FRVDAT        IFLT      DAT(1)
     C                   Z-ADD     BJRDNB        FRNDAT
     C                   Z-ADD     RAT(1)        FRNRAT
     C                   Z-ADD     BJRDNB        FRFDAT
     C                   Z-ADD     RAT(1)        FRFRAT
     C                   Z-ADD     RAT(1)        FRCRAT
     C                   GOTO      CREVA
     C                   ENDIF
      *
      *    COMPARE VALUE DATE WITH DATES IN ARRAY.
      *
     C                   Z-ADD     1             N                 2 0
     C     FRVDAT        LOOKUP    DAT(N)                             99        *
     C  N99              GOTO      CASE2
      *
      *    CHECK IF N-1 TH DATE MATCHES VALUE DATE
      *
     C     N             SUB       1             M                 2 0
     C     FRVDAT        COMP      DAT(M)                                 99    *
     C   99              GOTO      CASE1
      *
      *    THIRD  CASE - VALUE DATE IS BETWEEN TWO DATES IN
      *    THE ARRAY.
      *
     C                   Z-ADD     DAT(M)        FRNDAT
     C                   Z-ADD     RAT(M)        FRNRAT
     C                   Z-ADD     DAT(N)        FRFDAT
     C                   Z-ADD     RAT(N)        FRFRAT
 
     C     RAT(N)        SUB       RAT(M)        WKR1             12 8
      *
     C     FRVDAT        SUB       DAT(M)        WKD1              5 0
     C     DAT(N)        SUB       DAT(M)        WKD2              5 0
     C     WKR1          MULT      WKD1          WRK15            15 8
      *
     C     WRK15         DIV       WKD2          FRCRAT
      *
     C                   ADD       RAT(M)        FRCRAT
     C                   GOTO      CREVA
      *
      *    FIRST CASE - VALUE DATE MATCHES A DATE IN THE ARRAY
      *
     C     CASE1         TAG
     C                   Z-ADD     DAT(M)        FRNDAT
     C                   Z-ADD     RAT(M)        FRNRAT
     C                   Z-ADD     DAT(M)        FRFDAT
     C                   Z-ADD     RAT(M)        FRFRAT
     C                   Z-ADD     RAT(M)        FRCRAT
     C                   GOTO      CREVA
      *
      *    SECOND CASE - VALUE DATE IS AFTER LAST DATE IN
      *    THE ARRAY
      *
     C     CASE2         TAG
     C                   Z-ADD     DAT(LAST)     FRNDAT
     C                   Z-ADD     RAT(LAST)     FRNRAT
     C                   Z-ADD     DAT(LAST)     FRFDAT
     C                   Z-ADD     RAT(LAST)     FRFRAT
     C                   Z-ADD     RAT(LAST)     FRCRAT
      *
      *    CALCULATE REVALUED AMOUNT.
      *
     C     CREVA         TAG
      *
     C     A6NBDP        SUB       BasCcyDec     CDP_Dif           1 0
     C     CDP_Dif       ADD       4             CDP_Dif
      *
     C                   EXSR      CLREVA
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
 
     C     CDP_Dif       IFNE      1
     C     CDP_Dif       ANDNE     2
     C     FRCRAT        MULT      POWER(CDP_Dif)WK159            15 9
     C     FRAMTC        DIV(H)    WK159         FRBCYE
     C                   END
 
     C     CDP_Dif       IFEQ      1
     C     FRCRAT        MULT      100           RATE1            12 6
     C     RATE1         MULT      POWER(CDP_Dif)WK129            12 9
     C     FRAMTC        DIV(H)    WK129         WK152            15 2
     C     WK152         MULT(H)   100           FRBCYE
     C                   END
 
     C     CDP_Dif       IFEQ      2
     C     FRCRAT        MULT      10            RATE2            12 7
     C     RATE2         MULT      POWER(CDP_Dif)WK129
     C     FRAMTC        DIV(H)    WK129         WK151            15 1
     C     WK151         MULT(H)   10            FRBCYE
     C                   END
 
     C                   ELSE
 
     C     CDP_Dif       IFNE      6
     C     CDP_Dif       ANDNE     7
     C     FRCRAT        DIV       POWER(CDP_Dif)WK159
     C     FRAMTC        MULT(H)   WK159         FRBCYE
     C                   END
 
     C     CDP_Dif       IFEQ      7
     C     FRCRAT        MULT      100           RATE1
     C     RATE1         DIV       POWER(CDP_Dif)WK129
     C     FRAMTC        MULT(H)   WK129         FRBCYE
     C                   DIV(H)    100           FRBCYE
     C                   END
 
     C     CDP_Dif       IFEQ      6
     C     FRCRAT        MULT      10            RATE2
     C     RATE2         DIV       POWER(CDP_Dif)WK129
     C     FRAMTC        MULT(H)   WK129         FRBCYE
     C                   DIV(H)    10            FRBCYE
     C                   END
 
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * DETERMINE IF THE DEAL IS A FORWARD DEAL IN A PARTICULAR CURRENCY
      ********************************************************************
     C     Det_FWD       BEGSR
 
     C                   Z-ADD     *ZERO         Num_Days          1 0
     C                   Z-ADD     FRDDAT        ZDAYNO
     C     ZDAYNO        DOWLT     FRVDAT
     C     Num_Days      ANDLE     2
     C                   EXSR      ZCHKH
     C     ZIND          IFEQ      'W'
     C                   ADD       1             Num_Days
     C                   ENDIF
     C                   ADD       1             ZDAYNO
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
     C*****************************************************************
     C*                                                               *
     C*  Midas - Copy Source                                      *
     C*                                                               *
     C*  ZFWDTA - Calculate Working Days Forward.                     *
     C*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
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
     C                   END
     C*
     C                   END
     C*
     C** If working day then no. left to find is one less
     C*
     C     ZNRDYS        IFNE      0
     C     ZHL(ZINDX)    ANDEQ     ' '
     C                   SUB       1             ZNRDYS
     C                   END
     C*
     C                   END
     C*
     C** Move back original value of ZDAYNO
     C*
     C                   Z-ADD     ZDAYNT        ZDAYNO
     C*
     C                   END
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
     C     ZOPTN         IFEQ      '*FREE  '
     C*
     C                   CALL      'AOHOLS0'
     C                   PARM      *BLANK        RTNCD
     C                   PARM                    ZOPTN
     C                   PARM      ZCCY          ZZCCY
     C                   PARM      ZLOC          ZZLOC
     C                   PARM      ZDAYNO        ZZDYNO
     C     ZHOLDS        PARM      ZHOLDS        DSSDY
     C*
     C                   ELSE
     C*
     C     ZCCY          IFNE      ZSCCY
     C     ZLOC          ORNE      ZSLOC
     C     ZDAYNO        ORLT      ZSJAN
     C     ZDAYNO        ORGT      ZSDCM
      *
      * Get appropriate holiday record
      *
     C                   CALL      'AOHOLS0'
     C                   PARM      *BLANK        RTNCD
     C                   PARM                    ZOPTN
     C                   PARM      ZCCY          ZZCCY
     C                   PARM      ZLOC          ZZLOC
     C                   PARM      ZDAYNO        ZZDYNO            5 0
     C     ZHOLDS        PARM      ZHOLDS        DSSDY
      *
      * If no record was found, assume all days in year are working
      * days.
      *
     C     RTNCD         IFEQ      '*NRF   '
      *
     C                   MOVE      *ALL' '       ZHL
      *
      * Save 1st. Jan/31st. Dec dates as input date as we cannot say
      * anything about this year in future calls.
      *
     C                   Z-ADD     ZDAYNO        ZSJAN
     C                   Z-ADD     ZDAYNO        ZSDCM
      *
     C                   ELSE
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
     C                   END
      *
      * Save currency and location for future calls. Need to save
      * return code as well.
      *
     C                   MOVE      ZCCY          ZSCCY
     C                   MOVE      ZLOC          ZSLOC
     C                   MOVE      RTNCD         ZSRTN
      *
     C                   ELSE
      *
      * Move saved return code back again as there may have been no
      * record found last time.
      *
     C                   MOVE      ZSRTN         RTNCD
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  ZCHKH - Check if Holiday for Ccy/Locn                        *
      *                                                               *
      *****************************************************************
     C     ZCHKH         BEGSR
      **
      *Define input parameters
      **
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   MOVE      ZLOC          ZLOC              3
      **
      *Define output parameter
      **
     C                   MOVE      ZIND          ZIND              1
      *
      * Standard sub-routine to determine if a MIDAS day no. is a
      * holiday or working day for a given currency and (optionally)
      * location.
      * NB. This sub-routine must be used in conjunction with ZACCH.
      *
      * Access holiday record.
      *
      *
     C                   MOVE      '*SETGT '     ZOPTN
     C                   EXSR      ZACCH
      *
      * If no record was found then all days for year are assumed to be
      * working days, so set holiday indicator appropriately.
      *
     C     RTNCD         IFEQ      '*NRF   '                                    IF 1
      *
     C                   MOVE      'W'           ZIND
      *
     C                   ELSE                                                   ELSE 1
      *
      * Subtract 1st. Jan date from given date and add 1 to give the
      * nth day in the year (ZINDX).
      *
     C     ZDAYNO        IFGT      ZSJAN
     C     ZDAYNO        SUB       ZSJAN         ZINDX
     C                   ADD       1             ZINDX
     C                   ELSE
     C     ZDAYNO        SUB       DGJDNB        ZINDX
     C                   ADD       1             ZINDX
     C                   ENDIF
      *
      * Move the nth day in the year value to the holiday indicator
      *
     C                   MOVE      ZHL(ZINDX)    ZIND
      *
      * If holiday indicator is 'X' change to 'H' to show holiday
      *
     C     ZIND          IFEQ      'X'                                           IF 2
     C                   MOVE      'H'           ZIND
     C                   ELSE
     C                   MOVE      'W'           ZIND
     C                   END                                                     FI 2
      *
     C                   END                                                    FI 1
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      **  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access Base Currency Decimal Places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6NBDP        BasCcyDec         1 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   POWER - POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
