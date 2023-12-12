     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Disaster recovery')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000064 - ADBU Disaster Recovery                            *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD061992             Date 23Oct23             *
      *  Prev Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *  CUT017 - Adaptive Database Upgrade                           *
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
     C**********         PARM                    RefSys            2                        MD061992
     C                   PARM                    RefSys            3                        MD061992
     C                   PARM                    ERROR

      * 1. run DR tasks for LF which are not RSTOBJ (mainly DLTF LF)
     C/exec SQL
     C+ declare Cursor1 cursor for
     C+ select *
     C+ from UPZSCRTD where SCPRFX = :Prefix and SCTYPE = 'DR'
     C+ and SCLIB like '%VLIB%' and SCCDSH <> 'RSTOBJ'
     C+ order by SCSEQ
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

     C                   eval      Command = SCCMD

     C                   CALL(E)   'UPCGENER'
     C                   PARM                    Prefix
     C                   PARM                    Command
     C                   PARM                    ERROR

     C                   exsr      SR_Log

     C                   if        ERROR <> *BLANKS
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000064'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   dump
     C                   eval      ERROR = *BLANKS
     C*                  goto      End
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
     C                   Endif

     C                   MONITOR
     C                   ON-ERROR
     C                   ENDMON


     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :UPZSCR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor1
     C/end-exec


      * 2.0 run DR tasks for PF which are not RSTOBJ (mainly DLTF PF) - from RF system
     C/exec SQL
     C+ declare Cursor2 cursor for
     C+ select *
     C+ from UPZSCRTD where SCPRFX = :Prefix and SCTYPE = 'DR'
     C+ and SCLIB not like '%VLIB%' and SCCDSH <> 'RSTOBJ'
     C+ and SCDEPF <> '          '
     C+ order by SCLIB, SCSEQ desc
     C/end-exec

     C/exec SQL
     C+ open Cursor2
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor2
     C+ into :UPZSCR
     C/end-exec


     C                   DOW       SQLCODE = 0

     C                   eval      Command = SCCMD


     C                   CALL(E)   'UPCGENER'
     C                   PARM                    Prefix
     C                   PARM                    Command
     C                   PARM                    ERROR

     C                   exsr      SR_Log

     C                   if        ERROR <> *BLANKS
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000064'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   eval      ERROR = *BLANKS
     C                   dump
     C*                  goto      End
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'E'
     C+ where current of Cursor2
     C/end-exec
     C                   Else
      * update 'Command has run' flag
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'Y'
     C+ where current of Cursor2
     C/end-exec
     C                   Endif

     C                   MONITOR
     C                   ON-ERROR
     C                   ENDMON


     C/exec SQL
     C+ fetch next
     C+ from Cursor2
     C+ into :UPZSCR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor2
     C/end-exec

      * 2.1 run DR tasks for PF which are not RSTOBJ (mainly DLTF PF)
     C/exec SQL
     C+ declare Cursor21 cursor for
     C+ select *
     C+ from UPZSCRTD where SCPRFX = :Prefix and SCTYPE = 'DR'
     C+ and SCLIB not like '%VLIB%' and SCCDSH <> 'RSTOBJ'
     C+ and SCDEPF = '          '
     C+ order by SCLIB, SCSEQ desc
     C/end-exec

     C/exec SQL
     C+ open Cursor21
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor21
     C+ into :UPZSCR
     C/end-exec


     C                   DOW       SQLCODE = 0

     C                   eval      Command = SCCMD


     C                   CALL(E)   'UPCGENER'
     C                   PARM                    Prefix
     C                   PARM                    Command
     C                   PARM                    ERROR

     C                   exsr      SR_Log

     C                   if        ERROR <> *BLANKS
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000064'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   eval      ERROR = *BLANKS
     C                   dump
     C*                  goto      End
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'E'
     C+ where current of Cursor21
     C/end-exec
     C                   Else
      * update 'Command has run' flag
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'Y'
     C+ where current of Cursor21
     C/end-exec
     C                   Endif

     C                   MONITOR
     C                   ON-ERROR
     C                   ENDMON


     C/exec SQL
     C+ fetch next
     C+ from Cursor21
     C+ into :UPZSCR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor21
     C/end-exec

      * 3. run DR tasks for PF which are  RSTOBJ (mainly RSTOBJ PF)
     C/exec SQL
     C+ declare Cursor3 cursor for
     C+ select *
     C+ from UPZSCRTD where SCPRFX = :Prefix and SCTYPE = 'DR'
     C+ and SCLIB not like '%VLIB%' and SCCDSH = 'RSTOBJ'
     C+ order by SCLIB, SCSEQ desc
     C/end-exec

     C/exec SQL
     C+ open Cursor3
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor3
     C+ into :UPZSCR
     C/end-exec


     C                   DOW       SQLCODE = 0

     C                   eval      Command = SCCMD


     C                   CALL(E)   'UPCGENER'
     C                   PARM                    Prefix
     C                   PARM                    Command
     C                   PARM                    ERROR

     C                   exsr      SR_Log

     C                   if        ERROR <> *BLANKS
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000064'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   dump
     C                   goto      End
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'E'
     C+ where current of Cursor3
     C/end-exec
     C                   Else
      * update 'Command has run' flag
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'Y'
     C+ where current of Cursor3
     C/end-exec
     C                   Endif

     C                   MONITOR
     C                   ON-ERROR
     C                   ENDMON


     C/exec SQL
     C+ fetch next
     C+ from Cursor21
     C+ into :UPZSCR
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor3
     C+ into :UPZSCR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor3
     C/end-exec

      * 4. run DR tasks for LF which are RSTOBJ (mainly RSTOBJ LF)
     C/exec SQL
     C+ declare Cursor4 cursor for
     C+ select *
     C+ from UPZSCRTD where SCPRFX = :Prefix and SCTYPE = 'DR'
     C+ and SCLIB  like '%VLIB%' and SCCDSH = 'RSTOBJ'
     C+ order by SCLIB, SCSEQ desc
     C/end-exec

     C/exec SQL
     C+ open Cursor4
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor4
     C+ into :UPZSCR
     C/end-exec


     C                   DOW       SQLCODE = 0

     C                   eval      Command = SCCMD


     C                   CALL(E)   'UPCGENER'
     C                   PARM                    Prefix
     C                   PARM                    Command
     C                   PARM                    ERROR

     C                   exsr      SR_Log

     C                   if        ERROR <> *BLANKS
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000064'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   dump
     C                   goto      End
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'E'
     C+ where current of Cursor4
     C/end-exec
     C                   Else
      * update 'Command has run' flag
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'Y'
     C+ where current of Cursor4
     C/end-exec
     C                   Endif

     C                   MONITOR
     C                   ON-ERROR
     C                   ENDMON

     C/exec SQL
     C+ fetch next
     C+ from Cursor4
     C+ into :UPZSCR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Cursor4
     C/end-exec
     C

     C     End           TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      ********************************************************************
      /EJECT
      *****************************************************************
     C     SR_Log        BEGSR

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

     C                   If        ERROR <> *BLANKS
     C                   eval      X_SCCMD = 'Previous command failed'
      * log command
      ** Generate TimeStamp

     C                   CALL      'ZAGENTS'
     C                   PARM                    ULTMST
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

     C                   ENDIF
     C                   ENDSR

      ********************************************************************
      /EJECT
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
