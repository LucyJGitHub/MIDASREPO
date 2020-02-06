     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*XBIA*  OVRDBF FILE(POST1) TOFILE(UPPOSTPD)                          *
/*XBIB*  OVRDBF FILE(POST2) TOFILE(UPPOSTPD)                          *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Cross check postings from EODPOPD')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP000007 - Cross check postings from EODPOPD                 *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27788 *CREATE   Date 24May10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27788 - Postings reconciliation utility                   *
      *                                                               *
      *****************************************************************
      *
     FPOST1     IF   E             DISK    INFSR(*PSSR)
     FPOST2     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:POSTF) PREFIX(X)
     FUPPOSTPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:DIFFF) PREFIX(D)
      *
      /EJECT
     D Recursive       S              1    INZ(' ')
     D PMode           S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode
      *
     C     Account       KLIST
     C                   KFLD                    RECI
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    SPOS
      *
     C                   READ      POST1
      *
     C                   DOW       NOT(%EOF)
     C                   IF        RECI = 'T'
      *
     C     Account       CHAIN     POSTF
      * If record not found then record has been deleted or added
      *  depending on mode.
     C                   IF        NOT(%FOUND)
     C                   EVAL      DRECI = PMode
     C                   EVAL      DBRCA = BRCA
     C                   EVAL      DCNUM = CNUM
     C                   EVAL      DCCY  = CCY
     C                   EVAL      DACOD = ACOD
     C                   EVAL      DACSQ = ACSQ
     C                   EVAL      DSPOS = SPOS
     C                   EVAL      DCHQN = CHQN
     C                   EVAL      DSDCB = SDCB
     C                   WRITE     DIFFF
      *
     C                   ELSE
      * Need to find differences but this should only be run once;
      *  run only if mode is 'N'.
     C                   IF        PMode = 'N'
      *
     C                   IF        SDCB <> XSDCB or
     C                             CHQN <> XCHQN
     C                   EVAL      DRECI = 'B'
     C                   EVAL      DBRCA = BRCA
     C                   EVAL      DCNUM = CNUM
     C                   EVAL      DCCY  = CCY
     C                   EVAL      DACOD = ACOD
     C                   EVAL      DACSQ = ACSQ
     C                   EVAL      DSPOS = SPOS
     C                   EVAL      DCHQN = CHQN
     C                   EVAL      DSDCB = SDCB
     C                   EVAL      DSDLB = XSDCB
     C                   EVAL      DPTIM = XCHQN
     C                   WRITE     DIFFF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      POST1
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      ********************************************************************
