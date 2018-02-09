     H DEBUG DATEDIT(*DMY)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calc working days backward       (module)')
      *****************************************************************
      *                                                               *
      *  Midas - Cashier Interface Module                             *
      *                                                               *
      *  RVFBDT - Calculate Working Days Backward                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Prev Amend No. CRT004  *CREATE    Date 31Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *                                                               *
      *****************************************************************
     D*
     D ZHL1            S              1    DIM(366)
      * Arrays to split holiday fields into 1-bit elements
     D*
     D*
     D ZHOLDS          DS
      *
      * Data structure defined over holiday file fields
      *
     D  DGCYCD                 1      3
     D  DGLCCD                 4      6
     D  DGYRNB                 7     10  0
     D  DGJDNB                11     13P 0
     D  DGDDNB                14     16P 0
     D  ZDS1                  17    202
     D  ZDS2                 203    382
     D  ZHL                   17    382    DIM(366)
      *
      *
     D ZVARS           DS
      *
      * Data structure to define variables used in holiday sub-routines
      *
     D  ZIND                   1      1
     D  ZINDX                  2      4  0
     D  ZDAYNO                 5      7P 0
     D  ZDYNBR                 8     10P 0
     D  ZNRDYS                11     12  0
     D  @ZWRDY                13     14  0
      *
     D  ZCCY                  15     17
     D  ZLOC                  18     20
     D  @ZWRKI                15     20
      *
     D  ZSCCY                 21     23
     D  ZSLOC                 24     26
     D  ZSWEXX                27     30  0
     D  ZSJAN                 31     33P 0
     D  ZSDCM                 34     36P 0
     D  RTNCD                 37     43
     D  @ZWRKO                21     43
      *
     D  ZOPTN                 44     50
     D  ZZCCY                 51     53
     D  ZZLOC                 54     56
     D  ZZDYNO                57     59P 0
     D  ZSRTN                 60     66
     D*
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* Second DS for access programs, long data structure
     D*
     D*
     D* Copyright Notice
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D*****************************************************************
     C     *ENTRY        PLIST
     C     ZDAYNO        PARM      ZDAYNO        InputDay          5 0
     C     ZNRDYS        PARM      ZNRDYS        DaysFwd           2 0
     C     ZDYNBR        PARM      ZDYNBR        OutputDay         5 0
     C     ZCCY          PARM      ZCCY          Currency          3
     C     ZLOC          PARM      ZLOC          Location          3
     C*
     C*
     C                   EXSR      RVFBDT
     C*
     C*
     C                   RETURN
     C*
      /EJECT
      *****************************************************************
      *                                                               *
      *            RVFBDT - Calculate Working Days Backward.          *
      *                                                               *
      * CALLS      ZACCH  - Access record for Holidays file.          *
      *                                                               *
      * CALLED BY  P06    - Retrieve System Control Data Routine.     *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     RVFBDT        BEGSR                                                  *** RVFBDT ***
      *
      **  Define input parameters.
      *
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0          STARTING DATE
     C                   MOVE      ZCCY          ZCCY              3            DATE CURRENCY
     C                   MOVE      ZLOC          ZLOC              3            LOCATION
     C                   Z-ADD     ZNRDYS        ZNRDYS            2 0          NBR OF WORKING
      *                                                    DAYS BACKWARD
      **  Define output parameters.
      *
     C                   Z-ADD     0             ZDYNBR            5 0
      *
      **  Move input date to output date.
      *
     C                   Z-ADD     ZDAYNO        ZDYNBR
      *
      **  Save original value of ZDAYNO.
      *
     C                   Z-ADD     ZDAYNO        ZDAYNT            5 0
      *
      **  Access holiday record.
      *
     C                   MOVE      '*SETGT '     ZOPTN
     C                   EXSR      ZACCH
      *
      **  If no record was found, then just subtract no. of days backward
      **  required to input date to give output.
      *
     C     RTNCD         IFEQ      '*NRF   '
      *
     C     ZDAYNO        SUB       ZNRDYS        ZDYNBR
      *
     C                   ELSE
      *
      **  Otherwise, a holiday record was found and so need to count days
      **  backward to get required result.
      **  Subtract 1st Jan date from given date and add 1 to give the
      **  nth day in the year (ZINDX).
      *
     C     ZDAYNO        SUB       DGJDNB        ZINDX
     C                   ADD       1             ZINDX
      *
      **  If no. of working days backward wanted is zero, then check first
      **  that given date is not a holiday.  If it is, then change no. of
      **  days backward wanted to one to get next working day.
      *
     C     ZNRDYS        IFEQ      0
     C     ZHL(ZINDX)    ANDEQ     'X'
     C                   ADD       1             ZNRDYS
     C                   ENDIF
      *
      **  While no. of working days left to find is greater than zero
      *
     C     ZNRDYS        DOWGT     0
      *
      **  Subtract one to day in year index and to output date.
      *
     C                   SUB       1             ZINDX
     C                   SUB       1             ZDYNBR
      *
      **  If output date is before stored 1st Jan date, then need to
      **  get next holiday record with new parameters: output date is new
      **  input date; no. of days forward is current no. of days left to
      **  find.
      *
     C     ZDYNBR        IFLT      DGJDNB
      *
     C                   Z-ADD     ZDYNBR        ZDAYNO
      *
     C                   MOVE      '*SETGT '     ZOPTN
     C                   EXSR      ZACCH
      *
      **  If no record was found, then subtract no. of days left to find to
      **  output date and subtract 1 to give required result and change
      **  no. left to find to zero to terminate loop.
      *
     C     RTNCD         IFEQ      '*NRF   '
      *
     C                   SUB       ZNRDYS        ZDYNBR
     C                   ADD       1             ZDYNBR
     C                   Z-ADD     0             ZNRDYS
      *
     C                   ELSE
      *
      **  Otherwise, reset day in year value to last.
      *
     C                   Z-ADD     366           ZINDX
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  If working day then no. left to find is one less.
      *
     C     ZNRDYS        IFNE      0
     C     ZHL(ZINDX)    ANDEQ     ' '
     C                   SUB       1             ZNRDYS
     C                   ENDIF
      *
     C                   ENDDO
      *
      **  Move back original value of ZDAYNO.
      *
     C                   Z-ADD     ZDAYNT        ZDAYNO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*
     C*
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
     C                   ELSE
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
      /EJECT
     C*
**CTDATA CPY@
(c) Finastra International Limited 2001
