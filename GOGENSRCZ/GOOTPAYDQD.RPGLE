     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOOTPAYDQD - Bulk Update of Global File GZOTPAYDQD           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR1084524          Date 13Feb13               *
      *  Prev Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1084524 - Performance issue on IPAY & OPAY listview        *
      *              (Recompile)                                      *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
 
     FOTPAYQL0  IP  AE           K DISK    RENAME(OTPAYQD0   : FormatZON)
     F                                     INFSR(*PSSR)
     FGZOTPAYQL0IS  AE           K DISK    RENAME(OTPAYQD0   : FormatGLB)
     F                                     PREFIX(G_)
     F                                     INFSR(*PSSR)
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
     D Z_OTPAYQL0    E DS                  EXTNAME(OTPAYDQD  )
     D G_OTPAYQL0    E DS                  EXTNAME(GZOTPAYDQD)
     D                                     PREFIX(G_)
 
B    D BR              S              3    DIM(99)
B    D SL              S             27    DIM(99)
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
 
     IFormatZON     01
     I                                          OTPREF        L1M1
     IFormatGLB     02
     I                                          G_OTPREF      L1M1
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
     C                   MOVEL     Z_OTPAYQL0    G_OTPAYQL0
     C                   EVAL      G_OTBRCA      = OTBRCA
     C                   EVAL      I#BFAF = 'A'
     C                   EXSR      UPD_GLOBALFILE
     C                   ELSE
     C                   EVAL      I#BFAF = 'B'
     C                   EXSR      UPD_GLOBALFILE
     C                   ENDIF
     C                   ELSE
     C   02              MOVEL     Z_OTPAYQL0    G_OTPAYQL0
     C   02              EVAL      G_OTBRCA      = OTBRCA
     C   02              EVAL      I#BFAF = 'A'
     C   02              EXSR      UPD_GLOBALFILE
     C                   ENDIF
     C                   EXSR      UPD_SYNTOT
     CLR                 EXSR      WRT_SYNLOG
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C     UPD_GLOBALFILEBEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_OTPAYQL0
     C                   EVAL      I#AIMG = G_OTPAYQL0
     C/COPY GPCPYSRCG,GPOTPAYDQD
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C     UPD_SYNTOT    BEGSR
 
     C                   Z-ADD     1             I                 2 0
     C   01OTBRCA        LOOKUP    BR(I)                                  99
     C   02G_OTBRCA      LOOKUP    BR(I)                                  99
     C     *IN99         IFEQ      *OFF
     C     '***'         LOOKUP    BR(I)                                  99
     C   01              MOVEL     OTBRCA        BR(I)
     C   02              MOVEL     G_OTBRCA      BR(I)
     C                   CLEAR                   SYNLOGREC
     C                   MOVEL     SYNLOGREC     SL(I)
     C                   ELSE
     C                   MOVEL     SL(I)         SYNLOGREC
     C                   ENDIF
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
     C                   ADD       1             BSCNTW
     C                   ADD       1             T_BSCNTW
     C                   ELSE
     C                   ADD       1             BSCNTD
     C                   ADD       1             T_BSCNTD
     C                   ENDIF
     C                   ELSE
     C   02              ADD       1             BSCNTU
     C   02              ADD       1             T_BSCNTU
     C                   ENDIF
 
     C                   MOVEL     SYNLOGREC     SL(I)
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Write to Synchronization Log
      ********************************************************************
     C     WRT_SYNLOG    BEGSR
 
      ** Write overall totals
 
     C                   MOVEL     '***'         BSBRCA
     C                   Z-ADD     T_BSCNTW      BSCNTW
     C                   Z-ADD     T_BSCNTD      BSCNTD
     C                   Z-ADD     T_BSCNTU      BSCNTU
 
     C                   EVAL      BSDATE = PSRunDateA
     C                   EVAL      BSJOB  = PSJobName
     C                   EVAL      BSUSER = PSUser
     C                   EVAL      BSJOBN = PSJobNoA
 
     C                   EXSR      RECD_TIME
     C                   EVAL      TIME_END = NUM_TIME
     C                   EVAL      BSETIM   = BUF_TIME
 
      ** Calculate total number of seconds
 
     C                   EXSR      CAL_TOS
 
     C                   WRITE     GPSBLOGD0
 
      ** Write branch totals
 
     C                   Z-ADD     1             I                 2 0
     C     BR(I)         DOWNE     '***'
     C                   MOVEL     BR(I)         BSBRCA
     C                   MOVEL     SL(I)         SYNLOGREC
     C                   WRITE     GPSBLOGD0
     C                   ADD       1             I
     C                   ENDDO
 
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
     C                   CLEAR                   Z_OTPAYQL0
     C                   CLEAR                   G_OTPAYQL0
 
      ** Delete existing log records
 
     C                   EVAL      BSFILE = 'GZOTPAYDQD'
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
 
      ** Initialize branches
 
     C                   MOVE      '***'         BR
 
      ** Initialize overall totals
 
     C                   Z-ADD     *ZERO         T_BSCNTW          9 0
     C                   Z-ADD     *ZERO         T_BSCNTD          9 0
     C                   Z-ADD     *ZERO         T_BSCNTU          9 0
 
      ** Key lists
 
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
