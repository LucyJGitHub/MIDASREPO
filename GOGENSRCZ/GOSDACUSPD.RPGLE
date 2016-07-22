     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*S*D ***RPGBASEBNC****************************************************                     MD020205
/*STD *  RPGBASEMOD                                                   *                     MD020205
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSDACUSPD - Bulk Update of Global File GZSDACUSPD           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CGL132             Date 01May13               *
      *                 MD020205           Date 24Apr13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR742563           Date 06Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG22529 *CREATE   Date 05Feb09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  MD020205 - Continuous CoB run time improvement               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR742563 - Global Replication : GZSDACUSPD vs SDACUSPD       *
      *             (Child: AR742564) (Recompile)                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG22529 - Global Additional Cust Details                    *
      *                                                               *
      *****************************************************************

     F***SDACUSL0  IP  AE           K DISK    RENAME(@ACUSL0    : FormatZON)                MD020205
     FSDACUSPD  IF   E             DISK    INFDS(INFDS)                                     MD020205
     F                                     INFSR(*PSSR)
     F***GZSDACUSL0IS  AE           K DISK    RENAME(SDACUSD0   : FormatGLB)                MD020205
     F**********                           PREFIX(G_)                                       MD020205
     F**********                           INFSR(*PSSR)                                     MD020205
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D Z_SDACUSL0    E DS                  EXTNAME(SDACUSPD  )
     D G_SDACUSL0    E DS                  EXTNAME(GZSDACUSPD)
     D                                     PREFIX(G_)

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

      ** DS for SDACUSPD RRN                                                                MD020205
                                                                                            MD020205
     D INFDS           DS                                                                   MD020205
     D DBRRN                 397    400B 0                                                  MD020205
                                                                                            MD020205
     ***FormatZON     01                                                                    MD020205
     **********                                E5CUST        L1M1                           MD020205
     I***FormatGLB     02                                                                   MD020205
     I**********                                G_E5CUST      L1M1                          MD020205

     C     STRRRN        SETLL     SDACUSPD                                                 MD020205
     C                   READ      SDACUSD0                               19                MD020205
     C******INMR         IFEQ      *OFF                                                     MD020205
     C******IN01         IFEQ      *ON                                                      MD020205
      *                                                                                     MD020205
     C                   DOW       *IN19 = '0' AND DBRRN <= ENDRRN                          MD020205
     C                   MOVEL     Z_SDACUSL0    G_SDACUSL0
Z    C                   EVAL      G_E5ZONE      = I_ZONE
     C                   EVAL      I#BFAF = 'A'
     C                   EXSR      UPD_GLOBALFILE
     C                   READ      SDACUSD0                               19                MD020205
     C                   ENDDO                                                              MD020205
      *                                                                                     MD020205
     C                   UNLOCK    GPSBLOGL0                                                MD020205
     C                   RETURN                                                             MD020205
      *                                                                                     MD020205
     C**********         ELSE                                                               MD020205
     C**********         EVAL      I#BFAF = 'B'                                             MD020205
     C**********         EXSR      UPD_GLOBALFILE                                           MD020205
     C**********         ENDIF                                                              MD020205
     C**********         ELSE                                                               MD020205
     C***02              MOVEL     Z_SDACUSL0    G_SDACUSL0                                 MD020205
Z    C***02              EVAL      G_E5ZONE      = I_ZONE                                   MD020205
     C***02              EVAL      I#BFAF = 'A'                                             MD020205
     C***02              EXSR      UPD_GLOBALFILE                                           MD020205
     C**********         ENDIF                                                              MD020205
     C**********         EXSR      UPD_SYNTOT                                               MD020205
     C****LR                 EXSR      WRT_SYNLOG                                           MD020205
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C     UPD_GLOBALFILEBEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_SDACUSL0
     C                   EVAL      I#AIMG = G_SDACUSL0
     C/COPY GPCPYSRCG,GPSDACUSPD
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C     UPD_SYNTOT    BEGSR

     C******INMR         IFEQ      *OFF                                                     MD020205
     C******IN01         IFEQ      *ON                                                      MD020205
     C                   ADD       1             T_BSCNTW
     C**********         ELSE                                                               MD020205
     C                   ADD       1             T_BSCNTD
     C**********         ENDIF                                                              MD020205
     C**********         ELSE                                                               MD020205
     C***02              ADD       1             T_BSCNTU                                   MD020205
     C**********         ENDIF                                                              MD020205


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
     C                   PARM                    STRRRN           10 0                      MD020205
     C                   PARM                    ENDRRN           10 0                      MD020205

     C                   MOVEL     *BLANK        I#ERMS           50
     C                   CLEAR                   Z_SDACUSL0
     C                   CLEAR                   G_SDACUSL0

      * Delete existing log records

     C**********         EVAL      BSFILE = 'GZSDACUSPD'                                    MD020205
     C**********         EVAL      BSZONE = I_ZONE                                          MD020205
     C*****GPSBLOGK      SETLL     GPSBLOGD0                                                MD020205
     C*****GPSBLOGK      READE     GPSBLOGD0                              99                MD020205
     C******IN99         DOWEQ     *OFF                                                     MD020205
     C**********         DELETE    GPSBLOGD0                                                MD020205
     C*****GPSBLOGK      READE     GPSBLOGD0                              99                MD020205
     C**********         ENDDO                                                              MD020205

     C                   MOVEL     PSRunDate     PSRunDateA        6
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EXSR      RECD_TIME
     C                   EVAL      TIME_STR = NUM_TIME
     C                   EVAL      BSSTIM   = BUF_TIME

      * Initialize overall totals
     C                   Z-ADD     *ZERO         T_BSCNTW          9 0
     C                   Z-ADD     *ZERO         T_BSCNTD          9 0
     C                   Z-ADD     *ZERO         T_BSCNTU          9 0

      * Key lists

     C     GPSBLOGK      KLIST
     C                   KFLD                    BSFILE
     C                   KFLD                    BSZONE
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
