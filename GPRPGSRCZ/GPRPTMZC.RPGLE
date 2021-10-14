     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Report ML Country Exposure v. Limits')        *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMZC  - Report ML Country Exposure v. Limits             *
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
      *  DAI103 - Upgraded MPlus 121 NADC01, NADC02 and FRAIMP ML     *
      *           Extracts to FB 2.1                                  *
      *  FRAIMP - ML Reporting to include FRA                         *
      *  NADC02 - ML REPORTING TO INCLUDE IRS                         *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************

     FGPMLXCL1  IP   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FGPMLZCPD  IF A E           K DISK
     FGZSDBANKPDIF   E             DISK
     F*PRPTMZCP1O****F  348        PRINTER                                                    NADC02
     FGPRPTMZCP1O    F  378        PRINTER                                                    NADC02
     F                                     INFDS(SPOOLU)

      ** File Information Data Structure for GPRPTMZCP1
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
                                                                                             DAI103B
     D CLIM            S             15  0 DIM(25)                                           DAI103B
     D CEXP            S             15  0 DIM(25)                                           DAI103B
     D CEXE            S             15  0 DIM(25)                                           DAI103B
                                                                                             DAI103B
     D tCLIM           S             15  0 DIM(25)                                           DAI103B
     D tCEXP           S             15  0 DIM(25)                                           DAI103B
     D tCEXE           S             15  0 DIM(25)                                           DAI103B
                                                                                             DAI103B
     D*INST****        S             10    DIM(21)                                           DAI103B
     D*GLCAT***        S              5    DIM(21)                                           DAI103B
     D*INSTRGLC        S             15    DIM(21)                                           DAI103B

     D*CLIM****        S             15  0 DIM(21)                                           DAI103B
     D*CEXP****        S             15  0 DIM(21)                                           DAI103B
     D*CEXE****        S             15  0 DIM(21)                                           DAI103B

     D*tCLIM***        S             15  0 DIM(21)                                           DAI103B
     D*tCEXP***        S             15  0 DIM(21)                                           DAI103B
     D*tCEXE***        S             15  0 DIM(21)                                           DAI103B


     D  MEINSTGLCAT    DS
     D  MEINST                 1     10
     D  MEGLCAT               11     15


     D                 DS
     D  YYMMDD                 1     10
     D  YY                     3      4
     D  MM                     6      7
     D  DD                     9     10


     IGPMLXCD0
     I                                          MECNCD        L2
     I                                          MELIMDEF      L1

      * Change of country

     C   L2              EXSR      CHECK_EXCESS
     C   L2              IF        Do_output = 'Y'
     C   L2              SETON                                        80
     C   L2              Z-ADD     1             CHLINE
     C   L2              EXSR      PAG
     C   L2              EXCEPT    STRC
     C                   ENDIF

      * Change of limit defined

     C  NL2              DO
     C   L1              IF        Do_output = 'Y'
     C   L1              SETOFF                                       80
     C   L1              Z-ADD     1             CHLINE
     C   L1              EXSR      PAG
     C   L1              EXCEPT    STRC
     C                   ENDIF
     C                   ENDDO

     C   L1              Z-ADD     0             CLIM
     C   L1              Z-ADD     0             CEXE
     C   L1              Z-ADD     0             CEXP

      * Limit expiry date

     C                   EXSR      LIMIT_EXPDATE

      * Accumulate exposure

     C                   IF        Do_output = 'Y'
     C                   EXSR      ACCUM_EXPOS
     C                   ENDIF

      * Report exposure
     CL1                 IF        Do_output = 'Y'
     CL1                 EXSR      REPORT_EXPOS
     CL1                 ENDIF
     CL1                 MOVE      *BLANK        YYMMDD

      * Final totals
     CLR                 EXSR      REPORT_FINTOT
      *****************************************************************
     C     LIMIT_EXPDATE BEGSR

      * Update limit expiry date

     C                   IF        MELIMDEF = 'Y'
     C                             AND MEEXPDATE <> *BLANK
     C                   MOVEL     MEEXPDATE     YYMMDD
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C     ACCUM_EXPOS   BEGSR

      * INSTRUMENT
     C                   Z-ADD     1             #I
     C     MEINSTGLCAT   LOOKUP    INSTRGLC(#I)                           99
     C     *IN99         IFEQ      *ON

      * Country Exposure in USD

     C                   ADD       MECEXPUSD     CEXP(#I)

      * Country Limit in USD

     C                   MOVEL     'TOTAL'       MEGLCAT
     C                   Z-ADD     1             #I
     C     MEINSTGLCAT   LOOKUP    INSTRGLC(#I)                           99
     C                   IF        MELIMTUSD > 0
     C                   Z-ADD     MELIMTUSD     CLIM(#I)
     C                   ENDIF

      * Country Exposure in USD
      * Country Excess in USD

     C                   ADD       MECEXPUSD     CEXP(#I)
     C     CEXP(#I)      SUB       CLIM(#I)      CEXE(#I)               99
     C   99              Z-ADD     0             CEXE(#I)
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C     REPORT_EXPOS  BEGSR

     C     CLIM(1)       COMP      0                                  2121
     C  N21CEXP(1)       COMP      0                                  2121
     C  N21CEXE(1)       COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21

     C     CLIM(2)       COMP      0                                  2222
     C  N22CEXP(2)       COMP      0                                  2222
     C  N22CEXE(2)       COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22

     C     CLIM(3)       COMP      0                                  2323
     C  N23CEXP(3)       COMP      0                                  2323
     C  N23CEXE(3)       COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23

     C     CLIM(4)       COMP      0                                  2424
     C  N24CEXP(4)       COMP      0                                  2424
     C  N24CEXE(4)       COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24

     C     CLIM(5)       COMP      0                                  2525
     C  N25CEXP(5)       COMP      0                                  2525
     C  N25CEXE(5)       COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25

     C     CLIM(6)       COMP      0                                  2626
     C  N26CEXP(6)       COMP      0                                  2626
     C  N26CEXE(6)       COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26

     C     CLIM(7)       COMP      0                                  2727
     C  N27CEXP(7)       COMP      0                                  2727
     C  N27CEXE(7)       COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27

     C     CLIM(8)       COMP      0                                  2828
     C  N28CEXP(8)       COMP      0                                  2828
     C  N28CEXE(8)       COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28

     C     CLIM(9)       COMP      0                                  2929
     C  N29CEXP(9)       COMP      0                                  2929
     C  N29CEXE(9)       COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29

     C     CLIM(10)      COMP      0                                  3030
     C  N30CEXP(10)      COMP      0                                  3030
     C  N30CEXE(10)      COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30

     C     CLIM(11)      COMP      0                                  3131
     C  N31CEXP(11)      COMP      0                                  3131
     C  N31CEXE(11)      COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31

     C     CLIM(12)      COMP      0                                  3232
     C  N32CEXP(12)      COMP      0                                  3232
     C  N32CEXE(12)      COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32

     C     CLIM(13)      COMP      0                                  3333
     C  N33CEXP(13)      COMP      0                                  3333
     C  N33CEXE(13)      COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33

     C     CLIM(14)      COMP      0                                  3434
     C  N34CEXP(14)      COMP      0                                  3434
     C  N34CEXE(14)      COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34

     C     CLIM(15)      COMP      0                                  3535
     C  N35CEXP(15)      COMP      0                                  3535
     C  N35CEXE(15)      COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35

     C     CLIM(16)      COMP      0                                  3636
     C  N36CEXP(16)      COMP      0                                  3636
     C  N36CEXE(16)      COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36

     C     CLIM(17)      COMP      0                                  3737
     C  N37CEXP(17)      COMP      0                                  3737
     C  N37CEXE(17)      COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
                                                                                              NADC02
     C     CLIM(18)      COMP      0                                  3838                    NADC02
     C  N38CEXP(18)      COMP      0                                  3838                    NADC02
     C  N38CEXE(18)      COMP      0                                  3838                    NADC02
     C   38GLCAT(18)     COMP      'TOTAL'                                38                  NADC02
                                                                                              NADC02
     C     CLIM(19)      COMP      0                                  3939                    NADC02
     C  N39CEXP(19)      COMP      0                                  3939                    NADC02
     C  N39CEXE(19)      COMP      0                                  3939                    NADC02
     C   39GLCAT(19)     COMP      'TOTAL'                                39                  NADC02
                                                                                              FRAIMP
     C*****CLIM(20)      COMP      0                                  4040            FRAIMP DAI103B
     C**N38CEXP(20)      COMP      0                                  4040            FRAIMP DAI103B
     C**N38CEXE(20)      COMP      0                                  4040            FRAIMP DAI103B
     C***38GLCAT(20)     COMP      'TOTAL'                                40          FRAIMP DAI103B
                                                                                              FRAIMP
     C*****CLIM(21)      COMP      0                                  4141            FRAIMP DAI103B
     C**N39CEXP(21)      COMP      0                                  4141            FRAIMP DAI103B
     C**N39CEXE(21)      COMP      0                                  4141            FRAIMP DAI103B
     C***39GLCAT(21)     COMP      'TOTAL'                                41          FRAIMP DAI103B
                                                                                             DAI103B
     C     CLIM(20)      COMP      0                                  4040                   DAI103B
     C  N40CEXP(20)      COMP      0                                  4040                   DAI103B
     C  N40CEXE(20)      COMP      0                                  4040                   DAI103B
     C   40GLCAT(20)     COMP      'TOTAL'                                40                 DAI103B
                                                                                             DAI103B
     C     CLIM(21)      COMP      0                                  4141                   DAI103B
     C  N41CEXP(21)      COMP      0                                  4141                   DAI103B
     C  N41CEXE(21)      COMP      0                                  4141                   DAI103B
     C   41GLCAT(21)     COMP      'TOTAL'                                41                 DAI103B
                                                                                             DAI103B
     C     CLIM(22)      COMP      0                                  4242                   DAI103B
     C  N42CEXP(22)      COMP      0                                  4242                   DAI103B
     C  N42CEXE(22)      COMP      0                                  4242                   DAI103B
     C   42GLCAT(22)     COMP      'TOTAL'                                42                 DAI103B
                                                                                             DAI103B
     C     CLIM(23)      COMP      0                                  4343                   DAI103B
     C  N43CEXP(23)      COMP      0                                  4343                   DAI103B
     C  N43CEXE(23)      COMP      0                                  4343                   DAI103B
     C   43GLCAT(23)     COMP      'TOTAL'                                43                 DAI103B
                                                                                             DAI103B
     C     CLIM(24)      COMP      0                                  4444                   DAI103B
     C  N44CEXP(24)      COMP      0                                  4444                   DAI103B
     C  N44CEXE(24)      COMP      0                                  4444                   DAI103B
     C   44GLCAT(24)     COMP      'TOTAL'                                44                 DAI103B
                                                                                             DAI103B
     C     CLIM(25)      COMP      0                                  4545                   DAI103B
     C  N45CEXP(25)      COMP      0                                  4545                   DAI103B
     C  N45CEXE(25)      COMP      0                                  4545                   DAI103B
     C   45GLCAT(25)     COMP      'TOTAL'                                45                 DAI103B

     C     CEXP(1)       COMP      0                                  5151
     C     CEXP(2)       COMP      0                                  5252
     C     CEXP(3)       COMP      0                                  5353
     C     CEXP(4)       COMP      0                                  5454
     C     CEXP(5)       COMP      0                                  5555
     C     CEXP(6)       COMP      0                                  5656
     C     CEXP(7)       COMP      0                                  5757
     C     CEXP(8)       COMP      0                                  5858
     C     CEXP(9)       COMP      0                                  5959
     C     CEXP(10)      COMP      0                                  6060
     C     CEXP(11)      COMP      0                                  6161
     C     CEXP(12)      COMP      0                                  6262
     C     CEXP(13)      COMP      0                                  6363
     C     CEXP(14)      COMP      0                                  6464
     C     CEXP(15)      COMP      0                                  6565
     C     CEXP(16)      COMP      0                                  6666
     C     CEXP(17)      COMP      0                                  6767
     C     CEXP(18)      COMP      0                                  6868                    NADC02
     C     CEXP(19)      COMP      0                                  6969                    NADC02
     C     CEXP(20)      COMP      0                                  7070                    FRAIMP
     C     CEXP(21)      COMP      0                                  7171                    FRAIMP
     C     CEXP(22)      COMP      0                                  7272                   DAI103B
     C     CEXP(23)      COMP      0                                  7373                   DAI103B
     C     CEXP(24)      COMP      0                                  7474                   DAI103B
     C     CEXP(25)      COMP      0                                  7575                   DAI103B

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

      * Limit, exposure, excess

     C                   XFOOT     CLIM          TOTLIM           15 0
     C                   XFOOT     CEXP          TOTEXP           15 0
     C                   DIV       2             TOTEXP
     C                   XFOOT     CEXE          TOTEXE           15 0
      * Expiry date
     C                   IF        YYMMDD <> *BLANK
     C                   EVAL      REXPDATE = DD + '-' + MM + '-' + YY
     C                   ELSE
     C                   MOVEL     *BLANK        REXPDATE          8
     C                   ENDIF
      * Output
     C                   Z-ADD     5             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL

     C                   ADD       CLIM          tCLIM
     C                   ADD       CEXP          tCEXP
     C                   ADD       CEXE          tCEXE
      * Record if excess
     C                   IF        I#EXCES <> 'Y'
     C                             AND TOTEXE <> 0
     C                   WRITE     GPMLZCD0
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C     CHECK_EXCESS  BEGSR
     C                   IF        I#EXCES = 'Y'
     C     MECNCD        CHAIN     GPMLZCD0                           99
     C                   ENDIF
     C                   IF        I#EXCES <> 'Y'
     C                             OR I#EXCES = 'Y' AND *IN99 = *OFF
     C                   MOVE      'Y'           Do_output         1
     C                   ELSE
     C                   MOVE      'N'           Do_output
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C     REPORT_FINTOT BEGSR

     C     tCLIM(1)      COMP      0                                  2121
     C  N21tCEXP(1)      COMP      0                                  2121
     C  N21tCEXE(1)      COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21

     C     tCLIM(2)      COMP      0                                  2222
     C  N22tCEXP(2)      COMP      0                                  2222
     C  N22tCEXE(2)      COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22

     C     tCLIM(3)      COMP      0                                  2323
     C  N23tCEXP(3)      COMP      0                                  2323
     C  N23tCEXE(3)      COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23

     C     tCLIM(4)      COMP      0                                  2424
     C  N24tCEXP(4)      COMP      0                                  2424
     C  N24tCEXE(4)      COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24

     C     tCLIM(5)      COMP      0                                  2525
     C  N25tCEXP(5)      COMP      0                                  2525
     C  N25tCEXE(5)      COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25

     C     tCLIM(6)      COMP      0                                  2626
     C  N26tCEXP(6)      COMP      0                                  2626
     C  N26tCEXE(6)      COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26

     C     tCLIM(7)      COMP      0                                  2727
     C  N27tCEXP(7)      COMP      0                                  2727
     C  N27tCEXE(7)      COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27

     C     tCLIM(8)      COMP      0                                  2828
     C  N28tCEXP(8)      COMP      0                                  2828
     C  N28tCEXE(8)      COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28

     C     tCLIM(9)      COMP      0                                  2929
     C  N29tCEXP(9)      COMP      0                                  2929
     C  N29tCEXE(9)      COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29

     C     tCLIM(10)     COMP      0                                  3030
     C  N30tCEXP(10)     COMP      0                                  3030
     C  N30tCEXE(10)     COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30

     C     tCLIM(11)     COMP      0                                  3131
     C  N31tCEXP(11)     COMP      0                                  3131
     C  N31tCEXE(11)     COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31

     C     tCLIM(12)     COMP      0                                  3232
     C  N32tCEXP(12)     COMP      0                                  3232
     C  N32tCEXE(12)     COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32

     C     tCLIM(13)     COMP      0                                  3333
     C  N33tCEXP(13)     COMP      0                                  3333
     C  N33tCEXE(13)     COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33

     C     tCLIM(14)     COMP      0                                  3434
     C  N34tCEXP(14)     COMP      0                                  3434
     C  N34tCEXE(14)     COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34

     C     tCLIM(15)     COMP      0                                  3535
     C  N35tCEXP(15)     COMP      0                                  3535
     C  N35tCEXE(15)     COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35

     C     tCLIM(16)     COMP      0                                  3636
     C  N36tCEXP(16)     COMP      0                                  3636
     C  N36tCEXE(16)     COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36

     C     tCLIM(17)     COMP      0                                  3737
     C  N37tCEXP(17)     COMP      0                                  3737
     C  N37tCEXE(17)     COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
                                                                                              NADC02
     C     tCLIM(18)     COMP      0                                  3838                    NADC02
     C  N38tCEXP(18)     COMP      0                                  3838                    NADC02
     C  N38tCEXE(18)     COMP      0                                  3838                    NADC02
     C   38GLCAT(18)     COMP      'TOTAL'                                38                  NADC02
                                                                                              NADC02
     C     tCLIM(19)     COMP      0                                  3939                    NADC02
     C  N39tCEXP(19)     COMP      0                                  3939                    NADC02
     C  N39tCEXE(19)     COMP      0                                  3939                    NADC02
     C   39GLCAT(19)     COMP      'TOTAL'                                39                  NADC02
                                                                                              FRAIMP
     C*****tCLIM(20)     COMP      0                                  4040            FRAIMP DAI103B
     C**N38tCEXP(20)     COMP      0                                  4040            FRAIMP DAI103B
     C**N38tCEXE(20)     COMP      0                                  4040            FRAIMP DAI103B
     C***38GLCAT(20)     COMP      'TOTAL'                                40          FRAIMP DAI103B
                                                                                              FRAIMP
     C*****tCLIM(21)     COMP      0                                  4141            FRAIMP DAI103B
     C**N39tCEXP(21)     COMP      0                                  4141            FRAIMP DAI103B
     C**N39tCEXE(21)     COMP      0                                  4141            FRAIMP DAI103B
     C***39GLCAT(21)     COMP      'TOTAL'                                41          FRAIMP DAI103B
                                                                                             DAI103B
     C     tCLIM(20)     COMP      0                                  4040                   DAI103B
     C  N40tCEXP(20)     COMP      0                                  4040                   DAI103B
     C  N40tCEXE(20)     COMP      0                                  4040                   DAI103B
     C   40GLCAT(20)     COMP      'TOTAL'                                40                 DAI103B
                                                                                             DAI103B
     C     tCLIM(21)     COMP      0                                  4141                   DAI103B
     C  N41tCEXP(21)     COMP      0                                  4141                   DAI103B
     C  N41tCEXE(21)     COMP      0                                  4141                   DAI103B
     C   41GLCAT(21)     COMP      'TOTAL'                                41                 DAI103B

     C     tCEXP(1)      COMP      0                                  5151
     C     tCEXP(2)      COMP      0                                  5252
     C     tCEXP(3)      COMP      0                                  5353
     C     tCEXP(4)      COMP      0                                  5454
     C     tCEXP(5)      COMP      0                                  5555
     C     tCEXP(6)      COMP      0                                  5656
     C     tCEXP(7)      COMP      0                                  5757
     C     tCEXP(8)      COMP      0                                  5858
     C     tCEXP(9)      COMP      0                                  5959
     C     tCEXP(10)     COMP      0                                  6060
     C     tCEXP(11)     COMP      0                                  6161
     C     tCEXP(12)     COMP      0                                  6262
     C     tCEXP(13)     COMP      0                                  6363
     C     tCEXP(14)     COMP      0                                  6464
     C     tCEXP(15)     COMP      0                                  6565
     C     tCEXP(16)     COMP      0                                  6666
     C     tCEXP(17)     COMP      0                                  6767
     C     tCEXP(18)     COMP      0                                  6868                    NADC02
     C     tCEXP(19)     COMP      0                                  6969                    NADC02
     C     tCEXP(20)     COMP      0                                  7070                    FRAIMP
     C     tCEXP(21)     COMP      0                                  7171                    FRAIMP
     C     tCEXP(22)     COMP      0                                  7272                   DAI103B
     C     tCEXP(23)     COMP      0                                  7373                   DAI103B
     C     tCEXP(24)     COMP      0                                  7474                   DAI103B
     C     tCEXP(25)     COMP      0                                  7575                   DAI103B

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

     C                   XFOOT     tCLIM         TOTLIM
     C                   XFOOT     tCEXP         TOTEXP
     C                   DIV       2             TOTEXP
     C                   XFOOT     tCEXE         TOTEXE

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
     C     *ENTRY        PLIST
     C                   PARM                    I#EXCES           1
     C     I#EXCES       COMP      'Y'                                    85

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
     OGPRPTMZCP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMZC '
     O                                           70 'COUNTRY EXPOSURE +
     O                                              v LIMITS REPORT'
     O                     85                    79 ' - EXCESS'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                            7 'COUNTRY'
     O                                           29 'LIMIT'
     O                                           37 'EXPIRY'
     O                       INST(1)             63                                          DAI103B
     O                       INST(3)             78                                          DAI103B
     O                       INST(5)             93                                          DAI103B
     O                       INST(7)            108                                          DAI103B
     O                       INST(8)            123                                          DAI103B
     O                       INST(9)            138                                          DAI103B
     O                       INST(10)           153                                          DAI103B
     O                       INST(11)           168                                          DAI103B
     O                       INST(12)           183                                          DAI103B
     O                       INST(13)           198                                          DAI103B
     O                       INST(14)           213                                          DAI103B
     O                       INST(15)           228                                          DAI103B
     O                       INST(16)           243                                          DAI103B
     O                       INST(17)           258                                          DAI103B
     O                       INST(18)           273                                          DAI103B
     O                       INST(19)           288                                          DAI103B
     O                       INST(20)           303                                          DAI103B
     O                       INST(21)           318                                          DAI103B
     O                       INST(22)           333                                          DAI103B
     O                       INST(24)           348                                          DAI103B
     O                                           47 '|'                                      DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          152 '|'                                      DAI103B
     O                                          197 '|'                                      DAI103B
     O                                          272 '|'                                      DAI103B
     O                                          317 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O                                          362 'T O T A L '                             DAI103B
     O*********              INST(1)             63                                          DAI103B
     O*********              INST(2)             78                                          DAI103B
     O*********              INST(3)             93                                          DAI103B
     O*********              INST(4)            108                                          DAI103B
     O*********              INST(5)            123                                          DAI103B
     O*********              INST(6)            138                                          DAI103B
     O*********              INST(7)            153                                          DAI103B
     O*********              INST(8)            168                                          DAI103B
     O*********              INST(9)            183                                          DAI103B
     O*********              INST(10)           198                                          DAI103B
     O*********              INST(11)           213                                          DAI103B
     O*********              INST(12)           228                                          DAI103B
     O*********              INST(13)           243                                          DAI103B
     O*********              INST(14)           258                                          DAI103B
     O*********              INST(15)           273                                          DAI103B
     O*********              INST(16)           288                                          DAI103B
     O*********              INST(17)           303                                          DAI103B
     O*********              INST(18)           318                                   NADC02 DAI103B
     O*********              INST(19)           333                                   NADC02 DAI103B
     O*********              INST(20)           348                                   FRAIMP DAI103B
     O*********              INST(21)           363                                   FRAIMP DAI103B
     O*********                                  47 '|'                                      DAI103B
     O*********                                  77 '|'                                      DAI103B
     O*********                                 107 '|'                               NADC02 DAI103B
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 347 'T O T A L  '                      NADC02 FRAIMP
     O*********                                 137 '|'                               FRAIMP DAI103B
     O*********                                 197 '|'                               FRAIMP DAI103B
     O*********                                 242 '|'                               FRAIMP DAI103B
     O*********                                 317 '|'                               FRAIMP DAI103B
     O*********                                 362 '|'                               FRAIMP DAI103B
     O*********                                 378 'T O T A L  '                     FRAIMP DAI103B
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   317 'T O T A L  '                             NADC02
     O          E            PAGEHEAD    1
     O                                           37 ' DATE '
     O                       GLCAT(1)            58                                          DAI103B
     O                       GLCAT(3)            73                                          DAI103B
     O                       GLCAT(5)            88                                          DAI103B
     O                       GLCAT(7)           103                                          DAI103B
     O                       GLCAT(8)           118                                          DAI103B
     O                       GLCAT(9)           133                                          DAI103B
     O                       GLCAT(10)          148                                          DAI103B
     O                       GLCAT(11)          163                                          DAI103B
     O                       GLCAT(12)          178                                          DAI103B
     O                       GLCAT(13)          193                                          DAI103B
     O                       GLCAT(14)          208                                          DAI103B
     O                       GLCAT(15)          223                                          DAI103B
     O                       GLCAT(16)          238                                          DAI103B
     O                       GLCAT(17)          253                                          DAI103B
     O                       GLCAT(18)          268                                          DAI103B
     O                       GLCAT(19)          283                                          DAI103B
     O                       GLCAT(20)          298                                          DAI103B
     O                       GLCAT(21)          313                                          DAI103B
     O                       GLCAT(22)          328                                          DAI103B
     O                       GLCAT(24)          343                                          DAI103B
     O                                           47 '|'                                      DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          152 '|'                                      DAI103B
     O                                          197 '|'                                      DAI103B
     O                                          272 '|'                                      DAI103B
     O                                          317 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O*********              GLCAT(1)            58                                          DAI103B
     O*********              GLCAT(2)            73                                          DAI103B
     O*********              GLCAT(3)            88                                          DAI103B
     O*********              GLCAT(4)           103                                          DAI103B
     O*********              GLCAT(5)           118                                          DAI103B
     O*********              GLCAT(6)           133                                          DAI103B
     O*********              GLCAT(7)           148                                          DAI103B
     O*********              GLCAT(8)           163                                          DAI103B
     O*********              GLCAT(9)           178                                          DAI103B
     O*********              GLCAT(10)          193                                          DAI103B
     O*********              GLCAT(11)          208                                          DAI103B
     O*********              GLCAT(12)          223                                          DAI103B
     O*********              GLCAT(13)          238                                          DAI103B
     O*********              GLCAT(14)          253                                          DAI103B
     O*********              GLCAT(15)          268                                          DAI103B
     O*********              GLCAT(16)          283                                          DAI103B
     O*********              GLCAT(17)          298                                          DAI103B
     O*********              GLCAT(18)          313                                   NADC02 DAI103B
     O*********              GLCAT(19)          328                                   NADC02 DAI103B
     O*********              GLCAT(20)          343                                   FRAIMP DAI103B
     O*********              GLCAT(21)          358                                   FRAIMP DAI103B
     O*********                                  47 '|'                                      DAI103B
     O*********                                  77 '|'                                      DAI103B
     O*********                                 107 '|'                               NADC02 DAI103B
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 137 '|'                               FRAIMP DAI103B
     O*********                                 197 '|'                               FRAIMP DAI103B
     O*********                                 242 '|'                               FRAIMP DAI103B
     O*********                                 317 '|'                               FRAIMP DAI103B
     O*********                                 362 '|'                               FRAIMP DAI103B
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O          E            STRC        1
     O               80                          26 '--------------------------'
     O               80                          52 '--------------------------'
     O              N80                          62 '|-----------------------'
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
     O                                          317 '--------------------------'
     O                                          343 '--------------------------'              NADC02
     O                                          347 '----'                                    NADC02
     O                                          373 '--------------------------'              FRAIMP
     O                                          377 '----'                                    FRAIMP
     O          E            TOTAL       1
     O               80      MECNCDNAM           33
     O                                           33 '        '
     O                       MELIMDEF            27
     O                       REXPDATE            37
     O                       TOTLIM             361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     44CLIM(24)           346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     42CLIM(22)           331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     41CLIM(21)           316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     40CLIM(20)           301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     39CLIM(19)           286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     38CLIM(18)           271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     37CLIM(17)           256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     36CLIM(16)           241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     35CLIM(15)           226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     34CLIM(14)           211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     33CLIM(13)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     32CLIM(12)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     31CLIM(11)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     30CLIM(10)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     29CLIM(9)            136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     28CLIM(8)            121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     27CLIM(7)            106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     25CLIM(5)             91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     23CLIM(3)             76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     21CLIM(1)             61 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           47 '|'                                      DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          152 '|'                                      DAI103B
     O                                          197 '|'                                      DAI103B
     O                                          272 '|'                                      DAI103B
     O                                          317 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O***********************TOTLIM             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTLIM             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTLIM             377 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            41CLIM(21)           361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            40CLIM(20)           346 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            39CLIM(19)           331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            38CLIM(18)           316 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            37CLIM(17)           301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            36CLIM(16)           286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            35CLIM(15)           271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            34CLIM(14)           256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            33CLIM(13)           241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            32CLIM(12)           226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            31CLIM(11)           211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            30CLIM(10)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            29CLIM(9)            181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            28CLIM(8)            166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            27CLIM(7)            151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            26CLIM(6)            136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            25CLIM(5)            121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            24CLIM(4)            106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            23CLIM(3)             91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            22CLIM(2)             76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            21CLIM(1)             61 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  77 '|'                                      DAI103B
     O*********                                 107 '|'                               NADC02 DAI103B
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 137 '|'                               FRAIMP DAI103B
     O*********                                 197 '|'                               FRAIMP DAI103B
     O*********                                 242 '|'                               FRAIMP DAI103B
     O*********                                 317 '|'                               FRAIMP DAI103B
     O*********                                 362 '|'                               FRAIMP DAI103B
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O                                           47 '| LIMIT |'
     O          E            TOTAL       1
     O               80                           2 '=='
     O                       TOTEXP             361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     74CEXP(24)           346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     72CEXP(22)           331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     71CEXP(21)           316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     70CEXP(20)           301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     69CEXP(19)           286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     68CEXP(18)           271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     67CEXP(17)           256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     66CEXP(16)           241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     65CEXP(15)           226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     64CEXP(14)           211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     63CEXP(13)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     62CEXP(12)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     61CEXP(11)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     60CEXP(10)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     59CEXP(9)            136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     58CEXP(8)            121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     57CEXP(7)            106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     55CEXP(5)             91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     53CEXP(3)             76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     51CEXP(1)             61 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           47 '|'                                      DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          152 '|'                                      DAI103B
     O                                          197 '|'                                      DAI103B
     O                                          272 '|'                                      DAI103B
     O                                          317 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O***********************TOTEXP             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             377 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            71CEXP(21)           361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            70CEXP(20)           346 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            69CEXP(19)           331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            68CEXP(18)           316 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            67CEXP(17)           301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            66CEXP(16)           286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            65CEXP(15)           271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            64CEXP(14)           256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            63CEXP(13)           241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            62CEXP(12)           226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            61CEXP(11)           211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            60CEXP(10)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            59CEXP(9)            181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            58CEXP(8)            166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            57CEXP(7)            151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            56CEXP(6)            136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            55CEXP(5)            121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            54CEXP(4)            106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            53CEXP(3)             91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            52CEXP(2)             76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            51CEXP(1)             61 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  77 '|'                                      DAI103B
     O*********                                 107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 137 '|'                               FRAIMP DAI103B
     O*********                                 197 '|'                               FRAIMP DAI103B
     O*********                                 242 '|'                               FRAIMP DAI103B
     O*********                                 317 '|'                               FRAIMP DAI103B
     O*********                                 362 '|'                               FRAIMP DAI103B
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O                                           47 '| EXPOS |'
     O          E            TOTAL       1
     O                       TOTEXE             361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     44CEXE(24)           346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     42CEXE(22)           331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     41CEXE(21)           316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     40CEXE(20)           301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     39CEXE(19)           286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     38CEXE(18)           271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     37CEXE(17)           256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     36CEXE(16)           241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     35CEXE(15)           226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     34CEXE(14)           211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     33CEXE(13)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     32CEXE(12)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     31CEXE(11)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     30CEXE(10)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     29CEXE(9)            136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     28CEXE(8)            121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     27CEXE(7)            106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     25CEXE(5)             91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     23CEXE(3)             76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     21CEXE(1)             61 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           47 '|'                                      DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          152 '|'                                      DAI103B
     O                                          197 '|'                                      DAI103B
     O                                          272 '|'                                      DAI103B
     O                                          317 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O***********************TOTEXE             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXE             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXE             377 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            41CEXE(21)           361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            40CEXE(20)           346 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            39CEXE(19)           331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            38CEXE(18)           316 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            37CEXE(17)           301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            36CEXE(16)           286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            35CEXE(15)           271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            34CEXE(14)           256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            33CEXE(13)           241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            32CEXE(12)           226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            31CEXE(11)           211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            30CEXE(10)           196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            29CEXE(9)            181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            28CEXE(8)            166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            27CEXE(7)            151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            26CEXE(6)            136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            25CEXE(5)            121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            24CEXE(4)            106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            23CEXE(3)             91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            22CEXE(2)             76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            21CEXE(1)             61 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  77 '|'                                      DAI103B
     O*********                                 107 '|'                               NADC02 DAI103B
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 137 '|'                               FRAIMP DAI103B
     O*********                                 197 '|'                               FRAIMP DAI103B
     O*********                                 242 '|'                               FRAIMP DAI103B
     O*********                                 317 '|'                               FRAIMP DAI103B
     O*********                                 362 '|'                               FRAIMP DAI103B
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O                                           47 '| EXCES |'
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
     O                                          317 '--------------------------'
     O                                          343 '--------------------------'              NADC02
     O                                          347 '----'                                    NADC02
     O                                          373 '--------------------------'              FRAIMP
     O                                          377 '----'                                    FRAIMP
     O          E            FINTOTAL    1
     O                                           22 'G R A N D   T O T A L '
     O                       TOTLIM             361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     44tCLIM(24)          346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     42tCLIM(22)          331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     41tCLIM(21)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     40tCLIM(20)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     39tCLIM(19)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     38tCLIM(18)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     37tCLIM(17)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     36tCLIM(16)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     35tCLIM(15)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     34tCLIM(14)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     33tCLIM(13)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     32tCLIM(12)          181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     31tCLIM(11)          166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     30tCLIM(10)          151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     29tCLIM(9)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     28tCLIM(8)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     27tCLIM(7)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     25tCLIM(5)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     23tCLIM(3)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     21tCLIM(1)            61 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           47 '|'                                      DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          152 '|'                                      DAI103B
     O                                          197 '|'                                      DAI103B
     O                                          272 '|'                                      DAI103B
     O                                          317 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O***********************TOTLIM             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTLIM             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTLIM             377 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            41tCLIM(21)          361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            40tCLIM(20)          346 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            39tCLIM(19)          331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            38tCLIM(18)          316 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            37tCLIM(17)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            36tCLIM(16)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            35tCLIM(15)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            34tCLIM(14)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            33tCLIM(13)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            32tCLIM(12)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            31tCLIM(11)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            30tCLIM(10)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            29tCLIM(9)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            28tCLIM(8)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            27tCLIM(7)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            26tCLIM(6)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            25tCLIM(5)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            24tCLIM(4)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            23tCLIM(3)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            22tCLIM(2)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            21tCLIM(1)            61 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  77 '|'                                      DAI103B
     O*********                                 107 '|'                               NADC02 DAI103B
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 137 '|'                               FRAIMP DAI103B
     O*********                                 197 '|'                               FRAIMP DAI103B
     O*********                                 242 '|'                               FRAIMP DAI103B
     O*********                                 317 '|'                               FRAIMP DAI103B
     O*********                                 362 '|'                               FRAIMP DAI103B
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O                                           47 '| LIMIT |'
     O          E            FINTOTAL    1
     O                       TOTEXP             361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     74tCEXP(24)          346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     72tCEXP(22)          331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     71tCEXP(21)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     70tCEXP(20)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     69tCEXP(19)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     68tCEXP(18)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     67tCEXP(17)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     66tCEXP(16)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     65tCEXP(15)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     64tCEXP(14)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     63tCEXP(13)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     62tCEXP(12)          181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     61tCEXP(11)          166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     60tCEXP(10)          151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     59tCEXP(9)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     58tCEXP(8)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     57tCEXP(7)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     55tCEXP(5)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     53tCEXP(3)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     51tCEXP(1)            61 '   ,   ,   ,   , 0 -'                   DAI103B
     O                                           47 '|'                                      DAI103B
     O                                           62 '|'                                      DAI103B
     O                                           77 '|'                                      DAI103B
     O                                           92 '|'                                      DAI103B
     O                                          152 '|'                                      DAI103B
     O                                          197 '|'                                      DAI103B
     O                                          272 '|'                                      DAI103B
     O                                          317 '|'                                      DAI103B
     O                                          332 '|'                                      DAI103B
     O                                          347 '|'                                      DAI103B
     O***********************TOTEXP             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXP             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             377 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            71tCEXP(21)          361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            70tCEXP(20)          346 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            69tCEXP(19)          331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            68tCEXP(18)          316 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            67tCEXP(17)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            66tCEXP(16)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            65tCEXP(15)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            64tCEXP(14)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            63tCEXP(13)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            62tCEXP(12)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            61tCEXP(11)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            60tCEXP(10)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            59tCEXP(9)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            58tCEXP(8)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            57tCEXP(7)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            56tCEXP(6)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            55tCEXP(5)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            54tCEXP(4)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            53tCEXP(3)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            52tCEXP(2)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            51tCEXP(1)            61 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  77 '|'                                      DAI103B
     O*********                                 107 '|'                               NADC02 DAI103B
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 137 '|'                               FRAIMP DAI103B
     O*********                                 197 '|'                               FRAIMP DAI103B
     O*********                                 242 '|'                               FRAIMP DAI103B
     O*********                                 317 '|'                               FRAIMP DAI103B
     O*********                                 362 '|'                               FRAIMP DAI103B
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O                                           47 '| EXPOS |'
     O          E            FINTOTAL    1
     O                       TOTEXE             361 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     44tCEXE(24)          346 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     42tCEXE(22)          331 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     41tCEXE(21)          316 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     40tCEXE(20)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     39tCEXE(19)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     38tCEXE(18)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     37tCEXE(17)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     36tCEXE(16)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     35tCEXE(15)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     34tCEXE(14)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     33tCEXE(13)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     32tCEXE(12)          181 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     31tCEXE(11)          166 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     30tCEXE(10)          151 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     29tCEXE(9)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     28tCEXE(8)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     27tCEXE(7)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     25tCEXE(5)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     23tCEXE(3)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O                     21tCEXE(1)            61 '   ,   ,   ,   , 0 -'                   DAI103B
     O***********************TOTEXE             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********              TOTEXE             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXE             377 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            41tCEXE(21)          361 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            40tCEXE(20)          346 '   ,   ,   ,   , 0 -'            FRAIMP DAI103B
     O*********            39tCEXE(19)          331 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            38tCEXE(18)          316 '   ,   ,   ,   , 0 -'            NADC02 DAI103B
     O*********            37tCEXE(17)          301 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            36tCEXE(16)          286 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            35tCEXE(15)          271 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            34tCEXE(14)          256 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            33tCEXE(13)          241 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            32tCEXE(12)          226 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            31tCEXE(11)          211 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            30tCEXE(10)          196 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            29tCEXE(9)           181 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            28tCEXE(8)           166 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            27tCEXE(7)           151 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            26tCEXE(6)           136 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            25tCEXE(5)           121 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            24tCEXE(4)           106 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            23tCEXE(3)            91 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            22tCEXE(2)            76 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********            21tCEXE(1)            61 '   ,   ,   ,   , 0 -'                   DAI103B
     O*********                                  77 '|'                                      DAI103B
     O*********                                 107 '|'                               NADC02 DAI103B
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 137 '|'                               FRAIMP DAI103B
     O*********                                 197 '|'                               FRAIMP DAI103B
     O*********                                 242 '|'                               FRAIMP DAI103B
     O*********                                 317 '|'                               FRAIMP DAI103B
     O*********                                 362 '|'                               FRAIMP DAI103B
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O                                           47 '| EXCES |'
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
     O                                          317 '--------------------------'
     O                                          343 '--------------------------'              NADC02
     O                                          347 '----'                                    NADC02
     O                                          373 '--------------------------'              FRAIMP
     O                                          377 '----'                                    FRAIMP
