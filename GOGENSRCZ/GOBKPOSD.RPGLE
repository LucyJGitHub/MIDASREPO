     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBKPOSD   - Bulk Update of Global File GZBKPOSD             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15716           Date 18Feb08               *
      *                 246619             Date 28Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CSE074             Date 30Aug05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP107 - Global Layer - GOC0100 Task Split                   *
      *  BUG15716 - Increase array size to handle up to 999 branches  *
      *  246619 - Recompile over changes in PF/GZBKPOSD.              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FBKPOSBR   IP  AE           K DISK    RENAME(BKPOSDF    : FormatZON)
     F                                     INFSR(*PSSR)
     FGZBKPOSL0 IS  AE           K DISK    RENAME(BKPOSDF    : FormatGLB)
     F                                     PREFIX(G_)
     F                                     INFSR(*PSSR)
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)
 
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
     D Z_BKPOSBR     E DS                  EXTNAME(BKPOSD    )
     D G_BKPOSBR     E DS                  EXTNAME(GZBKPOSD  )
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
 
     IFormatZON     01
     I                                          BPBA          L1M6
     I                                          BPSC          L1M5
     I                                          BPBK          L1M4
     I                                          BPMK          L1M3
     I                                          BPTV          L1M2
     I                                          BPPD          L1M1
     IFormatGLB     02
     I                                          G_BPBA        L1M6
     I                                          G_BPSC        L1M5
     I                                          G_BPBK        L1M4
     I                                          G_BPMK        L1M3
     I                                          G_BPTV        L1M2
     I                                          G_BPPD        L1M1
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
     C                   MOVEL     Z_BKPOSBR     G_BKPOSBR
B    C                   EVAL      G_BPBA        = BPBA
     C                   EVAL      I#BFAF = 'A'
     C                   EXSR      UPD_GLOBALFILE
     C                   ELSE
     C                   EVAL      I#BFAF = 'B'
     C                   EXSR      UPD_GLOBALFILE
     C                   ENDIF
     C                   ELSE
     C   02              EVAL      G_BPBA = BPBA                                              CGP017
     C     Z_BKPOSBR     IFNE      G_BKPOSBR                                                  CGP017
     C   02              MOVEL     Z_BKPOSBR     G_BKPOSBR
B    C   02              EVAL      G_BPBA        = BPBA
     C   02              EVAL      I#BFAF = 'A'
     C   02              EXSR      UPD_GLOBALFILE
     C                   ELSE                                                                 CGP017
     C   02              EVAL      *IN02 = *OFF                                               CGP017
     C                   ENDIF                                                                CGP017
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
     C                   EVAL      I#BIMG = G_BKPOSBR
     C                   EVAL      I#AIMG = G_BKPOSBR
     C/COPY GPCPYSRCG,GPBKPOSD
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C     UPD_SYNTOT    BEGSR
 
B    C**********         Z-ADD     1             I                 2 0                      BUG15716
B    C                   Z-ADD     1             I                 3 0                      BUG15716
B    C   01BPBA          LOOKUP    BR(I)                                  99
B    C   02G_BPBA        LOOKUP    BR(I)                                  99
B    C     *IN99         IFEQ      *OFF
B    C     '***'         LOOKUP    BR(I)                                  99
B    C   01              MOVEL     BPBA          BR(I)
B    C   02              MOVEL     G_BPBA        BR(I)
B    C                   CLEAR                   SYNLOGREC
B    C                   MOVEL     SYNLOGREC     SL(I)
B    C                   ELSE
B    C                   MOVEL     SL(I)         SYNLOGREC
B    C                   ENDIF
B
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
B    C                   ADD       1             BSCNTW
     C                   ADD       1             T_BSCNTW
     C                   ELSE
B    C                   ADD       1             BSCNTD
     C                   ADD       1             T_BSCNTD
     C                   ENDIF
     C                   ELSE
B    C   02              ADD       1             BSCNTU
     C   02              ADD       1             T_BSCNTU
     C                   ENDIF
 
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
 
     C                   MOVEL     *BLANK        I#ERMS           50
     C                   CLEAR                   Z_BKPOSBR
     C                   CLEAR                   G_BKPOSBR
 
      * Delete existing log records
 
     C                   EVAL      BSFILE = 'GZBKPOSD  '
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
