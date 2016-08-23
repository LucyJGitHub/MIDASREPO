     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*XBIA*  OVRDBF FILE(OVR1) TOFILE(UPJOINTPD)                          *
/*XBIB*  OVRDBF FILE(OVR2) TOFILE(UPJOINTPD)                          *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Build Action File for CMPBDA *JOIN')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000036 - Build Action File for UPJOINPD                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025  *CREATE    Date 30May06               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
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
     F                                     RENAME(QWHFDJN:JOINF) PREFIX(X)
     FUPJOINPD  O    E             DISK    INFSR(*PSSR)
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
     C                   KFLD                    JNFILE
     C                   KFLD                    JNNSPC
     C                   KFLD                    JNDIAL
     C                   KFLD                    JNDNAM
     C                   KFLD                    JNJFRM
     C                   KFLD                    JNJFNM
     C                   KFLD                    JNJTO
     C                   KFLD                    JNJTNM
     C                   KFLD                    JNJFD1
     C                   KFLD                    JNJFD2
     C                   KFLD                    JNJDSQ
      *
     C     KPartial      KLIST
     C                   KFLD                    JNFILE
      *
     C     *LOVAL        SETLL     QWHFDJN
     C                   READ      OVR1                                 6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      * Perform partial chain first to see if file has any matches.
     C     KPartial      CHAIN     JOINF                              3069
      * If match not found ...
     C     *IN30         IFEQ      *ON
      * ... and if Missing Files requested ...
     C                   IF        PMissingFiles = '*YES'
      * ... set special Action Code ...
     C                   IF        PMode = 'I'
     C                   EVAL      JNACTC = 'J'
     C                   ELSE
     C                   EVAL      JNACTC = 'E'
     C                   ENDIF
      * ... write record ...
     C                   WRITE     UPJOIND0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      * ... and skip to record for the next file.
     C     KPartial      SETGT     QWHFDJN
     C                   GOTO      READ
     C                   ENDIF
      *
     C     KComp         CHAIN     JOINF                              3069
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If record not found then record has been deleted or added
      *  depending on mode.
     C     *IN30         IFEQ      *ON
     C                   MOVE      PMode         JNACTC
     C                   WRITE     UPJOIND0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
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
