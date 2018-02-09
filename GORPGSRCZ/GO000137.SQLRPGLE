     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GO Check Outgoing Msgs Awaiting Transmission')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO000137 - Midas GO Check Outgoing Messages                  *
      *             Awaiting Transmission                             *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD020167           Date 23Apr13               *
      *                 CCB023A            Date 06Aug12               *
      *                 AR1092060          Date 27Feb13               *
      *                 CCB023  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CCB023A - COB Restructure - Input Cycle Termination          *
      *            Restructuring                                      *
      *  AR1092060 - GO000138 Error encountered before starting       *
      *              GN EN zone COB (clean cob)                       *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring                                       *
      *                                                               *
      *****************************************************************
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)                                    AR1092060
      *                                                                                    AR1092060
     D/COPY ZACPYSRC,PSDS                                                                  AR1092060
      *
      ** Declared variables
      *
     D PROT            S              4
     D SVALK1          S             20
     D SVAL1           S            200
     D RTCD            S              7
     D OPTN            S              7
     D REOPN           S              1
     D MAXLEN          S              3S 0 INZ(150)
     D QMSGD           S            150
     D QMSG            C                   CONST('SNDMSG MSG(''Outstanding mess+
     D                                            ages awaiting transmission. P+
     D                                            ls reopen input cycle as per +
     D                                            COB Predefined Decision Table+
     D                                            .'') TOMSGQ(MOPERQ)')
     D Value           S              5                                                    AR1092060
      *                                                                                    AR1092060
     C/COPY GOCPYSRC,GOUPD_PARM                                                            AR1092060
      *
      ** Initialise variables
      *
     C                   IF        Key_Desc = 'WaitTransOutMsg'                            AR1092060
     C                   EVAL      SVALK1= 'ReopenSwiftTrans'
     C                   EVAL      OPTN = '*FIRST'
      *
      ** Get 'ReopenSwiftTrans' system value from file SDSVALPD
      *
     C/EXEC SQL
     C+ Declare SCursor Insensitive scroll cursor for
     C+ SELECT GIVAL FROM SDSVALPD WHERE
     C+ GISVAL = :SVALK1
     C/END-EXEC
      *
     C/EXEC SQL
     C+ Open SCursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH NEXT FROM SCursor INTO :SVAL1
     C/END-EXEC
      *
      ** If the 'ReopenSwiftTrans' system value
      ** is missing then end abnormally
      *
     C                   IF        SQLCOD <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access PF/SDMGMEPD to determine whether communications
      ** are through the SWIFT interface or through the
      ** Merva interface
      *
     C/EXEC SQL
     C+ Declare MCursor Insensitive scroll cursor for
     C+ SELECT ENPRUS FROM SDMGMEPD
     C/END-EXEC
      *
     C/EXEC SQL
     C+ Open MCursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH NEXT FROM MCursor INTO :PROT
     C/END-EXEC
      *
      ** Database error handling
      *
     C                   IF        SQLCOD <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If created/amended msgs awaiting tranmission give
      ** opportunity to report input cycle
      ** Call created/amended msgs awaiting transmission report
      *
     C                   CALL      'MEC0400'
      *
     C                   IF        *INU6 = *ON
     C                   EVAL      REOPN = 'Y'
     C                   ENDIF
      *
     C                   IF        REOPN = 'Y' and
     C                             %SUBST(SVAL1:1:1) = 'Y'
     C                   EVAL      QMSGD = QMSG
     C                   CALL      'QCMDEXC'
     C                   PARM                    QMSGD
     C                   PARM                    MAXLEN
     C                   IF        PROT = 'APPC'
     C                   CALL      'MSC6001'
     C                   ELSE
     C                   CALL      'MSC4001'
     C                   ENDIF
     C**********         EXSR      *PSSR                                                   AR1092060
     C                   EVAL      Value = '00001'                                         AR1092060
     C                   ELSE                                                              AR1092060
     C                   EVAL      Value = '00000'                                         AR1092060
     C                   ENDIF
      *
     C/EXEC SQL
     C+ Close SCursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ Close MCursor
     C/END-EXEC
      *                                                                                    AR1092060
     C                   IF        %Open(GPDWNLL0)                                         AR1092060
     C                   CLOSE     GPDWNLL0                                                AR1092060
     C                   ENDIF                                                             AR1092060
     C                   ENDIF                                                             AR1092060
      *                                                                                    AR1092060
     C/COPY GOCPYSRC,GOUPD_DWNL                                                            AR1092060
      *
     C                   EVAL      *INLR = *ON                                               CCB023A
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
     C                   ENDSR
      ****************************************************************
