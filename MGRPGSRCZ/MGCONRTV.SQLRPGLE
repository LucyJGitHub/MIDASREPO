     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas MG Retrieve MGCON details')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management                                   *
      *                                                               *
      *  MGCONRTV - Retrieve MGCON*TD details                         *
      *                                                               *
      *  Last Amend No. MD058081 *CREATE   Date 11May21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *                                                               *
      *****************************************************************


      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRPROCESS - Detail Processing                                *
      *                                                               *
      *****************************************************************
     D/EJECT

      ** Array containing Copyright statement

     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

      * Program Status data structure

     D  PSDS          SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263

      ** Local data area for database error details

     D LDA           E DS           256    EXTNAME(LDA)


     D MGECON        E DS                  EXTNAME(MGCONJW0)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D P@RTCD          S              7A
     D P@PARM          S             20A

      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================

      **  Perform Detail Processing.

     C/EXEC SQL
     C+ SELECT *
     C+ into :MGECON
     C+ from MGCONJW0
     C+ where MGNTRY = :P@PARM
     C/END-EXEC

     C                   EVAL      DSFDY = *BLANKS
     C                   EVAL      P@RTCD = *BLANKS

     C                   IF        SQLCODE = 0
     C                   EVAL      DSFDY = MGECON
     C                   ELSE
     C                   EVAL      P@RTCD = 'ERROR'
     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN

      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT

      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD
     C                   PARM                    P@PARM
     C                   PARM      MGECON        DSFDY

      ** Set up Local Data Area (LDA)

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPGM  = 'MGCONRTV'
     C                   EVAL      DBMOD  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   EVAL      DBPROC = *BLANKS
     C                   OUT       LDA

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      P@RTCD = '*ERROR'
     C                   DUMP

     C                   RETURN

     C                   ENDSR

      /EJECT
** CPY@
(c) Finastra International Limited 2021
