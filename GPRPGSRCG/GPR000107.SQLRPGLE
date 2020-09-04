     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Reset Values for Auto-generated')
/*XBI *****************************************************************
/*XBI *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GPR000107 - Reset Values for Auto-generated fields           *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG8394 *CREATE    Date 08Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG8394- Midas error[SQL0803] Duplicate key value specified  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Copyright(c)
     D @CPY            S             50    DIM(7) CTDATA PERRCD(1)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Prefix          S              2A
     D SqlStm          S            200A
     D Cmd             S             70A
     D CmdLen          S             15  5
     D Lib1            S             10A   INZ('GMLIB')
     D Lib2            S             10A   INZ('GTALIB')
     D Yes             S              3A   INZ('YES')

     d myDS            ds
     d   IdentLib                    10a   varying
     d   IdentFil                    10a
     d   Identty                      3a

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+


     C     *Entry        PLIST
     C                   PARM                    Prefix

     C                   EVAL      Lib1   = %Trim(Prefix) + Lib1
     C                   EVAL      Lib2   = %Trim(Prefix) + Lib2
     C                   EVAL      SqlStm =
     C                             'Select Trim(Char(DBName)), +
     C                                     Trim(Char(TBName)), +
     C                                     Trim(Char(Identity)) +
     C                               From SysColumns +
     C                               Where (DBName = ''' + %Trim(Lib1) + ''' +
     C                                   Or DBName = ''' + %Trim(Lib2) + ''' ) +
     C                                 And Identity = ? +
     C                                Order By DBName, TBName'

     C/Exec Sql
     C+ Declare MainCursor Cursor
     C+   For MainStatement
     C/End-Exec

     C/Exec Sql
     C+ Prepare MainStatement
     C+   From :SqlStm
     C/End-Exec

     C/Exec Sql
     C+ Open MainCursor
     C+ Using :Yes
     C/End-Exec

     C/Exec Sql
     C+ Fetch Next
     C+  From MainCursor
     C+  Into :myDS
     C/End-Exec

     C                   DOW       SQLSTT = '00000'

     C                   EVAL      Cmd   = 'RESETMAXID FILE(' +
     C                                     %Trim(IdentLib) + '/' +
     C                                     %Trim(IdentFil) +
     C                                     ') RSTOPT(*RSTMAX)'

     C                   EVAL      CmdLen = %Len(Cmd)

     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd
     C                   PARM                    CmdLen

     C/Exec Sql
     C+ Fetch Next
     C+  From MainCursor
     C+  into :myDS
     C/End-Exec

     C                   ENDDO

     C/Exec Sql
     C+ Close MainCursor
     C/End-Exec

     C                   EVAL      *Inlr  = *On
     C                   RETURN

      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2005
