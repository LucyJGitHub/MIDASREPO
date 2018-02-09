     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Initialization Program for CRE075')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000004 - Midas GL Initialization Program for CRE075        *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2011            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CRE075  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *****************************************************************
      *
     FACCNTAB   UF   E             DISK    INFSR(*PSSR)
      **  Main account details
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** | Named constants                      |
      ** | ===============                      |
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     1             SETLL     ACCNTAB
     C                   READ      ACCNTAB
     C                   DOW       NOT %EOF(ACCNTAB)
      *
      **  Only process if account is a retail account
      *
     C                   IF        ATYP = 'R' AND RECI = 'D' AND
     C                             ACEFDT = 0
 
     C                   EVAL      ACEFDT = DACO
 
     C                   UPDATE    ACCNTABF
 
     C                   ENDIF
 
     C                   READ      ACCNTAB
     C                   ENDDO
      *
      **  End program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
