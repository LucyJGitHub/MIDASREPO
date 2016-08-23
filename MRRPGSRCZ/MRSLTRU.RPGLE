     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Sub-Ledger Transactions Update')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRSLTRU - Sub-Ledger Transactions Update               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CMR001  *CREATE    Date 16Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRSLTRL1  IP   E           K DISK
     FMRSLACL1  IF   E           K DISK
     FMRTRAPL0  UF   E           K DISK
 
     IMRSLTRD0
     I                                          BRCA          L1
     I                                          CNUM          L1
     I                                          CCY           L1
     I                                          ACOD          L1
     I                                          ACSQ          L1
     I                                          SUB           L1
     I                                          CUBI          L1
     I                                          AMTT          L1
 
      * Access account from sub-ledger account file
      * (This file records sub-ledger accounts with transactions against them).
 
     C   L1SLACK         CHAIN     MRSLACD0                           50
 
      * Update transactions
 
     C                   EXSR      UPDATE_TRAN
 
      /SPACE 5
     C**********************************************************************************
     C     UPDATE_TRAN   BEGSR
 
     C     *IN50         IFEQ      *OFF
 
      * Update MRTRAPPD record according to amount type and customer/BICN
 
     C     TRAPK         CHAIN     MRTRAPD0                           60
 
      * Set PRINCIPAL, INTEREST ACCRUAL, DISC/PREM, UNREALIZED P/L reconciled inds.
 
     C     *IN60         IFEQ      *OFF
     C                   SELECT
     C     AMTT          WHENEQ    'P'
     C                   MOVEL     CUBI          EXPREC
     C     AMTT          WHENEQ    'A'
     C                   MOVEL     CUBI          EXAREC
     C     AMTT          WHENEQ    'E'
     C                   MOVEL     CUBI          EXEREC
     C     AMTT          WHENEQ    'U'
     C                   MOVEL     CUBI          EXUREC
     C                   ENDSL
     C                   EXCEPT    TRAP_UPD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
     C     SLACK         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    SUB
     C                   KFLD                    CUBI
     C                   KFLD                    AMTT
     C     TRAPK         KLIST
     C                   KFLD                    SUB
     C                   KFLD                    TRID
     C                   KFLD                    SEQ
     C                   ENDSR
     C**********************************************************************************
     OMRTRAPD0  E            TRAP_UPD
     O                       EXPREC
     O                       EXAREC
     O                       EXEREC
     O                       EXUREC
