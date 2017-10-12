     H DEBUG DATEDIT(*YMD)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Account Bal Extr E rcds for post 2/3/4')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL33203 - Midas GL Acct Bal Extract E rcds for post 2/3/4    *
      *                                                               *
      *  Function:  Write records to ABEXAGE for post runs 2/3/4      *
      *                                                               *
      *  Called By: GLC33202                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD042411           Date 18Nov16               *
      *  Prev Amend No. CGL120  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042411 - BRCA/CCY/ACOD totals can be more than 15 digits   *
      *            (Recompile)                                        *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
      *
     FACJND4    IF   E           K DISK    INFSR(*PSSR) INCLUDE(APOSTPDF)
     FACBRC     IF   E           K DISK    INFSR(*PSSR)
     FABEXAGE   O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(BA)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     98 - Indicator for read of ACBRC                          *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
      ** Local data area for database error details
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Program Status Data Structure
      *
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D WRKDRBL         S                   LIKE(BADRBL)
     D WRKCRBL         S                   LIKE(BACRBL)
     D ACCTFND         S              1
     D MODE            S              1
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
     C     KEY01         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
      *
     C     *LOVAL        SETLL     ACJND4
     C                   READ      ACJND4
      *
     C                   DOW       %EOF(ACJND4) = '0'
     C                   EVAL      WRKCRBL = 0
     C                   EVAL      WRKDRBL = 0
      *
      ** Accumulate Account balances for read BRCA/CCY/ACOD
      *
     C                   EVAL      ACCTFND = 'N'
     C     KEY01         SETLL     ACBRC
     C     KEY01         READE     ACBRC                                  98
      *
     C                   DOW       *IN98  = '0'
     C                   EVAL      ACCTFND = 'Y'
     C                   IF        LDBL < 0
     C                   EVAL      WRKCRBL = WRKCRBL + LDBL
     C                   ELSE
     C                   EVAL      WRKDRBL = WRKDRBL + LDBL
     C                   ENDIF
      *
     C     KEY01         READE     ACBRC                                  98
     C                   ENDDO
      *
     C                   IF        ACCTFND = 'Y'
     C                   EXSR      SETVAL
     C                   WRITE     ABEXAGF
     C                   EVAL      WRKCRBL = 0
     C                   EVAL      WRKDRBL = 0
     C                   ENDIF
      *
      ** Skip other postings for same BRCA/CCY/ACOD
      *
     C     KEY01         SETGT     ACJND4
     C                   READ      ACJND4
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETVAL - Set-up fields for ABEXAG                             *
      *                                                               *
      * Called by: Main processing                                    *
      * Calls: None                                                   *
      *****************************************************************
     C     SETVAL        BEGSR
      *
     C                   EVAL      BARECI = 'E'
     C                   EVAL      BABRCA = BRCA
     C                   EVAL      BACNUM = '000000'
     C                   EVAL      BACCY = CCY
     C                   EVAL      BAACOD = ACOD
     C                   EVAL      BARIND = 0
     C                   EVAL      BAACSQ = 0
     C                   EVAL      BACRBL = WRKCRBL
     C                   EVAL      BADRBL = WRKDRBL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      * Calls: None                                                   *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
