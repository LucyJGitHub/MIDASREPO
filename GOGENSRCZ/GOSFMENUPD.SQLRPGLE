     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/**** *  RPGBASEMOD                                                   *              CGP017 MD056561
/*STD *  RPGSQLMOD                                                    *                     MD056561
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD056561
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSFMENUPD - Bulk Update of Global File GZSFMENUPD           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD056561           Date 31Aug20               *
      *  Prev Amend No. MD055681           Date 31Jul20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD023266           Date 07Nov13               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 BG7142             Date 28Jun05               *
      *                 BUG2287            Date 28Apr04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056561 - Deliverable Data Split for SFMENUPD and GPMTXTPD  *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023266 - Dumps in CGL135 and CGL146 Switch-On (Recompile)  *
      *           - Applied for MD023043                              *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BG7142 - API names not replicated to global layer (Recompile)*
      *  BUG2287- Show consolidated global view (Recompile)           *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     F*SFMENUJ1* IP  AE           K DISK    RENAME(@MENUJ1    : FormatZON)                  MD056561
     F**********                           INFSR(*PSSR)                                     MD056561
     F*GZSFMENUL0IS  AE           K DISK    RENAME(SFMENUD0   : FormatGLB)                  MD056561
     F**********                           PREFIX(G_)                                       MD056561
     F**********                           INFSR(*PSSR)                                     MD056561
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D*Z_SFMENUJ1    E DS                  EXTNAME(SFMENUPD  )                              MD056561
     D*G_SFMENUJ1    E DS                  EXTNAME(GZSFMENUPD)                              MD056561
     D**********                           PREFIX(G_)                                       MD056561

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
     D TotRow          S             13  0                                                  MD056561
     D SQLDynStmt      S           5000A                                                    MD056561

     I*FormatZON     01                                                                     MD056561
     I**********                                MIINDX        L1M1                          MD056561
     I*FormatGLB     02                                                                     MD056561
     I**********                                G_MIINDX      L1M1                          MD056561

     C******INMR         IFEQ      *OFF                                                     MD056561
     C******IN01         IFEQ      *ON                                                      MD056561
     C**********         MOVEL     Z_SFMENUJ1    G_SFMENUJ1                                 MD056561
Z    C**********         EVAL      G_MIZONE      = I_ZONE                                   MD056561
     C**********         EVAL      I#BFAF = 'A'                                             MD056561
     C**********         EXSR      UPD_GLOBALFILE                                           MD056561
     C**********         ELSE                                                               MD056561
     C**********         EVAL      I#BFAF = 'B'                                             MD056561
     C**********         EXSR      UPD_GLOBALFILE                                           MD056561
     C**********         ENDIF                                                              MD056561
     C**********         ELSE                                                               MD056561
     C***02*****         MOVE      MIZONE        G_MIZONE                            CGP017 MD056561
     C*****Z_SFMENUJ1    IFNE      G_SFMENUJ1                                        CGP017 MD056561
     C***02*****         MOVEL     Z_SFMENUJ1    G_SFMENUJ1                                 MD056561
Z    C***02*****         EVAL      G_MIZONE      = I_ZONE                                   MD056561
     C***02*****         EVAL      I#BFAF = 'A'                                             MD056561
     C***02*****         EXSR      UPD_GLOBALFILE                                           MD056561
     C**********         ELSE                                                         CGP017MD056561
     C***02*****         MOVE      *OFF          *IN02                                CGP017MD056561
     C**********         ENDIF                                                        CGP017MD056561
     C**********         ENDIF                                                              MD056561
      * Delete GZ records which are not in SFMNUJW2                                         MD056561
     C/exec SQL                                                                             MD056561
     C+ delete from GZSFMENUPD A                                                            MD056561
     C+ where a.MIZONE = :I_ZONE and not exists                                             MD056561
     C+ (select * from SFMNUJW2 B where A.MIINDX = B.MIINDX)                                MD056561
     C/end-exec                                                                             MD056561
     C/EXEC SQL                                                                             MD056561
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD056561
     C/END-EXEC                                                                             MD056561
     C                   If        SQLCode <> 0                                             MD056561
     C                             and SQLCode <> 100                                       MD056561
     C                   EXSR      *PSSR                                                    MD056561
     C                   Endif                                                              MD056561
     C                   Z-ADD     TotRow        T_BSCNTD                                   MD056561
                                                                                            MD056561
      * Insert GZ records which are in SFMNUJW2 but not in GZSFMENUPD                       MD056561
     C/exec SQL                                                                             MD056561
     C+ insert into GZSFMENUPD                                                              MD056561
     C+ (select ZOZONE as MIZONE, MIINDX, MISECL, MIMODC, MIMMSN, MIEXTP ,                  MD056561
     C+  MIFRAM, MIPATH, MIAAC1, MIAAC2, MIAAC3, MIAAC4, MIAAC5,                            MD056561
     C+  MIAAC6, MIAAC7, MIAAC8, MIAAC9, MIAAC10, MIACOB, MIAPI1,                           MD056561
     C+  MIAPI2, MIAPI3, MIAPI4, MIAPI5, MIINS, MICON                                       MD056561
     C+ from SFMNUJW2 a, GPZONEPD                                                           MD056561
     C+ where not exists (select * from GZSFMENUPD b where                                  MD056561
     C+ a.MIINDX = b.MIINDX                                                                 MD056561
     C+ and b.MIZONE = :I_ZONE))                                                            MD056561
     C/end-exec                                                                             MD056561
                                                                                            MD056561
     C/EXEC SQL                                                                             MD056561
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD056561
     C/END-EXEC                                                                             MD056561
     C                   If        SQLCode <> 0                                             MD056561
     C                             and SQLCode <> 100                                       MD056561
     C                   EXSR      *PSSR                                                    MD056561
     C                   Endif                                                              MD056561
     C                   Z-ADD     TotRow        T_BSCNTW                                   MD056561
                                                                                            MD056561
      * Update GZ records which are different in SFMNUJW2                                   MD056561
     C/exec SQL                                                                             MD056561
     C+ update GZSFMENUPD a set                                                             MD056561
     C+ (a.MISECL, a.MIMODC, a.MIMMSN, a.MIEXTP ,                                           MD056561
     C+  a.MIFRAM, a.MIPATH, a.MIAAC1, a.MIAAC2, a.MIAAC3, a.MIAAC4, a.MIAAC5,              MD056561
     C+  a.MIAAC6, a.MIAAC7, a.MIAAC8, a.MIAAC9, a.MIAAC10, a.MIACOB, a.MIAPI1,             MD056561
     C+  a.MIAPI2, a.MIAPI3, a.MIAPI4, a.MIAPI5, a.MIINS, a.MICON ) =                       MD056561
     C+ (select b.MISECL, b.MIMODC, b.MIMMSN, b.MIEXTP ,                                    MD056561
     C+  b.MIFRAM, b.MIPATH, b.MIAAC1, b.MIAAC2, b.MIAAC3, b.MIAAC4, b.MIAAC5,              MD056561
     C+  b.MIAAC6, b.MIAAC7, b.MIAAC8, b.MIAAC9, b.MIAAC10, b.MIACOB, b.MIAPI1,             MD056561
     C+  b.MIAPI2, b.MIAPI3, b.MIAPI4, b.MIAPI5, b.MIINS, b.MICON                           MD056561
     C+ from SFMNUJW2 b, GPZONEPD                                                           MD056561
     C+ where a.MIINDX = b.MIINDX and ZOZONE = :I_ZONE)                                     MD056561
     C+ where exists (select * from SFMNUJW2 b where a.MIINDX = b.MIINDX)                   MD056561
     C+ and a.MIZONE = :I_ZONE                                                              MD056561
     C/end-exec                                                                             MD056561
                                                                                            MD056561
     C/EXEC SQL                                                                             MD056561
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD056561
     C/END-EXEC                                                                             MD056561
     C                   If        SQLCode <> 0                                             MD056561
     C                             and SQLCode <> 100                                       MD056561
     C                   EXSR      *PSSR                                                    MD056561
     C                   Endif                                                              MD056561
     C                   Z-ADD     TotRow        T_BSCNTU                                   MD056561
                                                                                            MD056561
     C**********         EXSR      UPD_SYNTOT                                               MD056561
     C*LR*******         EXSR      WRT_SYNLOG                                               MD056561
     C                   EXSR      WRT_SYNLOG                                               MD056561
     C                   SETON                                        LR                    MD056561
     C                   RETURN                                                             MD056561
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C*****UPD_GLOBALFILEBEGSR                                                              MD056561
     C**********         EVAL      I#ZONE = I_ZONE                                          MD056561
     C**********         EVAL      I#TRAP = 'N'                                             MD056561
     C**********         EVAL      I#BIMG = G_SFMENUJ1                                      MD056561
     C**********         EVAL      I#AIMG = G_SFMENUJ1                                      MD056561
     C*COPY*GPCPYSRCG,GPSFMENUPD                                                            MD056561
     C**********         ENDSR                                                              MD056561
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C*****UPD_SYNTOT    BEGSR                                                              MD056561
      **********                                                                            MD056561
     C******INMR         IFEQ      *OFF                                                     MD056561
     C******IN01         IFEQ      *ON                                                      MD056561
     C**********         ADD       1             T_BSCNTW                                   MD056561
     C**********         ELSE                                                               MD056561
     C**********         ADD       1             T_BSCNTD                                   MD056561
     C**********         ENDIF                                                              MD056561
     C**********         ELSE                                                               MD056561
     C***02*****         ADD       1             T_BSCNTU                                   MD056561
     C**********         ENDIF                                                              MD056561
      **********                                                                            MD056561
      **********                                                                            MD056561
     C**********         ENDSR                                                              MD056561
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
     C**********         CLEAR                   Z_SFMENUJ1                                 MD056561
     C**********         CLEAR                   G_SFMENUJ1                                 MD056561

      * Delete existing log records

     C                   EVAL      BSFILE = 'GZSFMENUPD'
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
