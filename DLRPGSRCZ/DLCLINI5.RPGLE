     H DEBUG
     H COPYRIGHT('(C) Copyright Midas-Kapiti International Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas DL Create transfer keys')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLCLINI5 - Create Transfer Keys                              *
      *             (Dealing initialisation program)                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER049             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG9397            Date 14Nov05               *
      *                 CDL038  *CREATE    Date 10May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  BUG9397 - Swap fees reversed with debit not credit           *
      *  CDL038 - Extended Deal Sub Type                              *
      *                                                               *
      *****************************************************************
 
     FACKEYAL   IP   E             DISK    RENAME(ACKEYALF:INACKF)
     FACKEY     UF A E           K DISK    PREFIX(N_)
 
     FQSYSPRT   O    F  132        PRINTER USROPN
 
     D DB              S              2    DIM(10) CTDATA PERRCD(10)
     D DC              S              2    DIM(30) CTDATA PERRCD(30)
     D DD              S              2    DIM(30) CTDATA PERRCD(30)
     D DE              S              2    DIM(30) CTDATA PERRCD(30)
     D DG              S              2    DIM(30) CTDATA PERRCD(30)
 
     D IGNDT           S              2    DIM(999)   ASCEND
     D ACKINV          S             80    DIM(9999)  ASCEND
 
     D                 DS
     D R_AKEY                  1     14
     D AKY                     1     14    DIM(14)
     D R_DTYP                  1      2
     D R_EVTPOS                3      3
     D R_DLST                  4      5
     D R_MIDPOS                6      9
     D R_AMTPOS               10     10
     D R_CLAS                 11     14
 
 
     D O_NCD           S              2A   DIM(6)
     D O_PRF           S              1S 0 DIM(6)
     D O_ACD           S             10S 0 DIM(6)
     D O_ACDA          S             11A   DIM(6)
 
     D O_ACKEYAL     E DS                  EXTNAME(ACKEYAL)
     D NCD                    38     49    DIM(6)
     D PRF                    50     55    DIM(6)
     D ACD                    97    156    DIM(6) ASCEND
 
     D N_ACKEYAL     E DS                  EXTNAME(ACKEYAL) PREFIX(N_)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     C     RECI          CABNE     'D'           BYPASS
 
     C                   MOVEL     *BLANK        R_FILE
 
     C                   EVAL      R_AKEY = AKEY
 
     C                   EXSR      CHECK_DTYP
 
     C     R_FILE        IFEQ      'DC'
     C                   EXSR      LOANDEP_TRANS
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DD'
     C                   EXSR      NAPURCH_TRANS
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DG'
     C                   SELECT
     C     R_DTYP        WHENEQ    'FR'
     C                   EXSR      FRAS_TRANS
     C                   OTHER
     C                   EXSR      DERIVS_TRANS
     C                   ENDSL
     C                   ENDIF
 
     C     BYPASS        TAG
 
     CLR                 EXSR      FINISH
      /SPACE 5
      ********************************************************************
     C     CHECK_DTYP    BEGSR
     C                   SETOFF                                       99
     C                   Z-ADD     1             X                 2 0
 
     C     R_DTYP        LOOKUP    DB(X)                                  99
     C     *IN99         IFEQ      *ON
     C     R_DTYP        IFNE      'OP'
     C     R_DTYP        OREQ      'OP'
     C     R_EVTPOS      ANDEQ     'D'
     C     R_MIDPOS      ANDNE     '    '
     C     R_DTYP        OREQ      'OP'
     C     R_EVTPOS      ANDEQ     'V'
     C                   MOVEL     'DB'          R_FILE
     C                   ENDIF
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C     R_DTYP        LOOKUP    DC(X)                                  99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'DC'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C     R_DTYP        LOOKUP    DD(X)                                  99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'DD'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C     R_DTYP        LOOKUP    DE(X)                                  99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'DE'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C     R_DTYP        LOOKUP    DG(X)                                  99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'DG'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C                   Z-ADD     1             IG                4 0
     C     R_DTYP        LOOKUP    IGNDT(IG)                              99
     C     *IN99         IFEQ      *OFF
     C     '  '          LOOKUP    IGNDT(IG)                              99
     C                   MOVEL     R_DTYP        IGNDT(IG)
     C                   ENDIF
 
     C     END_CHECK     ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     LOANDEP_TRANS BEGSR
 
      * Transfer principal a/c key
 
     C                   MOVE      'V'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'A'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'A'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
      * Transfer date unaccrued interest a/c key
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'A'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'I'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     NAPURCH_TRANS BEGSR
 
      * Transfer date face value a/c key
 
     C                   MOVE      'V'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'F'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'F'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
      * Transfer date unaccrued discount/premium a/c key
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'D'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'D'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'C'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'C'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
      * Transfer date unaccrued interest a/c key
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'I'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'I'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FRAS_TRANS    BEGSR
 
      * Transfer date FRA unaccrued settlement amount a/c key
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'P'           AKY(9)
     C                   MOVE      'A'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'P'           AKY(9)
     C                   MOVE      'I'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'R'           AKY(9)
     C                   MOVE      'A'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'R'           AKY(9)
     C                   MOVE      'I'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     DERIVS_TRANS  BEGSR
 
      * Transfer date our unaccrued interest a/c key
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'P'           AKY(9)
     C                   MOVE      'A'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'P'           AKY(9)
     C                   MOVE      'I'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
      * Transfer date their unaccrued interest a/c key
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'R'           AKY(9)
     C                   MOVE      'A'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'R'           AKY(9)
     C                   MOVE      'I'           AKY(10)
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
      * Transfer date unaccrued fee a/c key
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'P'           AKY(9)
     C                   MOVE      'F'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'P'           AKY(9)
     C                   MOVE      'F'           AKY(10)
     C                   Z-ADD     ACD4          ACD1                                        BUG9397
     C                   Z-ADD     0             ACD4                                        BUG9397
     C                   Z-ADD     PRF4          PRF1                                        BUG9397
     C                   Z-ADD     0             PRF4                                        BUG9397
     C                   MOVEL     NCD4          NCD1                                        BUG9397
     C                   MOVEL     *BLANK        NCD4                                        BUG9397
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
     C                   MOVE      'R'           AKY(9)
     C                   MOVE      'F'           AKY(10)
     C     R_AKEY        IFEQ      AKEY
     C                   EXSR      RMV_OFFBS_ACOD
     C                   MOVE      'T'           AKY(3)
     C                   MOVE      'R'           AKY(9)
     C                   MOVE      'F'           AKY(10)
     C                   Z-ADD     ACD1          ACD4                                        BUG9397
     C                   Z-ADD     0             ACD1                                        BUG9397
     C                   Z-ADD     PRF1          PRF4                                        BUG9397
     C                   Z-ADD     0             PRF1                                        BUG9397
     C                   MOVEL     NCD1          NCD4                                        BUG9397
     C                   MOVEL     *BLANK        NCD1                                        BUG9397
     C                   EXSR      WRT_ACKEYAL
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     RMV_OFFBS_ACODBEGSR
 
     C                   MOVE      NCD           O_NCD
     C                   MOVE      PRF           O_PRF
     C                   MOVE      ACD           O_ACD
     C                   MOVE      ACD           O_ACDA
 
      *   As the transfer keys should move only asset and liability balances
      *     Remove all references to accounts that are not assets or liabilities
 
     C                   Z-ADD     1             X
     C     X             DOWLE     6
     C                   MOVEL     ACD(X)        @ACCD
     C                   EXSR      ACS_ACOD
     C     A5ACSC        IFNE      'AS'
     C     A5ACSC        ANDNE     'LI'
     C     ACD(X)        OREQ      *ZERO
     C                   MOVEL     *BLANK        NCD(X)
     C                   MOVEL     '0'           PRF(X)
     C                   MOVEL     *ZEROS        ACD(X)
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
      * Count NEW number of account codes
 
     C                   Z-ADD     *ZERO         Count             3 0
     C                   Z-ADD     1             X
     C     X             DOWLE     6
     C     ACD(X)        IFNE      *ZERO
     C                   ADD       1             Count
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
      * Hash total OLD account codes
 
     C                   Z-ADD     *ZERO         Accode#Total     15 0
     C                   Z-ADD     1             X
     C     X             DOWLE     6
     C     O_ACD(X)      IFNE      *ZERO
     C     X             IFLE      3
     C                   ADD       O_ACD(X)      Accode#Total
     C                   ELSE
     C                   SUB       O_ACD(X)      Accode#Total
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
      * Log account keys requiring investigation
      *  (If new a/c key contains no account codes or more than one account code
      *   and if the original a/c key contained net posting)
 
     C     Count         IFNE      1
     C     Accode#Total  ANDNE     *ZERO
     C                   ADD       1             IN
     C                   MOVEL     R_AKEY        ACKINV(IN)
     C                   MOVEA     O_ACDA        W_66             66
     C                   MOVE      W_66          ACKINV(IN)
 
      * If internal deposit or internal loan
      * as accounting may be off-balance sheet, restore old a/cing
 
     C     R_DTYP        IFEQ      'ID'
     C     R_DTYP        OREQ      'IL'
     C                   MOVE      O_NCD         NCD
     C                   MOVE      O_PRF         PRF
     C                   MOVE      O_ACD         ACD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     ACS_ACOD      BEGSR
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @ACCD            10
     C     SDACOD        PARM      SDACOD        DSSDY
     C     @RTCD         IFNE      *BLANK
     C                   CLEAR                   SDACOD
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     WRT_ACKEYAL   BEGSR
 
     C     R_AKEY        CHAIN     ACKEYALF                           99
     C                   EVAL      N_ACKEYAL = O_ACKEYAL
     C                   EVAL      N_LCD     = BJRDNB
     C                   EVAL      N_AKEY    = R_AKEY
     C     *IN99         IFEQ      *ON
     C                   EVAL      N_CHTP    = 'I'
     C                   WRITE     ACKEYALF
     C                   ELSE
     C                   EVAL      N_CHTP    = 'A'
     C                   UPDATE    ACKEYALF
     C                   ENDIF
 
     C                   IF        N_CHTP    = 'I'
     C                   MOVEL     *BLANK        N_AKEY
     C     N_AKEY        CHAIN     ACKEYAKF                           99
     C     *IN99         IFEQ      *OFF
     C                   ADD       1             N_NINS
     C                   ADD       1             N_NREC1
     C                   UPDATE    ACKEYAKF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FINISH        BEGSR
 
      * Sort report arrays
 
     C                   SORTA     IGNDT
     C                   SORTA     ACKINV
 
     C                   OPEN      QSYSPRT
 
      * Report completion
 
     C                   EXCEPT    FIN
 
      * Report deal types ignored
 
     C                   Z-ADD     1             IG
     C     *BLANK        LOOKUP    IGNDT(IG)                          99
     C     *IN99         IFEQ      *ON
     C     IG            DOWLE     999
     C                   EXCEPT    IGN
     C                   ADD       1             IG
     C                   ENDDO
     C                   ENDIF
 
      * Report account keys requiring investigation
 
     C                   Z-ADD     1             IN
     C     *BLANK        LOOKUP    ACKINV(IN)                         99
     C     *IN99         IFEQ      *ON
     C                   EXCEPT    INVI
     C     IN            DOWLE     9999
     C                   EXCEPT    INV
     C                   ADD       1             IN
     C                   ENDDO
     C                   ENDIF
 
     C                   CLOSE     QSYSPRT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
     C                   MOVEL     *BLANK        R_FILE           10
     C                   MOVEL     *BLANK        R_EVTPOS          1
     C                   MOVEL     *BLANK        R_MIDPOS          4
     C                   MOVEL     *BLANK        R_PORPOS          1
     C                   MOVEL     *BLANK        R_AMTPOS          1
     C                   Z-ADD     1             IN                5 0
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
      ********************************************************************
     OQSYSPRT   E            FIN         1
     O                                           26 'PROGRAM COMPLETED NORMALLY'
     O          E            FIN         2  0
     O                                           26 'DEAL TYPES IGNORED ARE:   '
     O          E            IGN            1
     O                       IGNDT(IG)           25
     O          E            INVI        2  0
     O                                           26 'ACKEYS TO BE INVESTIGATED:'
     O          E            INV            1
     O                       ACKINV(IN)         107
** DB - DEALSDB DTYP
FPFSPISICXSWOPOTPSNX
** DC - DEALSDC DTYP
IPTICLLNDLITTDCDCIILIDFLDPLPFTDTLT
** DD - DEALSDD DTYP
C1C2BPBDTBDATA
** DE - DEALSDE DTYP
CSBSBRTSRATR
** DG - DEALSDG DTYP
FRRSRXRPRRRF
