     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GO Set Current Global Historic Balances')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETCHIB  - Set Current Global Historic Balances            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGP010   *CREATE   Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGZACCNTAB IP   E             DISK    INFSR(*PSSR)
     FGPWHIBLPD O    E             DISK    INFSR(*PSSR)
 
 
     D POWER           S              8  0 DIM(8) CTDATA PERRCD(1)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Branch Details
     D GZSDBRCH      E DS                  EXTNAME(GZSDBRCHPD)
     D                                     PREFIX(B_)
      * Currency Details
     D GPCURR        E DS                  EXTNAME(GPCURRPD)
     D                                     PREFIX(C_)
 
 
      * Access branch
 
     C     BRCA          IFNE      P_BRCA
     C                   MOVEL     BRCA          I#BRCD
     C                   EXSR      ACS_BRCH
     C                   MOVEL     BRCA          P_BRCA            3
     C                   ENDIF
 
      * Extract accounts only within the current zone
 
     C     B_A8ZONE      IFEQ      I#ZONE
 
      * Access currency decimal places
 
     C     CCY           IFNE      P_CCY
     C                   MOVEL     CCY           I#CCY
     C                   EXSR      ACS_CURR
     C                   MOVEL     CCY           P_CCY             3
     C                   ENDIF
 
 
      * Write account for current period
 
     C     B_A8ZONE      IFNE      *BLANK
     C                   MOVEL     O#Year        YR
     C                   MOVEL     O#Month       PR
     C     C_GCNBDP      ADD       1             CA                1 0
     C     LDBL          DIV       POWER(CA)     EPBLAC                 99
     C   99              MOVEL     '1'           EPBLDC
     C  N99              MOVEL     '0'           EPBLDC
     C                   Z-ADD     0             BSTFR
     C                   Z-ADD     0             FCTFAC
     C                   MOVEL     B_A8ZONE      HBZONE
     C                   WRITE     GPHIBLD0
     C                   ENDIF
     C                   ENDIF
 
      /SPACE 5
      **********************************************************************************
      * Access branch details
      **********************************************************************************
     C     ACS_BRCH      BEGSR
     C                   CALL      'GPACSBRCH'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * Branch
     C                   PARM                    I#BRCD            3
     C                   PARM                    GZSDBRCH
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Currency Details
      **********************************************************************************
     C     ACS_CURR      BEGSR
     C                   CALL      'GPACSCURR'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * currency
     C                   PARM                    I#CCY             3
     C                   PARM                    GPCURR
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'M'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * *INZSR - Initial Processing
      **********************************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUTS
     C                   PARM                    I#ZONE           10
      * OUTPUTS
     C                   PARM                    O#Year            2
     C                   PARM                    O#Month           2
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Convert current run date to month and year
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         O#Year
     C                   MOVEL     ZDATE         O#Month
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
