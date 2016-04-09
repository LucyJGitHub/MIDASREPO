     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Export Control Information Update')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXCTUPD - Export Control Information Update                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 240745             Data 06Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  240745 - Calculate previous run date rather than use date    *
      *           on JNSTAT.                                          *
      *  CMX001 - Meridian Export                                     *
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
     D                 DS
     D Z_DATEN                 1      6S 0
     D Z_DD                    1      2S 0
     D Z_MM                    3      4S 0
     D Z_YY                    5      6S 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
     D  ExpData                1    100
 
     D JNSTAT          DS           200
     D PRUN                  103    105P 0
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#COB             1
      * OUTPUT
      * Start of Month (Y/N)
     C                   PARM                    S_O_Month         1
 
      * Clear output
 
     C                   MOVE      'N'           S_O_Month
 
      * Calculate the monthly dates
 
     C                   EXSR      CAL_MDAT
 
      * Get extract control data
 
     C     *LOCK         IN        MXEXPCTL
 
      * Update Monthly Dates
 
     C                   Z-ADD     N_CUREOM      CUREOM
     C                   Z-ADD     N_CURSOM      CURSOM
     C                   Z-ADD     N_PRVSOM      PRVSOM
 
      * Update Run Dates and Next Working Day
 
     C                   Z-ADD     BJRDNB        CURRUN
     C                   Z-ADD     BJDNWD        CURNWD
     C**********         Z-ADD     PRUN          PRVRUN                                       240745
                                                                                              240745
      * Caluclate Previous Rundate as old PRUN can be wrong if input cycle is reopened        240745
                                                                                              240745
     C                   Callb     'RVFBDT'                                                   240745
     C                   Parm      BJRDNB        ZDAYNO            5 0                        240745
     C                   Parm      1             ZNRDYS            2 0                        240745
     C                   Parm                    ZDYNBR            5 0                        240745
     C                   Parm      BJLCCY        ZCCY              3                          240745
     C                   Parm      '***'         ZLOC              3                          240745
      *                                                                                       240745
     C                   Z-ADD     ZDYNBR        PRVRUN                                       240745
 
      * If this function is being called in the COB
      *  It is the start of the month
      *  if the previous run date is prior to the start of month date
      *  or if the 'trigger start of month processing' indicator is 'YES'
 
     C     I#COB         IFEQ      'Y'
     C     PRVRUN        IFLT      CURSOM
     C     TRGSOM        OREQ      'Y'
     C                   MOVE      'Y'           S_O_Month
     C                   MOVE      'N'           TRGSOM
     C                   ENDIF
     C                   ENDIF
 
      * Update extract control data
 
     C                   OUT       MXEXPCTL
 
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Calculate the monthly dates
      ********************************************************************
     C     CAL_MDAT      BEGSR
 
      * Current End of Month Date
      * -------------------------
 
      * Convert run date to day number
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        Z_DATEN
 
     C                   Z-ADD     1             Z_DD
     C                   ADD       1             Z_MM
     C     Z_MM          IFGT      12
     C                   Z-ADD     1             Z_MM
     C                   ADD       1             Z_YY
     C                   ENDIF
 
      * Convert back to a day number
 
     C                   MOVEL     Z_DATEN       ZDATEI
     C                   EXSR      ZDATE1
     C     ZDAYNO        SUB       1             N_CUREOM          5 0
 
      * Current Start Of Month Date
      * ---------------------------
 
      * Convert run date to day number
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        Z_DATEN
 
     C                   Z-ADD     1             Z_DD
 
      * Convert back to a day number
 
     C                   MOVEL     Z_DATEN       ZDATEI
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        N_CURSOM          5 0
 
      * Previous Start Of Month Date
      * ----------------------------
 
      * Convert run date to day number
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        Z_DATEN
 
     C                   Z-ADD     1             Z_DD
     C                   SUB       1             Z_MM
     C     Z_MM          IFEQ      0
     C                   Z-ADD     12            Z_MM
     C                   SUB       1             Z_YY
     C                   ENDIF
 
      * Convert back to a day number
 
     C                   MOVEL     Z_DATEN       ZDATEI
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        N_PRVSOM          5 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Convert a date to a day number
      *****************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM      'D'           ZZDFIN            1
     C                   PARM                    ErrorFlag         1
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Convert a day number to a date
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      'D'           ZZDFIN            1
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * DATABASE ERROR
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      * Get extract control data
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C     *LOCK         IN        MXEXPCTL
 
      * Default if no details
 
     C     ExpData       IFEQ      *BLANK
     C                   Z-ADD     0             CUREOM
     C                   Z-ADD     0             CURSOM
     C                   Z-ADD     0             PRVSOM
     C                   Z-ADD     0             CURRUN
     C                   Z-ADD     0             CURNWD
     C                   Z-ADD     0             PRVRUN
     C                   MOVEL     'N'           TRGSOM
     C                   MOVEL     'N'           TRACDX
     C                   MOVEL     'N'           TRACDT
     C                   MOVEL     'N'           TRACBX
     C                   MOVEL     'N'           TRACBT
     C                   MOVEL     'N'           DIAGEV
     C                   MOVEL     'N'           MNTRAC
     C                   MOVEL     'D'           SDFQDL
     C                   MOVEL     'M'           SDFQGL
     C                   MOVEL     'D'           SDFQLE
     C                   MOVEL     'D'           SDFQRE
     C                   MOVEL     'D'           SDFQSE
     C                   ENDIF
 
      * Update extract control data
 
     C                   OUT       MXEXPCTL
 
      * Get JNSTAT control data
 
     C     *DTAARA       DEFINE                  JNSTAT
     C     *LOCK         IN        JNSTAT
     C                   OUT       JNSTAT
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
