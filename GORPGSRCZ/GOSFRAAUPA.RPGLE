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
      *  GOSFRAAUPA - Bulk Update of Global File GZSFRAAUPA           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 25Aug06               *
      *                 CRE024  *CREATE    Date 22Dec05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CPK025 - MidasPlus 1.3 packaging.  Wrong source file.        *
      *  CRE024 - Restricted Account                                  *
      *                                                               *
      *****************************************************************
 
     FSFRAAUV0  IP  AE           K DISK    RENAME(SFRAAUP0   : FormatZON)
     F                                     INFSR(*PSSR)
     FGZSFRAAUL0US  AE           K DISK    RENAME(SFRAAUP0   : FormatGLB)
     F                                     PREFIX(G_)
     F                                     INFSR(*PSSR)
     FGZSFRAAUPAO  A E           K DISK    RENAME(SFRAAUP0   : FormatGLBW)
     F                                     INFSR(*PSSR)
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)
 
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
     D Z_SFRAAUV0    E DS                  EXTNAME(SFRAAUPA  )
     D G_SFRAAUV0    E DS                  EXTNAME(GZSFRAAUPA)
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
 
     IFormatZON     01
     I                                          MFRAC         L1M2
     I                                          MAUSR         L1M1
     IFormatGLB     02
     I                                          G_MFRAC       L1M2
     I                                          G_MAUSR       L1M1
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
Z    C                   EVAL      MZONE       = I_ZONE
     C                   WRITE     FormatGLBW
     C                   ELSE
     C                   DELETE    FormatGLB
     C                   ENDIF
     C                   ELSE
     C   02              MOVEL     Z_SFRAAUV0    G_SFRAAUV0
Z    C   02              EVAL      G_MZONE       = I_ZONE
     C   02              EXSR      FIX_DATA
     C   02              UPDATE    FormatGLB
     C                   ENDIF
     C                   EXSR      UPD_SYNTOT
     CLR                 EXSR      WRT_SYNLOG
     C/SPACE 5
      ********************************************************************
      * Fix Data
      ********************************************************************
     C     FIX_DATA      BEGSR
     C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
     C                   PARM      I_ZONE        I#ZONE           10
     C                   PARM      'GZSFRAAUPA'  I#FILE           10
     C                   PARM      G_SFRAAUV0    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_SFRAAUV0
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C     UPD_SYNTOT    BEGSR
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
     C                   ADD       1             T_BSCNTW
     C                   ELSE
     C                   ADD       1             T_BSCNTD
     C                   ENDIF
     C                   ELSE
     C   02              ADD       1             T_BSCNTU
     C                   ENDIF
 
 
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
 
     C                   CLEAR                   Z_SFRAAUV0
     C                   CLEAR                   G_SFRAAUV0
 
      * Delete existing log records
 
     C                   EVAL      BSFILE = 'GZSFRAAUPA'
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
