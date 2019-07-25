     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas FC CFC006 Initialisation Program')
      *****************************************************************
      *                                                               *
      *  Midas - Report Control Facility Module                       *
      *                                                               *
      *  FC000090 - CFC006 Initialisation Program                     *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD020563 *CREATE   Date 22May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020563 - CFC006 issues                                     *
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
      *  UPDATE - Update File SCCOMXTD                                *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************

      ** Section Name List

     D SCList          S             10    DIM(100) CTDATA PERRCD(1)

      ** Declared Variable

     D Ctr             S              5  0
     D SCName          S             10
     D WRun            S              1

      ** Main Process

     C                   Z-ADD     1             Ctr
     C                   EVAL      SCName = *BLANKS
     C                   EVAL      SCName = SCList(Ctr)
     C                   DOW       SCName <> *BLANKS AND Ctr < 50
     C                   EXSR      UPDATE
     C                   EVAL      Ctr = Ctr + 1
     C                   EVAL      SCName = *BLANKS
     C                   EVAL      SCName = SCList(Ctr)
     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  UPDATE - Suppreses records that are Core records and         *
      *           section name/FMMBR is in the array                  *
      *                                                               *
      *****************************************************************
     C     UPDATE        BEGSR

     C/EXEC SQL
     C+ update SCCOMXTD set FMDEL = 'N' where (FMUNIQ) in
     C+ (select FMUNIQ from SCCOMMTD where FMTYPE = 'X' and
     C+ FMMODE = 'C' and FMMBR = :SCName)
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** SCList
DL0195001
DL0280001
DL0450001
LER135001
RE3778001
GL0420001
GL0420002
LE0450002
GL0800001
GL2000001
LER020001
LER032001
LER135002
LE0300001
LE0310001
LE0320001
LE0450001
LER134001
LE00045601
LE00047901
