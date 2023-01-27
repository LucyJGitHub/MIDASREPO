     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update STRAN')                                *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU01000 - Update Base Rate field in STRAN                   *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060906  *CREATE  Date 25Jan23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060906 - Base Rate with '00' was not converted to blanks   *
      *             in PF/STRAN. It caused REC7B to fail as RE0743    *
      *             process base rate with '00' which doesn't exist.  *
      *             Create a program to convert the '00' base rate    *
      *             to blank when upgrading to a release with CSD103. *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *                                                               *
      *****************************************************************
      *
     FSTRAN     UF   E             DISK    INFSR(*PSSR)
      *
     D  STRANData      DS           209
     D  RecSeq                16     16  0
     D  BaseRate             152    153
     D  BaseRateNo           152    153  0
      *
     C     1             SETLL     STRAN
     C                   READ      STRAN
      *
     C                   DOU       %EOF
      *
     C                   IF        RECI = 'R'
     C                   EVAL      STRANData = ZZ199
     C                   IF        RecSeq = 1 and BaseRateNo = *Zero
     C                   EVAL      BaseRate = '  '
     C                   EVAL      ZZ199 = STRANData
     C                   UPDATE    STRANF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      STRAN
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR    - Program exception error routine                   *
      *             Called automatically if a program error occurs,   *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   DUMP
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
