     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Rebuild LF')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000065 - ADBU Rebuild LF                                   *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE     Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D Command         S            100
     D CommandLen      S             15  5 INZ(100)
     D SQLDynStmt      S           5000A

     D SavFile         S             10A
     D DVLIB           S             10A
     D ERROR           S             10A
     D X_SCCMD         S            100A
     D UPZSCR        E DS                  EXTNAME(UPZSCRTD)
     D UPZLGU        E DS                  EXTNAME(UPZLGUTD)
     D/COPY ZACPYSRC,PSDS
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Prefix            2
     C                   PARM                    RefSys            2
     C                   PARM                    ERROR

      * run RB tasks
     C/exec SQL
     C+ declare Cursor1 cursor for
     C+ select *
     C+ from UPZSCRTD where SCTYPE = 'RB'
     C+ order by SCLIB, SCFILE, SCSEQ
     C/end-exec

     C/exec SQL
     C+ open Cursor1
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :UPZSCR
     C/end-exec


     C                   DOW       SQLCODE = 0

     C                   eval      ERROR = *BLANKS
     C                   eval      Command = SCCMD

      * log command
      ** Generate TimeStamp

     C                   CALL      'ZAGENTS'
     C                   PARM                    ULTMST
     C                   eval      X_SCCMD = %subst(SCCMD:1:100)
     C/EXEC SQL
     C+ insert into UPZLGUTD
     C+ (
     C+   ULTMST
     C+  ,ULCMDE
     C+ )
     C+ Values
     C+ (
     C+   :ULTMST
     C+  ,:X_SCCMD
     C+ )
     C/END-EXEC

     C                   CALL(E)   'UPCGENER'
     C                   PARM                    Prefix
     C                   PARM                    Command
     C                   PARM                    ERROR


     C                   if        ERROR <> *BLANKS
     C/EXEC SQL
     C+ insert into UPZLGUTD
     C+ (
     C+   ULTMST
     C+  ,ULCMDE
     C+ )
     C+ Values
     C+ (
     C+   :ULTMST
     C+  ,'Previous command failed'
     C+ )
     C/END-EXEC
     C*                  goto      End
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000065'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   Endif

     C                   If        ERROR = '*Error'
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'E'
     C+ where current of Cursor1
     C/end-exec
     C                   Else
      * update 'Command has run' flag
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'Y'
     C+ where current of Cursor1
     C/end-exec
      * and send DTAQ message to refresh monitor screen
     C*                  CALL      'QSNDDTAQ'
     C*                  PARM      'UPZADBUDTQ'  DtqNam           10
     C*                  PARM      '*LIBL'       DtqLib           10
     C*                  PARM      50            DtqLen            5 0
     C*                  PARM      'REFRESH'     DtqDta           10
     C                   Endif

     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :UPZSCR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor1
     C/end-exec

     C     End           TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
