     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*XBIA*  CRTPF FILE(QTEMP/MAXID) RCDLEN(15)                           *
/*XBIB*  RNMOBJ OBJ(QTEMP/MAXID) OBJTYPE(*FILE) NEWOBJ(MAXAMT)        *
/*XB*C***OVRDBF*FILE(RESETMAXOF)*TOFILE(QADSPFFD)**********************                      BUG8856
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP CPP for RESETMAXID command')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000003 - CPP RPG for RESETMAXID command                    *
      *                                                               *
      *  Function:  This program will either:                         *
      *             - reset the 'start from' value of an automatic-   *
      *               ally generated field to the next available      *
      *               number.                                         *
      *             - reset all automatically generated fields to     *
      *               their lowest values and leave the 'start from'  *
      *               value as the next available number.             *
      *             - reset the 'start from' value of an automatic-   *
      *               ally generated field to a specified number.     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
/*    *  Prev Amend No. CPK025             Date 11Jul06               /
      *                 BUG8856            Date 13Oct05               *
      *                 CPK030  *CREATE    Date 22Dec04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
/*    *  CPK025  - File UPCDFDPD is redundant. Use file UPFFDSTPD.    *
      *  BUG8856 - DSPFFD changed at V5R3.  Use core outfile instead  *
      *  CPK030 - New utility.                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
     F****RESETMAXOFIF   E             DISK                                                  BUG8856
     F*UPCDFDPD*IF   E             DISK                                               BUG8856 CPK025
     FUPFFDSTPD IF   E             DISK                                                       CPK025
      *
     FMAXAMT    IF A E             DISK    USROPN
     F                                     RENAME(MAXID:MAXFMT1)
      *
      * Get maximum auto-generated value data structure
     D GetMax1         DS
     D  GLine1                 1     80    INZ('INSERT INTO QTEMP/MAXAMT (MAXID+
     D                                     ) (SELECT CAST (INTEGER(CASE WHEN MA+
     D                                     X(          )')
     D GField1                70     79
      *
     D GetMax2         DS
     D  GLine2                 1     80    INZ('IS NULL THEN 1 ELSE (MAX(      -
     D                                         )+1) END) AS CHAR(15)) FROM')
     D GField2                26     35
     D GetMax3         DS
     D  Gline3                 1     80    INZ('                     );')
     D GSQL_File               1     21
      *
      * Set new maximum auto-generated value data structure
     D SetMax1         DS
     D  SLine1                 1     80    INZ('ALTER +
     D                                     TABLE                       ALTER CO+
     D                                     LUMN            ')
     D SSQL_File              13     33
     D SField                 50     59
 
     D SetMax2         DS
     D  SLine2                 1     80    INZ('RESTART WITH                ;')
     D StartNbr               14     28
      *
      * Create table as data structure
     D CrtTab1         DS
     D  CLine1                 1     80    INZ('CREATE TABLE +
     D                                     QTEMP/UP000003QT AS (SELECT')
     D CrtTab2         DS
     D  CLine2                 1     80    INZ('FROM                      ) +
     D                                     WITH DATA')
     D CSQL_File               6     26
      *
     D RUNSQL_Cmd      C                   'RUNSQLSTM SRCFILE(QTEMP/RUNSQL) +
     D                                     SRCMBR(RUNSQLSTM) COMMIT(*NONE)'
     D CPYF_Cmd        C                   'CPYF FROMFILE(QTEMP/UP000003QT) +
     D                                     TOFILE('
     D MBROPT_Kwrd     C                   'MBROPT(*REPLACE) '
     D FMTOPT_Kwrd     C                   'FMTOPT(*MAP) '
     D Comma           C                   ','
     D CloseBracket    C                   ') '
      *
     D Cmd_String      S            300
     D Cmd_StringLen   S             15  5 INZ(%LEN(Cmd_String))
     D SQL_Line        S             80
     D Clear           S              6    INZ('*CLEAR')
     D Write           S              6    INZ('*WRITE')
     D Wrun            S              1
     D FieldTotal      S              4  0
     D FieldCount      S              4  0
      *
     C     *ENTRY        PLIST
     C                   Parm                    Field            10
     C                   Parm                    SQL_File         21
     C                   Parm                    ResetOption       7
      *
     C                   SELECT
      * If option is *RSTMAX.
     C                   WHEN      ResetOption = '*RSTMAX'
     C                   EVAL      GField1 = Field
     C                   EVAL      GField2 = Field
     C                   EVAL      GSQL_File = SQL_File
     C                   EVAL      SField = Field
     C                   EVAL      SSQL_File = SQL_File
     C                   EXSR      GetMaxNbr
     C                   EXSR      SetMaxNbr
      *
      * If option is *RSTALL.
     C                   WHEN      ResetOption = '*RSTALL'
     C                   EVAL      CSQL_File = SQL_File
     C                   EVAL      SField = Field
     C                   EVAL      SSQL_File = SQL_File
     C                   EVAL      StartNbr = '         1'
     C                   EXSR      CreateTableAs
     C                   EXSR      SetMaxNbr
     C                   EXSR      CopyFile
      *
      * If option is a specific number.
     C                   OTHER
     C                   EVAL      SField = Field
     C                   EVAL      SSQL_File = SQL_File
     C                   EVAL      StartNbr = ResetOption
     C                   EXSR      SetMaxNbr
      *
     C                   ENDSL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetMaxNbr - Get maximum value of auto. generated field       *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     GetMaxNbr     BEGSR
      *
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      SQL_Line = GetMax1
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    Clear
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      SQL_Line = GetMax2
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    Write
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      SQL_Line = GetMax3
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    Write
      *
     C                   EXSR      RunSQLStmt
      *
     C                   OPEN      MAXAMT
     C                   READ      MAXAMT
     C                   CLOSE     MAXAMT
     C                   EVAL      StartNbr = MAXID
      *
     C     GetMaxNbrE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetMaxNbr - Set new start value for auto. generated field    *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SetMaxNbr     BEGSR
      *
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      SQL_Line = SetMax1
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    Clear
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      SQL_Line = SetMax2
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    Write
      *
     C                   EXSR      RunSQLStmt
      *
     C     SetMaxNbrE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  CreateTableAs - Create a new table based on existing table   *
      *                  but without auto-generated field.            *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     CreateTableAs BEGSR
      *
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      SQL_Line = CrtTab1
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    Clear
     C                   EVAL      SQL_Line = *blanks
      * Read outfile of DSPFFD until no more fields are left, but ignore
      *  auto-generated field.
     C*****1****         SETLL     RESETMAXOF                                                BUG8856
     C**********         READ      RESETMAXOF                                                BUG8856
     C*****1****         SETLL     UPCDFDPD                                           BUG8856 CPK025
     C**********         READ      UPCDFDPD                                           BUG8856 CPK025
     C     1             SETLL     UPFFDSTPD                                                  CPK025
     C                   READ      UPFFDSTPD                                                  CPK025
      * Use the number of fields to indicate when the file has reached the end.
     C                   EVAL      FieldTotal = WHNFLD - 1
     C                   EVAL      FieldCount = 1
      *
     C                   DOU       %EOF
     C                   IF        WHFLDI <> Field
     C                   EVAL      SQL_Line = WHFLDI + Comma
     C                   IF        FieldCount <> FieldTotal
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    Write
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      FieldCount = FieldCount + 1
      *
     C                   ENDIF
     C                   ENDIF
     C**********         READ      RESETMAXOF                                                BUG8856
     C**********         READ      UPCDFDPD                                           BUG8856 CPK025
     C                   READ      UPFFDSTPD                                                  CPK025
     C                   ENDDO
      *
      * Write final field without comma ...
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      SQL_Line = WHFLDI
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    Write
      * ... and then write final part of CREATE TABLE AS statement.
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      SQL_Line = CLine2
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    Write
      *
     C                   EXSR      RunSQLStmt
      *
     C     CreateTableAsEENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  CopyFile - Copy file back to original file                   *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     CopyFile      BEGSR
      *
     C                   EVAL      Cmd_String = *blanks
     C                   EVAL      Cmd_String = CPYF_Cmd
     C                   EVAL      Cmd_String = %TRIMR(Cmd_String) +
     C                             SQL_File
     C                   EVAL      Cmd_String = %TRIMR(Cmd_String) +
     C                             CloseBracket +
     C                             MBROPT_Kwrd +
     C                             FMTOPT_Kwrd
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_StringLen
      *
     C     CopyFileE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RunSQLStmt - Run SQL Statement from RUNSQL source file       *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     RunSQLStmt    BEGSR
      *
     C                   EVAL      Cmd_String = *blanks
     C                   EVAL      Cmd_String = RUNSQL_Cmd
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_StringLen
      *
     C     RunSQLStmtE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
