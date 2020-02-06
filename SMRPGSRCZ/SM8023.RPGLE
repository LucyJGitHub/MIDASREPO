     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Delete Duplicate Records in SMITEMPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM8023 - Delete Duplicate Records in SMITEMPD                *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSF002  *CREATE    Date 27Feb04               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF002 - Global Processing changes for SPF.                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  File SMITEMPD holds all live items from MITEMDD and PCMD not *
      *  'TITLE' nor 'MENU' in SMC1080.                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       01      End of file SMITEMPD                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSMITEMPD  UF   E           K DISK    INFSR(*PSSR)
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
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
      *
     D PrevMGRP        S                   LIKE(MGRP) INZ(0)
     D PrevICDE        S                   LIKE(ICDE) INZ(' ')
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *                                                               *
      *****************************************************************
      *
     C                   READ      SMITEMPD                               01    EOF
      *
     C     *IN01         DOWEQ     *OFF
      *
      * If the read record has the same key as the last record, then
      *  delete the recently read record. Otherwise, save the current
      *  value of keys.
     C     MGRP          IFEQ      PrevMGRP
     C     ICDE          ANDEQ     PrevICDE
      *
     C                   DELETE    MITEMDDF
      *
     C                   ELSE
      *
      * Save the value of the current record's keys
     C                   EVAL      PrevMGRP  =   MGRP
     C                   EVAL      PrevICDE  =   ICDE
      *
     C                   ENDIF
      *
      * Read the next record
     C                   READ      SMITEMPD                               01
      *
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Initialize main DBerror fields
      *
     C                   Z-ADD     0             DBASE
     C                   MOVEL     *BLANKS       DBFILE
     C                   MOVEL     *BLANKS       DBKEY
      *
     C     INZSRE        ENDSR
      *
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
