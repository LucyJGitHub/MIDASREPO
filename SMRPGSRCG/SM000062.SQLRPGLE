     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*XBIA*  OVRDBF FILE(SM000062F) TOFILE(UPFFDSTPD)                     *
/*XBIB*  OVRDBF FILE(SM000062M) TOFILE(UPMBRLTPD)                     *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Migrate and convert loan ref fields')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000062 - This program has been written especially to deal  *
      *             with the change of loan references to alpha. If   *
      *             a loan reference field contained 000000 then it   *
      *             is set to blank.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. AR1092867          Date 01Mar13               *
      *  Prev Amend No. AR1085447*CREATE   Date 06Feb13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1092867 - Make sure that the SQL written via UTWRTSQL is   *
      *              complete.                                        *
      *  AR1085447 - Handle migration of loan reference to alpha.     *
      *                                                               *
      *****************************************************************
      *
      ** Files with loan reference fields
     FSMLNRFPD  UF   E           K DISK
      *
      ** DSPFFD outfile
     FSM000062F IF   E             DISK    USROPN
      *
      ** DSPFD outfile
     FSM000062M IF   E             DISK    USROPN
      *
      ** Parameters
     D FromObj         S             10
     D FromType        S              8
     D FromLib         S             10
     D ToLib           S             10
     D ReRun           S              4
     D SingleMode      S              1
     D ReturnCodeOut   S             10
      *
      ** Parameters for call to UTWRTSQL
     D Stmt_String     S             80
     D Mode            S              6
      *
      ** Work variables:
     D QCmdLen         S             15  5 INZ(150)
     D QCmdText        S            150
     D ByPass          S              1
     D MbrCount        S              5  0
     D ObjName         S             10
     D ObjType         S              8
     D MemberName      S             10
     D SQLFail         S              1
     D SMC40Rtn        S              1
     D SMC44Rtn        S              7
     D Write           S              7    INZ('*WRITE ')
     D ErrorMsg        S            100
      *
      ** Fields for storing field names
     D FromList        S          32767    Varying
     D ToList          S          32767    Varying
      *
      ** Fields for SQL statement
     D SQL             S          32767    Varying
     D Len             S              5  0
     D Pos             S              5  0
     D SST             S              2  0
      *
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY GPCPYSRCG,STD_D_SPEC
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY GPCPYSRCG,PSDS
      **------------------------------------------------------------------
      *
      ** Constants:
     D ConDSPFFD       C                   'DSPFFD FILE(                     ) +
     D                                     OUTPUT(*OUTFILE) +
     D                                     OUTFILE(QTEMP/FFD) +
     D                                     OUTMBR(*FIRST *REPLACE)'
      *
     D ConInsert       C                   'INSERT INTO           /           ('
      *
     D ConRunSQL       C                   'RUNSQLSTM SRCFILE(QTEMP/RUNSQL) +
     D                                     SRCMBR(RUNSQLSTM) COMMIT(*NONE)'
      *
     D ConDSPFD        C                   'DSPFD FILE(                     ) +
     D                                     TYPE(*MBRLIST) OUTPUT(*OUTFILE) +
     D                                     OUTFILE(QTEMP/MBRL) +
     D                                     OUTMBR(*FIRST *REPLACE)'
      *
     D ConCLRPFM       C                   'CLRPFM FILE(                     ) +
     D                                     MBR(*ALL)'
      *
     D ConCRTDUPOBJ1   C                   'CRTDUPOBJ OBJ(UPFFDSTPD) +
     D                                     FROMLIB(*LIBL) OBJTYPE(*FILE) +
     D                                     TOLIB(QTEMP) NEWOBJ(SM000062F)'
      *
     D ConCRTDUPOBJ2   C                   'CRTDUPOBJ OBJ(UPMBRLTPD) +
     D                                     FROMLIB(*LIBL) OBJTYPE(*FILE) +
     D                                     TOLIB(QTEMP) NEWOBJ(SM000062M)'
      *
     D ConCPYF1        C                   'CPYF FROMFILE(FFD) +
     D                                     TOFILE(SM000062F) MBROPT(*REPLACE) +
     D                                     FMTOPT(*MAP *DROP)'
      *
     D ConCPYF2        C                   'CPYF FROMFILE(MBRL) +
     D                                     TOFILE(SM000062M) MBROPT(*REPLACE) +
     D                                     FMTOPT(*MAP *DROP)'
      *
      ** DS for call to QCMDEXC for DSPFFD
     DCmdDSPFFD        DS           150
     D QualName               13     33
      *
      ** DS for call to QCMDEXC for DSPFFD
     DCmdCLRPFM        DS           150
     D QualName3              13     33
      *
      ** DS to create SQL command
     DCmdInsert        DS           150
     D ToSQLLib               13     22
     D ToSQLFile              24     33
      *
      ** DS for call to QCMDEXC for DSPFD
     DCmdDSPFD         DS           150
     D QualName2              12     32
      *
      *****************************************************************
      * Start of MAIN processing                                      *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    FromObj
     C                   PARM                    FromType
     C                   PARM                    FromLib
     C                   PARM                    ToLib
     C                   PARM                    ReRun
     C                   PARM                    SingleMode
     C                   PARM                    ReturnCode
      *
     C     Key01         KLIST
     C                   KFLD                    ObjName
     C                   KFLD                    ObjType
     C                   KFLD                    FieldName
      *
     C     Key02         KLIST
     C                   KFLD                    ObjName
     C                   KFLD                    ObjType
      *
     C                   EVAL      ReturnCode = *BLANKS
     C                   EVAL      ObjName = FromObj
     C                   EVAL      ObjType = FromType
      *
      ** If ReRun is '*NO ', set all update flags to blank.
     C                   IF        ReRun  = '*NO '
     C/Exec SQL
     C+ Update SMLNRFPD set LNUPDF = ' '
     C/End-Exec
     C                   ENDIF
      *
      ** Set up QCMD defaults
     C                   EVAL      CmdDSPFFD = ConDSPFFD
     C                   EVAL      CmdDSPFD = ConDSPFD
     C                   EVAL      CmdCLRPFM = ConCLRPFM
      *
      ** Set up SQL defaults
     C                   EVAL      CmdInsert = ConInsert
     C                   EVAL      ToSQLLib = ToLib
      *
      ** Read in the files to be migrated (or single file,
      ** if in single mode)
     C                   IF        SingleMode = 'Y'
     C     Key02         CHAIN     SMLNRFPD
     C                   IF        NOT %FOUND
     C                   EVAL      ReturnCode = '*NOTONLNRF'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ELSE
     C                   READ      SMLNRFPD
     C                   ENDIF
     C                   EVAL      ObjName = LNFILE
     C                   EVAL      SQLFail = ' '

     C                   DOU       %EOF or SingleMode = 'Y'
      *
      ** Only process file if it hasn't already been processed.
     C                   IF        LNUPDF <> 'Y'
      *
     C                   IF        FromType = '*DTAARA '
     C                   CALL      'SMC000040'
     C                   PARM                    FromObj
     C                   PARM                    FromLib
     C                   PARM                    ToLib
     C                   PARM                    LNFPOS
     C                   PARM                    SMC40Rtn
     C                   IF        SMC40Rtn <> ' '
     C                   EVAL      SQLFail = 'Y'
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Reset work variables
     C                   CLEAR                   FromList
     C                   CLEAR                   ToList
      *
      ** Set up CLRPFM
     C                   EVAL      QualName3 = %TRIM(ToLib) + '/' + LNFILE
     C                   EVAL      QCmdText = CmdCLRPFM
     C                   EXSR      QCmdExc
      ** Set up DSPFFD
     C                   EVAL      QualName = %TRIM(FromLib) + '/' + LNFILE
     C                   EVAL      QCmdText = CmdDSPFFD
     C                   EXSR      QCmdExc
     C                   EVAL      QCmdText = ConCRTDUPOBJ1
     C                   EXSR      QCmdExc
     C                   EVAL      QCmdText = ConCPYF1
     C                   EXSR      QCmdExc
      *
      ** Read DSPFFD outfile.
     C                   OPEN      SM000062F
     C                   READ      SM000062F
      *
      ** If no records on outfile, this file does not exist,
      ** so just flag it as processed on SMLNRFPD.
     C                   IF        %EOF
     C                   CLOSE     SM000062F
     C                   EVAL      *IN90 = *OFF
     C                   GOTO      UpdateF
     C                   ENDIF
      *
      ** Get all field names, and add to field lists.
     C                   DOU       %EOF
      *
      ** Check if a loan reference - if so then convert 0 to blanks
      ** and pad any numbers with leading zeros
     C                   EVAL      FieldName = WHFLDI
     C     Key01         CHAIN     SMLNRFPD
     C                   IF        %FOUND
     C                   EVAL      FromList = %TRIM(FromList) + ', CASE WHEN ' +
     C                             WHFLDI + ' = 0 THEN '' '' ELSE DIGITS(' +
     C                             %TRIM(WHFLDI) + ') END'
     C                   ELSE
     C                   EVAL      FromList = %TRIM(FromList) + ',' + WHFLDI
     C                   ENDIF
      *
     C                   EVAL      ToList = %TRIM(ToList) + ',' + WHFLDI
     C                   READ      SM000062F
     C                   ENDDO
     C                   CLOSE     SM000062F
      *
      ** Remove leading commas
     C                   EVAL      %SUBST(ToList:1:1) = ' '
     C                   EVAL      %SUBST(FromList:1:1) = ' '
      *
      ** Check if multi-member
     C                   EXSR      MultiMbr
      *
      ** Create SQL statement for each member
     C                   DOU       MbrCount = MLNOMB
      *
      ** Create aliases if multimember
     C                   CLEAR                   SQL
     C                   IF        MLNOMB > 1
     C                   EXSR      CrtAlias
     C                   ELSE
     C                   EVAL      MbrCount = 1
     C                   EVAL      MemberName = '*SINGLE   '
     C                   ENDIF
      *
      ** If member creation failed, don't try to process it.
     C                   IF        ByPass <> 'Y'
      *
      ** If multimember, use aliases for the update ...
     C                   IF        MLNOMB > 1
     C                   EVAL      ToSQLLib = 'QTEMP'
     C                   EVAL      ToSQLFile = 'ToAlias'
     C                   EVAL      SQL = %TRIM(CmdInsert) + %TRIM(ToList) +
     C                             ') SELECT ' + %TRIM(FromList) +
     C                             ' FROM QTEMP/FromAlias'
     C                   ELSE
      *
      * ...otherwise just use the file name.
     C                   IF        SingleMode = 'Y'
     C                   EVAL      ToSQLFile = ObjName
     C                   ELSE
     C                   EVAL      ToSQLFile = LNFILE
     C                   ENDIF
     C                   EVAL      SQL = %TRIM(CmdInsert) + %TRIM(ToList) +
     C                             ') SELECT ' + %TRIM(FromList) +
     C                             ' FROM ' + QualName
     C                   ENDIF
      *
      ** Write SQL to source file via UTWRTSQL (can only handle 80 long strings)
      ** - start by clearing the RUNSQLSTM file.
     C                   CLEAR                   Stmt_String
     C                   EVAL      Stmt_String = %SUBST(SQL:1:80)
     C                   CALL      'UTWRTSQL'
     C                   PARM                    Stmt_String
     C                   PARM      '*CLEAR'      Mode
      *
      ** Get the string length
     C                   EVAL      Len = %Len(SQL)
      *
      ** Write the remainder of the statement.
     C                   EVAL      Pos = 1
     C                   EVAL      SST = 80
     C**********         DOW       Len > (Pos + 80) and Len > 80                           AR1092867
     C                   DOW       Len >= (Pos + 80) and Len > 80                          AR1092867
     C                   EVAL      Pos = Pos + 80
      *
      ** Make sure the substring length is valid.
     C                   IF        (Pos + 80) > Len
     C                   EVAL      SST = Len - Pos + 1
     C                   ENDIF
     C                   EVAL      Stmt_String = %SUBST(SQL:Pos:SST)
     C                   CALL      'UTWRTSQL'
     C                   PARM                    Stmt_String
     C                   PARM      *BLANKS       Mode
     C                   ENDDO
      *
      ** Execute SQL via call to QMDEXEC.
     C                   EVAL      QCmdText = ConRunSQL
     C                   EXSR      QCmdExc
      *
      ** If SQL was unsuccessful, then attempt to identify the failure and
      ** migrate in an alternative fashion.
     C                   IF        PSExcpNo = '9010'
     C                   EVAL      SMC44Rtn = *BLANKS
     C                   CALL      'SMC000044'
     C                   PARM                    ObjName
     C                   PARM                    FromLib
     C                   PARM                    ToLib
     C                   PARM                    MemberName
     C                   PARM                    SMC44Rtn
     C                   IF        SMC44Rtn <> *BLANKS
     C                   IF        SMC40Rtn = '*ERROR'
     C                   EVAL      SQLFail = 'Y'
     C                   ELSE
     C                   EVAL      SQLFail = 'U'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** If SQL was successful, commit the update flags
     C     UpdateF       TAG
     C                   IF        SQLFail = ' '
     C                             or SQLFail = 'U'
     C     Key02         SETLL     SMLNRFPD
     C     Key02         READE     SMLNRFPD                               91
     C                   DOW       *IN91 = *OFF
     C                   EVAL      LNUPDF = 'Y'
     C                   UPDATE    LNLNRFD0
     C     Key02         READE     SMLNRFPD                               91
     C                   ENDDO
     C                   ENDIF
      *
     C                   IF        SQLFail = 'Y'
     C                   EVAL      ReturnCode = '*ERROR'
     C                   ENDIF
     C                   IF        SQLFail = 'U'
     C                   EVAL      ReturnCode = '*UNIQUE'
     C                   ENDIF
     C                   ENDIF
      *
      ** Get next file to be migrated
     C     Key02         SETGT     SMLNRFPD
     C                   READ      SMLNRFPD
     C                   EVAL      ObjName = LNFILE
     C                   EVAL      SQLFail = ' '
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * QCmdExc - call QCMDEXC                                        *
      *                                                               *
      *****************************************************************
     C     QCmdExc       BEGSR
      *
     C                   CALL      'QCMDEXC'                            90
     C                   PARM                    QCmdText
     C                   PARM                    QCmdLen
     C                   CLEAR                   QCmdText
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MultiMbr - Check if multi-member file                         *
      *                                                               *
      *****************************************************************
     C     MultiMbr      BEGSR
      *
      ** Get member list
     C                   EVAL      QualName2 = %TRIM(FromLib) + '/' + LNFILE
     C                   EVAL      QCmdText = CmdDSPFD
     C                   EXSR      QCmdExc
     C                   EVAL      QCmdText = ConCRTDUPOBJ2
     C                   EXSR      QCmdExc
     C                   EVAL      QCmdText = ConCPYF2
     C                   EXSR      QCmdExc
      *
      ** If error on DSPFD, report back
     C                   IF        *IN90 = *ON
     C                   EVAL      ReturnCode = '*ERROR'
      *
      ** If in single mode end program now
     C                   IF        SingleMode = 'Y'
     C                   EVAL      ReturnCode = '*NOTFOUND'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Get number of members, then reset to top of file
     C                   EVAL      MbrCount = 0
     C                   OPEN      SM000062M
     C                   READ      SM000062M
     C     1             SETLL     SM000062M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CrtAlias - Create alias for multi-member file                 *
      *                                                               *
      *****************************************************************
     C     CrtAlias      BEGSR
      *
      ** Get next member name
     C                   EVAL      MbrCount = MbrCount + 1
     C                   IF        MLNOMB >= MbrCount
     C                   READ      SM000062M
     C                   EVAL      MemberName = MLNAME
      *
      ** If end of file, close it
     C                   IF        %EOF
     C                   CLOSE     SM000062M
     C                   ENDIF
      *
      ** Make sure to-member exists
     C                   CALL      'SMC000041'
     C                   PARM                    ToLib
     C                   PARM                    MLFILE
     C                   PARM                    MLNAME
     C                   PARM                    MLMTXT
     C                   PARM                    ReturnCodeOut
      *
      ** If member not created set bypass flag
     C                   EVAL      ByPass = ' '
     C                   IF        ReturnCodeOut <> *Blanks
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      ByPass = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Drop previous aliases
     C                   EVAL      QCmdText = 'DLTF QTEMP/FromAlias'
     C                   EXSR      QCmdExc
     C                   EVAL      QCmdText = 'DLTF QTEMP/ToAlias'
     C                   EXSR      QCmdExc
      *
      ** Create new aliases
     C                   CLEAR                   Stmt_String
     C                   EVAL      Stmt_String = 'CREATE ALIAS QTEMP/FromAlias +
     C                              FOR ' + QualName + ' (' + MLNAME + ')'
      *
     C                   CALL      'UTWRTSQL'
     C                   PARM                    Stmt_String
     C                   PARM      '*CLEAR'      Mode
      *
      ** Execute SQL via call to QMDEXEC
     C                   EVAL      QCmdText = ConRunSQL
     C                   EXSR      QCmdExc
      *
     C                   CLEAR                   Stmt_String
     C                   EVAL      Stmt_String = 'CREATE ALIAS QTEMP/ToAlias +
     C                              FOR ' + %TRIM(ToLib) + '/ ' + MLFILE
     C                               + ' (' + MLNAME +')'
      *
     C                   CALL      'UTWRTSQL'
     C                   PARM                    Stmt_String
     C                   PARM      '*CLEAR'      Mode
      *
      ** Execute SQL via call to QMDEXEC
     C                   EVAL      QCmdText = ConRunSQL
     C                   EXSR      QCmdExc
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY GPCPYSRCG,PSSR_ILENE
     C                   EVAL      ReturnCode = '*ERROR'
     C                   ENDSR
      *****************************************************************
