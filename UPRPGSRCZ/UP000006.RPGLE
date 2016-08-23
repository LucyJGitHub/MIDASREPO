     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Update UPPOSTPD')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP000006 - Update UPPOSTPD                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *   Last Amend No. BUG27788  *CREATE     Date 21May10           *
      *   Prev Amend No. xxxxxx                Date ddMmmyy           *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27788 - Postings reconciliation utility                   *
      *                                                               *
      *****************************************************************
      *
     FUPPOSTL0  UF   E           K DISK    INFSR(*PSSR)
     FUPPOSTPD  UF A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(P)
      *
     D Recursive       S              1    INZ(' ')
     D PostAmount      S             15  0 INZ(0)
     D PostCount       S              8  0 INZ(0)
     D SaveBRCA        S              3
     D SaveCNUM        S              6
     D SaveCCY         S              3
     D SaveACOD        S             10  0
     D SaveACSQ        S              2  0
     D SaveSPOS        S              7
      *
      * Update file for amounts and source-of-posting.
     C                   EXSR      UpdatePOST
      *
      * Write total records to UPPOST.
     C                   EXSR      WriteTotal
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  UpdatePOST - Update file for amounts and source-of-posting   *
      *                                                               *
      *  Called By: *main                                             *
      *                                                               *
      *****************************************************************
      *
     C     UpdatePOST    BEGSR
      *
      * Start reading postings file to update file.
     C     *LOVAL        SETLL     UPPOSTL0
     C                   READ      UPPOSTL0
     C                   DOU       %EOF
      * Calculate amount.
     C                   EVAL      SDCB = PSTA * (1-(DRCR*2))
      * Change source of posting if not generated entry.
     C                   IF        %SCAN('GE-':SPOS) = 0
     C                   EVAL      SPOS = ' Non-GE'
     C                   ENDIF
     C                   UPDATE    UPPOSTP0
     C                   READ      UPPOSTL0
     C                   ENDDO
      *
     C     UpdatePOSTE   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  WriteTotal - Write total records to UPPOST                   *
      *                                                               *
      *  Called By: *main                                             *
      *                                                               *
      *****************************************************************
      *
     C     WriteTotal    BEGSR
      *
      * Re=read postings file to calculate totals.
     C     *LOVAL        SETLL     UPPOSTL0
     C                   READ      UPPOSTL0
     C                   DOU       %EOF
      * If any of the key fields have changed ...
     C                   IF        BRCA <> SaveBRCA or
     C                             CNUM <> SaveCNUM or
     C                             CCY  <> SaveCCY  or
     C                             ACOD <> SaveACOD or
     C                             ACSQ <> SaveACSQ or
     C                             SPOS <> SaveSPOS
      * Add record with total amount for key but not if first read.
     C                   IF        SaveBRCA <> *blank
     C                   EXSR      WriteTotPost
     C                   ENDIF
      * Save new keys.
     C                   EVAL      PostAmount = SDCB
     C                   EVAL      PostCount  = 1
     C                   EVAL      SaveBRCA = BRCA
     C                   EVAL      SaveCNUM = CNUM
     C                   EVAL      SaveCCY  = CCY
     C                   EVAL      SaveACOD = ACOD
     C                   EVAL      SaveACSQ = ACSQ
     C                   EVAL      SaveBRCA = BRCA
     C                   EVAL      SaveSPOS = SPOS
      *
     C                   ELSE
      * Keep running count of amount.
     C                   EVAL      PostAmount = PostAmount + SDCB
     C                   EVAL      PostCount  = PostCount + 1
     C                   ENDIF
     C                   READ      UPPOSTL0
     C                   ENDDO
      *
      * Write final record.
     C                   EXSR      WriteTotPost
      *
     C     WriteTotalE   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  WriteTotPost - Write record                                  *
      *                                                               *
      *  Called By: *main                                             *
      *                                                               *
      *****************************************************************
      *
     C     WriteTotPost  BEGSR
      *
     C                   EVAL      PRECI = 'T'
     C                   EVAL      PBRCA = SaveBRCA
     C                   EVAL      PCNUM = SaveCNUM
     C                   EVAL      PCCY  = SaveCCY
     C                   EVAL      PACOD = SaveACOD
     C                   EVAL      PACSQ = SaveACSQ
     C                   EVAL      PBRCA = SaveBRCA
     C                   EVAL      PSPOS = SaveSPOS
     C                   EVAL      PSDCB = PostAmount
     C                   EVAL      PCHQN = PostCount
     C                   WRITE     APOSTPDF
      *
     C     WriteTotPostE ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     EPSSR         ENDSR
      *
      *****************************************************************
