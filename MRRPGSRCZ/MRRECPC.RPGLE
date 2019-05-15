     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Reconcile Principal/CUSN amounts')            *
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRRECPC - Reconcile Principal/CUSN amounts             *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CMR001   *CREATE   Date 16Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRTRAPL4  IP   E           K DISK
     FACCBR     IF   E           K DISK    INCLUDE(ACCNTABF)
     FMRRECPCP1 O    F  132        PRINTER USROPN
     F                                     INFDS(SPOOL1)
     FMRSLACPD  O    E             DISK
     FMRSLTRPD  O    E             DISK
 
     D POWER           S              8  0 DIM(8) CTDATA PERRCD(1)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** File Information Data Structure for report
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
 
     IMRTRAPD0      01
     I                                          EXBRCH        L2
     I                                          EXCYCD        L2
     I                                          EXPACC        L2
     I                                          EXCUSN        L1
     I                                          EXACSQ        L1
 
 
     C     I#SUB         IFEQ      EXSUB
     C     I#UNAL        ANDEQ     'N'
     C     EXPREF        ANDEQ     '3'
 
     C     I#SUB         OREQ      '*ALL'
     C     I#UNAL        ANDEQ     'N'
     C     EXPREF        ANDEQ     '3'
 
     C     I#SUB         OREQ      EXSUB
     C     I#UNAL        ANDEQ     'Y'
     C     EXPACC        ANDEQ     ' '
     C     EXPAMT        ANDNE     0
 
     C     I#SUB         OREQ      '*ALL'
     C     I#UNAL        ANDEQ     'Y'
     C     EXPACC        ANDEQ     ' '
     C     EXPAMT        ANDNE     0
     C                   EXSR      ACCUM_BAL
     C                   ENDIF
 
     CL1 10              EXSR      CHECK_BAL
     CL1                 SETOFF                                       10
     CL2 20              EXSR      ACD_TOTALS
     CL2                 SETOFF                                       20
     CLR 30              EXSR      FIN_TOTALS
      /SPACE 5
     C**********************************************************************************
     C     ACCUM_BAL     BEGSR
 
     C     EXSTAT        IFEQ      ' '
     C     EXDDAT        IFLT      BJRDNB
     C     *INU1         ANDEQ     '1'
     C     *INU1         OREQ      '0'
 
     C                   ADD       1             NoTransactions    5 0
     C                   ADD       1             NoAccntTrans      5 0
 
     C                   SETON                                        102030
 
     C                   MOVEL     EXBRCH        BRCA
     C                   MOVEL     EXCUSN        CNUM
     C                   MOVEL     EXCYCD        CCY
     C                   MOVEL     EXPACC        ACOD
     C                   MOVEL     EXACSQ        ACSQ
 
      * Write to Sub-Ledger Transaction file
 
     C     I#UNAL        IFEQ      'N'
     C                   MOVEL     EXSUB         SUB
     C                   MOVEL     EXTRID        TRID
     C                   Z-ADD     EXSEQ         SEQ
     C                   WRITE     MRSLTRD0
     C                   ENDIF
 
      * Accumulate deal amount
 
     C     EXPAMT        MULT      EXPSGN        DealAmount       18 3
     C                   ADD       DealAmount    AccntPrincipl    18 3
     C                   ADD       DealAmount    AcodePrincipl    18 3
 
      * Report deal
 
     C                   Z-ADD     EXMDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        MATDAT            7
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   EXCEPT    DEAL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CHECK_BAL     BEGSR
 
      * Access account
 
     C     ACCBRK        CHAIN     ACCNTABF                           99
     C   99              Z-ADD     *ZERO         LDBL
 
      * Get Account Currency Details
 
     C                   CALL      'MR000101'
     C                   PARM      CCY           I#CCY             3
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        AcctCDP           1 0
 
      * Edit account balance
 
     C     AcctCDP       ADD       1             CA                1 0
     C     LDBL          DIV       POWER(CA)     AccountBalance   18 3
 
      * Check account balance
 
     C     AccntPrincipl COMP      AccountBalance                     6060      *
     C     AccntPrincipl SUB       AccountBalanceDifference       18 3
     C                   ADD       Difference    SumDiffs         18 3
 
      * Report account balance
 
     C  N60              Z-ADD     3             CHLINE            3 0
     C   60              Z-ADD     5             CHLINE            3 0
     C                   EXSR      PAG
     C                   EXCEPT    ACC
     C  N60              ADD       1             ValidAccounts     5 0
     C  N60              ADD       NoAccntTrans  NoReconTrans      5 0
     C   60              ADD       1             InvalAccounts     5 0
 
      * Write to Sub-Ledger Account file
 
     C     I#UNAL        IFEQ      'N'
     C                   MOVEL     EXSUB         SUB
     C  N60              MOVEL     'Y'           BALR
     C   60              MOVEL     'N'           BALR
     C                   Z-ADD     AccountBalanceACBL
     C                   Z-ADD     AccntPrincipl VALT
     C                   Z-ADD     Difference    DIFF
     C                   Z-ADD     NoAccntTrans  NOTR
     C                   WRITE     MRSLACD0
     C                   ENDIF
 
     C                   Z-ADD     *zero         NoAccntTrans
     C                   Z-ADD     *zero         AccntPrincipl
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ACD_TOTALS    BEGSR
     C                   Z-ADD     2             CHLINE            3 0
     C                   EXSR      PAG
     C                   EXCEPT    ACDTOTALS
 
     C                   Z-ADD     *zero         AcodePrincipl
     C                   Z-ADD     99            LINENO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     FIN_TOTALS    BEGSR
     C                   Z-ADD     6             CHLINE            3 0
     C                   EXSR      PAG
     C                   EXCEPT    FINTOTALS
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C     PAGNUM        IFEQ      0
     C                   OPEN      MRRECPCP1
     C                   EXSR      RCF
     C                   ENDIF
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   EXCEPT    PAGEHEAD
     C     5             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
     C     RCF           BEGSR
     C                   EVAL      ZSnum = PSFNum1
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSErr
     C                   IF        ZSERR = 'Y'
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
     C                   MOVEL     'C'           CUBI
     C                   MOVEL     'P'           AMTT
     C     *ENTRY        PLIST
     C                   PARM                    I#SUB             4
     C                   PARM                    I#UNAL            1
     C     ACCBRK        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Output page headings
 
     C                   Z-ADD     99            LINENO
     C                   Z-ADD     0             PAGNUM            5 0
     C     I#UNAL        COMP      'Y'                                    66
     C                   ENDSR
     C**********************************************************************************
     OMRRECPCP1 E            PAGEHEAD         03
     O                                           23 'REFERENCE MRRECPCP1'
