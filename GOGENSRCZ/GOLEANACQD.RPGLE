     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *                      CER073D
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOLEANACQD - Bulk Update of Global File GZLEANACQD           *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. CER073D            Date 28Nov19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER073B            Date 25Sep17               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073  *CREATE    Date 10Jul17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER073D - Upgrade of EML014 to FB2.1 SP21                    *
      *      EML014 - AnaCredit Reporting Enhancement                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073B - CER073 Change Control 2 (Recompile)                *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting                                 *
      *                                                               *
      *****************************************************************

     F**********LEANACI1  IP  AE           K DISK    RENAME(LEANACD0   : FormatZON)          CER073D
     FLEANACI1  IF   E           K DISK    RENAME(LEANACD0   : FormatZON)                    CER073D
     F                                     INFSR(*PSSR)
     F**********GZLEANACI0IS  AE           K DISK    RENAME(LEANACD0   : FormatGLB)          CER073D
     FGZLEANACI0IF   E           K DISK    RENAME(LEANACD0   : FormatGLB)                    CER073D
     F                                     PREFIX(G_)
     F                                     INFSR(*PSSR)
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D Z_LEANACI1    E DS                  EXTNAME(LEANACQD  )
     D G_LEANACI1    E DS                  EXTNAME(GZLEANACQD)
     D                                     PREFIX(G_)

     D BR              S              3    DIM(99)
     D SL              S             27    DIM(99)

     D SYNLOGREC       DS
     D  BSCNTW                 1      9S 0
     D  BSCNTD                10     18S 0
     D  BSCNTU                19     27S 0

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

     I**********FormatZON     01                                                             CER073D
     I**********                                ACBRCD        L1M2                           CER073D
     I**********                                ACLNRF        L1M1                           CER073D
     I**********FormatGLB     02                                                             CER073D
     I**********                                G_ACBRCD      L1M2                           CER073D
     I**********                                G_ACLNRF      L1M1                           CER073D

     C******INMR         IFEQ      *OFF                                                      CER073D
     C******IN01         IFEQ      *ON                                                       CER073D
     C**********         MOVEL     Z_LEANACI1    G_LEANACI1                                  CER073D
