     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Automatic Opening of GL Account - JRNE')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      *  GL000594J - Midas OF Automatic Opening of GL Account - JRNE  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD024772           Date 03Feb14               *
      *  Prev Amend No. MD024513           Date 23Jan14               *
      *                 MD023837           Date 27Nov13               *
      *                 CGL135B  *CREATE   Date 11Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries. (Recompile)                            *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed (Recompile)                                *
      *  CGL135B - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
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
     D P_BatchId       S             60A                                        Batch Id
     D S_BatchId       S             60A                                        selected batch Id
      *
      ** Batch Items
      *
     D DsItem          DS
     D   D_BDBTID                    60A                                        Batch Id
     D   D_BDIBCA                     3A                                        Input Branch Code
     D   D_BDACID                    10A                                        Customer number
     D   D_BDCYCD                     3A                                        Currency code
     D   D_BDACCD                    10A                                        Account code
     D   D_BDACSN                     2A                                        Account sequence
     D   D_BDNPSDT                    6A                                        New Posting date
      *
      * GL000590 parameters
      *
     D P_RtrnCode      S              7A                                        Return Code
     D P_Option        S              7A                                        Option
     D P_Branch        S              3A                                        Branch
     D P_Customer      S              6A                                        Customer
     D P_Currency      S              3A                                        Currency
     D P_AccntCode     S             10P 0                                      Account Code
     D P_AccntSeq      S              2P 0                                      Account Sequence
     D P_RetlAcNo      S             10P 0                                      Retail Account
     D P_OpnDate       S              5P 0                                      Date account opened
      *
      * Access objects parameters
      *
     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
      *
     D Recursive       S              1
      *
      *****************************************************************
      *                                                               *
      ** Main Processing                                              *
      *                                                               *
      *****************************************************************
      *
      ** Retrieve Batch Items corresponding to the Batch Id.
      *
     C/EXEC SQL DECLARE C1 CURSOR FOR
     C+    SELECT A.BDBTID,
     C+           A.BDIBCA,
     C+           A.BDACID,
     C+           A.BDCYCD,
     C+           A.BDACCD,
     C+           A.BDACSN,
     C+           A.BDNPSDT
     C+    FROM GLACBDTD A
     C+    WHERE A.BDBTID LIkE :S_BatchId
     C/END-EXEC
      *
     C/EXEC SQL
     C+  OPEN C1
     C/END-EXEC
      *
     C/EXEC SQL
     C+    FETCH NEXT FROM C1 INTO :DsItem
     C/END-EXEC
      *
     C                   DOW       SQLCODE <> 100
      *
      ** Convert new posting date
      *
     C                   EVAL      P_OpnDate  = *Zeros
      *
     C                   IF        D_BDNPSDT <> *Blanks
      *
     C                   MOVE      D_BDNPSDT     ZDATE                          Value date
     C                   CALL      'ZDATE1'                             99
     C                   PARM      *Blanks       ZERR              7            error code (Z r
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM      BJDFIN        ZDATFM            1            Date format ind
     C                   PARM      *Zeros        ZDAYNO            5 0          Value date
      *
     C                   IF        NOT *IN99       AND
     C                             ZERR = *Blanks
     C                   EVAL      P_OpnDate  = ZDAYNO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if account exists if not create it.
      *
     C                   MOVEL     D_BDACID      P_Customer                     Customer Number
     C                   MOVE(P)   D_BDACCD      P_AccntCode                    Account Code
     C                   MOVE(P)   D_BDACSN      P_AccntSeq                     Account Sequence
      *
      *
     C                   CALL      'GL000590J'                          99
     C                   PARM      *Blanks       P_RtrnCode                     Return Code
     C                   PARM      *Blanks       P_Option                       Option
     C                   PARM      D_BDIBCA      P_Branch                       Branch Code
     C                   PARM                    P_Customer                     Customer Number
     C                   PARM      D_BDCYCD      P_Currency                     Currency Code
     C                   PARM                    P_AccntCode                    Account Code
     C                   PARM                    P_AccntSeq                     Account Sequence
     C                   PARM      *Zeros        P_RetlAcNo                     Retail Account Nb
     C                   PARM                    P_OpnDate                      Date account opened
      *
     C/EXEC SQL
     C+    FETCH NEXT FROM C1 INTO :DsItem
     C/END-EXEC
      *
     C                   ENDDO
      *
     C/EXEC SQL
     C+  CLOSE C1
     C/END-EXEC
      *
      ** Release Resources
      *
     C                   CALL      'GL000590J'                          99
     C                   PARM      *Blanks       P_RtrnCode                     Return Code
     C                   PARM      '*CLOSE '     P_Option                       Option
     C                   PARM      *Blanks       P_Branch                       Branch Code
     C                   PARM      *Blanks       P_Customer                     Customer Number
     C                   PARM      *Blanks       P_Currency                     Currency Code
     C                   PARM      *Zeros        P_AccntCode                    Account Code
     C                   PARM      *Zeros        P_AccntSeq                     Account Sequence
     C                   PARM      *Zeros        P_RetlAcNo                     Retail Account Nb
     C                   PARM      *Zeros        P_OpnDate                      Date account opened
      *
     C                   SETON                                        LR
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
      *
      ** Retrieve Bank ICD details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C     DsBANK        PARM      *Blanks       DSFDY
      *
     C     EINZSR        ENDSR
      *
      *********************************************************************
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
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      ********************************************************************
