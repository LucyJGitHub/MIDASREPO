     H DEBUG DATEDIT(*YMD)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Account balances extract E records')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL33202 - Midas GL Account balances extract 'E' records      *
      *                                                               *
      *  Function:  Write records to ABEXAGE from GLACBTPD or ACCNTAB *
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
      *             (Recompile)                                       *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
      *
     FGLACBTL1  IF   E           K DISK    INFSR(*PSSR)
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
     D WRKDRBL         S                   LIKE(BADRBL) INZ(0)
     D WRKCRBL         S                   LIKE(BACRBL) INZ(0)
     D MODE            S              1
     D SBRCA           S              3    INZ(*BLANKS)
     D SCCY            S              3    INZ(*BLANKS)
     D SACOD           S             10  0 INZ(0)
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE
      *
     C                   EVAL      WRKCRBL = 0
     C                   EVAL      WRKDRBL = 0
      *
     C     *LOVAL        SETLL     GLACBTL1
     C                   READ      GLACBTL1
      *
     C                   IF        %EOF(GLACBTL1) = '0'
     C                   EVAL      SBRCA = BRCA
     C                   EVAL      SCCY = CCY
     C                   EVAL      SACOD = ACOD
     C                   ENDIF
      *
     C                   DOW       %EOF(GLACBTL1) = '0'
      *
      ** Accumulate balances whilst same BRCA/CCY/ACOD
      *
     C                   IF        BRCA = SBRCA AND CCY = SCCY
     C                             AND ACOD = SACOD
     C                   IF        LDBL < 0
     C                   EVAL      WRKCRBL = WRKCRBL + LDBL
     C                   ELSE
     C                   EVAL      WRKDRBL = WRKDRBL + LDBL
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        BRCA <> SBRCA OR CCY <> SCCY
     C                             OR ACOD <> SACOD
     C                   EXSR      SETVAL
     C                   WRITE     ABEXAGF
     C                   EVAL      WRKCRBL = 0
     C                   EVAL      WRKDRBL = 0
     C                   IF        LDBL < 0
     C                   EVAL      WRKCRBL = WRKCRBL + LDBL
     C                   ELSE
     C                   EVAL      WRKDRBL = WRKDRBL + LDBL
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      SBRCA = BRCA
     C                   EVAL      SCCY = CCY
     C                   EVAL      SACOD = ACOD
      *
     C                   READ      GLACBTL1
     C                   ENDDO
      *
     C                   IF        SBRCA <> *BLANKS
     C                   EXSR      SETVAL
     C                   WRITE     ABEXAGF
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETVAL - Set-up fields for ABEXAGE                            *
      *                                                               *
      * Called by: Main processing                                    *
      * Calls: None                                                   *
      *****************************************************************
     C     SETVAL        BEGSR
      *
     C                   EVAL      BARECI = 'E'
     C                   EVAL      BABRCA = SBRCA
     C                   EVAL      BACNUM = '000000'
     C                   EVAL      BACCY = SCCY
     C                   EVAL      BAACOD = SACOD
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
