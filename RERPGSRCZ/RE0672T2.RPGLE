     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Shadow Post Update - Copy Records')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE0672T2 - Midas RE Shadow Post Update - Copy Records        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CSC056  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC056 - COB Restructure - SC COB Optimisation Phase 1       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.  Use      *
      *  RESET for subsequent passes.                                 *
      *                                                               *
      *****************************************************************
 
     FRESPOIPD  UF A E           K DISK    COMMIT
      ** Task-split index file
 
     FRESPODPD  UF A E             DISK    COMMIT
      ** Task-split driver file, which follows RE0672 primary file
 
      /EJECT
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** Entry Parameters
     D NumRecPerTask   S             10P 0
     D TotRec          S                   LIKE( NumRecPerTask )
     D RtnCode         S              3A
 
      ** Declared variables and constants
     D PSSRDone        S              1N   INZ
     D True            C                   CONST( *ON )
     D False           C                   CONST( *OFF )
 
      /EJECT
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Retrieve the RRN of the last record allocated to a subtask
 
     C                   READ      RESPOIPD
 
      ** Save the starting RRN and the ending RRN of the block of
      ** data that is allocated for a sub-task
 
     C     1             CHAIN     RESPODPD
     C                   EVAL      SPSRRN = SPLRRN + 1
     C                   EVAL      SPERRN = SPLRRN + NumRecPerTask
 
     C                   IF        %FOUND( RESPODPD )
     C                   UPDATE    RESPODP0
     C                   ELSE
     C                   WRITE     RESPODP0
     C                   ENDIF
 
      ** Update the last RRN
 
     C                   EVAL      SPLRRN = SPERRN
 
     C                   IF        %EOF( RESPOIPD )
     C                   WRITE     RESPOIP0
     C                   ELSE
     C                   UPDATE    RESPOIP0
     C                   ENDIF
 
      ** Return 'EOF' if primary file has been exhausted
 
     C                   IF        SPERRN >= TotRec
     C                   EVAL      RtnCode = 'EOF'
     C                   ENDIF
 
      ** Normal termination
 
     C                   COMMIT
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    NumRecPerTask
     C                   PARM                    TotRec
     C                   PARM                    RtnCode
 
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
      * Called by: error-trapping routines                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        NOT PSSRDone
     C                   EVAL      PSSRDone = True
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
