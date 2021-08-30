     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU - Output error message into UPADBETD')   *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4040 - ADBU - Output error message into UPADBETD           *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     D Err_Msg         S            200
     D Msg_Id          S              8
     D Topgm           S             10
     D X               S              1  0

     D UPADBE        E DS                  EXTNAME(UPADBETD)
     D/COPY ZACPYSRC,PSDS
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Prefix            2
     C                   PARM                    File             10
     C                   PARM                    Program          10
     C                   PARM                    Command         200
     C                   PARM                    Type              4
     C                   PARM                    ERROR            10

     C                   eval      ERJOB = %Char(PSJobNo) + '/' +
     C                             %trimr(PSUSer) + '/' +
     C                             %trimr(PSJobName)

     C/exec SQL
     C+ declare Cursor1 cursor for
     C+ SELECT cast(message_text as char(200) ccsid 37),
     C+ message_id, TO_PROGRAM
     C+ FROM table(qsys2.joblog_info('*')) a
     C+ where severity >= 10
     C+ order by a.ORDINAL_POSITION desc
     C/end-exec

     C/exec SQL
     C+ open Cursor1
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :Err_Msg, :Msg_Id, :Topgm
     C/end-exec

     C                   eval      X = 0
     C                   DOU       X  = 2
     C                   If        SQLCODE <> 0
     C                   leave
     C                   ENDIF

     C                   If        Type = 'CLP'
     C                             and Topgm <> 'UPCGENER'
     C*                            and Topgm <> 'QLICRDUP'
     C                   Iter
     C                   ENDIF
     C
     C                   If        Type = 'SQL'
     C                   eval      X = X + 1
     C                   else
     C                   eval      X = 2
     C                   endif

     C                   CALL      'ZAGENTS'
     C                   PARM                    ERTMST
     C/EXEC SQL
     C+ insert into UPADBETD
     C+ (
     C+   ERPRFX
     C+  ,ERFILE
     C+  ,ERPGM
     C+  ,ERJOB
     C+  ,ERMSGI
     C+  ,ERMSG
     C+  ,ERTMST
     C+  ,ERCMD
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:File
     C+  ,:Program
     C+  ,:ERJOB
     C+  ,:Msg_Id
     C+  ,:Err_Msg
     C+  ,:ERTMST
     C+  ,:Command
     C+ )
     C/END-EXEC

     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :Err_Msg, :Msg_Id, :Topgm
     C/end-exec
     C                   ENDDO

     C                   RETURN

      *****************************************************************
