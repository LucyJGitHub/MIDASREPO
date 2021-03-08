     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/**** *  RPGBASEBNC                                                   *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas GP Access Global core switchable feature')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP270000 - Access Global core switchable feature             *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR754826 *CREATE   Date 13May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
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

     F*GPSARSL0* IF   E           K DISK    INFSR(*PSSR)                                    MD055681

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
     D GPSARS        E DS                  EXTNAME(GPSRSJW0)                                MD055681

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Read record from File

     C*****PSarn         CHAIN     GPSARSL0                                                 MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :GPSARS                                                                        MD055681
     C+ from GPSRSJW0                                                                       MD055681
     C+ where AXSARN = :PSarn                                                               MD055681
     C/END-EXEC                                                                             MD055681

     C**********         IF        NOT %FOUND                                               MD055681
     C                   IF        SQLCODE <> 0                                             MD055681

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
