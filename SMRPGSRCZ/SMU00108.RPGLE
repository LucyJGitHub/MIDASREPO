     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDACAHPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00108 - German Feature migration for SDACAHPD             *
      *                                                               *
      *  Called By: SMUC00000                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG25211 *CREATE   Date 27Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25211 - Customer Authority Holders not migrated           *
      *                                                               *
      *****************************************************************
     FSMUGF09PD IF   E             DISK    PREFIX(X)
      * Template file for SDCUAHPP
     FSDACAHPD  UF A E           K DISK
      *
      /EJECT
     D Recursive       S              1
      *
     D                 DS
     D AuthType03              1      3
     D AuthType02              1      2
      *
     C     1             SETLL     SMUGF09D0
     C                   READ      SMUGF09D0
     C                   DOW       NOT %EOF
      *
      * Update fields from template files.
     C                   EXSR      UpdateFields
     C                   WRITE     SDACAHD0
      *
     C                   READ      SMUGF09D0
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
     C                   EVAL      AAACNO = XAAACNO
     C                   EVAL      AAAUTH = XAAAUTH
     C                   EVAL      AALTYP = XAALTYP
     C                   EVAL      AALCD  = XAALCD
     C                   EVAL      AATYLC = XAATYLC
     C                   EVAL      AuthType03 = XAATYPA
     C                   EVAL      AATYPA = AuthType02
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
