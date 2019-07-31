     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Fnd nbr wrkg days fwd (2 ccy pgm)')
/*E*I****FIXNBR(*ZONED)************************************************                       174621
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *    ZF2C - Find the number of working days forward for 2 ccys  *
      *                                                               *
      *  Function:     This module will calculate up to 99 working    *
      *  days forward from a given date for any two currencies and    *
      *  such that it is a working day for both currencies.           *
      *  NB: A day is a working day only if it is a working day for   *
      *      both currencies.                                         *
      *  If required no. of days forward is zero and input date is a  *
      *  holiday in either currency, then the result is the next      *
      *  working day for both currencies, otherwise it is the input   *
      *  date.  This is equivalent to going one working day forward   *
      *  for two currencies.                                          *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZF2C          *
      *  subroutine.  The subroutine consists of three /COPY members. *
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
      *  It contains the converted code from the following /COPY      *
      *  members:                                                     *
      *                                                               *
      *                ZHOLE                                          *
      *                ZHOLI                                          *
      *                ZACCH                                          *
      *                ZCHKH                                          *
      *                                                               *
      *  Component of: ZA_ALL - ZA all modules service program.       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. 174621             Date 03Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 139277             Date 21Jul98               *
      *                 CAP002  *CREATE    Date 14Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  174621 - FIXNBR(*ZONED) now incorporated into RPGBASEMOD     *
      *           creation parameter                                  *
      *  139277 - Creation parameters changed to rectify decimal data *
      *           error problem.                                      *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
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
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** +--- The converted ZF2CE starts here --------------------------+
     D*ZHLA***         S              1    DIM(366)
     D*ZHLB***         S              1    DIM(366)
      *
      * Arrays to hold holiday fields for each individual currency
      * when using two currencies
      ** +--- The converted ZF2CE ends here --------------------------+
      *
      ** +--- The converted ZF2CI starts here --------------------------+
     D ZHLADS          DS
      *
      * Data structure to define input fields for first ccy
      *
     D  ZCCY1                  1      3
     D  ZLOC1                  4      6
     D  @ZFSTI                 1      6
      *
     D  ZDS11                  7    192
     D  ZDS12                193    372
     D  ZHLA                   7    372    DIM(366)
      *
     D ZHLBDS          DS
      *
      * Data structure to define input fields for second ccy
      *
     D  ZCCY2                  1      3
     D  ZLOC2                  4      6
     D  @ZSECI                 1      6
      *
     D  ZDS21                  7    192
     D  ZDS22                193    372
     D  ZHLB                   7    372    DIM(366)
      *
      *
     D ZVARS2          DS
      *
      * Data structure to define variables used in holiday sub-routine
      * for two currencies
      *
     D  ZSCCY1                 1      3
     D  ZSLOC1                 4      6
     D  @ZCLS1                 1      6
     D  ZSYR1                  7     10  0
     D  ZSJAN1                11     13P 0
     D  ZSDEC1                14     16P 0
     D  RTNCD1                17     23
     D  @ZFSTS                 1     23
      *
     D  ZSCCY2                24     26
     D  ZSLOC2                27     29
     D  @ZCLS2                24     29
     D  ZSYR2                 30     33  0
     D  ZSJAN2                34     36P 0
     D  ZSDEC2                37     39P 0
     D  RTNCD2                40     46
     D  @ZSECS                24     46
      *
      ** +--- The converted ZF2CI ends here --------------------------+
      *
      ** +--- Start of D-specs converted from ZHOLE ----------------------+
 
     D ZHL1            S              1    DIM(366)
      *
      * Arrays to split holiday fields into 1-bit elements
      *
 
      ** +--- End of D-specs converted from ZHOLE ------------------------+
 
      ** +--- Start of D-specs converted from ZHOLI ----------------------+
 
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
 
      ** +--- End of D-specs converted from ZHOLI ------------------------+
 
     D DateIn          S                   LIKE(ZDAYNO)
     D FirstCcy        S                   LIKE(ZCCY)
     D FirstLoc        S                   LIKE(ZLOC)
     D SecondCcy       S                   LIKE(ZCCY)
     D SecondLoc       S                   LIKE(ZLOC)
     D NumDaysFwd      S                   LIKE(ZNRDYS)
     D DayNumber       S                   LIKE(ZDYNBR)
 
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
 
      ** Copy the received values to the subroutine fields and pass control
      ** to the subroutine
     C                   EVAL      ZDAYNO = Datein
     C                   EVAL      ZCCY1  = FirstCcy
     C                   EVAL      ZLOC1  = FirstLoc
     C                   EVAL      ZCCY2  = SecondCcy
     C                   EVAL      ZLOC2  = SecondLoc
     C                   EVAL      ZNRDYS = NumDaysFwd
     C                   EVAL      ZDYNBR = DayNumber
 
     C** Initialise arrays.
     C                   MOVE      *BLANKS       @ZFSTS
     C                   MOVE      *BLANKS       @ZSECS
 
      ** +--- The converted ZF2C starts here --------------------------+
     C** Define input parameters
     C*
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   MOVE      ZCCY1         ZCCY1             3
     C                   MOVE      ZLOC1         ZLOC1             3
     C                   MOVE      ZCCY2         ZCCY2             3
     C                   MOVE      ZLOC2         ZLOC2             3
     C                   Z-ADD     ZNRDYS        ZNRDYS            2 0
     C*
     C** Define Output parameters
     C*
     C                   Z-ADD     0             ZDYNBR            5 0
     C*
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   MOVE      ZCCY1         ZCCY              3
     C                   MOVE      ZLOC1         ZLOC              3
     C                   MOVE      ZCCY2         ZCCY              3
     C                   MOVE      ZLOC2         ZLOC              3
     C                   Z-ADD     ZNRDYS        ZNRDYS            2 0
     C** Move input date to output date
     C*
     C                   Z-ADD     ZDAYNO        ZDYNBR
     C*
     C** If input parms for first ccy. equals first stored value (ie ccy
     C** and loc match and date is between 1st Jan & 31st Dec), then
     C** continue processing
     C*
     C     @ZFSTI        IFEQ      @ZCLS1                                       IF 1
     C     ZSJAN1        ANDLE     ZDAYNO                                        AND
     C     ZDAYNO        ANDLE     ZSDEC1                                        AND
     C*
     C** If input parms for sec. ccy. not equal to sec. stored value
     C** (ie. ccy/loc do not match or date is not between 1st Jan &
     C** 31st Dec), then need to get holiday record.
     C*
     C     @ZSECI        IFNE      @ZCLS2                                        IF 2
     C     ZDAYNO        ORLT      ZSJAN2                                         OR
     C     ZDAYNO        ORGT      ZSDEC2                                         OR
     C*
     C** Set up parms, get record and move result to second stored value
     C*
     C                   MOVE      '*SETGT '     ZOPTN
     C*
     C                   MOVE      @ZSECI        @ZWRKI
     C                   EXSR      ZACCH
     C*
     C                   MOVE      @ZWRKO        @ZSECS
     C                   MOVE      ZHL           ZHLB
     C*
     C                   END                                                     FI 2
     C*
     C** At this point both sets of stored values are correct. No more
     C** processing will be done.
     C*
     C                   ELSE                                                   ELSE 1
     C*
     C** First input value not equal to first stored value, but may be
     C** equal to second stored value
     C*
     C     @ZFSTI        IFEQ      @ZCLS2                                        IF 2
     C     ZSJAN2        ANDLE     ZDAYNO                                         AND
     C     ZDAYNO        ANDLE     ZSDEC2                                         AND
     C*
     C** Second input value may not be equal to first stored value
     C*
     C     @ZSECI        IFNE      @ZCLS1                                         IF 3
     C     ZDAYNO        ORLT      ZSJAN1                                          OR
     C     ZDAYNO        ORGT      ZSDEC1                                          OR
     C*
     C** Need to access holiday record, so set up parms, get record and
     C** move results to first stored value
     C*
     C                   MOVE      '*SETGT '     ZOPTN
     C*
     C                   MOVE      @ZSECI        @ZWRKI
     C                   EXSR      ZACCH
     C*
     C                   MOVE      @ZWRKO        @ZFSTS
     C                   MOVE      ZHL           ZHLA
     C*
     C                   END                                                      FI 3
     C*
     C** At this point both sets of stored values are correct. No more
     C** processing will be done.
     C*
     C                   ELSE                                                    ELSE 2
     C*
     C** Here, we can only say that first input value does not equal
     C** either stored value, but second input value may equal one of
     C** them. If it equals second, then set up parms, with first stored
     C** values, get record and move result to first stored value.
     C*
     C     @ZSECI        IFEQ      @ZCLS2                                         IF 3
     C     ZSJAN2        ANDLE     ZDAYNO                                          AND
     C     ZDAYNO        ANDLE     ZSDEC2                                          AND
     C*
     C                   MOVE      '*SETGT '     ZOPTN
     C*
     C                   MOVE      @ZFSTI        @ZWRKI
     C                   EXSR      ZACCH
     C*
     C                   MOVE      @ZWRKO        @ZFSTS
     C                   MOVE      ZHL           ZHLA
     C*
     C** At this point both sets of stored values are correct. No more
     C** processing will be done.
     C*
     C                   ELSE                                                     ELSE 3
     C*
     C** Second input does not equal second stored, but may equal first
     C*
     C     @ZSECI        IFEQ      @ZCLS1                                          IF 4
     C     ZSJAN1        ANDLE     ZDAYNO                                           AND
     C     ZDAYNO        ANDLE     ZSDEC1                                           AND
     C*
     C** Set up parms. for first input, get record and move result to
     C** second stored value (since second input equals first stored).
     C*
     C                   MOVE      '*SETGT '     ZOPTN
     C*
     C                   MOVE      @ZFSTI        @ZWRKI
     C                   EXSR      ZACCH
     C*
     C                   MOVE      @ZWRKO        @ZSECS
     C                   MOVE      ZHL           ZHLB
     C*
     C** At this point both sets of stored values are correct. No more
     C** processing will be done.
     C*
     C                   ELSE                                                      ELSE 4
     C*
     C** Otherwise, neither input value equals either of the stored
     C** values, so get records for both input values.
     C*
     C                   MOVE      '*SETGT '     ZOPTN
     C*
     C                   MOVE      @ZFSTI        @ZWRKI
     C                   EXSR      ZACCH
     C*
     C                   MOVE      @ZWRKO        @ZFSTS
     C                   MOVE      ZHL           ZHLA
     C*
     C                   MOVE      @ZSECI        @ZWRKI
     C                   EXSR      ZACCH
     C*
     C                   MOVE      @ZWRKO        @ZSECS
     C                   MOVE      ZHL           ZHLB
     C*
     C                   END                                                       FI 4
     C*
     C                   END                                                      FI 3
     C*
     C                   END                                                     FI 2
     C*
     C                   END                                                    FI 1
     C*
     C** Holiday arrays have been set up correctly and so can now find
     C** the working day required.
     C*
     C** If both currencies returned no record found, then just add
     C** required no. of days forward to input date to give output date.
     C*
     C     RTNCD1        IFEQ      '*NRF   '                                    IF 1
     C     RTNCD2        ANDEQ     '*NRF   '                                     AND
     C*
     C     ZDAYNO        ADD       ZNRDYS        ZDYNBR
     C*
     C                   ELSE                                                   ELSE 1
     C*
     C** Otherwise, need to step through year counting working days
     C*
     C** First, check that we have 1st Jan & 31st Dec dates; if not,
     C** then move values from first record in.
     C*
     C     RTNCD2        IFEQ      '*NRF   '                                     IF 2
     C                   Z-ADD     ZSJAN1        DGJDNB
     C                   Z-ADD     ZSDEC1        DGDDNB
     C                   END                                                     FI 2
     C*                                                                   060712
     C     RTNCD1        IFEQ      '*NRF   '                                     IF 2          06071
     C                   Z-ADD     ZSJAN2        DGJDNB                                        06071
     C                   Z-ADD     ZSDEC2        DGDDNB                                        06071
     C                   END                                                     FI 2          06071
      *                                                                   096087
     C     RTNCD1        IFEQ      *BLANKS                                       IF 2          09608
     C     RTNCD2        ANDEQ     *BLANKS                                                     09608
     C                   Z-ADD     ZSJAN1        DGJDNB                                        09608
     C                   Z-ADD     ZSDEC1        DGDDNB                                        09608
     C                   END                                                     FI 2          09608
     C*
     C** Subtract 1st. Jan date from input date and add 1 to give day in
     C** year index.
     C*
     C     ZDAYNO        SUB       DGJDNB        ZINDX
     C                   ADD       1             ZINDX
     C*
     C** If no. of days required is zero and date is a holiday in either
     C** currency, then make required no. of days equal to one.
     C*
     C     ZNRDYS        IFEQ      0                                             IF 2
     C     ZHLA(ZINDX)   ANDEQ     'X'                                            AND
     C     ZNRDYS        OREQ      0                                              OR
     C     ZHLB(ZINDX)   ANDEQ     'X'                                            AND
     C                   ADD       1             ZNRDYS
     C                   END                                                     FI 2
     C*
     C** While we still have days to find, continue processing
     C*
     C     ZNRDYS        DOWGT     0                                             DOW 1
     C*
     C** Add one to index and to output date
     C*
     C                   ADD       1             ZINDX
     C                   ADD       1             ZDYNBR
     C*
     C** If output date is beyond 31st. Dec date, then need to get
     C** next holiday record for both currencies.
     C*
     C     ZDYNBR        IFGT      DGDDNB                                         IF 1
     C*
     C** Current output date is new input date
     C*
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C*
     C                   MOVE      '*SETGT '     ZOPTN
     C*
     C                   MOVE      @ZFSTI        @ZWRKI
     C                   EXSR      ZACCH
     C*
     C                   MOVE      @ZWRKO        @ZFSTS
     C                   MOVE      ZHL           ZHLA
     C*
     C                   MOVE      @ZSECI        @ZWRKI
     C                   EXSR      ZACCH
     C*
     C                   MOVE      @ZWRKO        @ZSECS
     C                   MOVE      ZHL           ZHLB
     C*
     C** If no record was found for both currencies then add no. of days
     C** left to find to output date and subtract one to give required
     C** result and change no. left to find to zero to terminate loop.
     C*
     C     RTNCD1        IFEQ      '*NRF   '                                       IF 2
     C     RTNCD2        ANDEQ     '*NRF   '                                        AND
     C*
     C                   ADD       ZNRDYS        ZDYNBR
     C                   SUB       1             ZDYNBR
     C                   Z-ADD     0             ZNRDYS
     C*
     C                   ELSE                                                      ELSE 2
     C*
     C** Check that we have 1st Jan & 31st Dec dates; if not, then move
     C** values from first record in.
     C*
     C     RTNCD2        IFEQ      '*NRF   '                                        IF 3
     C                   Z-ADD     ZSJAN1        DGJDNB
     C                   Z-ADD     ZSDEC1        DGDDNB
     C                   END                                                        FI 3
     C*
     C** Reset day in year value to one.
     C*
     C                   Z-ADD     1             ZINDX
     C*
     C                   END                                                       FI 2
     C*
     C                   END                                                      FI 1
     C*
     C** If day is a working day in BOTH currencies, then no. left to
     C** find is one less.
     C*
     C** Do this only if No. of days required is not zero.                068225
     C*                                                                   068225
     C     ZNRDYS        IFNE      0                                              IF 1         06822
     C     ZHLA(ZINDX)   IFEQ      ' '                                            IF 1
     C     ZHLB(ZINDX)   ANDEQ     ' '                                             AND
     C                   SUB       1             ZNRDYS
     C                   END                                                      FI 1
     C                   END                                                      FI 1         06822
     C*
     C                   END                                                     ENW 1
     C*
     C                   END                                                    FI 1
     C*
      ** +--- The converted ZF2C ends here --------------------------+
     C*
     C                   EVAL      DayNumber = ZDYNBR
 
     C                   RETURN
 
     C*****************************************************************
      /EJECT
      ** +--- Start of subroutine converted from ZACCH -------------------+
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
     C                   CALLB     'AOHOLS0'
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
     C                   CALLB     'AOHOLS0'
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
      ** +--- End of subroutine converted from ZACCH ---------------------+
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
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      **
      ** Beginning date (5,0P, from caller) - the day number, as a
      ** number of days from 31DEC71, that we wish to calculate the
      ** number of days forward from.
     C                   PARM                    DateIn
      **
      ** First Currency (3A from caller)
     C                   PARM                    FirstCcy
      **
      ** First Location (3A from caller) This field is optional and should
      ** be blank if no location is to be specified.
     C                   PARM                    FirstLoc
      **
      ** Second Currency (3A from caller)
     C                   PARM                    SecondCcy
      **
      ** Second Location (3A from caller) This field is optional and should
      ** be blank if no location is to be specified.
     C                   PARM                    SecondLoc
      **
      ** Number of days forward to be calculated (2,0 from caller)
      ** Note that zero is a valid value.
     C                   PARM                    NumDaysFwd
 
      ** Day Number (5,0 returned to caller)
      ** The calculated value of the nth working day forward from the input
      ** date, in Midas Day number format.
     C                   PARM                    DayNumber
 
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
