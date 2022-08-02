     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Report ML Counterparty Exp. by Sector')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMZS  - Report ML Counterparty Exposure by Sector        *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. MD059057           Date 14Oct21               *
      *  Prev Amend No. DAI103B            Date 26Oct19               *
      *                 DAI103             Date 25Jun19               *
      *                 FRAIMP             Date 05May13               *
      *                 NADC02             Date 12Jun12               *
      *                 NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059057 - Missing changes in SP2021B compat - (DAI103B)     *
      *             (Recompile only)                                  *
      *  DAI103B - ML Reporting to include Nostros & Forward FX       *
      *  DAI103 - Upgraded MPlus 121 NADC01 and NADC02 to ML Extracts *
      *           to FB 2.1                                           *
      *  FRAIMP - ML Reporting to include FRA                         *
      *  NADC02 - ML REPORTING TO INCLUDE IRS                         *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************

     FGPMLEXL2  IP   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FGZSDBANKPDIF   E             DISK
     F*PRPTMZSP1O****F  348        PRINTER                                                    NADC02
     F**RPTMZSP1O    F  378        PRINTER                                             NADC02 FRAIMP
     F**GPRPTMZSP1O    F  408        PRINTER                                          FRAIMP DAI103B
     FGPRPTMZSP1O    F  378        PRINTER                                                   DAI103B
     F                                     INFDS(SPOOLU)

      ** File Information Data Structure for GPRPTMZSP1
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1

     D INSTR           S             10    DIM(10)
     D INST            S             10    DIM(25)                                           DAI103B
     D GLCAT           S              5    DIM(25)                                           DAI103B
     D INSTRGLC        S             15    DIM(25)                                           DAI103B
     D EXP             S             17  2 DIM(25)                                           DAI103B
     D oEXP            S             15  0 DIM(25)                                           DAI103B
     D iEXP            S             17  2 DIM(25)                                           DAI103B
     D ioEXP           S             15  0 DIM(25)                                           DAI103B
     D cEXP            S             17  2 DIM(25)                                           DAI103B
     D coEXP           S             15  0 DIM(25)                                           DAI103B
     D tEXP            S             17  2 DIM(25)                                           DAI103B
     D toEXP           S             15  0 DIM(25)                                           DAI103B
                                                                                             DAI103B
     D SECT            S             34    DIM(50)                                           DAI103B
     D SECT_TOT        S            459    DIM(50)  ASCEND                                   DAI103B
                                                                                             DAI103B
     D                 DS                                                                    DAI103B
     D STOT                    1    459                                                      DAI103B
     D SECTOT                 35    459  2 DIM(25)                                           DAI103B
                                                                                             DAI103B
     D*INST****        S             10    DIM(23)                                    FRAIMP DAI103B
     D*GLCAT***        S              5    DIM(23)                                    FRAIMP DAI103B
     D*INSTRGLC        S             15    DIM(23)                                    FRAIMP DAI103B
     D*INST*****       S             10    DIM(21)                                     NADC02 FRAIMP
     D*GLCAT****       S              5    DIM(21)                                     NADC02 FRAIMP
     D*INSTRGLC*       S             15    DIM(21)                                     NADC02 FRAIMP
     D*INST************S             10    DIM(17)                                            NADC02
     D*GLCAT***********S              5    DIM(17)                                            NADC02
     D*INSTRGLC********S             15    DIM(17)                                            NADC02

     D*EXP*****        S             17  2 DIM(23)                                    FRAIMP DAI103B
     D*oEXP****        S             15  0 DIM(23)                                    FRAIMP DAI103B
     D*EXP*****        S             17  2 DIM(21)                                     NADC02 FRAIMP
     D*oEXP****        S             15  0 DIM(21)                                     NADC02 FRAIMP
     D*EXP*************S             17  2 DIM(17)                                            NADC02
     D*oEXP************S             15  0 DIM(17)                                            NADC02

     D*iEXP****        S             17  2 DIM(23)                                    FRAIMP DAI103B
     D*ioEXP***        S             15  0 DIM(23)                                    FRAIMP DAI103B
     D*iEXP****        S             17  2 DIM(21)                                     NADC02 FRAIMP
     D*ioEXP***        S             15  0 DIM(21)                                     NADC02 FRAIMP
     D*iEXP************S             17  2 DIM(17)                                            NADC02
     D*ioEXP***********S             15  0 DIM(17)                                            NADC02

     D*cEXP****        S             17  2 DIM(23)                                    FRAIMP DAI103B
     D*coEXP***        S             15  0 DIM(23)                                    FRAIMP DAI103B
     D*cEXP****        S             17  2 DIM(21)                                     NADC02 FRAIMP
     D*coEXP***        S             15  0 DIM(21)                                     NADC02 FRAIMP
     D*cEXP************S             17  2 DIM(17)                                            NADC02
     D*coEXP***********S             15  0 DIM(17)                                            NADC02

     D*tEXP****        S             17  2 DIM(23)                                    FRAIMP DAI103B
     D*toEXP***        S             15  0 DIM(23)                                    FRAIMP DAI103B
     D*tEXP****        S             17  2 DIM(21)                                     NADC02 FRAIMP
     D*toEXP***        S             15  0 DIM(21)                                     NADC02 FRAIMP
     D*tEXP************S             17  2 DIM(17)                                            NADC02
     D*toEXP***********S             15  0 DIM(17)                                            NADC02


     D*SECT****        S             34    DIM(50)                                           DAI103B
     D*SECT_TOT        S            425    DIM(50)  ASCEND                            FRAIMP DAI103B
     D*SECT_TOT        S            391    DIM(50)  ASCEND                             NADC02 FRAIMP
     D*SECT_TOT********S******      323    DIM(50)  ASCEND                                   NADC02

     D*********        DS                                                                    DAI103B
     D**STOT***                1    425                                               FRAIMP DAI103B
     D**SECTOT*               35    425  2 DIM(23)                                    FRAIMP DAI103B
     D**STOT***                1    391                                               NADC02 FRAIMP
     D**SECTOT*               35    391  2 DIM(17)                                    NADC02 FRAIMP
     D**STOT****************** 1    323                                                      NADC02
     D**SECTOT****************35    323  2 DIM(17)                                           NADC02


     D  MEINSTGLCAT    DS
     D  MEINST                 1     10
     D  MEGLCAT               11     15


     IGPMLEXD0
     I                                          MECNCD        L4
     I                                          MELICDNAM     L3
     I                                          MECUSTNAME    L2
     I                                          MELIMDEFC     L1

      * Change of country

     C   L4              Z-ADD     99            LINENO
     C   L4              Z-ADD     0             cEXP

      * Change of industry

     C   L3              Z-ADD     0             iEXP

      * Change of limit defined

     C   L1              Z-ADD     0             EXP

      * Accumulate exposure

     C                   EXSR      ACCUM_EXPOS

      * Report exposure
     CL1                 EXSR      REPORT_EXPOS

      * Report industry totals
     CL3                 EXSR      REPORT_INDTOT

      * Report country totals
     CL4                 EXSR      REPORT_CTYTOT

      * Final totals
     CLR                 EXSR      REPORT_FINTOT

      * Sector totals
     CLR                 EXSR      REPORT_SECTOT
      *****************************************************************
     C     ACCUM_EXPOS   BEGSR

      * SECTOR & SECTOR TOTAL

     C                   Z-ADD     1             #S                2 0
     C     MELICDNAM     LOOKUP    SECT(#S)                               99
     C  N99              DO
     C     *BLANK        LOOKUP    SECT(#S)                               99
     C                   MOVEL     MELICDNAM     SECT(#S)
     C                   MOVEL     MELICDNAM     STOT
     C                   Z-ADD     *ZEROS        SECTOT
     C                   MOVEL     STOT          SECT_TOT(#S)
     C                   ENDDO
     C                   MOVEL     SECT_TOT(#S)  STOT

      * INSTRUMENT
     C                   Z-ADD     1             #I
     C     MEINSTGLCAT   LOOKUP    INSTRGLC(#I)                           99
     C     *IN99         IFEQ      *ON

      * Exposure in USD

     C                   ADD       MEEXPINUSD    EXP(#I)
     C                   ADD       MEEXPINUSD    SECTOT(#I)

     C                   MOVEL     'TOTAL'       MEGLCAT
     C                   Z-ADD     1             #I
     C     MEINSTGLCAT   LOOKUP    INSTRGLC(#I)                           99

      * Exposure in USD

     C                   ADD       MEEXPINUSD    EXP(#I)
     C                   ADD       MEEXPINUSD    SECTOT(#I)
     C                   ENDIF

     C                   MOVEL     STOT          SECT_TOT(#S)

     C                   ENDSR
      *****************************************************************
     C     REPORT_EXPOS  BEGSR

     C     EXP(1)        COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21

     C     EXP(2)        COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22

     C     EXP(3)        COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23

     C     EXP(4)        COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24

     C     EXP(5)        COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25

     C     EXP(6)        COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26

     C     EXP(7)        COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27

     C     EXP(8)        COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28

     C     EXP(9)        COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29

     C     EXP(10)       COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30

     C     EXP(11)       COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31

     C     EXP(12)       COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32

     C     EXP(13)       COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33

     C     EXP(14)       COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34

     C     EXP(15)       COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35

     C     EXP(16)       COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36

     C     EXP(17)       COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
                                                                                              NADC02
     C     EXP(18)       COMP      0                                  3838                    NADC02
     C   38GLCAT(18)     COMP      'TOTAL'                                38                  NADC02
                                                                                              NADC02
     C     EXP(19)       COMP      0                                  3939                    NADC02
     C   39GLCAT(19)     COMP      'TOTAL'                                39                  NADC02
                                                                                              FRAIMP
     C     EXP(20)       COMP      0                                  4040                    FRAIMP
     C   40GLCAT(20)     COMP      'TOTAL'                                40                  FRAIMP
                                                                                              FRAIMP
     C     EXP(21)       COMP      0                                  4141                    FRAIMP
     C   41GLCAT(21)     COMP      'TOTAL'                                41                  FRAIMP
                                                                                             DAI103B
     C     EXP(22)       COMP      0                                  4242                   DAI103B
     C   42GLCAT(22)     COMP      'TOTAL'                                42                 DAI103B
                                                                                             DAI103B
     C     EXP(23)       COMP      0                                  4343                   DAI103B
     C   43GLCAT(23)     COMP      'TOTAL'                                43                 DAI103B
                                                                                             DAI103B
     C     EXP(24)       COMP      0                                  4444                   DAI103B
     C   44GLCAT(24)     COMP      'TOTAL'                                44                 DAI103B
                                                                                             DAI103B
     C     EXP(25)       COMP      0                                  4545                   DAI103B
     C   45GLCAT(25)     COMP      'TOTAL'                                45                 DAI103B

     C     EXP(1)        COMP      0                                  5151
     C     EXP(2)        COMP      0                                  5252
     C     EXP(3)        COMP      0                                  5353
     C     EXP(4)        COMP      0                                  5454
     C     EXP(5)        COMP      0                                  5555
     C     EXP(6)        COMP      0                                  5656
     C     EXP(7)        COMP      0                                  5757
     C     EXP(8)        COMP      0                                  5858
     C     EXP(9)        COMP      0                                  5959
     C     EXP(10)       COMP      0                                  6060
     C     EXP(11)       COMP      0                                  6161
     C     EXP(12)       COMP      0                                  6262
     C     EXP(13)       COMP      0                                  6363
     C     EXP(14)       COMP      0                                  6464
     C     EXP(15)       COMP      0                                  6565
     C     EXP(16)       COMP      0                                  6666
     C     EXP(17)       COMP      0                                  6767
     C     EXP(18)       COMP      0                                  6868                    NADC02
     C     EXP(19)       COMP      0                                  6969                    NADC02
     C     EXP(20)       COMP      0                                  7070                    FRAIMP
     C     EXP(21)       COMP      0                                  7171                    FRAIMP
     C     EXP(22)       COMP      0                                  7272                   DAI103B
     C     EXP(23)       COMP      0                                  7373                   DAI103B
     C     EXP(24)       COMP      0                                  7474                   DAI103B
     C     EXP(25)       COMP      0                                  7575                   DAI103B

     C   21              SETON                                        51
     C   22              SETON                                        52
     C   23              SETON                                        53
     C   24              SETON                                        54
     C   25              SETON                                        55
     C   26              SETON                                        56
     C   27              SETON                                        57
     C   28              SETON                                        58
     C   29              SETON                                        59
     C   30              SETON                                        60
     C   31              SETON                                        61
     C   32              SETON                                        62
     C   33              SETON                                        63
     C   34              SETON                                        64
     C   35              SETON                                        65
     C   36              SETON                                        66
     C   37              SETON                                        67
     C   38              SETON                                        68                      NADC02
     C   39              SETON                                        69                      NADC02
     C   40              SETON                                        70                      FRAIMP
     C   41              SETON                                        71                      FRAIMP
     C   42              SETON                                        72                     DAI103B
     C   43              SETON                                        73                     DAI103B
     C   44              SETON                                        74                     DAI103B
     C   45              SETON                                        75                     DAI103B

      * Exposure

     C                   Z-ADD(H)  EXP           oEXP
     C                   XFOOT     oEXP          TOTEXP           15 0
     C                   DIV       2             TOTEXP
      * Output
     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL

     C                   ADD       EXP           iEXP
     C                   ADD       EXP           cEXP
     C                   ADD       EXP           tEXP

     C                   ENDSR
      *****************************************************************
     C     REPORT_INDTOT BEGSR

     C     iEXP(1)       COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21

     C     iEXP(2)       COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22

     C     iEXP(3)       COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23

     C     iEXP(4)       COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24

     C     iEXP(5)       COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25

     C     iEXP(6)       COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26

     C     iEXP(7)       COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27

     C     iEXP(8)       COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28

     C     iEXP(9)       COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29

     C     iEXP(10)      COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30

     C     iEXP(11)      COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31

     C     iEXP(12)      COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32

     C     iEXP(13)      COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33

     C     iEXP(14)      COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34

     C     iEXP(15)      COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35

     C     iEXP(16)      COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36

     C     iEXP(17)      COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
                                                                                              NADC02
     C     iEXP(18)      COMP      0                                  3838                    NADC02
     C   38GLCAT(18)     COMP      'TOTAL'                                38                  NADC02
                                                                                              NADC02
     C     iEXP(19)      COMP      0                                  3939                    NADC02
     C   39GLCAT(19)     COMP      'TOTAL'                                39                  NADC02
                                                                                              FRAIMP
     C     iEXP(20)      COMP      0                                  4040                    FRAIMP
     C   40GLCAT(20)     COMP      'TOTAL'                                40                  FRAIMP
                                                                                              FRAIMP
     C     iEXP(21)      COMP      0                                  4141                    FRAIMP
     C   41GLCAT(21)     COMP      'TOTAL'                                41                  FRAIMP
                                                                                             DAI103B
     C     iEXP(22)      COMP      0                                  4242                   DAI103B
     C   42GLCAT(22)     COMP      'TOTAL'                                42                 DAI103B
                                                                                             DAI103B
     C     iEXP(23)      COMP      0                                  4343                   DAI103B
     C   43GLCAT(23)     COMP      'TOTAL'                                43                 DAI103B
                                                                                             DAI103B
     C     iEXP(24)      COMP      0                                  4444                   DAI103B
     C   44GLCAT(24)     COMP      'TOTAL'                                44                 DAI103B
                                                                                             DAI103B
     C     iEXP(25)      COMP      0                                  4545                   DAI103B
     C   45GLCAT(25)     COMP      'TOTAL'                                45                 DAI103B

     C     iEXP(1)       COMP      0                                  5151
     C     iEXP(2)       COMP      0                                  5252
     C     iEXP(3)       COMP      0                                  5353
     C     iEXP(4)       COMP      0                                  5454
     C     iEXP(5)       COMP      0                                  5555
     C     iEXP(6)       COMP      0                                  5656
     C     iEXP(7)       COMP      0                                  5757
     C     iEXP(8)       COMP      0                                  5858
     C     iEXP(9)       COMP      0                                  5959
     C     iEXP(10)      COMP      0                                  6060
     C     iEXP(11)      COMP      0                                  6161
     C     iEXP(12)      COMP      0                                  6262
     C     iEXP(13)      COMP      0                                  6363
     C     iEXP(14)      COMP      0                                  6464
     C     iEXP(15)      COMP      0                                  6565
     C     iEXP(16)      COMP      0                                  6666
     C     iEXP(17)      COMP      0                                  6767
     C     iEXP(18)      COMP      0                                  6868                    NADC02
     C     iEXP(19)      COMP      0                                  6969                    NADC02
     C     iEXP(20)      COMP      0                                  7070                    FRAIMP
     C     iEXP(21)      COMP      0                                  7171                    FRAIMP
     C     iEXP(22)      COMP      0                                  7272                   DAI103B
     C     iEXP(23)      COMP      0                                  7373                   DAI103B
     C     iEXP(24)      COMP      0                                  7474                   DAI103B
     C     iEXP(25)      COMP      0                                  7575                   DAI103B

     C   21              SETON                                        51
     C   22              SETON                                        52
     C   23              SETON                                        53
     C   24              SETON                                        54
     C   25              SETON                                        55
     C   26              SETON                                        56
     C   27              SETON                                        57
     C   28              SETON                                        58
     C   29              SETON                                        59
     C   30              SETON                                        60
     C   31              SETON                                        61
     C   32              SETON                                        62
     C   33              SETON                                        63
     C   34              SETON                                        64
     C   35              SETON                                        65
     C   36              SETON                                        66
     C   37              SETON                                        67
     C   38              SETON                                        68                      NADC02
     C   39              SETON                                        69                      NADC02
     C   40              SETON                                        70                      FRAIMP
     C   41              SETON                                        71                      FRAIMP
     C   42              SETON                                        72                     DAI103B
     C   43              SETON                                        73                     DAI103B
     C   44              SETON                                        74                     DAI103B
     C   45              SETON                                        75                     DAI103B

     C                   Z-ADD(H)  iEXP          ioEXP
     C                   XFOOT     ioEXP         TOTEXP
     C                   DIV       2             TOTEXP

     C                   Z-ADD     3             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    INDTOTAL

     C                   ENDSR
      *****************************************************************
     C     REPORT_CTYTOT BEGSR

     C     cEXP(1)       COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21

     C     cEXP(2)       COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22

     C     cEXP(3)       COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23

     C     cEXP(4)       COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24

     C     cEXP(5)       COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25

     C     cEXP(6)       COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26

     C     cEXP(7)       COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27

     C     cEXP(8)       COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28

     C     cEXP(9)       COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29

     C     cEXP(10)      COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30

     C     cEXP(11)      COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31

     C     cEXP(12)      COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32

     C     cEXP(13)      COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33

     C     cEXP(14)      COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34

     C     cEXP(15)      COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35

     C     cEXP(16)      COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36

     C     cEXP(17)      COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
                                                                                              NADC02
     C     cEXP(18)      COMP      0                                  3838                    NADC02
     C   38GLCAT(18)     COMP      'TOTAL'                                38                  NADC02
                                                                                              NADC02
     C     cEXP(19)      COMP      0                                  3939                    NADC02
     C   39GLCAT(19)     COMP      'TOTAL'                                39                  NADC02
                                                                                              FRAIMP
     C     cEXP(20)      COMP      0                                  4040                    FRAIMP
     C   40GLCAT(20)     COMP      'TOTAL'                                40                  FRAIMP
                                                                                              FRAIMP
     C     cEXP(21)      COMP      0                                  4141                    FRAIMP
     C   41GLCAT(21)     COMP      'TOTAL'                                41                  FRAIMP
                                                                                             DAI103B
     C     cEXP(22)      COMP      0                                  4242                   DAI103B
     C   42GLCAT(22)     COMP      'TOTAL'                                42                 DAI103B
                                                                                             DAI103B
     C     cEXP(23)      COMP      0                                  4343                   DAI103B
     C   43GLCAT(23)     COMP      'TOTAL'                                43                 DAI103B
                                                                                             DAI103B
     C     cEXP(24)      COMP      0                                  4444                   DAI103B
     C   44GLCAT(24)     COMP      'TOTAL'                                44                 DAI103B
                                                                                             DAI103B
     C     cEXP(25)      COMP      0                                  4545                   DAI103B
     C   45GLCAT(25)     COMP      'TOTAL'                                45                 DAI103B

     C     cEXP(1)       COMP      0                                  5151
     C     cEXP(2)       COMP      0                                  5252
     C     cEXP(3)       COMP      0                                  5353
     C     cEXP(4)       COMP      0                                  5454
     C     cEXP(5)       COMP      0                                  5555
     C     cEXP(6)       COMP      0                                  5656
     C     cEXP(7)       COMP      0                                  5757
     C     cEXP(8)       COMP      0                                  5858
     C     cEXP(9)       COMP      0                                  5959
     C     cEXP(10)      COMP      0                                  6060
     C     cEXP(11)      COMP      0                                  6161
     C     cEXP(12)      COMP      0                                  6262
     C     cEXP(13)      COMP      0                                  6363
     C     cEXP(14)      COMP      0                                  6464
     C     cEXP(15)      COMP      0                                  6565
     C     cEXP(16)      COMP      0                                  6666
     C     cEXP(17)      COMP      0                                  6767
     C     cEXP(18)      COMP      0                                  6868                    NADC02
     C     cEXP(19)      COMP      0                                  6969                    NADC02
     C     cEXP(20)      COMP      0                                  7070                    FRAIMP
     C     cEXP(21)      COMP      0                                  7171                    FRAIMP
     C     cEXP(22)      COMP      0                                  7272                   DAI103B
     C     cEXP(23)      COMP      0                                  7373                   DAI103B
     C     cEXP(24)      COMP      0                                  7474                   DAI103B
     C     cEXP(25)      COMP      0                                  7575                   DAI103B

     C   21              SETON                                        51
     C   22              SETON                                        52
     C   23              SETON                                        53
     C   24              SETON                                        54
     C   25              SETON                                        55
     C   26              SETON                                        56
     C   27              SETON                                        57
     C   28              SETON                                        58
     C   29              SETON                                        59
     C   30              SETON                                        60
     C   31              SETON                                        61
     C   32              SETON                                        62
     C   33              SETON                                        63
     C   34              SETON                                        64
     C   35              SETON                                        65
     C   36              SETON                                        66
     C   37              SETON                                        67
     C   38              SETON                                        68                      NADC02
     C   39              SETON                                        69                      NADC02
     C   40              SETON                                        70                      FRAIMP
     C   41              SETON                                        71                      FRAIMP
     C   42              SETON                                        72                     DAI103B
     C   43              SETON                                        73                     DAI103B
     C   44              SETON                                        74                     DAI103B
     C   45              SETON                                        75                     DAI103B

     C                   Z-ADD(H)  cEXP          coEXP
     C                   XFOOT     coEXP         TOTEXP
     C                   DIV       2             TOTEXP

     C                   Z-ADD     3             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    CTYTOTAL

     C                   ENDSR
      *****************************************************************
     C     REPORT_FINTOT BEGSR

     C     tEXP(1)       COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21

     C     tEXP(2)       COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22

     C     tEXP(3)       COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23

     C     tEXP(4)       COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24

     C     tEXP(5)       COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25

     C     tEXP(6)       COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26

     C     tEXP(7)       COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27

     C     tEXP(8)       COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28

     C     tEXP(9)       COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29

     C     tEXP(10)      COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30

     C     tEXP(11)      COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31

     C     tEXP(12)      COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32

     C     tEXP(13)      COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33

     C     tEXP(14)      COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34

     C     tEXP(15)      COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35

     C     tEXP(16)      COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36

     C     tEXP(17)      COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
                                                                                              NADC02
     C     tEXP(18)      COMP      0                                  3838                    NADC02
     C   38GLCAT(18)     COMP      'TOTAL'                                38                  NADC02
                                                                                              NADC02
     C     tEXP(19)      COMP      0                                  3939                    NADC02
     C   39GLCAT(19)     COMP      'TOTAL'                                39                  NADC02
                                                                                              FRAIMP
     C     tEXP(20)      COMP      0                                  4040                    FRAIMP
     C   40GLCAT(20)     COMP      'TOTAL'                                40                  FRAIMP
                                                                                              FRAIMP
     C     tEXP(21)      COMP      0                                  4141                    FRAIMP
     C   41GLCAT(21)     COMP      'TOTAL'                                41                  FRAIMP
                                                                                             DAI103B
     C     tEXP(22)      COMP      0                                  4242                   DAI103B
     C   42GLCAT(22)     COMP      'TOTAL'                                42                 DAI103B
                                                                                             DAI103B
     C     tEXP(23)      COMP      0                                  4343                   DAI103B
     C   43GLCAT(23)     COMP      'TOTAL'                                43                 DAI103B
                                                                                             DAI103B
     C     tEXP(24)      COMP      0                                  4444                   DAI103B
     C   44GLCAT(24)     COMP      'TOTAL'                                44                 DAI103B
                                                                                             DAI103B
     C     tEXP(25)      COMP      0                                  4545                   DAI103B
     C   45GLCAT(25)     COMP      'TOTAL'                                45                 DAI103B

     C     tEXP(1)       COMP      0                                  5151
     C     tEXP(2)       COMP      0                                  5252
     C     tEXP(3)       COMP      0                                  5353
     C     tEXP(4)       COMP      0                                  5454
     C     tEXP(5)       COMP      0                                  5555
     C     tEXP(6)       COMP      0                                  5656
     C     tEXP(7)       COMP      0                                  5757
     C     tEXP(8)       COMP      0                                  5858
     C     tEXP(9)       COMP      0                                  5959
     C     tEXP(10)      COMP      0                                  6060
     C     tEXP(11)      COMP      0                                  6161
     C     tEXP(12)      COMP      0                                  6262
     C     tEXP(13)      COMP      0                                  6363
     C     tEXP(14)      COMP      0                                  6464
     C     tEXP(15)      COMP      0                                  6565
     C     tEXP(16)      COMP      0                                  6666
     C     tEXP(17)      COMP      0                                  6767
     C     tEXP(18)      COMP      0                                  6868                    NADC02
     C     tEXP(19)      COMP      0                                  6969                    NADC02
     C     tEXP(20)      COMP      0                                  7070                    FRAIMP
     C     tEXP(21)      COMP      0                                  7171                    FRAIMP
     C     tEXP(22)      COMP      0                                  7272                   DAI103B
     C     tEXP(23)      COMP      0                                  7373                   DAI103B
     C     tEXP(24)      COMP      0                                  7474                   DAI103B
     C     tEXP(25)      COMP      0                                  7575                   DAI103B

     C   21              SETON                                        51
     C   22              SETON                                        52
     C   23              SETON                                        53
     C   24              SETON                                        54
     C   25              SETON                                        55
     C   26              SETON                                        56
     C   27              SETON                                        57
     C   28              SETON                                        58
     C   29              SETON                                        59
     C   30              SETON                                        60
     C   31              SETON                                        61
     C   32              SETON                                        62
     C   33              SETON                                        63
     C   34              SETON                                        64
     C   35              SETON                                        65
     C   36              SETON                                        66
     C   37              SETON                                        67
     C   38              SETON                                        68                      NADC02
     C   39              SETON                                        69                      NADC02
     C   40              SETON                                        70                      FRAIMP
     C   41              SETON                                        71                      FRAIMP
     C   42              SETON                                        72                     DAI103B
     C   43              SETON                                        73                     DAI103B
     C   44              SETON                                        74                     DAI103B
     C   45              SETON                                        75                     DAI103B

     C                   Z-ADD(H)  tEXP          toEXP
     C                   XFOOT     toEXP         TOTEXP
     C                   DIV       2             TOTEXP

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
     C     REPORT_SECTOT BEGSR

     C                   SORTA     SECT_TOT
     C                   Z-ADD     1             #S
     C     *BLANK        LOOKUP    SECT_TOT(#S)                       99
     C     *IN99         IFEQ      *ON
     C     #S            DOWLE     50
     C     SECT_TOT(#S)  ANDNE     *BLANK

     C                   MOVEL     SECT_TOT(#S)  MELICDNAM
     C                   MOVEL     SECT_TOT(#S)  STOT
     C                   Z-ADD     SECTOT        tEXP

     C     tEXP(1)       COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21

     C     tEXP(2)       COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22

     C     tEXP(3)       COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23

     C     tEXP(4)       COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24

     C     tEXP(5)       COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25

     C     tEXP(6)       COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26

     C     tEXP(7)       COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27

     C     tEXP(8)       COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28

     C     tEXP(9)       COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29

     C     tEXP(10)      COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30

     C     tEXP(11)      COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31

     C     tEXP(12)      COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32

     C     tEXP(13)      COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33

     C     tEXP(14)      COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34

     C     tEXP(15)      COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35

     C     tEXP(16)      COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36

     C     tEXP(17)      COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
                                                                                              NADC02
     C     tEXP(18)      COMP      0                                  3838                    NADC02
     C   38GLCAT(18)     COMP      'TOTAL'                                38                  NADC02
                                                                                              NADC02
     C     tEXP(19)      COMP      0                                  3939                    NADC02
     C   39GLCAT(19)     COMP      'TOTAL'                                39                  NADC02
                                                                                              FRAIMP
     C     tEXP(20)      COMP      0                                  4040                    FRAIMP
     C   40GLCAT(20)     COMP      'TOTAL'                                40                  FRAIMP
                                                                                              FRAIMP
     C     tEXP(21)      COMP      0                                  4141                    FRAIMP
     C   41GLCAT(21)     COMP      'TOTAL'                                41                  FRAIMP
                                                                                             DAI103B
     C     tEXP(22)      COMP      0                                  4242                   DAI103B
     C   42GLCAT(22)     COMP      'TOTAL'                                42                 DAI103B
                                                                                             DAI103B
     C     tEXP(23)      COMP      0                                  4343                   DAI103B
     C   43GLCAT(23)     COMP      'TOTAL'                                43                 DAI103B
                                                                                             DAI103B
     C     tEXP(24)      COMP      0                                  4444                   DAI103B
     C   44GLCAT(24)     COMP      'TOTAL'                                44                 DAI103B
                                                                                             DAI103B
     C     tEXP(25)      COMP      0                                  4545                   DAI103B
     C   45GLCAT(25)     COMP      'TOTAL'                                45                 DAI103B

     C     tEXP(1)       COMP      0                                  5151
     C     tEXP(2)       COMP      0                                  5252
     C     tEXP(3)       COMP      0                                  5353
     C     tEXP(4)       COMP      0                                  5454
     C     tEXP(5)       COMP      0                                  5555
     C     tEXP(6)       COMP      0                                  5656
     C     tEXP(7)       COMP      0                                  5757
     C     tEXP(8)       COMP      0                                  5858
     C     tEXP(9)       COMP      0                                  5959
     C     tEXP(10)      COMP      0                                  6060
     C     tEXP(11)      COMP      0                                  6161
     C     tEXP(12)      COMP      0                                  6262
     C     tEXP(13)      COMP      0                                  6363
     C     tEXP(14)      COMP      0                                  6464
     C     tEXP(15)      COMP      0                                  6565
     C     tEXP(16)      COMP      0                                  6666
     C     tEXP(17)      COMP      0                                  6767
     C     tEXP(18)      COMP      0                                  6868                    NADC02
     C     tEXP(19)      COMP      0                                  6969                    NADC02
     C     tEXP(20)      COMP      0                                  7070                    FRAIMP
     C     tEXP(21)      COMP      0                                  7171                    FRAIMP
     C     tEXP(22)      COMP      0                                  7272                   DAI103B
     C     tEXP(23)      COMP      0                                  7373                   DAI103B
     C     tEXP(24)      COMP      0                                  7474                   DAI103B
     C     tEXP(25)      COMP      0                                  7575                   DAI103B

     C   21              SETON                                        51
     C   22              SETON                                        52
     C   23              SETON                                        53
     C   24              SETON                                        54
     C   25              SETON                                        55
     C   26              SETON                                        56
     C   27              SETON                                        57
     C   28              SETON                                        58
     C   29              SETON                                        59
     C   30              SETON                                        60
     C   31              SETON                                        61
     C   32              SETON                                        62
     C   33              SETON                                        63
     C   34              SETON                                        64
     C   35              SETON                                        65
     C   36              SETON                                        66
     C   37              SETON                                        67
     C   38              SETON                                        68                      NADC02
     C   39              SETON                                        69                      NADC02
     C   40              SETON                                        70                      FRAIMP
     C   41              SETON                                        71                      FRAIMP
     C   42              SETON                                        72                     DAI103B
     C   43              SETON                                        73                     DAI103B
     C   44              SETON                                        74                     DAI103B
     C   45              SETON                                        75                     DAI103B

     C                   Z-ADD(H)  tEXP          toEXP
     C                   XFOOT     toEXP         TOTEXP
     C                   DIV       2             TOTEXP

     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    SECTOTAL

     C                   ADD       1             #S
     C                   ENDDO

     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    SECTOTALF

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
     C                   MOVE      'TOTAL'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '1 ON '       INSTRGLC(#J)
      *IR                                                                                     NADC02
     C                   WHEN      INSTR(#I) = 'GLOBIR'                                       NADC02
     C                   MOVE      'TOTAL'       INSTRGLC(#J)                                 NADC02
     C                   ADD       1             #J                                           NADC02
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)                                 NADC02
     C                   MOVE      '2 OFF'       INSTRGLC(#J)                                 NADC02
      *FR                                                                                     FRAIMP
     C                   WHEN      INSTR(#I) = 'GLOBFR'                                       FRAIMP
     C                   MOVE      'TOTAL'       INSTRGLC(#J)                                 FRAIMP
     C                   ADD       1             #J                                           FRAIMP
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)                                 FRAIMP
     C                   MOVE      '2 OFF'       INSTRGLC(#J)                                 FRAIMP
      *LE
     C                   WHEN      INSTR(#I) = 'GLOBLE'
     C                   MOVE      'TOTAL'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '1 ON '       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '2 OFF'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '3 MEM'       INSTRGLC(#J)
      *MM
     C                   WHEN      INSTR(#I) = 'GLOBMM'
     C                   MOVE      'TOTAL'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '1 ON '       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '4 FWD'       INSTRGLC(#J)
      *SE
     C                   WHEN      INSTR(#I) = 'GLOBSE'
     C                   MOVE      'TOTAL'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
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
     C                   MOVE      'TOTAL'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '1 ON '       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
     C                   MOVE      '2 OFF'       INSTRGLC(#J)
      *FW                                                                                    DAI103B
     C                   WHEN      INSTR(#I) = 'GLOBFW'                                      DAI103B
     C                   MOVE      'TOTAL'       INSTRGLC(#J)                                DAI103B
     C                   ADD       1             #J                                          DAI103B
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)                                DAI103B
     C                   MOVE      '2 OFF'       INSTRGLC(#J)                                DAI103B
      *NO                                                                                    DAI103B
     C                   WHEN      INSTR(#I) = 'GLOBNO'                                      DAI103B
     C                   MOVE      'TOTAL'       INSTRGLC(#J)                                DAI103B
     C                   ADD       1             #J                                          DAI103B
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)                                DAI103B
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
     OGPRPTMZSP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMZS '
     O                                           80 'COUNTERPARTY EXPOSURE +
     O                                              BY SECTOR REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                            6 'SECTOR'
     O                                           45 'COUNTERPARTY'
     O                                           61 'LIM'
     O                       INST(1)             78                                          DAI103B
     O                       INST(3)             93                                          DAI103B
     O                       INST(5)            108                                          DAI103B
     O                       INST(7)            123                                          DAI103B
     O                       INST(8)            138                                          DAI103B
     O                       INST(9)            153                                          DAI103B
     O                       INST(10)           168                                          DAI103B
     O                       INST(11)           183                                          DAI103B
     O                       INST(12)           198                                          DAI103B
     O                       INST(13)           213                                          DAI103B
     O                       INST(14)           228                                          DAI103B
     O                       INST(15)           243                                          DAI103B
     O                       INST(16)           258                                          DAI103B
     O                       INST(17)           273                                          DAI103B
     O                       INST(18)           288                                          DAI103B
     O                       INST(19)           303                                          DAI103B
     O                       INST(20)           318                                          DAI103B
     O                       INST(21)           333                                          DAI103B
     O                       INST(22)           348                                          DAI103B
     O                       INST(24)           363                                          DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          107 '|'                                      DAI103B
     O                                          167 '|'                                      DAI103B
     O                                          212 '|'                                      DAI103B
     O                                          287 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O                                          362 '|'                                      DAI103B
     O                                          377 'T O T A L '                             DAI103B
     O*********              INST(1)             78                                          DAI103B
     O*********              INST(2)             93                                          DAI103B
     O*********              INST(3)            108                                          DAI103B
     O*********              INST(4)            123                                          DAI103B
     O*********              INST(5)            138                                          DAI103B
     O*********              INST(6)            153                                          DAI103B
     O*********              INST(7)            168                                          DAI103B
     O*********              INST(8)            183                                          DAI103B
     O*********              INST(9)            198                                          DAI103B
     O*********              INST(10)           213                                          DAI103B
     O*********              INST(11)           228                                          DAI103B
     O*********              INST(12)           243                                          DAI103B
     O*********              INST(13)           258                                          DAI103B
     O*********              INST(14)           273                                          DAI103B
     O*********              INST(15)           288                                          DAI103B
     O*********              INST(16)           303                                          DAI103B
     O*********              INST(17)           318                                          DAI103B
     O*********              INST(18)           333                                   NADC02 DAI103B
     O*********              INST(19)           348                                   NADC02 DAI103B
     O*********              INST(20)           363                                   FRAIMP DAI103B
     O*********              INST(21)           378                                   FRAIMP DAI103B
     O*********                                  62 '|'                                      DAI103B
     O*********                                  92 '|'                                      DAI103B
     O*********                                 122 '|'                               NADC02 DAI103B
     O*********                                 152 '|'                               FRAIMP DAI103B
     O*********                                 212 '|'                               FRAIMP DAI103B
     O*********                                 257 '|'                               FRAIMP DAI103B
     O*********                                 332 '|'                               FRAIMP DAI103B
     O*********                                 378 '|'                               FRAIMP DAI103B
     O*********                                 392 'T O T A L  '                     FRAIMP DAI103B
     O*********                                 182 '|'                                NADC02 FRAIMP
     O*********                                 227 '|'                                NADC02 FRAIMP
     O*********                                 302 '|'                                NADC02 FRAIMP
     O*********                                 347 '|'                                NADC02 FRAIMP
     O*********                                 363 '|'                                NADC02 FRAIMP
     O*********                                 362 'T O T A L  '                      NADC02 FRAIMP
     O***********************                   152 '|'                                       NADC02
     O***********************                   197 '|'                                       NADC02
     O***********************                   272 '|'                                       NADC02
     O***********************                   317 '|'                                       NADC02
     O***********************                   333 '|'                                       NADC02
     O***********************                   332 'T O T A L  '                             NADC02
     O          E            PAGEHEAD    1
     O                       GLCAT(1)            73                                          DAI103B
     O                       GLCAT(3)            88                                          DAI103B
     O                       GLCAT(5)           103                                          DAI103B
     O                       GLCAT(7)           118                                          DAI103B
     O                       GLCAT(8)           133                                          DAI103B
     O                       GLCAT(9)           148                                          DAI103B
     O                       GLCAT(10)          163                                          DAI103B
     O                       GLCAT(11)          178                                          DAI103B
     O                       GLCAT(12)          193                                          DAI103B
     O                       GLCAT(13)          208                                          DAI103B
     O                       GLCAT(14)          223                                          DAI103B
     O                       GLCAT(15)          238                                          DAI103B
     O                       GLCAT(16)          253                                          DAI103B
     O                       GLCAT(17)          268                                          DAI103B
     O                       GLCAT(18)          283                                          DAI103B
     O                       GLCAT(19)          298                                          DAI103B
     O                       GLCAT(20)          313                                          DAI103B
     O                       GLCAT(21)          328                                          DAI103B
     O                       GLCAT(22)          343                                          DAI103B
     O                       GLCAT(24)          358                                          DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          107 '|'                                      DAI103B
     O                                          167 '|'                                      DAI103B
     O                                          212 '|'                                      DAI103B
     O                                          287 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O                                          362 '|'                                      DAI103B
     O*********              GLCAT(1)            73                                          DAI103B
     O*********              GLCAT(2)            88                                          DAI103B
     O*********              GLCAT(3)           103                                          DAI103B
     O*********              GLCAT(4)           118                                          DAI103B
     O*********              GLCAT(5)           133                                          DAI103B
     O*********              GLCAT(6)           148                                          DAI103B
     O*********              GLCAT(7)           163                                          DAI103B
     O*********              GLCAT(8)           178                                          DAI103B
     O*********              GLCAT(9)           193                                          DAI103B
     O*********              GLCAT(10)          208                                          DAI103B
     O*********              GLCAT(11)          223                                          DAI103B
     O*********              GLCAT(12)          238                                          DAI103B
     O*********              GLCAT(13)          253                                          DAI103B
     O*********              GLCAT(14)          268                                          DAI103B
     O*********              GLCAT(15)          283                                          DAI103B
     O*********              GLCAT(16)          298                                          DAI103B
     O*********              GLCAT(17)          313                                          DAI103B
     O*********              GLCAT(18)          328                                   NADC02 DAI103B
     O*********              GLCAT(19)          343                                   NADC02 DAI103B
     O*********              GLCAT(20)          358                                   FRAIMP DAI103B
     O*********              GLCAT(21)          373                                   FRAIMP DAI103B
     O*********                                  61 'DEF'                                    DAI103B
     O*********                                  62 '|'                                      DAI103B
     O*********                                  92 '|'                                      DAI103B
     O*********                                 122 '|'                               NADC02 DAI103B
     O*********                                 152 '|'                               FRAIMP DAI103B
     O*********                                 212 '|'                               FRAIMP DAI103B
     O*********                                 257 '|'                               FRAIMP DAI103B
     O*********                                 332 '|'                               FRAIMP DAI103B
     O*********                                 378 '|'                               FRAIMP DAI103B
     O*********                                 182 '|'                                NADC02 FRAIMP
     O*********                                 227 '|'                                NADC02 FRAIMP
     O*********                                 302 '|'                                NADC02 FRAIMP
     O*********                                 347 '|'                                NADC02 FRAIMP
     O*********                                 363 '|'                                NADC02 FRAIMP
     O***********************                   152 '|'                                       NADC02
     O***********************                   197 '|'                                       NADC02
     O***********************                   272 '|'                                       NADC02
     O***********************                   317 '|'                                       NADC02
     O***********************                   333 '|'                                       NADC02
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
     O                                          260 '=========================='
     O                                          286 '=========================='
     O                                          302 '=========================='
     O                                          328 '=========================='
     O                                          333 '=========================='
     O                                          359 '=========================='              NADC02
     O                                          363 '===='                                    NADC02
     O                                          378 '==============='                         FRAIMP
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
     O                                          260 '=========================='
     O                                          286 '=========================='
     O                                          302 '=========================='
     O                                          328 '=========================='
     O                                          333 '=========================='
     O                                          359 '=========================='              NADC02
     O                                          363 '===='                                    NADC02
     O                                          378 '==============='                         FRAIMP
     O          E            TOTAL       1
     O                       MELICDNAM           34
     O                       TOTEXP             376 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     74oEXP(24)           361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     72oEXP(22)           346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     71oEXP(21)           331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     70oEXP(20)           316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     69oEXP(19)           301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     68oEXP(18)           286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     67oEXP(17)           271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     66oEXP(16)           256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     65oEXP(15)           241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     64oEXP(14)           226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     63oEXP(13)           211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     62oEXP(12)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     61oEXP(11)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     60oEXP(10)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     59oEXP(9)            151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     58oEXP(8)            136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     57oEXP(7)            121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     55oEXP(5)            106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     53oEXP(3)             91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     51oEXP(1)             76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          107 '|'                                      DAI103B
     O                                          167 '|'                                      DAI103B
     O                                          212 '|'                                      DAI103B
     O                                          287 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O                                          362 '|'                                      DAI103B
     O***********************TOTEXP             332 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            69oEXP(19)           346 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            68oEXP(18)           331 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             392 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            71oEXP(21)           376 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            70oEXP(20)           361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            69oEXP(19)           346 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            68oEXP(18)           331 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            67oEXP(17)           316 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            66oEXP(16)           301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            65oEXP(15)           286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            64oEXP(14)           271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            63oEXP(13)           256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            62oEXP(12)           241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            61oEXP(11)           226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            60oEXP(10)           211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            59oEXP(9)            196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            58oEXP(8)            181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            57oEXP(7)            166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            56oEXP(6)            151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            55oEXP(5)            136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            54oEXP(4)            121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            53oEXP(3)            106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            52oEXP(2)             91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            51oEXP(1)             76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                       MECUSTNAME          61
     O                                           61 '   '
     O                       MELIMDEFC           60
     O*********                                  62 '|'                                      DAI103B
     O*********                                  92 '|'                                      DAI103B
     O*********                                 122 '|'                               NADC02 DAI103B
     O*********                                 152 '|'                               FRAIMP DAI103B
     O*********                                 212 '|'                               FRAIMP DAI103B
     O*********                                 257 '|'                               FRAIMP DAI103B
     O*********                                 332 '|'                               FRAIMP DAI103B
     O*********                                 378 '|'                               FRAIMP DAI103B
     O*********                                 182 '|'                                NADC02 FRAIMP
     O*********                                 227 '|'                                NADC02 FRAIMP
     O*********                                 302 '|'                                NADC02 FRAIMP
     O*********                                 347 '|'                                NADC02 FRAIMP
     O*********                                 363 '|'                                NADC02 FRAIMP
     O***********************                   152 '|'                                       NADC02
     O***********************                   197 '|'                                       NADC02
     O***********************                   272 '|'                                       NADC02
     O***********************                   317 '|'                                       NADC02
     O***********************                   333 '|'                                       NADC02
     O          E            INDTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          156 '--------------------------'
     O                                          182 '--------------------------'
     O                                          208 '--------------------------'
     O                                          234 '--------------------------'
     O                                          260 '--------------------------'
     O                                          286 '--------------------------'
     O                                          302 '--------------------------'
     O                                          328 '--------------------------'
     O                                          333 '--------------------------'
     O                                          359 '--------------------------'              NADC02
     O                                          363 '----'                                    NADC02
     O                                          378 '---------------'                         FRAIMP
     O          E            INDTOTAL    1
     O                       MELICDNAM           34
     O                                           43 ' T O T A L '
     O                       TOTEXP             376 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     74ioEXP(24)          361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     72ioEXP(22)          346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     71ioEXP(21)          331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     70ioEXP(20)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     69ioEXP(19)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     68ioEXP(18)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     67ioEXP(17)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     66ioEXP(16)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     65ioEXP(15)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     64ioEXP(14)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     63ioEXP(13)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     62ioEXP(12)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     61ioEXP(11)          181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     60ioEXP(10)          166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     59ioEXP(9)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     58ioEXP(8)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     57ioEXP(7)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     55ioEXP(5)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     53ioEXP(3)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     51ioEXP(1)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          107 '|'                                      DAI103B
     O                                          167 '|'                                      DAI103B
     O                                          212 '|'                                      DAI103B
     O                                          287 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O                                          362 '|'                                      DAI103B
     O***********************TOTEXP             332 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             392 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            71ioEXP(21)          376 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            70ioEXP(20)          361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            69ioEXP(19)          346 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            68ioEXP(18)          331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            67ioEXP(17)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            66ioEXP(16)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            65ioEXP(15)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            64ioEXP(14)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            63ioEXP(13)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            62ioEXP(12)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            61ioEXP(11)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            60ioEXP(10)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            59ioEXP(9)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            58ioEXP(8)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            57ioEXP(7)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            56ioEXP(6)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            55ioEXP(5)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            54ioEXP(4)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            53ioEXP(3)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            52ioEXP(2)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            51ioEXP(1)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  62 '|'                                      DAI103B
     O*********                                  92 '|'                                      DAI103B
     O*********                                 122 '|'                               NADC02 DAI103B
     O*********                                 152 '|'                               FRAIMP DAI103B
     O*********                                 212 '|'                               FRAIMP DAI103B
     O*********                                 257 '|'                               FRAIMP DAI103B
     O*********                                 332 '|'                               FRAIMP DAI103B
     O*********                                 378 '|'                               FRAIMP DAI103B
     O*********                                 182 '|'                                NADC02 FRAIMP
     O*********                                 227 '|'                                NADC02 FRAIMP
     O*********                                 302 '|'                                NADC02 FRAIMP
     O*********                                 347 '|'                                NADC02 FRAIMP
     O*********                                 363 '|'                                NADC02 FRAIMP
     O***********************                   152 '|'                                       NADC02
     O***********************                   197 '|'                                       NADC02
     O***********************                   272 '|'                                       NADC02
     O***********************                   317 '|'                                       NADC02
     O***********************                   333 '|'                                       NADC02
     O          E            INDTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          156 '--------------------------'
     O                                          182 '--------------------------'
     O                                          208 '--------------------------'
     O                                          234 '--------------------------'
     O                                          260 '--------------------------'
     O                                          286 '--------------------------'
     O                                          302 '--------------------------'
     O                                          328 '--------------------------'
     O                                          333 '--------------------------'
     O                                          359 '--------------------------'              NADC02
     O                                          363 '----'                                    NADC02
     O                                          378 '---------------'                         FRAIMP
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
     O                                          260 '--------------------------'
     O                                          286 '--------------------------'
     O                                          302 '--------------------------'
     O                                          328 '--------------------------'
     O                                          333 '--------------------------'
     O                                          359 '--------------------------'              NADC02
     O                                          363 '----'                                    NADC02
     O                                          378 '---------------'                         FRAIMP
     O          E            CTYTOTAL    1
     O                       MECNCDNAM           33
     O                       TOTEXP             376 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     74coEXP(24)          361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     72coEXP(22)          346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     71coEXP(21)          331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     70coEXP(20)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     69coEXP(19)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     68coEXP(18)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     67coEXP(17)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     66coEXP(16)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     65coEXP(15)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     64coEXP(14)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     63coEXP(13)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     62coEXP(12)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     61coEXP(11)          181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     60coEXP(10)          166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     59coEXP(9)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     58coEXP(8)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     57coEXP(7)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     55coEXP(5)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     53coEXP(3)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     51coEXP(1)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          107 '|'                                      DAI103B
     O                                          167 '|'                                      DAI103B
     O                                          212 '|'                                      DAI103B
     O                                          287 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O                                          362 '|'                                      DAI103B
     O***********************TOTEXP             332 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             392 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            71coEXP(21)          376 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            70coEXP(20)          361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            69coEXP(19)          346 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            68coEXP(18)          331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            67coEXP(17)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            66coEXP(16)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            65coEXP(15)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            64coEXP(14)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            63coEXP(13)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            62coEXP(12)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            61coEXP(11)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            60coEXP(10)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            59coEXP(9)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            58coEXP(8)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            57coEXP(7)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            56coEXP(6)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            55coEXP(5)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            54coEXP(4)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            53coEXP(3)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            52coEXP(2)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            51coEXP(1)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  62 '|'                                      DAI103B
     O*********                                  92 '|'                                      DAI103B
     O*********                                 122 '|'                               NADC02 DAI103B
     O*********                                 152 '|'                               FRAIMP DAI103B
     O*********                                 212 '|'                               FRAIMP DAI103B
     O*********                                 257 '|'                               FRAIMP DAI103B
     O*********                                 332 '|'                               FRAIMP DAI103B
     O*********                                 378 '|'                               FRAIMP DAI103B
     O*********                                 182 '|'                                NADC02 FRAIMP
     O*********                                 227 '|'                                NADC02 FRAIMP
     O*********                                 302 '|'                                NADC02 FRAIMP
     O*********                                 347 '|'                                NADC02 FRAIMP
     O*********                                 363 '|'                                NADC02 FRAIMP
     O***********************                   152 '|'                                       NADC02
     O***********************                   197 '|'                                       NADC02
     O***********************                   272 '|'                                       NADC02
     O***********************                   317 '|'                                       NADC02
     O***********************                   333 '|'                                       NADC02
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
     O                                          260 '--------------------------'
     O                                          286 '--------------------------'
     O                                          302 '--------------------------'
     O                                          328 '--------------------------'
     O                                          333 '--------------------------'
     O                                          359 '--------------------------'              NADC02
     O                                          363 '----'                                    NADC02
     O                                          378 '---------------'                         FRAIMP
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
     O                                          260 '--------------------------'
     O                                          286 '--------------------------'
     O                                          302 '--------------------------'
     O                                          328 '--------------------------'
     O                                          333 '--------------------------'
     O                                          359 '--------------------------'              NADC02
     O                                          363 '----'                                    NADC02
     O                                          378 '---------------'                         FRAIMP
     O          E            FINTOTAL    1
     O                                           22 'G R A N D   T O T A L '
     O                       TOTEXP             376 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     74toEXP(24)          361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     72toEXP(22)          346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     71toEXP(21)          331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     70toEXP(20)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     69toEXP(19)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     68toEXP(18)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     67toEXP(17)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     66toEXP(16)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     65toEXP(15)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     64toEXP(14)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     63toEXP(13)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     62toEXP(12)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     61toEXP(11)          181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     60toEXP(10)          166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     59toEXP(9)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     58toEXP(8)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     57toEXP(7)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     55toEXP(5)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     53toEXP(3)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     51toEXP(1)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          107 '|'                                      DAI103B
     O                                          167 '|'                                      DAI103B
     O                                          212 '|'                                      DAI103B
     O                                          287 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O                                          362 '|'                                      DAI103B
     O***********************TOTEXP             332 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             392 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            71toEXP(21)          376 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            70toEXP(20)          361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            69toEXP(19)          346 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            68toEXP(18)          331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            67toEXP(17)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            66toEXP(16)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            65toEXP(15)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            64toEXP(14)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            63toEXP(13)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            62toEXP(12)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            61toEXP(11)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            60toEXP(10)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            59toEXP(9)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            58toEXP(8)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            57toEXP(7)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            56toEXP(6)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            55toEXP(5)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            54toEXP(4)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            53toEXP(3)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            52toEXP(2)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            51toEXP(1)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  62 '|'                                      DAI103B
     O*********                                  92 '|'                                      DAI103B
     O*********                                 122 '|'                               NADC02 DAI103B
     O*********                                 152 '|'                               FRAIMP DAI103B
     O*********                                 212 '|'                               FRAIMP DAI103B
     O*********                                 257 '|'                               FRAIMP DAI103B
     O*********                                 332 '|'                               FRAIMP DAI103B
     O*********                                 378 '|'                               FRAIMP DAI103B
     O*********                                 182 '|'                                NADC02 FRAIMP
     O*********                                 227 '|'                                NADC02 FRAIMP
     O*********                                 302 '|'                                NADC02 FRAIMP
     O*********                                 347 '|'                                NADC02 FRAIMP
     O*********                                 363 '|'                                NADC02 FRAIMP
     O***********************                   152 '|'                                       NADC02
     O***********************                   197 '|'                                       NADC02
     O***********************                   272 '|'                                       NADC02
     O***********************                   317 '|'                                       NADC02
     O***********************                   333 '|'                                       NADC02
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
     O                                          260 '--------------------------'
     O                                          286 '--------------------------'
     O                                          302 '--------------------------'
     O                                          328 '--------------------------'
     O                                          333 '--------------------------'
     O                                          359 '--------------------------'              NADC02
     O                                          363 '----'                                    NADC02
     O                                          378 '---------------'                         FRAIMP
     O          E            SECTOTAL    1
     O                       TOTEXP             376 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     74toEXP(24)          361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     72toEXP(22)          346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     71toEXP(21)          331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     70toEXP(20)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     69toEXP(19)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     68toEXP(18)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     67toEXP(17)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     66toEXP(16)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     65toEXP(15)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     64toEXP(14)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     63toEXP(13)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     62toEXP(12)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     61toEXP(11)          181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     60toEXP(10)          166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     59toEXP(9)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     58toEXP(8)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     57toEXP(7)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     55toEXP(5)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     53toEXP(3)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     51toEXP(1)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          107 '|'                                      DAI103B
     O                                          167 '|'                                      DAI103B
     O                                          212 '|'                                      DAI103B
     O                                          287 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O                                          362 '|'                                      DAI103B
     O                       MELICDNAM           34
     O***********************TOTEXP             332 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             392 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            71toEXP(21)          376 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            70toEXP(20)          361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            69toEXP(19)          346 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            68toEXP(18)          331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            67toEXP(17)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            66toEXP(16)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            65toEXP(15)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            64toEXP(14)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            63toEXP(13)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            62toEXP(12)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            61toEXP(11)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            60toEXP(10)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            59toEXP(9)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            58toEXP(8)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            57toEXP(7)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            56toEXP(6)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            55toEXP(5)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            54toEXP(4)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            53toEXP(3)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            52toEXP(2)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            51toEXP(1)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  62 '|'                                      DAI103B
     O*********                                  92 '|'                                      DAI103B
     O*********                                 122 '|'                               NADC02 DAI103B
     O*********                                 152 '|'                               FRAIMP DAI103B
     O*********                                 212 '|'                               FRAIMP DAI103B
     O*********                                 257 '|'                               FRAIMP DAI103B
     O*********                                 332 '|'                               FRAIMP DAI103B
     O*********                                 378 '|'                               FRAIMP DAI103B
     O*********                                 182 '|'                                NADC02 FRAIMP
     O*********                                 227 '|'                                NADC02 FRAIMP
     O*********                                 302 '|'                                NADC02 FRAIMP
     O*********                                 347 '|'                                NADC02 FRAIMP
     O*********                                 363 '|'                                NADC02 FRAIMP
     O***********************                   152 '|'                                       NADC02
     O***********************                   197 '|'                                       NADC02
     O***********************                   272 '|'                                       NADC02
     O***********************                   317 '|'                                       NADC02
     O***********************                   333 '|'                                       NADC02
     O          E            SECTOTALF   1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O                                          156 '--------------------------'
     O                                          182 '--------------------------'
     O                                          208 '--------------------------'
     O                                          234 '--------------------------'
     O                                          260 '--------------------------'
     O                                          286 '--------------------------'
     O                                          302 '--------------------------'
     O                                          328 '--------------------------'
     O                                          333 '--------------------------'
     O                                          359 '--------------------------'              NADC02
     O                                          363 '----'                                    NADC02
     O                                          378 '---------------'                         FRAIMP
