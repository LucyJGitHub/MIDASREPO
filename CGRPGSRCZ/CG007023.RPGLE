     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Load DL/LE Interest Scale Qualifying Acct Codes')      *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG007023 - Load Dealing and Lending Interest Scale           *
      *             Qualifying Account Codes via DL/LE                *
      *             Types/Sub-Types tables                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR815785*CREATE    Date 17Aug11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR815785 - Interest Scale DL/LE Load Account Codes maint ;   *
      *             replaced CG7180 program to revise the DL/LE       *
      *             loading functionality                             *
      *                                                               *
      *****************************************************************
      ** Midas Loans Types/Sub-Types
     FSDLOANPD  IF   E             DISK    INFSR(*PSSR)
      ** Midas FD Deal type/Subtypes
     FFDDTSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Interest Scale DL/LE Qualifying Account Codes
     FCGISDQL0  IF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CGISDQD0:ZDQPL0)
     F                                     COMMIT
      ** Working variables
     D WSRUN           S              1A
     D WSCRTR          S              3A
      ** Midas Account Keys INFDS
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** Installation control details DS
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *****************************************************************
      *                                                               *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      *****************************************************************
 
      ** Load FDDTSTPD
     C                   EXSR      SrLoad_Dealing
      ** Load SDLOANPD
     C                   EXSR      SrLoad_Lending
      ** Record/s created
     C     WSCRTR        IFEQ      'YES'
     C                   COMMIT
     C                   ENDIF
 
      ** Terminate function
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SrLoad_Dealing - Load Dealing Type/Subtype                    *
      *                                                               *
      *****************************************************************
     C     SrLoad_DealingBEGSR
 
      ** Read FDDTSTPD
     C     *LOVAL        SETLL     FDDTSTPD
     C                   READ      FDDTSTPD                               81
 
     C     *IN81         DOWEQ     *OFF
      ** If type is CD(call deposit) or CL(call loan), write to the table
     C                   IF        DTPE11 = 'CD' OR DTPE11 = 'CL'
     C                   EVAL      Z1DLTP = DTPE11
     C                   EVAL      Z1DLST = DLST11
     C                   EVAL      Z1ACOD = 0
     C     KYCGDQ        CHAIN     CGISDQL0
     C                   IF        NOT %FOUND(CGISDQL0)
     C                   EVAL      Z1LCDT = AGRDNB
     C                   EVAL      Z1LCTP = 'I'
     C                   EVAL      Z1TRCL = ' '
     C                   WRITE     ZDQPL0
     C                   EVAL      WSCRTR = 'YES'
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      FDDTSTPD                               81
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SrLoad_Lending - Load Lending Type SubType                    *
      *                                                               *
      *****************************************************************
     C     SrLoad_LendingBEGSR
 
      ** Read SD Loan types/subtypes
     C                   READ      SDLOANPD                               80
 
     C     *IN80         DOWEQ     *OFF
 
      ** If loan processing type is 61(demand loan), 68(call participation purchased) or
      **    69(call participation sold), write to the table
     C                   IF        AYLNPT = 61 OR AYLNPT = 68 OR AYLNPT = 69
     C                   EVAL      Z1DLTP = AYLNTY
     C                   EVAL      Z1DLST = AYLNST
     C                   EVAL      Z1ACOD = 0
     C     KYCGDQ        CHAIN     CGISDQL0
     C                   IF        NOT %FOUND(CGISDQL0)
     C                   EVAL      Z1LCDT = AGRDNB
     C                   EVAL      Z1LCTP = 'I'
     C                   EVAL      Z1TRCL = ' '
     C                   WRITE     ZDQPL0
     C                   EVAL      WSCRTR = 'YES'
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDLOANPD                               80
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     KYCGDQ        KLIST
     C                   KFLD                    Z1DLTP
     C                   KFLD                    Z1DLST
     C                   KFLD                    Z1TRCL
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Record/s created flag
     C                   EVAL      WSCRTR = 'NO '
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - File exception/ error subroutine                     *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
      ** Check to see that *PSSR has not already been called
     C     WSRUN         IFEQ      *BLANK
     C                   MOVE      'Y'           WSRUN
     C                   ENDIF
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
