     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SC Utility Update Program for SCFMBRTD')         *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  UTSC0010 - Midas SC Utility Update Program for SCFMBRTD      *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD057248  *Create   Date 21Jan21              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057248 - Program CBC022001 failed to add member SDACAHL3   *
      *             to file SDACAHL3.                                 *
      *                                                               *
      *****************************************************************
      *
     FUTSC0010P1O    E             PRINTER OFLIND(*IN95)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   90    - Audit/Update mode                                   *
      *   95    - Page overflow on UTSC0010P1                         *
      *   LR    - End of Program                                      *
      *   U7,U8 - Database error occured.                             *
      *                                                               *
      *****************************************************************
     F/SPACE 3
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short data structure


     D LDA             DS           256
      ** Define LDA
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0

     D RUNDT           DS
      ** RUNDAT data structure to pick up system rundate.
     D RUNA                    1      7
     D RUND                    8     10P 0
     D SSF                    11     11
     D DATF                   12     12
     D MBIN                   13     13

     D SCFMBRF       E DS                  EXTNAME(SCFMBRTD)
      ** SCFMBRTD data structure for SQL fetch

     D WRUN            S              1

      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *  SRMAIN - Main Processing                                     *
      *  SRPRINT - Generate reports                                   *
      *  *PSSR  - Error Processing                                    *
      *                                                               *
      *****************************************************************
      *
      *****************************************************************
     C/TITLE Program Start
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMODE             1
      *
      ** Perform initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Perform main routine
      *
     C                   EXSR      SRMAIN

     C     TOTAL1        IFEQ      0
     C                   WRITE     NODETP1
     C                   ELSE
     C                   WRITE     TOTALP1
     C                   ENDIF
      *
      ** End program.
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
     C/TITLE SR/INIT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initial processing                                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Databese Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Get RUND from DTAARA/RUNDAT.
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDT
      *
      ** Define program for error handling
      *
     C                   EVAL      DBPGM = 'UTSC0010'
     C                   EVAL      *IN90 = '0'

      *
     C     PMODE         IFEQ      'A'
     C     PMODE         OREQ      'a'
     C                   EVAL      *IN90 = '0'
     C                   ELSE
     C     PMODE         IFEQ      'U'
     C     PMODE         OREQ      'u'
     C                   EVAL      *IN90 = '1'
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      TOTAL1 = 0
     C                   EVAL      WRUN = ' '
      *
     C                   ENDSR
      *
      *****************************************************************
     C/TITLE SR/SRMAIN
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main Routine                                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRMAIN        BEGSR
      *
     C                   WRITE     HEADP1
      *
      *  -----------------------------
      ** Process SCFMBRTD
      *  -----------------------------
      *
     C                   CLEAR                   SCFMBRF
     C/EXEC SQL
     C+ DECLARE LIST1 cursor FOR
     C+  SELECT * FROM SCFMBRTD WHERE MBFILE = 'SDACAHL3' AND
     C+     MBPERM = 'Y'
     C/END-EXEC

     C/EXEC SQL
     C+ OPEN LIST1
     C/END-EXEC

     C                   EXSR      SRSQLERR1

     C/EXEC SQL
     C+ fetch next
     C+ from LIST1
     C+ into: SCFMBRF
     C/END-EXEC

     C                   DOW       SQLCode <> 100
      *
      ** Print report
     C                   ADD       1             TOTAL1
     C                   EVAL      PRFILN = MBFILE
     C                   EVAL      PRMBRN = MBNAME
     C                   EVAL      PRMTXT = MBMTXT
     C                   EVAL      PRPFIL = MBBOF
     C                   EVAL      PRPERM = MBPERM
     C                   EXSR      SRPRINT

     C/EXEC SQL
     C+ fetch next from LIST1
     C+ into :SCFMBRF
     C/END-EXEC

     C                   ENDDO
     C                   EXSR      SRSQLERR2

     C/EXEC SQL
     C+ close LIST1
     C/END-EXEC
      *
      *  -----------------------------
      ** Process deletion in SCFMBRTD
      *  -----------------------------
      *
     C                   IF        *IN90 = '1'
      *
      ** Delete SCFMBRTD with SDACAHL3 record
      *
     C/EXEC SQL
     C+  DELETE FROM SCFMBRTD WHERE MBFILE = 'SDACAHL3' AND
     C+     MBPERM = 'Y'
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0 AND
     C                             SQLCODE <> 100
     C     *LOCK         IN        LDA
     C                   MOVEL     'T_TREF'      DBKEY
     C                   MOVEL     'SCFMBRTD'    DBFILE
     C                   MOVEL     '101'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        SQLCODE <> 0 AND
     C                             SQLCODE <> 100
     C     *LOCK         IN        LDA
     C                   MOVEL     'T_TREF'      DBKEY
     C                   MOVEL     'SCFMBRTD'    DBFILE
     C                   MOVEL     '102'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *

      *****************************************************************
     C/TITLE SR/SRPSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine.                           *
      *                                                               *
      *  Called By:                                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   WRITE     HEADP1
     C                   WRITE     DBERROR
      *
      ** Set on indicators to end the program.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     C/TITLE SR/SRPRINT
      *****************************************************************
      *                                                               *
      *  SRPRINT - Report the affected accounts                       *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPRINT       BEGSR
      *
     C     *IN95         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN95 = *OFF
     C                   ENDIF
      *
     C                   IF        TOTAL1 > 0
     C                   WRITE     DETAILP1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/TITLE SR/SRSQLERR
      *****************************************************************
      *                                                               *
      *  SRSQLERR1 - SQL Error Routine                                *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRSQLERR1     BEGSR

     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/TITLE SR/SRSQLERR
      *****************************************************************
      *                                                               *
      *  SRSQLERR2 - SQL Error Routine                                *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRSQLERR2     BEGSR

     C                   IF        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
** CPY@ **      OBJECT COPYRIGHT
(c) Finastra International Limited 2021
