     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Migration Utility for CLOANCL')               *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00115 - Migration Utility for CLOANCL and related files   *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 AR1075447 *CREATE  Date 28Mar13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  AR1085447D - Migration utility for CLOANCL, MCLONCL          *
      *                                                               *
      *****************************************************************

      ** Midas LE Past Due & Original Loan Link
     FLEPDUELA  IF   E           K DISK

      ** Midas LE Past Due & Original Fees Link
     FLEPDUFL1  IF   E           K DISK

      ** Midas GZ Customer loans A record
     FCLOAN     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)

      ** Midas LE New matured loans file
     FMLOAN     UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:HISTLF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Loans
      *
     C                   SETOFF                                       99
     C     *IN99         DOWEQ     *OFF
     C                   READ      LEPDUELA                               99
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SrUpdateFL1
     C                   ENDIF
     C                   ENDDO
      *
      ** Fees
      *
     C                   SETOFF                                       99
     C     *IN99         DOWEQ     *OFF
     C                   READ      LEPDUFL1                               99
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SrUpdateFL2
     C                   ENDIF
     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFees - Update Fees Fields                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrFees        BEGSR
     C                   EVAL      ORLN = *BLANKS
     C                   EVAL      OFCU = YECNUM
     C                   IF        YEFACL <> *ZEROS
     C                   MOVEL     YEFACL        OFAC
     C                   ELSE
     C                   MOVEL     *BLANKS       OFAC
     C                   ENDIF
     C                   MOVEL     YESEQ         OFSQ
     C                   EVAL      OFLN = YPORG
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLoan - Update Loan Fields                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrLoan        BEGSR
     C                   EVAL      ORLN = YPORG
     C                   EVAL      OFCU = *BLANKS
     C                   EVAL      OFAC = *BLANKS
     C                   EVAL      OFES = *BLANKS
     C                   EVAL      OFSQ = *BLANKS
     C                   EVAL      OFLN = *BLANKS
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdateFL1 - Update Fields                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdateFL1   BEGSR
      *
      ** CLOANCL
     C     YPLON         CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)
     C                   EXSR      SrLoan
     C                   UPDATE    CLOANCLF
     C                   ENDIF
      *
      ** MCLONCL
     C     YPLON         CHAIN     MLOAN
     C                   IF        %FOUND(MLOAN)
     C                   EXSR      SrLoan
     C                   UPDATE    HISTLF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdateFL2 - Update Fields                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdateFL2   BEGSR
      *
      ** CLOANCL
     C     YPLON         CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)
     C                   EXSR      SrFees
     C                   UPDATE    CLOANCLF
     C                   ENDIF
      *
      ** MCLONCL
     C     YPLON         CHAIN     MLOAN
     C                   IF        %FOUND(MLOAN)
     C                   EXSR      SrFees
     C                   UPDATE    HISTLF
     C                   ENDIF
      *
      *
     C                   ENDSR
      *
      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
      *
     C                   RETURN
     C                   EVAL      *INLR = *ON
     C                   ENDSR
      *
      *****************************************************************
