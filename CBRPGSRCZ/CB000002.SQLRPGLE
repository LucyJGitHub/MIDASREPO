     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CB Program to run COB counter')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  CB000002 - Program to Run COB Counter                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CCB021  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCB021 - COB Restructure - Non Working Day COB               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D CBRUN           DS             6
     D  DSTotComp              1      3P 0
     D  DSTotRun               4      6P 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TotComp         S              4
     D TotRun          S              4
     D Tmp             S              4P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
     C/EXEC SQL
     C+ Select count(DHCRQD) into :TotComp
     C+        from CBCOMSPD
     C+        where DHCRQD = 'Y'
     C/END-EXEC
      **
     C/EXEC SQL
     C+ Select count(DHCRQD) into :TotRun
     C+        from CBCOMSPD
     C+        where DHCRQD = 'Y' and DHCSTS = 'C'
     C/END-EXEC
      **
     C                   IF        SQLCODE = 0
     C
     C     *DTAARA       DEFINE                  CBRUN
     C     *LOCK         IN        CBRUN
     C                   EVAL      Tmp = %Dec(TotComp:4:0)
     C                   Z-ADD     Tmp           DSTotComp
     C                   EVAL      Tmp = %Dec(TotRun:4:0)
     C                   Z-ADD     Tmp           DSTotRun
     C                   OUT       CBRUN
     C
     C                   ENDIF
     C
     C                   SETON                                        LR
      ********************************************************************