Z    C**********         EVAL      G_ACBRCD      = ACBRCD                                    CER073D
     C**********         EVAL      I#BFAF = 'A'                                              CER073D
     C**********         EXSR      UPD_GLOBALFILE                                            CER073D
     C**********         ELSE                                                                CER073D
     C**********         EVAL      I#BFAF = 'B'                                              CER073D
     C**********         EXSR      UPD_GLOBALFILE                                            CER073D
     C**********         ENDIF                                                               CER073D
     C**********         ELSE                                                                CER073D
     C***02*****         MOVE      ACBRCD        G_ACBRCD                                    CER073D
     C*****Z_LEANACI1    IFNE      G_LEANACI1                                                CER073D
     C***02*****         MOVEL     Z_LEANACI1    G_LEANACI1                                  CER073D
     C***02*****         EVAL      G_ACBRCD      = ACBRCD                                    CER073D
     C***02*****         EVAL      I#BFAF = 'A'                                              CER073D
     C***02*****         EXSR      UPD_GLOBALFILE                                            CER073D
     C**********         ELSE                                                                CER073D
     C***02*****         MOVE      *OFF          *IN02                                       CER073D
     C**********         ENDIF                                                               CER073D
     C**********         ENDIF                                                               CER073D
      *                                                                                      CER073D
     C     KAnac         KList                                                               CER073D
     C                   Kfld                    ACBrcd                                      CER073D
     C                   Kfld                    ACLnrf                                      CER073D
      *                                                                                      CER073D
     C                   movea     '00'          *IN(01)                                     CER073D
     C     *LOVAL        SETLL     LEANACI1                                                  CER073D
     C                   READ      FormatZon                              20                 CER073D
      *                                                                                      CER073D
     C     *In20         Doweq     *Off                                                      CER073D
      *                                                                                      CER073D
     C     KAnac         Chain     GZLEANACI0                         21                     CER073D
      *                                                                                      CER073D
     C     *In21         Ifeq      *Off                                                      CER073D
     C                   movea     '11'          *IN(01)                                     CER073D
     C                   else                                                                CER073D
     C                   movea     '10'          *IN(01)                                     CER073D
     C                   Endif                                                               CER073D
      *                                                                                      CER073D
     C     *In21         Ifeq      *Off                                                      CER073D
     C   02              Move      ACBRCD        G_ACBRCD                                    CER073D
     C     Z_LEANACI1    Ifne      G_LEANACI1                                                CER073D
     C   02              Movel     Z_LEANACI1    G_LEANACI1                                  CER073D
     C   02              Eval      G_ACBRCD      = ACBRCD                                    CER073D
     C   02              Eval      I#BFAF = 'A'                                              CER073D
     C   02              Exsr      UPD_GLOBALFILE                                            CER073D
     C                   Else                                                                CER073D
     C   02              Move      *Off          *In02                                       CER073D
     C                   Endif                                                               CER073D
     C                   Else                                                                CER073D
     C                   Movel     Z_LEANACI1    G_LEANACI1                                  CER073D
     C                   Eval      G_ACBRCD      = ACBRCD                                    CER073D
     C                   Eval      I#BFAF = 'A'                                              CER073D
     C                   Exsr      UPD_GLOBALFILE                                            CER073D
     C                   Endif                                                               CER073D
      *                                                                                      CER073D
     C                   Exsr      UPD_SYNTOT                                                CER073D
     C                   Read      FormatZon                              20                 CER073D
     C                   movea     '00'          *IN(01)                                     CER073D
     C                   Enddo                                                               CER073D
      *                                                                                      CER073D
     C     KGAnac        KList                                                               CER073D
     C                   Kfld                    G_ACBrcd                                    CER073D
     C                   Kfld                    G_ACLnrf                                    CER073D
      *                                                                                      CER073D
     C                   movea     '00'          *IN(01)                                     CER073D
     C     *LOVAL        SETLL     GZLEANACI0                                                CER073D
     C                   READ      FormatGlb                              20                 CER073D
      *                                                                                      CER073D
     C     *In20         Doweq     *Off                                                      CER073D
      *                                                                                      CER073D
     C     KGAnac        Chain     LEANACI1                           21                     CER073D
      *                                                                                      CER073D
     C     *In21         Ifeq      *Off                                                      CER073D
     C                   movea     '11'          *IN(01)                                     CER073D
     C                   else                                                                CER073D
     C                   movea     '01'          *IN(01)                                     CER073D
     C                   Endif                                                               CER073D
      *                                                                                      CER073D
     C     *IN21         Ifeq      *On                                                       CER073D
     C                   Eval      I#BFAF = 'B'                                              CER073D
     C                   Exsr      UPD_GLOBALFILE                                            CER073D
     C                   Endif                                                               CER073D
      *                                                                                      CER073D
     C                   EXSR      UPD_SYNTOT
     C                   Read      FormatGlb                              20                 CER073D
     C                   movea     '00'          *IN(01)                                     CER073D
     C                   Enddo                                                               CER073D
      *                                                                                      CER073D
     C***LR*****            EXSR      WRT_SYNLOG                                             CER073D
     C                   EXSR      WRT_SYNLOG                                                CER073D
      *                                                                                      CER073D
     C                   Unlock    GPSBLOGL0                                                 CER073D
     C                   Seton                                        LR                     CER073D
     C                   Return                                                              CER073D
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C     UPD_GLOBALFILEBEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_LEANACI1
     C                   EVAL      I#AIMG = G_LEANACI1
     C/COPY GPCPYSRCG,GPLEANACQD
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C     UPD_SYNTOT    BEGSR

B    C                   Z-ADD     1             I                 2 0
B    C   01ACBRCD        LOOKUP    BR(I)                                  99
B    C   02G_ACBRCD      LOOKUP    BR(I)                                  99
B    C     *IN99         IFEQ      *OFF
     C     '***'         LOOKUP    BR(I)                                  99
     C   01              MOVEL     ACBRCD        BR(I)
     C   02              MOVEL     G_ACBRCD      BR(I)
     C                   CLEAR                   SYNLOGREC
     C                   MOVEL     SYNLOGREC     SL(I)
     C                   ELSE
     C                   MOVEL     SL(I)         SYNLOGREC
     C                   ENDIF

     C******INMR         IFEQ      *OFF                                                      CER073D
     C     *IN21         Ifeq      *On                                                       CER073D
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

      * Write branch totals
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
     C                   CLEAR                   Z_LEANACI1
     C                   CLEAR                   G_LEANACI1

      * Delete existing log records

     C                   EVAL      BSFILE = 'GZLEANACQD'
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

      * Initialize branches
     C                   MOVE      '***'         BR

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
