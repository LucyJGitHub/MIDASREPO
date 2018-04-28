     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UTC000001R) TOFILE(UPMBRLTPD)                    *
/*XBIB*  OVRDBF FILE(UTC000001C) TOFILE(UPMBRLTPD)                    *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Create summary file for CMPSRC')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000004 - Create summary file about compares.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 20067           *
      *                                                               *
      *  Last Amend No. BUG27884 *CREATE   Date 08Jul10               *
      *  Prev Amend No. CUT010             Date 10May07               *
      *                 xxxxxx             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BUG27884 - Applied CUT010.                                   *
      *  CUT010 - New utility.                                        *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
     FUTC000001RUF A E           K DISK    RENAME(QWHFDML:RMBRL)
     F                                     PREFIX(R)
     FUTC000001CUF   E           K DISK    RENAME(QWHFDML:CMBRL)
     F                                     PREFIX(C)
      *
      /EJECT
      *
     D KFile           S             10
     D KMember         S             10
      *
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
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     C     KSrcMember    KLIST
     C                   KFLD                    KFile
     C                   KFLD                    KMember
      *
      * Read records for Reference file.
     C     *LOVAL        SETLL     RMBRL
     C                   READ      RMBRL
      *
     C                   DOW       NOT(%EOF)
      *
     C                   EVAL      KFile = RMLFILE
     C                   EVAL      KMember = RMLNAME
      * Check if member exists on Comparison file and update the Reference
      *  file accordingly ...
     C     KSrcMember    CHAIN     CMBRL
     C                   IF        %FOUND
     C                   EVAL      RMLRDAT = 'REFCMP'
     C                   EVAL      RMLSIZE = CMLNRCD
      * ... and delete from Comaparison file.
     C                   DELETE    CMBRL
     C                   ELSE
     C                   EVAL      RMLRDAT = 'NOTCMP'
     C                   ENDIF
     C                   UPDATE    RMBRL
      *
     C                   READ      RMBRL
      *
     C                   ENDDO
      *
      * Read through what is left in the Comparison file.
     C     *LOVAL        SETLL     CMBRL
     C                   READ      CMBRL
      *
     C                   DOW       NOT(%EOF)
     C                   EVAL      KFile = CMLFILE
      * Check if source file exists in Reference file; if it doesn't then
      *  ignore it.
     C     KFile         CHAIN     RMBRL
     C                   IF        %FOUND
      * Update records and write to the Reference File.
     C                   EVAL      RMLFILE = CMLFILE
     C                   EVAL      RMLNAME = CMLNAME
     C                   EVAL      RMLNRCD = CMLNRCD
     C                   EVAL      RMLRDAT = 'NOTREF'
     C                   WRITE     RMBRL
     C                   ENDIF
      *
     C                   READ      CMBRL
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
