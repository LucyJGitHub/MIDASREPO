     H DEBUG
     H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2008')**                       LUC109
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')                         LUC109
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Extract of Version of SDCURRPD to match xxINTFLIB')    *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      ***DEL000300*-*Extract*of*Version*of*SDCURRPD*to*match*xxINTFLIB*                       LUC109
      *  XXL000300 - Extract of Version of SDCURRPD to match xxINTFLIB*                       LUC109
      *                                                               *
      *  Function:  This program will extract data to the version of  *
      *             SDCURRPD that matches that in xxINTFLIB.          *
      *                                                               *
      ***Called*By:*DELC000300*****************************************                       LUC109
      *  Called By: XXLC000300                                        *                       LUC109
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
 
     FSDCURRPD  IF   E           K DISK    INFSR(*PSSR) COMMIT
     F***DESDCURRPPO    E           K DISK    INFSR(*PSSR) COMMIT                             LUC109
     F**********                           RENAME(SDCURRD0:DESDCURRD0)                        LUC109
     FXXSDCURRPPO    E           K DISK    INFSR(*PSSR) COMMIT                                LUC109
     F                                     RENAME(SDCURRD0:XXSDCURRD0)                        LUC109
 
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
 
     ISDCURRD0
     I              A6SPAE                      @A6SPAE
     I              A6FTAE                      @A6FTAE
     I              A6SWAE                      @A6SWAE
     I              A6TAC4                      @A6TAC4
     I              A6TAC5                      @A6TAC5
     I              A6CSCD                      @A6CSCD
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
     C                   READ(E)   SDCURRPD
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVEL     @A6SPAE       A6SPAE
     C                   MOVEL     @A6FTAE       A6FTAE
     C                   MOVEL     @A6SWAE       A6SWAE
     C                   MOVEL     @A6TAC4       A6TAC4
     C                   MOVEL     @A6TAC5       A6TAC5
     C                   MOVEL     @A6CSCD       A6CSCD
 
      * Write to Extract File
     C**********         WRITE     DESDCURRD0                                                 LUC109
     C                   WRITE     XXSDCURRD0                                                 LUC109
     C                   COMMIT
 
      * Read next record from MidasPlus File
     C                   READ(E)   SDCURRPD
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
