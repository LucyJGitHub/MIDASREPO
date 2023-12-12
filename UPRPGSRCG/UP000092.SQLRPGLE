     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - ADBU Script Report')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000092 - ADBU Script Report                                *
      *                                                               *
      *           This program generates report UP000092P1 listing    *
      *           script for ADBU.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD061992             Date 23Oct23             *
      *  Prev Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *             Recompiled                                        *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     FUP000092P1O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D SQL_Arr         S          32000
     D Strng67         DS
     D  St67                          1    DIM(67)

     D DepF            S             10
     D S_DepF          S             10
     D Ix              S              5  0
     D Iz              S              5  0
     D Cnt             S              5  0
     D RcdCount        S              5  0

     D S_JOB           S             10
     D S_FILE          S             10
     D Recursive       S              1
     D ObjFlag         S              1
     D SrcFlag         S              1
     D Stop            S              1
      *

      /SPACE 3
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  R_JOB                244    253
     D  R_USER               254    263

     D UPZSCR        E DS                  EXTNAME(UPZSCRTD)
     D UPGSCR        E DS                  EXTNAME(UPGSCRTD)
     D                                     PREFIX(G)

     **************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    Lib              10
     C                   PARM                    File             10
     C                   PARM                    Layer             7

      * Write main page header.
     C                   setoff                                       20

      * Write main page header.
     C                   WRITE     HEADH

     C                   eval      R_File = File
     C                   eval      R_Lib  = Lib
     C                   WRITE     LIBRARY

     C                   If        Layer = '*ZONE'
      * Read log file for backup script
     C/exec SQL
     C+ declare CursorBU cursor for
     C+ select *
     C+ from UPZSCRTD where SCFILE = :File and SCLIB = :Lib and SCTYPE = 'BU'
     C+ order by SCSEQ
     C/end-exec

     C/exec SQL
     C+ open CursorBU
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorBU
     C+ into :UPZSCR
     C/end-exec

     C                   else
      * Read log file for backup script
     C/exec SQL
     C+ declare CursorBUG cursor for
     C+ select *
     C+ from UPGSCRTD where SCFILE = :File and SCLIB = :Lib and SCTYPE = 'BU'
     C+ order by SCSEQ
     C/end-exec

     C/exec SQL
     C+ open CursorBUG
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorBUG
     C+ into :UPZSCR
     C/end-exec
     C                   endif

     C                   WRITE     BACKUP_SC
     C                   eval      BKSEQ  = 0

     C                   DOW       SQLCODE = 0
     C                   eval      BKSEQ  = BKSEQ + 1
     C                   eval      BKLINE = SCCMD
     C                   WRITE     BK_DET
      * Read next record.
     C                   If        Layer = '*ZONE'
     C/exec SQL
     C+ fetch next
     C+ from CursorBU
     C+ into :UPZSCR
     C/end-exec
     C                   else
     C/exec SQL
     C+ fetch next
     C+ from CursorBUG
     C+ into :UPZSCR
     C/end-exec
     C                   endif

     C                   ENDDO
     C                   If        Layer = '*ZONE'
     C/exec SQL
     C+ close CursorBU
     C/end-exec
     C                   else
     C/exec SQL
     C+ close CursorBUG
     C/end-exec
     C                   endif

      * Read log file for SQL script
     C                   If        Layer = '*ZONE'
     C/exec SQL
     C+ declare CursorSQL cursor for
     C+ select *
     C+ from UPZSCRTD where SCFILE = :File and SCLIB = :Lib and SCTYPE = '  '
     C+ order by SCSEQ
     C/end-exec

     C/exec SQL
     C+ open CursorSQL
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorSQL
     C+ into :UPZSCR
     C/end-exec
     C                   else
     C/exec SQL
     C+ declare CursorSQLG cursor for
     C+ select *
     C+ from UPGSCRTD where SCFILE = :File and SCLIB = :Lib and SCTYPE = '  '
     C+ order by SCSEQ
     C/end-exec

     C/exec SQL
     C+ open CursorSQLG
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorSQLG
     C+ into :UPZSCR
     C/end-exec
     C                   endif

     C                   WRITE     SQL_SC
     C                   eval      SQLSEQ  = 0
     C                   SETON                                        20

     C                   DOW       SQLCODE = 0
     C                   if        SCCMTY = 'SQL'
     C                   eval      SQLSEQ  = SQLSEQ + 1
     C                   eval      SQL_Arr = SCCMD
     C                   eval      Stop = 'N'
     C                   eval      Ix = 1

     C                   DOU       Stop = 'Y'
      * search for first blank backwards
     C                   eval      Strng67 = %subst(SQL_Arr:Ix:67)
     C                   If        Strng67 = *blanks
     C                   leave
     C                   Endif
     C                   eval      Iz = 67
     C                   DOW       St67(Iz) <> ' '
     C                             and Iz > 0
     C                   eval      Iz = Iz -1
     C                   ENDDO
     C                   eval      SQLLINE = %subst(Strng67:1:Iz)
     C                   WRITE     SQL_DET
     C                   SETOFF                                       20
      * If overflow on then write header.
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADH
     C                   WRITE     LIBRARY
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
     C                   eval      Ix = Ix + Iz
     C                   If        Iz = 0
     C                   eval      Stop = 'Y'
     C                   Endif
     C                   ENDDO
      * Read next record.
     C                   WRITE     BLANK
     C                   SETON                                        20

     C                   Else
      * if not SQL
     C                   eval      SQLSEQ  = SQLSEQ + 1
     C                   eval      SQLLINE = SCCMD
     C                   WRITE     SQL_DET
     C                   Endif

     C                   If        Layer = '*ZONE'
     C/exec SQL
     C+ fetch next
     C+ from CursorSQL
     C+ into :UPZSCR
     C/end-exec
     C                   Else
     C/exec SQL
     C+ fetch next
     C+ from CursorSQLG
     C+ into :UPZSCR
     C/end-exec
     C                   Endif

     C                   ENDDO

     C                   If        Layer = '*ZONE'
     C/exec SQL
     C+ close CursorSQL
     C/end-exec
     C                   Else
     C/exec SQL
     C+ close CursorSQLG
     C/end-exec
     C                   Endif

      * Write trailer and end program.
     C                   WRITE     TRAILP

     C     ENDPGM        TAG

     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
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
     C     Recursive     IFEQ      *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
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
