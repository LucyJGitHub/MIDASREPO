     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Accounting Rules Real Time Post')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      ***GL000588*-*Midas*OF*Accounting*Rules*Real*Time*Post***********                     MD029739
      *  DI000588 - Midas OF Accounting Rules Real Time Post          *                     MD029739
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029739 *RENAMED* Date 15Aug14               *
/*    *  Prev Amend No. MD028241           Date 19Aug14               *
      *                 MD025973           Date 25Mar14               *
      *                 MD023629           Date 08Jan14               *
      *                 MD023628           Date 09Nov13               *
      *                 CGL135B  *Create   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029739 - File renaming for integration layer.              *
/*    *  MD028241 - Real Time processing rollback issue.              *
      *  MD025973 - Intermitent Generation of Movement in MT940       *
      *  MD023629 - Accounting Rules Processing - Restart             *
      *  MD023628 - Accounting Rules Process - restart processing     *
      *  CGL135B - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
      *
      ** File DS
      *
      **   Midas GL Accounting Rules Batch Header
     D*DSACBHTD*     E DS                  EXTNAME(GLACBHTD) Prefix(H_)                     MD029739
     D DSACBHTD      E DS                  EXTNAME(DIACBHTD) Prefix(H_)                     MD029739
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
     D S_ARStatus      S             30                                         AR Status
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
     D P@BatchNum      S              3A                                        Batch Number
     D P@WorkStn       S             10A                                        Work Station
      *
     D WkRealTime      S              1A                                        Real Time Post flag
      *
     D WkBatchSts      S              1                                         Batch Status
     D WkBatchUse      S              1                                         Batch in Use
     D WkRealPost      S              1                                         Real Time Post
     D WkRealErr       S              1                                         Real Time Post Err
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
      ** Reset working value.
      *
     C******             EVAL      P_ARStatus = 'ERROR in Real Time Post'                  MD023628
     C                   EVAL      P_ARErrCod = *Blanks                                    MD023628
     C                   EVAL      WkRealPost = 'N'                             Real Time Post
     C                   EVAL      WkRealErr  = 'N'                             Real Time Post Err
      *
      ** If Real Time Post required.
      *
     C                   IF        WkRealTime <> 'Y'
     C                   GOTO      EndPgm
     C                   ENDIF
      *
      ** Declare cursor to retrieve header details
      *
     C/EXEC SQL DECLARE C1 CURSOR FOR
     C+    SELECT *
     C*+***FROM*GLACBHTD H                                                                  MD029739
     C+    FROM DIACBHTD H                                                                  MD029739
     C+    WHERE H.BHBTID LIKE :S_BatchId
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
      ** Retrieve batch Status
      *
     C/EXEC SQL
     C+  SELECT BRBTSF,
     C+         BRBIUF
     C+  INTO   :WkBatchSts,
     C+         :WkBatchUse
     C+  FROM GLJENHPD
     C+  WHERE BRBTNB LIKE :H_BHBTNB
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      P_ARErrCod = 'CGL0211'                                  MD023628
      *** Error Code: CGL0211 - No Batch Header.                                           MD023628
     C                   EVAL      WkRealErr  = 'Y'                             Real Time Post Err
     C                   GOTO      EndPgm
     C                   ENDIF
      *
      ** According Batch status
      *
     C                   SELECT
      *
      ** If Batch has been already Submitted
      *
     C                   WHEN      WkBatchSts = 'S'
      *                                                                                    MD023629
      ** Real Time Post succeeds                                                           MD023629
      *                                                                                    MD023629
     C                   EVAL      WkRealPost = 'Y'                                        MD023629
      *
      ** If Batch is still in Hold -> error
      *
     C                   WHEN      WkBatchSts = 'H'
     C                   EVAL      P_ARErrCod = 'CGL0212'                                  MD023628
      *** Error Code: CGL0212 - Batch Header held.                                         MD023628
     C                   EVAL      WkRealErr  = 'Y'                             Real Time Post sts
     C                   GOTO      EndPgm
      *
      ** If Batch is in Use
      *
     C                   WHEN      WkBatchSts = 'A' AND
     C                             WkBatchUse = 'Y'
     C                   EVAL      P_ARErrCod = 'CGL0213'                                  MD023628
      *** Error Code: CGL0213 - Batch Header in used.                                      MD023628
     C                   EVAL      WkRealErr  = 'Y'                             Real Time Post sts
     C                   GOTO      EndPgm
      *
     C                   WHEN      WkBatchSts = 'A'
      *
      ** If Batch is Approved -> start real time post
      *
      ** Update journal header details.
      *
     C                   EVAL      WkBatchSts = 'S'
      *
     C/EXEC SQL
     C+  UPDATE GLJENHPD
     C+    SET BRBTSF = :WkBatchSts
     C+  WHERE BRBTNB = :H_BHBTNB
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      P_ARErrCod = 'CGL0214'                                  MD023628
      *** Error Code: CGL0214 - Batch Header update failed.                                MD023628
     C                   EVAL      WkRealErr  = 'Y'                             Real Time Post Err
     C*******            EXSR      *PSSR                                                   MD023628
     C                   GOTO      EndPgm                                                  MD023628
     C                   ENDIF
      *
     C                   COMMIT                                                            MD023628
      *
     C**********         CALL      'GLC000588'                          99                  MD025973
     C**********         PARM      *Blanks       P@RTCD                                     MD025973
     C**********         PARM      H_BHBTNB      P@BatchNum                                 MD025973
      *
     C**********         IF        *IN99  OR P@RTCD <> *Blanks                              MD025973
                                                                                            MD025973
     C                   CALL      'GLC000589'                          99                  MD025973
     C                   PARM      H_BHBTNB      P@BatchNum                                 MD025973
     C**********         PARM                    P@WorkStn                         MD025973 MD028241
                                                                                            MD025973
     C                   IF        *IN99 = *ON                                              MD025973
      *                                                                                     MD025973
     C                   EVAL      P_ARErrCod = 'CGL0215'                                  MD023628
      *** Error Code: CGL0215 - Real Time Post processing failed.                          MD023628
     C                   EVAL      WkRealErr  = 'Y'                             Real Time Post sts
     C                   GOTO      EndPgm
     C                   ENDIF
      *
      ** Check the Status - In case of error GL0451 reset the batch status flag.
      *
     C/EXEC SQL
     C+  SELECT BRBTSF
     C+  INTO   :WkBatchSts
     C+  FROM GLJENHPD
     C+  WHERE BRBTNB LIKE :H_BHBTNB
     C/END-EXEC
      *
      ** If Batch status is not Submitted -> Error
      *
     C                   IF        SQLCODE    <>  0  OR
     C                             WkBatchSts <> 'S'
     C                   EVAL      P_ARErrCod = 'CGL0216'                                  MD023628
      *** Error Code: CGL0216 - Real Time Post failed.                                     MD023628
     C                   EVAL      WkRealErr  = 'Y'                             Real Time Post Err
     C                   GOTO      EndPgm
     C                   ENDIF
      *
      ** Real Time Post succeeds
      *
     C                   EVAL      WkRealPost = 'Y'
      *
     C                   ENDSL
      *
      ** Update header details.
      *
     C/EXEC SQL
     C*+*UPDATE*GLACBHTD                                                                    MD029739
     C+  UPDATE DIACBHTD                                                                    MD029739
     C+    SET BHBTSF = :WkBatchSts
     C+  WHERE BHBTID = :H_BHBTID
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      P_ARErrCod = 'CGL0217'                                  MD023628
      *** Error Code: CGL0217 - AR Batch Header update failed.                             MD023628
     C                   EVAL      WkRealErr  = 'Y'                             Real Time Post Err
     C******             EXSR      *PSSR                                                   MD023628
     C                   GOTO      EndPgm                                                  MD023628
     C                   ENDIF
      *
     C                   COMMIT                                                            MD023628
      *
     C/EXEC SQL
     C+  FETCH NEXT FROM C1 INTO :DSACBHTD
     C/END-EXEC
      *
     C                   ENDDO
      *
     C     EndPgm        TAG
      *
     C/EXEC SQL
     C+  CLOSE C1
     C/END-EXEC
      *
      ** Update Batch Id Status Parameter
      *
     C                   SELECT
     C                   WHEN      WkRealPost = 'N' AND
     C                             WkRealErr  = 'N'
     C                   EVAL      P_ARStatus = S_ARStatus
      *
     C                   WHEN      WkRealPost = 'Y' AND
     C                             WkRealErr  = 'N'
     C******             EVAL      P_ARStatus = 'Real Time Post Succeeded'
     C                   EVAL      P_ARStatus = 'Real Time Post'                           MD023628
      *
     C                   WHEN      WkRealErr = 'Y'
     C                   EVAL      P_ARStatus = 'Real Time Post Failed'
     C                   ENDSL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
     C     S_ARStatus    PARM                    P_ARStatus
     C                   PARM                    P_ARErrCod                                MD023628
      *
      ** Retrieve Bank ICD details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C     DsBANK        PARM      *Blanks       DSFDY
      *
      ** Retrieve Accounting Rules Real Time Post Flag
      *
     C                   EVAL      P@OP01 = 'AcctRulesRealTimPost'
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
     C                   EVAL      WkRealTime  = P@VL01
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
     C                   EVAL      P_ARErrCod = 'CGL0210'                                  MD023628
      *** Error Code: CGL0210 - Real Time Post failed.                                     MD023628
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
