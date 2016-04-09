     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDCUAHPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00107 - German Feature migration for SDCUAHPD             *
      *                                                               *
      *  Called By: SMUC00000                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CGL132             Date 01May13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG25211C          Date 14Aug09               *
      *                 BUG25211 *CREATE   Date 27Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25211C - Append '0000' to CAAUTH field upon migration     *
      *  BUG25211 - Customer Authority Holders not migrated           *
      *                                                               *
      *****************************************************************
     FSMUGF08PD IF   E             DISK    PREFIX(X)
      * Template file for SDCUAHPP
     FSDCUAHPD  UF A E           K DISK
      *
      /EJECT
     D Recursive       S              1
      *
     D                 DS
     D AuthType03              1      3
     D AuthType02              1      2
      *
     C     1             SETLL     SMUGF08D0
     C                   READ      SMUGF08D0
     C                   DOW       NOT %EOF
      *
      * Update fields from template files.
     C                   EXSR      UpdateFields
     C                   WRITE     SDCUAHD0
      *
     C                   READ      SMUGF08D0
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
     C                   ENDSR
      *
      *****************************************************************
      * UpdateFields - Move fields from template file.                *
      *****************************************************************
 
     C     UpdateFields  BEGSR
      *
     C                   EVAL      CACUST = XCACUST
     C**********         EVAL      CAAUTH = XCAAUTH                                        BUG25211C
     C                   EVAL      CAAUTH = '0000' + XCAAUTH                               BUG25211C
     C                   EVAL      CALTYP = XCALTYP
     C                   EVAL      CAPRG1 = XCAPDG1
     C                   EVAL      CAPRG2 = XCAPDG2
     C                   EVAL      CAPRG3 = XCAPDG3
     C                   EVAL      CAPRG4 = XCAPDG4
     C                   EVAL      CATYLC = XCATYLC
     C                   EVAL      AuthType03 = XCATYPA
     C                   EVAL      CATYPA = AuthType02
      *
     C     UpdateFieldsE ENDSR
      *
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
