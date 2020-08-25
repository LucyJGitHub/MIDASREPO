     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/**** *  RPGBASEMOD                                                   *              CGP017 MD055681
/*STD *  RPGSQLMOD                                                    *                     MD055681
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD055681
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSCSARDPD - Bulk Update of Global File GZSCSARDPD           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD023266           Date 07Nov13               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023266 - Dumps in CGL135 and CGL146 Switch-On (Recompile)  *
      *           - Applied for MD023043                              *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     F*SCSARDL3* IP  AE           K DISK    RENAME(@SARDL3    : FormatZON)                  MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
     F*GZSCSARDL0IS  AE           K DISK    RENAME(SCSARDD0   : FormatGLB)                  MD055681
     F**********                           PREFIX(G_)                                       MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D*Z_SCSARDL3    E DS                  EXTNAME(SCSARDPD  )                              MD055681
     D*G_SCSARDL3    E DS                  EXTNAME(GZSCSARDPD)                              MD055681
     D**********                           PREFIX(G_)                                       MD055681

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
     D TotRow          S             13  0                                                  MD055681
     D SQLDynStmt      S           5000A                                                    MD055681

     I*FormatZON     01                                                                     MD055681
     I**********                                SARN          L1M1                          MD055681
     I*FormatGLB     02                                                                     MD055681
     I**********                                G_SARN        L1M1                          MD055681

     C******INMR         IFEQ      *OFF                                                     MD055681
     C******IN01         IFEQ      *ON                                                      MD055681
     C**********         MOVEL     Z_SCSARDL3    G_SCSARDL3                                 MD055681
Z    C**********         EVAL      G_ZONE        = I_ZONE                                   MD055681
     C**********         EVAL      I#BFAF = 'A'                                             MD055681
     C**********         EXSR      UPD_GLOBALFILE                                           MD055681
     C**********         ELSE                                                               MD055681
     C**********         EVAL      I#BFAF = 'B'                                             MD055681
     C**********         EXSR      UPD_GLOBALFILE                                           MD055681
     C**********         ENDIF                                                              MD055681
     C**********         ELSE                                                               MD055681
     C***02*****         MOVE      ZONE          G_ZONE                              CGP017 MD055681
     C**** Z_SCSARDL3    IFNE      G_SCSARDL3                                        CGP017 MD055681
     C***02*****         MOVEL     Z_SCSARDL3    G_SCSARDL3                                 MD055681
Z    C***02*****         EVAL      G_ZONE        = I_ZONE                                   MD055681
     C***02*****         EVAL      I#BFAF = 'A'                                             MD055681
     C***02*****         EXSR      UPD_GLOBALFILE                                           MD055681
     C**********         ELSE                                                        CGP017 MD055681
     C***02*****         MOVE      *OFF          *IN02                               CGP017 MD055681
     C**********         ENDIF                                                       CGP017 MD055681
     C**********         ENDIF                                                              MD055681
     C**********         EXSR      UPD_SYNTOT                                               MD055681
                                                                                            MD055681
      * Delete GZ records which are not in SCSRDJW0                                         MD055681
     C/exec SQL                                                                             MD055681
     C+ delete from GZSCSARDPD A                                                            MD055681
     C+ where a.ZONE = :I_ZONE and not exists                                               MD055681
     C+ (select * from SCSRDJW0 B where A.SARN = B.SARN)                                    MD055681
     C/end-exec                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   EXSR      *PSSR                                                    MD055681
     C                   Endif                                                              MD055681
     C                   Z-ADD     TotRow        T_BSCNTD                                   MD055681
                                                                                            MD055681
      * Insert GZ records which are in SCSRDSJW0 but not in GZSCSARDPD                      MD055681
     C/exec SQL                                                                             MD055681
     C+ insert into GZSCSARDPD                                                              MD055681
     C+ (select SARN, SARD, LCD, TYLC, ZOZONE as ZONE                                       MD055681
     C+ from SCSRDJW0 a, GPZONEPD                                                           MD055681
     C+ where not exists (select * from GZSCSARDPD b where a.SARN = b.SARN                  MD055681
     C+ and b.ZONE = :I_ZONE))                                                              MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   EXSR      *PSSR                                                    MD055681
     C                   Endif                                                              MD055681
     C                   Z-ADD     TotRow        T_BSCNTW                                   MD055681
                                                                                            MD055681
      * Update GZ records which are different in SCSRDJW0                                   MD055681
     C/exec SQL                                                                             MD055681
     C+ update GZSCSARDPD a set                                                             MD055681
     C+ (a.SARN, a.SARD, a.LCD, a.TYLC, a.ZONE ) =                                          MD055681
     C+ (select b.SARN, b.SARD, b.LCD, b.TYLC, ZOZONE as ZONE                               MD055681
     C+ from SCSRDJW0 b, GPZONEPD                                                           MD055681
     C+ where b.SARN = a.SARN and ZOZONE = :I_ZONE)                                         MD055681
     C+ where exists (select * from SCSRDJW0 b where a.SARN = b.SARN)                       MD055681
     C+ and a.ZONE = :I_ZONE                                                                MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   EXSR      *PSSR                                                    MD055681
     C                   Endif                                                              MD055681
     C                   Z-ADD     TotRow        T_BSCNTU                                   MD055681
                                                                                            MD055681
     C*LR********        EXSR      WRT_SYNLOG
     C                   EXSR      WRT_SYNLOG                                               MD055681
     C                   SETON                                        LR                    MD055681
     C                   RETURN                                                             MD055681
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C*****UPD_GLOBALFILEBEGSR                                                              MD055681
     C**********         EVAL      I#ZONE = I_ZONE                                          MD055681
     C**********         EVAL      I#TRAP = 'N'                                             MD055681
     C**********         EVAL      I#BIMG = G_SCSARDL3                                      MD055681
     C**********         EVAL      I#AIMG = G_SCSARDL3                                      MD055681
     C*COPY GPCPYSRCG,GPSCSARDPD                                                            MD055681
     C**********         ENDSR                                                              MD055681
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C*****UPD_SYNTOT    BEGSR                                                              MD055681
      **********                                                                            MD055681
     C******INMR         IFEQ      *OFF                                                     MD055681
     C******IN01         IFEQ      *ON                                                      MD055681
     C**********         ADD       1             T_BSCNTW                                   MD055681
     C**********         ELSE                                                               MD055681
     C**********         ADD       1             T_BSCNTD                                   MD055681
     C**********         ENDIF                                                              MD055681
     C**********         ELSE                                                               MD055681
     C***02*****         ADD       1             T_BSCNTU                                   MD055681
     C**********         ENDIF                                                              MD055681
      **********                                                                            MD055681
      **********                                                                            MD055681
     C**********         ENDSR                                                              MD055681
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
     C**********         CLEAR                   Z_SCSARDL3                                 MD055681
     C**********         CLEAR                   G_SCSARDL3                                 MD055681

      * Delete existing log records

     C                   EVAL      BSFILE = 'GZSCSARDPD'
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
