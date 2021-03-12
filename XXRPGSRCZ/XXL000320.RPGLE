     H DEBUG
     H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2008')**                       LUC109
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')                         LUC109
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Extract of Version of SDDEALPD to match xxINTFLIB')    *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      ***DEL000320*-*Extract*of*Version*of*SDDEALPD*to*match*xxINTFLIB*                       LUC109
      *  XXL000320 - Extract of Version of SDDEALPD to match xxINTFLIB*                       LUC109
      *                                                               *
      *  Function:  This program will extract data to the version of  *
      *             SDDEALPD that matches that in xxINTFLIB.          *
      *                                                               *
      ***Called*By:*DELC000320*****************************************                       LUC109
      *  Called By: XXLC000320                                        *                       LUC109
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
 
     FSDDEALPD  IF   E           K DISK    INFSR(*PSSR) COMMIT
     F***DESDDEALPPO    E           K DISK    INFSR(*PSSR) COMMIT                             LUC109
     F**********                           RENAME(SDDEALD0:DESDDEALD0)                        LUC109
     FXXSDDEALPPO    E           K DISK    INFSR(*PSSR) COMMIT                                LUC109
     F                                     RENAME(SDDEALD0:XXSDDEALD0)                        LUC109
 
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
 
     ISDDEALD0
     I              BNACCD                      @BNACCD
     I              BNFRPL                      @BNFRPL
     I              BNFTAC                      @BNFTAC
     I              BNSWTA                      @BNSWTA
     I              BNBTCD                      @BNBTCD
     I              BNBUCD                      @BNBUCD
     I              BNNEAC                      @BNNEAC
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
     C                   READ(E)   SDDEALPD
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVEL     @BNACCD       BNACCD
     C                   MOVEL     @BNFRPL       BNFRPL
     C                   MOVEL     @BNFTAC       BNFTAC
     C                   MOVEL     @BNSWTA       BNSWTA
     C                   MOVEL     @BNBTCD       BNBTCD
     C                   MOVEL     @BNBUCD       BNBUCD
     C                   MOVEL     @BNNEAC       BNNEAC
 
      * Write to Extract File
     C**********         WRITE     DESDDEALD0                                                 LUC109
     C                   WRITE     XXSDDEALD0                                                 LUC109
     C                   COMMIT
 
      * Read next record from MidasPlus File
     C                   READ(E)   SDDEALPD
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
