     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/**** *  RPGBASEMOD                                                   *                     MD058085
/*STD *  RPGSQLMOD                                                    *                     MD058085
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD058085
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSDBROKPD - Bulk Update of Global File GZSDBROKPD           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD062254           Date 26Jan24               *
      *  Prev Amend No. MD058085           Date 11May21               *
      *                 MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215           Date 27Sep06               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062254 - GOC0100/GOC0100A fails for GZSDBROKPD due to      *
      *             duplicate record key. Fix is to restrict the      *
      *             to the zone where the GOC0100A is called over.    *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     F*SDBROKL2* IP  AE           K DISK    RENAME(@BROKL2    : FormatZON)                  MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
     F*GZSDBROKL0IS  AE           K DISK    RENAME(SDBROKD0   : FormatGLB)                  MD058085
     F**********                           PREFIX(G_)                                       MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D*Z_SDBROKL2    E DS                  EXTNAME(SDBROKPD  )                              MD058085
     D*G_SDBROKL2    E DS                  EXTNAME(GZSDBROKPD)                              MD058085
     D**********                           PREFIX(G_)                                       MD058085

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

     D TotRow          S             13  0                                                  MD058085
     I*FormatZON    01                                                                      MD058085
     I**********                                A9BROK        L1M1                          MD058085
     I*FormatGLB    02                                                                      MD058085
     I**********                                G_A9BROK      L1M1                          MD058085
      **********                                                                            MD058085
     C******INMR         IFEQ      *OFF                                                     MD058085
     C******IN01         IFEQ      *ON                                                      MD058085
     C**********         MOVEL     Z_SDBROKL2    G_SDBROKL2                                 MD058085
Z    C**********         EVAL      G_A9ZONE      = I_ZONE                                   MD058085
     C**********         EVAL      I#BFAF = 'A'                                             MD058085
     C**********         EXSR      UPD_GLOBALFILE                                           MD058085
     C**********         ELSE                                                               MD058085
     C**********         EVAL      I#BFAF = 'B'                                             MD058085
     C**********         EXSR      UPD_GLOBALFILE                                           MD058085
     C**********         ENDIF                                                              MD058085
     C**********         ELSE                                                               MD058085
     C***02*****         MOVE      A9ZONE        G_A9ZONE                            CGP017 MD058085
     C*****Z_SDBROKL2    IFNE      G_SDBROKL2                                        CGP017 MD058085
     C***02*****         MOVEL     Z_SDBROKL2    G_SDBROKL2                                 MD058085
Z    C***02*****         EVAL      G_A9ZONE      = I_ZONE                                   MD058085
     C***02*****         EVAL      I#BFAF = 'A'                                             MD058085
     C***02*****         EXSR      UPD_GLOBALFILE                                           MD058085
     C**********         ELSE                                                        CGP017 MD058085
     C***02*****         MOVE      *OFF          *IN02                               CGP017 MD058085
     C**********         ENDIF                                                       CGP017 MD058085
     C**********         ENDIF                                                              MD058085
      * Delete GZ records which are not in SDBRKJW0                                         MD058085
     C/exec SQL                                                                             MD058085
     C+ delete from GZSDBROKPD A                                                            MD058085
     C+ where a.A9ZONE = :I_ZONE and not exists                                             MD058085
     C+ (select * from SDBRKJW0 B where A.A9BROK = B.A9BROK)                                MD058085
     C/end-exec                                                                             MD058085
                                                                                            MD058085
     C                   If        SQLCode <> 0                                             MD058085
     C                             and SQLCode <> 100                                       MD058085
     C                   EXSR      *PSSR                                                    MD058085
     C                   Endif                                                              MD058085
     C/EXEC SQL                                                                             MD058085
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD058085
     C/END-EXEC                                                                             MD058085
     C                   Z-ADD     TotRow        T_BSCNTD                                   MD058085
                                                                                            MD058085
      * Insert GZ records which are in SDBRKJW0 but not in GZSDBROKPD                       MD058085
     C/exec SQL                                                                             MD058085
     C+ insert into GZSDBROKPD                                                              MD058085
     C+ (select A9BROK, A9BRCY, A9LCD , A9TYLC, A9BKNM, A9BRTN, A9ACBC,                     MD058085
     C+  A9OGID, A9EBS,                                                                     MD058085
     C+  ZOZONE as A9ZONE                                                                   MD058085
     C+ from SDBRKJW0 a, GPZONEPD                                                           MD058085
     C+ where not exists (select * from GZSDBROKPD b where a.A9BROK = b.A9BROK              MD058085
     C**and*B.A9ZONE = :I_ZONE))                                                   MD058085 MD062254
     C+ and B.A9ZONE = :I_ZONE) and ZOZONE = :I_ZONE)                                       MD062254
     C/end-exec                                                                             MD058085
                                                                                            MD058085
     C                   If        SQLCode <> 0                                             MD058085
     C                             and SQLCode <> 100                                       MD058085
     C                   EXSR      *PSSR                                                    MD058085
     C                   Endif                                                              MD058085
     C/EXEC SQL                                                                             MD058085
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD058085
     C/END-EXEC                                                                             MD058085
     C                   Z-ADD     TotRow        T_BSCNTW                                   MD058085
                                                                                            MD058085
                                                                                            MD058085
      * Update GZ records which are different in SDBRKJW0                                   MD058085
     C/exec SQL                                                                             MD058085
     C+ update GZSDBROKPD a set                                                             MD058085
     C+ (a.A9BRCY, a.A9LCD , a.A9TYLC, a.A9BKNM, a.A9BRTN, a.A9ACBC,                        MD058085
     C+ a.A9OGID, a.A9EBS) =                                                                MD058085
     C+ (select b.A9BRCY, b.A9LCD , b.A9TYLC, b.A9BKNM, b.A9BRTN, b.A9ACBC,                 MD058085
     C+ b.A9OGID, b.A9EBS                                                                   MD058085
     C+ from SDBRKJW0 b, GPZONEPD                                                           MD058085
     C+ where a.A9BROK = b.A9BROK and                                                       MD058085
     C+  ZOZONE = :I_ZONE)                                                                  MD058085
     C+ where exists (select * from SDBRKJW0 b where                                        MD058085
     C+     A.A9BROK = B.A9BROK )                                                           MD058085
     C+ and a.A9ZONE = :I_ZONE                                                              MD058085
     C/end-exec                                                                             MD058085
                                                                                            MD058085
     C                   If        SQLCode <> 0                                             MD058085
     C                             and SQLCode <> 100                                       MD058085
     C                   EXSR      *PSSR                                                    MD058085
     C                   Endif                                                              MD058085
     C/EXEC SQL                                                                             MD058085
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD058085
     C/END-EXEC                                                                             MD058085
     C                   Z-ADD     TotRow        T_BSCNTU                                   MD058085
                                                                                            MD058085
     C**********         EXSR      UPD_SYNTOT                                               MD058085
     C*LR*******         EXSR      WRT_SYNLOG                                               MD058085
     C                   EXSR      WRT_SYNLOG                                               MD058085
     C                   SETON                                        LR                    MD058085
     C                   RETURN                                                             MD058085
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C*****UPD_GLOBALFILEBEGSR                                                              MD058085
     C**********         EVAL      I#ZONE = I_ZONE                                          MD058085
     C**********         EVAL      I#TRAP = 'N'                                             MD058085
     C**********         EVAL      I#BIMG = G_SDBROKL2                                      MD058085
     C**********         EVAL      I#AIMG = G_SDBROKL2                                      MD058085
     C*COPY GPCPYSRCG,GPSDBROKPD                                                            MD058085
     C**********         ENDSR                                                              MD058085
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C*****UPD_SYNTOT    BEGSR                                                              MD058085
      **********                                                                            MD058085
     C******INMR         IFEQ      *OFF                                                     MD058085
     C******IN01         IFEQ      *ON                                                      MD058085
     C**********         ADD       1             T_BSCNTW                                   MD058085
     C**********         ELSE                                                               MD058085
     C**********         ADD       1             T_BSCNTD                                   MD058085
     C**********         ENDIF                                                              MD058085
     C**********         ELSE                                                               MD058085
     C***02*****         ADD       1             T_BSCNTU                                   MD058085
     C**********         ENDIF                                                              MD058085
      **********                                                                            MD058085
      **********                                                                            MD058085
     C**********         ENDSR                                                              MD058085
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
     C**********         CLEAR                   Z_SDBROKL2                                 MD058085
     C**********         CLEAR                   G_SDBROKL2                                 MD058085

      * Delete existing log records

     C                   EVAL      BSFILE = 'GZSDBROKPD'
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
