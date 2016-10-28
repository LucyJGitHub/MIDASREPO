     H DEBUG
     H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2008')**                       LUC109
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')                         LUC109
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Extract of Version of ACKEYAL to match xxINTFLIB')     *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      ***DEL000070*-*Extract*of*Version*of*ACKEYAL*to*match*xxINTFLIB**                       LUC109
      *  XXL000070 - Extract of Version of ACKEYAL to match xxINTFLIB *                       LUC109
      *                                                               *
      *  Function:  This program will extract data to the version of  *
      *             ACKEYAL that matches that in xxINTFLIB.           *
      *                                                               *
      ***Called*By:*DELC000070*****************************************                       LUC109
      *  Called By: XXLC000070                                        *                       LUC109
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
 
     FACKEYAL   IF   E           K DISK    INFSR(*PSSR) COMMIT
     F***DEACKEYLPPO    E           K DISK    INFSR(*PSSR) COMMIT                             LUC109
     F**********                           RENAME(ACKEYALF:DEACKEYALF)                        LUC109
     FXXACKEYLPPO    E           K DISK    INFSR(*PSSR) COMMIT                                LUC109
     F                                     RENAME(ACKEYALF:XXACKEYALF)                        LUC109
 
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
 
     IACKEYALF
     I              ACD1                        @ACD1
     I              ACD2                        @ACD2
     I              ACD3                        @ACD3
     I              ACD4                        @ACD4
     I              ACD5                        @ACD5
     I              ACD6                        @ACD6
     I              AKEY                        @AKEY                                         LUC109
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
     C                   READ(E)   ACKEYAL
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVEL     @ACD1         ACD1
     C                   MOVEL     @ACD2         ACD2
     C                   MOVEL     @ACD3         ACD3
     C                   MOVEL     @ACD4         ACD4
     C                   MOVEL     @ACD5         ACD5
     C                   MOVEL     @ACD6         ACD6
     C                   MOVEL     @AKEY         AKEY                                         LUC109
 
      * Write to Extract File
     C**********         WRITE     DEACKEYALF                                                 LUC109
     C                   WRITE     XXACKEYALF                                                 LUC109
     C                   COMMIT
 
      * Read next record from MidasPlus File
     C                   READ(E)   ACKEYAL
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
