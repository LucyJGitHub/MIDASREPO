     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/**** *  RPGBASEMOD                                                   *              CGP017 MD056557
/*STD *  RPGSQLMOD                                                    *                     MD056557
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD056557
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSDPDWNPD - Bulk Update of Global File GZSDPDWNPD           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD062254           Date 26Jan24               *
      *  Prev Amend No. MD056557           Date 31Aug20               *
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
      *  MD056557 - Deliverable Data Split for Pulldown               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     F*SDPDWNL0* IP  AE           K DISK    RENAME(SDPDWND0   : FormatZON)                  MD056557
     F**********                           INFSR(*PSSR)                                     MD056557
     F*GZSDPDWNL0IS  AE           K DISK    RENAME(SDPDWND0   : FormatGLB)                  MD056557
     F**********                           PREFIX(G_)                                       MD056557
     F**********                           INFSR(*PSSR)                                     MD056557
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D TotRow          S             13  0                                                  MD056557
     D*Z_SDPDWNL0    E DS                  EXTNAME(SDPDWNPD  )                              MD056557
     D*G_SDPDWNL0    E DS                  EXTNAME(GZSDPDWNPD)                              MD056557
     D*********                            PREFIX(G_)                                       MD056557

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

     I*FormatZON     01                                                                     MD056557
     I**********                                GLHIND        L1M2                          MD056557
     I**********                                GLDIND        L1M1                          MD056557
     I*FormatGLB     02                                                                     MD056557
     I**********                                G_GLHIND      L1M2                          MD056557
     I**********                                G_GLDIND      L1M1                          MD056557

     C******INMR         IFEQ      *OFF                                                     MD056557
     C******IN01         IFEQ      *ON                                                      MD056557
     C*********          MOVEL     Z_SDPDWNL0    G_SDPDWNL0                                 MD056557
Z    C*********          EVAL      G_GLZONE      = I_ZONE                                   MD056557
     C*********          EVAL      I#BFAF = 'A'                                             MD056557
     C*********          EXSR      UPD_GLOBALFILE                                           MD056557
     C*********          ELSE                                                               MD056557
     C*********          EVAL      I#BFAF = 'B'                                             MD056557
     C*********          EXSR      UPD_GLOBALFILE                                           MD056557
     C*********          ENDIF                                                              MD056557
     C*********          ELSE                                                               MD056557
     C***02****          MOVE      GLZONE        G_GLZONE                            CGP017 MD056557
     C*****Z_SDPDWNL0    IFNE      G_SDPDWNL0                                        CGP017 MD056557
     C***02****          MOVEL     Z_SDPDWNL0    G_SDPDWNL0                                 MD056557
Z    C***02****          EVAL      G_GLZONE      = I_ZONE                                   MD056557
     C***02****          EVAL      I#BFAF = 'A'                                             MD056557
     C***02****          EXSR      UPD_GLOBALFILE                                           MD056557
     C*********          ELSE                                                        CGP017 MD056557
     C***02****          MOVE      *OFF          *IN02                               CGP017 MD056557
     C*********          ENDIF                                                       CGP017 MD056557
     C*********          ENDIF                                                              MD056557
      * Delete GZ records which are not in SDPWNJW0                                         MD056557
     C/exec SQL                                                                             MD056557
     C+ delete from GZSDPDWNPD A                                                            MD056557
     C+ where a.GLZONE = :I_ZONE and not exists                                             MD056557
     C+ (select * from SDPWNJW0 B where A.GLHIND = B.GLHIND                                 MD056557
     C+ and A.GLDIND = B.GLDIND)                                                            MD056557
     C/end-exec                                                                             MD056557
     C/EXEC SQL                                                                             MD056557
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD056557
     C/END-EXEC                                                                             MD056557
     C                   If        SQLCode <> 0                                             MD056557
     C                             and SQLCode <> 100                                       MD056557
     C                   EXSR      *PSSR                                                    MD056557
     C                   Endif                                                              MD056557
     C                   Z-ADD     TotRow        T_BSCNTD                                   MD056557
                                                                                            MD056557
      * Insert GZ records which are in SDPWNJW0 but not in GZSDPDWNPD                       MD056557
     C/exec SQL                                                                             MD056557
     C+ insert into GZSDPDWNPD                                                              MD056557
     C+ (select GLDIND, GLHIND, GLLANG, GLVDTA , GLDESC, GLMMSN,                            MD056557
     C+  ZOZONE as GLZONE                                                                   MD056557
     C+ from SDPWNJW0 a, GPZONEPD                                                           MD056557
     C+ where not exists (select * from GZSDPDWNPD b where a.GLHIND = b.GLHIND              MD056557
     C+ and A.GLDIND = B.GLDIND                                                             MD056557
     C**and*B.GLZONE = :I_ZONE))                                                   MD056557 MD062254
     C+ and B.GLZONE = :I_ZONE) and ZOZONE = :I_ZONE)                                       MD062254
     C/end-exec                                                                             MD056557
                                                                                            MD056557
     C/EXEC SQL                                                                             MD056557
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD056557
     C/END-EXEC                                                                             MD056557
     C                   If        SQLCode <> 0                                             MD056557
     C                             and SQLCode <> 100                                       MD056557
     C                   EXSR      *PSSR                                                    MD056557
     C                   Endif                                                              MD056557
     C                   Z-ADD     TotRow        T_BSCNTW                                   MD056557
                                                                                            MD056557
      * Update GZ records which are different in SDPWNJW0                                   MD056557
     C/exec SQL                                                                             MD056557
     C+ update GZSDPDWNPD a set                                                             MD056557
     C+ (a.GLLANG, a.GLVDTA, a.GLDESC, a.GLMMSN) =                                          MD056557
     C+ (select b.GLLANG, b.GLVDTA, b.GLDESC, b.GLMMSN                                      MD056557
     C+ from SDPWNJW0 b, GPZONEPD                                                           MD056557
     C+ where a.GLHIND = b.GLHIND and A.GLDIND = B.GLDIND and                               MD056557
     C+  ZOZONE = :I_ZONE)                                                                  MD056557
     C+ where exists (select * from SDPWNJW0 b where                                        MD056557
     C+     A.GLHIND = B.GLHIND and A.GLDIND = B.GLDIND)                                    MD056557
     C+ and a.GLZONE = :I_ZONE                                                              MD056557
     C/end-exec                                                                             MD056557
                                                                                            MD056557
     C/EXEC SQL                                                                             MD056557
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD056557
     C/END-EXEC                                                                             MD056557
     C                   If        SQLCode <> 0                                             MD056557
     C                             and SQLCode <> 100                                       MD056557
     C                   EXSR      *PSSR                                                    MD056557
     C                   Endif                                                              MD056557
     C                   Z-ADD     TotRow        T_BSCNTU                                   MD056557
                                                                                            MD056557
     C**********         EXSR      UPD_SYNTOT                                               MD056557
     C*LR*******         EXSR      WRT_SYNLOG                                               MD056557
     C                   EXSR      WRT_SYNLOG                                               MD056557
     C                   SETON                                        LR                    MD056557
     C                   RETURN                                                             MD056557
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C*****UPD_GLOBALFILEBEGSR                                                              MD056557
     C**********         EVAL      I#ZONE = I_ZONE                                          MD056557
     C**********         EVAL      I#TRAP = 'N'                                             MD056557
     C**********         EVAL      I#BIMG = G_SDPDWNL0                                      MD056557
     C**********         EVAL      I#AIMG = G_SDPDWNL0                                      MD056557
     C*COPY*GPCPYSRCG,GPSDPDWNPD                                                            MD056557
     C**********         ENDSR                                                              MD056557
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C*****UPD_SYNTOT    BEGSR                                                              MD056557
      **********                                                                            MD056557
     C******INMR         IFEQ      *OFF                                                     MD056557
     C******IN01         IFEQ      *ON                                                      MD056557
     C**********         ADD       1             T_BSCNTW                                   MD056557
     C**********         ELSE                                                               MD056557
     C**********         ADD       1             T_BSCNTD                                   MD056557
     C**********         ENDIF                                                              MD056557
     C**********         ELSE                                                               MD056557
     C***02*****         ADD       1             T_BSCNTU                                   MD056557
     C**********         ENDIF                                                              MD056557
      **********                                                                            MD056557
      **********                                                                            MD056557
     C**********         ENDSR                                                              MD056557
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
     C**********         CLEAR                   Z_SDPDWNL0                                 MD056557
     C**********         CLEAR                   G_SDPDWNL0                                 MD056557

      * Delete existing log records

     C                   EVAL      BSFILE = 'GZSDPDWNPD'
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
