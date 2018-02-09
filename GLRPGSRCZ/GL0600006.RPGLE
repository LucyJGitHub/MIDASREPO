     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Populate ZACCNTAB with postings only')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0600006 - Midas GL Populate ZACCNTAB with postings only    *
      *                                                               *
      *  Function:  This new program will retrieve records from       *
      *             postings files and populate ZACCNTAB              *
      *                                                               *
      *  Called By: GLC0600006                                        *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1097218          Date 05Apr13               *
      *                 CGL142  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1097218 - GLC0720 seq 10001 failed Out of Balance          *
      *  CGL142 - Tactical COB changes GL                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      ******80*-*GLACPML0*record***************************************                    AR1097218
      ******81*-*SETLL*ZACCNTC*****************************************                    AR1097218
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
 
      ** Midas GL Account Balance Extract Driver
     FZACCNTAB  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTABF2)
 
      ** Midas GL Accounts Postings
     F***GLACPML0  IF   F  620    24AIDISK    INFSR(*PSSR)                                 AR1097218
     FACPO1     IF   F  620    24AIDISK    INFSR(*PSSR)
     F                                     KEYLOC(2)
 
      ** Midas GL Accounts master
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program Status Data Structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
     D ACPOK                   1     24
     D  KCNUM                  1      6
     D  KCCY                   7      9
     D  KACOD                 10     19  0
     D  KACSQ                 20     21  0
     D  KBRCA                 22     24
 
     D WRun            S              1
 
     I***GLACPML0  NS  01    1 CR                                                          AR1097218
     IACPO1     NS  01    1 CR                                                             AR1097218
     I                                  1  620  ACREC
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I                                 15   16 0ACSQ
     I                                103  105  BRCA
     I                                161  170 0ACOD
     I          NS  02    1 CP
     I                                  1  620  ACREC
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I                                 15   16 0ACSQ
     I                                103  105  BRCA
     I                                590  599 0ACOD
 
      ** Initial processing
 
     C                   EXSR      INIT
 
     C******LOVAL        SETLL     GLACPML0                                                AR1097218
     C**********         READ      GLACPML0                                                AR1097218
     C     *LOVAL        SETLL     ACPO1
     C                   READ      ACPO1
 
     C**********         DOW       NOT %EOF(GLACPML0)                                      AR1097218
     C                   DOW       NOT %EOF(ACPO1)                                         AR1097218
 
     C                   EVAL      KCNUM = CNUM
     C                   EVAL      KCCY  = CCY
     C                   EVAL      KACOD = ACOD
     C                   EVAL      KACSQ = ACSQ
     C                   EVAL      KBRCA = BRCA
     C     KEY01         CHAIN     ACCNT
     C                   IF        NOT %FOUND(ACCNT)
     C                   CLEAR                   ACCNTABF2
     C                   EVAL      RECI = 'X'
     C                   EVAL      CNUM = KCNUM
     C                   EVAL      CCY  = KCCY
     C                   EVAL      ACOD = KACOD
     C                   EVAL      ACSQ = KACSQ
     C                   EVAL      BRCA = KBRCA
     C                   EVAL      LDBL = *ZERO
     C                   EVAL      CLBL = *ZERO
     C                   ENDIF
     C                   WRITE     ACCNTABF2
 
      ** Skip other postings for same account
 
     C*****ACPOK         SETGT     GLACPML0                                                AR1097218
     C**********         READ      GLACPML0                                                AR1097218
     C     ACPOK         SETGT     ACPO1                                                   AR1097218
     C                   READ      ACPO1                                                   AR1097218
 
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
 
      ***Key*List*for*GLACPML0*****************************************                    AR1097218
      ** Key List for ACPO1                                                                AR1097218
 
     C     KEY02         KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
 
      ** Define LDA
 
     C     *DTAARA       DEFINE                  LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