1437 O                       BJURPT              89
1438 O                                          104 'DATE'
1439 O                       BJMRDT             112
1440 O                                          122 'PAGE'
1441 O                       PAGNUM             127 '   0 '
     O          E            PAGEHEAD    1
     O                                           70 'PRINCIPAL RECONCILIATION '
     O                                           84 'REPORT - CUSN:'
     O                       I#SUB               89
     O                     66                   105 '* UNALLOCATED *'
     O          E            PAGEHEAD    1
     O                                            3 'BRC'
     O                                            7 'CCY'
     O                                           18 'A/C CODE'
     O                                           25 'CUST'
     O                                           28 'SQ'
     O                                           48 'AMOUNT  '
     O                                           57 'DEAL'
     O                                           65 'TYPE'
     O                                           70 'STYP'
     O                                           77 'CUST'
     O                                           85 'CCIT'
     O                                           90 'CLOC'
     O                                           96 'CIND'
     O                                          102 'CINT'
     O                                          109 'BK/NBK'
     O                                          116 'MATDAT'
     O          E            DEAL        1
     O                       EXBRCH               3
     O                                            4 '-'
     O                       EXCYCD               7
     O                                            8 '-'
     O                       EXPACC              18
     O                                           19 '-'
     O                       EXCUSN              25
     O                                           26 '-'
     O                       EXACSQ              28
     O                       EXTRID              72
     O                       DealAmount          49 '             0 .   -'
     O                       EXTRTY              67
     O                       EXTRST              72
     O                       EXCUSN              79
     O                       EXCCIT              84
     O                       EXCLOC              89
     O                       EXCIND              95
     O                       EXCINT             101
     O                       EXCBNK             107
     O                       MATDAT             116
     O                       EXMDT1             125
     O          E            ACC         1
     O                                           49 '--------------------'
     O          E            ACC         1
     O                                           17 'Account Balance: '
     O                       AccountBalance      49 '             0 .   -'
     O                     60                    75 '???'
     O          E          60ACC         1
     O                                           17 'Total Principal: '
     O                       AccntPrincipl       49 '             0 .   -'
     O          E          60ACC         1
     O                                           12 'Difference: '
     O                       Difference          49 '             0 .   -'
     O          E            ACC         1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O          E            ACDTOTALS   1
     O                       EXBRCH               3
     O                                            4 '-'
     O                       EXCYCD               7
     O                                            8 '-'
     O                       EXPACC              18
     O                                           29 'T O T A L:'
     O                       AcodePrincipl       49 '             0 .   -'
     O          E            ACDTOTALS   1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O          E            FINTOTALS   1
     O                                           23 'Number of Transactions:'
     O                       NoTransactions      40 '   0 '
     O          E            FINTOTALS   1
     O                                           21 'Number of Reconciled '
     O                                           34 'Transactions:'
     O                       NoReconTrans        40 '   0 '
     O          E            FINTOTALS   1
     O                                           24 'Valid Account Balances: '
     O                       ValidAccounts       40 '   0 '
     O          E            FINTOTALS   1
     O                                           26 'Invalid Account Balances: '
     O                       InvalAccounts       40 '   0 '
     O          E            FINTOTALS   1
     O                                           20 'Sum of Differences: '
     O                       SumDiffs            49 '             0 .   -'
     O          E            FINTOTALS   1
     O                                           74 '* END OF REPORT * '
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
