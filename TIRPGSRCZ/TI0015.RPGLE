     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*XBI *  CRTPF FILE(QTEMP/TIC0015) RCDLEN(100)                        *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Write/Report on Midas/TI server links')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Inovation (TI) Module                          *
      *                                                               *
      *  TI0015 - Report of the status of server links with Midas     *
      *                                                               *
      *  Phase(s): I/C or CoB                                         *
      *                                                               *
      *  Called By: TIC0015                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CTI003   *CREATE   Date 28Mar01               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI003 - Patch D.  CoB changes.                              *
      *                                                               *
      *****************************************************************
      *
     FTIC0015   IF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(TIC0015:TIC0015F)
     F                                     PREFIX(#)
      *
     FTI0015AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      *
     D RUNDAT        E DS
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   88  - End of File TIC0015                                   *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  WRITE  - Write record to TIC0015.                            *
      *  REPORT - Produce report.                                     *
      *  *PSSR  - Program Error processing Subroutine                 *
      *                                                               *
      *****************************************************************
     D/EJECT
     D DBERR         E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SPOOLU          DS
      **  File Information Data Structure for TI0507AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  OFLLNU               188    189B 0
     D  PRTLNU               367    368B 0
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      **  End program and return.
      *
     C                   SETON                                        LR
     C                   RETURN
      ******************************************************************
      *
     C     WRITE         BEGSR
      *
     C                   MOVEL     TEXT          #TIC0015
     C                   WRITE     TIC0015F
      *
     C     WRITE_END     ENDSR
      *
      ******************************************************************
      *
     C     REPORT        BEGSR
      *
     C                   OPEN      TI0015AU
      *
     C                   WRITE     HEADAU
      *
     C     1             SETLL     TIC0015F
     C                   READ      TIC0015F                               88
     C     *IN88         IFEQ      *ON
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C     *IN88         DOWNE     *ON
     C                   MOVEL     #TIC0015      @1TEXT
      ** Check that sufficient lines remain for the Format.
      *
     C     OFLLNU        SUB       PRTLNU        DIFLNU            3 0
     C     DIFLNU        IFLE      RQDLNU
     C                   WRITE     HEADAU
     C                   ENDIF
     C
      *
     C                   WRITE     DETAIL
      *
     C                   READ      TIC0015F                               88
      *
     C                   ENDDO
      *
     C                   WRITE     TRAILAU
      *
     C                   CLOSE     TI0015AU
      *
     C     REPORT_END    ENDSR
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Automatically                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE             10
     C                   PARM                    TEXT            100
      *
      **  Initialise LDA field.
      *
     C                   MOVEL     'TI0015'      DBPGM
     C     *DTAARA       DEFINE    LDA           @LDA            256
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      **  Initialise required no. of lines for detail output
      *
     C                   Z-ADD     1             RQDLNU            3 0
      *
     C     MODE          CASEQ     '*WRITE'      WRITE
     C     MODE          CASEQ     '*REPORT'     REPORT
     C                   ENDCS
      *
      *
     C                   ENDSR
      *
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      **  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *LOCK         IN        @LDA
     C                   MOVEL     DBERR         @LDA
     C                   OUT       @LDA
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ENDIF
      *
      **  If *PSSR already run, then just end the program here.
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
