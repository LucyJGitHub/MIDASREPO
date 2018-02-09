     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*XBIA*  OVRDBF FILE(OVR1) TOFILE(UPSLCTTPD)                          *
/*XBIB*  OVRDBF FILE(OVR2) TOFILE(UPSLCTTPD)                          *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Build Action File for CMPBDA *SELECT')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000040 - Build Action File for UPSLCTPD                    *
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
      *
     FOVR1      IF   E           K DISK    INFSR(*PSSR)
     FOVR2      IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(QWHFDSO:SLCTF) PREFIX(X)
     FUPSLCTPD  O    E             DISK    INFSR(*PSSR)
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
     C                   KFLD                    SOFILE
     C                   KFLD                    SORFMT
     C                   KFLD                    SOFLD
     C                   KFLD                    SORULE
     C                   KFLD                    SOCOMP
     C                   KFLD                    SOVALU
      *
     C     KPartial      KLIST
     C                   KFLD                    SOFILE
      *
     C     *LOVAL        SETLL     QWHFDSO
     C                   READ      OVR1                                 6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      * Perform partial chain first to see if file has any matches.
     C     KPartial      CHAIN     SLCTF                              3069
      * If match not found ...
     C     *IN30         IFEQ      *ON
      * ... and if Missing Files requested ...
     C                   IF        PMissingFiles = '*YES'
      * ... set special Action Code ...
     C                   IF        PMode = 'I'
     C                   EVAL      SOACTC = 'J'
     C                   ELSE
     C                   EVAL      SOACTC = 'E'
     C                   ENDIF
      * ... write record ...
     C                   WRITE     UPSLCTD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      * ... and skip to record for the next file.
     C     KPartial      SETGT     QWHFDSO
     C                   GOTO      READ
     C                   ENDIF
      *
     C     KComp         CHAIN     SLCTF                              3069
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If record not found then record has been deleted or added
      *  depending on mode.
     C     *IN30         IFEQ      *ON
     C                   MOVE      PMode         SOACTC
      * Do not write record if there are no selection criteria.
     C                   IF        SONVAL <> 0
     C                   WRITE     UPSLCTD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
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
