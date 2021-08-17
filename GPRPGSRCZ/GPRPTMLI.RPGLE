     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/********TEXT('Midas GP Report ML Counterparty Exposure')             *                      DAI103B
/*EXI *  TEXT('Midas GP Report ML Instrument Exposure')               *                      DAI103B
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      ***GPRPTMLI**-*Report*ML*Counterparty*Exposure                  *                      DAI103B
      *  GPRPTMLI  - Report ML Instrument Exposure                    *                      DAI103B
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103B            Date 26Oct19               *
      *  Prev Amend No. DAI103             Date 25Jun19               *
      *                 FRAIMP             Date 17Apr13               *
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
 
     FGPMLEXL1  IP   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FGZSDBANKPDIF   E             DISK
     FGPCTRYL0  IF   E           K DISK
     F*PRPTMLIP1O****F  132        PRINTER                                                    NADC02
     F**GPRPTMLIP1O    F  145        PRINTER                                           NADC02 FRAIMP
     F**GPRPTMLIP1O    F  158        PRINTER                                          FRAIMP DAI103B
     FGPRPTMLIP1O    F  202        PRINTER                                                   DAI103B
     F                                     INFDS(SPOOLU)
 
      ** File Information Data Structure for GPRPTMLIP1
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
     D INSTR           S             10    DIM(10)
 
     D cEXP            S             17  2 DIM(10)
     D coEXP           S             15  0 DIM(10)
 
     D pEXP            S             17  2 DIM(10)
     D poEXP           S             15  0 DIM(10)
 
     D tEXP            S             17  2 DIM(10)
     D toEXP           S             15  0 DIM(10)
 
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
 
     C                   Z-ADD(H)  MEEXPINUSD    EXP              15 0
     C                   Z-ADD(H)  MEEXPINUSD    TOTEXP           15 0
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    INST
 
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
     C     MEINST        LOOKUP    INSTR(#I)                              99
     C                   MOVEL     INSTR(#I)     Instrument       10
 
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
     C     #I            COMP      7                                      27                  NADC02
     C     #I            COMP      8                                      28                  FRAIMP
     C     #I            COMP      9                                      29                 DAI103B
     C     #I            COMP      10                                     30                 DAI103B
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_CUSTOT BEGSR
 
     C     pEXP(1)       COMP      0                                  2121
 
     C     pEXP(2)       COMP      0                                  2222
 
     C     pEXP(3)       COMP      0                                  2323
 
     C     pEXP(4)       COMP      0                                  2424
 
     C     pEXP(5)       COMP      0                                  2525
 
     C     pEXP(6)       COMP      0                                  2626
                                                                                              NADC02
     C     pEXP(7)       COMP      0                                  2727                    NADC02
                                                                                              FRAIMP
     C     pEXP(8)       COMP      0                                  2828                    FRAIMP
                                                                                             DAI103B
     C     pEXP(9)       COMP      0                                  2929                   DAI103B
                                                                                             DAI103B
     C     pEXP(10)      COMP      0                                  3030                   DAI103B
 
     C                   Z-ADD(H)  pEXP          poEXP
     C                   XFOOT     poEXP         TOTEXP
 
     C                   Z-ADD     2             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    CUSTOTAL
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_CTYTOT BEGSR
 
     C                   Z-ADD(H)  cEXP          coEXP
     C                   XFOOT     coEXP         TOTEXP
 
     C                   Z-ADD     3             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    CTYTOTAL
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_FINTOT BEGSR
 
     C                   Z-ADD(H)  tEXP          toEXP
     C                   XFOOT     toEXP         TOTEXP
 
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
     C                   MOVE      *BLANK        MECNCDNAM        33
 
     C                   ENDSR
      *****************************************************************
     OGPRPTMLIP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMLI '
     O                                           80 'INSTRUMENT EXPOSURE +
     O                                              REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           12 'COUNTERPARTY'
     O                                           22 '/REFERENCE'
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
     C*********                                 145 'T O T A L  '                      NADC02 FRAIMP
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
     O          E            CUSHEAD     1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          145 '---------------'                         NADC02
     O                                          158 '---------------'                         FRAIMP
     O                                          184 '--------------------------'             DAI103B
     O                                          202 '------------------'                     DAI103B
     O          E            CUSHEAD     1
     O                       MECUSTNAME          28
     O***********************                   118 '|'                                       NADC02
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********                                 144 '|'                               FRAIMP DAI103B
     O                                           37 '|'                                      DAI103B
     O                                          188 '|'                                      DAI103B
     O          E            CUSHEAD     1
     O                                            6 '======'
     O***********************                   118 '|'                                       NADC02
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********                                 144 '|'                               FRAIMP DAI103B
     O                                           37 '|'                                      DAI103B
     O                                          188 '|'                                      DAI103B
     O          E            INST        1
     O                       MESNAM              50
     O                       TOTEXP             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                     30EXP                187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     29EXP                172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     28EXP                157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     27EXP                142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     26EXP                127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     25EXP                112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     24EXP                 97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     23EXP                 82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     22EXP                 67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     21EXP                 52 '   ,   ,   ,   ,  0-'                   DAI103B
     O                                           37 '|'                                      DAI103B
     O                       MESMOD              36                                          DAI103B
     O***********************TOTEXP             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O*********************26EXP                117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********            27EXP                130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********            28EXP                143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            27EXP                129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********            26EXP                116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********            25EXP                103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            24EXP                 90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            23EXP                 77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            22EXP                 64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            21EXP                 51 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              MESMOD              39                                          DAI103B
     O          E            CUSTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          145 '---------------'                         NADC02
     O                                          158 '---------------'                         FRAIMP
     O                                          184 '--------------------------'             DAI103B
     O                                          202 '------------------'                     DAI103B
     O          E            CUSTOTAL    1
     O                       MECUSTNAME          28
     O                       TOTEXP             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                     30poEXP(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     29poEXP(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     28poEXP(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     27poEXP(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     26poEXP(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     25poEXP(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     24poEXP(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     23poEXP(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     22poEXP(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     21poEXP(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTEXP             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O*********************26poEXP(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********            27poEXP(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********            28poEXP(8)           143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            27poEXP(7)           129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********            26poEXP(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********            25poEXP(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            24poEXP(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            23poEXP(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            22poEXP(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            21poEXP(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O          E            CTYTOTAL    1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O                                          145 '==============='                         NADC02
     O*********                                 145 '==============='                 FRAIMP DAI103B
     O                                          158 '==============='                        DAI103B
     O                                          184 '=========================='             DAI103B
     O                                          202 '=================='                     DAI103B
     O          E            CTYTOTAL    1
     O                       MECNCDNAM           33
     O                       TOTEXP             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       coEXP(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       coEXP(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTEXP             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************coEXP(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              coEXP(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              coEXP(8)           143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********              coEXP(7)           129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********              coEXP(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              coEXP(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              coEXP(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              coEXP(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              coEXP(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              coEXP(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O          E            CTYTOTAL    1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O                                          145 '==============='                         NADC02
     O                                          158 '==============='                         FRAIMP
     O                                          184 '=========================='             DAI103B
     O                                          202 '=================='                     DAI103B
     O          E            FINTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          145 '---------------'                        DAI103B
     O                                          158 '---------------'                        DAI103B
     O                                          184 '--------------------------'             DAI103B
     O                                          202 '------------------'                     DAI103B
     O          E            FINTOTAL    1
     O                                           22 'G R A N D   T O T A L '
     O                       TOTEXP             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       toEXP(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       toEXP(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTEXP             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************toEXP(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              toEXP(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              toEXP(8)           143 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********              toEXP(7)           129 '   ,   ,   ,   , 0 '             FRAIMP DAI103B
     O*********              toEXP(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              toEXP(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              toEXP(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              toEXP(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              toEXP(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              toEXP(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
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
