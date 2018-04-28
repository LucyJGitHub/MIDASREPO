     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Populate ZACCNTABC with closing accounts')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0600007 - Midas GL Populate ZACCNTABC with closing a/cs    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CGL142  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL142 - Tactical COB changes GL                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     80 - CACCNTAB Record                                      *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
 
      ** Midas GL Account Balance Extract Driver
     FZACCNTAB  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTABF2)
 
      ** Midas GL Closing accounts
     FCACCNTAB  IF   E             DISK    INFSR(*PSSR)
 
      ** Midas GL Accounts master
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
 
      ** Midas GL Accounts master
     FZACCNT    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTABF3)
     F                                     PREFIX(Z_)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program Status Data Structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
      ** ACCNT Key
     D DSAKEY          DS
     D  CNUM                   1      6
     D  CCY                    7      9
     D  ACOD                  10     19  0
     D  ACSQ                  20     21  0
     D  BRCA                  22     24
 
      ** ACCNT Key Field
     D KCNUM           S              6
     D KCCY            S              3
     D KACOD           S             10  0
     D KACSQ           S              2  0
     D KBRCA           S              3
 
      ** Initial processing
 
     C                   EXSR      INIT
 
     C                   READ      CACCNTAB
 
     C                   DOW       NOT %EOF(CACCNTAB)
 
     C                   EVAL      KCNUM = CNUM
     C                   EVAL      KCCY  = CCY
     C                   EVAL      KACOD = ACOD
     C                   EVAL      KACSQ = ACSQ
     C                   EVAL      KBRCA = BRCA
     C     KEY01         CHAIN     ZACCNT
     C                   IF        NOT %FOUND(ZACCNT)
 
     C     KEY01         CHAIN     ACCNT
     C                   IF        %FOUND(ACCNT)
     C                   WRITE     ACCNTABF2
     C                   ELSE
     C                   MOVE      'ACCNT'       DBFILE
     C                   Z-ADD     001           DBASE
     C                   MOVEL     DSAKEY        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      CACCNTAB
 
     C                   ENDDO
 
      ** End processing
 
     C                   EXSR      END
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END - Exit program and return to calling program.            *
      *                                                               *
      *****************************************************************
     C     END           BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Initial processing.                                   *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
 
      ** KLIST for ACCNT and ZACCNTAB
 
     C     KEY01         KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
 
     C     *DTAARA       DEFINE                  LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
