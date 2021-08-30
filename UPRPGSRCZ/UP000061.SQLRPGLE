     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Run Bakcup')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000061 - This program                                      *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D Command         S            100
     D CommandLen      S             15  5 INZ(100)

     D SavFile         S             10A
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
     C                   PARM                    RefSys            2
     C                   PARM                    ERROR

      * reset 'Command has run' flag
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = ' '
     C+ where sctype = 'BU'
     C/end-exec

      * Read Ref System file
     C/exec SQL
     C+ declare CursorRdZ cursor for
     C+ select *
     C+ from UPZSCRTD where SCPRFX = :Prefix and SCTYPE = 'BU'
     C+ order by SCLIB, SCSEQ
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
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
     C                   PARM      'UP000061'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR

     C                   Leave
     C                   Endif

     C                   MONITOR

     C                   ON-ERROR

     C                   ENDMON

      * update 'Command has run' flag
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'Y'
     C+ where current of CursorRdZ
     C/end-exec
      * and send DTAQ message to refresh monitor screen
     C*                  CALL      'QSNDDTAQ'
     C*                  PARM      'UPZADBUDTQ'  DtqNam           10
     C*                  PARM      '*LIBL'       DtqLib           10
     C*                  PARM      50            DtqLen            5 0
     C*                  PARM      'REFRESH'     DtqDta2          10

     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into :UPZSCR
     C/end-exec

     C                   ENDDO

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
