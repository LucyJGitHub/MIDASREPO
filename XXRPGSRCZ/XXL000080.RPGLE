     H DEBUG
     H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2008')**                       LUC109
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')                         LUC109
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Extract of Version of CLOANCL to match xxINTFLIB')     *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      ***DEL000080*-*Extract*of*Version*of*CLOANCL*to*match*xxINTFLIB**                       LUC109
      *  XXL000080 - Extract of Version of CLOANCL to match xxINTFLIB *                       LUC109
      *                                                               *
      *  Function:  This program will extract data to the version of  *
      *             CLOANCL that matches that in xxINTFLIB.           *
      *                                                               *
      ***Called*By:*DELC000080*****************************************                       LUC109
      *  Called By: XXLC000080                                        *                       LUC109
      *                                                               *
      ***(c) Misys*International*Banking*Systems*Ltd.*2008*************                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 09Sep16               *
      *  Prev Amend No. LUC013  *CREATE    Date 01May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  LUC013 - Head Office Reporting Upgrade to MidasPlus          *
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
 
     FCLOANCL   IF   E           K DISK    INFSR(*PSSR) COMMIT
     F***DECLOANLPPO    E           K DISK    INFSR(*PSSR) COMMIT                             LUC109
     F**********                           RENAME(CLOANCLF:DECLOANCLF)                        LUC109
     FXXCLOANLPPO    E           K DISK    INFSR(*PSSR) COMMIT                                LUC109
     F                                     RENAME(CLOANCLF:XXCLOANCLF)                        LUC109
 
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
 
     ICLOANCLF
     I              OSDA                        @OSDA
     I              OMDA                        @OMDA
     I              RONS                        @RONS
     I              PONS                        @PONS
     I              LNRF                        @LNRF                                         LUC109
     I              CNUM                        @CNUM                                         LUC109
     I              FCUS                        @FCUS                                         LUC109
     I              MLNR                        @MLNR                                         LUC109
     I              OLNO                        @OLNO                                         LUC109
     I              COCU                        @COCU                                         LUC109
     I              RECE                        @RECE                                         LUC109
     I              ROBN                        @ROBN                                         LUC109
     I              ROCN                        @ROCN                                         LUC109
     I              POBN                        @POBN                                         LUC109
     I              POCN                        @POCN                                         LUC109
     I              PTFC                        @PTFC                                         LUC109
     I              TOLN                        @TOLN                                         LUC109
      *****************************************************************
      /EJECT
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
 
      * Read first record from MidasPlus File
     C                   READ(E)   CLOANCL
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   IF        %SUBST(@OSDA:18:1) <> ' '
     C                   EVAL      OSDA = %SUBST(@OSDA:1:6) + %SUBST(@OSDA:7:4)
     C                                                      + %SUBST(@OSDA:17:2)
     C                   ELSE
     C                   MOVEL     @OSDA         OSDA
     C                   ENDIF
 
     C                   IF        %SUBST(@OMDA:18:1) <> ' '
     C                   EVAL      OMDA = %SUBST(@OMDA:1:6) + %SUBST(@OMDA:7:4)
     C                                                      + %SUBST(@OMDA:17:2)
     C                   ELSE
     C                   MOVEL     @OMDA         OMDA
     C                   ENDIF
 
     C                   IF        %SUBST(@RONS:18:1) <> ' '
     C                   EVAL      RONS = %SUBST(@RONS:1:6) + %SUBST(@RONS:7:4)
     C                                                      + %SUBST(@RONS:17:2)
     C                   ELSE
     C                   MOVEL     @RONS         RONS
     C                   ENDIF
 
     C                   IF        %SUBST(@PONS:18:1) <> ' '
     C                   EVAL      PONS = %SUBST(@PONS:1:6) + %SUBST(@PONS:7:4)
     C                                                      + %SUBST(@PONS:17:2)
     C                   ELSE
     C                   MOVEL     @PONS         PONS
     C                   ENDIF
 
     C                   MOVEL     @LNRF         LNRF                                         LUC109
     C                   MOVEL     @CNUM         CNUM                                         LUC109
     C                   MOVEL     @FCUS         FCUS                                         LUC109
     C                   MOVEL     @MLNR         MLNR                                         LUC109
     C                   MOVEL     @OLNO         OLNO                                         LUC109
     C                   MOVEL     @COCU         COCU                                         LUC109
     C                   MOVEL     @RECE         RECE                                         LUC109
     C                   MOVEL     @ROBN         ROBN                                         LUC109
     C                   MOVEL     @ROCN         ROCN                                         LUC109
     C                   MOVEL     @POBN         POBN                                         LUC109
     C                   MOVEL     @POCN         POCN                                         LUC109
     C                   MOVEL     @PTFC         PTFC                                         LUC109
     C                   MOVEL     @TOLN         TOLN                                         LUC109
      *
      * Write to Extract File
     C**********         WRITE     DECLOANCLF                                                 LUC109
     C                   WRITE     XXCLOANCLF                                                 LUC109
     C                   COMMIT
 
      * Read next record from MidasPlus File
     C                   READ(E)   CLOANCL
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
