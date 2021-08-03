     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas SM Delete CBMEXCPD duplicate records')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMCPK01503 - Delete Duplicate Records in CBMEXCPD            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD055891           Date 01Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK015  *CREATE    Date 09Jun04               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK015 - Delete duplicate records.                           *
      *                                                               *
      *****************************************************************
     F*CBMEXCL3* UF   E           K DISK                                                    MD055891
      /EJECT
      *
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
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
     D CBMEXC        E DS                  EXTNAME(CBMEXJW0)                                MD055891
      *
     C                   EXSR      SRINIT
      *
     C                   EXSR      SRMAIN
      *
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
      ** Initialise main DBerror fields
      *
     C                   Z-ADD     0             DBASE
     C                   MOVEL     *BLANKS       DBFILE
     C                   MOVEL     *BLANKS       DBKEY
      *
     C                   MOVEL     *BLANKS       WCOTT            10
     C                   MOVEL     *BLANKS       WCSEQ             5
     C                   MOVEL     *BLANKS       WMECN            10
     C                   MOVEL     *BLANKS       WMECS             5
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
     C**********         READ      CBMEXCL3                               01                MD055891
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
     C     DKCOTT        IFEQ      WCOTT
     C     DKCSEQ        ANDEQ     WCSEQ
     C     DKMECN        ANDEQ     WMECN
     C     DKMECS        ANDEQ     WMECS
      *
     C**********         DELETE    @MEXCL3                                                  MD055891
     C                   If        DKMODE = 'C'                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ delete from CBMEXCTD                                                                MD055891
     C+ where DKCOTT = :WCOTT  and DKCSEQ = :WCSEQ  and                                     MD055891
     C+       DKMEUN = :DKMEUN                                                              MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ delete from CBDPRXTD                                                                MD055891
     C+ where DKCOTT = :WCOTT  and DKCSEQ = :WCSEQ  and                                     MD055891
     C+       DKMEUN = :DKMEUN                                                              MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
     C                   If        DKMODE = 'B'                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ delete from CBMEXBTD                                                                MD055891
     C+ where DKCOTT = :WCOTT  and DKCSEQ = :WCSEQ  and                                     MD055891
     C+       DKMEUN = :DKMEUN                                                              MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ delete from CBDPRXTD                                                                MD055891
     C+ where DKCOTT = :WCOTT  and DKCSEQ = :WCSEQ  and                                     MD055891
     C+       DKMEUN = :DKMEUN                                                              MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
      *
     C                   ELSE
      *
      * Save the value of the current record's keys
     C                   MOVEL     DKCOTT        WCOTT
     C                   MOVEL     DKCSEQ        WCSEQ
     C                   MOVEL     DKMECN        WMECN
     C                   MOVEL     DKMECS        WMECS
      *
     C                   ENDIF
      *
      * Read the next record
     C**********         READ      CBMEXCL3                               01                MD055891
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
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
