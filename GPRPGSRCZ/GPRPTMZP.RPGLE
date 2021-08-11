     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Report ML Counterparty Exp. v. Limits')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMZP  - Report ML Counterparty Exposure v. Limits        *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103             Date 25Jun19               *
      *  Prev Amend No. FRAIMP             Date 05May13               *
      *                 NADC02             Date 12Jun12               *
      *                 NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103 - Upgraded MPlus 121 NADC01 and NADC02 to ML Extracts *
      *           to FB 2.1                                           *
      *  FRAIMP - ML Reporting to include FRA                         *
      *  NADC02 - ML REPORTING TO INCLUDE IRS                         *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
 
     FGPMLXPL0  IP   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FGPMLZPPD  IF A E           K DISK
     FGZSDBANKPDIF   E             DISK
     F*PRPTMZPP1O****F  348        PRINTER                                                    NADC02
     F*PRPTMZPP1O    F  378        PRINTER                                                    NADC02
     FGPRPTMZPP1O    F  408        PRINTER                                                    NADC02
     F                                     INFDS(SPOOLU)
 
      ** File Information Data Structure for GPRPTMZPP1
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
     D INSTR           S             10    DIM(10)
     D*INST            S             10    DIM(21)                                            FRAIMP
     D*GLCAT           S              5    DIM(21)                                            FRAIMP
     D*INSTRGLC        S             15    DIM(21)                                            FRAIMP
     D INST            S             10    DIM(23)                                            FRAIMP
     D GLCAT           S              5    DIM(23)                                            FRAIMP
     D INSTRGLC        S             15    DIM(23)                                            FRAIMP
 
     D*PLIM            S             15  0 DIM(21)                                            FRAIMP
     D*PEXP            S             15  0 DIM(21)                                            FRAIMP
     D*PEXE            S             15  0 DIM(21)                                            FRAIMP
     D PLIM            S             15  0 DIM(23)                                            FRAIMP
     D PEXP            S             15  0 DIM(23)                                            FRAIMP
     D PEXE            S             15  0 DIM(23)                                            FRAIMP
 
     D*cPLIM           S             15  0 DIM(21)                                            FRAIMP
     D*cPEXP           S             15  0 DIM(21)                                            FRAIMP
     D*cPEXE           S             15  0 DIM(21)                                            FRAIMP
     D cPLIM           S             15  0 DIM(23)                                            FRAIMP
     D cPEXP           S             15  0 DIM(23)                                            FRAIMP
     D cPEXE           S             15  0 DIM(23)                                            FRAIMP
 
     D*tPLIM           S             15  0 DIM(21)                                            FRAIMP
     D*tPEXP           S             15  0 DIM(21)                                            FRAIMP
     D*tPEXE           S             15  0 DIM(21)                                            FRAIMP
     D tPLIM           S             15  0 DIM(23)                                            FRAIMP
     D tPEXP           S             15  0 DIM(23)                                            FRAIMP
     D tPEXE           S             15  0 DIM(23)                                            FRAIMP
 
 
     D  MEINSTGLCAT    DS
     D  MEINST                 1     10
     D  MEGLCAT               11     15
 
 
     D                 DS
     D  YYMMDD                 1     10
     D  YY                     3      4
     D  MM                     6      7
     D  DD                     9     10
 
 
     IGPMLXPD0
     I                                          MECNCD        L3
     I                                          MECUSTNAME    L2
     I                                          MELIMDEF      L1
 
      * Change of country
 
     C   L3              Z-ADD     99            LINENO
     C   L3              Z-ADD     0             cPLIM
     C   L3              Z-ADD     0             cPEXP
     C   L3              Z-ADD     0             cPEXE
 
      * Change of customer
 
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
 
     C   L1              Z-ADD     0             PLIM
     C   L1              Z-ADD     0             PEXP
     C   L1              Z-ADD     0             PEXE
 
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
 
      * Report country totals
     CL3 88              EXSR      REPORT_CTYTOT
     CL3 88              SETOFF                                       88
 
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
 
      * Cpty Exposure in USD
 
     C                   ADD       MEPEXPUSD     PEXP(#I)
 
      * Cpty Limit in USD
 
     C                   MOVEL     'TOTAL'       MEGLCAT
     C                   Z-ADD     1             #I
     C     MEINSTGLCAT   LOOKUP    INSTRGLC(#I)                           99
     C                   IF        MELIMTUSD > 0
     C                   Z-ADD     MELIMTUSD     PLIM(#I)
     C                   ENDIF
 
      * Cpty Exposure in USD
      * Cpty Excess in USD
 
     C                   ADD       MEPEXPUSD     PEXP(#I)
     C     PEXP(#I)      SUB       PLIM(#I)      PEXE(#I)               99
     C   99              Z-ADD     0             PEXE(#I)
     C                   ENDIF
 
     C                   SETON                                        88
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_EXPOS  BEGSR
 
     C     PLIM(1)       COMP      0                                  2121
     C  N21PEXP(1)       COMP      0                                  2121
     C  N21PEXE(1)       COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21
 
     C     PLIM(2)       COMP      0                                  2222
     C  N22PEXP(2)       COMP      0                                  2222
     C  N22PEXE(2)       COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22
 
     C     PLIM(3)       COMP      0                                  2323
     C  N23PEXP(3)       COMP      0                                  2323
     C  N23PEXE(3)       COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23
 
     C     PLIM(4)       COMP      0                                  2424
     C  N24PEXP(4)       COMP      0                                  2424
     C  N24PEXE(4)       COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24
 
     C     PLIM(5)       COMP      0                                  2525
     C  N25PEXP(5)       COMP      0                                  2525
     C  N25PEXE(5)       COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25
 
     C     PLIM(6)       COMP      0                                  2626
     C  N26PEXP(6)       COMP      0                                  2626
     C  N26PEXE(6)       COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26
 
     C     PLIM(7)       COMP      0                                  2727
     C  N27PEXP(7)       COMP      0                                  2727
     C  N27PEXE(7)       COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27
 
     C     PLIM(8)       COMP      0                                  2828
     C  N28PEXP(8)       COMP      0                                  2828
     C  N28PEXE(8)       COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28
 
     C     PLIM(9)       COMP      0                                  2929
     C  N29PEXP(9)       COMP      0                                  2929
     C  N29PEXE(9)       COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29
 
     C     PLIM(10)      COMP      0                                  3030
     C  N30PEXP(10)      COMP      0                                  3030
     C  N30PEXE(10)      COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30
 
     C     PLIM(11)      COMP      0                                  3131
     C  N31PEXP(11)      COMP      0                                  3131
     C  N31PEXE(11)      COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31
 
     C     PLIM(12)      COMP      0                                  3232
     C  N32PEXP(12)      COMP      0                                  3232
     C  N32PEXE(12)      COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32
 
     C     PLIM(13)      COMP      0                                  3333
     C  N33PEXP(13)      COMP      0                                  3333
     C  N33PEXE(13)      COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33
 
     C     PLIM(14)      COMP      0                                  3434
     C  N34PEXP(14)      COMP      0                                  3434
     C  N34PEXE(14)      COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34
 
     C     PLIM(15)      COMP      0                                  3535
     C  N35PEXP(15)      COMP      0                                  3535
     C  N35PEXE(15)      COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35
 
     C     PLIM(16)      COMP      0                                  3636
     C  N36PEXP(16)      COMP      0                                  3636
     C  N36PEXE(16)      COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36
 
     C     PLIM(17)      COMP      0                                  3737
     C  N37PEXP(17)      COMP      0                                  3737
     C  N37PEXE(17)      COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
 
     C     PLIM(18)      COMP      0                                  3838
     C  N38PEXP(18)      COMP      0                                  3838
     C  N38PEXE(18)      COMP      0                                  3838
     C   38GLCAT(18)     COMP      'TOTAL'                                38
 
     C     PLIM(19)      COMP      0                                  3939
     C  N39PEXP(19)      COMP      0                                  3939
     C  N39PEXE(19)      COMP      0                                  3939
     C   39GLCAT(19)     COMP      'TOTAL'                                39
                                                                                              NADC02
     C     PLIM(20)      COMP      0                                  4040                    NADC02
     C  N40PEXP(20)      COMP      0                                  4040                    NADC02
     C  N40PEXE(20)      COMP      0                                  4040                    NADC02
     C   40GLCAT(20)     COMP      'TOTAL'                                40                  NADC02
                                                                                              NADC02
     C     PLIM(21)      COMP      0                                  4141                    NADC02
     C  N41PEXP(21)      COMP      0                                  4141                    NADC02
     C  N41PEXE(21)      COMP      0                                  4141                    NADC02
     C   41GLCAT(21)     COMP      'TOTAL'                                41                  NADC02
                                                                                              FRAIMP
     C     PLIM(22)      COMP      0                                  4242                    FRAIMP
     C  N42PEXP(22)      COMP      0                                  4242                    FRAIMP
     C  N42PEXE(22)      COMP      0                                  4242                    FRAIMP
     C   42GLCAT(22)     COMP      'TOTAL'                                42                  FRAIMP
                                                                                              FRAIMP
     C     PLIM(23)      COMP      0                                  4343                    FRAIMP
     C  N43PEXP(23)      COMP      0                                  4343                    FRAIMP
     C  N43PEXE(23)      COMP      0                                  4343                    FRAIMP
     C   43GLCAT(23)     COMP      'TOTAL'                                43                  FRAIMP
 
     C     PEXP(1)       COMP      0                                  5151
     C     PEXP(2)       COMP      0                                  5252
     C     PEXP(3)       COMP      0                                  5353
     C     PEXP(4)       COMP      0                                  5454
     C     PEXP(5)       COMP      0                                  5555
     C     PEXP(6)       COMP      0                                  5656
     C     PEXP(7)       COMP      0                                  5757
     C     PEXP(8)       COMP      0                                  5858
     C     PEXP(9)       COMP      0                                  5959
     C     PEXP(10)      COMP      0                                  6060
     C     PEXP(11)      COMP      0                                  6161
     C     PEXP(12)      COMP      0                                  6262
     C     PEXP(13)      COMP      0                                  6363
     C     PEXP(14)      COMP      0                                  6464
     C     PEXP(15)      COMP      0                                  6565
     C     PEXP(16)      COMP      0                                  6666
     C     PEXP(17)      COMP      0                                  6767
     C     PEXP(18)      COMP      0                                  6868
     C     PEXP(19)      COMP      0                                  6969
     C     PEXP(20)      COMP      0                                  7070                    NADC02
     C     PEXP(21)      COMP      0                                  7171                    NADC02
     C     PEXP(22)      COMP      0                                  7272                    FRAIMP
     C     PEXP(23)      COMP      0                                  7373                    FRAIMP
 
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
     C   38              SETON                                        68
     C   39              SETON                                        69
     C   40              SETON                                        70                      NADC02
     C   41              SETON                                        71                      NADC02
     C   42              SETON                                        72                      FRAIMP
     C   43              SETON                                        73                      FRAIMP
 
      * Limit, exposure, excess
 
     C                   XFOOT     PLIM          TOTLIM           15 0
     C*******************SUB       PLIM(18)      TOTLIM                         FX total      NADC02
     C*********          SUB       PLIM(20)      TOTLIM                       FX total NADC02 FRAIMP
     C                   SUB       PLIM(22)      TOTLIM                         FX total      FRAIMP
     C                   XFOOT     PEXP          TOTEXP           15 0
     C                   DIV       2             TOTEXP
     C*******************SUB       PEXP(18)      TOTEXP                         FX total      NADC02
     C*********          SUB       PEXP(20)      TOTEXP                       FX total NADC02 FRAIMP
     C                   SUB       PEXP(22)      TOTEXP                         FX total      FRAIMP
     C                   XFOOT     PEXE          TOTEXE           15 0
     C*******************SUB       PEXE(18)      TOTEXE                         FX total      NADC02
     C*********          SUB       PEXE(20)      TOTEXE                       FX total NADC02 FRAIMP
     C                   SUB       PEXE(22)      TOTEXE                         FX total      FRAIMP
      * Expiry date
     C                   IF        YYMMDD <> *BLANK
     C                   EVAL      REXPDATE = DD + '-' + MM + '-' + YY
     C                   ELSE
     C                   MOVEL     *BLANK        REXPDATE          8
     C                   ENDIF
      * Output
     C                   Z-ADD     3             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL
 
     C                   ADD       PLIM          cPLIM
     C                   ADD       PEXP          cPEXP
     C                   ADD       PEXE          cPEXE
 
     C                   ADD       PLIM          tPLIM
     C                   ADD       PEXP          tPEXP
     C                   ADD       PEXE          tPEXE
      * Record if excess
     C                   IF        I#EXCES <> 'Y'
     C                   IF        TOTEXE <> 0
     C*******************          OR PEXE(18) <> 0                                           NADC02
     C*********                    OR PEXE(20) <> 0                                    NADC02 FRAIMP
     C                             OR PEXE(22) <> 0                                           FRAIMP
     C                   WRITE     GPMLZPD0
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C     CHECK_EXCESS  BEGSR
     C                   IF        I#EXCES = 'Y'
     C     GPMLZPK       KLIST
     C                   KFLD                    MECNCD
     C                   KFLD                    MECUSTNAME
     C     GPMLZPK       CHAIN     GPMLZPD0                           99
     C                   ENDIF
     C                   IF        I#EXCES <> 'Y'
     C                             OR I#EXCES = 'Y' AND *IN99 = *OFF
     C                   MOVE      'Y'           Do_output         1
     C                   ELSE
     C                   MOVE      'N'           Do_output
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C     REPORT_CTYTOT BEGSR
 
     C     cPLIM(1)      COMP      0                                  2121
     C  N21cPEXP(1)      COMP      0                                  2121
     C  N21cPEXE(1)      COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21
 
     C     cPLIM(2)      COMP      0                                  2222
     C  N22cPEXP(2)      COMP      0                                  2222
     C  N22cPEXE(2)      COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22
 
     C     cPLIM(3)      COMP      0                                  2323
     C  N23cPEXP(3)      COMP      0                                  2323
     C  N23cPEXE(3)      COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23
 
     C     cPLIM(4)      COMP      0                                  2424
     C  N24cPEXP(4)      COMP      0                                  2424
     C  N24cPEXE(4)      COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24
 
     C     cPLIM(5)      COMP      0                                  2525
     C  N25cPEXP(5)      COMP      0                                  2525
     C  N25cPEXE(5)      COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25
 
     C     cPLIM(6)      COMP      0                                  2626
     C  N26cPEXP(6)      COMP      0                                  2626
     C  N26cPEXE(6)      COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26
 
     C     cPLIM(7)      COMP      0                                  2727
     C  N27cPEXP(7)      COMP      0                                  2727
     C  N27cPEXE(7)      COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27
 
     C     cPLIM(8)      COMP      0                                  2828
     C  N28cPEXP(8)      COMP      0                                  2828
     C  N28cPEXE(8)      COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28
 
     C     cPLIM(9)      COMP      0                                  2929
     C  N29cPEXP(9)      COMP      0                                  2929
     C  N29cPEXE(9)      COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29
 
     C     cPLIM(10)     COMP      0                                  3030
     C  N30cPEXP(10)     COMP      0                                  3030
     C  N30cPEXE(10)     COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30
 
     C     cPLIM(11)     COMP      0                                  3131
     C  N31cPEXP(11)     COMP      0                                  3131
     C  N31cPEXE(11)     COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31
 
     C     cPLIM(12)     COMP      0                                  3232
     C  N32cPEXP(12)     COMP      0                                  3232
     C  N32cPEXE(12)     COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32
 
     C     cPLIM(13)     COMP      0                                  3333
     C  N33cPEXP(13)     COMP      0                                  3333
     C  N33cPEXE(13)     COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33
 
     C     cPLIM(14)     COMP      0                                  3434
     C  N34cPEXP(14)     COMP      0                                  3434
     C  N34cPEXE(14)     COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34
 
     C     cPLIM(15)     COMP      0                                  3535
     C  N35cPEXP(15)     COMP      0                                  3535
     C  N35cPEXE(15)     COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35
 
     C     cPLIM(16)     COMP      0                                  3636
     C  N36cPEXP(16)     COMP      0                                  3636
     C  N36cPEXE(16)     COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36
 
     C     cPLIM(17)     COMP      0                                  3737
     C  N37cPEXP(17)     COMP      0                                  3737
     C  N37cPEXE(17)     COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
 
     C     cPLIM(18)     COMP      0                                  3838
     C  N38cPEXP(18)     COMP      0                                  3838
     C  N38cPEXE(18)     COMP      0                                  3838
     C   38GLCAT(18)     COMP      'TOTAL'                                38
 
     C     cPLIM(19)     COMP      0                                  3939
     C  N39cPEXP(19)     COMP      0                                  3939
     C  N39cPEXE(19)     COMP      0                                  3939
     C   39GLCAT(19)     COMP      'TOTAL'                                39
                                                                                              NADC02
     C     cPLIM(20)     COMP      0                                  4040                    NADC02
     C  N40cPEXP(20)     COMP      0                                  4040                    NADC02
     C  N40cPEXE(20)     COMP      0                                  4040                    NADC02
     C   40GLCAT(20)     COMP      'TOTAL'                                40                  NADC02
                                                                                              NADC02
     C     cPLIM(21)     COMP      0                                  4141                    NADC02
     C  N41cPEXP(21)     COMP      0                                  4141                    NADC02
     C  N41cPEXE(21)     COMP      0                                  4141                    NADC02
     C   41GLCAT(21)     COMP      'TOTAL'                                41                  NADC02
                                                                                              FRAIMP
     C     cPLIM(22)     COMP      0                                  4242                    FRAIMP
     C  N42cPEXP(22)     COMP      0                                  4242                    FRAIMP
     C  N42cPEXE(22)     COMP      0                                  4242                    FRAIMP
     C   42GLCAT(22)     COMP      'TOTAL'                                42                  FRAIMP
                                                                                              FRAIMP
     C     cPLIM(23)     COMP      0                                  4343                    FRAIMP
     C  N43cPEXP(23)     COMP      0                                  4343                    FRAIMP
     C  N43cPEXE(23)     COMP      0                                  4343                    FRAIMP
     C   43GLCAT(23)     COMP      'TOTAL'                                43                  FRAIMP
 
     C     cPEXP(1)      COMP      0                                  5151
     C     cPEXP(2)      COMP      0                                  5252
     C     cPEXP(3)      COMP      0                                  5353
     C     cPEXP(4)      COMP      0                                  5454
     C     cPEXP(5)      COMP      0                                  5555
     C     cPEXP(6)      COMP      0                                  5656
     C     cPEXP(7)      COMP      0                                  5757
     C     cPEXP(8)      COMP      0                                  5858
     C     cPEXP(9)      COMP      0                                  5959
     C     cPEXP(10)     COMP      0                                  6060
     C     cPEXP(11)     COMP      0                                  6161
     C     cPEXP(12)     COMP      0                                  6262
     C     cPEXP(13)     COMP      0                                  6363
     C     cPEXP(14)     COMP      0                                  6464
     C     cPEXP(15)     COMP      0                                  6565
     C     cPEXP(16)     COMP      0                                  6666
     C     cPEXP(17)     COMP      0                                  6767
     C     cPEXP(18)     COMP      0                                  6868
     C     cPEXP(19)     COMP      0                                  6969
     C     cPEXP(20)     COMP      0                                  7070                    NADC02
     C     cPEXP(21)     COMP      0                                  7171                    NADC02
     C     cPEXP(22)     COMP      0                                  7272                    FRAIMP
     C     cPEXP(23)     COMP      0                                  7373                    FRAIMP
 
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
     C   38              SETON                                        68
     C   39              SETON                                        69
     C   40              SETON                                        70                      NADC02
     C   41              SETON                                        71                      NADC02
     C   42              SETON                                        72                      FRAIMP
     C   43              SETON                                        73                      FRAIMP
 
     C                   XFOOT     cPLIM         TOTLIM
     C*******************SUB       cPLIM(18)     TOTLIM                         FX total      NADC02
     C*********          SUB       cPLIM(20)     TOTLIM                      FX total  NADC02 FRAIMP
     C                   SUB       cPLIM(22)     TOTLIM                         FX total      FRAIMP
     C                   XFOOT     cPEXP         TOTEXP
     C                   DIV       2             TOTEXP
     C*******************SUB       cPEXP(18)     TOTEXP                         FX total      NADC02
     C*********          SUB       cPEXP(20)     TOTEXP                      FX total  NADC02 FRAIMP
     C                   SUB       cPEXP(22)     TOTEXP                         FX total      FRAIMP
     C                   XFOOT     cPEXE         TOTEXE
     C*******************SUB       cPEXE(18)     TOTEXE                         FX total      NADC02
     C*********          SUB       cPEXE(20)     TOTEXE                      FX total  NADC02 FRAIMP
     C                   SUB       cPEXE(22)     TOTEXE                         FX total      FRAIMP
 
     C                   Z-ADD     5             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    CTYTOTAL
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_FINTOT BEGSR
 
     C     tPLIM(1)      COMP      0                                  2121
     C  N21tPEXP(1)      COMP      0                                  2121
     C  N21tPEXE(1)      COMP      0                                  2121
     C   21GLCAT(1)      COMP      'TOTAL'                                21
 
     C     tPLIM(2)      COMP      0                                  2222
     C  N22tPEXP(2)      COMP      0                                  2222
     C  N22tPEXE(2)      COMP      0                                  2222
     C   22GLCAT(2)      COMP      'TOTAL'                                22
 
     C     tPLIM(3)      COMP      0                                  2323
     C  N23tPEXP(3)      COMP      0                                  2323
     C  N23tPEXE(3)      COMP      0                                  2323
     C   23GLCAT(3)      COMP      'TOTAL'                                23
 
     C     tPLIM(4)      COMP      0                                  2424
     C  N24tPEXP(4)      COMP      0                                  2424
     C  N24tPEXE(4)      COMP      0                                  2424
     C   24GLCAT(4)      COMP      'TOTAL'                                24
 
     C     tPLIM(5)      COMP      0                                  2525
     C  N25tPEXP(5)      COMP      0                                  2525
     C  N25tPEXE(5)      COMP      0                                  2525
     C   25GLCAT(5)      COMP      'TOTAL'                                25
 
     C     tPLIM(6)      COMP      0                                  2626
     C  N26tPEXP(6)      COMP      0                                  2626
     C  N26tPEXE(6)      COMP      0                                  2626
     C   26GLCAT(6)      COMP      'TOTAL'                                26
 
     C     tPLIM(7)      COMP      0                                  2727
     C  N27tPEXP(7)      COMP      0                                  2727
     C  N27tPEXE(7)      COMP      0                                  2727
     C   27GLCAT(7)      COMP      'TOTAL'                                27
 
     C     tPLIM(8)      COMP      0                                  2828
     C  N28tPEXP(8)      COMP      0                                  2828
     C  N28tPEXE(8)      COMP      0                                  2828
     C   28GLCAT(8)      COMP      'TOTAL'                                28
 
     C     tPLIM(9)      COMP      0                                  2929
     C  N29tPEXP(9)      COMP      0                                  2929
     C  N29tPEXE(9)      COMP      0                                  2929
     C   29GLCAT(9)      COMP      'TOTAL'                                29
 
     C     tPLIM(10)     COMP      0                                  3030
     C  N30tPEXP(10)     COMP      0                                  3030
     C  N30tPEXE(10)     COMP      0                                  3030
     C   30GLCAT(10)     COMP      'TOTAL'                                30
 
     C     tPLIM(11)     COMP      0                                  3131
     C  N31tPEXP(11)     COMP      0                                  3131
     C  N31tPEXE(11)     COMP      0                                  3131
     C   31GLCAT(11)     COMP      'TOTAL'                                31
 
     C     tPLIM(12)     COMP      0                                  3232
     C  N32tPEXP(12)     COMP      0                                  3232
     C  N32tPEXE(12)     COMP      0                                  3232
     C   32GLCAT(12)     COMP      'TOTAL'                                32
 
     C     tPLIM(13)     COMP      0                                  3333
     C  N33tPEXP(13)     COMP      0                                  3333
     C  N33tPEXE(13)     COMP      0                                  3333
     C   33GLCAT(13)     COMP      'TOTAL'                                33
 
     C     tPLIM(14)     COMP      0                                  3434
     C  N34tPEXP(14)     COMP      0                                  3434
     C  N34tPEXE(14)     COMP      0                                  3434
     C   34GLCAT(14)     COMP      'TOTAL'                                34
 
     C     tPLIM(15)     COMP      0                                  3535
     C  N35tPEXP(15)     COMP      0                                  3535
     C  N35tPEXE(15)     COMP      0                                  3535
     C   35GLCAT(15)     COMP      'TOTAL'                                35
 
     C     tPLIM(16)     COMP      0                                  3636
     C  N36tPEXP(16)     COMP      0                                  3636
     C  N36tPEXE(16)     COMP      0                                  3636
     C   36GLCAT(16)     COMP      'TOTAL'                                36
 
     C     tPLIM(17)     COMP      0                                  3737
     C  N37tPEXP(17)     COMP      0                                  3737
     C  N37tPEXE(17)     COMP      0                                  3737
     C   37GLCAT(17)     COMP      'TOTAL'                                37
 
     C     tPLIM(18)     COMP      0                                  3838
     C  N38tPEXP(18)     COMP      0                                  3838
     C  N38tPEXE(18)     COMP      0                                  3838
     C   38GLCAT(18)     COMP      'TOTAL'                                38
 
     C     tPLIM(19)     COMP      0                                  3939
     C  N39tPEXP(19)     COMP      0                                  3939
     C  N39tPEXE(19)     COMP      0                                  3939
     C   39GLCAT(19)     COMP      'TOTAL'                                39
                                                                                              NADC02
     C     tPLIM(20)     COMP      0                                  4040                    NADC02
     C  N40tPEXP(20)     COMP      0                                  4040                    NADC02
     C  N40tPEXE(20)     COMP      0                                  4040                    NADC02
     C   40GLCAT(20)     COMP      'TOTAL'                                40                  NADC02
                                                                                              NADC02
     C     tPLIM(21)     COMP      0                                  4141                    NADC02
     C  N41tPEXP(21)     COMP      0                                  4141                    NADC02
     C  N41tPEXE(21)     COMP      0                                  4141                    NADC02
     C   41GLCAT(21)     COMP      'TOTAL'                                41                  NADC02
                                                                                              FRAIMP
     C     tPLIM(22)     COMP      0                                  4242                    FRAIMP
     C  N42tPEXP(22)     COMP      0                                  4242                    FRAIMP
     C  N42tPEXE(22)     COMP      0                                  4242                    FRAIMP
     C   42GLCAT(22)     COMP      'TOTAL'                                42                  FRAIMP
                                                                                              FRAIMP
     C     tPLIM(23)     COMP      0                                  4343                    FRAIMP
     C  N43tPEXP(23)     COMP      0                                  4343                    FRAIMP
     C  N43tPEXE(23)     COMP      0                                  4343                    FRAIMP
     C   43GLCAT(23)     COMP      'TOTAL'                                43                  FRAIMP
 
     C     tPEXP(1)      COMP      0                                  5151
     C     tPEXP(2)      COMP      0                                  5252
     C     tPEXP(3)      COMP      0                                  5353
     C     tPEXP(4)      COMP      0                                  5454
     C     tPEXP(5)      COMP      0                                  5555
     C     tPEXP(6)      COMP      0                                  5656
     C     tPEXP(7)      COMP      0                                  5757
     C     tPEXP(8)      COMP      0                                  5858
     C     tPEXP(9)      COMP      0                                  5959
     C     tPEXP(10)     COMP      0                                  6060
     C     tPEXP(11)     COMP      0                                  6161
     C     tPEXP(12)     COMP      0                                  6262
     C     tPEXP(13)     COMP      0                                  6363
     C     tPEXP(14)     COMP      0                                  6464
     C     tPEXP(15)     COMP      0                                  6565
     C     tPEXP(16)     COMP      0                                  6666
     C     tPEXP(17)     COMP      0                                  6767
     C     tPEXP(18)     COMP      0                                  6868
     C     tPEXP(19)     COMP      0                                  6969
     C     tPEXP(20)     COMP      0                                  7070                    NADC02
     C     tPEXP(21)     COMP      0                                  7171                    NADC02
     C     tPEXP(22)     COMP      0                                  7272                    FRAIMP
     C     tPEXP(23)     COMP      0                                  7373                    FRAIMP
 
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
     C   38              SETON                                        68
     C   39              SETON                                        69
     C   40              SETON                                        70                      NADC02
     C   41              SETON                                        71                      NADC02
     C   42              SETON                                        72                      FRAIMP
     C   43              SETON                                        73                      FRAIMP
 
     C                   XFOOT     tPLIM         TOTLIM
     C*******************SUB       tPLIM(18)     TOTLIM                         FX total      NADC02
     C*********          SUB       tPLIM(20)     TOTLIM                       FX total NADC02 FRAIMP
     C                   SUB       tPLIM(22)     TOTLIM                         FX total      FRAIMP
     C                   XFOOT     tPEXP         TOTEXP
     C                   DIV       2             TOTEXP
     C*******************SUB       tPEXP(18)     TOTEXP                         FX total      NADC02
     C*********          SUB       tPEXP(20)     TOTEXP                       FX total NADC02 FRAIMP
     C                   SUB       tPEXP(22)     TOTEXP                         FX total      FRAIMP
     C                   XFOOT     tPEXE         TOTEXE
     C*******************SUB       tPEXE(18)     TOTEXE                         FX total      NADC02
     C*********          SUB       tPEXE(20)     TOTEXE                       FX total NADC02 FRAIMP
     C                   SUB       tPEXE(22)     TOTEXE                         FX total      FRAIMP
 
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
      *FX
     C                   WHEN      INSTR(#I) = 'GLOBFX'
     C                   MOVE      'TOTAL'       INSTRGLC(#J)
     C                   ADD       1             #J
     C                   MOVEL     INSTR(#I)     INSTRGLC(#J)
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
     OGPRPTMZPP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMZP '
     O                                           80 'COUNTERPARTY EXPOSURE +
     O                                              v LIMITS REPORT'
     O                     85                    89 ' - EXCESS'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           12 'COUNTERPARTY'
     O                                           29 'LIMIT'
     O                                           37 'EXPIRY'
     O                       INST(1)             63
     O                       INST(2)             78
     O                       INST(3)             93
     O                       INST(4)            108
     O                       INST(5)            123
     O                       INST(6)            138
     O                       INST(7)            153
     O                       INST(8)            168
     O                       INST(9)            183
     O                       INST(10)           198
     O                       INST(11)           213
     O                       INST(12)           228
     O                       INST(13)           243
     O                       INST(14)           258
     O                       INST(15)           273
     O                       INST(16)           288
     O                       INST(17)           303
     O                       INST(18)           318                                           NADC02
     O                       INST(19)           333                                           NADC02
     O                                           47 '|'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O*********                                 347 'T O T A L  '                      NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 'T O T A L  '                             FRAIMP
     O                       INST(20)           348                                           FRAIMP
     O                       INST(21)           363                                           FRAIMP
     O*********              INST(20)           364                                    NADC02 FRAIMP
     O*********              INST(21)           378                                    NADC02 FRAIMP
     O                       INST(22)           394                                           FRAIMP
     O                       INST(23)           408                                           FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   317 'T O T A L  '                             NADC02
     O***********************INST(18)           334                                           NADC02
     O***********************INST(19)           348                                           NADC02
     O***********************                   348 '|'                                       NADC02
     O          E            PAGEHEAD    1
     O                                           37 ' DATE '
     O                       GLCAT(1)            58
     O                       GLCAT(2)            73
     O                       GLCAT(3)            88
     O                       GLCAT(4)           103
     O                       GLCAT(5)           118
     O                       GLCAT(6)           133
     O                       GLCAT(7)           148
     O                       GLCAT(8)           163
     O                       GLCAT(9)           178
     O                       GLCAT(10)          193
     O                       GLCAT(11)          208
     O                       GLCAT(12)          223
     O                       GLCAT(13)          238
     O                       GLCAT(14)          253
     O                       GLCAT(15)          268
     O                       GLCAT(16)          283
     O                       GLCAT(17)          298
     O                       GLCAT(18)          313                                           NADC02
     O                       GLCAT(19)          328                                           NADC02
     O                                           47 '|'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O*********              GLCAT(20)          359                                    NADC02 FRAIMP
     O*********              GLCAT(21)          373                                    NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 'T O T A L  '                             FRAIMP
     O                       GLCAT(20)          343                                           FRAIMP
     O                       GLCAT(21)          358                                           FRAIMP
     O                       GLCAT(22)          389                                           FRAIMP
     O                       GLCAT(23)          403                                           FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************GLCAT(18)          329                                           NADC02
     O***********************GLCAT(19)          343                                           NADC02
     O***********************                   348 '|'                                       NADC02
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
     O                                          348 '=========================='
     O                                          374 '=========================='              NADC02
     O                                          378 '===='                                    NADC02
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
     O                                          348 '=========================='
     O                                          374 '=========================='              NADC02
     O                                          378 '===='                                    NADC02
     O          E            STRC        1
     O               80                          26 '--------------------------'
     O               80                          52 '--------------------------'
     O              N80                          52 '|-----------------------'
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
     O                                          348 '--------------------------'
     O                                          374 '--------------------------'              NADC02
     O                                          378 '----'                                    NADC02
     O          E            TOTAL       1
     O               80      MECUSTNAME          28
     O                                           28 '   '
     O                       MELIMDEF            27
     O                       REXPDATE            37
     O*********************39PLIM(19)           347 '   ,   ,   ,   , 0 -'                    NADC02
     O*********************38PLIM(18)           332 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************TOTLIM             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            41PLIM(21)           377 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            40PLIM(20)           362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTLIM             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     43PLIM(23)           407 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     42PLIM(22)           392 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TOTLIM             377 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     41PLIM(21)           361 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     40PLIM(20)           346 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     39PLIM(19)           331 '   ,   ,   ,   , 0 -'                    NADC02
     O                     38PLIM(18)           316 '   ,   ,   ,   , 0 -'                    NADC02
     O                     37PLIM(17)           301 '   ,   ,   ,   , 0 -'
     O                     36PLIM(16)           286 '   ,   ,   ,   , 0 -'
     O                     35PLIM(15)           271 '   ,   ,   ,   , 0 -'
     O                     34PLIM(14)           256 '   ,   ,   ,   , 0 -'
     O                     33PLIM(13)           241 '   ,   ,   ,   , 0 -'
     O                     32PLIM(12)           226 '   ,   ,   ,   , 0 -'
     O                     31PLIM(11)           211 '   ,   ,   ,   , 0 -'
     O                     30PLIM(10)           196 '   ,   ,   ,   , 0 -'
     O                     29PLIM(9)            181 '   ,   ,   ,   , 0 -'
     O                     28PLIM(8)            166 '   ,   ,   ,   , 0 -'
     O                     27PLIM(7)            151 '   ,   ,   ,   , 0 -'
     O                     26PLIM(6)            136 '   ,   ,   ,   , 0 -'
     O                     25PLIM(5)            121 '   ,   ,   ,   , 0 -'
     O                     24PLIM(4)            106 '   ,   ,   ,   , 0 -'
     O                     23PLIM(3)             91 '   ,   ,   ,   , 0 -'
     O                     22PLIM(2)             76 '   ,   ,   ,   , 0 -'
     O                     21PLIM(1)             61 '   ,   ,   ,   , 0 -'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   348 '|'                                       NADC02
     O                                           47 '| LIMIT |'
     O          E            TOTAL       1
     O*********************69PEXP(19)           347 '   ,   ,   ,   , 0 -'                    NADC02
     O*********************68PEXP(18)           332 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************TOTEXP             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            71PEXP(21)           377 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            70PEXP(20)           362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     73PEXP(22)           407 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     72PEXP(22)           392 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TOTEXP             377 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     71PEXP(21)           361 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     70PEXP(20)           346 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     69PEXP(19)           331 '   ,   ,   ,   , 0 -'                    NADC02
     O                     68PEXP(18)           316 '   ,   ,   ,   , 0 -'                    NADC02
     O                     67PEXP(17)           301 '   ,   ,   ,   , 0 -'
     O                     66PEXP(16)           286 '   ,   ,   ,   , 0 -'
     O                     65PEXP(15)           271 '   ,   ,   ,   , 0 -'
     O                     64PEXP(14)           256 '   ,   ,   ,   , 0 -'
     O                     63PEXP(13)           241 '   ,   ,   ,   , 0 -'
     O                     62PEXP(12)           226 '   ,   ,   ,   , 0 -'
     O                     61PEXP(11)           211 '   ,   ,   ,   , 0 -'
     O                     60PEXP(10)           196 '   ,   ,   ,   , 0 -'
     O                     59PEXP(9)            181 '   ,   ,   ,   , 0 -'
     O                     58PEXP(8)            166 '   ,   ,   ,   , 0 -'
     O                     57PEXP(7)            151 '   ,   ,   ,   , 0 -'
     O                     56PEXP(6)            136 '   ,   ,   ,   , 0 -'
     O                     55PEXP(5)            121 '   ,   ,   ,   , 0 -'
     O                     54PEXP(4)            106 '   ,   ,   ,   , 0 -'
     O                     53PEXP(3)             91 '   ,   ,   ,   , 0 -'
     O                     52PEXP(2)             76 '   ,   ,   ,   , 0 -'
     O                     51PEXP(1)             61 '   ,   ,   ,   , 0 -'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   348 '|'                                       NADC02
     O                                           47 '| EXPOS |'
     O          E            TOTAL       1
     O*********************39PEXE(19)           347 '   ,   ,   ,   , 0 -'                    NADC02
     O*********************38PEXE(18)           332 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************TOTEXE             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            41PEXE(21)           377 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            40PEXE(20)           362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXE             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     43PEXE(23)           407 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     42PEXE(22)           392 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TOTEXE             377 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     41PEXE(21)           361 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     40PEXE(20)           346 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     39PEXE(19)           331 '   ,   ,   ,   , 0 -'                    NADC02
     O                     38PEXE(18)           316 '   ,   ,   ,   , 0 -'                    NADC02
     O                     37PEXE(17)           301 '   ,   ,   ,   , 0 -'
     O                     36PEXE(16)           286 '   ,   ,   ,   , 0 -'
     O                     35PEXE(15)           271 '   ,   ,   ,   , 0 -'
     O                     34PEXE(14)           256 '   ,   ,   ,   , 0 -'
     O                     33PEXE(13)           241 '   ,   ,   ,   , 0 -'
     O                     32PEXE(12)           226 '   ,   ,   ,   , 0 -'
     O                     31PEXE(11)           211 '   ,   ,   ,   , 0 -'
     O                     30PEXE(10)           196 '   ,   ,   ,   , 0 -'
     O                     29PEXE(9)            181 '   ,   ,   ,   , 0 -'
     O                     28PEXE(8)            166 '   ,   ,   ,   , 0 -'
     O                     27PEXE(7)            151 '   ,   ,   ,   , 0 -'
     O                     26PEXE(6)            136 '   ,   ,   ,   , 0 -'
     O                     25PEXE(5)            121 '   ,   ,   ,   , 0 -'
     O                     24PEXE(4)            106 '   ,   ,   ,   , 0 -'
     O                     23PEXE(3)             91 '   ,   ,   ,   , 0 -'
     O                     22PEXE(2)             76 '   ,   ,   ,   , 0 -'
     O                     21PEXE(1)             61 '   ,   ,   ,   , 0 -'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   348 '|'                                       NADC02
     O                                           47 '| EXCES |'
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
     O                                          348 '--------------------------'
     O                                          374 '--------------------------'              NADC02
     O                                          378 '----'                                    NADC02
     O          E            CTYTOTAL    1
     O                       MECNCDNAM           33
     O*********************39cPLIM(19)          347 '   ,   ,   ,   , 0 -'                    NADC02
     O*********************38cPLIM(18)          332 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************TOTLIM             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            41cPLIM(21)          377 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            40cPLIM(20)          362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTLIM             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     43cPLIM(23)          407 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     42cPLIM(22)          392 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TOTLIM             377 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     41cPLIM(21)          361 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     40cPLIM(20)          346 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     39cPLIM(19)          331 '   ,   ,   ,   , 0 -'                    NADC02
     O                     38cPLIM(18)          316 '   ,   ,   ,   , 0 -'                    NADC02
     O                     37cPLIM(17)          301 '   ,   ,   ,   , 0 -'
     O                     36cPLIM(16)          286 '   ,   ,   ,   , 0 -'
     O                     35cPLIM(15)          271 '   ,   ,   ,   , 0 -'
     O                     34cPLIM(14)          256 '   ,   ,   ,   , 0 -'
     O                     33cPLIM(13)          241 '   ,   ,   ,   , 0 -'
     O                     32cPLIM(12)          226 '   ,   ,   ,   , 0 -'
     O                     31cPLIM(11)          211 '   ,   ,   ,   , 0 -'
     O                     30cPLIM(10)          196 '   ,   ,   ,   , 0 -'
     O                     29cPLIM(9)           181 '   ,   ,   ,   , 0 -'
     O                     28cPLIM(8)           166 '   ,   ,   ,   , 0 -'
     O                     27cPLIM(7)           151 '   ,   ,   ,   , 0 -'
     O                     26cPLIM(6)           136 '   ,   ,   ,   , 0 -'
     O                     25cPLIM(5)           121 '   ,   ,   ,   , 0 -'
     O                     24cPLIM(4)           106 '   ,   ,   ,   , 0 -'
     O                     23cPLIM(3)            91 '   ,   ,   ,   , 0 -'
     O                     22cPLIM(2)            76 '   ,   ,   ,   , 0 -'
     O                     21cPLIM(1)            61 '   ,   ,   ,   , 0 -'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   348 '|'                                       NADC02
     O                                           47 '| LIMIT |'
     O          E            CTYTOTAL    1
     O                                           26 'C O U N T R Y   T O T A L '
     O*********************69cPEXP(19)          347 '   ,   ,   ,   , 0 -'                    NADC02
     O*********************68cPEXP(18)          332 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************TOTEXP             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            71cPEXP(21)          377 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            70cPEXP(20)          362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     73cPEXP(23)          407 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     72cPEXP(22)          392 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TOTEXP             377 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     71cPEXP(21)          361 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     70cPEXP(20)          346 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     69cPEXP(19)          331 '   ,   ,   ,   , 0 -'                    NADC02
     O                     68cPEXP(18)          316 '   ,   ,   ,   , 0 -'                    NADC02
     O                     67cPEXP(17)          301 '   ,   ,   ,   , 0 -'
     O                     66cPEXP(16)          286 '   ,   ,   ,   , 0 -'
     O                     65cPEXP(15)          271 '   ,   ,   ,   , 0 -'
     O                     64cPEXP(14)          256 '   ,   ,   ,   , 0 -'
     O                     63cPEXP(13)          241 '   ,   ,   ,   , 0 -'
     O                     62cPEXP(12)          226 '   ,   ,   ,   , 0 -'
     O                     61cPEXP(11)          211 '   ,   ,   ,   , 0 -'
     O                     60cPEXP(10)          196 '   ,   ,   ,   , 0 -'
     O                     59cPEXP(9)           181 '   ,   ,   ,   , 0 -'
     O                     58cPEXP(8)           166 '   ,   ,   ,   , 0 -'
     O                     57cPEXP(7)           151 '   ,   ,   ,   , 0 -'
     O                     56cPEXP(6)           136 '   ,   ,   ,   , 0 -'
     O                     55cPEXP(5)           121 '   ,   ,   ,   , 0 -'
     O                     54cPEXP(4)           106 '   ,   ,   ,   , 0 -'
     O                     53cPEXP(3)            91 '   ,   ,   ,   , 0 -'
     O                     52cPEXP(2)            76 '   ,   ,   ,   , 0 -'
     O                     51cPEXP(1)            61 '   ,   ,   ,   , 0 -'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   348 '|'                                       NADC02
     O                                           47 '| EXPOS |'
     O          E            CTYTOTAL    1
     O*********************39cPEXE(19)          347 '   ,   ,   ,   , 0 -'                    NADC02
     O*********************38cPEXE(18)          332 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************TOTEXE             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            41cPEXE(21)          377 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            40cPEXE(20)          362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXE             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     43cPEXE(23)          407 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     42cPEXE(22)          392 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TOTEXE             377 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     41cPEXE(21)          361 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     40cPEXE(20)          346 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     39cPEXE(19)          331 '   ,   ,   ,   , 0 -'                    NADC02
     O                     38cPEXE(18)          316 '   ,   ,   ,   , 0 -'                    NADC02
     O                     37cPEXE(17)          301 '   ,   ,   ,   , 0 -'
     O                     36cPEXE(16)          286 '   ,   ,   ,   , 0 -'
     O                     35cPEXE(15)          271 '   ,   ,   ,   , 0 -'
     O                     34cPEXE(14)          256 '   ,   ,   ,   , 0 -'
     O                     33cPEXE(13)          241 '   ,   ,   ,   , 0 -'
     O                     32cPEXE(12)          226 '   ,   ,   ,   , 0 -'
     O                     31cPEXE(11)          211 '   ,   ,   ,   , 0 -'
     O                     30cPEXE(10)          196 '   ,   ,   ,   , 0 -'
     O                     29cPEXE(9)           181 '   ,   ,   ,   , 0 -'
     O                     28cPEXE(8)           166 '   ,   ,   ,   , 0 -'
     O                     27cPEXE(7)           151 '   ,   ,   ,   , 0 -'
     O                     26cPEXE(6)           136 '   ,   ,   ,   , 0 -'
     O                     25cPEXE(5)           121 '   ,   ,   ,   , 0 -'
     O                     24cPEXE(4)           106 '   ,   ,   ,   , 0 -'
     O                     23cPEXE(3)            91 '   ,   ,   ,   , 0 -'
     O                     22cPEXE(2)            76 '   ,   ,   ,   , 0 -'
     O                     21cPEXE(1)            61 '   ,   ,   ,   , 0 -'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   348 '|'                                       NADC02
     O                                           47 '| EXCES |'
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
     O                                          348 '--------------------------'
     O                                          374 '--------------------------'              NADC02
     O                                          378 '----'                                    NADC02
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
     O                                          348 '--------------------------'
     O                                          374 '--------------------------'              NADC02
     O                                          378 '----'                                    NADC02
     O          E            FINTOTAL    1
     O                                           22 'G R A N D   T O T A L '
     O*********************39tPLIM(19)          347 '   ,   ,   ,   , 0 -'                    NADC02
     O*********************38tPLIM(18)          332 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************TOTLIM             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            41tPLIM(21)          377 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            40tPLIM(20)          362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTLIM             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     43tPLIM(23)          407 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     42tPLIM(22)          392 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TOTLIM             377 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     41tPLIM(21)          361 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     40tPLIM(20)          346 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     39tPLIM(19)          331 '   ,   ,   ,   , 0 -'                    NADC02
     O                     38tPLIM(18)          316 '   ,   ,   ,   , 0 -'                    NADC02
     O                     37tPLIM(17)          301 '   ,   ,   ,   , 0 -'
     O                     36tPLIM(16)          286 '   ,   ,   ,   , 0 -'
     O                     35tPLIM(15)          271 '   ,   ,   ,   , 0 -'
     O                     34tPLIM(14)          256 '   ,   ,   ,   , 0 -'
     O                     33tPLIM(13)          241 '   ,   ,   ,   , 0 -'
     O                     32tPLIM(12)          226 '   ,   ,   ,   , 0 -'
     O                     31tPLIM(11)          211 '   ,   ,   ,   , 0 -'
     O                     30tPLIM(10)          196 '   ,   ,   ,   , 0 -'
     O                     29tPLIM(9)           181 '   ,   ,   ,   , 0 -'
     O                     28tPLIM(8)           166 '   ,   ,   ,   , 0 -'
     O                     27tPLIM(7)           151 '   ,   ,   ,   , 0 -'
     O                     26tPLIM(6)           136 '   ,   ,   ,   , 0 -'
     O                     25tPLIM(5)           121 '   ,   ,   ,   , 0 -'
     O                     24tPLIM(4)           106 '   ,   ,   ,   , 0 -'
     O                     23tPLIM(3)            91 '   ,   ,   ,   , 0 -'
     O                     22tPLIM(2)            76 '   ,   ,   ,   , 0 -'
     O                     21tPLIM(1)            61 '   ,   ,   ,   , 0 -'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   348 '|'                                       NADC02
     O                                           47 '| LIMIT |'
     O          E            FINTOTAL    1
     O*********************69tPEXP(19)          347 '   ,   ,   ,   , 0 -'                    NADC02
     O*********************68tPEXP(18)          332 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************TOTEXP             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            71tPEXP(21)          377 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            70tPEXP(20)          362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXP             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     73tPEXP(22)          407 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     72tPEXP(22)          392 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TOTEXP             377 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     71tPEXP(21)          361 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     70tPEXP(20)          346 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     69tPEXP(19)          331 '   ,   ,   ,   , 0 -'                    NADC02
     O                     68tPEXP(18)          316 '   ,   ,   ,   , 0 -'                    NADC02
     O                     67tPEXP(17)          301 '   ,   ,   ,   , 0 -'
     O                     66tPEXP(16)          286 '   ,   ,   ,   , 0 -'
     O                     65tPEXP(15)          271 '   ,   ,   ,   , 0 -'
     O                     64tPEXP(14)          256 '   ,   ,   ,   , 0 -'
     O                     63tPEXP(13)          241 '   ,   ,   ,   , 0 -'
     O                     62tPEXP(12)          226 '   ,   ,   ,   , 0 -'
     O                     61tPEXP(11)          211 '   ,   ,   ,   , 0 -'
     O                     60tPEXP(10)          196 '   ,   ,   ,   , 0 -'
     O                     59tPEXP(9)           181 '   ,   ,   ,   , 0 -'
     O                     58tPEXP(8)           166 '   ,   ,   ,   , 0 -'
     O                     57tPEXP(7)           151 '   ,   ,   ,   , 0 -'
     O                     56tPEXP(6)           136 '   ,   ,   ,   , 0 -'
     O                     55tPEXP(5)           121 '   ,   ,   ,   , 0 -'
     O                     54tPEXP(4)           106 '   ,   ,   ,   , 0 -'
     O                     53tPEXP(3)            91 '   ,   ,   ,   , 0 -'
     O                     52tPEXP(2)            76 '   ,   ,   ,   , 0 -'
     O                     51tPEXP(1)            61 '   ,   ,   ,   , 0 -'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   348 '|'                                       NADC02
     O                                           47 '| EXPOS |'
     O          E            FINTOTAL    1
     O*********************39tPEXE(19)          347 '   ,   ,   ,   , 0 -'                    NADC02
     O*********************38tPEXE(18)          332 '   ,   ,   ,   , 0 -'                    NADC02
     O***********************TOTEXE             317 '   ,   ,   ,   , 0 -'                    NADC02
     O*********            41tPEXE(21)          377 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********            40tPEXE(20)          362 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O*********              TOTEXE             347 '   ,   ,   ,   , 0 -'             NADC02 FRAIMP
     O                     43tPEXE(23)          407 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     42tPEXE(22)          392 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                       TOTEXE             377 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     41tPEXE(21)          361 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     40tPEXE(20)          346 '   ,   ,   ,   , 0 -'                    FRAIMP
     O                     39tPEXE(19)          331 '   ,   ,   ,   , 0 -'                    NADC02
     O                     38tPEXE(18)          316 '   ,   ,   ,   , 0 -'                    NADC02
     O                     37tPEXE(17)          301 '   ,   ,   ,   , 0 -'
     O                     36tPEXE(16)          286 '   ,   ,   ,   , 0 -'
     O                     35tPEXE(15)          271 '   ,   ,   ,   , 0 -'
     O                     34tPEXE(14)          256 '   ,   ,   ,   , 0 -'
     O                     33tPEXE(13)          241 '   ,   ,   ,   , 0 -'
     O                     32tPEXE(12)          226 '   ,   ,   ,   , 0 -'
     O                     31tPEXE(11)          211 '   ,   ,   ,   , 0 -'
     O                     30tPEXE(10)          196 '   ,   ,   ,   , 0 -'
     O                     29tPEXE(9)           181 '   ,   ,   ,   , 0 -'
     O                     28tPEXE(8)           166 '   ,   ,   ,   , 0 -'
     O                     27tPEXE(7)           151 '   ,   ,   ,   , 0 -'
     O                     26tPEXE(6)           136 '   ,   ,   ,   , 0 -'
     O                     25tPEXE(5)           121 '   ,   ,   ,   , 0 -'
     O                     24tPEXE(4)           106 '   ,   ,   ,   , 0 -'
     O                     23tPEXE(3)            91 '   ,   ,   ,   , 0 -'
     O                     22tPEXE(2)            76 '   ,   ,   ,   , 0 -'
     O                     21tPEXE(1)            61 '   ,   ,   ,   , 0 -'
     O                                           77 '|'
     O                                          107 '|'                                       NADC02
     O*********                                 167 '|'                                NADC02 FRAIMP
     O*********                                 212 '|'                                NADC02 FRAIMP
     O*********                                 287 '|'                                NADC02 FRAIMP
     O*********                                 332 '|'                                NADC02 FRAIMP
     O*********                                 348 '|'                                NADC02 FRAIMP
     O                                          137 '|'                                       FRAIMP
     O                                          197 '|'                                       FRAIMP
     O                                          242 '|'                                       FRAIMP
     O                                          317 '|'                                       FRAIMP
     O                                          362 '|'                                       FRAIMP
     O                                          378 '|'                                       NADC02
     O***********************                   137 '|'                                       NADC02
     O***********************                   182 '|'                                       NADC02
     O***********************                   257 '|'                                       NADC02
     O***********************                   302 '|'                                       NADC02
     O***********************                   318 '|'                                       NADC02
     O***********************                   348 '|'                                       NADC02
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
     O                                          328 '--------------------------'
     O                                          348 '--------------------------'
     O                                          374 '--------------------------'              NADC02
     O                                          378 '----'                                    NADC02
