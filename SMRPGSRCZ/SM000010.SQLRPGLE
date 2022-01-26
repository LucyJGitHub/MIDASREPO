     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD058089
/*STD *  RPGSQLBND                                                    *                     MD058089
/*EXI *  TEXT('Midas SM Account Code File Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000010 - Account Code File Extract Program                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD058089           Date 01Sep21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029  *CREATE    Date 13Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058089 - Deliverable Data Split for SM and UP              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code Field to 10 digit.            *
      *                                                               *
      *****************************************************************
     F*SMACFFL4* IF   E           K DISK    INFDS(INIDS)                                    MD058089
     FSMACFNPD  O  A E             DISK
      /EJECT
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
     D INIDS           DS
     D**RECFMT**         *RECORD                                                            MD058089
     D SMACFF        E DS                  EXTNAME(SMACFJW0)                                MD058089
      *
      *
      ** Read through the Account Code File File
      *
     C     *LIKE         DEFINE    FILE          STFILE
      *
     C******LOVAL        SETLL     SMACFFD0                                                 MD058089
     C**********         READ      SMACFFL4                               LR                MD058089
     C/EXEC SQL                                                                             MD058089
     C+ declare ACursor insensitive scroll cursor for                                       MD058089
     C+ select * from SMACFJW0                                                              MD058089
     C+ order by FILE, FIELD                                                                MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C/EXEC SQL                                                                             MD058089
     C+ open ACursor                                                                        MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C/EXEC SQL                                                                             MD058089
     C+ fetch next from ACursor into :SMACFF                                                MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
      *
     C******INLR         DOWEQ     *OFF                                                     MD058089
     C     SQLCODE       DOWEQ     0                                                        MD058089
      *
     C     STFILE        IFNE      FILE
      *
     C                   MOVEL     FILE          STFILE
     C                   WRITE     SMACFND0
      *
     C                   ENDIF
      *
     C**********         READ      SMACFFL4                               LR                MD058089
     C/EXEC SQL                                                                             MD058089
     C+ fetch next from ACursor into :SMACFF                                                MD058089
     C/END-EXEC                                                                             MD058089
      *
     C                   ENDDO
      *
     C/EXEC SQL                                                                             MD058089
     C+ close ACursor                                                                       MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C                   SETON                                            LR                MD058089
     C                   RETURN
