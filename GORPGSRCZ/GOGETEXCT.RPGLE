     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Get extract control information')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGETEXCT - Get Extract Control Information.                 *
      *                                                               *
      *  Function:  This module retrieves the extract control dates   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FCBAICDL1  IF   E           K DISK
     FGPICDTL0  IF   E           K DISK
     FGOICDTL0  IF   E           K DISK
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      * MPHAS Data-Area
     D***MPHAS**         DS             1                                                     CCB020
     D*****PHASE                 1      1                                                     CCB020
 
 
     D JNSTAT          DS           200
     D PRUN                  103    105P 0
 
 
     D                 DS
     D  W#DATE                 1      6
     D  W#MNTH                 1      2S 0
     D  W#DAY                  3      4S 0
     D  W#YEAR                 5      6S 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CCB020
      ** Work Variable in calling CBC001001                                                   CCB020
     D W_COB           S              4                                                       CCB020
 
 
     C     *ENTRY        PLIST
 
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * OUTPUTS
     C                   PARM                    Run_Date          5 0
     C                   PARM                    Date_NWD          5 0
     C                   PARM                    ProjCO_Dat        5 0
     C                   PARM                    AcMRec_Dat        5 0
 
     C                   RETURN
     C/SPACE 5
      **********************************************************************
      * CONVERT DATE TO DAY NUMBER
      **********************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM      'M'           ZDATFM            1
     C                   PARM      *BLANK        ErrorFlag         1
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
      * CONVERT DAY NUMBER TO DATE
      **********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'M'           ZDATFM            1            Date format ind
     C                   PARM      *ZERO         ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
 
      **Read*MPHAS*data-area*******************************************                       CCB020
 
     C******DTAARA       DEFINE                  MPHAS                                        CCB020
     C**********         IN        MPHAS                                                      CCB020
                                                                                              CCB020
      ** Call program CBC001001 to check if system is in COB or IC                            CCB020
      ** If the return value is *YES, system is in COB                                        CCB020
      ** If *NO, system is in Input Cycle                                                     CCB020
                                                                                              CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM                    W_COB                                        CCB020
 
      * Get JNSTAT control data
 
     C     *DTAARA       DEFINE                  JNSTAT
     C     *LOCK         IN        JNSTAT
     C                   OUT       JNSTAT
 
      * Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Read Global ICD
 
     C     *LOVAL        SETLL     GPICDTD0
     C                   READ      GPICDTD0                               99
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'NO GLOBAL ICD IN GPICDTPD'
     C                   EXSR      *PSSR
     C                   END
 
      * Read Zone ICD
 
     C     *LOVAL        SETLL     GOICDTD0
     C                   READ      GOICDTD0                               99
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'NO ZONE ICD IN GOICDTPD'
     C                   EXSR      *PSSR
     C                   END
 
      * If in input cycle
 
     C*****PHASE         IFEQ      'A'                                                        CCB020
     C     W_COB         IFEQ      '*NO'                                                      CCB020
 
      * Set Run Date and Date of Next Working Day
 
     C                   Z-ADD     BJRDNB        Run_Date
     C                   Z-ADD     BJDNWD        Date_NWD
 
      * If in COB
 
     C                   ELSE
 
      * Get following run date
 
     C                   MOVEL     'A.COB '      ABACOB
     C     ABACOB        CHAIN     @AICDF1                            99        *
     C     *in99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'NO AUTO COB DATA IN CBAICDPD'
     C                   EXSR      *PSSR
     C                   END
 
      * Calculate next working day after following run date
 
     C                   CALLB     'ZFWDT'
     C                   PARM      ABDBRN        ZDAYNO            5 0
     C                   PARM      1             ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM                    ZLOC              3
 
     C                   Z-ADD     ABDBRN        Run_Date
     C                   Z-ADD     ZDYNBR        Date_NWD
     C                   ENDIF
 
 
      * Calculate projections cut-off date
      * Starting from day prior to next working day
      * add projected days, months & years
 
     C     Date_NWD      SUB       1             ProjCO_Dat
     C                   ADD       GLPCOD        ProjCO_Dat
 
     C     GLPCOM        IFNE      *ZERO
     C     GLPCOY        ORNE      *ZERO
 
      * Convert day number to date
 
     C                   Z-ADD     ProjCO_Dat    ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         W#DATE
 
     C                   ADD       GLPCOM        W#MNTH
     C     W#MNTH        IFGT      12
     C                   SUB       12            W#MNTH
     C                   ADD       1             W#YEAR
     C                   ENDIF
 
     C                   ADD       GLPCOY        W#YEAR
 
      * Convert date to day number
 
     C                   MOVE      W#DATE        ZDATEI
     C                   EXSR      ZDATE1
     C     ErrorFlag     DOWEQ     'Y'
     C     W#DAY         ANDGT     1
     C                   SUB       1             W#DAY
     C                   MOVE      W#DATE        ZDATEI
     C                   EXSR      ZDATE1
     C                   ENDDO
 
     C                   Z-ADD     ZDAYNO        ProjCO_Dat
 
     C                   ENDIF
 
      * If override for a/c movement recovery days specified
      * use these days
 
     C     Run_Date      SUB       ZNAMRD        AcMRec_Dat
 
      * The a/c movement recovery date must be at least the prev. run date
 
     C     PRUN          IFLT      AcMRec_Dat
     C                   Z-ADD     PRUN          AcMRec_Dat
     C                   ENDIF
 
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
