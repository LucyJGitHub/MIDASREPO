     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/********TEXT('Midas GP Make a Directory')                            *                      DAI103B
/*EXI *  TEXT('Report ML Country Exposure')                           *                      DAI103B
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMLC  - Report ML Country Exposure                       *
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
     F*PRPTMLCP1O****F  132        PRINTER                                                    NADC02
     F**GPRPTMLCP1O    F  145        PRINTER                                           NADC02 FRAIMP
     F**GPRPTMLCP1O    F  158        PRINTER                                          FRAIMP DAI103B
     FGPRPTMLCP1O    F  202        PRINTER                                                   DAI103B
     F                                     INFDS(SPOOLU)

      ** File Information Data Structure for GPRPTMLCP1
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1

     D INSTR           S             10    DIM(10)

     D TPIX            S             15  0 DIM(10)
     D TPEX            S             15  0 DIM(10)
     D CEXP            S             15  0 DIM(10)
     D TDI1            S             15  0 DIM(10)
     D TDI2            S             15  0 DIM(10)

     D tTPIX           S             15  0 DIM(10)
     D tTPEX           S             15  0 DIM(10)
     D tCEXP           S             15  0 DIM(10)
     D tTDI1           S             15  0 DIM(10)
     D tTDI2           S             15  0 DIM(10)

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
     C     MEINST        LOOKUP    INSTR(#I)                              99
     C                   MOVEL     INSTR(#I)     Instrument       10

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
                                                                                              NADC02
     C     TPIX(7)       COMP      0                                  2727                    NADC02
     C  N27TPEX(7)       COMP      0                                  2727                    NADC02
     C  N27CEXP(7)       COMP      0                                  2727                    NADC02
                                                                                              FRAIMP
     C     TPIX(8)       COMP      0                                  2828                    FRAIMP
     C  N28TPEX(8)       COMP      0                                  2828                    FRAIMP
     C  N28CEXP(8)       COMP      0                                  2828                    FRAIMP
                                                                                             DAI103B
     C     TPIX(9)       COMP      0                                  2929                   DAI103B
     C  N29TPEX(9)       COMP      0                                  2929                   DAI103B
     C  N29CEXP(9)       COMP      0                                  2929                   DAI103B
                                                                                             DAI103B
     C     TPIX(10)      COMP      0                                  3030                   DAI103B
     C  N30TPEX(10)      COMP      0                                  3030                   DAI103B
     C  N30CEXP(10)      COMP      0                                  3030                   DAI103B

     C                   XFOOT     TPIX          TOTPIX           15 0
     C                   XFOOT     TPEX          TOTPEX           15 0
     C                   XFOOT     CEXP          TOTCEX           15 0
     C                   XFOOT     TDI1          TOTDI1           15 0
     C                   XFOOT     TDI2          TOTDI2           15 0

     C                   Z-ADD     5             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL

     C                   ENDSR
      *****************************************************************
     C     REPORT_FINTOT BEGSR

     C                   XFOOT     tTPIX         TOTPIX
     C                   XFOOT     tTPEX         TOTPEX
     C                   XFOOT     tCEXP         TOTCEX
     C                   XFOOT     tTDI1         TOTDI1
     C                   XFOOT     tTDI2         TOTDI2

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
     C     3             ADD       CHLINE        LINENO
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
     OGPRPTMLCP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMLC '
     O                                           75 'COUNTRY EXPOSURE +
     O                                              REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                            7 'COUNTRY'
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
     O               40      MECNCDNAM           33
     O                                           33 '        '
     O                       MELIMDEF            27
     O                       TOTPIX             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       TPIX(10)           187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(9)            172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(8)            157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(7)            142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(6)            127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(5)            112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(4)             97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(3)             82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(2)             67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPIX(1)             52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTPIX             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************TPIX(6)            117 '   ,   ,   ,   ,  0-'                    NADC02
     O*********              TOTPIX             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              TPIX(7)            130 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTPIX             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              TPIX(8)            143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TPIX(7)            129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              TPIX(6)            116 '   ,   ,   ,   ,  0'             NADC02 DAI103B
     O*********              TPIX(5)            103 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TPIX(4)             90 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TPIX(3)             77 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TPIX(2)             64 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TPIX(1)             51 '   ,   ,   ,   ,  0'                    DAI103B
     O                                           38 '| GL     |'
     O          E            TOTAL       1
     O               40                           2 '=='
     O                       TOTPEX             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       TPEX(10)           187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(9)            172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(8)            157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(7)            142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(6)            127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(5)            112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(4)             97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(3)             82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(2)             67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       TPEX(1)             52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTPEX             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************TPEX(6)            117 '   ,   ,   ,   ,  0-'                    NADC02
     O*********              TOTPEX             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              TPEX(7)            130 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTPEX             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              TPEX(8)            143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TPEX(7)            129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              TPEX(6)            116 '   ,   ,   ,   ,  0'             NADC02 DAI103B
     O*********              TPEX(5)            103 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TPEX(4)             90 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TPEX(3)             77 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TPEX(2)             64 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              TPEX(1)             51 '   ,   ,   ,   ,  0'                    DAI103B
     O                                           38 '| ML     |'
     O          E            TOTAL       1
     O                       TOTCEX             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       CEXP(10)           187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(9)            172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(8)            157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(7)            142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(6)            127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(5)            112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(4)             97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(3)             82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(2)             67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       CEXP(1)             52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTCEX             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************CEXP(6)            117 '   ,   ,   ,   ,  0-'                    NADC02
     O*********              TOTCEX             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              CEXP(7)            130 '   ,   ,   ,   ,  0-'             NADC02 FRAIMP
     O*********              TOTCEX             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              CEXP(8)            143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              TPEX(7)            129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              CEXP(6)            116 '   ,   ,   ,   ,  0'             NADC02 DAI103B
     O*********              CEXP(5)            103 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              CEXP(4)             90 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              CEXP(3)             77 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              CEXP(2)             64 '   ,   ,   ,   ,  0'                    DAI103B
     O*********              CEXP(1)             51 '   ,   ,   ,   ,  0'                    DAI103B
     O                                           38 '| CTY    |'
     O          E            TOTAL       1
     O                       TOTDI2             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                     30TDI2(10)           187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     29TDI2(9)            172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     28TDI2(8)            157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     27TDI2(7)            142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     26TDI2(6)            127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     25TDI2(5)            112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     24TDI2(4)             97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     23TDI2(3)             82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     22TDI2(2)             67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     21TDI2(1)             52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTDI2             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O*********************26TDI2(6)            117 '   ,   ,   ,   ,  0-'                    NADC02
     O*********              TOTDI2             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********            27TDI2(7)            130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTDI2             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********            28TDI2(8)            143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********            27TDI2(7)            129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********            26TDI2(6)            116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********            25TDI2(5)            103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            24TDI2(4)             90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            23TDI2(3)             77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            22TDI2(2)             64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            21TDI2(1)             51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| CTY-GL |'
     O          E            TOTAL       1
     O                       TOTDI1             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                     30TDI1(10)           187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     29TDI1(9)            172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     28TDI1(8)            157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     27TDI1(7)            142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     26TDI1(6)            127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     25TDI1(5)            112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     24TDI1(4)             97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     23TDI1(3)             82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     22TDI1(2)             67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                     21TDI1(1)             52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTDI1             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O*********************26TDI1(6)            117 '   ,   ,   ,   ,  0-'                    NADC02
     O*********              TOTDI1             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********            27TDI1(7)            130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTDI1             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********            28TDI1(8)            143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********            27TDI1(7)            129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********            26TDI1(6)            116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********            25TDI1(5)            103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            24TDI1(4)             90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            23TDI1(3)             77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            22TDI1(2)             64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********            21TDI1(1)             51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| CTY-ML |'
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
     O          E            FINTOTAL    1
     O                                           22 'G R A N D   T O T A L '
     O                       TOTPIX             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       tTPIX(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPIX(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTPIX             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************tTPIX(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTPIX             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              tTPIX(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTPIX             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              tTPIX(8)           143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              tTPIX(7)           129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              tTPIX(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              tTPIX(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTPIX(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTPIX(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTPIX(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTPIX(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| GL     |'
     O          E            FINTOTAL    1
     O                       TOTPEX             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       tTPEX(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTPEX(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTPEX             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************tTPEX(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTPEX             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              tTPEX(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTPEX             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              tTPEX(8)           143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              tTPEX(7)           129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              tTPEX(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              tTPEX(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTPEX(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTPEX(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTPEX(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTPEX(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| ML     |'
     O          E            FINTOTAL    1
     O                       TOTCEX             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       tCEXP(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tCEXP(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTCEX             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************tCEXP(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTCEX             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              tCEXP(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTCEX             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              tCEXP(8)           143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              tCEXP(7)           129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              tCEXP(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              tCEXP(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tCEXP(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tCEXP(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tCEXP(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tCEXP(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| CTY    |'
     O          E            FINTOTAL    1
     O                       TOTDI2             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       tTDI2(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI2(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTDI2             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************tTDI2(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTDI2             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              tTDI2(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTDI2             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              tTDI2(8)           143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              tTDI2(7)           129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              tTDI2(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              tTDI2(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDI2(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDI2(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDI2(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDI2(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| CTY-GL |'
     O          E            FINTOTAL    1
     O                       TOTDI1             202 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                          188 '|'                                      DAI103B
     O                       tTDI1(10)          187 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(9)           172 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(8)           157 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(7)           142 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(6)           127 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(5)           112 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(4)            97 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(3)            82 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(2)            67 '   ,   ,   ,   ,  0-'                   DAI103B
     O                       tTDI1(1)            52 '   ,   ,   ,   ,  0-'                   DAI103B
     O***********************TOTDI1             132 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************                   118 '|'                                       NADC02
     O***********************tTDI1(6)           117 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTDI1             145 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********                                 131 '|'                                NADC02 FRAIMP
     O*********              tTDI1(7)           130 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTDI1             158 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********                                 144 '|'                               FRAIMP DAI103B
     O*********              tTDI1(8)           143 '   ,   ,   ,   ,  0-'            FRAIMP DAI103B
     O*********              tTDI1(7)           129 '   ,   ,   ,   ,  0'             FRAIMP DAI103B
     O*********              tTDI1(6)           116 '   ,   ,   ,   , 0 '             NADC02 DAI103B
     O*********              tTDI1(5)           103 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDI1(4)            90 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDI1(3)            77 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDI1(2)            64 '   ,   ,   ,   , 0 '                    DAI103B
     O*********              tTDI1(1)            51 '   ,   ,   ,   , 0 '                    DAI103B
     O                                           38 '| CTY-ML |'
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
