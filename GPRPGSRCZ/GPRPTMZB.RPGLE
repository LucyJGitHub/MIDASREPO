     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Report ML Exposure by Mturity Bucket')        *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMZB  - Report ML Exposure by Maturity Bucket            *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103             Date 25Jun19               *
      *  Prev Amend No. NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103 - Upgraded MPlus 121 NADC01 ML Extracts to FB 2.1     *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
 
     FGPMLEXL3  IP   E           K DISK
     FGZSDBANKPDIF   E             DISK
     FMRDSBDL1  IF   E           K DISK
     FGPRPTMZBP1O    F  132        PRINTER
     F                                     INFDS(SPOOLU)
 
      ** File Information Data Structure for GPRPTMZBP1
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
     D MATB            S              6    DIM(10)
 
     D iEXP            S             17  2 DIM(10)
     D ioEXP           S             15  0 DIM(10)
 
     D cEXP            S             17  2 DIM(10)
     D coEXP           S             15  0 DIM(10)
 
     D tEXP            S             17  2 DIM(10)
     D toEXP           S             15  0 DIM(10)
 
 
     IGPMLEXD0
     I                                          MEGLCAT       L2
     I                                          MEINST        L1
 
      * Change of GL category
 
     C   L2              Z-ADD     0             cEXP
 
      * Change of instrument
 
     C   L1              Z-ADD     0             iEXP
 
      * Accumulate exposure
 
     C                   EXSR      ACCUM_EXPOS
 
      * Report instrument total
     CL1                 EXSR      REPORT_INSTOT
     CL1                 Z-ADD     0             NoMAT_TOTAL
 
      * Report GL category totals
     CL2                 EXSR      REPORT_GLCTOT
 
      * Final totals
     CLR                 EXSR      REPORT_FINTOT
      *****************************************************************
     C     ACCUM_EXPOS   BEGSR
 
     C                   IF        MESMOD = 'MT'
     C                   EVAL      MEMATB = *BLANK
     C                   ENDIF
 
      * MATURITY
     C                   Z-ADD     1             #I
     C     MEMATB        LOOKUP    MATB(#I)                               99
     C   99              ADD       MEEXPINUSD    iEXP(#I)
     C  N99              ADD       MEEXPINUSD    iEXP(1)
     C                   IF        MEEDAT = 0
     C                   ADD       MEEXPINUSD    NoMAT_TOTAL      17 2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_INSTOT BEGSR
 
     C                   ADD       iEXP          cEXP
     C                   ADD       iEXP          tEXP
 
      * Securities
 
     C                   IF        MEINST = 'GLOBSE'
     C                   MOVE      'FIN'         MEINST
     C                   SUB       NoMAT_TOTAL   iEXP(1)
     C                   ENDIF
 
     C     iEXP(1)       COMP      0                                  2121
     C     iEXP(2)       COMP      0                                  2222
     C     iEXP(3)       COMP      0                                  2323
     C     iEXP(4)       COMP      0                                  2424
     C     iEXP(5)       COMP      0                                  2525
     C     iEXP(6)       COMP      0                                  2626
 
      * Exposure
 
     C                   Z-ADD(H)  iEXP          ioEXP
     C                   XFOOT     ioEXP         TOTEXP           15 0
      * Output
     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    INSTOTAL
 
      * Securities
 
     C                   IF        MEINST = 'GLOBSE FIN' AND NoMAT_TOTAL <> 0
     C                   Z-ADD     0             iEXP
     C                   Z-ADD     NoMAT_TOTAL   iEXP(1)              2121
     C                   SETOFF                                       222324
     C                   SETOFF                                       2526
      * Exposure
     C                   Z-ADD(H)  iEXP          ioEXP
     C                   XFOOT     ioEXP         TOTEXP           15 0
      * Output
     C                   MOVE      'UNT'         MEINST
     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    INSTOTAL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C     REPORT_GLCTOT BEGSR
 
     C     cEXP(1)       COMP      0                                  2121
     C     cEXP(2)       COMP      0                                  2222
     C     cEXP(3)       COMP      0                                  2323
     C     cEXP(4)       COMP      0                                  2424
     C     cEXP(5)       COMP      0                                  2525
     C     cEXP(6)       COMP      0                                  2626
 
      * Exposure
 
     C                   Z-ADD(H)  cEXP          coEXP
     C                   XFOOT     coEXP         TOTEXP           15 0
      * Output
     C                   Z-ADD     3             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    GLCTOTAL
 
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
     C     5             ADD       CHLINE        LINENO
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   READ      GZSDBANKPD                             H1
 
      * LOAD MATURITY BUCKETS
 
     C                   MOVEL     'ZZZZZZ'      MATB
     C                   Z-ADD     0             #I                4 0
     C     DSSCHD        SETLL     MRDSBDD0
     C     DSSCHD        READE     MRDSBDD0
     C                   DOW       NOT %EOF(MRDSBDL1)
     C                   ADD       1             #I
     C                   MOVEL     DSBCDE        MATB(#I)
     C     DSSCHD        READE     MRDSBDD0
     C                   ENDDO
 
     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0
 
     C                   ENDSR
      *****************************************************************
     OGPRPTMZBP1E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMZB '
     O                                           80 'EXPOSURE BY MATURITY +
     O                                              BUCKET REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                            3 'CAT'
     O                                           16 'INSTRUMENT'
     O                       MATB(1)             34
     O                       MATB(2)             49
     O                       MATB(3)             64
     O                       MATB(4)             79
     O                       MATB(5)             94
     O                       MATB(6)            109
     O                                          127 'T O T A L  '
     O          E            PAGEHEAD    1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O          E            INSTOTAL    1
     O                       MEGLCAT              5
     O                       MEINST              16
     O                       TOTEXP             126 '   ,   ,   ,   , 0 -'
     O                     26ioEXP(6)           111 '   ,   ,   ,   , 0 -'
     O                     25ioEXP(5)            96 '   ,   ,   ,   , 0 -'
     O                     24ioEXP(4)            81 '   ,   ,   ,   , 0 -'
     O                     23ioEXP(3)            66 '   ,   ,   ,   , 0 -'
     O                     22ioEXP(2)            51 '   ,   ,   ,   , 0 -'
     O                     21ioEXP(1)            36 '   ,   ,   ,   , 0 -'
     O          E            GLCTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O          E            GLCTOTAL    1
     O                       TOTEXP             126 '   ,   ,   ,   , 0 -'
     O                     26coEXP(6)           111 '   ,   ,   ,   , 0 -'
     O                     25coEXP(5)            96 '   ,   ,   ,   , 0 -'
     O                     24coEXP(4)            81 '   ,   ,   ,   , 0 -'
     O                     23coEXP(3)            66 '   ,   ,   ,   , 0 -'
     O                     22coEXP(2)            51 '   ,   ,   ,   , 0 -'
     O                     21coEXP(1)            36 '   ,   ,   ,   , 0 -'
     O          E            GLCTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O          E            FINTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O          E            FINTOTAL    1
     O                                           12 'GRAND  TOTAL'
     O                       TOTEXP             126 '   ,   ,   ,   , 0 -'
     O                       toEXP(6)           111 '   ,   ,   ,   , 0 -'
     O                       toEXP(5)            96 '   ,   ,   ,   , 0 -'
     O                       toEXP(4)            81 '   ,   ,   ,   , 0 -'
     O                       toEXP(3)            66 '   ,   ,   ,   , 0 -'
     O                       toEXP(2)            51 '   ,   ,   ,   , 0 -'
     O                       toEXP(1)            36 '   ,   ,   ,   , 0 -'
     O          E            FINTOTAL    1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
