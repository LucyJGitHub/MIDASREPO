     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Report ML Counterparty Exposure')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMLP  - Report ML Counterparty Exposure                  *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. MD059057           Date 14Oct21               *
      *  Prev Amend No. DAI103B            Date 26Oct19               *
      *                 DAI103             Date 25Jun19               *
      *                 FRAIMP             Date 17Apr13               *
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

     FGPMLXPL0  IP   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FGZSDBANKPDIF   E             DISK
     F*PRPTMLPP1O****F  132        PRINTER                                                    NADC02
     F**GPRPTMLPP1O    F  145        PRINTER                                           NADC02 FRAIMP
     F**GPRPTMLPP1O    F  158        PRINTER                                          FRAIMP DAI103B
     FGPRPTMLPP1O    F  202        PRINTER                                                   DAI103B
     F                                     INFDS(SPOOLU)

      ** File Information Data Structure for GPRPTMLPP1
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1

     D INSTR           S             10    DIM(10)

     D TIEX            S             15  0 DIM(10)
     D PEXP            S             15  0 DIM(10)
     D TDIF            S             15  0 DIM(10)

     D cTIEX           S             15  0 DIM(10)
     D cPEXP           S             15  0 DIM(10)
     D cTDIF           S             15  0 DIM(10)

     D tTIEX           S             15  0 DIM(10)
     D tPEXP           S             15  0 DIM(10)
     D tTDIF           S             15  0 DIM(10)

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
     C     MEINST        LOOKUP    INSTR(#I)                              99
     C                   MOVEL     INSTR(#I)     Instrument       10

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
                                                                                              NADC02
     C     TIEX(7)       COMP      0                                  2727                    NADC02
     C  N27PEXP(7)       COMP      0                                  2727                    NADC02
     C  N27TDIF(7)       COMP      0                                  2727                    NADC02
                                                                                              FRAIMP
     C     TIEX(8)       COMP      0                                  2828                    FRAIMP
     C  N28PEXP(8)       COMP      0                                  2828                    FRAIMP
     C  N28TDIF(8)       COMP      0                                  2828                    FRAIMP
                                                                                             DAI103B
     C     TIEX(9)       COMP      0                                  2929                   DAI103B
     C  N29PEXP(9)       COMP      0                                  2929                   DAI103B
     C  N29TDIF(9)       COMP      0                                  2929                   DAI103B
                                                                                             DAI103B
     C     TIEX(10)      COMP      0                                  3030                   DAI103B
     C  N30PEXP(10)      COMP      0                                  3030                   DAI103B
     C  N30TDIF(10)      COMP      0                                  3030                   DAI103B

     C                   XFOOT     TIEX          TOTIEX           15 0
     C                   XFOOT     PEXP          TOPEXP           15 0
     C                   XFOOT     TDIF          TOTDIF           15 0

     C                   Z-ADD     3             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL

     C                   ENDSR
      *****************************************************************
     C     REPORT_CTYTOT BEGSR

     C                   XFOOT     cTIEX         TOTIEX
     C                   XFOOT     cPEXP         TOPEXP
     C                   XFOOT     cTDIF         TOTDIF

     C                   Z-ADD     5             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    CTYTOTAL

     C                   ENDSR
      *****************************************************************
     C     REPORT_FINTOT BEGSR

     C                   XFOOT     tTIEX         TOTIEX
     C                   XFOOT     tPEXP         TOPEXP
     C                   XFOOT     tTDIF         TOTDIF

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
     C     6             ADD       CHLINE        LINENO
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
     C                             AND NLINSTCODE <> 'GLOBFX'                                DAI103B
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
     C                   ADD       1             #I                                          DAI103B
     C                   EVAL      INSTR(#I)   = 'GLOBFX'                                    DAI103B

     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0

     C                   ENDSR
      *****************************************************************
     OGPRPTMLPP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMLP '
     O                                           80 'COUNTERPARTY EXPOSURE +
     O                                              REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           12 'COUNTERPARTY'
     O                                           29 'LIMIT'
     O                       INSTR(1)            53                                          DAI103B
     O                       INSTR(2)            68                                          DAI103B
     O                       INSTR(3)            83                                          DAI103B
     O                       INSTR(4)            98                                          DAI103B
     O                       INSTR(5)           113                                          DAI103B
     O                       INSTR(6)           128                                          DAI103B
     O                       INSTR(7)           143                                          DAI103B
     O                       INSTR(8)           158                                          DAI103B
     O                       INSTR(9)           173                                          DAI103B
     O                       INSTR(10)          188                                          DAI103B
     O                                          201 'T O T A L'                              DAI103B
     O*********              INSTR(1)            54                                          DAI103B
     O*********              INSTR(2)            67                                          DAI103B
     O*********              INSTR(3)            80                                          DAI103B
     O*********              INSTR(4)            93                                          DAI103B
     O*********              INSTR(5)           106                                          DAI103B
     O*********              INSTR(6)           119                                          DAI103B
     O***********************                   132 'T O T A L  '                             NADC02
     O*********              INSTR(7)           132                                   NADC02 DAI103B
     O*********                                 145 'T O T A L  '                      NADC02 FRAIMP
     O*********              INSTR(8)           145                                   FRAIMP DAI103B
     O*********                                 158 'T O T A L  '                     FRAIMP DAI103B
     O          E            PAGEHEAD    1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O                                          145 '==============='                         NADC02
     O                                          158 '==============='                         FRAIMP
     O                                          184 '=========================='             DAI103B
     O                                          202 '=================='                     DAI103B
     O          E            PAGEHEAD    1
     O                       MECNCDNAM           33
     O          E            PAGEHEAD    1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O                                          145 '==============='                         NADC02
     O                                          158 '==============='                         FRAIMP
     O                                          184 '=========================='             DAI103B
     O                                          202 '=================='                     DAI103B
     O          E            STRC        1
     O               40                          26 '--------------------------'
     O               40                          52 '--------------------------'
     O              N40                          52 '|-----------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          145 '---------------'                         NADC02
     O                                          158 '---------------'                         FRAIMP
     O                                          184 '--------------------------'             DAI103B
     O                                          202 '------------------'                     DAI103B
     O          E            TOTAL       1
     O               40      MECUSTNAME          28
     O                                           28 '   '
     O                       MELIMDEF            27
     O                       TOTIEX             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       TIEX(10)           187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TIEX(9)            172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TIEX(8)            157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TIEX(7)            142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TIEX(6)            127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TIEX(5)            112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TIEX(4)             97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TIEX(3)             82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TIEX(2)             67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TIEX(1)             52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTIEX             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************TIEX(6)            117 '   ,   ,   ,   ,  0-'                    NADC02
     O*********              TOTIEX             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              TIEX(7)            130 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTIEX             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              TIEX(8)            143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TIEX(7)            129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              TIEX(6)            116 '   ,   ,   ,   ,  0'             NADC02 DAI103B
     O*********              TIEX(5)            103 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TIEX(4)             90 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TIEX(3)             77 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TIEX(2)             64 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TIEX(1)             51 '   ,   ,   ,   ,  0'                    DAI103B
     O                                           38 '| GL     |'
     O          E            TOTAL       1
     O                       TOPEXP             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       PEXP(10)           187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       PEXP(9)            172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       PEXP(8)            157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       PEXP(7)            142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       PEXP(6)            127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       PEXP(5)            112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       PEXP(4)             97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       PEXP(3)             82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       PEXP(2)             67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       PEXP(1)             52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOPEXP             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************PEXP(6)            117 '   ,   ,   ,   ,  0-'                    NADC02
     O*********              TOPEXP             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              PEXP(7)            130 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOPEXP             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              PEXP(8)            143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              PEXP(7)            129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              PEXP(6)            116 '   ,   ,   ,   ,  0'             NADC02 DAI103B
     O*********              PEXP(5)            103 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              PEXP(4)             90 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              PEXP(3)             77 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              PEXP(2)             64 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              PEXP(1)             51 '   ,   ,   ,   ,  0'                    DAI103B
     O                                           38 '| ML     |'
     O          E            TOTAL       1
     O                       TOTDIF             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                     30TDIF(10)           187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     29TDIF(9)            172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     28TDIF(8)            157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     27TDIF(7)            142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     26TDIF(6)            127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     25TDIF(5)            112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     24TDIF(4)             97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     23TDIF(3)             82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     22TDIF(2)             67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     21TDIF(1)             52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTDIF             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O*********************26TDIF(6)            117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTDIF             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********            27TDIF(7)            130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTDIF             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********            28TDIF(8)            143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            27TDIF(7)            129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********            26TDIF(6)            116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********            25TDIF(5)            103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            24TDIF(4)             90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            23TDIF(3)             77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            22TDIF(2)             64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            21TDIF(1)             51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| ML- GL |'
     O          E            CTYTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          145 '---------------'                         NADC02
     O                                          158 '---------------'                         FRAIMP
     O                                          184 '--------------------------'             DAI103B
     O                                          202 '------------------'                     DAI103B
     O          E            CTYTOTAL    1
     O                       MECNCDNAM           33
     O                       TOTIEX             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       cTIEX(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTIEX(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTIEX(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTIEX(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTIEX(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTIEX(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTIEX(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTIEX(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTIEX(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTIEX(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTIEX             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************cTIEX(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTIEX             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              cTIEX(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTIEX             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              cTIEX(8)           143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********              cTIEX(7)           129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********              cTIEX(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              cTIEX(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cTIEX(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cTIEX(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cTIEX(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cTIEX(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| GL     |'
     O          E            CTYTOTAL    1
     O                                           26 'C O U N T R Y   T O T A L '
     O                       TOPEXP             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       cPEXP(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cPEXP(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cPEXP(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cPEXP(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cPEXP(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cPEXP(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cPEXP(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cPEXP(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cPEXP(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cPEXP(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOPEXP             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************cPEXP(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOPEXP             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              cPEXP(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOPEXP             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              cPEXP(8)           143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********              cPEXP(7)           129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********              cPEXP(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              cPEXP(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cPEXP(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cPEXP(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cPEXP(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cPEXP(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| ML     |'
     O          E            CTYTOTAL    1
     O                       TOTDIF             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       cTDIF(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTDIF(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTDIF(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTDIF(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTDIF(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTDIF(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTDIF(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTDIF(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTDIF(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       cTDIF(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTDIF             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************cTDIF(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTDIF             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              cTDIF(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTDIF             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              cTDIF(8)           143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********              cTDIF(7)           129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********              cTDIF(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              cTDIF(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cTDIF(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cTDIF(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cTDIF(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              cTDIF(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| ML- GL |'
     O          E            CTYTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          145 '---------------'                         NADC02
     O                                          158 '---------------'                         FRAIMP
     O                                          184 '--------------------------'             DAI103B
     O                                          202 '------------------'                     DAI103B
     O          E            FINTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          145 '---------------'                         NADC02
     O*********                                 145 '---------------'                 FRAIMP DAI103B
     O                                          158 '---------------'                        DAI103B
     O                                          184 '--------------------------'             DAI103B
     O                                          202 '------------------'                     DAI103B
     O          E            FINTOTAL    1
     O                                           22 'G R A N D   T O T A L '
     O                       TOTIEX             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       tTIEX(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTIEX(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTIEX(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTIEX(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTIEX(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTIEX(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTIEX(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTIEX(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTIEX(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTIEX(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTIEX             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************tTIEX(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTIEX             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              tTIEX(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTIEX             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              tTIEX(8)           143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********              tTIEX(7)           129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********              tTIEX(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              tTIEX(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTIEX(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTIEX(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTIEX(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTIEX(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| GL     |'
     O          E            FINTOTAL    1
     O                       TOPEXP             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       tPEXP(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tPEXP(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tPEXP(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tPEXP(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tPEXP(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tPEXP(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tPEXP(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tPEXP(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tPEXP(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tPEXP(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOPEXP             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************tPEXP(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOPEXP             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              tPEXP(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOPEXP             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              tPEXP(8)           143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********              tPEXP(7)           129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********              tPEXP(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              tPEXP(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tPEXP(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tPEXP(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tPEXP(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tPEXP(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| ML     |'
     O          E            FINTOTAL    1
     O                       TOTDIF             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       tTDIF(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDIF(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDIF(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDIF(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDIF(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDIF(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDIF(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDIF(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDIF(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDIF(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTDIF             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************tTDIF(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTDIF             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              tTDIF(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTDIF             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              tTDIF(8)           143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********              tTDIF(7)           129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********              tTDIF(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              tTDIF(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDIF(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDIF(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDIF(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDIF(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| ML- GL |'
     O          E            FINTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          145 '---------------'                         NADC02
     O                                          158 '---------------'                         FRAIMP
     O                                          184 '--------------------------'             DAI103B
     O                                          202 '------------------'                     DAI103B
