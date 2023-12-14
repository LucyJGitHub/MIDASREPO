     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - ADBU Exception Report')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4018 - ADBU Exception Report (Reconcile)                   *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
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
     FUP4018P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D XLib            S             10
     D RdFile          S             10
     D RcdCount        S              5  0
     D Dep_Fil         S             10    DIM(999)
     D DepF            S             10
     D S_DepF          S             10
     D Ix              S              3  0

     D S_JOB           S             10
     D S_FILE          S             10
     D Recursive       S              1
     D ObjFlag         S              1
     D SrcFlag         S              1
     D MatFlag         S              1
     D X               S              1  0
      *
     D                 DS
     D  DateStamp              1     12
     D  yy                     1      2
     D  mm                     3      4
     D  dd                     5      6

     D UPADBE        E DS                  EXTNAME(UPADBETD)
      /SPACE 3

     D PSDS           SDS

      ** Program Status Data Structure

     D  PGM              *PROC
     D  R_JOB                244    253
     D  R_USER               254    263
      *
     C     *ENTRY        PLIST
     C                   PARM                    Lib1              2
     C**********         PARM                    Lib2              2                        MD061992
     C                   PARM                    Lib2              3                        MD061992
     C                   PARM                    Layer             7

      * Set report fields
     C                   eval      E_LIB1 = Lib1
     C                   eval      E_LIB2 = Lib2

      * Write main page header.
     C                   setoff                                       20
     C                   IF        Layer = '*GLOBAL'
     C                   seton                                        20
     C                   ENDIF
     C                   WRITE     HEADH

      * If there are no records at all write 'no records'

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPADBETD
     C+ where
     C+     ERPRFX = :Lib1
     C/end-exec
     C                   IF        RcdCount = 0
     C                   WRITE     LIBRARY
     C                   WRITE     NORECS
     C                   WRITE     TRAILP
     C                   GOTO      ENDPGM

     C                   ENDIF

     C                   WRITE     LIBRARY

     C/exec SQL
     C+ declare CursorRd cursor for
     C+ select * from UPADBETD
     C+ where ERPRFX = :Lib1
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRd
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRd
     C+ into :UPADBE
     C/end-exec

     C                   DOW       SQLCODE = 0

      * If overflow on then write header.
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADH
     C                   WRITE     LIBRARY
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF

     C                   eval      E_OBJ = ERFILE
     C                   eval      E_PGM = ERPGM
     C                   eval      E_JOB = ERJOB
     C                   eval      E_DET = ERMSGI + ' ' + ERMSG
     C                   eval      E_CMD = ERCMD
     C                   eval      E_TMST = ERTMST

     C                   WRITE     DETAIL
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from CursorRd
     C+ into :UPADBE
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close CursorRd
     C/end-exec

      * Write 'End of report'
     C                   write     TRAILP

     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN

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
