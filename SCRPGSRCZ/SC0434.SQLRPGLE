     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Updates non-core release/interim release')    *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC0434 - Update Non-core switchable features                 *
      *                                                               *
      *  Function:  This program reads through switchable features    *
      *             file SCSARDPD to determine which features are     *
      *             at which release level.                           *
      *                                                               *
      *  Called By: SC0435, SC0433                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CUP023             Date 17Mar11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 27Sep01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC010  *CREATE    Date 05Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP023 - Addition of sequence numbers for release levels     *
      *           (Recompile)                                         *
      *  CPK014 - Release 4 packaging:                                *
      *           - Define Release 4.                                 *
      *  CSC010 - Switchable features enhancements.                   *
      *                                                               *
      *****************************************************************
      *
     F*SCSARDL1* IF   E           K DISK                                                    MD055681
      * Switchable features held on file
      *
     FSCRELHL0  IF   E           K DISK
      * List of all core switchable features available
      *
      * List of all non-core switchable features for this branch
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D R105            C                   CONST('ABS R10.5')
     D R104            C                   CONST('ABS R10.4')
      *
      ** Set up copyright parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    AXRELL           10
     C                   PARM                    AXIREL            3
     C                   PARM                    RETCDE            7
     C                   MOVEA     CPY@          MKI@             80
     C*
     C** Find licence level of system
     C*
     C*****'MREL04'      CHAIN     SCSARDL1                           92                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT * into :SCSARD                                                               MD055681
     C+ from SCSRDJW0  where SARN = 'MREL04'                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN92         IFEQ      *OFF                                                     MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   MOVEL     'MREL04'      AXRELL
     C                   EXSR      RELL
     C                   EXSR      EXIT
     C                   ENDIF
     C*****'DBAR3 '      CHAIN     SCSARDL1                           92                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT * into :SCSARD                                                               MD055681
     C+ from SCSRDJW0  where SARN = 'DBAR3 '                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN92         IFEQ      *OFF                                                     MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   MOVEL     'DBA R3'      AXRELL
     C                   EXSR      RELL
     C                   EXSR      EXIT
     C                   ENDIF
     C*****'DBAR2 '      CHAIN     SCSARDL1                           92                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT * into :SCSARD                                                               MD055681
     C+ from SCSRDJW0  where SARN = 'DBAR2 '                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN92         IFEQ      *OFF                                                     MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   MOVEL     'DBA R2'      AXRELL
     C                   EXSR      RELL
     C                   EXSR      EXIT
     C                   ENDIF
     C*****'DBAR1 '      CHAIN     SCSARDL1                           92                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT * into :SCSARD                                                               MD055681
     C+ from SCSRDJW0  where SARN = 'DBAR1 '                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN92         IFEQ      *OFF                                                     MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   MOVEL     'DBA R1'      AXRELL
     C                   EXSR      RELL
     C                   EXSR      EXIT
     C                   ENDIF
     C*****'R10.5 '      CHAIN     SCSARDL1                           92                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT * into :SCSARD                                                               MD055681
     C+ from SCSRDJW0  where SARN = 'R10.5 '                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN92         IFEQ      *OFF                                                     MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   MOVEL     R105          AXRELL
     C                   EXSR      RELL
     C                   EXSR      EXIT
     C                   ENDIF
     C*****'R10.4 '      CHAIN     SCSARDL1                           92                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT * into :SCSARD                                                               MD055681
     C+ from SCSRDJW0  where SARN = 'R10.4 '                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN92         IFEQ      *OFF                                                     MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   MOVEL     R104          AXRELL
     C                   EXSR      RELL
     C                   EXSR      EXIT
     C                   ENDIF
     C*
     C*  If none of the Licence levels are found, return blank values.
     C                   MOVEL     *BLANKS       AXRELL
     C                   MOVEL     *BLANKS       AXIREL
     C                   EXSR      EXIT
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  RELL   - Subroutine to find interim release level            *
      *                                                               *
      *****************************************************************
     C     RELL          BEGSR
     C*
      *
     C     AXRELL        CHAIN     SCRELHL0                           93
      *
      *
     C                   ENDSR
      *
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXIT   - Subroutine to END PROGRAM                           *
      *                                                               *
      *****************************************************************
     C     EXIT          BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
