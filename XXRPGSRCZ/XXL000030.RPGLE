     H DEBUG
     H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2008')**                       LUC109
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')                         LUC109
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Extract of Version of REIACD to match xxINTFLIB')      *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      ***DEL000030*-*Extract*of*Version*of*REIACD*to*match*xxINTFLIB***                       LUC109
      *  XXL000030 - Extract of Version of REIACD to match xxINTFLIB  *                       LUC109
      *                                                               *
      *  Function:  This program will extract data to the version of  *
      *             REIACD that matches that in xxINTFLIB.            *
      *                                                               *
      ***Called*By:*DELC000030*****************************************                       LUC109
      *  Called By: XXLC000030                                        *                       LUC109
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
 
     FREIACD    IF   E           K DISK    INFSR(*PSSR) COMMIT
     F***DEREIACDPPO    E           K DISK    INFSR(*PSSR) COMMIT                             LUC109
     F**********                           RENAME(REIACDF:DEREIACDF)                          LUC109
     FXXREIACDPPO    E           K DISK    INFSR(*PSSR) COMMIT                                LUC109
     F                                     RENAME(REIACDF:XXREIACDF)                          LUC109
 
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
 
     IREIACDF
     I              ACOD                        @ACOD
     I              DACP                        @DACP
     I              CACP                        @CACP
     I              CHAC                        @CHAC
     I              CNUM                        @CNUM                                         LUC109
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
     C                   READ(E)   REIACD
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   MOVEL     @ACOD         ACOD
 
     C                   IF        %SUBST(@DACP:21:1) <> ' '
     C                   EVAL      DACP = %SUBST(@DACP:1:9) + %SUBST(@DACP:10:4)
     C                                                      + %SUBST(@DACP:20:2)
     C                   ELSE
     C                   MOVEL     @DACP         DACP
     C                   ENDIF
 
     C                   IF        %SUBST(@CACP:21:1) <> ' '
     C                   EVAL      CACP = %SUBST(@CACP:1:9) + %SUBST(@CACP:10:4)
     C                                                      + %SUBST(@CACP:20:2)
     C                   ELSE
     C                   MOVEL     @CACP         CACP
     C                   ENDIF
 
     C                   IF        %SUBST(@CHAC:21:1) <> ' '
     C                   EVAL      CHAC = %SUBST(@CHAC:1:9) + %SUBST(@CHAC:10:4)
     C                                                      + %SUBST(@CHAC:20:2)
     C                   ELSE
     C                   MOVEL     @CHAC         CHAC
     C                   ENDIF
 
     C                   MOVEL     @CNUM         CNUM                                         LUC109
      *                                                                                       LUC109
      * Write to Extract File
     C**********         WRITE     DEREIACDF                                                  LUC109
     C                   WRITE     XXREIACDF                                                  LUC109
     C                   COMMIT
 
      * Read next record from MidasPlus File
     C                   READ(E)   REIACD
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
