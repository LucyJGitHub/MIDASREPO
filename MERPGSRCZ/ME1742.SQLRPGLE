     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME Update MEISOCPD (feature CFT017)')            *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1742 - ME Update MEISOCPD (feature CFT017)                 *
      *                                                               *
      *  Function:  This program initialises the 'EEA Member' flag    *
      *             on PF/MEISOCPD.                                   *
      *                                                               *
      *  Called By: MEC1742                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW213             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CFT017  *CREATE    Date 12Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  CFT017 - Multilateral Inter-bank Exchange Fee.               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     F*MEISOCL0* UF   E           K DISK                                                    MD058081
     F**********                           COMMIT                                           MD058081
     F**********                           INFSR(*PSSR)                                     MD058081
      *
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      /EJECT
      *
     C     *ENTRY        PLIST
     C     PMODE         PARM                    PMODE             1
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
     C                   MOVE      'N'           WKERR             1
      *
      ** If the Processing Mode is '1' for feature being set on
      *
     C     PMODE         IFEQ      '1'
     C                   EXSR      SRDFLT
     C                   ENDIF
      *
      ** If error is encountered, roll back the values, else commit
      *
     C     WKERR         IFEQ      'Y'
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDFLT - Subroutine that reads MEISOCL0 and update non-'Y'    *
      *          valued EEA member flag.                              *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SR/*PSSR                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRDFLT        BEGSR
      *
     C******LOVAL        SETLL     MEISOCL0                                                 MD058081
     C**********         READ      MEISOCL0                             0504                MD058081
      **********                                                                            MD058081
     C******IN05         IFEQ      '1'                                                      MD058081
     C**********         MOVE      'Y'           WKERR             1                        MD058081
     C******LOCK         IN        LDA                                                      MD058081
     C**********         Z-ADD     001           DBASE                                      MD058081
     C**********         MOVEL     'MEISOCPD'    DBFILE                                     MD058081
     C**********         MOVEL     *BLANKS       DBKEY                                      MD058081
     C**********         OUT       LDA                                                      MD058081
     C**********         EXSR      *PSSR                                                    MD058081
     C**********         ENDIF                                                              MD058081
      **********                                                                            MD058081
     C******IN04         DOWEQ     '0'                                                      MD058081
      **********                                                                            MD058081
      ** If EEA Member field is not 'Y', default this to 'N'                                MD058081
      **********                                                                            MD058081
     C*****M3EEAM        IFNE      'Y'                                                      MD058081
     C**********         MOVE      'N'           M3EEAM                                     MD058081
     C**********         MOVE      'A'           M3ACTY                                     MD058081
     C**********         UPDATE    @ISOCL0                              05                  MD058081
      **********                                                                            MD058081
     C******IN05         IFEQ      '1'                                                      MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEISOXTD set                                                                 MD058081
     C+   M3EEAM = 'N'                                                                      MD058081
     C+ , M3ACTY = 'A'                                                                      MD058081
     C+ where M3EEAM <> 'Y'                                                                 MD058081
     C/END-EXEC                                                                             MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C                   MOVE      'Y'           WKERR             1
     C     *LOCK         IN        LDA
     C                   Z-ADD     002           DBASE
     C                   MOVEL     'MEISOCPD'    DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      **********                                                                            MD058081
     C**********         ENDIF                                                              MD058081
      **********                                                                            MD058081
     C**********         READ      MEISOCL0                             0504                MD058081
      **********                                                                            MD058081
     C******IN05         IFEQ      '1'                                                      MD058081
     C**********         MOVE      'Y'           WKERR             1                        MD058081
     C******LOCK         IN        LDA                                                      MD058081
     C**********         Z-ADD     003           DBASE                                      MD058081
     C**********         MOVEL     'MEISOCPD'    DBFILE                                     MD058081
     C**********         MOVEL     *BLANKS       DBKEY                                      MD058081
     C**********         OUT       LDA                                                      MD058081
     C**********         EXSR      *PSSR                                                    MD058081
     C**********         ENDIF                                                              MD058081
      **********                                                                            MD058081
     C**********         ENDDO                                                              MD058081
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   ROLBK
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
