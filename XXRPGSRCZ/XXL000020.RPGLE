     H DEBUG
     H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2008')**                       LUC109
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')                         LUC109
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Extract of Version of CLOANCK to match xxINTFLIB')     *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      ***DEL000020*-*Extract*of*Version*of*CLOANCK*to*match*xxINTFLIB**                       LUC109
      *  XXL000020 - Extract of Version of CLOANCK to match xxINTFLIB *                       LUC109
      *                                                               *
      *  Function:  This program will extract data to the version of  *
      *             CLOANCK that matches that in xxINTFLIB.           *
      *                                                               *
      ***Called*By:*DELC000020*****************************************                       LUC109
      *  Called By: XXLC000020                                        *                       LUC109
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
 
     FCLOANCK   IF   E           K DISK    INFSR(*PSSR) COMMIT
     F***DECLOANKPPO    E           K DISK    INFSR(*PSSR) COMMIT                             LUC109
     F**********                           RENAME(CLOANCKF:DECLOANCKF)                        LUC109
     FXXCLOANKPPO    E           K DISK    INFSR(*PSSR) COMMIT                                LUC109
     F                                     RENAME(CLOANCKF:XXCLOANCKF)                        LUC109
 
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
 
     ICLOANCKF
     I              ORVD                        @ORVD
     I              RRON                        @RRON
     I              RPON                        @RPON
     I              RPOS                        @RPOS
     I              LNRF                        @LNRF                                         LUC109
     I              RROB                        @RROB                                         LUC109
     I              RROC                        @RROC                                         LUC109
     I              RPOB                        @RPOB                                         LUC109
     I              RPOC                        @RPOC                                         LUC109
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
     C                   READ(E)   CLOANCK
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   IF        %SUBST(@ORVD:18:1) <> ' '
     C                   EVAL      ORVD = %SUBST(@ORVD:1:6) + %SUBST(@ORVD:7:4)
     C                                                      + %SUBST(@ORVD:17:2)
     C                   ELSE
     C                   MOVEL     @ORVD         ORVD
     C                   ENDIF
 
     C                   IF        %SUBST(@RRON:18:1) <> ' '
     C                   EVAL      RRON = %SUBST(@RRON:1:6) + %SUBST(@RRON:7:4)
     C                                                      + %SUBST(@RRON:17:2)
     C                   ELSE
     C                   MOVEL     @RRON         RRON
     C                   ENDIF
 
     C                   IF        %SUBST(@RPON:18:1) <> ' '
     C                   EVAL      RPON = %SUBST(@RPON:1:6) + %SUBST(@RPON:7:4)
     C                                                      + %SUBST(@RPON:17:2)
     C                   ELSE
     C                   MOVEL     @RPON         RPON
     C                   ENDIF
 
     C                   IF        %SUBST(@RPOS:18:1) <> ' '
     C                   EVAL      RPOS = %SUBST(@RPOS:1:6) + %SUBST(@RPOS:7:4)
     C                                                      + %SUBST(@RPOS:17:2)
     C                   ELSE
     C                   MOVEL     @RPOS         RPOS
     C                   ENDIF
 
     C                   MOVEL     @LNRF         LNRF                                         LUC109
     C                   MOVEL     @RROB         RROB                                         LUC109
     C                   MOVEL     @RROC         RROC                                         LUC109
     C                   MOVEL     @RPOB         RPOB                                         LUC109
     C                   MOVEL     @RPOC         RPOC                                         LUC109
      *                                                                                       LUC109
      * Write to Extract File
     C**********         WRITE     DECLOANCKF                                                 LUC109
     C                   WRITE     XXCLOANCKF                                                 LUC109
     C                   COMMIT
 
      * Read next record from MidasPlus File
     C                   READ(E)   CLOANCK
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
