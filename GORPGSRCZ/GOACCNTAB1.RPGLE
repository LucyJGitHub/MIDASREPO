     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                    AR1095441
/*STD *  RPGBASEMOD                                                   *                    AR1095441
/*EXI *  TEXT('Bulk Global Update of Accounts - task-split')          *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOACCNTAB1 - Bulk Update of Global File GZACCNTAB            *
      *               Does not process superfluous global records.    *
      *                                                               *
      *---------------------------------------------------------------*
      *  !! NB do not change this program without considering         *
      *  !! changes to GOACCNTAB and GOACCNTAB2.                      *
      *---------------------------------------------------------------*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR1097467B         Date 17Apr13               *
      *  Prev Amend No. AR1095441          Date 11Mar13               *
      *                 CGO001AA           Date 06Aug12               *
      *                 AR854619           Date 06Jan12               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGP013             Date 20Feb09               *
      *                 BUG15716           Date 18Feb08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1097467B - Expected 15% COB run optimization not met       *
      *  AR1095441 - COBOP Compilation Issues                         *
      *  CGO001AA - COB Restructure - GO COB Optimisation Phase 1     *
      *  AR854619 - In Main list the new fields are blank and user    *
      *             input contractual spread (Recompile)              *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CGP013 - Task Split for Accounts Global Update               *
      *           The Task Split results in 2 programs, this and      *
      *           GOACCNTAB2, replacing generated GOACCNTAB.          *
      *  BUG15716 - Increase array size to handle up to 999 branches  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     F***ACTSDVPD  IF   E           K DISK    RENAME(ACCNTABF   : FormatZON)         CGP013 CGO001AA
     F*****ACCNT     IP  AE           K DISK    RENAME(ACCNTABF   : FormatZON)                CGP013
     F*****                                IGNORE(ACCNTAAF   )                                CGP013
     F*****                                IGNORE(ACCNTACF   )                                CGP013
     F***ACTSDVPD  IF   E           K DISK    RENAME(ACTSDVPDF  : DRIVEF) USROPN CGO001AA AR1097467B
     F**********                           INFSR(*PSSR)                                   AR1097467B
     F***ACCNT     IF   E           K DISK    IGNORE(ACCNTAAF   )                CGO001AA AR1097467B
     F**********                           IGNORE(ACCNTACF   )                   CGO001AA AR1097467B
     FACCNTAB   IF   E             DISK    INFDS(INFDS)                                   AR1097467B
     F                                     INFSR(*PSSR)                                     CGO001AA
     F*****GZACCNTL0 IS  AE           K DISK    RENAME(ACCNTABF   : FormatGLB)                CGP013
     F*****                                PREFIX(G_)                                         CGP013
     F*****                                INFSR(*PSSR)                                       CGP013
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)
 
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
     D Z_ACCNT       E DS                  EXTNAME(ACCNTAB   )
     D G_ACCNT       E DS                  EXTNAME(GZACCNTAB )
     D                                     PREFIX(G_)
 
B    D*BR*******       S              3    DIM(99)                                          BUG15716
B    D*SL*******       S             27    DIM(99)                                          BUG15716
B    D BR              S              3    DIM(999)                                         BUG15716
B    D SL              S             27    DIM(999)                                         BUG15716
B
B    D SYNLOGREC       DS
B    D  BSCNTW                 1      9S 0
B    D  BSCNTD                10     18S 0
B    D  BSCNTU                19     27S 0
B
     D                 DS
     D  BUF_TIME               1      8
     D  BUF_HH                 1      2
     D  BUF_C1                 3      3
     D  BUF_MM                 4      5
     D  BUF_C2                 6      6
     D  BUF_SS                 7      8
 
     D                 DS
     D  ALP_TIME               1      6
     D  ALP_HH                 1      2
     D  ALP_MM                 3      4
     D  ALP_SS                 5      6
 
     D                 DS
     D  TIME_STR               1      6S 0
     D  STR_HH                 1      2S 0
     D  STR_MM                 3      4S 0
     D  STR_SS                 5      6S 0
 
     D                 DS
     D  TIME_END               1      6S 0
     D  END_HH                 1      2S 0
     D  END_MM                 3      4S 0
     D  END_SS                 5      6S 0
      **********                                                                 CGO001AA AR1097467B
      ***Data*Structure for the end record key                                   CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
     D**********       DS                                                        CGO001AA AR1097467B
     D*ENDKEY***               1     24                                          CGO001AA AR1097467B
     D*ECNUM****               1      6                                          CGO001AA AR1097467B
     D*ECCY*****               7      9                                          CGO001AA AR1097467B
     D*EACOD****              10     19  0                                       CGO001AA AR1097467B
     D*EACSQ****              20     21  0                                       CGO001AA AR1097467B
     D*EBRCA****              22     24                                          CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
      ***Data*structure for the next record key                                  CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
     D**********       DS                                                        CGO001AA AR1097467B
     D*FRSTKY***               1     24                                          CGO001AA AR1097467B
     D*NCNUM****               1      6                                          CGO001AA AR1097467B
     D*NCCY*****               7      9                                          CGO001AA AR1097467B
     D*NACOD****              10     19  0                                       CGO001AA AR1097467B
     D*NACSQ****              20     21  0                                       CGO001AA AR1097467B
     D*NBRCA****              22     24                                          CGO001AA AR1097467B
                                                                                          AR1097467B
      ** DS for ACCNTAB RRN                                                               AR1097467B
                                                                                          AR1097467B
     D INFDS           DS                                                                 AR1097467B
     D DBRRN                 397    400B 0                                                AR1097467B
 
     I*****FormatZON     01                                                                   CGP013
     I*****                                     CNUM          L1M5                            CGP013
     I*****                                     CCY           L1M4                            CGP013
     I*****                                     ACOD          L1M3                            CGP013
     I*****                                     ACSQ          L1M2                            CGP013
     I*****                                     BRCA          L1M1                            CGP013
     I*****FormatGLB     02                                                                   CGP013
     I*****                                     G_CNUM        L1M5                            CGP013
     I*****                                     G_CCY         L1M4                            CGP013
     I*****                                     G_ACOD        L1M3                            CGP013
     I*****                                     G_ACSQ        L1M2                            CGP013
     I*****                                     G_BRCA        L1M1                            CGP013
 
      **Read*through*the*task*split*driver*file.                                   CGP013 AR1097467B
      **********                                                                   CGP013 AR1097467B
     C**********         OPEN      ACTSDVPD                                      CGO001AA AR1097467B
     C**********         MOVE      *BLANK        AZKEY             1             CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
      ***Read*END record key from ACTSDVPD                                       CGO001AA AR1097467B
     C**********         EVAL      AZKEY = 'Z'                                   CGO001AA AR1097467B
     C*****AZKEY         CHAIN     DRIVEF                             38         CGO001AA AR1097467B
     C**********         IF        *IN38 = '0'                                   CGO001AA AR1097467B
     C**********         EVAL      ECNUM = CNUM                                  CGO001AA AR1097467B
     C**********         EVAL      ECCY  = CCY                                   CGO001AA AR1097467B
     C**********         EVAL      EACOD = ACOD                                  CGO001AA AR1097467B
     C**********         EVAL      EACSQ = ACSQ                                  CGO001AA AR1097467B
     C**********         EVAL      EBRCA = BRCA                                  CGO001AA AR1097467B
     C**********         ENDIF                                                   CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
      ***Read*START record key form ACTSDVPD                                     CGO001AA AR1097467B
     C**********         IF        *IN38 = '0'                                   CGO001AA AR1097467B
     C**********         EVAL      AZKEY = 'A'                                   CGO001AA AR1097467B
     C*****AZKEY         CHAIN     DRIVEF                             38         CGO001AA AR1097467B
     C**********         ENDIF                                                   CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
     C**********         IF        *IN38 = '0'                                   CGO001AA AR1097467B
     C**********         EVAL      NCNUM = CNUM                                  CGO001AA AR1097467B
     C**********         EVAL      NCCY  = CCY                                   CGO001AA AR1097467B
     C**********         EVAL      NACOD = ACOD                                  CGO001AA AR1097467B
     C**********         EVAL      NACSQ = ACSQ                                  CGO001AA AR1097467B
     C**********         EVAL      NBRCA = BRCA                                  CGO001AA AR1097467B
     C**********         ENDIF                                                   CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
      ***Set*pointer to the first record for process                             CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
     C**********         EVAL      *IN19 = '0'                                   CGO001AA AR1097467B
     C**********         IF        FRSTKY > ENDKEY                               CGO001AA AR1097467B
     C**********         EVAL      *IN19 = '1'                                   CGO001AA AR1097467B
     C**********         ENDIF                                                   CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
     C**********         IF        *IN19 = '0'                                   CGO001AA AR1097467B
     C*****GOACNTK       SETLL     ACCNT                                         CGO001AA AR1097467B
     C     STRRRN        SETLL     ACCNTAB                                                AR1097467B
     C                   READ      ACCNTABF                               19                CGO001AA
                                                                                            CGO001AA
     C**********         READ      ACTSDVPD                                          CGP013 CGO001AA
     C**********         DOW       NOT %EOF                                          CGP013 CGO001AA
                                                                                              CGP013
     C******INMR         IFEQ      *OFF                                                       CGP013
     C******IN01         IFEQ      *ON                                                        CGP013
     C**********         DOW       *IN19 = '0'                                   CGO001AA AR1097467B
     C                   DOW       *IN19 = '0' AND DBRRN <= ENDRRN                        AR1097467B
     C                   MOVEL     Z_ACCNT       G_ACCNT
B    C                   EVAL      G_BRCA        = BRCA
     C                   EVAL      I#BFAF = 'A'
     C                   EXSR      UPD_GLOBALFILE
     C*****              ELSE                                                                 CGP013
     C*****              EVAL      I#BFAF = 'B'                                               CGP013
     C*****              EXSR      UPD_GLOBALFILE                                             CGP013
     C*****              ENDIF                                                                CGP013
     C*****              ELSE                                                                 CGP013
     C***02              MOVEL     Z_ACCNT       G_ACCNT                                      CGP013
B    C***02              EVAL      G_BRCA        = BRCA                                       CGP013
     C***02              EVAL      I#BFAF = 'A'                                               CGP013
     C***02              EXSR      UPD_GLOBALFILE                                             CGP013
     C*****              ENDIF                                                                CGP013
     C*****              EXSR      UPD_SYNTOT                                                 CGP013
                                                                                              CGP013
     C**********         READ      ACTSDVPD                                          CGP013 CGO001AA
     C                   READ      ACCNTABF                               19                CGO001AA
                                                                                            CGO001AA
     C**********         IF        *IN19 = '0'                                   CGO001AA AR1097467B
     C**********         EVAL      NCNUM = CNUM                                  CGO001AA AR1097467B
     C**********         EVAL      NCCY  = CCY                                   CGO001AA AR1097467B
     C**********         EVAL      NACOD = ACOD                                  CGO001AA AR1097467B
     C**********         EVAL      NACSQ = ACSQ                                  CGO001AA AR1097467B
     C**********         EVAL      NBRCA = BRCA                                  CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
     C**********         IF        FRSTKY > ENDKEY                               CGO001AA AR1097467B
     C**********         EVAL      *IN19 = '1'                                   CGO001AA AR1097467B
     C**********         ENDIF                                                   CGO001AA AR1097467B
      **********                                                                 CGO001AA AR1097467B
     C**********         ENDIF                                                   CGO001AA AR1097467B
                                                                                            CGO001AA
     C                   ENDDO                                                                CGP013
                                                                                              CGP013
     C**********         ENDIF                                                   CGO001AA AR1097467B
                                                                                            CGO001AA
     C**********         EVAL      *INLR = *ON                                       CGP013 CGO001AA
     C                   UNLOCK    GPSBLOGL0                            39                  CGO001AA
     C**********         CLOSE     ACTSDVPD                                      CGO001AA AR1097467B
     C                   RETURN                                                               CGP013
                                                                                              CGP013
     C**LR*                EXSR      WRT_SYNLOG                                               CGP013
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C     UPD_GLOBALFILEBEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_ACCNT
     C                   EVAL      I#AIMG = G_ACCNT
     C/COPY GPCPYSRCG,GPACCNTAB
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C     UPD_SYNTOT    BEGSR
 
B    C**********         Z-ADD     1             I                 2 0                      BUG15716
B    C                   Z-ADD     1             I                 3 0                      BUG15716
B    C***01BRCA          LOOKUP    BR(I)                                  99                CGP013
B    C***02G_BRCA        LOOKUP    BR(I)                                  99                CGP013
B    C     *IN99         IFEQ      *OFF
B    C     '***'         LOOKUP    BR(I)                                  99
B    C***01              MOVEL     BRCA          BR(I)                                      CGP013
B    C***02              MOVEL     G_BRCA        BR(I)                                      CGP013
B    C                   CLEAR                   SYNLOGREC
B    C                   MOVEL     SYNLOGREC     SL(I)
B    C                   ELSE
B    C                   MOVEL     SL(I)         SYNLOGREC
B    C                   ENDIF
B
     C******INMR         IFEQ      *OFF                                                     CGP013
     C******IN01         IFEQ      *ON                                                      CGP013
B    C                   ADD       1             BSCNTW
     C                   ADD       1             T_BSCNTW
     C*****              ELSE                                                               CGP013
B    C                   ADD       1             BSCNTD
     C                   ADD       1             T_BSCNTD
     C*****              ENDIF                                                              CGP013
     C*****              ELSE                                                               CGP013
B    C***02              ADD       1             BSCNTU                                     CGP013
     C***02              ADD       1             T_BSCNTU                                   CGP013
     C*****              ENDIF                                                              CGP013
 
B    C                   MOVEL     SYNLOGREC     SL(I)
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Write to Synchronization Log
      ********************************************************************
     C     WRT_SYNLOG    BEGSR
 
      * Write overall totals
     C                   MOVEL     '***'         BSBRCA
     C                   Z-ADD     T_BSCNTW      BSCNTW
     C                   Z-ADD     T_BSCNTD      BSCNTD
     C                   Z-ADD     T_BSCNTU      BSCNTU
      *
     C                   EVAL      BSDATE = PSRunDateA
     C                   EVAL      BSJOB  = PSJobName
     C                   EVAL      BSUSER = PSUser
     C                   EVAL      BSJOBN = PSJobNoA
 
     C                   EXSR      RECD_TIME
     C                   EVAL      TIME_END = NUM_TIME
     C                   EVAL      BSETIM   = BUF_TIME
 
      * Calculate total number of seconds
 
     C                   EXSR      CAL_TOS
 
     C                   WRITE     GPSBLOGD0
 
B     * Write branch totals
B    C**********         Z-ADD     1             I                 2 0                      BUG15716
B    C                   Z-ADD     1             I                 3 0                      BUG15716
B    C     BR(I)         DOWNE     '***'
B    C                   MOVEL     BR(I)         BSBRCA
B    C                   MOVEL     SL(I)         SYNLOGREC
B    C                   WRITE     GPSBLOGD0
B    C                   ADD       1             I
B    C                   ENDDO
B
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Calculate total number of seconds
      ********************************************************************
     C     CAL_TOS       BEGSR
 
     C     TIME_END      IFLT      TIME_STR
     C                   ADD       240000        TIME_END
     C                   ENDIF
 
     C     END_HH        SUB       STR_HH        TOT_HH            6 0
     C     END_MM        SUB       STR_MM        TOT_MM            6 0
     C     END_SS        SUB       STR_SS        TOT_SS            6 0
 
     C     STR_MM        IFGT      END_MM
     C                   SUB       1             TOT_HH
     C                   ADD       60            TOT_MM
     C                   ENDIF
 
     C     STR_SS        IFGT      END_SS
     C                   SUB       1             TOT_MM
     C                   ADD       60            TOT_SS
     C                   ENDIF
 
     C                   MULT      3600          TOT_HH
     C                   MULT      60            TOT_MM
 
     C                   Z-ADD     TOT_HH        BSTOS
     C                   ADD       TOT_MM        BSTOS
     C                   ADD       TOT_SS        BSTOS
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Record the time
      ********************************************************************
     C     RECD_TIME     BEGSR
     C                   TIME                    NUM_TIME          6 0
     C                   MOVEL     NUM_TIME      ALP_TIME          6
     C                   MOVEL     ALP_HH        BUF_HH
     C                   MOVEL     ALP_MM        BUF_MM
     C                   MOVEL     ALP_SS        BUF_SS
     C                   MOVEL     ':'           BUF_C1
     C                   MOVEL     ':'           BUF_C2
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE           10
     C                   PARM                    STRRRN           10 0                    AR1097467B
     C                   PARM                    ENDRRN           10 0                    AR1097467B
 
     C                   MOVEL     *BLANK        I#ERMS           50
     C                   CLEAR                   Z_ACCNT
     C                   CLEAR                   G_ACCNT
 
      * Delete existing log records
 
     C*****              EVAL      BSFILE = 'GZACCNTAB '                                      CGP013
     C*****              EVAL      BSZONE = I_ZONE                                            CGP013
     C*****GPSBLOGK      SETLL     GPSBLOGD0                                                  CGP013
     C*****GPSBLOGK      READE     GPSBLOGD0                              99                  CGP013
     C******IN99         DOWEQ     *OFF                                                       CGP013
     C*****              DELETE    GPSBLOGD0                                                  CGP013
     C*****GPSBLOGK      READE     GPSBLOGD0                              99                  CGP013
     C*****              ENDDO                                                                CGP013
 
     C                   MOVEL     PSRunDate     PSRunDateA        6
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EXSR      RECD_TIME
     C                   EVAL      TIME_STR = NUM_TIME
     C                   EVAL      BSSTIM   = BUF_TIME
 
B     * Initialize branches
B    C                   MOVE      '***'         BR
B
      * Initialize overall totals
     C                   Z-ADD     *ZERO         T_BSCNTW          9 0
     C                   Z-ADD     *ZERO         T_BSCNTD          9 0
     C                   Z-ADD     *ZERO         T_BSCNTU          9 0
 
      * Key lists
 
     C     GPSBLOGK      KLIST
     C                   KFLD                    BSFILE
     C                   KFLD                    BSZONE
 
     C     ACCNTK        KLIST                                                                CGP013
     C                   KFLD                    CNUM                                         CGP013
     C                   KFLD                    CCY                                          CGP013
     C                   KFLD                    ACOD                                         CGP013
     C                   KFLD                    ACSQ                                         CGP013
     C                   KFLD                    BRCA                                         CGP013
 
     C     GOACNTK       KLIST                                                              CGO001AA
     C                   KFLD                    CNUM                                       CGO001AA
     C                   KFLD                    CCY                                        CGO001AA
     C                   KFLD                    ACOD                                       CGO001AA
     C                   KFLD                    ACSQ                                       CGO001AA
     C                   KFLD                    BRCA                                       CGO001AA
                                                                                            CGO001AA
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANKS
 
     C                   MOVE      'Y'           RunBefore         1
 
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
