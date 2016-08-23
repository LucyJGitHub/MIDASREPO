     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA: Access a record from the holiday file')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZACCH   -   Access a record from the holiday file            *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZACCH         *
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
 
      ** Array originally declared in /COPY ZHOLE
     D ZHL1            S              1    DIM(366)
      * Arrays to split holiday fields into 1-bit elements
 
      *  Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * Data structure defined over holiday file fields
     D ZHOLDS          DS
     D  DGCYCD                 1      3
     D  DGLCCD                 4      6
     D  DGYRNB                 7     10  0
     D  DGJDNB                11     13P 0
     D  DGDDNB                14     16P 0
     D  ZDS1                  17    202
     D  ZDS2                 203    382
     D  ZHL                   17    382    DIM(366)
 
     D ZSCCY           S                   LIKE(ZCCY)
     D ZZCCY           S                   LIKE(ZCCY)
     D ZSLOC           S                   LIKE(ZLOC)
     D ZZLOC           S                   LIKE(ZLOC)
     D ZSJAN           S                   LIKE(ZDAYNO)
     D ZSDCM           S                   LIKE(ZDAYNO)
     D RTNCD           S              7A
     D ZSRTN           S                   LIKE(RTNCD)
 
     D ZHLField        S            366A
 
      ** +-----------------------------------------------------------------+
 
 
     C                   EXSR      ZACCH
 
      ** Processing required after standard subroutine
      **  Place array of flags into a field for return
     C                   MOVEA     ZHL           ZHLField
 
     C                   RETURN
 
      ** +--- The converted ZACCH starts here --------------------------+
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
     C     ZHOLDS        PARM      ZHOLDS        DSSDY
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
      ** +--- The converted ZACCH ends here ----------------------------+
 
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
 
      * INPUT
 
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZOPTN
 
      * OUTPUT
      * (ZSJAN/ZSDCM = DGJDNB/DGDDNB)
 
     C                   PARM                    RTNCD
     C                   PARM                    ZSJAN
     C                   PARM                    ZSDCM
     C                   PARM                    ZHLField
 
     C                   ENDSR
      *****************************************************************
