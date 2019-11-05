     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDACUSPD - 02')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00008 - German Feature migration for SDACUSPD             *
      *                                                               *
      *  Called By: SMUC00000                                         *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 B24746A            Date 16Jun09               *
      *                 B24416             Date 17Jun09               *
      *                 CSM011  *CREATE    Date 08May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  B24746A - Further migration refinement.  Recompile.          *
      *  B24416 - Additional changes for join type.                   *
      *  CSM011 - Midas SM Process CAR migration                      *
      *                                                               *
      *****************************************************************
     FSMUGF01PD IF   E             DISK
      * Template file for SDCUSTX0
     FSMUGF02PD IF   E           K DISK    PREFIX(X)
      * Template file for SDCUSTX2
     FSDACUSL0  UF A E           K DISK
      * Additional customer details file
     FSDCUSTL0  IF   E           K DISK
      * Customer details file
     FSDJACCL0  UF A E           K DISK
      * Joint Account Members
      *
      /EJECT
      *
     D UorW            S              1
     D Recursive       S              1
     D WkCust          S              6    INZ(*blanks)
     D PMode           S              7
     D PReport         S             10    INZ(*blanks)
     D PErrorMsg       S            100    INZ(*blanks)
      *
      * Process Joint accounts only.
     C     1             SETLL     SMUGF01D0
     C                   READ      SMUGF01D0
     C                   DOW       NOT %EOF
      * Check if account is a joint account: If so process joint customers
     C     BBJACC        CASEQ     'Y'           JointAccount
     C                   ENDCS
     C                   READ      SMUGF01D0
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
     C                   KFLD                    WkCust
      *
     C     KJointAc      KLIST
     C                   KFLD                    JCJANO
     C                   KFLD                    JCCUST
      *
     C                   ENDSR
      *
      *****************************************************************
      * Process account with jount customers                          *
      *****************************************************************
      *
     C     JointAccount  BEGSR
      *
      * Check if Joint Customer 1 and Joint Customer 2 are 0.
     C                   IF        BBJCU1 = 0 and BBJCU2 = 0
      *
      * Joint Customer 1 and Joint Customer 2 are 0: No processing possible
      * then leave.
     C                   LEAVESR
     C                   ENDIF
 
 
     C                   IF        BBJCU1 > 0                                   B24416
      *
      * Check if joint 1 already exist.
     C                   MOVE      BBJCU1        WKCUST
     C     CustomerNo    SETLL     @ACUSL0
     C                   IF        NOT %Found
      *
      * Report as an error.
     C                   EXSR      ReportError
     C                   ELSE
      *
      * Joint 1 does exist: update customer record as 'Individual';
      * create joint account relation.
     C                   EXSR      UpdIndv
     C                   EXSR      AddRelat
     C                   ENDIF
     C                   ENDIF                                                  B24416
 
     C                   IF        BBJCU2 > 0                                   B24416
      *
      * Check if joint 2 already exist.
     C                   MOVE      BBJCU2        WKCUST
     C     CustomerNo    SETLL     @ACUSL0
     C                   IF        NOT %Found
      *
      * Joint 2 does not exist; report error.
     C                   EXSR      ReportError
     C                   ELSE
      *
      * Joint 2 does exist: update customer record as 'Individual';
      * create joint account relation.
     C                   EXSR      UpdIndv
     C                   EXSR      AddRelat
     C                   ENDIF
     C                   ENDIF                                                  B24416
      *
     C     JointAccountE ENDSR
      *
      *****************************************************************
      * ReportError                                                   *
      *****************************************************************
      *
     C     ReportError   BEGSR
      *
     C                   EVAL      PErrorMsg='Customer '+ BBCUST + ':' +
     C                             'Joint Account Customer ' + WKCUST +
     C                             'not found in SDACUSTPD'
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      PMode
     C                   PARM                    PReport
     C                   PARM                    PErrorMsg
     C                   CLEAR                   PErrorMsg
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C     ReportErrorE  ENDSR
      *
      *****************************************************************
      * Process account with jount customers                          *
      *****************************************************************
      *
     C     AddRelat      BEGSR
      *
     C     KJointAc      SETLL     SDJACCD0
     C                   IF        NOT %FOUND
     C                   EVAL      JCJANO = BBCUST
     C                   EVAL      JCCUST = WKCUST
     C                   EVAL      JCINVP = '50/100'
     C                   WRITE     SDJACCD0
     C                   ENDIF
      *
     C     AddRelatE     ENDSR
      *
      *****************************************************************
      * Update joint account customer as individual                   *
      *****************************************************************
     C     UpdIndv       BEGSR
      *
     C     CustomerNo    CHAIN     @ACUSL0
     C                   IF        %FOUND
     C                   IF        BBJACC = 'Y'                                               B24416
     C                   EVAL      E5JATP = 'I'
     C                   UPDATE    @ACUSL0
     C                   ENDIF                                                                B24416
     C                   ENDIF
      *
     C     UpdIndvE      ENDSR
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
