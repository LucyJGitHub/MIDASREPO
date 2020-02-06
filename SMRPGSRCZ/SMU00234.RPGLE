     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration GLACNTQD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00234 - German Feature migration for GLACNTQD             *
      *                                                               *
      *  Called By: SMC000065                                         *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE095             Date 25Apr14               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 AR800209*CREATE    Date 07Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  AR800209 - Database migration from a previous Midas Release  *
      *             to Midas Plus 1.4                                 *
      *                                                               *
      *****************************************************************
 
     FSMUGF11PD IF   E             DISK
      ** Template file for ACCNTBX3
     FGLACNTL3  UF A E           K DISK
      ** Midas GL Account Master Extension File
     FSMBRCCVTL1IF   E           K DISK
      ** Midas SM Branches to be converted
 
     D BrConvFlag      S              1
     D Recursive       S              1
     D KBRCA           S              3
 
     D                 DS
     D Z3CNUM                  1      6  0
     D Z3CNUMA                 1      6
 
     C                   IF        BrConvFlag = 'Y'
     C                   EXSR      ProcBr_Conv
     C                   ELSE
     C                   EXSR      ProcBr_NoConv
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * ProcBr_Conv - Process with Branch Conversion                  *
      *                                                               *
      *****************************************************************
     C     ProcBr_Conv   BEGSR
 
     C     1             SETLL     SMUGF11D0
     C                   READ      SMUGF11D0
 
     C                   DOW       NOT %EOF
     C     Z3BRCA        CHAIN     SMBRCCVTD0
     C                   IF        %FOUND
     C                   EVAL      KBRCA = BCNEWB
     C                   ELSE
     C                   EVAL      KBRCA = Z3BRCA
     C                   ENDIF
     C     GLACNKY       CHAIN     GLACNTL3
     C                   IF        %FOUND
     C                   MOVE      Z3ZINS        F1ZINS
     C                   UPDATE    GLACNTD0
     C                   ELSE
     C                   EXSR      UpdateFields
     C                   WRITE     GLACNTD0
     C                   ENDIF
 
     C                   READ      SMUGF11D0
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * ProcBr_NoConv - Process Branch with No Conversion             *
      *                                                               *
      *****************************************************************
     C     ProcBr_NoConv BEGSR
 
     C     1             SETLL     SMUGF11D0
     C                   READ      SMUGF11D0
 
     C                   DOW       NOT %EOF
     C                   EVAL      KBRCA = Z3BRCA
     C     GLACNKY       CHAIN     GLACNTL3
     C                   IF        %FOUND
     C                   MOVE      Z3ZINS        F1ZINS
     C                   UPDATE    GLACNTD0
     C                   ELSE
     C                   EXSR      UpdateFields
     C                   WRITE     GLACNTD0
     C                   ENDIF
 
     C                   READ      SMUGF11D0
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * UpdateFields - Move fields to GLACNTQD file                   *
      *                                                               *
      *****************************************************************
     C     UpdateFields  BEGSR
 
     C                   EVAL      F1BRCA = KBRCA
     C                   EVAL      F1CCY  = Z3CCY
     C                   EVAL      F1ACSQ = Z3ACSQ
     C                   EVAL      F1ZINS = Z3ZINS
     C                   EVAL      F1ACOD = Z3ACOD
     C                   MOVEL     Z3CNUMA       F1CNUM
 
     C                   Z-ADD     0             F1FCHD
     C                   Z-ADD     0             F1LFCD
     C                   Z-ADD     0             F1ACBL
     C                   Z-ADD     0             F1TEXO
     C                   Z-ADD     0             F1TEOF
     C                   Z-ADD     0             F1TEOC
     C                   Z-ADD     0             F1TOLR
     C                   Z-ADD     0             F1DAT0
     C                   Z-ADD     0             F1DAT1
     C                   Z-ADD     0             F1DAT2
     C                   Z-ADD     0             F1DAT3
     C                   Z-ADD     0             F1DAT4
     C                   Z-ADD     0             F1DAT5
     C                   Z-ADD     0             F1DAT6
     C                   Z-ADD     0             F1DAT7
     C                   Z-ADD     0             F1DAT8
     C                   Z-ADD     0             F1DAT9
 
     C                   Z-ADD     0             F1BAV0
     C                   Z-ADD     0             F1BAV1
     C                   Z-ADD     0             F1BAV2
     C                   Z-ADD     0             F1BAV3
     C                   Z-ADD     0             F1BAV4
     C                   Z-ADD     0             F1BAV5
     C                   Z-ADD     0             F1BAV6
     C                   Z-ADD     0             F1BAV7
     C                   Z-ADD     0             F1BAV8
     C                   Z-ADD     0             F1BAV9
     C                   Z-ADD     0             F1AVA0
     C                   Z-ADD     0             F1AVA1
     C                   Z-ADD     0             F1AVA2
     C                   Z-ADD     0             F1AVA3
     C                   Z-ADD     0             F1AVA4
     C                   Z-ADD     0             F1AVA5
     C                   Z-ADD     0             F1AVA6
     C                   Z-ADD     0             F1AVA7
     C                   Z-ADD     0             F1AVA8
     C                   Z-ADD     0             F1AVA9
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     GLACNKY       KLIST
     C                   KFLD                    Z3CNUMA
     C                   KFLD                    Z3CCY
     C                   KFLD                    Z3ACOD
     C                   KFLD                    Z3ACSQ
     C                   KFLD                    KBRCA
 
     C                   EVAL      BrConvFlag = 'N'
     C     *LOVAL        SETLL     SMBRCCVTD0
     C                   READ      SMBRCCVTD0
     C                   IF        NOT %EOF
     C                   EVAL      BrConvFlag = 'Y'
     C                   ENDIF
 
     C                   ENDSR
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
 
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
