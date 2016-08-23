      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Balance MUSERZZ with MUSERDD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM001074 - Balance MUSERZZ with MUSERDD                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CUP034  *CREATE    Date 21Dec06               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
