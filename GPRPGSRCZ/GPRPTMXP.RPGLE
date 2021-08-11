     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Report ML Counterparty Exp by GL Category')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMXP  - Report ML Counterparty Exposure (by GL Category) *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103             Date 25Jun19               *
      *  Prev Amend No. FRAIMP             Date 16Apr13               *
      *                 NADC02             Date 12Jun12               *
      *                 NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103 - Upgraded MPlus 121 NADC01, NADC02 and FRAIMP ML     *
      *           Extracts to FB 2.1                                  *
      *  FRAIMP - ML Reporting to include FRA                         *
      *  NADC02 - ML REPORTING TO INCLUDE IRS                         *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
 
     FGPMLXPL0  IP   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FGZSDBANKPDIF   E             DISK
     F*PRPTMXPP1O****F  246        PRINTER                                                    NADC02
     F**RPTMXPP1O    F  261        PRINTER                                             NADC02 FRAIMP
     FGPRPTMXPP1O    F  276        PRINTER                                                    FRAIMP
     F                                     INFDS(SPOOLU)
 
      ** File Information Data Structure for GPRPTMXPP1
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
     D INSTR           S             10    DIM(10)
     D INST            S             10    DIM(20)
     D GLCAT           S              5    DIM(20)
     D INSTRGLC        S             15    DIM(20)
 
     D TIEX            S             15  0 DIM(20)
     D PEXP            S             15  0 DIM(20)
     D TDIF            S             15  0 DIM(20)
 
     D cTIEX           S             15  0 DIM(20)
     D cPEXP           S             15  0 DIM(20)
     D cTDIF           S             15  0 DIM(20)
 
     D tTIEX           S             15  0 DIM(20)
     D tPEXP           S             15  0 DIM(20)
     D tTDIF           S             15  0 DIM(20)
 
 
     D  MEINSTGLCAT    DS
     D  MEINST                 1     10
     D  MEGLCAT               11     15
 
 
     IGPMLXPD0
     I                                          MECNCD        L3
     I                                          MECUSTNAME    L2
     I                                          MELIMDEF      L1
 
      * Change of country
 
     C   L3              Z-ADD     99            LINENO
     C   L3              Z-ADD     0             cTIEX
     C   L3              Z-ADD     0             cPEXP
     C   L3              Z-ADD     0             cTDIF
 
      * Change of customer
 
     C   L2              SETON                                        40
     C   L2              Z-ADD     1             CHLINE
     C   L2              EXSR      PAG
     C   L2              EXCEPT    STRC
 
      * Change of limit defined
 
     C  NL2              DO
     C   L1              SETOFF                                       40
     C   L1              Z-ADD     1             CHLINE
     C   L1              EXSR      PAG
     C   L1              EXCEPT    STRC
     C                   ENDDO
 
     C   L1              Z-ADD     0             TIEX
     C   L1              Z-ADD     0             PEXP
     C   L1              Z-ADD     0             TDIF
 
      * Accumulate exposure
 
     C                   EXSR      ACCUM_EXPOS
 
      * Report exposure
     CL1                 EXSR      REPORT_EXPOS
 
      * Report country totals
     CL3                 EXSR      REPORT_CTYTOT
 
      * Final totals
     CLR                 EXSR      REPORT_FINTOT
      *****************************************************************
     C     ACCUM_EXPOS   BEGSR
 
      * INSTRUMENT
     C                   Z-ADD     1             #I
     C     MEINSTGLCAT   LOOKUP    INSTRGLC(#I)                           99
 
      * Total Inst Exp in USD  (GL Exposure)
      * Cpty Exposure in USD   (ML Exposure)
      * Difference in USD      (Diff)
 
     C                   ADD       METIEXUSD     TIEX(#I)
     C                   ADD       MEPEXPUSD     PEXP(#I)
     C                   ADD       METDIFUSD     TDIF(#I)
 
     C                   ADD       METIEXUSD     cTIEX(#I)
     C                   ADD       MEPEXPUSD     cPEXP(#I)
     C                   ADD       METDIFUSD     cTDIF(#I)
 
     C                   ADD       METIEXUSD     tTIEX(#I)
     C                   ADD       MEPEXPUSD     tPEXP(#I)
     C                   ADD       METDIFUSD     tTDIF(#I)
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_EXPOS  BEGSR
 
     C     TIEX(1)       COMP      0                                  2121
     C  N21PEXP(1)       COMP      0                                  2121
     C  N21TDIF(1)       COMP      0                                  2121
 
     C     TIEX(2)       COMP      0                                  2222
     C  N22PEXP(2)       COMP      0                                  2222
     C  N22TDIF(2)       COMP      0                                  2222
 
     C     TIEX(3)       COMP      0                                  2323
     C  N23PEXP(3)       COMP      0                                  2323
     C  N23TDIF(3)       COMP      0                                  2323
 
     C     TIEX(4)       COMP      0                                  2424
     C  N24PEXP(4)       COMP      0                                  2424
     C  N24TDIF(4)       COMP      0                                  2424
 
     C     TIEX(5)       COMP      0                                  2525
     C  N25PEXP(5)       COMP      0                                  2525
     C  N25TDIF(5)       COMP      0                                  2525
 
     C     TIEX(6)       COMP      0                                  2626
     C  N26PEXP(6)       COMP      0                                  2626
     C  N26TDIF(6)       COMP      0                                  2626
 
     C     TIEX(7)       COMP      0                                  2727
     C  N27PEXP(7)       COMP      0                                  2727
     C  N27TDIF(7)       COMP      0                                  2727
 
     C     TIEX(8)       COMP      0                                  2828
     C  N28PEXP(8)       COMP      0                                  2828
     C  N28TDIF(8)       COMP      0                                  2828
 
     C     TIEX(9)       COMP      0                                  2929
     C  N29PEXP(9)       COMP      0                                  2929
     C  N29TDIF(9)       COMP      0                                  2929
 
     C     TIEX(10)      COMP      0                                  3030
     C  N30PEXP(10)      COMP      0                                  3030
     C  N30TDIF(10)      COMP      0                                  3030
 
     C     TIEX(11)      COMP      0                                  3131
     C  N31PEXP(11)      COMP      0                                  3131
     C  N31TDIF(11)      COMP      0                                  3131
 
     C     TIEX(12)      COMP      0                                  3232
     C  N32PEXP(12)      COMP      0                                  3232
     C  N32TDIF(12)      COMP      0                                  3232
 
     C     TIEX(13)      COMP      0                                  3333
     C  N33PEXP(13)      COMP      0                                  3333
     C  N33TDIF(13)      COMP      0                                  3333
                                                                                              NADC02
     C     TIEX(14)      COMP      0                                  3434                    NADC02
     C  N34PEXP(14)      COMP      0                                  3434                    NADC02
     C  N34TDIF(14)      COMP      0                                  3434                    NADC02
                                                                                              FRAIMP
     C     TIEX(15)      COMP      0                                  3535                    FRAIMP
     C  N34PEXP(15)      COMP      0                                  3535                    FRAIMP
     C  N34TDIF(15)      COMP      0                                  3535                    FRAIMP
 
     C                   XFOOT     TIEX          TOTIEX           15 0
     C*******************SUB       TIEX(13)      TOTIEX                         * FX          NADC02
     C*********          SUB       TIEX(14)      TOTIEX                         * FX   NADC02 FRAIMP
     C                   SUB       TIEX(15)      TOTIEX                         * FX          FRAIMP
     C                   XFOOT     PEXP          TOPEXP           15 0
     C*******************SUB       PEXP(13)      TOPEXP                         * FX          NADC02
     C*********          SUB       PEXP(14)      TOPEXP                         * FX   NADC02 FRAIMP
     C                   SUB       PEXP(15)      TOTIEX                         * FX          FRAIMP
     C                   XFOOT     TDIF          TOTDIF           15 0
     C*******************SUB       TDIF(13)      TOTDIF                         * FX          NADC02
     C*********          SUB       TDIF(14)      TOTDIF                         * FX   NADC02 FRAIMP
     C                   SUB       TDIF(15)      TOTIEX                         * FX          FRAIMP
 
     C                   Z-ADD     3             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_CTYTOT BEGSR
 
     C                   XFOOT     cTIEX         TOTIEX
     C*******************SUB       cTIEX(13)     TOTIEX                         * FX          NADC02
     C*********          SUB       cTIEX(14)     TOTIEX                         * FX   NADC02 FRAIMP
     C                   SUB       cTIEX(15)     TOTIEX                         * FX          FRAIMP
     C                   XFOOT     cPEXP         TOPEXP
     C*******************SUB       cPEXP(13)     TOPEXP                         * FX          NADC02
     C*********          SUB       cPEXP(14)     TOPEXP                         * FX   NADC02 FRAIMP
     C                   SUB       cPEXP(15)     TOPEXP                         * FX          FRAIMP
     C                   XFOOT     cTDIF         TOTDIF
     C*******************SUB       cTDIF(13)     TOTDIF                         * FX          NADC02
     C*********          SUB       cTDIF(14)     TOTDIF                         * FX   NADC02 FRAIMP
     C                   SUB       cTDIF(15)     TOTDIF                         * FX          FRAIMP
 
     C                   Z-ADD     5             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    CTYTOTAL
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_FINTOT BEGSR
 
     C                   XFOOT     tTIEX         TOTIEX
     C*******************SUB       tTIEX(13)     TOTIEX                         * FX          NADC02
     C*********          SUB       tTIEX(14)     TOTIEX                         * FX   NADC02 FRAIMP
     C                   SUB       tTIEX(15)     TOTIEX                         * FX          FRAIMP
     C                   XFOOT     tPEXP         TOPEXP
     C*******************SUB       tPEXP(13)     TOPEXP                         * FX          NADC02
     C*********          SUB       tPEXP(14)     TOPEXP                         * FX   NADC02 FRAIMP
     C                   SUB       tPEXP(15)     TOPEXP                         * FX          FRAIMP
     C                   XFOOT     tTDIF         TOTDIF
     C*******************SUB       tTDIF(13)     TOTDIF                         * FX          NADC02
     C*********          SUB       tTDIF(14)     TOTDIF                         * FX   NADC02 FRAIMP
     C                   SUB       tTDIF(15)     TOTDIF                         * FX          FRAIMP
 
     C                   Z-ADD     5             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    FINTOTAL
 
      ** Ensure Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C     PAG           BEGSR
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   EXCEPT    PAGEHEAD
     C     7             ADD       CHLINE        LINENO
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   READ      GZSDBANKPD                             H1
 
      * LOAD INSTRUMENT GROUPS
 
     C                   EVAL      INSTR = 'ZZZZZZZZZZ'
     C                   Z-ADD     0             #I                4 0
     C                   READ      T_GRINSTLF                             99
     C     *IN99         DOWEQ     *OFF
     C                   IF        NLPARENT  <> 0
     C                             AND NLINSTCODE <> 'GLOBRE'
     C                             AND NLINSTCODE <> 'GLOBFX'
     C                   ADD       1             #I
     C                   EVAL      INSTR(#I)   = NLINSTCODE
     C                   ENDIF
     C                   READ      T_GRINSTLF                             99
     C                   ENDDO
     C                   SORTA     INSTR
     C                   ADD       1             #I
     C                   EVAL      INSTR(#I)   = 'GLOBFX'
      * INSTRUMENT/GL CAT
     C                   Z-ADD     1             #I
     C                   Z-ADD     0             #J                4 0
     C     INSTR(#I)     DOUEQ     'ZZZZZZZZZZ'
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   SELECT
      *GL
     C                   WHEN      INSTR(#I) = 'GLOBGL'
     C                   MOVE      '1 ON '       INSTRGLC(#J)
      *IR                                                                                     NADC02
     C                   WHEN      INSTR(#I) = 'GLOBIR'                                       NADC02
     C                   MOVE      '2 OFF'       INSTRGLC(#J)                                 NADC02
      *FR                                                                                     FRAIMP
     C                   WHEN      INSTR(#I) = 'GLOBFR'                                       FRAIMP
     C                   MOVE      '2 OFF'       INSTRGLC(#J)                                 FRAIMP
      *LE
     C                   WHEN      INSTR(#I) = 'GLOBLE'
     C                   MOVE      '1 ON '       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '2 OFF'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '3 MEM'       INSTRGLC(#J)
      *MM
     C                   WHEN      INSTR(#I) = 'GLOBMM'
     C                   MOVE      '1 ON '       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '4 FWD'       INSTRGLC(#J)
      *SE
     C                   WHEN      INSTR(#I) = 'GLOBSE'
     C                   MOVE      '1 ON '       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '2 OFF'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '3 MEM'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '4 FWD'       INSTRGLC(#J)
      *TI
     C                   WHEN      INSTR(#I) = 'GLOBTI'
     C                   MOVE      '1 ON '       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '2 OFF'       INSTRGLC(#J)
      *FX
     C                   WHEN      INSTR(#I) = 'GLOBFX'
     C                   MOVE      '2 OFF'       INSTRGLC(#J)
     C                   ENDSL
 
     C                   ADD       1             #I
     C                   ENDDO
 
     C                   MOVEL     INSTRGLC      INST
     C                   MOVE      INSTRGLC      GLCAT
 
     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0
 
     C                   ENDSR
      *****************************************************************
     OGPRPTMXPP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMXP '
     O                                           80 'COUNTERPARTY EXPOSURE +
     O                                              BY GL CATEGORY REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           12 'COUNTERPARTY'
     O                                           29 'LIMIT'
     O                       INST(1)             53
     O                       INST(2)             68
     O                       INST(3)             83
     O                       INST(4)             98
     O                       INST(5)            113
     O                       INST(6)            128
     O                       INST(7)            143
     O                       INST(8)            158
     O                       INST(9)            173
     O                       INST(10)           188
     O                       INST(11)           203
     O                       INST(12)           218
     O***********************                   232 'T O T A L  '                             NADC02
     O***********************INST(13)           246                                           NADC02
     O                       INST(13)           233                                           NADC02
     O                       INST(14)           248                                           FRAIMP
     O                                          262 'T O T A L  '                             FRAIMP
     O                       INST(15)           276                                           FRAIMP
     O*********                                 247 'T O T A L  '                      NADC02 FRAIMP
     O*********              INST(14)           261                                    NADC02 FRAIMP
     O                                           38 '|'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O          E            PAGEHEAD    1
     O                       GLCAT(1)            48
     O                       GLCAT(2)            63
     O                       GLCAT(3)            78
     O                       GLCAT(4)            93
     O                       GLCAT(5)           108
     O                       GLCAT(6)           123
     O                       GLCAT(7)           138
     O                       GLCAT(8)           153
     O                       GLCAT(9)           168
     O                       GLCAT(10)          183
     O                       GLCAT(11)          198
     O                       GLCAT(12)          213
     O***********************GLCAT(13)          241                                           NADC02
     O                       GLCAT(13)          228                                           NADC02
     O*********              GLCAT(14)          256                                    NADC02 FRAIMP
     O                       GLCAT(14)          243                                           FRAIMP
     O                       GLCAT(15)          271                                           FRAIMP
     O                                           38 '|'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O          E            PAGEHEAD    1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O                                          156 '=========================='
     O                                          182 '=========================='
     O                                          208 '=========================='
     O                                          234 '=========================='
     O                                          246 '=========================='
     O                                          261 '==============='                         NADC02
     O                                          276 '==============='                         FRAIMP
     O          E            PAGEHEAD    1
     O                       MECNCDNAM           33
     O          E            PAGEHEAD    1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O                                          156 '=========================='
     O                                          182 '=========================='
     O                                          208 '=========================='
     O                                          234 '=========================='
     O                                          246 '=========================='
     O                                          261 '==============='                         NADC02
     O                                          276 '==============='                         FRAIMP
     O          E            STRC        1
     O               40                          26 '--------------------------'
     O               40                          52 '--------------------------'
     O              N40                          52 '|-----------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          156 '--------------------------'
     O                                          182 '--------------------------'
     O                                          208 '--------------------------'
     O                                          234 '--------------------------'
     O                                          246 '--------------------------'
     O                                          261 '---------------'                         NADC02
     O                                          276 '---------------'                         FRAIMP
     O          E            TOTAL       1
     O               40      MECUSTNAME          28
     O                                           28 '   '
     O                       MELIMDEF            27
     O***********************TIEX(13)           246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTIEX             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TIEX(14)           261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTIEX             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                       TIEX(15)           276 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TOTIEX             261 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TIEX(14)           246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TIEX(13)           231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       TIEX(13)           231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       TIEX(12)           216 '   ,   ,   ,   ,  0-'
     O                       TIEX(11)           201 '   ,   ,   ,   ,  0-'
     O                       TIEX(10)           186 '   ,   ,   ,   ,  0-'
     O                       TIEX(9)            171 '   ,   ,   ,   ,  0-'
     O                       TIEX(8)            156 '   ,   ,   ,   ,  0-'
     O                       TIEX(7)            141 '   ,   ,   ,   ,  0-'
     O                       TIEX(6)            126 '   ,   ,   ,   ,  0-'
     O                       TIEX(5)            111 '   ,   ,   ,   ,  0-'
     O                       TIEX(4)             96 '   ,   ,   ,   ,  0-'
     O                       TIEX(3)             81 '   ,   ,   ,   ,  0-'
     O                       TIEX(2)             66 '   ,   ,   ,   ,  0-'
     O                       TIEX(1)             51 '   ,   ,   ,   ,  0-'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O****************************************** 97 '|'                                       NADC02
     O******************************************127 '|'                                       NADC02
     O******************************************187 '|'                                       NADC02
     O******************************************217 '|'                                       NADC02
     O******************************************232 '|'                                       NADC02
     O                                           38 '| GL     |'
     O          E            TOTAL       1
     O***********************PEXP(13)           246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOPEXP             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              PEXP(14)           261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOPEXP             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                       PEXP(15)           276 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TOPEXP             261 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       PEXP(14)           246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       PEXP(13)           231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       PEXP(12)           216 '   ,   ,   ,   ,  0-'
     O                       PEXP(11)           201 '   ,   ,   ,   ,  0-'
     O                       PEXP(10)           186 '   ,   ,   ,   ,  0-'
     O                       PEXP(9)            171 '   ,   ,   ,   ,  0-'
     O                       PEXP(8)            156 '   ,   ,   ,   ,  0-'
     O                       PEXP(7)            141 '   ,   ,   ,   ,  0-'
     O                       PEXP(6)            126 '   ,   ,   ,   ,  0-'
     O                       PEXP(5)            111 '   ,   ,   ,   ,  0-'
     O                       PEXP(4)             96 '   ,   ,   ,   ,  0-'
     O                       PEXP(3)             81 '   ,   ,   ,   ,  0-'
     O                       PEXP(2)             66 '   ,   ,   ,   ,  0-'
     O                       PEXP(1)             51 '   ,   ,   ,   ,  0-'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O                                           38 '| ML     |'
     O          E            TOTAL       1
     O*********************33TDIF(13)           246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTDIF             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            34TDIF(14)           261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTDIF             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     35TDIF(15)           276 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TOTDIF             261 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     34TDIF(14)           246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                     33TDIF(13)           231 '   ,   ,   ,   ,  0-'                    NADC02
     O                     32TDIF(12)           216 '   ,   ,   ,   ,  0-'
     O                     31TDIF(11)           201 '   ,   ,   ,   ,  0-'
     O                     30TDIF(10)           186 '   ,   ,   ,   ,  0-'
     O                     29TDIF(9)            171 '   ,   ,   ,   ,  0-'
     O                     28TDIF(8)            156 '   ,   ,   ,   ,  0-'
     O                     27TDIF(7)            141 '   ,   ,   ,   ,  0-'
     O                     26TDIF(6)            126 '   ,   ,   ,   ,  0-'
     O                     25TDIF(5)            111 '   ,   ,   ,   ,  0-'
     O                     24TDIF(4)             96 '   ,   ,   ,   ,  0-'
     O                     23TDIF(3)             81 '   ,   ,   ,   ,  0-'
     O                     22TDIF(2)             66 '   ,   ,   ,   ,  0-'
     O                     21TDIF(1)             51 '   ,   ,   ,   ,  0-'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O                                           38 '| ML- GL |'
     O          E            CTYTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          156 '--------------------------'
     O                                          182 '--------------------------'
     O                                          208 '--------------------------'
     O                                          234 '--------------------------'
     O                                          246 '--------------------------'
     O                                          261 '---------------'                         NADC02
     O                                          276 '---------------'                         FRAIMP
     O          E            CTYTOTAL    1
     O                       MECNCDNAM           33
     O***********************cTIEX(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTIEX             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              cTIEX(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTIEX             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                       cTIEX(15)          276 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TOTIEX             261 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       cTIEX(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       cTIEX(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       cTIEX(12)          216 '   ,   ,   ,   ,  0-'
     O                       cTIEX(11)          201 '   ,   ,   ,   ,  0-'
     O                       cTIEX(10)          186 '   ,   ,   ,   ,  0-'
     O                       cTIEX(9)           171 '   ,   ,   ,   ,  0-'
     O                       cTIEX(8)           156 '   ,   ,   ,   ,  0-'
     O                       cTIEX(7)           141 '   ,   ,   ,   ,  0-'
     O                       cTIEX(6)           126 '   ,   ,   ,   ,  0-'
     O                       cTIEX(5)           111 '   ,   ,   ,   ,  0-'
     O                       cTIEX(4)            96 '   ,   ,   ,   ,  0-'
     O                       cTIEX(3)            81 '   ,   ,   ,   ,  0-'
     O                       cTIEX(2)            66 '   ,   ,   ,   ,  0-'
     O                       cTIEX(1)            51 '   ,   ,   ,   ,  0-'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O                                           38 '| GL     |'
     O          E            CTYTOTAL    1
     O                                           26 'C O U N T R Y   T O T A L '
     O***********************cPEXP(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOPEXP             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              cPEXP(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOPEXP             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                       cPEXP(15)          276 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TOPEXP             261 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       cPEXP(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       cPEXP(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       cPEXP(12)          216 '   ,   ,   ,   ,  0-'
     O                       cPEXP(11)          201 '   ,   ,   ,   ,  0-'
     O                       cPEXP(10)          186 '   ,   ,   ,   ,  0-'
     O                       cPEXP(9)           171 '   ,   ,   ,   ,  0-'
     O                       cPEXP(8)           156 '   ,   ,   ,   ,  0-'
     O                       cPEXP(7)           141 '   ,   ,   ,   ,  0-'
     O                       cPEXP(6)           126 '   ,   ,   ,   ,  0-'
     O                       cPEXP(5)           111 '   ,   ,   ,   ,  0-'
     O                       cPEXP(4)            96 '   ,   ,   ,   ,  0-'
     O                       cPEXP(3)            81 '   ,   ,   ,   ,  0-'
     O                       cPEXP(2)            66 '   ,   ,   ,   ,  0-'
     O                       cPEXP(1)            51 '   ,   ,   ,   ,  0-'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O                                           38 '| ML     |'
     O          E            CTYTOTAL    1
     O***********************cTDIF(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTDIF             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              cTDIF(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTDIF             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                       cTDIF(15)          276 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TOTDIF             261 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       cTDIF(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       cTDIF(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       cTDIF(12)          216 '   ,   ,   ,   ,  0-'
     O                       cTDIF(11)          201 '   ,   ,   ,   ,  0-'
     O                       cTDIF(10)          186 '   ,   ,   ,   ,  0-'
     O                       cTDIF(9)           171 '   ,   ,   ,   ,  0-'
     O                       cTDIF(8)           156 '   ,   ,   ,   ,  0-'
     O                       cTDIF(7)           141 '   ,   ,   ,   ,  0-'
     O                       cTDIF(6)           126 '   ,   ,   ,   ,  0-'
     O                       cTDIF(5)           111 '   ,   ,   ,   ,  0-'
     O                       cTDIF(4)            96 '   ,   ,   ,   ,  0-'
     O                       cTDIF(3)            81 '   ,   ,   ,   ,  0-'
     O                       cTDIF(2)            66 '   ,   ,   ,   ,  0-'
     O                       cTDIF(1)            51 '   ,   ,   ,   ,  0-'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O                                           38 '| ML- GL |'
     O          E            CTYTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          156 '--------------------------'
     O                                          182 '--------------------------'
     O                                          208 '--------------------------'
     O                                          234 '--------------------------'
     O                                          246 '--------------------------'
     O                                          261 '---------------'                         NADC02
     O                                          276 '---------------'                         FRAIMP
     O          E            FINTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          156 '--------------------------'
     O                                          182 '--------------------------'
     O                                          208 '--------------------------'
     O                                          234 '--------------------------'
     O                                          246 '--------------------------'
     O                                          261 '---------------'                         NADC02
     O                                          276 '---------------'                         FRAIMP
     O          E            FINTOTAL    1
     O                                           22 'G R A N D   T O T A L '
     O***********************tTIEX(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTIEX             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              tTIEX(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTIEX             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                       tTIEX(15)          276 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TOTIEX             261 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       tTIEX(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       tTIEX(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       tTIEX(12)          216 '   ,   ,   ,   ,  0-'
     O                       tTIEX(11)          201 '   ,   ,   ,   ,  0-'
     O                       tTIEX(10)          186 '   ,   ,   ,   ,  0-'
     O                       tTIEX(9)           171 '   ,   ,   ,   ,  0-'
     O                       tTIEX(8)           156 '   ,   ,   ,   ,  0-'
     O                       tTIEX(7)           141 '   ,   ,   ,   ,  0-'
     O                       tTIEX(6)           126 '   ,   ,   ,   ,  0-'
     O                       tTIEX(5)           111 '   ,   ,   ,   ,  0-'
     O                       tTIEX(4)            96 '   ,   ,   ,   ,  0-'
     O                       tTIEX(3)            81 '   ,   ,   ,   ,  0-'
     O                       tTIEX(2)            66 '   ,   ,   ,   ,  0-'
     O                       tTIEX(1)            51 '   ,   ,   ,   ,  0-'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O                                           38 '| GL     |'
     O          E            FINTOTAL    1
     O***********************tPEXP(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOPEXP             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              tPEXP(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOPEXP             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                       tPEXP(15)          276 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TOPEXP             261 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       tPEXP(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       tPEXP(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       tPEXP(12)          216 '   ,   ,   ,   ,  0-'
     O                       tPEXP(11)          201 '   ,   ,   ,   ,  0-'
     O                       tPEXP(10)          186 '   ,   ,   ,   ,  0-'
     O                       tPEXP(9)           171 '   ,   ,   ,   ,  0-'
     O                       tPEXP(8)           156 '   ,   ,   ,   ,  0-'
     O                       tPEXP(7)           141 '   ,   ,   ,   ,  0-'
     O                       tPEXP(6)           126 '   ,   ,   ,   ,  0-'
     O                       tPEXP(5)           111 '   ,   ,   ,   ,  0-'
     O                       tPEXP(4)            96 '   ,   ,   ,   ,  0-'
     O                       tPEXP(3)            81 '   ,   ,   ,   ,  0-'
     O                       tPEXP(2)            66 '   ,   ,   ,   ,  0-'
     O                       tPEXP(1)            51 '   ,   ,   ,   ,  0-'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O                                           38 '| ML     |'
     O          E            FINTOTAL    1
     O***********************tTDIF(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTDIF             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              tTDIF(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTDIF             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                       tTDIF(15)          276 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TOTDIF             261 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       tTDIF(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       tTDIF(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       tTDIF(12)          216 '   ,   ,   ,   ,  0-'
     O                       tTDIF(11)          201 '   ,   ,   ,   ,  0-'
     O                       tTDIF(10)          186 '   ,   ,   ,   ,  0-'
     O                       tTDIF(9)           171 '   ,   ,   ,   ,  0-'
     O                       tTDIF(8)           156 '   ,   ,   ,   ,  0-'
     O                       tTDIF(7)           141 '   ,   ,   ,   ,  0-'
     O                       tTDIF(6)           126 '   ,   ,   ,   ,  0-'
     O                       tTDIF(5)           111 '   ,   ,   ,   ,  0-'
     O                       tTDIF(4)            96 '   ,   ,   ,   ,  0-'
     O                       tTDIF(3)            81 '   ,   ,   ,   ,  0-'
     O                       tTDIF(2)            66 '   ,   ,   ,   ,  0-'
     O                       tTDIF(1)            51 '   ,   ,   ,   ,  0-'
     O                                           52 '|'
     O                                           67 '|'                                       NADC02
     O                                           82 '|'                                       FRAIMP
     O                                          127 '|'                                       FRAIMP
     O                                          157 '|'                                       FRAIMP
     O                                          217 '|'                                       FRAIMP
     O*********                                 112 '|'                                NADC02 FRAIMP
     O*********                                 142 '|'                                NADC02 FRAIMP
     O*********                                 202 '|'                                NADC02 FRAIMP
     O*********                                 232 '|'                                NADC02 FRAIMP
     O                                          247 '|'                                       NADC02
     O                                          262 '|'                                       FRAIMP
     O*********                                 276 '|'                                       FRAIMP
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O                                           38 '| ML- GL |'
     O          E            FINTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          156 '--------------------------'
     O                                          182 '--------------------------'
     O                                          208 '--------------------------'
     O                                          234 '--------------------------'
     O                                          246 '--------------------------'
     O                                          261 '---------------'                         NADC02
     O                                          276 '---------------'                         FRAIMP
