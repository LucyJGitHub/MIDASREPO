     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/**** *  RPGBASEMOD                                                   *              CGP017 MD056555
/*STD *  RPGSQLMOD                                                    *                     MD056555
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD056555
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSCSARIPD - Bulk Update of Global File GZSCSARIPD           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD062254           Date 26Jan24               *
      *  Prev Amend No. MD056555           Date 31Aug20               *
      *                 MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215           Date 27Sep06               *
      *                 BG1364             Date 04Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062254 - GOC0100/GOC0100A fails for GZSDBROKPD due to      *
      *             duplicate record key. Fix is to restrict the      *
      *             to the zone where the GOC0100A is called over.    *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  BG1364 - Filter Duplicate records in Bulk Synchronization    *
      *           (Regenerated)                                       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     F*SCSARIL4* IP  AE           K DISK    RENAME(SCSARID0   : FormatZON)                  MD056555
     F**********                           INFSR(*PSSR)                                     MD056555
     F*GZSCSARIL0IS  AE           K DISK    RENAME(SCSARID0   : FormatGLB)                  MD056555
     F**********                           PREFIX(G_)                                       MD056555
     F**********                           INFSR(*PSSR)                                     MD056555
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D*Z_SCSARIL4    E DS                  EXTNAME(SCSARIPD  )                              MD056555
     D*G_SCSARIL4    E DS                  EXTNAME(GZSCSARIPD)                              MD056555
     D**********                           PREFIX(G_)                                       MD056555

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
     D TotRow          S             13  0                                                  MD056555
     D SQLDynStmt      S           5000A                                                    MD056555

     I*FormatZON     01                                                                     MD056555
     I**********                                ADSARN        L1M2                          MD056555
     I**********                                ADINDX        L1M1                          MD056555
     I*FormatGLB     02                                                                     MD056555
     I**********                                G_ADSARN      L1M2                          MD056555
     I**********                                G_ADINDX      L1M1                          MD056555

     C******INMR         IFEQ      *OFF                                                     MD056555
     C******IN01         IFEQ      *ON                                                      MD056555
     C**********         MOVEL     Z_SCSARIL4    G_SCSARIL4                                 MD056555
Z    C**********         EVAL      G_ADZONE      = I_ZONE                                   MD056555
     C**********         EVAL      I#BFAF = 'A'                                             MD056555
     C**********         EXSR      UPD_GLOBALFILE                                           MD056555
     C**********         ELSE                                                               MD056555
     C**********         EVAL      I#BFAF = 'B'                                             MD056555
     C**********         EXSR      UPD_GLOBALFILE                                           MD056555
     C**********         ENDIF                                                              MD056555
     C**********         ELSE                                                               MD056555
     C***02*****         MOVE      ADZONE        G_ADZONE                            CGP017 MD056555
     C*****Z_SCSARIL4    IFNE      G_SCSARIL4                                        CGP017 MD056555
     C***02*****         MOVEL     Z_SCSARIL4    G_SCSARIL4                                 MD056555
Z    C***02*****         EVAL      G_ADZONE      = I_ZONE                                   MD056555
     C***02*****         EVAL      I#BFAF = 'A'                                             MD056555
     C***02*****         EXSR      UPD_GLOBALFILE                                           MD056555
     C**********         ELSE                                                        CGP017 MD056555
     C***02*****         MOVE      *OFF          *IN02                               CGP017 MD056555
     C**********         ENDIF                                                       CGP017 MD056555
     C**********         ENDIF                                                              MD056555
      * Delete GZ records which are not in SCSRIJW0                                         MD056555
     C/exec SQL                                                                             MD056555
     C+ delete from GZSCSARIPD A                                                            MD056555
     C+ where a.ADZONE = :I_ZONE and not exists                                             MD056555
     C+ (select * from SCSRIJW0 B where A.ADSARN = B.ADSARN                                 MD056555
     C+ and A.ADINDX = B.ADINDX)                                                            MD056555
     C/end-exec                                                                             MD056555
     C/EXEC SQL                                                                             MD056555
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD056555
     C/END-EXEC                                                                             MD056555
     C                   If        SQLCode <> 0                                             MD056555
     C                             and SQLCode <> 100                                       MD056555
     C                   EXSR      *PSSR                                                    MD056555
     C                   Endif                                                              MD056555
     C                   Z-ADD     TotRow        T_BSCNTD                                   MD056555
                                                                                            MD056555
      * Insert GZ records which are in SCSRIJW0 but not in GZSCSARIPD                       MD056555
     C/exec SQL                                                                             MD056555
     C+ insert into GZSCSARIPD                                                              MD056555
     C+ (select ADSARN, ADMGRP, ADICDE, ADRECI , ADAVAL, ADINAR ,                           MD056555
     C+  ADLCD, ADTYLC, ADINDX, ZOZONE as ADZONE                                            MD056555
     C+ from SCSRIJW0 a, GPZONEPD                                                           MD056555
     C+ where not exists (select * from GZSCSARIPD b where a.ADSARN = b.ADSARN              MD056555
     C+ and a.ADINDX = b.ADINDX                                                             MD056555
     C**and*b.ADZONE = :I_ZONE))                                                   MD056555 MD062254
     C+ and b.ADZONE = :I_ZONE) and ZOZONE = :I_ZONE)                                       MD062254
     C/end-exec                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD056555
     C/END-EXEC                                                                             MD056555
     C                   If        SQLCode <> 0                                             MD056555
     C                             and SQLCode <> 100                                       MD056555
     C                   EXSR      *PSSR                                                    MD056555
     C                   Endif                                                              MD056555
     C                   Z-ADD     TotRow        T_BSCNTW                                   MD056555
                                                                                            MD056555
      * Update GZ records which are different in SCSRIJW0                                   MD056555
     C/exec SQL                                                                             MD056555
     C+ update GZSCSARIPD a set                                                             MD056555
     C+ (a.ADMGRP, a.ADICDE, a.ADRECI, a.ADAVAL, a.ADINAR, a.ADLCD,                         MD056555
     C+  a.ADTYLC) =                                                                        MD056555
     C+ (select b.ADMGRP, b.ADICDE, b.ADRECI, b.ADAVAL, b.ADINAR, b.ADLCD,                  MD056555
     C+  b.ADTYLC                                                                           MD056555
     C+ from SCSRIJW0 b, GPZONEPD                                                           MD056555
     C+ where b.ADSARN = a.ADSARN and a.ADINDX = b.ADINDX and ZOZONE = :I_ZONE)             MD056555
     C+ where exists (select * from SCSRIJW0 b where a.ADSARN = b.ADSARN                    MD056555
     C+  and a.ADINDX = b.ADINDX)                                                           MD056555
     C+ and a.ADZONE = :I_ZONE                                                              MD056555
     C/end-exec                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD056555
     C/END-EXEC                                                                             MD056555
     C                   If        SQLCode <> 0                                             MD056555
     C                             and SQLCode <> 100                                       MD056555
     C                   EXSR      *PSSR                                                    MD056555
     C                   Endif                                                              MD056555
     C                   Z-ADD     TotRow        T_BSCNTU                                   MD056555
                                                                                            MD056555
     C**********         EXSR      UPD_SYNTOT                                               MD056555
     C*LR*******         EXSR      WRT_SYNLOG                                               MD056555
     C                   EXSR      WRT_SYNLOG                                               MD056555
     C                   SETON                                        LR                    MD056555
     C                   RETURN                                                             MD056555
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C*****UPD_GLOBALFILEBEGSR                                                              MD056555
     C**********         EVAL      I#ZONE = I_ZONE                                          MD056555
     C**********         EVAL      I#TRAP = 'N'                                             MD056555
     C**********         EVAL      I#BIMG = G_SCSARIL4                                      MD056555
     C**********         EVAL      I#AIMG = G_SCSARIL4                                      MD056555
     C*COPY GPCPYSRCG,GPSCSARIPD                                                            MD056555
     C**********         ENDSR                                                              MD056555
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C*****UPD_SYNTOT    BEGSR                                                              MD056555
      **********                                                                            MD056555
     C******INMR         IFEQ      *OFF                                                     MD056555
     C******IN01         IFEQ      *ON                                                      MD056555
     C**********         ADD       1             T_BSCNTW                                   MD056555
     C**********         ELSE                                                               MD056555
     C**********         ADD       1             T_BSCNTD                                   MD056555
     C**********         ENDIF                                                              MD056555
     C**********         ELSE                                                               MD056555
     C***02*****         ADD       1             T_BSCNTU                                   MD056555
     C**********         ENDIF                                                              MD056555
      **********                                                                            MD056555
      **********                                                                            MD056555
     C**********         ENDSR                                                              MD056555
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

     C                   MOVEL     *BLANK        I#ERMS           50
     C**********         CLEAR                   Z_SCSARIL4                                 MD056555
     C**********         CLEAR                   G_SCSARIL4                                 MD056555

      * Delete existing log records

     C                   EVAL      BSFILE = 'GZSCSARIPD'
     C                   EVAL      BSZONE = I_ZONE
     C     GPSBLOGK      SETLL     GPSBLOGD0
     C     GPSBLOGK      READE     GPSBLOGD0                              99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPSBLOGD0
     C     GPSBLOGK      READE     GPSBLOGD0                              99
     C                   ENDDO

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
