     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Corrective Batch Global Layer Update')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL008902 - Midas GL Corrective Batch Global Layer Update     *
      *                                                               *
      *  Function:  This program updates the previous period end      *
      *             balances of corrective batch accounts.            *
      *                                                               *
      *  Called By: GLC008902 - Midas GL Corrective Batch Global      *
      *                         Layer Update                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CSC054 *CREATE     Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    70      Manual postings detail file - EOF                  *
      *    71      Corrective batch register file - Chain             *
      *    72      Account master detail file - Chain                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** Midas GL Manual Postings Detail File
     FMANPOPD   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(BT)
 
      ** Midas GL Corrective Batch Register File
     FGLCORBL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Accounts Master Detail File
     FACCNT     UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D BTSPOS          DS
     D BNUMSP                  1      3
     D ITEMSP                  4      7
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D WRun            S              1A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read all postings from manual postings details file
 
     C     1             SETLL     MANPOPD
     C                   READ      MANPOPD                                70
     C     *IN70         DOWEQ     '0'
 
     C                   IF        BNUMSP <> *BLANKS AND
     C                             ITEMSP = *BLANKS AND
     C                             BTGETP = *BLANKS AND
     C                             BTRECI = 'P'
 
      ** Check if posting is from corrective batch
 
     C     KCorb         CHAIN     GLCORBL0                           71
     C                   IF        *IN71 = '0'
 
      ** Update End of Period Balances of the account
 
     C     KAccnt        CHAIN     ACCNT                              72
     C                   IF        *IN72 = '0'
     C     BTDRCR        IFEQ      0
     C                   ADD       BTPSTA        EPLB
     C                   ADD       BTPSTA        EPCB
     C                   ELSE
     C                   SUB       BTPSTA        EPLB
     C                   SUB       BTPSTA        EPCB
     C                   ENDIF
     C                   UPDATE    ACCNTABF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   READ      MANPOPD                                70
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
     ** Key fields for corrective batch register file
 
     C     KCorb         KLIST
     C                   KFLD                    BNUMSP
     C                   KFLD                    BTPSTD
 
     ** Key fields for accounts master file
 
     C     KAccnt        KLIST
     C                   KFLD                    BTCNUM
     C                   KFLD                    BTCCY
     C                   KFLD                    BTACOD
     C                   KFLD                    BTACSQ
     C                   KFLD                    BTBRCA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
     C                   RETURN
 
     C                   ENDSR
