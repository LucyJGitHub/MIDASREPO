     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*XBIA*  OVRDBF FILE(SM000040F) TOFILE(UPFFDSTPD)                     *                     BUG27793
/*XBIB*  OVRDBF FILE(SM000040M) TOFILE(UPMBRLTPD)                     *                     BUG27793
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Migrate and convert customer fields')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000040 - This program has been written especially to deal  *
      *             with the change of Customer Numbers to alpha.  If *
      *             a Customer Number field contained 000000 then it  *
      *             is set to blank.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CUP003             Date 02Aug10               *
      *  Prev Amend No. BUG27793           Date 07Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BG18582            Date 06Jul06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025  *CREATE    Date 06Jul06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP003 - Handle unique key problems better.                  *
      *  B27793 - Make migration multi-streamed.                      *
      *  BG18582 - Initialise return code.                            *
      *  CPK025 - MidasPlus 1.3 packaging.  New migration tool.       *
      *                                                               *
      *****************************************************************
      *
      * Files with customer name fields
     FSMCNUMPD  UF   E           K DISK
      *
      * DSPFFD outfile
     F*UPFFDSTPDIF***E             DISK    USROPN                                           BUG27793
     FSM000040F IF   E             DISK    USROPN                                           BUG27793
      *
      * DSPFD outfile
     F*UPMBRLTPDIF***E             DISK    USROPN                                           BUG27793
     FSM000040M IF   E             DISK    USROPN                                           BUG27793
      *
      * Parameters
     D FromObj         S             10
     D FromType        S              8
     D FromLib         S             10
     D ToLib           S             10
     D ReRun           S              4
     D SingleMode      S              1
     D ReturnCodeOut   S             10
      *
      * Parameters for call to UTWRTSQL
     D Stmt_String     S             80
     D Mode            S              6
      *
      * Work variables:
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
      * Fields for storing field names
     D FromList        S          32767    Varying
     D ToList          S          32767    Varying
      *
      * Fields for SQL statement
     D SQL             S          32767    Varying
     D Len             S              5  0
     D Pos             S              5  0
     D SST             S              2  0
      **
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
      * Constants:
     D ConDSPFFD       C                   'DSPFFD FILE(                     ) +
     D                                     OUTPUT(*OUTFILE) +
     D**********                           OUTFILE(UPFFDSTPD) +                             BUG27793
     D                                     OUTFILE(QTEMP/FFD) +                             BUG27793
     D                                     OUTMBR(*FIRST *REPLACE)'
      *
     D ConInsert       C                   'INSERT INTO           /           ('
      *
     D ConRunSQL       C                   'RUNSQLSTM SRCFILE(QTEMP/RUNSQL) +
     D                                     SRCMBR(RUNSQLSTM) COMMIT(*NONE)'
      *
     D ConDSPFD        C                   'DSPFD FILE(                     ) +
     D                                     TYPE(*MBRLIST) OUTPUT(*OUTFILE) +
     D**********                           OUTFILE(UPMBRLTPD) +                             BUG27793
     D                                     OUTFILE(QTEMP/MBRL) +                            BUG27793
     D                                     OUTMBR(*FIRST *REPLACE)'
      *
     D ConCLRPFM       C                   'CLRPFM FILE(                     ) +
     D                                     MBR(*ALL)'
      *
     D ConCRTDUPOBJ1   C                   'CRTDUPOBJ OBJ(UPFFDSTPD) +                      BUG27793
     D                                     FROMLIB(*LIBL) OBJTYPE(*FILE) +                  BUG27793
     D                                     TOLIB(QTEMP) NEWOBJ(SM000040F)'                  BUG27793
      *
     D ConCRTDUPOBJ2   C                   'CRTDUPOBJ OBJ(UPMBRLTPD) +                      BUG27793
     D                                     FROMLIB(*LIBL) OBJTYPE(*FILE) +                  BUG27793
     D                                     TOLIB(QTEMP) NEWOBJ(SM000040M)'                  BUG27793
      *
     D ConCPYF1        C                   'CPYF FROMFILE(FFD) +                            BUG27793
     D                                     TOFILE(SM000040F) MBROPT(*REPLACE) +             BUG27793
     D                                     FMTOPT(*MAP *DROP)'                              BUG27793
      *
     D ConCPYF2        C                   'CPYF FROMFILE(MBRL) +                           BUG27793
     D                                     TOFILE(SM000040M) MBROPT(*REPLACE) +             BUG27793
     D                                     FMTOPT(*MAP *DROP)'                              BUG27793
      *
      * DS for call to QCMDEXC for DSPFFD
     DCmdDSPFFD        DS           150
     D QualName               13     33
      *
      * DS for call to QCMDEXC for DSPFFD
     DCmdCLRPFM        DS           150
     D QualName3              13     33
      *
      * DS to create SQL command
     DCmdInsert        DS           150
     D ToSQLLib               13     22
     D ToSQLFile              24     33
      *
      * DS for call to QCMDEXC for DSPFD
     DCmdDSPFD         DS           150
     D QualName2              12     32
      *
      *****************************************************************
      *                                                               *
      * Start of MAIN processing                                      *
      *                                                               *
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
     C                   EVAL      ReturnCode = *blanks                                      BG18582
     C                   EVAL      ObjName = FromObj
     C                   EVAL      ObjType = FromType
      *
      * If ReRun is '*NO ', set all update flags to blank.
     C                   IF        ReRun  = '*NO '
     C/Exec SQL
     C+ Update SMCNUMPD set CNUPDF = ' '
     C/End-Exec
     C                   ENDIF
      *
      * Set up QCMD defaults
     C                   EVAL      CmdDSPFFD = ConDSPFFD
     C                   EVAL      CmdDSPFD = ConDSPFD
     C                   EVAL      CmdCLRPFM = ConCLRPFM
      *
      * Set up SQL defaults
     C                   EVAL      CmdInsert = ConInsert
     C                   EVAL      ToSQLLib = ToLib
      *
      * Read in the files to be migrated (or single file,
      * if in single mode)
     C                   IF        SingleMode = 'Y'
     C     Key02         CHAIN     SMCNUMPD
     C                   IF        NOT %FOUND
     C                   EVAL      ReturnCode = '*NOTONCNUM'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ELSE
     C                   READ      SMCNUMPD
     C                   ENDIF
     C                   EVAL      ObjName = CNFILE
     C                   EVAL      SQLFail = ' '
 
     C                   DOU       %EOF or SingleMode = 'Y'
      *
      * Only process file if it hasn't already been processed.
     C                   IF        CNUPDF <> 'Y'
      *
     C                   IF        FromType = '*DTAARA '
     C                   CALL      'SMC000040'
     C                   PARM                    FromObj
     C                   PARM                    FromLib
     C                   PARM                    ToLib
     C                   PARM                    CNFPOS
     C                   PARM                    SMC40Rtn
     C                   IF        SMC40Rtn <> ' '
     C**********         EVAL      ErrorMsg = %TRIMR(ObjName) + ' , type +                  BUG27793
     C**********                   *DTAARA failed to copy.'                                 BUG27793
     C**********         EXSR      WriteErrMsg                                              BUG27793
     C                   EVAL      SQLFail = 'Y'
     C                   ENDIF
      *
     C                   ELSE
      *
      * Reset work variables
     C                   CLEAR                   FromList
     C                   CLEAR                   ToList
      *
      * Set up CLRPFM
     C                   EVAL      QualName3 = %Trim(ToLib) + '/' + CNFILE
     C                   EVAL      QCmdText = CmdCLRPFM
     C                   EXSR      QCmdExc
      * Set up DSPFFD
     C                   EVAL      QualName = %Trim(FromLib) + '/' + CNFILE
     C                   EVAL      QCmdText = CmdDSPFFD
     C                   EXSR      QCmdExc
     C                   EVAL      QCmdText = ConCRTDUPOBJ1                                 BUG27793
     C                   EXSR      QCmdExc                                                  BUG27793
     C                   EVAL      QCmdText = ConCPYF1                                      BUG27793
     C                   EXSR      QCmdExc                                                  BUG27793
      *
      * Read DSPFFD outfile.
     C**********         OPEN      UPFFDSTPD                                                BUG27793
     C**********         READ      UPFFDSTPD                                                BUG27793
     C                   OPEN      SM000040F                                                BUG27793
     C                   READ      SM000040F                                                BUG27793
      *
      * If no records on outfile, this file does not exist,
      * so just flag it as processed on SMCNUMPD.
     C                   IF        %EOF
     C**********         CLOSE     UPFFDSTPD                                                BUG27793
     C                   CLOSE     SM000040F                                                BUG27793
     C                   EVAL      *IN90 = *OFF
     C                   GOTO      UpdateF
     C                   ENDIF
      *
      * Get all field names, and add to field lists.
     C                   DOU       %EoF
      *
      * Check if a customer field - if so then convert 0 to blanks
      * and pad any numbers with leading zeros
     C                   EVAL      FieldName = WHFLDI
     C     Key01         CHAIN     SMCNUMPD
     C                   IF        %FOUND
     C                   EVAL      FromList = %Trim(FromList) + ', case when ' +
     C                             WHFLDI + ' = 0 then '' '' else digits(' +
     C                             %Trim(WHFLDI) + ') end'
     C                   ELSE
     C                   EVAL      FromList = %Trim(FromList) + ',' + WHFLDI
     C                   ENDIF
      *
     C                   EVAL      ToList = %Trim(ToList) + ',' + WHFLDI
     C**********         READ      UPFFDSTPD                                                BUG27793
     C                   READ      SM000040F                                                BUG27793
     C                   ENDDO
     C**********         CLOSE     UPFFDSTPD
     C                   CLOSE     SM000040F                                                BUG27793
      *
      * Remove leading commas
     C                   EVAL      %SUBST(ToList:1:1) = ' '
     C                   EVAL      %SUBST(FromList:1:1) = ' '
      *
      * Check if multi-member
     C                   EXSR      MultiMbr
      *
      * Create SQL statement for each member
     C                   DOU       MbrCount = MLNOMB
      *
      * Create aliases if multimember
     C                   CLEAR                   SQL
     C                   IF        MLNOMB > 1
     C                   EXSR      CrtAlias
     C                   ELSE
     C                   EVAL      MbrCount = 1
     C                   EVAL      MemberName = '*SINGLE   '
     C                   ENDIF
      *
      * If member creation failed, don't try to process it.
     C                   IF        ByPass <> 'Y'
      *
      * If multimember, use aliases for the update ....
     C                   IF        MLNOMB > 1
     C                   EVAL      ToSQLLib = 'QTEMP'
     C                   EVAL      ToSQLFile = 'ToAlias'
     C                   EVAL      SQL = %Trim(CmdInsert) + %trim(ToList) +
     C                             ') select ' + %Trim(FromList) +
     C                             ' from QTEMP/FromAlias'
     C                   ELSE
      *
      * ...otherwise just use the file name.
     C                   IF        SingleMode = 'Y'
     C                   EVAL      ToSQLFile = ObjName
     C                   ELSE
     C                   EVAL      ToSQLFile = CNFILE
     C                   ENDIF
     C                   EVAL      SQL = %Trim(CmdInsert) + %trim(ToList) +
     C                             ') select ' + %Trim(FromList) +
     C                             ' from ' + QualName
     C                   EndIf
      *
      * Write SQL to source file via UTWRTSQL (can only handle 80 long strings)
      *  - start by clearing the RUNSQLSTM file.
     C                   CLEAR                   Stmt_String
     C                   EVAL      Stmt_String = %SubSt(SQL:1:80)
     C                   CALL      'UTWRTSQL'
     C                   PARM                    Stmt_String
     C                   PARM      '*CLEAR'      Mode
      *
      * Get the string length
     C                   EVAL      Len = %Len(SQL)
      *
      * Write the remainder of the statement.
     C                   EVAL      Pos = 1
     C                   EVAL      SST = 80
     C                   DOW       Len > (Pos + 80) and Len > 80
     C                   EVAL      Pos = Pos + 80
      *
      * Make sure the substring length is valid.
     C                   IF        (Pos + 80) > Len
     C                   Eval      SST = Len - Pos + 1
     C                   ENDIF
     C                   EVAL      Stmt_String = %SubSt(SQL:Pos:SST)
     C                   CAll      'UTWRTSQL'
     C                   PARM                    Stmt_String
     C                   PARM      *Blanks       Mode
     C                   ENDDO
      *
      * Execute SQL via call to QMDEXEC.
     C                   EVAL      QCmdText = ConRunSQL
     C                   EXSR      QCmdExc
      *
      * If SQL was unsuccessful, then attempt to identify the failure and
      *  migrate in an alternative fashion.
     C                   IF        PSExcpNo = '9010'
     C                   EVAL      SMC44Rtn = *blanks
     C                   CALL      'SMC000044'
     C                   PARM                    ObjName
     C                   PARM                    FromLib
     C                   PARM                    ToLib
     C                   PARM                    MemberName
     C                   PARM                    SMC44Rtn
     C                   IF        SMC44Rtn <> *blanks
     C**********         EVAL      ErrorMsg = %TRIMR(ObjName) + ' , type *FILE +            BUG27793
     C**********                   failed in secondary copy.'                               BUG27793
     C**********         EXSR      WriteErrMsg                                              BUG27793
     C                   IF        SMC40Rtn = '*ERROR'                                        CUP003
     C                   EVAL      SQLFail = 'Y'
     C                   ELSE                                                                 CUP003
     C                   EVAL      SQLFail = 'U'                                              CUP003
     C                   ENDIF                                                                CUP003
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      * If SQL was successful, commit the update flags
     C     UpdateF       TAG
     C                   IF        SQLFail = ' '
     C                             or SQLFail = 'U'                                           CUP003
     C     Key02         SETLL     SMCNUMPD
     C     Key02         READE     SMCNUMPD                               91
     C                   DOW       *IN91 = *OFF
     C                   EVAL      CNUPDF = 'Y'
     C                   UPDATE    CNCNUMD0
     C     Key02         READE     SMCNUMPD                               91
     C                   ENDDO
     C                   ENDIF                                                                CUP003
      *
     C**********         ELSE                                                                 CUP003
     C                   IF        SQLFail = 'Y'                                              CUP003
     C                   EVAL      ReturnCode = '*ERROR'
     C                   ENDIF
     C                   IF        SQLFail = 'U'                                              CUP003
     C                   EVAL      ReturnCode = '*UNIQUE'                                     CUP003
     C                   ENDIF                                                                CUP003
     C                   ENDIF
      *
      * Get next file to be migrated
     C     Key02         SETGT     SMCNUMPD
     C                   READ      SMCNUMPD
     C                   EVAL      ObjName = CNFILE
     C                   EVAL      SQLFail = ' '
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
     C     QCmdExcE      ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * MultiMbr - Check if multi-member file                         *
      *                                                               *
      *****************************************************************
     C     MultiMbr      BEGSR
      *
      * Get member list
     C                   EVAL      QualName2 = %Trim(FromLib) + '/' + CNFILE
     C                   EVAL      QCmdText = CmdDSPFD
     C                   EXSR      QCmdExc
     C                   EVAL      QCmdText = ConCRTDUPOBJ2                                 BUG27793
     C                   EXSR      QCmdExc                                                  BUG27793
     C                   EVAL      QCmdText = ConCPYF2                                      BUG27793
     C                   EXSR      QCmdExc                                                  BUG27793
      *
      * If error on DSPFD, report back
     C                   IF        *IN90 = *ON
     C                   EVAL      ReturnCode = '*ERROR'
      *
      * If in single mode end program now
     C                   IF        SingleMode = 'Y'
     C                   EVAL      ReturnCode = '*NOTFOUND'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      * Get number of members, then reset to top of file
     C                   EVAL      MbrCount = 0
     C**********         OPEN      UPMBRLTPD
     C**********         READ      UPMBRLTPD
     C*****1****         SETLL     UPMBRLTPD
     C                   OPEN      SM000040M
     C                   READ      SM000040M
     C     1             SETLL     SM000040M
 
     C     MultiMbrE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * CrtAlias - Create alias for multi-member file                 *
      *                                                               *
      *****************************************************************
     C     CrtAlias      BEGSR
      *
      * Get next member name
     C                   EVAL      MbrCount = MbrCount + 1
     C                   IF        MLNOMB >= MbrCount
     C**********         READ      UPMBRLTPD                                                BUG27793
     C                   READ      SM000040M                                                BUG27793
     C                   EVAL      MemberName = MLNAME
      *
      * If end of file, close it
     C                   IF        %EOF
     C**********         CLOSE     UPMBRLTPD                                                BUG27793
     C                   CLOSE     SM000040M                                                BUG27793
     C                   ENDIF
      *
      * Make sure to-member exists
     C                   CALL      'SMC000041'
     C                   PARM                    ToLib
     C                   PARM                    MLFILE
     C                   PARM                    MLNAME
     C                   PARM                    MLMTXT
     C                   PARM                    ReturnCodeOut
      *
      * If member not created set bypass flag
     C                   EVAL      ByPass = ' '
     C                   IF        ReturnCodeOut <> *Blanks
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      ByPass = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Drop previous aliases
     C                   EVAL      QCmdText = 'DLTF QTEMP/FromAlias'
     C                   EXSR      QCmdExc
     C                   EVAL      QCmdText = 'DLTF QTEMP/ToAlias'
     C                   EXSR      QCmdExc
      *
      * Create new aliases
     C                   CLEAR                   Stmt_String
     C                   EVAL      Stmt_String = 'Create alias qtemp/FromAlias +
     C                              for ' + QualName + ' (' + MLNAME + ')'
      *
     C                   CALL      'UTWRTSQL'
     C                   PARM                    Stmt_String
     C                   PARM      '*CLEAR'      Mode
      *
      * Execute SQL via call to QMDEXEC
     C                   EVAL      QCmdText = ConRunSQL
     C                   EXSR      QCmdExc
      *
     C                   CLEAR                   Stmt_String
     C                   EVAL      Stmt_String = 'Create alias qtemp/ToAlias +
     C                              for ' + %Trim(ToLib) + '/ ' + MLFILE
     C                               + ' (' + MLNAME +')'
      *
     C                   CALL      'UTWRTSQL'
     C                   PARM                    Stmt_String
     C                   PARM      '*CLEAR'      Mode
      *
      * Execute SQL via call to QMDEXEC
     C                   EVAL      QCmdText = ConRunSQL
     C                   EXSR      QCmdExc
      *
     C     CrtAliasE     ENDSR
      *EJECT*****                                                                           BUG27793
      *****************************************************************                     BUG27793
      ***********                                                     *                     BUG27793
      **WriteErrMsg*-*Write*error*messages*for*final*report*          *                     BUG27793
      ***********                                                     *                     BUG27793
      *****************************************************************                     BUG27793
     C*****WriteErrMSg   BEGSR                                                              BUG27793
      **********                                                                            BUG27793
     C**********         CALL      'UP008010'                                               BUG27793
     C**********         PARM                    Write                                      BUG27793
     C**********         PARM                    PSProcPgm                                  BUG27793
     C**********         PARM                    ErrorMsg                                   BUG27793
      **********                                                                            BUG27793
     C*****WriteErrMSgE  ENDSR                                                              BUG27793
      /EJECT
      *****************************************************************
     C/COPY GPCPYSRCG,PSSR_ILENE
     C                   EVAL      ReturnCode = '*ERROR'
     C                   ENDSR
      *****************************************************************
