     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDCSINPD - 02')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00009 - German Feature migration for SDCSINPD             *
      *                                                               *
     ****Called By: SMUC00007******************************************         262664
      *  Called By: SMUC00213                                         *         262664
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 262664             Date 11Nov09               *
      *                 B24416             Date 16Jun09               *
      *                 CSM011  *CREATE    Date 08May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  262664  - SMUC00007 is now redundant in GF. New program name *
      *            is SMUC00213.                                      *
      *  B24416 - Additional changes for join type.                   *
      *  CSM011 - Midas SM Process CAR migration                      *
      *                                                               *
      *****************************************************************
     FSMUGF07PD IF   E             DISK
      * Template file for SDCSINPD
     FSDJACCL0  IF   E           K DISK
      * Joint Account Members
     FSDCSINL2  UF   E           K DISK
      * Midas SD Customer Income
      *
      * D Specs
      *****************************************************************
     D UorW            S              1
     D WkCust          S              6    INZ(*blanks)
     D Recursive       S              1
      *
      * Process Joint accounts only.
     C     1             SETLL     SMUGF07D0
     C                   READ      SMUGF07D0
     C                   DOW       NOT %EOF
      * Check if account is a joint account: If so update details SDCSINL2.
     C                   MOVE      FCUST         WKCUST
     C     CustomerNo    CHAIN     SDJACCD0
     C                   IF        %FOUND
     C                   EXSR      JointAccount
     C                   ENDIF
     C                   READ      SMUGF07D0
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
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
     C     CustomerNo    KLIST
     C                   KFLD                    WKCUST
      *
     C                   ENDSR
      *
      *****************************************************************
      * Process account with jount customers                          *
      *****************************************************************
      *
     C     JointAccount  BEGSR
      *
     C     CustomerNo    CHAIN     SDCSIND0
     C                   DOW       %FOUND OR NOT %EOF
     C                   MOVE      JCJANO        TSJOIN
     C                   IF        TSINVP <> '1/1'                                            B24416
     C                   EVAL      TSINVP = JCINVP
     C                   ENDIF                                                                B24416
     C                   UPDATE    SDCSIND0
     C     CustomerNo    READE     SDCSIND0
     C                   ENDDO
      *
     C     JointAccountE ENDSR
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
      *****************************************************************
