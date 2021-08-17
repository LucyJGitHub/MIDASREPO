     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Report ML Country Exposure by GL Category')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMXC  - Report ML Country Exposure (by GL Category)      *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103B            Date 26Oct19               *
      *  Prev Amend No. DAI103             Date 25Jun19               *
      *                 FRAIMP             Date 16Apr13               *
      *                 NADC02             Date 12Jun12               *
      *                 NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103B - ML Reporting to include Nostros & Forward FX       *
      *  DAI103 - Upgraded MPlus 121 NADC01, NADC02 and FRAIMP ML     *
      *           Extracts to FB 2.1                                  *
      *  FRAIMP - ML Reporting to include FRA                         *
      *  NADC02 - ML REPORTING TO INCLUDE IRS                         *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
 
     FGPMLXCL0  IP   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FGZSDBANKPDIF   E             DISK
     F*PRPTMXCP1O****F  246        PRINTER                                                    NADC02
     F**RPTMXCP1O    F  261        PRINTER                                             NADC02 FRAIMP
     F**GPRPTMXCP1O    F  276        PRINTER                                          FRAIMP DAI103B
     FGPRPTMXCP1O    F  306        PRINTER                                                   DAI103B
     F                                     INFDS(SPOOLU)
 
      ** File Information Data Structure for GPRPTMXCP1
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
 
     D TPIX            S             15  0 DIM(20)
     D TPEX            S             15  0 DIM(20)
     D CEXP            S             15  0 DIM(20)
     D TDI1            S             15  0 DIM(20)
     D TDI2            S             15  0 DIM(20)
 
     D tTPIX           S             15  0 DIM(20)
     D tTPEX           S             15  0 DIM(20)
     D tCEXP           S             15  0 DIM(20)
     D tTDI1           S             15  0 DIM(20)
     D tTDI2           S             15  0 DIM(20)
 
 
     D  MEINSTGLCAT    DS
     D  MEINST                 1     10
     D  MEGLCAT               11     15
 
 
     IGPMLXCD0
     I                                          MECNCD        L2
     I                                          MELIMDEF      L1
 
      * Change of country
 
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
 
     C   L1              Z-ADD     0             TPIX
     C   L1              Z-ADD     0             TPEX
     C   L1              Z-ADD     0             CEXP
     C   L1              Z-ADD     0             TDI1
     C   L1              Z-ADD     0             TDI2
 
      * Accumulate exposure
 
     C                   EXSR      ACCUM_EXPOS
 
      * Report exposure
     CL1                 EXSR      REPORT_EXPOS
 
      * Final totals
     CLR                 EXSR      REPORT_FINTOT
      *****************************************************************
     C     ACCUM_EXPOS   BEGSR
 
      * INSTRUMENT
     C                   Z-ADD     1             #I
     C     MEINSTGLCAT   LOOKUP    INSTRGLC(#I)                           99
 
      * Total Cpty Inst Exp in USD  (Counterparty GL Exposure)
      * Total Cpty Exposure in USD  (Counterparty ML Exposure)
      * Country Exposure in USD     (Country Exposure)
      * Total Diff in USD           (Country Exposure - Counterparty GL Exposure)
      * Total Diff in USD           (Country Exposure - Counterparty ML Exposure)
 
     C                   ADD       METPIXUSD     TPIX(#I)
     C                   ADD       METPEXUSD     TPEX(#I)
     C                   ADD       MECEXPUSD     CEXP(#I)
     C                   ADD       METDI1USD     TDI1(#I)
     C                   ADD       METDI2USD     TDI2(#I)
 
     C                   ADD       METPIXUSD     tTPIX(#I)
     C                   ADD       METPEXUSD     tTPEX(#I)
     C                   ADD       MECEXPUSD     tCEXP(#I)
     C                   ADD       METDI1USD     tTDI1(#I)
     C                   ADD       METDI2USD     tTDI2(#I)
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_EXPOS  BEGSR
 
     C     TPIX(1)       COMP      0                                  2121
     C  N21TPEX(1)       COMP      0                                  2121
     C  N21CEXP(1)       COMP      0                                  2121
 
     C     TPIX(2)       COMP      0                                  2222
     C  N22TPEX(2)       COMP      0                                  2222
     C  N22CEXP(2)       COMP      0                                  2222
 
     C     TPIX(3)       COMP      0                                  2323
     C  N23TPEX(3)       COMP      0                                  2323
     C  N23CEXP(3)       COMP      0                                  2323
 
     C     TPIX(4)       COMP      0                                  2424
     C  N24TPEX(4)       COMP      0                                  2424
     C  N24CEXP(4)       COMP      0                                  2424
 
     C     TPIX(5)       COMP      0                                  2525
     C  N25TPEX(5)       COMP      0                                  2525
     C  N25CEXP(5)       COMP      0                                  2525
 
     C     TPIX(6)       COMP      0                                  2626
     C  N26TPEX(6)       COMP      0                                  2626
     C  N26CEXP(6)       COMP      0                                  2626
 
     C     TPIX(7)       COMP      0                                  2727
     C  N27TPEX(7)       COMP      0                                  2727
     C  N27CEXP(7)       COMP      0                                  2727
 
     C     TPIX(8)       COMP      0                                  2828
     C  N28TPEX(8)       COMP      0                                  2828
     C  N28CEXP(8)       COMP      0                                  2828
 
     C     TPIX(9)       COMP      0                                  2929
     C  N29TPEX(9)       COMP      0                                  2929
     C  N29CEXP(9)       COMP      0                                  2929
 
     C     TPIX(10)      COMP      0                                  3030
     C  N30TPEX(10)      COMP      0                                  3030
     C  N30CEXP(10)      COMP      0                                  3030
 
     C     TPIX(11)      COMP      0                                  3131
     C  N31TPEX(11)      COMP      0                                  3131
     C  N31CEXP(11)      COMP      0                                  3131
 
     C     TPIX(12)      COMP      0                                  3232
     C  N32TPEX(12)      COMP      0                                  3232
     C  N32CEXP(12)      COMP      0                                  3232
 
     C     TPIX(13)      COMP      0                                  3333
     C  N33TPEX(13)      COMP      0                                  3333
     C  N33CEXP(13)      COMP      0                                  3333
                                                                                              NADC02
     C     TPIX(14)      COMP      0                                  3434                    NADC02
     C  N34TPEX(14)      COMP      0                                  3434                    NADC02
     C  N34CEXP(14)      COMP      0                                  3434                    NADC02
                                                                                              FRAIMP
     C*****TPIX(15)      COMP      0                                  3535            FRAIMP DAI103B
     C**N34TPEX(15)      COMP      0                                  3535            FRAIMP DAI103B
     C**N34CEXP(15)      COMP      0                                  3535            FRAIMP DAI103B
                                                                                             DAI103B
     C     TPIX(15)      COMP      0                                  3535                   DAI103B
     C  N35TPEX(15)      COMP      0                                  3535                   DAI103B
     C  N35CEXP(15)      COMP      0                                  3535                   DAI103B
                                                                                             DAI103B
     C     TPIX(16)      COMP      0                                  3636                   DAI103B
     C  N36TPEX(16)      COMP      0                                  3636                   DAI103B
     C  N36CEXP(16)      COMP      0                                  3636                   DAI103B
                                                                                             DAI103B
     C     TPIX(17)      COMP      0                                  3737                   DAI103B
     C  N37TPEX(17)      COMP      0                                  3737                   DAI103B
     C  N37CEXP(17)      COMP      0                                  3737                   DAI103B
 
     C                   XFOOT     TPIX          TOTPIX           15 0
     C*******************SUB       TPIX(13)      TOTPIX                         * FX          NADC02
     C*********          SUB       TPIX(14)      TOTPIX                         * FX   NADC02 FRAIMP
     C*********          SUB       TPIX(15)      TOTPIX                         * FX  FRAIMP DAI103B
     C                   SUB       TPIX(17)      TOTPIX                         * FX         DAI103B
     C                   XFOOT     TPEX          TOTPEX           15 0
     C*******************SUB       TPEX(13)      TOTPEX                         * FX          NADC02
     C*********          SUB       TPEX(14)      TOTPEX                         * FX   NADC02 FRAIMP
     C*********          SUB       TPEX(15)      TOTPEX                         * FX  FRAIMP DAI103B
     C                   SUB       TPEX(17)      TOTPEX                         * FX         DAI103B
     C                   XFOOT     CEXP          TOTCEX           15 0
     C*******************SUB       CEXP(13)      TOTCEX                         * FX          NADC02
     C*********          SUB       CEXP(14)      TOTCEX                         * FX   NADC02 FRAIMP
     C*********          SUB       CEXP(15)      TOTPIX                         * FX  FRAIMP DAI103B
     C                   SUB       CEXP(17)      TOTCEX                         * FX         DAI103B
     C                   XFOOT     TDI1          TOTDI1           15 0
     C*******************SUB       TDI1(13)      TOTDI1                         * FX          NADC02
     C*********          SUB       TDI1(14)      TOTDI1                         * FX   NADC02 FRAIMP
     C*********          SUB       TDI1(15)      TOTPIX                         * FX  FRAIMP DAI103B
     C                   SUB       TDI1(17)      TOTDI1                         * FX         DAI103B
     C                   XFOOT     TDI2          TOTDI2           15 0
     C*******************SUB       TDI2(13)      TOTDI2                         * FX          NADC02
     C*********          SUB       TDI2(14)      TOTDI2                         * FX   NADC02 FRAIMP
     C*********          SUB       TDI2(15)      TOTPIX                         * FX  FRAIMP DAI103B
     C                   SUB       TDI2(17)      TOTDI2                         * FX         DAI103B
 
     C                   Z-ADD     5             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_FINTOT BEGSR
 
     C                   XFOOT     tTPIX         TOTPIX
     C*******************SUB       tTPIX(13)     TOTPIX                         * FX          NADC02
     C*********          SUB       tTPIX(14)     TOTPIX                         * FX   NADC02 FRAIMP
     C*********          SUB       tTPIX(15)     TOTPIX                         * FX  FRAIMP DAI103B
     C                   SUB       tTPIX(17)     TOTPIX                         * FX         DAI103B
     C                   XFOOT     tTPEX         TOTPEX
     C*******************SUB       tTPEX(13)     TOTPEX                         * FX          NADC02
     C*********          SUB       tTPEX(14)     TOTPEX                         * FX   NADC02 FRAIMP
     C*********          SUB       tTPEX(15)     TOTPIX                         * FX  FRAIMP DAI103B
     C                   SUB       tTPEX(17)     TOTPEX                         * FX         DAI103B
     C                   XFOOT     tCEXP         TOTCEX
     C*******************SUB       tCEXP(13)     TOTCEX                         * FX          NADC02
     C*********          SUB       tCEXP(14)     TOTCEX                         * FX   NADC02 FRAIMP
     C*********          SUB       tCEXP(15)     TOTPIX                         * FX  FRAIMP DAI103B
     C                   SUB       tCEXP(17)     TOTCEX                         * FX         DAI103B
     C                   XFOOT     tTDI1         TOTDI1
     C*******************SUB       tTDI1(13)     TOTDI1                         * FX          NADC02
     C*********          SUB       tTDI1(14)     TOTDI1                         * FX   NADC02 FRAIMP
     C*********          SUB       tTDI1(15)     TOTPIX                         * FX  FRAIMP DAI103B
     C                   SUB       tTDI1(17)     TOTDI1                         * FX         DAI103B
     C                   XFOOT     tTDI2         TOTDI2
     C*******************SUB       tTDI2(13)     TOTDI2                         * FX          NADC02
     C*********          SUB       tTDI2(14)     TOTDI2                         * FX   NADC02 FRAIMP
     C*********          SUB       tTDI2(15)     TOTPIX                         * FX  FRAIMP DAI103B
     C                   SUB       tTDI2(17)     TOTDI2                         * FX         DAI103B
 
     C                   Z-ADD     7             CHLINE            2 0
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
     C     4             ADD       CHLINE        LINENO
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
 
     C                   ENDSR
      *****************************************************************
     OGPRPTMXCP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMXC '
     O                                           75 'COUNTRY EXPOSURE +
     O                                              BY GL CATEGORY REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                            7 'COUNTRY'
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
     O                                          291 '---------------'                        DAI103B
     O                                          306 '---------------'                        DAI103B
     O          E            TOTAL       1
     O               40      MECNCDNAM           33
     O                                           33 '        '
     O                       MELIMDEF            27
     O***********************TPIX(13)           246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTPIX             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TPIX(14)           261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTPIX             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TPIX(15)           276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTPIX             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       TPIX(17)           306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTPIX             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       TPIX(16)           276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(15)           261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(14)           246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TPIX(13)           231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       TPIX(12)           216 '   ,   ,   ,   ,  0-'
     O                       TPIX(11)           201 '   ,   ,   ,   ,  0-'
     O                       TPIX(10)           186 '   ,   ,   ,   ,  0-'
     O                       TPIX(9)            171 '   ,   ,   ,   ,  0-'
     O                       TPIX(8)            156 '   ,   ,   ,   ,  0-'
     O                       TPIX(7)            141 '   ,   ,   ,   ,  0-'
     O                       TPIX(6)            126 '   ,   ,   ,   ,  0-'
     O                       TPIX(5)            111 '   ,   ,   ,   ,  0-'
     O                       TPIX(4)             96 '   ,   ,   ,   ,  0-'
     O                       TPIX(3)             81 '   ,   ,   ,   ,  0-'
     O                       TPIX(2)             66 '   ,   ,   ,   ,  0-'
     O                       TPIX(1)             51 '   ,   ,   ,   ,  0-'
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
     O                                          247 '|'                                       FRAIMP
     O                                          262 '|'                                       FRAIMP
     O                                          277 '|'                                      DAI103B
     O                                          292 '|'                                      DAI103B
     O*********                                 276 '|'                               FRAIMP DAI103B
     O****************************************** 97 '|'                                       NADC02
     O******************************************127 '|'                                       NADC02
     O******************************************187 '|'                                       NADC02
     O******************************************217 '|'                                       NADC02
     O******************************************232 '|'                                       NADC02
     O                                           38 '| GL     |'
     O          E            TOTAL       1
     O               40                           2 '=='
     O***********************TPEX(13)           246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTPEX             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TPEX(14)           261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTPEX             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TPEX(15)           276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTPEX             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       TPEX(17)           306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTPEX             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       TPEX(16)           276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(15)           261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(14)           246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       TPEX(13)           231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       TPEX(12)           216 '   ,   ,   ,   ,  0-'
     O                       TPEX(11)           201 '   ,   ,   ,   ,  0-'
     O                       TPEX(10)           186 '   ,   ,   ,   ,  0-'
     O                       TPEX(9)            171 '   ,   ,   ,   ,  0-'
     O                       TPEX(8)            156 '   ,   ,   ,   ,  0-'
     O                       TPEX(7)            141 '   ,   ,   ,   ,  0-'
     O                       TPEX(6)            126 '   ,   ,   ,   ,  0-'
     O                       TPEX(5)            111 '   ,   ,   ,   ,  0-'
     O                       TPEX(4)             96 '   ,   ,   ,   ,  0-'
     O                       TPEX(3)             81 '   ,   ,   ,   ,  0-'
     O                       TPEX(2)             66 '   ,   ,   ,   ,  0-'
     O                       TPEX(1)             51 '   ,   ,   ,   ,  0-'
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
     O                                           38 '| ML     |'
     O          E            TOTAL       1
     O***********************CEXP(13)           246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTCEX             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              CEXP(14)           261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTCEX             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              CEXP(15)           276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTCEX             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       CEXP(17)           306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTCEX             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       CEXP(16)           276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(15)           261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(14)           246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       CEXP(13)           231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       CEXP(12)           216 '   ,   ,   ,   ,  0-'
     O                       CEXP(11)           201 '   ,   ,   ,   ,  0-'
     O                       CEXP(10)           186 '   ,   ,   ,   ,  0-'
     O                       CEXP(9)            171 '   ,   ,   ,   ,  0-'
     O                       CEXP(8)            156 '   ,   ,   ,   ,  0-'
     O                       CEXP(7)            141 '   ,   ,   ,   ,  0-'
     O                       CEXP(6)            126 '   ,   ,   ,   ,  0-'
     O                       CEXP(5)            111 '   ,   ,   ,   ,  0-'
     O                       CEXP(4)             96 '   ,   ,   ,   ,  0-'
     O                       CEXP(3)             81 '   ,   ,   ,   ,  0-'
     O                       CEXP(2)             66 '   ,   ,   ,   ,  0-'
     O                       CEXP(1)             51 '   ,   ,   ,   ,  0-'
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
     O                                           38 '| CTY    |'
     O          E            TOTAL       1
     O*********************33TDI2(13)           246 '   ,   ,   ,   ,  0-'                    NADC02
     O*********************  TOTDI2             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            34TDI2(14)           261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTDI2             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            35TDI2(15)           276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTDI2             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                     37TDI2(17)           306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTDI2             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     36TDI2(16)           276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     35TDI2(15)           261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     34TDI2(14)           246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                     33TDI2(13)           231 '   ,   ,   ,   ,  0-'                    NADC02
     O                     32TDI2(12)           216 '   ,   ,   ,   ,  0-'
     O                     31TDI2(11)           201 '   ,   ,   ,   ,  0-'
     O                     30TDI2(10)           186 '   ,   ,   ,   ,  0-'
     O                     29TDI2(9)            171 '   ,   ,   ,   ,  0-'
     O                     28TDI2(8)            156 '   ,   ,   ,   ,  0-'
     O                     27TDI2(7)            141 '   ,   ,   ,   ,  0-'
     O                     26TDI2(6)            126 '   ,   ,   ,   ,  0-'
     O                     25TDI2(5)            111 '   ,   ,   ,   ,  0-'
     O                     24TDI2(4)             96 '   ,   ,   ,   ,  0-'
     O                     23TDI2(3)             81 '   ,   ,   ,   ,  0-'
     O                     22TDI2(2)             66 '   ,   ,   ,   ,  0-'
     O                     21TDI2(1)             51 '   ,   ,   ,   ,  0-'
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
     O                                           38 '| CTY-GL |'
     O          E            TOTAL       1
     O*********************33TDI1(13)           246 '   ,   ,   ,   ,  0-'                    NADC02
     O*********************  TOTDI1             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            34TDI1(14)           261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTDI1             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            35TDI1(15)           276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTDI1             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                     37TDI1(17)           306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTDI1             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     36TDI1(16)           276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     35TDI1(15)           261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     34TDI1(14)           246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                     33TDI1(13)           231 '   ,   ,   ,   ,  0-'                    NADC02
     O                     32TDI1(12)           216 '   ,   ,   ,   ,  0-'
     O                     31TDI1(11)           201 '   ,   ,   ,   ,  0-'
     O                     30TDI1(10)           186 '   ,   ,   ,   ,  0-'
     O                     29TDI1(9)            171 '   ,   ,   ,   ,  0-'
     O                     28TDI1(8)            156 '   ,   ,   ,   ,  0-'
     O                     27TDI1(7)            141 '   ,   ,   ,   ,  0-'
     O                     26TDI1(6)            126 '   ,   ,   ,   ,  0-'
     O                     25TDI1(5)            111 '   ,   ,   ,   ,  0-'
     O                     24TDI1(4)             96 '   ,   ,   ,   ,  0-'
     O                     23TDI1(3)             81 '   ,   ,   ,   ,  0-'
     O                     22TDI1(2)             66 '   ,   ,   ,   ,  0-'
     O                     21TDI1(1)             51 '   ,   ,   ,   ,  0-'
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
     O                                           38 '| CTY-ML |'
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
     O***********************tTPIX(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTPIX             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              tTPIX(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTPIX             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              tTPIX(15)          276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTPIX             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       tTPIX(17)          306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTPIX             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       tTPIX(16)          276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(15)          261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       tTPIX(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       tTPIX(12)          216 '   ,   ,   ,   ,  0-'
     O                       tTPIX(11)          201 '   ,   ,   ,   ,  0-'
     O                       tTPIX(10)          186 '   ,   ,   ,   ,  0-'
     O                       tTPIX(9)           171 '   ,   ,   ,   ,  0-'
     O                       tTPIX(8)           156 '   ,   ,   ,   ,  0-'
     O                       tTPIX(7)           141 '   ,   ,   ,   ,  0-'
     O                       tTPIX(6)           126 '   ,   ,   ,   ,  0-'
     O                       tTPIX(5)           111 '   ,   ,   ,   ,  0-'
     O                       tTPIX(4)            96 '   ,   ,   ,   ,  0-'
     O                       tTPIX(3)            81 '   ,   ,   ,   ,  0-'
     O                       tTPIX(2)            66 '   ,   ,   ,   ,  0-'
     O                       tTPIX(1)            51 '   ,   ,   ,   ,  0-'
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
     O                                           38 '| GL     |'
     O          E            FINTOTAL    1
     O***********************tTPEX(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTPEX             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              tTPEX(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTPEX             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              tTPEX(15)          276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTPEX             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       tTPEX(17)          306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTPEX             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       tTPEX(16)          276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(15)          261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       tTPEX(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       tTPEX(12)          216 '   ,   ,   ,   ,  0-'
     O                       tTPEX(11)          201 '   ,   ,   ,   ,  0-'
     O                       tTPEX(10)          186 '   ,   ,   ,   ,  0-'
     O                       tTPEX(9)           171 '   ,   ,   ,   ,  0-'
     O                       tTPEX(8)           156 '   ,   ,   ,   ,  0-'
     O                       tTPEX(7)           141 '   ,   ,   ,   ,  0-'
     O                       tTPEX(6)           126 '   ,   ,   ,   ,  0-'
     O                       tTPEX(5)           111 '   ,   ,   ,   ,  0-'
     O                       tTPEX(4)            96 '   ,   ,   ,   ,  0-'
     O                       tTPEX(3)            81 '   ,   ,   ,   ,  0-'
     O                       tTPEX(2)            66 '   ,   ,   ,   ,  0-'
     O                       tTPEX(1)            51 '   ,   ,   ,   ,  0-'
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
     O                                           38 '| ML     |'
     O          E            FINTOTAL    1
     O***********************tCEXP(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTCEX             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              tCEXP(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTCEX             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              tCEXP(15)          276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTCEX             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       tCEXP(17)          306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTCEX             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       tCEXP(16)          276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(15)          261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       tCEXP(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       tCEXP(12)          216 '   ,   ,   ,   ,  0-'
     O                       tCEXP(11)          201 '   ,   ,   ,   ,  0-'
     O                       tCEXP(10)          186 '   ,   ,   ,   ,  0-'
     O                       tCEXP(9)           171 '   ,   ,   ,   ,  0-'
     O                       tCEXP(8)           156 '   ,   ,   ,   ,  0-'
     O                       tCEXP(7)           141 '   ,   ,   ,   ,  0-'
     O                       tCEXP(6)           126 '   ,   ,   ,   ,  0-'
     O                       tCEXP(5)           111 '   ,   ,   ,   ,  0-'
     O                       tCEXP(4)            96 '   ,   ,   ,   ,  0-'
     O                       tCEXP(3)            81 '   ,   ,   ,   ,  0-'
     O                       tCEXP(2)            66 '   ,   ,   ,   ,  0-'
     O                       tCEXP(1)            51 '   ,   ,   ,   ,  0-'
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
     O                                           38 '| CTY    |'
     O          E            FINTOTAL    1
     O***********************tTDI2(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTDI2             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              tTDI2(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTDI2             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              tTDI2(15)          276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTDI2             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       tTDI2(17)          306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTDI2             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       tTDI2(16)          276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(15)          261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       tTDI2(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       tTDI2(12)          216 '   ,   ,   ,   ,  0-'
     O                       tTDI2(11)          201 '   ,   ,   ,   ,  0-'
     O                       tTDI2(10)          186 '   ,   ,   ,   ,  0-'
     O                       tTDI2(9)           171 '   ,   ,   ,   ,  0-'
     O                       tTDI2(8)           156 '   ,   ,   ,   ,  0-'
     O                       tTDI2(7)           141 '   ,   ,   ,   ,  0-'
     O                       tTDI2(6)           126 '   ,   ,   ,   ,  0-'
     O                       tTDI2(5)           111 '   ,   ,   ,   ,  0-'
     O                       tTDI2(4)            96 '   ,   ,   ,   ,  0-'
     O                       tTDI2(3)            81 '   ,   ,   ,   ,  0-'
     O                       tTDI2(2)            66 '   ,   ,   ,   ,  0-'
     O                       tTDI2(1)            51 '   ,   ,   ,   ,  0-'
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
     O                                           38 '| CTY-GL |'
     O          E            FINTOTAL    1
     O***********************tTDI1(13)          246 '   ,   ,   ,   ,  0-'                    NADC02
     O***********************TOTDI1             231 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              tTDI1(14)          261 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTDI1             246 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              tTDI1(15)          276 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TOTDI1             261 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O                       tTDI1(17)          306 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TOTDI1             291 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       tTDI1(16)          276 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(15)          261 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(14)          246 '   ,   ,   ,   ,  0-'                    FRAIMP
     O                       tTDI1(13)          231 '   ,   ,   ,   ,  0-'                    NADC02
     O                       tTDI1(12)          216 '   ,   ,   ,   ,  0-'
     O                       tTDI1(11)          201 '   ,   ,   ,   ,  0-'
     O                       tTDI1(10)          186 '   ,   ,   ,   ,  0-'
     O                       tTDI1(9)           171 '   ,   ,   ,   ,  0-'
     O                       tTDI1(8)           156 '   ,   ,   ,   ,  0-'
     O                       tTDI1(7)           141 '   ,   ,   ,   ,  0-'
     O                       tTDI1(6)           126 '   ,   ,   ,   ,  0-'
     O                       tTDI1(5)           111 '   ,   ,   ,   ,  0-'
     O                       tTDI1(4)            96 '   ,   ,   ,   ,  0-'
     O                       tTDI1(3)            81 '   ,   ,   ,   ,  0-'
     O                       tTDI1(2)            66 '   ,   ,   ,   ,  0-'
     O                       tTDI1(1)            51 '   ,   ,   ,   ,  0-'
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
     O                                           38 '| CTY-ML |'
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
