     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Purge records from SCJSEQPD')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC002474 - Purge records from journal sequence number file,  *
      *              SCJSEQPD.                                        *
      *                                                               *
      *  Function: This module is used to purge old records from      *
      *            file SCJSEQPD.                                     *
      *                                                               *
      *  Component of: SC002474                                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 242614             Date 27Sep06               *
      *                 CSC020  *CREATE    Date 31Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  242614 - Remove unneccesary DUMP so as not to cause SCC0405  *
      *           to fail during COB.                                 *
      *  CSC020 - Journaling changes for MidasPlus.                   *
      *                                                               *
      *****************************************************************
     FSCJSEQPD  UF   E             DISK
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA Layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
     D SVALKK          C                   CONST('ReceiverRetainDays')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     I* Second DS for access programs, long data structure
     DDSSDY          E DS                  EXTNAME(DSSDY)
      **  Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL12                   1      2
      *
     DZHL              S              1    DIM(366)
     DZHL1             S              1    DIM(366)
      *
      * Data structure defined over holiday file fields
      *
     DZHOLDS           DS
     D DGCYCD                  1      3
     D DGLCCD                  4      6
     D DGYRNB                  7     10  0
     D DGJDNB                 11     13P 0
     D DGDDNB                 14     16P 0
     D ZDS1                   17    202
     D ZDS2                  203    382
     D ZHLZ                   17    382
      *
      * Data structure to define variables used in holiday sub-routines
      *
     DZVARS            DS
     D ZIND                    1      1
     D ZINDX                   2      4  0
     D ZDAYNO                  5      7P 0
     D ZDYNBR                  8     10P 0
     D ZNRDYS                 11     12  0
     D @ZWRDY                 13     14  0
     D ZCCY                   15     17
     D ZLOC                   18     20
     D @ZWRKI                 15     20
     D ZSCCY                  21     23
     D ZSLOC                  24     26
     D ZSWEXX                 27     30  0
     D ZSJAN                  31     33P 0
     D ZSDCM                  34     36P 0
     D RTNCD                  37     43
     D @ZWRKO                 21     43
     D ZOPTN                  44     50
     D ZZCCY                  51     53
     D ZZLOC                  54     56
     D ZZDYNO                 57     59P 0
     D ZSRTN                  60     66
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D ControlDate     S              5  0
      *
      **  Set up error variables
      *
     C                   move      *BLANKS       DBFILE            8
     C                   move      *BLANKS       DBKEY            29
     C                   move      *BLANKS       DBPGM            10
     C                   movel     'SC002474'    DBPGM
     C                   z-add     0             DBASE             3 0
      *
      **  Access Bank details.
      *
     C                   call      'AOBANKR0'
     C                   parm      *BLANKS       PRTCD             7
     C                   parm      '*FIRST '     POPTN             7
     C     SDBANK        parm      SDBANK        DSFDY
      *
     C                   if        PRTCD <> *BLANKS
      *
     C                   movel     'SDBANKPD'    DBFILE
     C                   movel     '001'         DBASE
     C                   movel     POPTN         DBKEY
     C                   exsr      *PSSR
      *
     C                   endif
      *
      *  Access journal receiver save days system value
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD             7
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
 
     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK0        DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
 
     C     *LOCK         IN        LDA
     C                   MOVEL     '002'         DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'SC002474'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Change number of days to numeric value and increment by 1.
      *
     C                   move      SVAL12        ZNRDYS            2 0
     C                   eval      ZNRDYS = ZNRDYS + 1
      *
      *  Calculate control date, the date beyond which journal receivers may be deleted.
      *
     C                   eval      ZDAYNO = BJRDNB
     C                   eval      ZCCY = BJLCCY
     C                   eval      ZLOC = '   '
     C                   exsr      ZBKDT
     C                   eval      ControlDate = ZDYNBR
     C**********         dump                                                                 242614
      *
      *  While end of file SCJSEQPD is not reached,
      *
     C     *IN01         doweq     *OFF
      *
      *  read a record from SCJSEQPD.
      *
     C                   read      SCJSEQPD                               01
      *
      *  If end of file was not reached,
      *
     C     *IN01         ifeq      *OFF
      *
      *  If run date of record is less than control date,
      *
     C     JSRUND        iflt      ControlDate
      *
      *  delete the record.
      *
     C                   delete    SCJSEQD0
      *
     C                   endif
      *
     C                   endif
      *
     C                   enddo
      *
      *  Terminate program and return to caller.
      *
     C                   eval      *INLR = *ON
     C                   return
      /EJECT
      *****************************************************************
     C     zbkdt         begsr
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
     C                   z-add     ZDAYNO        ZDAYNO            5 0
     C                   move      ZCCY          ZCCY              3
     C                   move      ZLOC          ZLOC              3
     C                   z-add     ZNRDYS        ZNRDYS            2 0
      **
      *Define Output parameters
      **
     C                   z-add     0             ZDYNBR            5 0
      *
      * Move input date to output date
      *
     C                   z-add     ZDAYNO        ZDYNBR
      *
      * Get holiday record
      *
     C                   move      '*SETGT '     ZOPTN
      *
     C                   exsr      ZACCH
      *
      * If no record was found, subtract no. of days back from input
      * date and then try to find record again.
      *
     C     RTNCD         ifeq      '*NRF   '                                    IF 1
      *
      * Set up new input day number to get record
      *
     C     ZDAYNO        sub       ZNRDYS        ZDAYNO
      *
     C                   move      '*PREV  '     ZOPTN
      *
     C                   exsr      ZACCH
      *
      * Move input date back again; is still in output date field.
      *
     C                   z-add     ZDYNBR        ZDAYNO
      *
      * If still no record found, then just subtract no. of working
      * days back required from input date to get output date.
      *
     C     RTNCD         ifeq      '*NRF   '                                    IF 2
      *
     C     ZDAYNO        sub       ZNRDYS        ZDYNBR
      *
     C                   else                                                   ELSE 2
      *
      * Otherwise, need to step back through the year and count the
      * working days until we get to the value required. Subtracting
      * 31st. Dec date from input date and subtracting one gives no.
      * of working days in this year (@ZWRDY).
      *
     C     ZDAYNO        sub       DGDDNB        @ZWRDY
     C                   sub       1             @ZWRDY
      *
      * Need to count working days in previous year; subtract no. in
      * this year to give no. left to find; find position of 31st. Dec
      * for previous year. Subtract no. of working days in this year
      * from output date.
      *
     C     ZNRDYS        sub       @ZWRDY        ZNRDYS
     C     ZDYNBR        sub       @ZWRDY        ZDYNBR
      *
     C     DGDDNB        sub       DGJDNB        ZINDX
     C                   add       2             ZINDX
      *
     C                   exsr      ZCNTDY
      *
     C                   end                                                    FI 2
      *
     C                   else                                                   ELSE 1
      *
      * Otherwise, we have a record and so need to count working days
      * Subtract 1st. Jan from input date and add 1 to give day in year
      * index.
      *
     C     ZDAYNO        sub       DGJDNB        ZINDX
     C                   add       1             ZINDX
      *
     C                   exsr      ZCNTDY
      *
     C                   end                                                    FI 1
      *
     C                   endsr
      *
      *****************************************************************
      *
     C     ZCNTDY        begsr
      *
      * Since the following code would be duplicated in the main
      * sub-routine, it is put in a separate one for clarity.
      *
      * If no. of working days required is zero and input date is a
      * holiday, then change required no. of days to one.
      *
     C     ZNRDYS        ifeq      0
     C     ZHL(ZINDX)    andeq     'X'
     C                   add       1             ZNRDYS
     C                   end
      *
      * While we still need to find a working day, continue processing.
      *
     C     ZNRDYS        dowgt     0                                            DOW 1
      *
      * Subtract one from day in year index and output date
      *
     C                   sub       1             ZINDX
     C                   sub       1             ZDYNBR
      *
      * If output date is beyond stored 1st. Jan date, then need to
      * get prev holiday record with new parameters: output date is new
      * input date; no. of days back is current no. of days left to
      * find.
      *
     C     ZDYNBR        iflt      DGJDNB                                       IF 1
      *
     C                   z-add     ZDYNBR        ZDAYNO
      *
     C                   move      '*SETGT '     ZOPTN
      *
     C                   exsr      ZACCH
      *
      * If no record was found, then subtract no. of days left to find
      * from output date and add 1 to give required result and change
      * no. left to find to zero to terminate loop.
      * Change day in year index to one to avoid errors.
      *
     C     RTNCD         ifeq      '*NRF   '                                    IF 2
      *
     C                   sub       ZNRDYS        ZDYNBR
     C                   add       1             ZDYNBR
     C                   z-add     0             ZNRDYS
     C                   z-add     1             ZINDX
      *
     C                   else                                                   ELSE 2
      *
      * Otherwise, reset day in year value.
      *
     C     ZDAYNO        sub       DGJDNB        ZINDX
     C                   add       1             ZINDX
      *
     C                   end                                                    FI 2
      *
     C                   end                                                    FI 1
      *
      * If holiday index value is ' ' then need to find one day less
      *
     C     ZHL(ZINDX)    ifeq      ' '                                          IF 1
     C                   sub       1             ZNRDYS
     C                   end                                                    FI 1
      *
     C                   end                                                    ENW 1
      *
     C                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZACCH         begsr
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
     C                   movea     ZHLZ          ZHL
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
     C                   movea     ZHLZ          ZHL
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
     C                   Z-ADD     DGYRNB        Z@YR              4 0
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
     C                   Z-ADD     ZSJAN         DGJDNB
     C                   Z-ADD     ZSDCM         DGDDNB
     C                   MOVE      ZSRTN         RTNCD
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WDUMP = *BLANKS
     C                   MOVE      'Y'           WDUMP             1
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
 
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
**  CPY@
(c) Finastra International Limited 2004
