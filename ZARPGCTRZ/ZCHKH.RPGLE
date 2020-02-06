     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Check whether date is a holiday in curr')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZCHKH - Check whether date is a holiday in specified currency*
      *                                                               *
      *  Function:  This module checks whether a received date is a   *
      *             holiday in the received currency and location.    *
      *                                                               *
      *             This module is an ILE conversion of the ZSRSRC    *
      *             standard subroutine ZCHKH.  As such, it contains  *
      *             the converted code from the following /COPY       *
      *             members:                                          *
      *                                                               *
      *                ZHOLE                                          *
      *                ZHOLI                                          *
      *                ZACCH                                          *
      *                ZCHKH                                          *
      *                                                               *
      *  Component of: ZA_ALL - all ZA modules service program        *
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
      *  Prev Amend No. BG19041            Date 03Jun08               *
      *                 BUG14806A          Date 14Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG19041 - Moved fix 248676 from source found in ZARPGSRCZ.   *
      *            Made source from ZARPGSRCZ redundant.              *
      *  248676 - Holiday warning displaying incorrectly.             *
      *  BUG14806A - Recompile Program due to Decimal Error           *
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DateIn          S                   LIKE(ZDAYNO)
     D Currency        S                   LIKE(ZCCY)
     D Location        S                   LIKE(ZLOC)
     D HolInd          S                   LIKE(ZIND)
 
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
     C                   EVAL      ZCCY = Currency
     C                   EVAL      ZLOC = Location
 
     C                   EXSR      ZCHKH
 
      ** Copy the return value to the parameter field
     C                   EVAL      HolInd = ZIND
 
     C                   RETURN
 
      ** +--- Start of subroutine converted from ZCHKH -------------------+
 
      *****************************************************************
      /EJECT
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
     C     RTNCD         IFEQ      '*NRF   '
      *
     C                   MOVE      'W'           ZIND
      *
     C                   ELSE
      *
      * Subtract 1st. Jan date from given date and add 1 to give the
      * nth day in the year (ZINDX).
      *
     C     ZDAYNO        SUB       DGJDNB        ZINDX
     C                   ADD       1             ZINDX
      *
      * Move the nth day in the year value to the holiday indicator
      *
     C                   MOVE      ZHL(ZINDX)    ZIND
      *
      * If holiday indicator is 'X' change to 'H' to show holiday
      *
     C     ZIND          IFEQ      'X'
     C                   MOVE      'H'           ZIND
     C                   ELSE
     C                   MOVE      'W'           ZIND
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ** +--- End of subroutine converted from ZCHKH ---------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
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
     C                   MOVE      ZZLOC         Location                                     248676
      *                                                                                       248676
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
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    DateIn
     C                   PARM                    Currency
     C                   PARM                    Location
     C                   PARM                    HolInd
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
