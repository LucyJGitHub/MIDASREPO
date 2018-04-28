     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Loans Amendements Extension File Take-On')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000071 - Midas LE Loan Amendments Extension File Take-On   *
      *             Program                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CRE073  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas LE Loan Amendments File
     FLOAMSDK   IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Loan Amendments Extension File
     FCLOAMQL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     KYXTLA        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    VDAT
     C                   KFLD                    LASN
     C
      ** Read all records in Loan Amendments File
 
     C                   READ      LOAMSDK
     C                   DOW       NOT %EOF(LOAMSDK)
     C
     C     KYXTLA        CHAIN     CLOAMQL0
 
     C                   IF        NOT %FOUND(CLOAMQL0)
     C                   EVAL      AMLNRF = LNRF
     C                   EVAL      AMVDAT = VDAT
     C                   EVAL      AMLASN = LASN
     C                   EVAL      AMBRCA = BRCA
     C                   EVAL      AMFRID = FRNT
     C                   EVAL      AMCNSP = *ZERO
     C                   EVAL      AMCNSG = *BLANKS
     C                   EVAL      AMRDMT = *BLANKS
     C                   EVAL      AMRDFD = *BLANKS
     C                   WRITE     LOAMSQD0
     C                   ENDIF
 
     C                   READ      LOAMSDK
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
