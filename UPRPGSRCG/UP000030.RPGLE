     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*XBIA*  OVRDBF FILE(OVR1) TOFILE(UPACCPTPD)                          *
/*XBIB*  OVRDBF FILE(OVR2) TOFILE(UPACCPTPD)                          *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Build Action File for CMPBDA *ACCPTH')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000030 - Build Action File for UPACCPPD                    *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK025  *CREATE    Date 30May06               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK025 - New utility.                                        *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain - record not found
      *       69      Read, write or chain fail
      *       70 +    Indicators for changed fields
      *
     FOVR1      IF   E           K DISK    INFSR(*PSSR)
     FOVR2      IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(QWHFDACP:ACCPF) PREFIX(X)
     FUPACCPPD  O    E             DISK    INFSR(*PSSR)
      *
      /EJECT
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *
      *                                     134 141 DBFILE
      *       Defines:                      142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode             1
     C                   PARM                    PMissingFiles     4
      *
     C     KComp         KLIST
     C                   KFLD                    APFILE
     C                   KFLD                    APBOF
     C                   KFLD                    APBOLF
     C                   KFLD                    APKEYF
     C                   KFLD                    APKEYN
      *
     C     KPartial      KLIST
     C                   KFLD                    APFILE
      *
     C     *LOVAL        SETLL     QWHFDACP
     C                   READ      OVR1                                 6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      * Perform partial chain first to see if file has any matches.
     C     KPartial      CHAIN     ACCPF                              3069
      * If match not found ...
     C     *IN30         IFEQ      *ON
      * ... and if Missing Files requested ...
     C                   IF        PMissingFiles = '*YES'
      * ... set special Action Code ...
     C                   IF        PMode = 'I'
     C                   EVAL      APACTC = 'J'
     C                   ELSE
     C                   EVAL      APACTC = 'E'
     C                   ENDIF
      * ... write record ...
     C                   WRITE     UPACCPD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      * ... and skip to record for the next file.
     C     KPartial      SETGT     QWHFDACP
     C                   GOTO      READ
     C                   ENDIF
      *
     C     KComp         CHAIN     ACCPF                              3069
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If record not found then record has been deleted or added
      *  depending on mode.
     C     *IN30         IFEQ      *ON
     C                   MOVE      PMode         APACTC
     C                   WRITE     UPACCPD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      * Need to find differences but this should only be run once;
      *  run only if mode is 'Delete'.
     C     PMode         IFEQ      'D'
      *
      * If record found then look for any differences; only look in
      *  fields that have data all of the time.
     C     *IN30         IFEQ      *OFF
     C                   MOVE      'A'           APACTC
      *
      * Key sequence
     C     APKSEQ        IFNE      XAPKSEQ
     C                   SETON                                        70
     C                   ENDIF
      *
     C                   MOVEA     *IN(70)       INTEST            1
     C                   MOVE      INTEST        INTNUM            1 0
      * If any indicators are set on then write record.
     C     INTNUM        IFNE      0
     C                   WRITE     UPACCPD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Set values to write second record.
     C                   MOVEL     XAPKSEQ       APKSEQ
      *
     C                   WRITE     UPACCPD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      * Read next record
     C                   MOVEA     '0000000000'  *IN(70)
      *
     C     READ          TAG
     C                   READ      OVR1                                 6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
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
