     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Shadow Post Update - Num of Rec to Copy')     *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE0672T1 - Shadow Post Update - Number of Records to Copy    *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSC056  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
     FRESPOCPD  UF A E             DISK    INFSR(*PSSR)
      ** Midas RE Shadow Post Update Control File
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** Entry parameters
     D NumSubTasks     S              3P 0
     D TotRec          S                   LIKE( SPTOTL )
 
      ** Declared Variables and Constants
     D ULNumRec        S                   LIKE( SPNORE )
     D                                     INZ( *ALL'9' )
     D PssrDone        S              1N   INZ
     D True            C                   CONST( *ON )
     D False           C                   CONST( *OFF )
 
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   READ      RESPOCPD
 
      ** Total records of the file
 
     C                   EVAL      SPTOTL = TotRec
 
      ** Calculate number of records to feed to a subtask
 
     C                   EVAL      SPNORE = TotRec / NumSubTasks
 
     C                   IF        SPNORE >= ULNumRec
     C                   EVAL      SPNORE = ULNumRec
     C                   ELSE
 
      ** If the total file records is not perfectly divisible by
      ** the number of sub-tasks
 
     C                   IF        %REM( TotRec : NumSubTasks ) > 0
     C                   EVAL      SPNORE = SPNORE + 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        %EOF( RESPOCPD ) = True
     C                   WRITE     RESPOCP0
     C                   ELSE
     C                   UPDATE    RESPOCP0
     C                   ENDIF
 
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
     C                   PARM                    NumSubTasks
     C                   PARM                    TotRec
 
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
      ********************************************************************
