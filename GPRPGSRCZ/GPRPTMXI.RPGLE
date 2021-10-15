     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/********TEXT('Midas GP Report ML Counterparty Exp by GL Category')   *                      DAI103B
/*EXI *  TEXT('Midas GP Report ML Instrument Exp by GL Category')     *                      DAI103B
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      ***GPRPTMXI**-*Report*ML*Counterparty*Exposure*(by*GL*Category) *                      DAI103B
      *  GPRPTMXI  - Report ML Instrument Exposure (by GL Category)   *                      DAI103B
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. MD059057           Date 14Oct21               *
      *  Prev Amend No. DAI103B            Date 26Oct19               *
      *                 DAI103             Date 25Jun19               *
      *                 FRAIMP             Date 16Apr13               *
      *                 NADC02             Date 12Jun12               *
      *                 NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059057 - Missing changes in SP2021B compat - (DAI103B)     *
      *             (Recompile only)                                  *
      *  DAI103B - ML Reporting to include Nostros & Forward FX       *
      *  DAI103 - Upgraded MPlus 121 NADC01, NADC02 and FRAIMP ML     *
      *           Extracts to FB 2.1                                  *
      *  FRAIMP - ML Reporting to include FRA                         *
      *  NADC02 - ML REPORTING TO INCLUDE IRS                         *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************

     FGPMLEXL1  IP   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FGZSDBANKPDIF   E             DISK
     FGPCTRYL0  IF   E           K DISK
     F*PRPTMXIP1O****F  246        PRINTER                                                    NADC02
     F**RPTMXIP1O    F  261        PRINTER                                             NADC02 FRAIMP
     F**GPRPTMXIP1O    F  276        PRINTER                                          FRAIMP DAI103B
     FGPRPTMXIP1O    F  306        PRINTER                                                   DAI103B
     F                                     INFDS(SPOOLU)

      ** File Information Data Structure for GPRPTMXIP1
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

     D cEXP            S             17  2 DIM(20)
     D coEXP           S             15  0 DIM(20)

     D pEXP            S             17  2 DIM(20)
     D poEXP           S             15  0 DIM(20)

     D tEXP            S             17  2 DIM(20)
     D toEXP           S             15  0 DIM(20)


     D  MEINSTGLCAT    DS
     D  MEINST                 1     10
     D  MEGLCAT               11     15


     IGPMLEXD0
     I                                          MECNCD        L3
     I                                          MECUSTNAME    L2
     I                                          MEINST        L1

      * Change of country

     C   L3              Z-ADD     99            LINENO
     C   L3              Z-ADD     0             cEXP
     C   L3              MOVEL     *BLANK        A4CNNM
     C   L3MECNCD        CHAIN     GPCTRYD0                           99
     C   L3              EVAL      MECNCDNAM = MECNCD + ' ' + A4CNNM

      * Change of customer

     C   L2              Z-ADD     3             CHLINE
     C   L2              EXSR      PAG
     C   L2              EXCEPT    CUSHEAD
     C   L2              Z-ADD     0             pEXP

      * Accumulate exposure

     C                   EXSR      ACCUM_EXPOS

      * Output instrument

     C                   IF        MESMOD <> 'MT' AND MESMOD <> 'ACCT'
     C                   EVAL      %Subst(MESNAM: 26: 7) = MEREDAT
     C                   ENDIF
     C                   MOVEL     MESNAM        RSNAM            32
     C                   Z-ADD(H)  MEEXPINUSD    EXP              15 0
     C                   IF        MESMOD = 'FXDL'
     C                   Z-ADD     0             TOTEXP
     C                   ELSE
     C                   Z-ADD(H)  MEEXPINUSD    TOTEXP           15 0
     C                   ENDIF
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    INSTRUM

      * Report customer totals
     CL2                 EXSR      REPORT_CUSTOT

      * Report country totals
     CL3                 EXSR      REPORT_CTYTOT

      * Final totals
     CLR                 EXSR      REPORT_FINTOT
      *****************************************************************
     C     ACCUM_EXPOS   BEGSR

      * INSTRUMENT
     C                   Z-ADD     1             #I
     C     MEINSTGLCAT   LOOKUP    INSTRGLC(#I)                           99

      * Exposure in USD

     C                   ADD       MEEXPINUSD    pEXP(#I)

     C                   ADD       MEEXPINUSD    cEXP(#I)

     C                   ADD       MEEXPINUSD    tEXP(#I)

     C     #I            COMP      1                                      21
     C     #I            COMP      2                                      22
     C     #I            COMP      3                                      23
     C     #I            COMP      4                                      24
     C     #I            COMP      5                                      25
     C     #I            COMP      6                                      26
     C     #I            COMP      7                                      27
     C     #I            COMP      8                                      28
     C     #I            COMP      9                                      29
     C     #I            COMP      10                                     30
     C     #I            COMP      11                                     31
     C     #I            COMP      12                                     32
     C     #I            COMP      13                                     33
     C     #I            COMP      14                                     34                  NADC02
     C*****#I            COMP      15                                     34          FRAIMP DAI103B
     C     #I            COMP      15                                     35                 DAI103B
     C     #I            COMP      16                                     36                 DAI103B
     C     #I            COMP      17                                     37                 DAI103B

     C                   ENDSR
      *****************************************************************
     C     REPORT_CUSTOT BEGSR

     C     pEXP(1)       COMP      0                                  2121

     C     pEXP(2)       COMP      0                                  2222

     C     pEXP(3)       COMP      0                                  2323

     C     pEXP(4)       COMP      0                                  2424

     C     pEXP(5)       COMP      0                                  2525

     C     pEXP(6)       COMP      0                                  2626

     C     pEXP(7)       COMP      0                                  2727

     C     pEXP(8)       COMP      0                                  2828

     C     pEXP(9)       COMP      0                                  2929

     C     pEXP(10)      COMP      0                                  3030

     C     pEXP(11)      COMP      0                                  3131

     C     pEXP(12)      COMP      0                                  3232

     C     pEXP(13)      COMP      0                                  3333
                                                                                              NADC02
     C     pEXP(14)      COMP      0                                  3434                    NADC02
                                                                                              FRAIMP
     C     pEXP(15)      COMP      0                                  3535                    FRAIMP
                                                                                             DAI103B
     C     pEXP(16)      COMP      0                                  3636                   DAI103B
                                                                                             DAI103B
     C     pEXP(17)      COMP      0                                  3737                   DAI103B

     C                   Z-ADD(H)  pEXP          poEXP
     C                   XFOOT     poEXP         TOTEXP
     C*******************SUB       poEXP(13)     TOTEXP                         * FX          NADC02
     C*********          SUB       poEXP(14)     TOTEXP                         * FX   NADC02 FRAIMP
     C*********          SUB       poEXP(15)     TOTEXP                         * FX  FRAIMP DAI103B
     C                   SUB       poEXP(17)     TOTEXP                         * FX         DAI103B

     C                   Z-ADD     2             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    CUSTOTAL

     C                   ENDSR
      *****************************************************************
     C     REPORT_CTYTOT BEGSR

     C                   Z-ADD(H)  cEXP          coEXP
     C                   XFOOT     coEXP         TOTEXP
     C*******************SUB       coEXP(13)     TOTEXP                         * FX          NADC02
     C*********          SUB       coEXP(14)     TOTEXP                         * FX   NADC02 FRAIMP
     C*********          SUB       coEXP(15)     TOTEXP                         * FX  FRAIMP DAI103B
     C                   SUB       coEXP(17)     TOTEXP                         * FX         DAI103B

     C                   Z-ADD     3             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    CTYTOTAL

     C                   ENDSR
      *****************************************************************
     C     REPORT_FINTOT BEGSR

     C                   Z-ADD(H)  tEXP          toEXP
     C                   XFOOT     toEXP         TOTEXP
     C*******************SUB       toEXP(13)     TOTEXP                         * FX          NADC02
     C*********          SUB       toEXP(14)     TOTEXP                         * FX   NADC02 FRAIMP
     C*********          SUB       toEXP(15)     TOTEXP                         * FX  FRAIMP DAI103B
     C                   SUB       toEXP(17)     TOTEXP                         * FX         DAI103B

     C                   Z-ADD     3             CHLINE            2 0
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
     C                             AND NLINSTCODE <> 'GLOBFW'                                DAI103B
     C                             AND NLINSTCODE <> 'GLOBNO'                                DAI103B
     C                             AND NLINSTCODE <> 'GLOBFX'
     C                   ADD       1             #I
     C                   EVAL      INSTR(#I)   = NLINSTCODE
     C                   ENDIF
     C                   READ      T_GRINSTLF                             99
     C                   ENDDO
     C                   SORTA     INSTR
     C                   ADD       1             #I                                          DAI103B
     C                   EVAL      INSTR(#I)   = 'GLOBFW'                                    DAI103B
     C                   ADD       1             #I                                          DAI103B
     C                   EVAL      INSTR(#I)   = 'GLOBNO'                                    DAI103B
     C                   ADD       1             #I
     C                   EVAL      INSTR(#I)   = 'GLOBFX'
      * INSTRUMENT/GL CAT
     C                   EVAL      INSTRGLC = 'ZZZZZZ'                                       DAI103B
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
      *FW                                                                                    DAI103B
     C                   WHEN      INSTR(#I) = 'GLOBFW'                                      DAI103B
     C                   MOVE      '2 OFF'       INSTRGLC(#J)                                DAI103B
      *NO                                                                                    DAI103B
     C                   WHEN      INSTR(#I) = 'GLOBNO'                                      DAI103B
     C                   MOVE      '1 ON '       INSTRGLC(#J)                                DAI103B
      *FX
     C                   WHEN      INSTR(#I) = 'GLOBFX'
     C*********          MOVE      '2 OFF'       INSTRGLC(#J)                                DAI103B
     C                   MOVE      '1 ON '       INSTRGLC(#J)                                DAI103B
     C                   ENDSL

     C                   ADD       1             #I
     C                   IF        #I > 10                                                   DAI103B
     C                   LEAVE                                                               DAI103B
     C                   ENDIF                                                               DAI103B
     C                   ENDDO

     C                   MOVEL     INSTRGLC      INST
     C                   MOVE      INSTRGLC      GLCAT

     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0
     C                   MOVE      *BLANK        MECNCDNAM        33

     C                   ENDSR
      *****************************************************************
     OGPRPTMXIP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMXI '
     O                                           80 'INSTRUMENT EXPOSURE +
     O                                              BY GL CATEGORY REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           12 'COUNTERPARTY'
     O                                           22 '/REFERENCE'
     O                                           34 'LIM'
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
     O*********                                 247 'T O T A L  '                      NADC02 FRAIMP
     O*********              INST(14)           261                                    NADC02 FRAIMP
     O                       INST(14)           248                                           FRAIMP
     O*********                                 262 'T O T A L  '                     FRAIMP DAI103B
     O*********              INST(15)           276                                   FRAIMP DAI103B
     O                       INST(15)           263                                          DAI103B
     O                       INST(16)           278                                          DAI103B
     O                                          291 'T O T A L  '                            DAI103B
     O                       INST(17)           306                                          DAI103B
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
     O                                          277 '|'                                      DAI103B
     O                                          292 '|'                                      DAI103B
     O*********                                 276 '|'                               FRAIMP DAI103B
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O          E            PAGEHEAD    1
     O                                           34 'DEF'
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
     O*********              GLCAT(15)          271                                   FRAIMP DAI103B
     O                       GLCAT(15)          258                                          DAI103B
     O                       GLCAT(16)          273                                          DAI103B
     O                       GLCAT(17)          301                                          DAI103B
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
     O                                          277 '|'                                      DAI103B
     O                                          292 '|'                                      DAI103B
     O*********                                 276 '|'                               FRAIMP DAI103B
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
     O                                          291 '==============='                        DAI103B
     O                                          306 '==============='                        DAI103B
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
     O                                          291 '==============='                        DAI103B
     O                                          306 '==============='                        DAI103B
     O          E            CUSHEAD     1
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
     O                                          291 '---------------'                        DAI103B
     O                                          306 '---------------'                        DAI103B
     O          E            CUSHEAD     1
     O                       MECUSTNAME          28
     O                       MELIMDEFC           33
     O                                           38 '|'                                      DAI103B
     O                                           52 '|'                                      DAI103B
     O                                           67 '|'                                      DAI103B
     O                                           82 '|'                                      DAI103B
     O                                          127 '|'                                      DAI103B
     O                                          157 '|'                                      DAI103B
     O                                          217 '|'                                      DAI103B
     O                                          247 '|'                                      DAI103B
     O                                          262 '|'                                      DAI103B
     O                                          277 '|'                                      DAI103B
     O                                          292 '|'                                      DAI103B
     O***********************                   232 '|'                                       NADC02
     O*********                                 247 '|'                                NADC02 FRAIMP
     O*********                                 262 '|'                               FRAIMP DAI103B
     O          E            CUSHEAD     1
     O                                            6 '======'
     O                                           38 '|'                                      DAI103B
     O                                           52 '|'                                      DAI103B
     O                                           67 '|'                                      DAI103B
     O                                           82 '|'                                      DAI103B
     O                                          127 '|'                                      DAI103B
     O                                          157 '|'                                      DAI103B
     O                                          217 '|'                                      DAI103B
     O                                          247 '|'                                      DAI103B
     O                                          262 '|'                                      DAI103B
     O                                          277 '|'                                      DAI103B
     O                                          292 '|'                                      DAI103B
     O***********************                   232 '|'                                       NADC02
     O*********                                 247 '|'                                NADC02 FRAIMP
     O*********                                 262 '|'                               FRAIMP DAI103B
     O          E            INSTRUM     1
     O                       MESMOD               4
     O                    N21MESNAM              55
     O*********************33EXP                246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTEXP             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            34EXP                261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTEXP             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            35EXP                276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTEXP             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                     37EXP                306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTEXP             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     36EXP                276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     35EXP                261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     34EXP                246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                     33EXP                231 '   ,   ,   ,   ,  0-'                    NADC02
     O                     32EXP                216 '   ,   ,   ,   ,  0-'
     O                     31EXP                201 '   ,   ,   ,   ,  0-'
     O                     30EXP                186 '   ,   ,   ,   ,  0-'
     O                     29EXP                171 '   ,   ,   ,   ,  0-'
     O                     28EXP                156 '   ,   ,   ,   ,  0-'
     O                     27EXP                141 '   ,   ,   ,   ,  0-'
     O                     26EXP                126 '   ,   ,   ,   ,  0-'
     O                     25EXP                111 '   ,   ,   ,   ,  0-'
     O                     24EXP                 96 '   ,   ,   ,   ,  0-'
     O                     23EXP                 81 '   ,   ,   ,   ,  0-'
     O                     22EXP                 66 '   ,   ,   ,   ,  0-'
     O                     21EXP                 51 '   ,   ,   ,   ,  0-'
     O                     21RSNAM               37
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
     O                                          277 '|'                                      DAI103B
     O                                          292 '|'                                      DAI103B
     O*********                                 276 '|'                               FRAIMP DAI103B
     O****************************************** 97 '|'                                       NADC02
     O******************************************127 '|'                                       NADC02
     O******************************************187 '|'                                       NADC02
     O******************************************217 '|'                                       NADC02
     O******************************************232 '|'                                       NADC02
     O          E            CUSTOTAL    1
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
     O                                          291 '---------------'                        DAI103B
     O                                          306 '---------------'                        DAI103B
     O          E            CUSTOTAL    1
     O                       MECUSTNAME          28
     O*********************33poEXP(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTEXP             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            34poEXP(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTEXP             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            35poEXP(15)          276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTEXP             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                     37poEXP(17)          306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTEXP             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     36poEXP(16)          276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     35poEXP(15)          261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     34poEXP(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                     33poEXP(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                     32poEXP(12)          216 '   ,   ,   ,   ,  0-'
     O                     31poEXP(11)          201 '   ,   ,   ,   ,  0-'
     O                     30poEXP(10)          186 '   ,   ,   ,   ,  0-'
     O                     29poEXP(9)           171 '   ,   ,   ,   ,  0-'
     O                     28poEXP(8)           156 '   ,   ,   ,   ,  0-'
     O                     27poEXP(7)           141 '   ,   ,   ,   ,  0-'
     O                     26poEXP(6)           126 '   ,   ,   ,   ,  0-'
     O                     25poEXP(5)           111 '   ,   ,   ,   ,  0-'
     O                     24poEXP(4)            96 '   ,   ,   ,   ,  0-'
     O                     23poEXP(3)            81 '   ,   ,   ,   ,  0-'
     O                     22poEXP(2)            66 '   ,   ,   ,   ,  0-'
     O                     21poEXP(1)            51 '   ,   ,   ,   ,  0-'
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
     O                                          277 '|'                                      DAI103B
     O                                          292 '|'                                      DAI103B
     O*********                                 276 '|'                               FRAIMP DAI103B
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O          E            CTYTOTAL    1
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
     O                                          291 '==============='                        DAI103B
     O                                          306 '==============='                        DAI103B
     O          E            CTYTOTAL    1
     O                       MECNCDNAM           33
     O***********************coEXP(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTEXP             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              coEXP(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTEXP             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              coEXP(15)          276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTEXP             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       coEXP(17)          306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTEXP             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       coEXP(16)          276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(15)          261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       coEXP(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       coEXP(12)          216 '   ,   ,   ,   ,  0-'
     O                       coEXP(11)          201 '   ,   ,   ,   ,  0-'
     O                       coEXP(10)          186 '   ,   ,   ,   ,  0-'
     O                       coEXP(9)           171 '   ,   ,   ,   ,  0-'
     O                       coEXP(8)           156 '   ,   ,   ,   ,  0-'
     O                       coEXP(7)           141 '   ,   ,   ,   ,  0-'
     O                       coEXP(6)           126 '   ,   ,   ,   ,  0-'
     O                       coEXP(5)           111 '   ,   ,   ,   ,  0-'
     O                       coEXP(4)            96 '   ,   ,   ,   ,  0-'
     O                       coEXP(3)            81 '   ,   ,   ,   ,  0-'
     O                       coEXP(2)            66 '   ,   ,   ,   ,  0-'
     O                       coEXP(1)            51 '   ,   ,   ,   ,  0-'
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
     O                                          277 '|'                                      DAI103B
     O                                          292 '|'                                      DAI103B
     O*********                                 276 '|'                               FRAIMP DAI103B
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
     O          E            CTYTOTAL    1
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
     O                                          291 '==============='                        DAI103B
     O                                          306 '==============='                        DAI103B
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
     O                                          291 '---------------'                        DAI103B
     O                                          306 '---------------'                        DAI103B
     O          E            FINTOTAL    1
     O                                           22 'G R A N D   T O T A L '
     O***********************toEXP(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTEXP             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              toEXP(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTEXP             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              toEXP(15)          276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTEXP             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       toEXP(17)          306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTEXP             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       toEXP(16)          276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(15)          261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       toEXP(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       toEXP(12)          216 '   ,   ,   ,   ,  0-'
     O                       toEXP(11)          201 '   ,   ,   ,   ,  0-'
     O                       toEXP(10)          186 '   ,   ,   ,   ,  0-'
     O                       toEXP(9)           171 '   ,   ,   ,   ,  0-'
     O                       toEXP(8)           156 '   ,   ,   ,   ,  0-'
     O                       toEXP(7)           141 '   ,   ,   ,   ,  0-'
     O                       toEXP(6)           126 '   ,   ,   ,   ,  0-'
     O                       toEXP(5)           111 '   ,   ,   ,   ,  0-'
     O                       toEXP(4)            96 '   ,   ,   ,   ,  0-'
     O                       toEXP(3)            81 '   ,   ,   ,   ,  0-'
     O                       toEXP(2)            66 '   ,   ,   ,   ,  0-'
     O                       toEXP(1)            51 '   ,   ,   ,   ,  0-'
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
     O                                          277 '|'                                      DAI103B
     O                                          292 '|'                                      DAI103B
     O*********                                 276 '|'                               FRAIMP DAI103B
     O***********************                    97 '|'                                       NADC02
     O***********************                   127 '|'                                       NADC02
     O***********************                   187 '|'                                       NADC02
     O***********************                   217 '|'                                       NADC02
     O***********************                   232 '|'                                       NADC02
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
     O                                          291 '---------------'                        DAI103B
     O                                          306 '---------------'                        DAI103B
