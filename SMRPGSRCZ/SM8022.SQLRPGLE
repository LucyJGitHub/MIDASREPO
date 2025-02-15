     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas SM Check for CBMEXCPD duplicate records')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM8022 - Check for duplicate records in CBMEXCPD             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055891           Date 01Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK015  *CREATE    Date 03Jan03               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK015 - Check for duplicate records in CBDPRLL5.            *
      *                                                               *
      *****************************************************************
     F*CBMEXCPD* IF   E             DISK                                                    MD055891
     FSM8020P1  O    E             PRINTER OFLIND(*IN37)
     F                                     USROPN
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
     D CBMEXC        E DS                  EXTNAME(CBMEXJW0)                                MD055891
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
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     C                   EXSR      SRINIT
      *
     C                   EXSR      SRMAIN
      *
     C     RECS          IFNE      'Y'
     C                   WRITE     NORECS
     C                   ENDIF
      *
     C                   CLOSE     SM8020P1
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation routine.                             *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C                   MOVEL     'CBMEXCPD'    #FILE
      *
      ** Initialise main DBerror fields
      *
     C                   Z-ADD     0             DBASE
     C                   MOVEL     *BLANKS       DBFILE
     C                   MOVEL     *BLANKS       DBKEY
      *
     C                   MOVEL     *BLANKS       #COTT            10
     C                   MOVEL     *BLANKS       #CSEQ             5
     C                   MOVEL     *BLANKS       #MECN            10
     C                   MOVEL     *BLANKS       #MECS             5
      *
     C                   MOVEL     '1st Cmp'     #HDR1
     C                   MOVEL     'Seq'         #HDR2
     C                   MOVEL     '2nd Cmp'     #HDR3
     C                   MOVEL     'Seq'         #HDR4
     C                   MOVEL     *BLANKS       #HDR5
      *
     C                   OPEN      SM8020P1
     C                   WRITE     HEADH                                69
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main processing                                     *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
     C**********         READ      CBMEXCPD                               01                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ order by DKCOTT, DKCSEQ, DKMECN, DKMECS                                             MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
      *
     C******IN01         DOWEQ     *OFF                                                     MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
      *
      * If the read record has the same key as the last record, then
      *  delete the recently read record. Otherwise, save the current
      *  value of keys.
     C     DKCOTT        IFEQ      #COTT
     C     DKCSEQ        ANDEQ     #CSEQ
     C     DKMECN        ANDEQ     #MECN
     C     DKMECS        ANDEQ     #MECS
      *
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADH
     C                   SETOFF                                       37
     C                   ENDIF
      *
     C                   MOVEL     #COTT         #FLD1
     C                   MOVEL     #CSEQ         #FLD2
     C                   MOVEL     #MECN         #FLD3
     C                   MOVEL     #MECS         #FLD4
     C                   MOVEL     *BLANKS       #FLD5
     C                   WRITE     DTL1
     C                   MOVEL     'Y'           RECS              1
      *
     C                   ELSE
      *
      * Save the value of the current record's keys
     C                   MOVEL     DKCOTT        #COTT
     C                   MOVEL     DKCSEQ        #CSEQ
     C                   MOVEL     DKMECN        #MECN
     C                   MOVEL     DKMECS        #MECS
      *
     C                   ENDIF
      *
      * Read the next record
     C**********         READ      CBMEXCPD                               01                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
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
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2003
