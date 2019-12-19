     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/**** *  RPGBASEBNC                                                   *                     MD054605
/*STD *  RPGSQLBND                                                    *                     MD054605
/*EXI *  TEXT('Generated Code')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSDSVALPD - Bulk Update of Global File GZSDSVALPD           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *                                                               *
      *****************************************************************

     F*SDSVALL0* IP  AE           K DISK    RENAME(@SVALL0    : FormatZON)                  MD054605
     F**********                           INFSR(*PSSR)                                     MD054605
     F*GZSDSVALL0IS  AE           K DISK    RENAME(SDSVALD0   : FormatGLB)                  MD054605
     F**********                           PREFIX(G_)                                       MD054605
     F**********                           INFSR(*PSSR)                                     MD054605
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D*Z_SDSVALL0    E DS                  EXTNAME(SDSVALPD  )                              MD054605
     D*G_SDSVALL0    E DS                  EXTNAME(GZSDSVALPD)                              MD054605
     D**********                           PREFIX(G_)                                       MD054605

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
     D TotRow          S             13  0                                                  MD054605
     D SQLDynStmt      S           5000A                                                    MD054605

     I*FormatZON     01                                                                     MD054605
     I**********                                GISVAL        L1M1                          MD054605
     I*FormatGLB     02                                                                     MD054605
     I**********                                G_GISVAL      L1M1                          MD054605

     C******INMR         IFEQ      *OFF                                                     MD054605
     C******IN01         IFEQ      *ON                                                      MD054605
     C**********         MOVEL     Z_SDSVALL0    G_SDSVALL0                                 MD054605
Z    C**********         EVAL      G_GIZONE      = I_ZONE                                   MD054605
     C**********         EVAL      I#BFAF = 'A'                                             MD054605
     C**********         EXSR      UPD_GLOBALFILE                                           MD054605
     C**********         ELSE                                                               MD054605
     C**********         EVAL      I#BFAF = 'B'                                             MD054605
     C**********         EXSR      UPD_GLOBALFILE                                           MD054605
     C**********         ENDIF                                                              MD054605
     C**********         ELSE                                                               MD054605
     C***02*****         MOVEL     Z_SDSVALL0    G_SDSVALL0                                 MD054605
Z    C***02*****         EVAL      G_GIZONE      = I_ZONE                                   MD054605
     C***02*****         EVAL      I#BFAF = 'A'                                             MD054605
     C***02*****         EXSR      UPD_GLOBALFILE                                           MD054605
     C**********         ENDIF                                                              MD054605
                                                                                            MD054605
      * Delete GZ records which are not in SDSVLJW0                                         MD054605
     C/exec SQL                                                                             MD054605
     C+ delete from GZSDSVALPD A                                                            MD054605
     C+ where a.GIZONE = :I_ZONE and not exists                                             MD054605
     C+ (select * from SDSVLJW0 B where A.GISVAL = B.GISVAL)                                MD054605
     C/end-exec                                                                             MD054605
     C/EXEC SQL                                                                             MD054605
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCode <> 0                                             MD054605
     C                             and SQLCode <> 100                                       MD054605
     C                   EXSR      *PSSR                                                    MD054605
     C                   Endif                                                              MD054605
     C                   Z-ADD     TotRow        T_BSCNTD                                   MD054605
                                                                                            MD054605
      * Insert GZ records which are in SDSVLSJW0 but not in GZSDSVALPD                      MD054605
     C/exec SQL                                                                             MD054605
     C+ insert into GZSDSVALPD                                                              MD054605
     C+ (select GISVAL, GIMMOD, GIMMSN, GIDESC, GIVAL, GIDFT, GIHELP,                       MD054605
     C+ GIATTR, GIDLEN, GISUPP, GISWCH, GIALWB, GIJUST, GIEMSG, GILCD,                      MD054605
     C+ GILCT, ZOZONE as GIZONE  from SDSVLJW0 a , GPZONEPD                                 MD054605
     C+ where not exists (select * from GZSDSVALPD b where a.gisval = b.gisval)             MD054605
     C+ and ZOZONE = :I_ZONE)                                                               MD054605
     C/end-exec                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCode <> 0                                             MD054605
     C                             and SQLCode <> 100                                       MD054605
     C                   EXSR      *PSSR                                                    MD054605
     C                   Endif                                                              MD054605
     C                   Z-ADD     TotRow        T_BSCNTW                                   MD054605
                                                                                            MD054605
      * Update GZ records which are different in SDSVLJW0                                   MD054605
     C/exec SQL                                                                             MD054605
     C+ update GZSDSVALPD a set                                                             MD054605
     C+ (a.GISVAL, a.GIMMOD, a.GIMMSN, a.GIDESC, a.GIVAL, a.GIDFT, a.GIHELP,                MD054605
     C+ a.GIATTR, a.GIDLEN, a.GISUPP, a.GISWCH, a.GIALWB, a.GIJUST, a.GIEMSG,               MD054605
     C+ a.GILCD, a.GILCT, a.GIZONE) =                                                       MD054605
     C+ (select b.GISVAL, b.GIMMOD, b.GIMMSN, b.GIDESC, b.GIVAL, b.GIDFT,                   MD054605
     C+ b.GIHELP, b.GIATTR, b.GIDLEN, b.GISUPP, b.GISWCH, b.GIALWB, b.GIJUST,               MD054605
     C+ b.GIEMSG, b.GILCD, b.GILCT, ZOZONE as GIZONE from SDSVLJW0 b, GPZONEPD              MD054605
     C+ where b.GISVAL = a.GISVAL and ZOZONE = :I_ZONE)                                     MD054605
     C+ where exists (select * from SDSVLJW0 b where a.gisval = b.gisval)                   MD054605
     C+ and a.GIZONE = :I_ZONE                                                              MD054605
     C/end-exec                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCode <> 0                                             MD054605
     C                             and SQLCode <> 100                                       MD054605
     C                   EXSR      *PSSR                                                    MD054605
     C                   Endif                                                              MD054605
     C                   Z-ADD     TotRow        T_BSCNTU                                   MD054605
                                                                                            MD054605
     C**********         EXSR      UPD_SYNTOT                                               MD054605
     C*LR*******         EXSR      WRT_SYNLOG                                               MD054605
     C                   EXSR      WRT_SYNLOG                                               MD054605
     C                   SETON                                        LR                    MD054605
     C                   RETURN                                                             MD054605
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C*****UPD_GLOBALFILEBEGSR                                                              MD054605
     C**********         EVAL      I#ZONE = I_ZONE                                          MD054605
     C**********         EVAL      I#TRAP = 'N'                                             MD054605
     C**********         EVAL      I#BIMG = G_SDSVALL0                                      MD054605
     C**********         EVAL      I#AIMG = G_SDSVALL0                                      MD054605
     C*COPY*GPCPYSRCG,GPSDSVALPD                                                            MD054605
     C**********         ENDSR                                                              MD054605
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C*****UPD_SYNTOT    BEGSR                                                              MD054605
                                                                                            MD054605
     C******INMR         IFEQ      *OFF                                                     MD054605
     C******IN01         IFEQ      *ON                                                      MD054605
     C**********         ADD       1             T_BSCNTW                                   MD054605
     C**********         ELSE                                                               MD054605
     C**********         ADD       1             T_BSCNTD                                   MD054605
     C**********         ENDIF                                                              MD054605
     C**********         ELSE                                                               MD054605
     C***02*****         ADD       1             T_BSCNTU                                   MD054605
     C**********         ENDIF                                                              MD054605


     C**********         ENDSR                                                              MD054605
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

     C                   MOVEL     *BLANK        I#ERMS           50                       MD054605
     C**********         CLEAR                   Z_SDSVALL0                                MD054605
     C**********         CLEAR                   G_SDSVALL0

      * Delete existing log records

     C                   EVAL      BSFILE = 'GZSDSVALPD'
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
