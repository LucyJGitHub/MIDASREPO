     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Housekeeping of Passbook Printing Files')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004608 - Midas GL Housekeeping of Passbook Printing Files  *
      *                                                               *
      *  Function:  This program housekeep files intrduced by         *
      *             BankFusion Midas Teller Passbook Printing         *
      *                                                               *
      *  Called By: GLC004608 - Housekeeping of Passbook Printing File*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CRE072 *CREATE     Date 30Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE072 - BankFusion Midas Teller Related Changes             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    nn         Function of Indicator                           *
      *    10         bit 3 of pay recieve indicator is ON            *
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
      ** Midas GL Passbook Unprinted Account Movements
     FGLPUAMPD  UF   E             DISK    INFSR(*PSSR)
      *
      ** Midas RE Passbook Printing Status File
     FREPPSTPD  UF   E             DISK    INFSR(*PSSR)
      *
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRun            S              1A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Housekeep Passbook Unprinted Account Movements
      *
     C                   EXSR      SrHKGLPUAM
      *
      ** Housekeep Passbook Printing Status File
      *
     C                   EXSR      SrHKREPPST
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrHKREPPST - Subroutine to housekeep REPPSTPD                *
      *                                                               *
      *****************************************************************
     C     SrHKREPPST    BEGSR
      *
     C     1             SETLL     REPPSTPD
     C                   READ      REPPSTPD
      *
     C                   DOW       NOT %EOF(REPPSTPD)
      *
      ** If the record is printed / Passbook Printed Flag is 'Y'
      ** It is to be deleted else it is to be kept
      *
     C                   IF        PPPRFL = 'Y'
     C                   DELETE    REPPSTPD
     C                   ENDIF
      *
     C                   READ      REPPSTPD
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrHKGLPUAM - Subroutine to housekeep GLPUAMPD                *
      *                                                               *
      *****************************************************************
     C     SrHKGLPUAM    BEGSR
      *
     C     1             SETLL     GLPUAMPD
     C                   READ      GLPUAMPD
      *
     C                   DOW       NOT %EOF(GLPUAMPD)
      *
      ** If the record is printed / bit 3 of pay recieve indicator is ON
      ** It is to be deleted else it is to be kept
      *
     C                   TESTB     '3'           PRIN                     10
     C                   IF        *IN10 = *ON
     C                   DELETE    GLPUAMPD
     C                   ENDIF
      *
     C                   READ      GLPUAMPD
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
