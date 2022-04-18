     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - aDBU log statement views')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4026 - aDBU Log statement views                            *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059751 *CREATE   Date 25Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059751 - SQL view statement change is not detected by aDBU *
      *                                                               *
      *****************************************************************
      /EJECT

     D XVIEW           S             10

     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  R_JOB                244    253
     D  R_USER               254    263


     C     *ENTRY        PLIST
     C                   PARM                    Lib1             10
     C                   PARM                    Lib2             10
     C                   PARM                    LAYER             7

     C/exec SQL
     C+ declare View cursor for
     C+ select SVIEW from SQLSTM_C1 C1 where exists
     C+ (select * from SQLSTM_C2 C2 where C1.SVIEW = C2.SVIEW
     C+ and C1.SSTMT <> C2.SSTMT)
     C/end-exec

     C/exec SQL
     C+ open View
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from VIEW
     C+ into :XVIEW
     C/end-exec

     C                   DOW       SQLCODE = 0


     C/EXEC SQL
     C+ insert into UPGLOGPD
     C+ (
     C+   WJOB
     C+  ,WFILE
     C+  ,WDSP
     C+  ,WTYPE
     C+  ,WLIB1
     C+  ,WLIB2
     C+  ,WFLD1
     C+  ,WFLD2
     C+  ,WFLDA
     C+  ,WDESC
     C+  ,WFDEC
     C+  ,WDATA
     C+  ,WWHDS
     C+ )
     C+ Values
     C+ (
     C+   :Lib1
     C+  ,:XVIEW
     C+  ,'SQLVIEW'
     C+  ,' '
     C+  ,:Lib1
     C+  ,:Lib2
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,'SQL view statement'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+ )
     C/END-EXEC


     C/exec SQL
     C+ fetch next
     C+ from View
     C+ into :XVIEW
     C/end-exec

     C                   Enddo

     C/exec SQL
     C+ close View
     C/end-exec
      *

     C                   seton                                        LR
     C                   return
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
