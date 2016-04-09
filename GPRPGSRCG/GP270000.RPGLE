     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access Global core switchable feature')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP270000 - Access Global core switchable feature             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR754826 *CREATE   Date 13May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR754826 - UTMENU should check for corresponding Global      *
      *             feature status  (Child: AR754827)                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
 
      ** Midas RE Reserved Transactions by RTREF
 
     FGPSARSL0  IF   E           K DISK    INFSR(*PSSR)
 
     D LDA           E DS           256    EXTNAME(LDA)
     D                                     DTAARA(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'
 
     D/COPY GPCPYSRCG,PSDS
      ** Program Status Data Structure
 
      ** Entry Parameters
 
     D PRtcd           S              7
     D PSarn           S                   LIKE(AXSARN)
 
      ** Work fields
 
     D WRun            S              1A   INZ(' ')
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read record from File
 
     C     PSarn         CHAIN     GPSARSL0
 
     C                   IF        NOT %FOUND
 
     C                   EVAL      PRtcd = '*NRF'
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Receive Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PSarn
 
      ** Initialise LDA field
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = 1
     C                   EVAL      DBPGM = 'GP270000'
     C                   OUT       LDA
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
