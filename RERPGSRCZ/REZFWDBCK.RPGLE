     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Determine Forward and Back Value Dates')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  REZBCKFWD - Determine Forward and Back Value Dates           *
      *                                                               *
      *  Function:  This program is given forward and back dating     *
      *             codes and converts them into days.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 212467             Date 10Jan03               *
      *  Prev Amend No. 212908             Date 07Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  212467 - External Forward and Back Value Sweeping details    *
      *           must be constrained by the ICD.                     *
      *  212908 - Back valued entries swept with wrong value date     *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D                 DS
     D Z_DATEN                 1      6S 0
     D Z_DD                    1      2S 0
     D Z_MM                    3      4S 0
     D Z_YY                    5      6S 0
 
 
     D                 DS
     D NumPer                  1      3
     D Number                  1      2S 0
     D Period                  3      3
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
 
 
      /SPACE 5
 
      * Clear outputs
 
     C                   Z-ADD     *ZERO         O_FVDate
     C                   Z-ADD     *ZERO         O_BVDate
 
      * Calculate Number of Forward Value Date
 
     C                   EXSR      CAL_FWD
 
      * Calculate Number of Back Value Date
 
     C                   EXSR      CAL_BCK
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Calculate Number of Forward Value Date
      ********************************************************************
     C     CAL_FWD       BEGSR
 
     C                   MOVEL     I_FVD         NumPer
 
     C                   SELECT
 
      * CALENDAR DAYS
      * -------------
 
     C     Period        WHENEQ    'C'
     C     Number        ANDNE     *zero                                        212467
 
     C     BJRDNB        ADD       Number        O_FVDate
 
      * BUSINESS DAYS
      * -------------
 
     C     Period        WHENEQ    'B'
     C     Number        ANDNE     *zero                                        212467
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     Number        ZNRDYS
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        O_FVDate
 
      * NO FORWARD VALUE
      * ----------------
 
     C                   OTHER
 
     C     BJDNWD        SUB       1             O_FVDate
 
     C                   ENDSL
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Calculate Number of Back Value Date
      ********************************************************************
     C     CAL_BCK       BEGSR
 
     C                   MOVEL     I_BVD         NumPer
 
     C                   SELECT
 
      * CALENDAR DAYS
      * -------------
 
     C     Period        WHENEQ    'C'
     C     Number        ANDNE     *zero                                        212467
 
     C     BJRDNB        SUB       Number        O_BVDate
 
      * BUSINESS DAYS
      * -------------
 
     C     Period        WHENEQ    'B'
     C     Number        ANDNE     *zero                                        212467
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     Number        ZNRDYS
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        O_BVDate
 
      * MONTHS
      * ------
 
     C     Period        WHENEQ    'M'
     C     Number        ANDNE     *zero                                        212467
 
      * Subtract no. of months
 
     C                   MOVEL     RunDate       Z_DATEN
     C                   Z-ADD     1             Z_DD
     C                   SUB       Number        Z_MM
     C*******************ADD       1             Z_MM                           212908
     C     Z_MM          DOWLE     0
     C                   ADD       12            Z_MM
     C                   SUB       1             Z_YY
     C                   ENDDO
 
      * Determine day number
 
     C                   MOVEL     Z_DATEN       ZDATEI
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        O_BVDate
 
      * NO BACK VALUE
      * -------------
 
     C                   OTHER
 
     C                   Z-ADD     BJRDNB        O_BVDate
 
     C                   ENDSL
 
     C                   ENDSR
      *******************************************************************
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
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Calculate working days forward
      *****************************************************************
     C     ZFWDT         BEGSR
 
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      BJSLCD        ZLOC              3
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Calculate working days backward
      *****************************************************************
     C     ZBKDT         BEGSR
 
     C                   CALLB     'ZBKDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      BJSLCD        ZLOC              3
     C                   PARM                    ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * INPUTS
 
      * Forward value days
      * Back value days
     C                   PARM                    I_FVD             3
     C                   PARM                    I_BVD             3
 
      * SDBANKPD
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Forward value date
      * Back value date
     C                   PARM                    O_FVDate          5 0
     C                   PARM                    O_BVDate          5 0
 
      * Convert run day number to a date
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        RunDate           6
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
