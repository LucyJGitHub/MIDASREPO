      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Balance MUSERZZ with MUSERDD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM001074 - Balance MUSERZZ with MUSERDD                      *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CUP034  *CREATE    Date 21Dec06               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP034 - MidasPlus user data migration.                      *
      *                                                               *
      *****************************************************************
      *
     FMUSERDD   IF   E             DISK    INFSR(*PSSR)
      *
     FMUSERZZ   UF A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(ZZ)
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  SWSID                244    253
     D  SUSER                254    263
      *
     D NoOfRecords     S              5  0 INZ(0)
 
     C     1             SETLL     MUSERDD
     C                   READ      MUSERDD
      *
     C                   DOW       NOT(%EOF)
      *
     C                   IF        RECI = 'D'
     C                   EVAL      NoOfRecords = NoOfRecords +1
     C                   ENDIF
      *
     C                   READ      MUSERDD
      *
     C                   ENDDO
      *
     C     1             SETLL     MUSERZZ
     C                   READ      MUSERZZ
      *
     C                   EVAL      ZZNORE = NoOfRecords
     C                   IF        %EOF
     C                   EVAL      ZZRECI = 'Z'
     C                   WRITE     MUSERZZF
     C                   ELSE
     C                   UPDATE    MUSERZZF
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      ********************************************************************
      *  *PSSR Subroutine - Error handling                               *
      ********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
