     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - aDBU List select difference')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4027 - aDBU List difference in selection                   *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD060709 *CREATE     Date 08Nov22             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060709 - Change in LF dynamic selection is omitted         *
      *             File is not deleted when both DTAARA and file     *
      *             have the same name.                               *
      *             Change in PF key is omitted                       *
      *                                                               *
      *****************************************************************
      /EJECT
     FUPCLOGPD  O  A E             DISK

     D S_JOB           S             10
     D S_FILE          S             10
     D X_DATA          S             30
      *
     D G1VLIB          S             10
     D G2VLIB          S             10
     D xCFDATA         S           4400
     D CFIL            S             10
     D S_CFIL          S             10
     D                 DS
     D  DateStamp              1     12
     D  yy                     1      2
     D  mm                     3      4
     D  dd                     5      6
      *
      /SPACE 3
      *
     D SQLDynStmt      S            500A
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

     C                   eval      G1VLIB = Lib1
     C                   eval      G2VLIB = Lib2

     C                   eval      SQLDynStmt = 'select CFDATA ' +
     C                             'from QTEMP/UTCMPFPD#'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C1 cursor with return to client for DynSQLStmnt
     C/end-exec

     C/EXEC SQL
     C+ open C1
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C1 into :xCFDATA
     C/END-EXEC
     C                   Dow       SQLCODE = 0
     C                   eval      CFIL = %subst(xCFDATA:14:10)

     C                   if        CFIL <> S_CFIL
     C                   EVAL      WJOB  = G1VLIB
     C                   EVAL      WFILE = CFIL
     C                   EVAL      WDSP  = 'DSPFD_SL'
     C                   EVAL      WTYPE = *blanks
     C                   EVAL      WLIB1 = G1VLIB
     C                   EVAL      WLIB2 = G2VLIB
     C                   EVAL      WFLD1 = *BLANKS
     C                   EVAL      WFLD2 = *BLANKS
     C                   EVAL      WFLDA = 'Selection'
     C                   EVAL      WDESC = 'Selection changed'
     C                   EVAL      WFDEC = *BLANKS
     C                   EVAL      WDATA = X_DATA
     C                   EVAL      WWHDS = *BLANKS
     C                   WRITE     UPCLOGD0
     C                   eval      S_CFIL = CFIL
     C                   endif
     C/EXEC SQL
     C+ fetch C1 into :xCFDATA
     C/END-EXEC
     C                   enddo

     C/EXEC SQL
     C+ close C1
     C/END-EXEC

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
