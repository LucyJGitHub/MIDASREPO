     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Update Extension file GLJEAUPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0081 - Update Extension file GLJEAUPD                      *
      *                                                               *
      *  Function: This program writes a record to Extension file     *
      *            GLJEAUPD                                           *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. CGL082   *Create   Date 02Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL082 - Journal Entry User Audit                            *
      *                                                               *
      *****************************************************************
     FGLJENHL0  IF   E           K DISK
      * Journal Entry Header
      *
     FGLJEAUL0  O    E           K DISK
      * Journal Entry Extension
      *
      /EJECT
     F*****************************************************************
      /TITLE FUNCTION OF INDICATORS
     F*                                                               *
     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
     F*                                                               *
     F*      *INLR - End of Program                                   *
     F*                                                               *
     F*****************************************************************
      /TITLE ARRAY SPECIFICATIONS
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      **  Array for Object Copyright Statement.
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     D ZMUSER          DS
     D  USID                   1     10
     D  UDBC                  11     13
     D  UDDP                  14     16
     D  UBLA                  17     17
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Get parameters from calling program
      *
     C     *ENTRY        PLIST
     C                   PARM                    BTNB              3
     C                   PARM                    BRCA              3
     C                   PARM                    ACTN              1
      *
      **  Copyright Statement.
      *
     C                   MOVEA     CPY@          MKI@             80
      *
     C     WRTTAG        TAG
      *
      ** Set up file fields
      *
     C                   MOVE      BTNB          AUBTNB
     C                   MOVE      ACTN          AUACTN
     C                   MOVE      BRCA          AUBRCA
      *
      ** Access data-area ZMUSER to obtain User ID.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   MOVE      USID          AUUSID                         User Profile
      *
      ** Obtain Batch Description
      *
     C     AUBTNB        CHAIN     GLJENHL0                           80
     C                   MOVE      BRBDES        AUDSCR
     C                   MOVE      BRDPCD        AUDPCD
      *
      ** Obtain Time
      *
     C                   TIME                    AUTIME
      *
      ** Write record to Extension file.
      *
     C                   WRITE     GLJEAUD0
      *
     C                   SETON                                        LR
     C                   RETURN
      ********************************************************************
      /EJECT
      ********************************************************************
      *
**  CPY@ - OBJECT COPYRIGHT
(c) Finastra International Limited 2021
