     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*XBIA*  OVRDBF FILE(OVR1) TOFILE(UPFFDSTPD)                          *
/*XBIB*  OVRDBF FILE(OVR2) TOFILE(UPFFDSTPD)                          *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Build Action File for CMPBDA *FIELD')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000034 - Build Action File for UPFFDSPD                    *
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
     F                                     RENAME(QWHDRFFD:FFDSF) PREFIX(X)
     FUPFFDSPD  O    E             DISK    INFSR(*PSSR)
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
     C                   PARM                    PUserData        10
      *
     C     KComp         KLIST
     C                   KFLD                    WHFILE
     C                   KFLD                    WHNAME
     C                   KFLD                    WHFLDE
      *
     C     KPartial      KLIST
     C                   KFLD                    WHFILE
      *
     C     *LOVAL        SETLL     QWHDRFFD
     C                   READ      OVR1                                 6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      * Perform partial chain first to see if file has any matches.
     C     KPartial      CHAIN     FFDSF                              3069
      * If match not found ...
     C     *IN30         IFEQ      *ON
      * ... and if Missing Files requested ...
     C                   IF        PMissingFiles = '*YES'
      * ... set special Action Code ...
     C                   IF        PMode = 'I'
     C                   EVAL      WHACTC = 'J'
     C                   ELSE
     C                   EVAL      WHACTC = 'E'
     C                   ENDIF
      * ... write record ...
     C                   WRITE     UPFFDSD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      * ... and skip to record for the next file.
     C     KPartial      SETGT     QWHDRFFD
     C                   GOTO      READ
     C                   ENDIF
      *
     C     KComp         CHAIN     FFDSF                              3069
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If record not found then record has been deleted or added
      *  depending on mode.
     C     *IN30         IFEQ      *ON
     C                   MOVE      PMode         WHACTC
     C                   WRITE     UPFFDSD0                             69
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
     C                   MOVE      'A'           WHACTC
      *
     C                   IF        PUserData = '*FIELD' or
     C                             PUserData = '*FLDATR'
      * Input buffer position
     C     WHIBO         IFNE      XWHIBO
     C                   SETON                                        70
     C                   ENDIF
      *
      * Field length
     C     WHFLDB        IFNE      WHFLDB
     C                   SETON                                        71
     C                   ENDIF
      *
      * Number of digits
     C     WHFLDD        IFNE      XWHFLDD
     C                   SETON                                        72
     C                   ENDIF
      *
      * Decimal positions
     C     WHFLDP        IFNE      XWHFLDP
     C                   SETON                                        73
     C                   ENDIF
      *
      * Field Type
     C     WHFLDT        IFNE      XWHFLDT
     C                   SETON                                        74
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        PUserData = '*FIELD' or
     C                             PUserData = '*FLDTXT'
      * Text
     C     WHFTXT        IFNE      XWHFTXT
     C                   SETON                                        75
     C                   ENDIF
      *
      * Column Heading 1
     C     WHCHD1        IFNE      XWHCHD1
     C                   SETON                                        76
     C                   ENDIF
      *
      * Column Heading 2
     C     WHCHD2        IFNE      XWHCHD2
     C                   SETON                                        77
     C                   ENDIF
      *
      * Column Heading 3
     C     WHCHD3        IFNE      XWHCHD3
     C                   SETON                                        78
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEA     *IN(70)       INTEST            9
     C                   MOVE      INTEST        INTNUM            9 0
      * If any indicators are set on then write record.
     C     INTNUM        IFNE      0
     C                   WRITE     UPFFDSD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Set values to write second record.
     C                   Z-ADD     XWHIBO        WHIBO
     C                   Z-ADD     XWHFLDB       WHFLDB
     C                   Z-ADD     XWHFLDD       WHFLDD
     C                   Z-ADD     XWHFLDP       WHFLDP
     C                   MOVEL     XWHFLDT       WHFLDT
     C                   MOVEL     XWHFTXT       WHFTXT
     C                   MOVEL     XWHCHD1       WHCHD1
     C                   MOVEL     XWHCHD2       WHCHD2
     C                   MOVEL     XWHCHD3       WHCHD3
      *
     C                   WRITE     UPFFDSD0                             69
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
