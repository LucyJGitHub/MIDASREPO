     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Match xxINTFLIB for header/trailer files FBM')         *
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      *  XXL000380 - Match XXINTFLIB for header/trailer files FBM     *
      *                                                               *
      *  Function:  This program will extract data to the version of  *
      *             header/trailer files that match xxINTFLIB.        *
      *                                                               *
      *  Called By: XXLC000380                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC109             Date 12Sep16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Date Format                                     *
      *    U7+U8      Database Errors                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FACCNTAA   IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXACCNTAA O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(ACCNTAAF:XXACCNTAAF)
 
     FACCNTAC   IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXACCNTAC O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(ACCNTACF:XXACCNTACF)
 
     FDEALSDA   IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXDEALSDA O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(DEALSDAF:XXDEALSDAF)
 
     FDEALSDF   IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXDEALSDF O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(DEALSDFF:XXDEALSDFF)
 
     FFCLTYHH   IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXFCLTYHH O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(FCLTYHHF:XXFCLTYHHF)
 
     FFCLTYZZ   IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXFCLTYZZ O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(FCLTYZZF:XXFCLTYZZF)
 
     FREIACA    IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXREIACA  O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(REIACAF:XXREIACAF)
 
     FREIACZ    IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXREIACZ  O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(REIACZF:XXREIACZF)
 
     FMCLONHH   IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXMCLONHH O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(CLOANHHF:XXCLOANHHF)
 
     FMCLONZ1   IF   E           K DISK    INFSR(*PSSR) COMMIT
     FXXMCLONZ1 O    E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(CLOANZ1F:XXCLOANZ1F)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
     D @RUN            S              1
 
     IACCNTAAF
     I              CNUM                        @CNUM
     I              ACOD                        @ACOD
 
     IACCNTACF
     I              CNUM                        @CNUM
     I              ACOD                        @ACOD
 
     IDEALSDAF
     I              CNUM                        @CNUM
 
     IDEALSDFF
     I              CNUM                        @CNUM
 
     IFCLTYHHF
     I              CNUM                        @CNUM
 
     IFCLTYZZF
     I              CNUM                        @CNUM
 
     IREIACAF
     I              CNUM                        @CNUM
     I              ACOD                        @ACOD
 
     IREIACZF
     I              CNUM                        @CNUM
     I              ACOD                        @ACOD
 
     ICLOANHHF
     I              LNRF                        @LNRF
 
     ICLOANZ1F
     I              LNRF                        @LNRF
 
      *****************************************************************
      /EJECT
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
 
      *
      * Read first record from FBM ACCNTAA file
      *                            -------
     C                   READ(E)   ACCNTAA
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @CNUM         CNUM
     C                   MOVEL     @ACOD         ACOD
 
      * Write to Extract File
     C                   WRITE     XXACCNTAAF
     C                   COMMIT
 
     C                   READ(E)   ACCNTAA
     C                   ENDDO
      *
      * Read first record from FBM ACCNTAC file
      *                            -------
     C                   READ(E)   ACCNTAC
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @CNUM         CNUM
     C                   MOVEL     @ACOD         ACOD
 
      * Write to Extract File
     C                   WRITE     XXACCNTACF
     C                   COMMIT
 
     C                   READ(E)   ACCNTAC
     C                   ENDDO
      *
      * Read first record from FBM DEALSDA file
      *                            -------
     C                   READ(E)   DEALSDA
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @CNUM         CNUM
 
      * Write to Extract File
     C                   WRITE     XXDEALSDAF
     C                   COMMIT
 
     C                   READ(E)   DEALSDA
     C                   ENDDO
      *
      * Read first record from FBM DEALSDF file
      *                            -------
     C                   READ(E)   DEALSDF
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @CNUM         CNUM
 
      * Write to Extract File
     C                   WRITE     XXDEALSDFF
     C                   COMMIT
 
     C                   READ(E)   DEALSDF
     C                   ENDDO
      *
      * Read first record from FBM FCLTYHH file
      *                            -------
     C                   READ(E)   FCLTYHH
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @CNUM         CNUM
 
      * Write to Extract File
     C                   WRITE     XXFCLTYHHF
     C                   COMMIT
 
     C                   READ(E)   FCLTYHH
     C                   ENDDO
      *
      * Read first record from FBM FCLTYZZ file
      *                            -------
     C                   READ(E)   FCLTYZZ
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @CNUM         CNUM
 
      * Write to Extract File
     C                   WRITE     XXFCLTYZZF
     C                   COMMIT
 
     C                   READ(E)   FCLTYZZ
     C                   ENDDO
      *
      * Read first record from FBM REIACA  file
      *                            ------
     C                   READ(E)   REIACA
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @CNUM         CNUM
     C                   MOVEL     @ACOD         ACOD
 
      * Write to Extract File
     C                   WRITE     XXREIACAF
     C                   COMMIT
 
     C                   READ(E)   REIACA
     C                   ENDDO
      *
      * Read first record from FBM REIACZ  file
      *                            ------
     C                   READ(E)   REIACZ
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @CNUM         CNUM
     C                   MOVEL     @ACOD         ACOD
 
      * Write to Extract File
     C                   WRITE     XXREIACZF
     C                   COMMIT
 
     C                   READ(E)   REIACZ
     C                   ENDDO
      *
      * Read first record from FBM MCLONHH file
      *                            -------
     C                   READ(E)   MCLONHH
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @LNRF         LNRF
 
      * Write to Extract File
     C                   WRITE     XXCLOANHHF
     C                   COMMIT
 
     C                   READ(E)   MCLONHH
     C                   ENDDO
      *
      * Read first record from FBM MCLONZ1 file
      *                            -------
     C                   READ(E)   MCLONZ1
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVE      @LNRF         LNRF
 
      * Write to Extract File
     C                   WRITE     XXCLOANZ1F
     C                   COMMIT
 
     C                   READ(E)   MCLONZ1
     C                   ENDDO
 
     C                   Eval      *INLR = *ON
     C                   Return
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   ENDSR
 
      *****************************************************************
      *
      /EJECT
 
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *
      /EJECT
