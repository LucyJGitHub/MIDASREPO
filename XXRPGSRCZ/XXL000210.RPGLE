     H DEBUG
     H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2008')**                       LUC109
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')                         LUC109
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Extract of Version of INPAYDD to match xxINTFLIB')     *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      ***DEL000210*-*Extract*of*Version*of*INPAYDD*to*match*xxINTFLIB**                       LUC109
      *  XXL000210 - Extract of Version of INPAYDD to match xxINTFLIB *                       LUC109
      *                                                               *
      *  Function:  This program will extract data to the version of  *
      *             INPAYDD that matches that in xxINTFLIB.           *
      *                                                               *
      ***Called*By:*DELC000210*****************************************                       LUC109
      *  Called By: XXLC000210                                        *                       LUC109
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
 
     FINPAYDD   IF   E           K DISK    INFSR(*PSSR) COMMIT
     F***DEINPAYPP O    E           K DISK    INFSR(*PSSR) COMMIT                             LUC109
     F**********                           RENAME(INPAYDDF:DEINPAYDDF)                        LUC109
     FXXINPAYPP O    E           K DISK    INFSR(*PSSR) COMMIT                                LUC109
     F                                     RENAME(INPAYDDF:XXINPAYDDF)                        LUC109
 
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
     D WA12            S             12
     D WA18            S             18
 
     IINPAYDDF
     I              ACBK                        @ACBK
     I              CDRO                        @CDRO
     I              RCCO                        @RCCO                                         LUC109
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
     C                   READ(E)   INPAYDD
 
     C                   DOW       NOT %EOF
      * Convert Data fields
     C                   IF        %SUBST(@ACBK:18:1) <> ' '
     C                   EVAL      ACBK = %SUBST(@ACBK:1:6) + %SUBST(@ACBK:7:4)
     C                                                      + %SUBST(@ACBK:17:2)
     C                   ELSE
     C                   MOVEL     @ACBK         ACBK
     C                   ENDIF
 
     C                   MOVEL     @CDRO         WA18
 
     C                   IF        %SUBST(WA18:17:2) <> '00'
     C                   EVAL      WA12 = %SUBST(WA18:1:6) + %SUBST(WA18:7:4)
     C                                                     + %SUBST(WA18:17:2)
     C                   ELSE
     C                   MOVEL     WA18          WA12
     C                   ENDIF
 
     C                   MOVEL     WA12          CDRO
     C                   MOVEL     @RCCO         RCCO                                         LUC109
 
      * Write to Extract File
     C**********         WRITE     DEINPAYDDF                                                 LUC109
     C                   WRITE     XXINPAYDDF                                                 LUC109
     C                   COMMIT
 
      * Read next record from MidasPlus File
     C                   READ(E)   INPAYDD
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
