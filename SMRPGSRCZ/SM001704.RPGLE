     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update STRAN')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM001704 - Update STRAN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 248691             Date 25Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSM007 *C *CREATE  Date 01Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  248691 - Additional processing added for 'D' records.        *
      *  CSM007 - Additional conversion for 10 long account code.     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *****************************************************************
      *
     FSTRAN     UF   E             DISK    INFSR(*PSSR)
     F*SMAC10PD*IF***E           K DISK    INFSR(*PSSR)                                       248691
      *
     D  STRANData      DS           209
     D  OldACOD               10     13
     D  OldACODNum            10     13  0
     D  OldACOD__D            13     16                                                       248691
     D  OldACODNuD            13     16  0                                                    248691
     D  NewACOD              200    209
     D  NewACODNum           200    209  0
      *
     C     1             SETLL     STRAN
     C                   READ      STRAN
      *
     C                   DOU       %EOF
      *
     C                   IF        RECI = 'R'
     C                   EVAL      STRANData = ZZ199
     C*****OldACODNum    CHAIN     SMAC10PD                                                   248691
     C**********         IF        %FOUND                                                     248691
     C**********         EVAL      NewACODNum = ACOD10                                        248691
     C                   CALL      'SM00AC10'                                                 248691
     C                   PARM                    OldACODNum                                   248691
     C                   PARM                    NewACODNum                                   248691
     C                   EVAL      OldACOD = '    '
     C                   EVAL      ZZ199 = STRANData
     C                   UPDATE    STRANF
     C**********         ENDIF                                                                248691
     C                   ENDIF
      *
     C                   IF        RECI = 'D'                                                 248691
     C                   EVAL      STRANData = ZZ199                                          248691
     C                   CALL      'SM00AC10'                                                 248691
     C                   PARM                    OldACODNuD                                   248691
     C                   PARM                    NewACODNum                                   248691
     C                   EVAL      OldACOD__D = '    '                                        248691
     C                   EVAL      ZZ199 = STRANData                                          248691
     C                   UPDATE    STRANF                                                     248691
     C                   ENDIF                                                                248691
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
