     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Upgrade PF')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000062 - ADBU Upgrade PF                                   *
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

     D SavFile         S             10A
     D DVLIB           S             10A
     D ERROR           S             10A
     D UPZSCR        E DS                  EXTNAME(UPZSCRTD)
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


     C                   eval      DVLIB = Prefix + 'DVLIB'

      * Delete dependent files
     C/exec SQL
     C+ declare CursorDD1 cursor for
     C+ select *
     C+ from UPZSCRTD where SCPRFX = :Prefix and SCTYPE = 'DD'
     C+ and SCLIB = :DVLIB
     C+ order by SCSEQ
     C/end-exec

     C/exec SQL
     C+ open CursorDD1
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorDD1
     C+ into :UPZSCR
     C/end-exec


     C                   DOW       SQLCODE = 0

     C                   eval      Command = SCCMD

     C                   CALL(E)   'UPCGENER'
     C                   PARM                    Prefix
     C                   PARM                    Command
     C                   PARM                    ERROR

     C                   if        ERROR <> *BLANKS
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000062'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'E'
     C+ where current of CursorDD1
     C/end-exec
     C                   goto      End
     C                   Endif

     C                   MONITOR

     C                   ON-ERROR

     C                   ENDMON
      * update 'Command has run' flag
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'Y'
     C+ where current of CursorDD1
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorDD1
     C+ into :UPZSCR
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorDD1
     C/end-exec
     C

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
