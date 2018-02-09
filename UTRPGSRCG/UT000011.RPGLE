     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UTC000001C) TOFILE(UPMBRLTPD)                    *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Check member exists, return library name')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000001 - Check if member exists and return library name    *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG22137 *CREATE   Date 13Jan09               *
      *                 CUT010             Date 10May07               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG22137 - Bridge/Utility Changes.                           *
      *          - UT000001 renamed to UT000011.                      *
      *  CUT010 - New utility.                                        *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
     FUTC000001CIF   E           K DISK    INFSR(*PSSR)
      *
      /EJECT
     D PSrcFile        S             10
     D KSrcFile        S                   LIKE(PSrcFile)
     D PMember         S             10
     D KMember         S                   LIKE(PMember)
     D PFound          S              4
     D PLibrary        S             10
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *
      *                                     134 141 DBFILE
      *       Defines:                      142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSrcFile
     C                   PARM                    PMember
     C                   PARM                    PFound
     C                   PARM                    PLibrary
      *
     C     KCheck        KLIST
     C                   KFLD                    KSrcFile
     C                   KFLD                    KMember
      *
     C                   EVAL      PFound = *blanks
     C                   EVAL      KSrcFile = PSrcFile
     C                   EVAL      KMember = PMember
      *
     C     KCheck        CHAIN     UTC000001C
     C                   IF        %FOUND
     C                   EVAL      PFound = '*YES'
     C                   EVAL      PLibrary = MLLIB
     C                   ELSE
     C                   EVAL      PFound = '*NO '
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
