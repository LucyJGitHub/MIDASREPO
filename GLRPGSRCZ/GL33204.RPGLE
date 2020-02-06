     H DEBUG DATEDIT(*YMD)
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Spot Reval and Tfr Base Ccy equivalents')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL33204 - Midas GL Spot Revaluations & Tfr of Bccy Equivs    *
      *                                                               *
      *  Function:  This new program will retrieve records from       *
      *             postings files and populate ZACCNTAB with details *
      *             from ACCNTAB                                      *
      *                                                               *
      *  Called By: GLC33204                                          *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL142             Date 06Aug12               *
      *                 CGL120  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL142 - Tactical COB changes GL                             *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
      *
     FZACCNTAB  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTABF2)
      * Midas GL Account Balance Extract Driver
 
     FACJND4    IF   E           K DISK    INFSR(*PSSR) INCLUDE(APOSTPDF)
      * Midas GL Postings Details
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      * Midas GL Accounts master
 
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
     D/EJECT
      /SPACE 3
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
     D KCNUM           S              6
     D KCCY            S              3
     D KACOD           S             10  0
     D KACSQ           S              2  0
     D KBRCA           S              3
     D KRIND           S              1  0
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initial processing
      *
     C                   EXSR      INIT
      *
     C     *LOVAL        SETLL     ACJND4
     C                   READ      ACJND4
      *
     C                   DOW       %EOF(ACJND4) = '0'
      *
     C                   EVAL      KCNUM = CNUM
     C                   EVAL      KCCY  = CCY
     C                   EVAL      KACOD = ACOD
     C                   EVAL      KACSQ = ACSQ
     C                   EVAL      KBRCA = BRCA
     C                   EVAL      KRIND = RIND
     C     KEY01         CHAIN     ACCNT
     C**********         IF        %FOUND(ACCNT)                                              CGL142
     C**********         WRITE     ACCNTABF2                                                  CGL142
     C                   IF        NOT %FOUND(ACCNT)                                          CGL142
     C                   CLEAR                   ACCNTABF2                                    CGL142
     C                   EVAL      RECI = 'X'                                                 CGL142
     C                   EVAL      CNUM = KCNUM                                               CGL142
     C                   EVAL      CCY  = KCCY                                                CGL142
     C                   EVAL      ACOD = KACOD                                               CGL142
     C                   EVAL      ACSQ = KACSQ                                               CGL142
     C                   EVAL      BRCA = KBRCA                                               CGL142
     C                   EVAL      LDBL = *ZERO                                               CGL142
     C                   EVAL      CLBL = *ZERO                                               CGL142
     C                   ENDIF
     C                   WRITE     ACCNTABF2                                                  CGL142
      *
      ** Skip other postings for same account
      *
     C     KEY02         SETGT     ACJND4
     C                   READ      ACJND4
      *
     C                   ENDDO
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR/INIT - Initial processing.                                 *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** KLIST for ACCNT and ZACCNTAB
      *
     C     KEY01         KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
      *
      ** Key List for ACJND4
      *
     C     KEY02         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KRIND
     C                   KFLD                    KCNUM
     C                   KFLD                    KACSQ
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
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
