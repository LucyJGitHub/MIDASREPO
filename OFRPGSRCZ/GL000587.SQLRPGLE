     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Accounting Rules Submit transactions')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      *  GL000587 - Midas OF Accounting Rules Submit transactions     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD026935           Date 15May14               *
      *  Prev Amend No. MD025869           Date 24Mar14               *
      *                 MD024772           Date 03Feb14               *
      *                 MD024513           Date 23Jan14               *
      *                 MD024534           Date 24Jan14               *
      *                 MD023629           Date 08Jan14               *
      *                 MD023837           Date 27Nov13               *
      *                 MD023628           Date 09Nov13               *
      *                 CGL135B  *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026935 - Journal Entry 'Accepted' status issue.            *
      *  MD025869 - Multiple items in one csv file but with missing   *
      *             accounting rule. Batch status is accepted.        *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries. (Recompile)                            *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  MD024534 - According to-authorize, insert batch header as    *
      *             authorized or not                                 *
      *  MD023629 - Accounting Rules Processing - Restart             *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed                                            *
      *  MD023628 - Accounting Rules Process - restart processing     *
      *  CGL135B - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
      *
      ** File DS
      *
      **   Midas GL Accounting Rules Batch Header
     D DsACBHTD      E DS                  EXTNAME(GLACBHTD) Prefix(H_)
      *
      **   Midas GL Accounting Rules Batch Details
     D DsACBDTD      E DS                  EXTNAME(GLACBDTD) Prefix(I_)
      *
      **   Midas GL Journal entry header
     D DsJENHPD      E DS                  EXTNAME(GLJENHPD) Prefix(B_)
      *
      **   Midas GL Journal entry header
     D DsJENPPD      E DS                  EXTNAME(GLJENPPD) Prefix(E_)
      *
      * Bank Details
     D DsBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Local data Area
     D LDA           E DS                  EXTNAME(LDA) DTAARA
      *
      * Entry's parameters
      *
     D P_BatchId       S             60                                         Batch Id
     D S_BatchId       S             60                                         Batch Id
     D P_ARStatus      S             30                                         AR Status
     D P_ARErrCod      S             10                                         AR Err CodeMD023628
      *
      * Access objects parameters
     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A
      *
     D P@Actcde        S              1A                                        Action Code
     D P@TransType     S              4A                                        Transaction Type
     D P@BITH          S                   LIKE(DSACBHTD)                       JRNE - Batch Header
     D P@BITP          S                   LIKE(DSACBDTD)                       JRNE - Batch Item
      *
     D WkAutoAuth      S              1A                                        Auto Authorize Ind.
      *
     D WkBIdSts        S             10                                         Batch Id Status
     D WkHeadErr       S              1                                         Header Error
     D WkItemErr       S              1                                         Item error
     D WkItemNum       S              3A                                        Item Number
     D WkCounter       S              5I 0                                      Counter     MD024534
     D*WkCmdDly*       S             15A   INZ('DLYJOB DLY(3)')                 ComMD024534 MD025869
     D WkCmdDly        S             15A   INZ('DLYJOB DLY(10)')                            MD025869
     D WkLength        S             15P 5 INZ(15)                              Length      MD024534
      *
     D Recursive       S              1
      *
      /EJECT
      *
      *****************************************************************
      * Main routine                                                  *
      *****************************************************************
      *
      ** Start commitment control                                                          MD023628
      *                                                                                    MD023628
     C/EXEC SQL                                                                            MD023628
     C+ SET OPTION COMMIT = *CHG                                                           MD023628
     C/END-EXEC                                                                            MD023628
      *
     C******             EVAL      P_ARStatus = 'Journal Entry Failed'                     MD023628
     C                   EVAL      P_ARErrCod = *Blanks                                    MD023628
     C                   EVAL      WkBIdSts   = *Blanks
     C                   EVAL      WkHeadErr  = 'N'                             Header Error
      *
      ** Declare cursor to retrieve header details
      *
     C/EXEC SQL DECLARE C1 CURSOR FOR
     C+  SELECT *
     C+  FROM GLACBHTD H
     C+  WHERE H.BHBTID LIKE :S_BatchId
     C/END-EXEC
      *
      ** Declare cursor to retrieve item details
      *
     C/EXEC SQL DECLARE C2 CURSOR FOR
     C+  SELECT *
     C+  FROM GLACBDTD I
     C+  WHERE I.BDFOAS LIKE :H_BHFRNT
     C+    AND I.BDCRST <> 'I'                                                             MD023837
     C/END-EXEC
      *
      ** Retrieve batch header(s) corresponding to batch Id.
      *
     C/EXEC SQL
     C+  OPEN C1
     C/END-EXEC
      *
     C/EXEC SQL
     C+  FETCH NEXT FROM C1 INTO :DSACBHTD
     C/END-EXEC
      *
     C                   DOW       SQLCODE <> 100
      *
      ** If batch number is blank,
      *
     C                   IF        H_BHBTNB = *Blanks
      *
      ** If batch header does not exist for the Front Office Reference,                    MD023628
      *                                                                                    MD023628
     C/EXEC SQL                                                                            MD023628
     C+  SELECT *                                                                          MD023628
     C+  INTO   :DsJENHPD                                                                  MD023628
     C+  FROM GLJENHPD                                                                     MD023628
     C+  WHERE BRAFRT LIKE :H_BHFRNT                                                       MD023628
     C/END-EXEC                                                                            MD023628
      *
     C                   IF        SQLCODE <> 0
      *
      ** Insert Jounal Entry Batch Header
      *
     C                   CALL      'GL000587H'                          99
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      *Blanks       P@OPTN
     C                   PARM      'I'           P@Actcde
     C                   PARM      'BITH'        P@TransType
     C                   PARM      DSACBHTD      P@BITH
     C                   PARM      *Blanks       P@BITP
      *
     C******             IF        *IN99 OR P@RTCD = '*ERROR'                              MD023628
     C******             GOTO      EndPgm                                                  MD023628
     C******             ENDIF                                                             MD023628
     C******             IF        P@RTCD    <> *Blanks                                    MD023628
     C******             EVAL      WkHeadErr =  'Y'                                        MD023628
     C******             GOTO      EndPgm                                                  MD023628
     C******             ENDIF                                                             MD023628
      *                                                                                    MD023628
     C                   IF        *IN99 OR P@RTCD <> *Blanks                              MD023628
     C                   EVAL      P_ARErrCod = 'CGL0201'                                  MD023628
      *** Error Code: CGL0201 - Batch Header creation failed.                              MD023628
     C                   EVAL      WkHeadErr =  'Y'                                        MD023628
     C                   GOTO      EndPgm                                                  MD023628
     C                   ENDIF                                                             MD023628
      *
      ** Retrieve the batch details - Key: Associated front office reference
      *
     C/EXEC SQL
     C+  SELECT *
     C+  INTO   :DsJENHPD
     C+  FROM GLJENHPD
     C+  WHERE BRAFRT LIKE :H_BHFRNT
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      P_ARErrCod = 'CGL0202'                                  MD023628
      *** Error Code: CGL0202 - Batch Header details retrieval failed.                     MD023628
     C                   EVAL      WkHeadErr =  'Y'
     C                   GOTO      EndPgm
     C                   ENDIF
      *
     C                   ENDIF                                                             MD023628
      *
     C                   EVAL      H_BHBTNB    = B_BRBTNB                       Batch number
     C                   EVAL      H_BHBTSF    = B_BRBTSF                       Batch status flag
      *
      ** Update header details.
      *
     C/EXEC SQL
     C+  UPDATE GLACBHTD
     C+    SET BHBTNB = :H_BHBTNB,
     C+        BHBTSF = :H_BHBTSF
     C+  WHERE BHBTID = :H_BHBTID AND
     C+        BHFRNT = :H_BHFRNT
     C/END-EXEC
      *                                                                                    MD023628
     C                   IF        SQLCODE <> 0                                            MD023628
     C                   EVAL      P_ARErrCod = 'CGL0203'                                  MD023628
      *** Error Code: CGL0203 - AR Header update failed.                                   MD023628
     C                   EVAL      WkHeadErr =  'Y'                                        MD023628
     C                   EXSR      *PSSR                                                   MD023628
     C                   ENDIF                                                             MD023628
      *                                                                                    MD023628
     C                   COMMIT                                                            MD023628
      *
     C                   ENDIF
      *
      ** Insert Jounal Entry Batch Items
      *
     C                   EVAL      WkItemErr = 'N'
      *
     C                   EXSR      SRBatchItem
      *
      ** Authorized the batch according the system value 'Accounting Rules Auto Authorise'
      ** and no item error
      *
     C                   IF        WkAutoAuth = 'Y' AND
     C                             WkItemErr  = 'N'
      *                                                                                     MD024534
      ** No need to re-authorize the batch header if auto-authorize is 'Y'                  MD024534
      *                                                                                     MD024534
      *
      ***Update*Batch*Status*Flag*as*Approved**************************                     MD024534
      *
     C**********         EVAL      H_BHBTSF = 'A'                                           MD024534
      *
      ***Approve*the*batch*********************************************                     MD024534
      *
     C**********         CALL      'GL000587H'                          99                  MD024534
     C**********         PARM      *Blanks       P@RTCD                                     MD024534
     C**********         PARM      *Blanks       P@OPTN                                     MD024534
     C**********         PARM      'C'           P@Actcde                                   MD024534
     C**********         PARM      'BITH'        P@TransType                                MD024534
     C**********         PARM      DSACBHTD      P@BITH                                     MD024534
     C**********         PARM      *Blanks       P@BITP                                     MD024534
      *
     C**********         IF        *IN99 OR P@RTCD = '*ERROR'                               MD024534
     C**********         EVAL      P_ARErrCod = 'CGL0207'                                   MD024534
      ****Error*Code:*CGL0207*-*Batch*approval*failed.*****************                     MD024534
     C**********         EVAL      WkHeadErr =  'Y'                                         MD024534
     C**********         GOTO      EndPgm                                                   MD024534
     C**********         ENDIF                                                              MD024534
      *                                                                                     MD024534
      ** Loop until the batch is not more in 'Use' (only 5 loops)                           MD024534
      *                                                                                     MD024534
     C                   EVAL      WkCounter = *Zeros                                       MD024534
      *                                                                                     MD024534
     C**********         DOU       B_BRBIUF = *Blanks                              MD024534 MD026935
     C**********                   OR WkCounter = 5                                MD024534 MD025869
     C                   DOU       B_BRBIUF = 'A'                                           MD026935
     C                             OR WKCOUNTER = H_BHHINI                                  MD025869
      *
      ** Retrieve the batch status flag
      *
     C/EXEC SQL
     C+  SELECT *
     C+  INTO   :DsJENHPD
     C+  FROM GLJENHPD
     C+  WHERE BRAFRT LIKE :H_BHFRNT
     C/END-EXEC
      *                                                                                    MD023628
     C                   IF        SQLCODE <> 0                                            MD023628
     C                   EVAL      P_ARErrCod = 'CGL0208'                                  MD023628
      *** Error Code: CGL0208 - Batch Header details retrieval failed.                     MD023628
     C                   EVAL      WkHeadErr =  'Y'                                        MD023628
     C                   GOTO      EndPgm                                                  MD023628
     C                   ENDIF                                                             MD023628
      *
     C                   EVAL      H_BHBTSF    = B_BRBTSF                       Batch status flag
      *                                                                                     MD024534
      ** If batch is 'In Use', delay job 3 seconds and re-check the batch                   MD024534
      *                                                                                     MD024534
     C**********         IF        B_BRBIUF <> *Blanks                             MD024534 MD025869
     C                   IF        B_BRBIUF = ' ' AND                                       MD025869
     C                             B_BRBTSF = 'A'                                           MD025869
     C                   ELSE                                                               MD025869
     C                   CALL      'QCMDEXC'                            99                  MD024534
     C                   PARM                    WkCmdDly                                   MD024534
     C                   PARM                    WkLength                                   MD024534
     C                   ENDIF                                                              MD024534
      *                                                                                     MD024534
     C                   ADD       1             WkCounter                                  MD024534
      *                                                                                     MD024534
     C                   ENDDO                                                              MD024534
      *
      ** Update header details.
      *
     C/EXEC SQL
     C+  UPDATE GLACBHTD
     C+    SET BHBTNB = :H_BHBTNB,
     C+        BHBTSF = :H_BHBTSF
     C+  WHERE BHBTID = :H_BHBTID AND
     C+        BHFRNT = :H_BHFRNT
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      P_ARErrCod = 'CGL0209'                                  MD023628
      *** Error Code: CGL0209 - AR Header update failed.                                   MD023628
     C                   EVAL      WkHeadErr =  'Y'                                        MD023628
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Update Batch Id status
      *
     C                   SELECT
     C**********         WHEN      H_BHBTSF = 'A' AND WkBIdSts <> 'HELD'                    MD025869
     C                   WHEN      H_BHBTSF = 'A'                                           MD025869
     C                   EVAL      WkBIdSts = 'ACCEPTED'
     C                   WHEN      H_BHBTSF = 'H'
     C                   EVAL      WkBIdSts = 'HELD'
     C                   ENDSL
      *
     C/EXEC SQL
     C+  FETCH NEXT FROM C1 INTO :DSACBHTD
     C/END-EXEC
      *
     C                   ENDDO
      *
      ** Update Batch Id Status Parameter
      *
     C                   SELECT
     C                   WHEN      WkBIdSts = 'HELD'
     C**********         EVAL      P_ARStatus = 'Journal Entry Held'                        MD023629
     C                   EVAL      P_ARStatus = 'Journal Batch Held'                        MD023629
     C                   WHEN      WkBIdSts = 'ACCEPTED'
     C**********         EVAL      P_ARStatus = 'Journal Entry Accepted'                    MD023629
     C                   EVAL      P_ARStatus = 'Journal Batch Accepted'                    MD023629
     C                   ENDSL
      *
     C     EndPgm        TAG
      *
     C/EXEC SQL
     C+  CLOSE C1
     C/END-EXEC
      *
      ** Release resource
      *
     C                   CALL      'GL000587H'                          99
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*CLOSE '     P@OPTN
     C                   PARM      *Blanks       P@Actcde
     C                   PARM      *Blanks       P@TransType
     C                   PARM      *Blanks       P@BITH
     C                   PARM      *Blanks       P@BITP
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBatchItem - Insert Batch Item                               *
      *****************************************************************
      *
     C     SRBatchItem   BEGSR
      *
      ** Retrieve batch item(s) corresponding to front office associated deal
      *
     C/EXEC SQL
     C+  OPEN C2
     C/END-EXEC
      *
     C/EXEC SQL
     C+  FETCH NEXT FROM C2 INTO :DSACBDTD
     C/END-EXEC
      *
     C                   DOW       SQLCODE <> 100
      *
      ** If batch number is blank, insert Jounal Entry Batch Item
      *
     C                   IF        I_BDBTNB = *Blanks
      *
     C                   EVAL      I_BDBTNB = H_BHBTNB
      *
     C                   CALL      'GL000587H'                          99
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      *Blanks       P@OPTN
     C                   PARM      'I'           P@Actcde
     C                   PARM      'BITP'        P@TransType
     C                   PARM      DSACBHTD      P@BITH
     C                   PARM      DSACBDTD      P@BITP
      *
     C                   SELECT
      *
     C                   WHEN      *IN99 OR P@RTCD = '*ERROR'
     C                   EVAL      P_ARErrCod = 'CGL0204'                                  MD023628
      *** Error Code: CGL0204 - Batch Item creation failed.                                MD023628
     C                   EVAL      WkItemErr = 'Y'
     C*******            GOTO      SRBatchItemE                                            MD023628
     C                   LEAVESR                                                           MD023628
      *
     C                   WHEN      P@RTCD <> *Blanks
     C                   EVAL      P_ARErrCod = 'CGL0205'                                  MD023628
      *** Error Code: CGL0205 - Batch Item not valid.                                      MD023628
     C                   EVAL      WkItemErr = 'Y'
     C                   ENDSL
      *
      ** Retrieve the batch Item Number
      **  RMK: In GLJENPPD, the Front Office Trans ID is always 'APCTRANVU' + batch number
      **       So, it is not possible to retrieve the Item number.
      *
     C*EXEC SQL
     C** SELECT *
     C** INTO   :DsJENPPD
     C** FROM GLJENPPD
     C** WHERE BTAFRT LIKE :I_BDFOTR
     C**
     C*END-EXEC
      *
     C****               IF        SQLCODE <> 0
     C****               EVAL      WkItemErr = 'Y'
     C****               GOTO      SRBatchItemE
     C****               ENDIF
      *
     C****               MOVE      E_BTBINB      WkItemNum
      *
      ** Update item details
      *
     C/EXEC SQL
     C+  UPDATE GLACBDTD
     C+    SET BDBTNB = :I_BDBTNB
     C****     BDBINB = :WkItemNum
     C+  WHERE BDFOTR = :I_BDFOTR  AND
     C+        BDFOAS = :I_BDFOAS
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      P_ARErrCod = 'CGL0206'                                  MD023628
      *** Error Code: CGL0206 - AR details update failed.                                  MD023628
     C                   EVAL      WkItemErr = 'Y'                                         MD023628
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   COMMIT                                                            MD023628
      *
     C                   ENDIF
      *
     C     SRBatchItemE  TAG
      *
     C/EXEC SQL
     C+  FETCH NEXT FROM C2 INTO :DSACBDTD
     C/END-EXEC
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C     S_BatchId     PARM                    P_BatchId
     C                   PARM                    P_ARStatus
     C                   PARM                    P_ARErrCod
      *
      ** Retrieve Bank ICD details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C     DsBANK        PARM      *Blanks       DSFDY
      *
      ** Retrieve Auto Authorise
      *
     C                   EVAL      P@OP01 = 'AcctRulesAutoAuth'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM                    P@OP01
     C                   PARM      *Blanks       P@VL01
     C                   PARM                    P@OP02
     C                   PARM                    P@VL02
     C                   PARM                    P@OP03
     C                   PARM                    P@VL03
     C                   PARM                    P@OP04
     C                   PARM                    P@VL04
     C                   PARM                    P@OP05
     C                   PARM                    P@VL05
     C                   PARM                    P@OP06
     C                   PARM                    P@VL06
     C                   PARM                    P@OP07
     C                   PARM                    P@VL07
     C                   PARM                    P@OP08
     C                   PARM                    P@VL08
     C                   PARM                    P@OP09
     C                   PARM                    P@VL09
     C                   PARM                    P@OP10
     C                   PARM                    P@VL10
      *
     C     P@RTCD        IFEQ      *Blanks
     C                   EVAL      WkAutoAuth  = P@VL01
     C                   ENDIF
      *
     C     EINZSR        ENDSR
      *
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *                                                                   *
      * Called by:                                                        *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ROLBK                                                             MD023628
     C                   ENDIF
      *
     C                   IF        P_ARErrCod = *Blanks                                    MD023628
     C                   EVAL      P_ARErrCod = 'CGL0200'                                  MD023628
      *** Error Code: CGL0200 - Journal Entry failed.                                      MD023628
     C                   ENDIF                                                             MD023628
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      ********************************************************************
      *
