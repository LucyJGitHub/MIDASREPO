     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Shadow Post Update - Audit Report')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE0672T4 - Midas RE Shadow Post Update - Audit Report        *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSC056  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC056 - COB Restructure - Split of SCC0404 and SCC041       *
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
 
     FRESPOAPD  IF   E             DISK    INFSR( *PSSR )
      ** Task-split control file
 
     FSDBANKL1  IF   E           K DISK    INFSR( *PSSR )
      ** Task-split control file
 
     FRE0672AU  O    E             PRINTER INFSR( *PSSR )
      ** Report number of records read, written, updated
 
      /EJECT
 
     D LDA           E DS           256    DTAARA(LDA)
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
 
      ** Entry parameters
     D RtnCode         S              1A
 
      ** Declared variables and constants
     D PSSRDone        S              1N   INZ
     D True            C                   CONST( *ON )
     D False           C                   CONST( *OFF )
     D PgmName         C                   CONST( 'RE0672T4' )
 
      ** Audit file datastructure
     D RESPOADS      E DS                  EXTNAME( RESPOAPD )
     D                                     INZ
 
      /EJECT
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   READ      RESPOAP0
     C                   DOW       NOT %EOF( RESPOAPD )
 
     C                   EVAL      F1AREC = F1AREC + SPAREC
     C                   EVAL      F1RREC = F1RREC + SPRREC
     C                   EVAL      F1MREC = F1MREC + SPMREC
     C                   EVAL      F1SREC = F1SREC + SPSREC
 
     C                   READ      RESPOAP0
     C                   ENDDO
 
     C                   WRITE     F1HDR1
     C                   WRITE     F1DET1
     C                   WRITE     F1TRL1
 
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
     C                   PARM                    RtnCode
 
     C                   EVAL      BJBANK = 'BANK'
     C     BJBANK        CHAIN     SDBANKL1
 
     C                   IF        NOT %FOUND( SDBANKL1 )
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKL1'
     C                   EVAL      DBKEY = '*ONLY'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBPGM = PgmName
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
     C                   EVAL      RtnCode = 'Y'
     C                   RETURN
 
     C                   ENDSR
