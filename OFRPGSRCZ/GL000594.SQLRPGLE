     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Automatic Opening of GL Account - JRNE')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      *  GL000594 - Midas OF Automatic Opening of GL Account - JRNE   *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL135A  *CREATE   Date 11Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL135A - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
      *
     D P_RtnCde        S              7A                                        Return Code
     D P_BatchNb       S              3A                                        Batch Number
     D S_BatchNb       S              3A                                        selected batch
      *
      ** Batch Items
      *
     D DsItem          DS
     D   D_BTBTNB                     3A                                        Batch number
     D   D_BTBINB                     3  0                                      Batch item no
     D   D_BTPTDT                     5  0                                      Posting date
     D   D_BTIBCA                     3A                                        Input Branch Code
     D   D_BTCUST                     6A                                        Customer number
     D   D_BTCYCD                     3A                                        Currency code
     D   D_BTACCD                    10A                                        Account code
     D   D_BTACSN                     2A                                        Account sequence
     D   D_BEPSDN                     5  0
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
     D Recursive       S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    P_RtnCde
     C     S_BatchNb     PARM                    P_BatchNb
      *
     C                   EVAL      P_RtnCde = *Blanks
      *
      ** Retrieve Batch Items corresponding to the Batch number.
      *
     C/EXEC SQL DECLARE C1 CURSOR FOR
     C+    SELECT A.BTBTNB,
     C+           A.BTBINB,
     C+           A.BTPTDT,
     C+           A.BTIBCA,
     C+           A.BTCUST,
     C+           A.BTCYCD,
     C+           A.BTACCD,
     C+           A.BTACSN,
     C+           CASE WHEN B.BEPSDN IS NOT NULL THEN B.BEPSDN ELSE A.BTPTDT END AS PSDN
     C+    FROM GLJENPPD A LEFT JOIN GLJENP1D B ON
     C+           A.BTBTNB = B.BEBTNB and
     C+           A.BTBINB = B.BEBINB and
     C+           A.BTPTDT = B.BEPSTD
     C+    WHERE A.BTBTNB LIkE :S_BatchNb
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
      ** Check if account exists if not create it.
      *
     C                   MOVE(P)   D_BTACCD      P_AccntCode                    Account Code
     C                   MOVE(P)   D_BTACSN      P_AccntSeq                     Account Sequence
      *
     C                   CALL      'GL000590'                           99
     C                   PARM      *Blanks       P_RtrnCode                     Return Code
     C                   PARM      *Blanks       P_Option                       Option
     C                   PARM      D_BTIBCA      P_Branch                       Branch Code
     C                   PARM      D_BTCUST      P_Customer                     Customer Number
     C                   PARM      D_BTCYCD      P_Currency                     Currency Code
     C                   PARM                    P_AccntCode                    Account Code
     C                   PARM                    P_AccntSeq                     Account Sequence
     C                   PARM      *Zeros        P_RetlAcNo                     Retail Account Nb
     C                   PARM      D_BEPSDN      P_OpnDate                      Date account opened
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
     C                   CALL      'GL000590'                           99
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
