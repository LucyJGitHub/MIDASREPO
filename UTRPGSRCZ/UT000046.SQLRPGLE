      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
     F*****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas UT Get Message Description')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000046 - Update Error Message Description                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF011   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
     F*****************************************************************

     D OutTable      E DS                  EXTNAME(UTFINFPD)

     D MsgFNDS         DS
     D MsgFNArr                      10A   DIM(5)

     D CGPgmNm         S             10A
     D APIName         S             10A
     D FldName         S             10A
     D MsgID           S             10A
     D Nrfd            S              1A
     D Stmt            S            500A
     D Operr           S              1A
     D FileEnd         S              1A
     D @MsgID          S              7A
     D @MsgDT          S             45A
     D LangPrx         S              2A   INZ('GB')
     D M               S              2  0
     D ReturnCode      S             10A
     D CompMsg         S           3000A
     D #MsgFile        S             10A
     D #MsgFLib        S             10A
     D Level           S              1A

     D MsgLen          C                   CONST(3000)
     D MsgNotF         C                   CONST('*ERROR - Message not found')

     D @UC             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D @LC             C                   'abcdefghijklmnopqrstuvwxyz'

      *****************************************************************
      *  M A I N L I N E   P R O C E S S                              *
      *****************************************************************

     C                   EVAL      FileEnd = 'N'
     C                   EXSR      Init_Driver

      ** Do until end of driving file UTFINFPD

     C                   DOW       FileEnd = 'N'

      ** Read UTFINFPD

     C                   EXSR      FetchFldRec

     C                   IF        FileEnd = 'N'
     C                   EXSR      InitWrkFields
     C                   EXSR      GETMSG
     C                   EXSR      Upd_Msg
     C                   ENDIF

     C                   ENDDO

     C                   EXSR      CloseFile

     C                   SETON                                        LR

      *****************************************************************
      *                                                               *
      * Init_Driver - Setup pointer to the driving file               *
      *                                                               *
      *****************************************************************
     C     Init_Driver   BEGSR

     C                   EVAL      Nrfd  = 'Y'

      /free
        Stmt = 'Select * from UTFINFPD Where FMSGID <> '
                  + '''' + ' ' + '''' + ' and ( FETYPE = '
                  +  '''' + 'E' + '''' + ' or FETYPE = '
                  +  '''' + 'W' + '''' + ' )';
      /end-free

     C/EXEC SQL WHENEVER SQLERROR GOTO ErrOpr
     C/END-EXEC

     C/EXEC SQL WHENEVER NOT FOUND GOTO NoRec
     C/END-EXEC

     C/EXEC SQL
     C+ PREPARE S1 FROM :Stmt
     C/END-EXEC

     C/EXEC SQL
     C+ DECLARE C1 CURSOR FOR S1
     C/END-EXEC

     C/EXEC SQL
     C+ OPEN C1
     C/END-EXEC

     C                   EVAL      Nrfd = 'N'

     C     NoRec         TAG
     C     ErrOpr        TAG

     C                   IF        Nrfd = 'Y'
     C                   EVAL      FileEnd = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * FetchFldRec  - Read Field Detail File                         *
      *                                                               *
      *****************************************************************
     C     FetchFldRec   BEGSR

     C                   EVAL      OutTable = *BLANKS
     C                   EVAL      Operr = 'P'
     C                   EVAL      Nrfd  = 'Y'

     C/EXEC SQL WHENEVER SQLERROR GOTO ERROP
     C/END-EXEC

     C                   EVAL      Operr = 'O'

     C/EXEC SQL WHENEVER NOT FOUND GOTO NRECF
     C/END-EXEC

     C/EXEC SQL
     C+  FETCH C1 INTO :OutTable
     C/END-EXEC

     C                   EVAL      Nrfd  = 'N'

     C     NRECF         TAG
     C     ERROP         TAG

     C                   IF        Nrfd = 'Y'
     C                   EVAL      FileEnd = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * InitWrkFields - Initialise work fields for each program       *
      *                                                               *
      *****************************************************************
     C     InitWrkFields BEGSR

     C                   EVAL      MsgFNDS = FMSGFN
     C                   EVAL      MsgID   = FMSGID
     C                   EVAL      @MsgID  = MsgID
     C                   EVAL      @MsgDT  = '****'
     C                   EVAL      FldName = FINERD
     C                   EVAL      CGPgmNm = FCGPGM
     C                   EVAL      APIName = FCDPGM

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * GetMsg - Get Messages                                         *
      *                                                               *
      *****************************************************************
     C     GETMSG        BEGSR

     C                   EVAL      CompMsg = *Blank
     C                   Z-ADD     1             M
     C                   DOU       CompMsg <> *Blank or
     C                             #Msgfile = *Blank or
     C                             M = 6
     C                   EVAL      #MsgFile = MsgFNArr(M)
     C                   EVAL      #MsgFile = LangPrx + %TRIM(#MsgFile)
     C                   EXSR      ZAMSGRTVMS
     C                   ADD       1             M
     C                   ENDDO

      ** If message not found, report this

     C                   IF        CompMsg = *Blank
     C                   EVAL      CompMsg = MsgNotF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * ZAMSGRTVMS - Retrieve Messages From Message File              *
      *                                                               *
      *****************************************************************
     C     ZAMSGRTVMS    BEGSR

     C                   CALL      'ZAMSGRTVNS'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM      *BLANK        CompMsg
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
     C                   PARM                    #MsgFile
     C                   PARM      '*LIBL  '     #MsgFLib
     C                   PARM      '0'           Level

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Upd_Msg - Update field information file with error            *
      *           description                                         *
      *                                                               *
      *****************************************************************
     C     Upd_Msg       BEGSR

     C/EXEC SQL WHENEVER SQLERROR GOTO UpdMsgErr
     C/END-EXEC
     C/EXEC SQL WHENEVER NOT FOUND GOTO UpdMsgErr
     C/END-EXEC
     C/EXEC SQL
     C+  Update UTFINFPD  SET FDESCN = :CompMsg ,
     C+                       FMSGFU = :#MsgFile
     C+              Where FCGPGM = :CGPgmNm
     C+                    and FCDPGM = :APIName
     C+                    and FINERD = :FldName
     C+                    and FMSGID = :MsgID
     C/END-EXEC


     C     UpdMsgErr     TAG

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * CloseFile - Close Field Information File                      *
      *                                                               *
      *****************************************************************
     C     CloseFile     BEGSR

     C/EXEC SQL WHENEVER SQLERROR GOTO CloseErrS
     C/END-EXEC
     C/EXEC SQL WHENEVER NOT FOUND GOTO CloseErrS
     C/END-EXEC
     C/EXEC SQL
     C+  CLOSE C1
     C/END-EXEC

     C     CloseErrS     TAG

     C                   ENDSR

