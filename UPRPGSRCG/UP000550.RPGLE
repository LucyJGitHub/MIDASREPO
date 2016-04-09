     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Compare screen handling')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000550 - Compare screen handling                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSM005  *REWRITE   Date 18Aug05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CUP001 *CREATE     Date 23Dec98               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSM005 - Rewrite of UP0550 and moved to global layer.        *
      *  CUP001 - Introduction of BRIDGE                              *
      *                                                               *
     F*****************************************************************
     FUP000550DFCF   E             WORKSTN USROPN
     FQSYSPRT   O    F  132        PRINTER USROPN
     D ECR             S             80    DIM(24)
     D LIG             S              1    DIM(80)
     D UL              S              1    DIM(80)
     D HI              S              1    DIM(80)
     D OVR             S             80    DIM(1) CTDATA PERRCD(1)
     D OVR2            S             80    DIM(1) CTDATA PERRCD(1)
     D BUFFER          DS          2048
     D  B                      1   2048
     D                                     DIM(2048)
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    OVR
     C                   PARM      80            CMDLN            15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    OVR2
     C                   PARM      80            CMDLN            15 5
     C                   OPEN      UP000550DF
     C                   OPEN      QSYSPRT
     C                   BITOFF    '01234567'    HEX00             1
     C                   BITOFF    '01234567'    HEX02             1
     C                   BITOFF    '01234567'    HEX04             1
     C                   BITOFF    '01234567'    HEX10             1
     C                   BITOFF    '01234567'    HEX62             1
     C                   BITOFF    '01234567'    HEX73             1
     C                   BITON     '6'           HEX02
     C                   BITON     '5'           HEX04
     C                   BITON     '3'           HEX10
     C                   BITON     '126'         HEX62
     C                   BITON     '12367'       HEX73
     C                   MOVE      *BLANKS       B
     C                   MOVE      HEX00         B(1)
     C                   MOVE      HEX02         B(2)
     C                   MOVE      HEX10         B(3)
     C                   MOVE      HEX00         B(4)
     C                   MOVE      HEX73         B(5)
     C                   MOVE      HEX04         B(6)
     C                   MOVE      HEX62         B(7)
     C                   EXFMT     FMT#1
     C                   MOVEA     B(1)          ECR(1)
     C                   BITOFF    '01234567'    HEX20             1
     C                   BITON     '2'           HEX20
     C                   BITOFF    '01234567'    HEX3F             1
     C                   BITON     '234567'      HEX3F
     C                   MOVEA     '000'         *IN(81)
     C     1             DO        24            I                 3 0
     C                   MOVEA     ECR(I)        LIG(1)
     C                   MOVE      *BLANKS       HI
     C                   MOVE      *BLANKS       UL
     C                   MOVEA     '00'          *IN(72)
     C     1             DO        80            J                 3 0
     C     LIG(J)        IFLT      HEX20
     C                   MOVE      *BLANKS       LIG(J)
     C                   END
     C                   MOVE      LIG(J)        BYTE              1
     C     BYTE          IFGE      HEX20
     C     BYTE          ANDLE     HEX3F
     C                   MOVEA     '000'         *IN(81)
     C                   END
     C     *IN81         IFEQ      '1'
     C                   MOVE      *BLANKS       LIG(J)
     C                   END
     C     *IN82         IFEQ      '1'
     C                   MOVE      LIG(J)        HI(J)
     C                   MOVE      '1'           *IN72
     C                   END
     C     *IN83         IFEQ      '1'
     C                   MOVE      '_'           UL(J)
     C                   MOVE      '1'           *IN73
     C                   END
     C     BYTE          IFGE      HEX20
     C     BYTE          ANDLE     HEX3F
     C                   TESTB     '567'         BYTE                     81
     C     *IN81         IFEQ      '0'
     C                   TESTB     '6'           BYTE                     82
     C                   TESTB     '5'           BYTE                     83
     C                   END
     C                   MOVE      *BLANKS       LIG(J)
     C                   END
     C                   END
     C     *IN72         IFEQ      '1'
     C     1             DO        3             J
     C                   EXCEPT    LIGHI
     C                   END
     C                   END
     C     *IN73         IFEQ      '1'
     C                   EXCEPT    LIGUL
     C                   END
     C                   EXCEPT    DETAIL
     C                   END
     C                   SETON                                            LR
     OQSYSPRT   E            DETAIL      0  1
     O                       LIG                 80
     O          E            LIGHI       0  0
     O                       HI                  80
     O          E            LIGUL       0  0
     O                       UL                  80
**
OVRDSPF UP000550DF UP000551DF LVLCHK(*NO)
**
OVRPRTF QSYSPRT PAGRTT(0) OUTQ(QUALITY) PRTTXT(*BLANK) SPLFNAME(HARDCOPY)
