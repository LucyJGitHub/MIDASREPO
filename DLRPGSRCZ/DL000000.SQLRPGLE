     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL Zeroise RODN for deals - utility')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  DL000000 - Zeroise rollover deal numbers for deals           *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 MD021155 *CREATE   Date 23Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  MD021155 - COB Restructure Phase 1 remnants                  *
      *           - Rewrite of upgrade program to avoid creating      *
      *             files.                                            *
      *                                                               *
      *****************************************************************
      *
     D Action          S              7
     D UpdateMsg       S            100
     D UpdateFlag      S              1    INZ('N')
     D Program         S             10    INZ('DL000000')
     D Recursive       S              1    INZ('N')
      *
     D                 DS
     D  DealNoA                1      6
     D  DealNoN                1      6  0
     D                 DS
     D  RODealNoA              1      6
     D  RODealNoN              1      6  0
     D                 DS
     D  RODNN                  1      6  0
     D  RODNA                  1      6
      *
     D DCDEALS       E DS                  EXTNAME(DEALSDC)
      *
     D PSDS           SDS
     D PSExcpType             40     42
     D PSExcpNo               43     46
      *
      * Prepare to read DEALSDC.
     C/exec SQL
     C+ declare DCCursor cursor for
     C+ select * from DEALSDC
     C+ where
     C+     RODN <> 0
     C+ and RECI = 'D'
     C/end-exec
      *
     C/exec SQL
     C+ open DCCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DCCursor
     C+ into :DCDEALS
     C/end-exec
      *
      * Loop through DEALSDC.
     C                   DOW       SQLCODE = 0
     C                   EVAL      DealNoN = DLNO
     C                   EVAL      RODNN = RODN
      *
     C                   EXSR      DealsCheck
      *
     C/exec SQL
     C+ fetch next
     C+ from DCCursor
     C+ into :DCDEALS
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close DCCursor
     C/end-exec
      *
      * Only produce report if errors encountered.
     C                   IF        UpdateFlag <> 'Y'
     C                   EVAL      UpdateMsg = 'No deals updates were required.'
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      Action
     C                   PARM                    Program
     C                   PARM                    UpdateMsg
     C                   ENDIF
     C                   CALL      'UP008010'
     C                   PARM      '*REPORT'     Action
     C                   PARM                    Program
     C                   PARM      *blank        UpdateMsg
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *
     C     DealsCheck    BEGSR
      *
     C/exec SQL
     C+ select RBDN into :RODealNoN
     C+ from DEALSDC
     C+   where
     C+ DLNO = :RODNN
     C/end-exec
      *
     C                   IF        SQLCODE = 0 and
     C                             DealNoN = RODealNoN
     C                   LEAVESR
     C                   ELSE
     C/exec SQL
     C+ select RBDN into :RODealNoN
     C+ from DLCHISPD
     C+   where
     C+ DLNO = :RODNN
     C/end-exec
      *
     C                   IF        SQLCODE = 0 and
     C                             DealNoN = RODealNoN
     C                   LEAVESR
     C                   ELSE
     C/exec SQL
     C+ select HKDADN into :RODealNoA
     C+ from MMDELDPP
     C+   where
     C+ HKDN38 = :RODNN
     C/end-exec
      *
     C                   IF        SQLCODE = 0 and
     C                             DealNoA = RODealNoA
     C                   LEAVESR
      *
     C                   ELSE
     C                   EXSR      UpdateDeals
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     CheckDealsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     UpdateDeals   BEGSR
      *
     C/exec SQL
     C+ update DEALSDC
     C+ set
     C+   RODN = 0
     C+ , RODA = 0
     C+ where current of DCCursor
     C/end-exec
      *
     C/exec SQL
     C+ update MMDELDPP
     C+ set
     C+   HKDADN = ' '
     C+ , HKRBAT = 0
     C+   where
     C+ HKDN38 = :DealNoN
     C/end-exec
      *
     C                   EXSR      UpdateReport
      *
     C     UpdateDealsE  ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     UpdateReport  BEGSR
      *
     C                   EVAL      UpdateFlag = 'Y'
     C                   CLEAR                   UpdateMsg
     C                   EVAL      UpdateMsg = 'Deal Number: ' + DealNoA +
     C                             '                 ' +
     C                             'Rollover Deal Number: ' + RODealNoA
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      Action
     C                   PARM                    Program
     C                   PARM                    UpdateMsg
      *
     C     UpdateReportE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
