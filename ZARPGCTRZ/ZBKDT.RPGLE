     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA: Find Nth working date previous')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZBKDT   -   Find Nth working day previous                    *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZBKDT         *
      *  subroutine.  The subroutine consists of one /COPY member.    *
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
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP002  *CREATE    Date 21Apr98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
     D Holidays        DS
     D  ZHLField               1    366
     D  ZHL                    1    366
     D                                     DIM(366)                             CR01-12 ARRAY
 
      * Working variables
     D @ZWRDY          S              2S 0
     D ZINDX           S              3S 0
 
     D ZOPTN           S              7A
     D RTNCD           S              7A
     D DGJDNB          S              5P 0
     D DGDDNB          S              5P 0
 
      ** +-----------------------------------------------------------------+
 
      ** Execute the standard subroutine
     C                   EXSR      ZBKDT
 
     C                   RETURN
 
      ** +--- The converted ZBKDT starts here --------------------------+
      /EJECT
      *****************************************************************
     C     ZBKDT         BEGSR
      *
      * Standard sub-routine to calculate up to 99 working days back
      * from a given start date.
      * NB. Must be used in conjunction with ZACCH.
      *
      * NB: If required no. of working days back is zero, then:-
      *       if input date is a working day, then result is input date
      *       else result is first working day before input date.
      *
      *     If required no. of working days back is one, then:-
      *       if input date is a working day, then result is previous
      *       working day
      *       else result is first working day before input date.
      *
      * Thus, if input date is a holiday, then zero and one working day
      * back will return the same result.
      *
      **
      *Define input parameters
      **
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   MOVE      ZLOC          ZLOC              3                           S0119
     C                   Z-ADD     ZNRDYS        ZNRDYS            2 0
      **
      *Define Output parameters
      **
     C                   Z-ADD     0             ZDYNBR            5 0
      *
      * Move input date to output date
      *
     C                   Z-ADD     ZDAYNO        ZDYNBR
      *
      * Get holiday record
      *
     C                   MOVE      '*SETGT '     ZOPTN
      *
     C                   EXSR      ZACCH
      *
      * If no record was found, subtract no. of days back from input
      * date and then try to find record again.
      *
     C     RTNCD         IFEQ      '*NRF   '                                    IF 1
      *
      * Set up new input day number to get record
      *
     C     ZDAYNO        SUB       ZNRDYS        ZDAYNO
      *
     C                   MOVE      '*PREV  '     ZOPTN
      *
     C                   EXSR      ZACCH
      *
      * Move input date back again; is still in output date field.
      *
     C                   Z-ADD     ZDYNBR        ZDAYNO
      *
      * If still no record found, then just subtract no. of working
      * days back required from input date to get output date.
      *
     C     RTNCD         IFEQ      '*NRF   '                                     IF 2
      *
     C     ZDAYNO        SUB       ZNRDYS        ZDYNBR
      *
     C                   ELSE                                                    ELSE 2
      *
      * Otherwise, need to step back through the year and count the
      * working days until we get to the value required. Subtracting
      * 31st. Dec date from input date and subtracting one gives no.
      * of working days in this year (@ZWRDY).
      *
     C     ZDAYNO        SUB       DGDDNB        @ZWRDY
     C                   SUB       1             @ZWRDY
      *
      * Need to count working days in previous year; subtract no. in
      * this year to give no. left to find; find position of 31st. Dec
      * for previous year. Subtract no. of working days in this year
      * from output date.
      *
     C     ZNRDYS        SUB       @ZWRDY        ZNRDYS
     C     ZDYNBR        SUB       @ZWRDY        ZDYNBR
      *
     C     DGDDNB        SUB       DGJDNB        ZINDX
     C                   ADD       2             ZINDX
      *
     C                   EXSR      ZCNTDY
      *
     C                   END                                                     FI 2
      *
     C                   ELSE                                                   ELSE 1
      *
      * Otherwise, we have a record and so need to count working days
      * Subtract 1st. Jan from input date and add 1 to give day in year
      * index.
      *
     C     ZDAYNO        SUB       DGJDNB        ZINDX
     C                   ADD       1             ZINDX
      *
     C                   EXSR      ZCNTDY
      *
     C                   END                                                    FI 1
      *
     C                   ENDSR
      *
      *****************************************************************
      *
     C     ZCNTDY        BEGSR
      *
      * Since the following code would be duplicated in the main
      * sub-routine, it is put in a separate one for clarity.
      *
      * If no. of working days required is zero and input date is a
      * holiday, then change required no. of days to one.
      *
     C     ZNRDYS        IFEQ      0
     C     ZHL(ZINDX)    ANDEQ     'X'
     C                   ADD       1             ZNRDYS
     C                   END
      *
      * While we still need to find a working day, continue processing.
      *
     C     ZNRDYS        DOWGT     0                                            DOW 1
      *
      * Subtract one from day in year index and output date
      *
     C                   SUB       1             ZINDX
     C                   SUB       1             ZDYNBR
      *
      * If output date is beyond stored 1st. Jan date, then need to
      * get prev holiday record with new parameters: output date is new
      * input date; no. of days back is current no. of days left to
      * find.
      *
     C     ZDYNBR        IFLT      DGJDNB                                        IF 1
      *
     C                   Z-ADD     ZDYNBR        ZDAYNO
      *
     C                   MOVE      '*SETGT '     ZOPTN
      *
     C                   EXSR      ZACCH
      *
      * If no record was found, then subtract no. of days left to find
      * from output date and add 1 to give required result and change
      * no. left to find to zero to terminate loop.
      * Change day in year index to one to avoid errors.
      *
     C     RTNCD         IFEQ      '*NRF   '                                      IF 2
      *
     C                   SUB       ZNRDYS        ZDYNBR
     C                   ADD       1             ZDYNBR
     C                   Z-ADD     0             ZNRDYS
     C                   Z-ADD     1             ZINDX
      *
     C                   ELSE                                                     ELSE 2
      *
      * Otherwise, reset day in year value.
      *
     C     ZDAYNO        SUB       DGJDNB        ZINDX
     C                   ADD       1             ZINDX
      *
     C                   END                                                      FI 2
      *
     C                   END                                                     FI 1
      *
      * If holiday index value is ' ' then need to find one day less
      *
     C     ZHL(ZINDX)    IFEQ      ' '                                           IF 1
     C                   SUB       1             ZNRDYS
     C                   END                                                     FI 1
      *
     C                   END                                                    ENW 1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
 
      ** +--- The converted ZBKDT ends here ----------------------------+
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZBKDT in this module executes another standard subroutine,       *
      *   ZACCH, which has also been converted to a module.                *
      *  This subroutine is also called ZACCH and simply does a CALLB to   *
      *   the module that contains subroutine ZACCH                        *
      *                                                                    *
     C     ZACCH         BEGSR
 
     C                   CALLB     'ZACCH'
      * Input
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC                                          S0119
     C*******************PARM                    ZNRDYS
     C                   PARM                    ZOPTN
      * Output
     C                   PARM                    RTNCD
     C                   PARM                    DGJDNB
     C                   PARM                    DGDDNB
     C                   PARM                    ZHLField                                      S0119
 
     C                   ENDSR
      **********************************************************************
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
 
      * INPUTS
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZNRDYS
 
      * OUTPUTS
     C                   PARM                    ZDYNBR
 
     C                   ENDSR
 
      *****************************************************************
