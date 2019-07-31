     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Sub-Ledger Accounts Report')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRSLACR - Sub-Ledger Accounts Report                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CMR001  *CREATE    Date 16Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRTRAPL9  UP   E           K DISK
     FMRSLACL1  IF   E           K DISK
     FSDACODL1  IF   E           K DISK
     FMRSLACL2  IF   E           K DISK    RENAME(MRSLACD0: MRSLACDX)
     FMRSLACRP1 O    F  132        PRINTER USROPN
     F                                     INFDS(SPOOL1)
 
 
     D DESCK           S              2    DIM(8) CTDATA PERRCD(1)
     D DESC            S             60    DIM(8) CTDATA PERRCD(1)
 
     D SLA             S             10  0 DIM(999)
     D SLT             S              2    DIM(999)
 
 
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
 
 
     IMRTRAPD0
     I                                          EXPACC        L1
 
      * Process live accounts
 
     C     EXSUB         IFEQ      'ACCT'
     C     EXSTAT        ANDNE     'M'
     C                   EXSR      REPORT_ACC
     C                   ENDIF
 
     CL1 10              EXSR      ACD_TOTALS
     CL1                 SETOFF                                       10
     CLR 20              EXSR      FIN_TOTALS
      /SPACE 5
     C**********************************************************************************
     C     REPORT_ACC    BEGSR
 
      * Account ID
 
     C                   MOVEL     EXBRCH        BRCA
     C                   MOVEL     EXCUSN        CNUM
     C                   MOVEL     EXCYCD        CCY
     C                   MOVEL     EXPACC        ACOD
     C                   MOVEL     EXACSQ        ACSQ
 
      * Bypass if account code is not a sub-ledger account code
 
     C                   Z-ADD     1             X
     C     ACOD          LOOKUP    SLA(X)                                 99
     C  N99              GOTO      END_ACC
     C                   MOVEL     SLT(X)        ACD_CUBI          1
     C                   MOVE      SLT(X)        ACD_AMTT          1
 
     C                   SETON                                        1020
 
      * Get correct sign of principal amount
 
     C     EXPAMT        MULT      EXPSGN        EXPAMT
 
      * Access account from sub-ledger account file
      * (This file records sub-ledger accounts with transactions against them).
 
     C     ACCBRK        CHAIN     MRSLACD0                           50
 
     C                   SETOFF                                       5152
     C     *IN50         IFEQ      *ON
 
      * A/c has no transactions against it and has a balance  => error
 
     C     EXPAMT        IFNE      *ZERO
     C                   SETON                                        51
     C                   Z-ADD     0             ValueOfTrans     18 3
     C                   Z-SUB     EXPAMT        Difference       18 3
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     VALT          ValueOfTrans     18 3
     C                   Z-ADD     DIFF          Difference       18 3
 
      * A/c has transactions against it but transaction value does not = a/c balance
      * => error
 
     C     BALR          COMP      'Y'                                5151
     C  N51              ADD       NOTR          NoRecTrans
 
      * A/c has transactions against it but CUBI/AMTT on a/c <> CUBI/AMTT for a/c code
      * => error
 
     C     CUBI          IFNE      ACD_CUBI
     C     AMTT          ORNE      ACD_AMTT
     C                   SETON                                        5152
     C                   ENDIF
 
     C                   ENDIF
 
      * Report sub-ledger account in error
 
     C                   ADD       1             NoAccounts
     C     *in51         IFEQ      *ON
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   EXCEPT    ACC
     C                   ELSE
     C                   ADD       1             NoRecAccounts
     C                   ENDIF
 
      * Set Status of accounts to 'SUB-LEDGER'
      * Set PRINCIPAL, INTEREST ACCRUAL, DISC/PREM, UNREALIZED P/L reconciled inds.
 
     C                   MOVEL     'S'           EXSTAT
     C                   SELECT
     C     ACD_AMTT      WHENEQ    'P'
     C                   MOVEL     ACD_CUBI      EXPREC
     C     ACD_AMTT      WHENEQ    'A'
     C                   MOVEL     ACD_CUBI      EXAREC
     C     ACD_AMTT      WHENEQ    'E'
     C                   MOVEL     ACD_CUBI      EXEREC
     C     ACD_AMTT      WHENEQ    'U'
     C                   MOVEL     ACD_CUBI      EXUREC
     C                   ENDSL
     C                   MOVEL     SUB           EXLSUB
     C                   EXCEPT    TRAP_UPD
 
     C     END_ACC       ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ACD_TOTALS    BEGSR
 
     C                   MOVEL     EXPACC        ACOD
     C                   Z-ADD     1             X
     C     ACOD          LOOKUP    SLA(X)                                 99
 
     C     *IN99         IFEQ      *ON
 
     C     EXPACC        CHAIN     @A5REA6                            99
     C   99              MOVEL     *BLANK        A5ACCN
 
     C                   MOVEL     SLT(X)        DESCKF            2
     C                   MOVE      SLT(X)        DESCKF
     C                   Z-ADD     1             X
     C     DESCKF        LOOKUP    DESCK(X)                               99
     C                   Z-ADD     6             CHLINE            3 0
     C                   EXSR      PAG
     C                   EXCEPT    ACDTOTALS
     C                   ENDIF
     C                   Z-ADD     0             NoAccounts        5 0
     C                   Z-ADD     0             NoRecAccounts     5 0
     C                   Z-ADD     0             NoRecTrans        5 0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     FIN_TOTALS    BEGSR
     C                   Z-ADD     1             CHLINE            3 0
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
     C                   OPEN      MRSLACRP1
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
     C     *INZSR        BEGSR
     C     ACCBRK        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C     SLACK         KLIST
     C                   KFLD                    ACOD
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Output page headings
 
     C                   Z-ADD     99            LINENO
     C                   Z-ADD     0             PAGNUM            5 0
 
      * Determine sub-ledger account codes
 
     C                   Z-ADD     *ZERO         ACOD
     C     SLACK         SETLL     MRSLACDX
     C                   READ      MRSLACDX                               99
     C     *IN99         DOWEQ     *OFF
     C                   Z-ADD     1             X                 3 0
     C     ACOD          LOOKUP    SLA(X)                                 99
     C     *IN99         IFEQ      *OFF
     C     *ZERO         LOOKUP    SLA(X)                                 99
     C                   Z-ADD     ACOD          SLA(X)
     C                   MOVEL     CUBI          SLT(X)
     C                   MOVE      AMTT          SLT(X)
     C                   ENDIF
     C                   READ      MRSLACDX                               99
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
     OMRSLACRP1 E            PAGEHEAD         03
     O                                           23 'REFERENCE MRSLACRP1'
     O                       BJURPT              89
     O                                          104 'DATE'
     O                       BJMRDT             112
     O                                          122 'PAGE'
     O                       PAGNUM             127 '   0 '
     O          E            PAGEHEAD    1
     O                                           70 'SUB-LEDGER ACCOUNT REPORT'
     O          E            PAGEHEAD    1
     O                                            3 'BRC'
     O                                            7 'CCY'
     O                                           18 'A/C CODE'
     O                                           25 'CUST'
     O                                           28 'SQ'
     O                                           48 'BALANCE '
     O                                           70 'VALUE OF TRANSACTIONS'
     O                                           88 'DIFFERENCE '
     O          E            ACC         1
     O                       EXBRCH               3
     O                                            4 '-'
     O                       EXCYCD               7
     O                                            8 '-'
     O                       EXPACC              18
     O                                           19 '-'
     O                       EXCUSN              25
     O                                           26 '-'
     O                       EXACSQ              28
     O                       EXPAMT              48 '             0 .   -'
     O                       ValueOfTrans        68 '             0 .   -'
     O                       Difference          88 '             0 .   -'
     O                     52                   109 'A/C MISUSED:'
     O                     52CUBI               110
     O                     52AMTT               111
     O                     52                   112 '/'
     O                     52ACD_CUBI           113
     O                     52ACD_AMTT           114
     O                     50                   130 'NO TRANSACTIONS'
     O          E            ACDTOTALS   1
     O                                            3 '***'
     O                       EXPACC              18
     O                       A5ACCN              44
     O          E            ACDTOTALS   1
     O                       DESC(X)             79
     O          E            ACDTOTALS   1
     O                                           34 'No of Accounts:'
     O                       NoAccounts          54 '   0 '
     O          E            ACDTOTALS   1
     O                                           36 'No of Reconciled '
     O                                           45 'Accounts:'
     O                       NoRecAccounts       54 '   0 '
     O          E            ACDTOTALS   1
     O                                           36 'No of Reconciled '
     O                                           49 'Transactions:'
     O                       NoRecTrans          54 '   0 '
     O          E            ACDTOTALS   1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
     O          E            FINTOTALS   1
     O                                           74 '* END OF REPORT * '
     OMRTRAPD0  E            TRAP_UPD
     O                       EXSTAT
     O                       EXPREC
     O                       EXAREC
     O                       EXEREC
     O                       EXUREC
     O                       EXLSUB
** DESCK
BA
BE
BP
BU
CA
CE
CP
CU
** DESC
Branch Internal Customer Interest Accrual Accounts
Branch Internal Customer Discount/Premium Accrual Accounts
Branch Internal Customer Principal Accounts
Branch Internal Customer Unrealized P/L Accounts
Customer Interest Accrual Accounts
Customer Discount/Premium Accrual Accounts
Customer Principal Accounts
Customer Unrealized P/L Accounts
