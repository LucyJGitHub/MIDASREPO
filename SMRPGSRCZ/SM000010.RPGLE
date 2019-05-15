     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Account Code File Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000010 - Account Code File Extract Program                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029  *CREATE    Date 13Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code Field to 10 digit.            *
      *                                                               *
      *****************************************************************
     FSMACFFL4  IF   E           K DISK    INFDS(INIDS)
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
     D  RECFMT           *RECORD
      *
      *
      ** Read through the Account Code File File
      *
     C     *LIKE         DEFINE    FILE          STFILE
      *
     C     *LOVAL        SETLL     SMACFFD0
     C                   READ      SMACFFL4                               LR
      *
     C     *INLR         DOWEQ     *OFF
      *
     C     STFILE        IFNE      FILE
      *
     C                   MOVEL     FILE          STFILE
     C                   WRITE     SMACFND0
      *
     C                   ENDIF
      *
     C                   READ      SMACFFL4                               LR
      *
     C                   ENDDO
      *
     C                   RETURN
