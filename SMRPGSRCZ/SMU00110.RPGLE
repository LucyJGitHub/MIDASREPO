     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDNAHOPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00110 - German Feature migration for SDNAHOPD             *
      *                                                               *
      *  Called By: SMUC00000                                         *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG25211C          Date 14Aug09               *
      *                 BUG25211B *CREATE  Date 08Aug09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25211C - Error on date format                             *
      *  BUG25211B - Non-Account Holders not migrated                 *
      *                                                               *
      *****************************************************************
     FSMUGF10PD IF   E             DISK
      * Template file for SDAHLDPP
 
     FSDNAHOPD  UF A E           K DISK
      *
      /EJECT
     D Recursive       S              1
     D WDate           S              8                                                    BUG25211C
      *                                                                                    BUG25211C
     D                 DS                                                                  BUG25211C
     D WDAteN                  1      8  0                                                 BUG25211C
     D WDateA                  1      8                                                    BUG25211C
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C     1             SETLL     SMUGF10D0
     C                   READ      SMUGF10D0
     C                   DOW       NOT %EOF
      *
      * Update fields from template files.
      *
     C                   EXSR      UpdateFields
     C                   WRITE     SDNAHOD0
      *
     C                   READ      SMUGF10D0
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
     C                   EVAL      NHNAHO = '0000' + AHAUTH
     C                   EVAL      NHSHNM = AHAUSN
     C                   EVAL      NHTITL = AHTTLC
     C                   EVAL      NHIDE1 = AHSNMA
     C                   EVAL      NHIDE2 = AHFNMA
     C                   EVAL      NHMDNM = AHMNMA
     C**********         MOVE      AHDBRA        NHDBTH                                    BUG25211C
     C                   EVAL      WDateN = AHDBRA                                         BUG25211C
     C                   EVAL      %SUBST(WDate:1:4) =                                     BUG25211C
     C                             %SUBST(WDateA:5:4)                                      BUG25211C
     C                   EVAL      %SUBST(WDate:5:2) =                                     BUG25211C
     C                             %SUBST(WDateA:3:2)                                      BUG25211C
     C                   EVAL      %SUBST(WDate:7:2) =                                     BUG25211C
     C                             %SUBST(WDateA:1:2)                                      BUG25211C
     C                   EVAL      NHDBTH = WDate                                          BUG25211C
     C                   EVAL      NHBTHT = AHPLBR
     C                   EVAL      NHINDC = AHLICD
     C                   EVAL      NHIDTP = AHIDCA
     C                   EVAL      NHDOCN = AHIDNR
     C                   EVAL      NHISAU = AHISAU
     C                   EVAL      NHISUP = AHISPL
     C**********         MOVE      AHISDT        NHISDT                                    BUG25211C
     C                   EVAL      WDateN = AHISDT                                         BUG25211C
     C                   EVAL      %SUBST(WDate:1:4) =                                     BUG25211C
     C                             %SUBST(WDateA:5:4)                                      BUG25211C
     C                   EVAL      %SUBST(WDate:5:2) =                                     BUG25211C
     C                             %SUBST(WDateA:3:2)                                      BUG25211C
     C                   EVAL      %SUBST(WDate:7:2) =                                     BUG25211C
     C                             %SUBST(WDateA:1:2)                                      BUG25211C
     C                   EVAL      NHISDT = WDate                                          BUG25211C
     C                   MOVE      AHEXDT        NHEXDT
     C                   EVAL      NHIDE3 = AHADRS
     C                   EVAL      NHCNA1 = AHADA1
     C                   EVAL      NHCNA2 = AHADA2
     C                   EVAL      NHZIPC = AHPCDE
     C                   EVAL      NHCOLC = AHCOLC
     C                   EVAL      NHPHON = AHPHON
     C                   EVAL      NHRMK1 = AHREM1
     C                   EVAL      NHRMK2 = AHREM2
     C                   EVAL      NHRMK3 = AHREM3
     C                   EVAL      NHLCDT = AHLCD
     C                   EVAL      NHCHTP = AHTYLC
     C                   EVAL      NHFRNT = AHFRNT
     C                   EVAL      NHTMST = AHTMST
     C                   EVAL      NHTINO = AHTINO
     C                   EVAL      NHBTHC = AHBTHC
     C                   EVAL      NHISCT = AHCIDI
     C                   EVAL      NHNARN = AHAUSN
     C                   EVAL      NHNATW = %SUBST(AHTOWN:1:10)
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
