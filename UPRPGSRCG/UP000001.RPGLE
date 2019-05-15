     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Check if object is to be journaled')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  UP000001 - Check if object is to be journaled.               *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256038  *CREATE    Date 06Sep08               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256038 - Handle triggering of files.                         *
      *                                                               *
      *****************************************************************
      *
      * File containing list of objects not to be journaled.
     FGPNJRNL4  IF   E           K DISK
      *
     D Object          S             10
     D Type            S             10
     D PObject         S             10
     D PType           S             10
     D PToBeJournaled  S              1
     D Recursive       S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    PObject
     C                   PARM                    PType
     C                   PARM                    PToBeJournaled
     C
     C     Obj_and_Type  KLIST
     C                   KFLD                    Object
     C                   KFLD                    Type
      *
     C                   EVAL      Object = PObject
     C                   EVAL      Type = PType
     C                   EVAL      PToBeJournaled = *blank
      *
      * See if record exists.
     C     Obj_and_Type  CHAIN     GPNJRNL4
     C                   IF        %FOUND
     C                   IF        NJACTV = 'Y'
     C                   EVAL      PToBeJournaled = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
