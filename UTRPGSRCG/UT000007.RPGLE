     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*O*R****CRTSRCPF***FILE(QTEMP/UTSQLEXC)*RCDLEN(92)********************                       CUT008
/*XBI *  CRTSRCPF   FILE(QTEMP/UTSQLEXC) RCDLEN(112)                  *                       CUT008
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Replace the SQL object name and library')     *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000007 - Replace the SQL Object Name and Library           *
      *                                                               *
      *  Component of: UTC000007                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUT008             Date 24Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK022             Date 10Aug05               *
      *                 CPK019             Date 24Jun04               *
      *                 CPK018  *MOVED     Date 30Jan04               *
      *                 CAP084             Date 28Oct03               *
      *                 CPK016  *CREATE    Date 15Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT008 - CRTOBJ rewrite.                                     *
      *           Change record length of UTSQLEXC to 112.            *
      *  CPK022 - Change CALLB UTC000008 to CALL UTC000008.           *
      *  CPK019 - Remove references to zone layer.                    *
      *  CPK018 - MidasPlus packaging                                 *
      *  GPG001 - MidasPlus changes to insert column headings         *
      *  CPK016 - R5.00 Packaging.                                    *
      *           - Change CRTOBJ to create SQL objects.              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         End of file for UTSQLEXC                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FUTSQLEXC  UF A E             DISK
     F                                     RENAME(UTSQLEXC:UTSQLEXF)
 
     FUTFLTXPD  IF   E           K DISK                                                       CAP084
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     DCompareString    S             21    INZ('**********/**********')                       CAP084
     D*CompareString***S*************21    INZ('  **********/**********')                     CAP084
     DDescribeString   S             16    INZ(' * DESCRIBEFIELD')                            CAP084
     DDescListStart    S             16    INZ(' * DESCRIBESTART')                            CAP084
     DDescListEnd      S             14    INZ(' * DESCRIBEEND')                              CAP084
     DObject           S             10
     DObjectLib        S             10
                                                                                              CAP084
     DDescribeDS       DS            68                                                       CAP084
     D CalcField              18     27                                                       CAP084
     D OrigField              32     41                                                       CAP084
     D FileName               49     58                                                       CAP084
     D BaseCcy                60     68                                                       CAP084
                                                                                              CAP084
     DBeginLabel       S             18    INZ('  LABEL ON COLUMN ')                          CAP084
     DDescCount        S              3  0 INZ(0)                                             CAP084
     DDescCount2       S              3  0 INZ(0)                                             CAP084
     DDescCount3       S              3  0 INZ(0)                                             CAP084
     D RunBefore       S              1A                                                      CPK019
 
      * These variables are used to ensure the column heading does not exceed 60              CAP084
      * and text description does not exceed 50                                               CAP084
     DColumnHead       S             74                                                       CAP084
     DTextDesc         S             69                                                       CAP084
                                                                                              CAP084
      * Field for locating the position of the **********/********** string                   CAP084
     DPosition         S              2  0                                                    CAP084
                                                                                              CAP084
      * WCMD field for deleting override                                                      CPK018
     DWCMD             S             20    INZ('DLTOVR (UTFLTXPD)')                           CPK018
                                                                                              CPK018
      ** The following /COPY line includes all the defined fields in the                      CPK018
      ** PSDS.  They have meaningful names, prefixed by 'PS'.                                 CPK018
                                                                                              CPK018
      ** +--------------------------------------+                                             CPK018
      ** ¦ Automatically included D-specs       ¦                                             CPK018
      ** ¦ ==============================       ¦                                             CPK018
      ** +--------------------------------------+                                             CPK018
                                                                                              CPK018
      **--------------------------------------------------------------------------------------CPK018
      ** The following /COPY line includes (among others) the LDA layout                      CPK018
      ** and the copyright array definition:                                                  CPK018
     D*COPY*ZACPYSRC,STD_D_SPEC*                                                       CPK018 CPK019
     D/COPY GPCPYSRCG,GP_D_SPEC                                                               CPK019
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)                           CPK019
      **--------------------------------------------------------------------------------------CPK018
                                                                                              CPK018
      **--------------------------------------------------------------------------------------CPK018
      ***The*following*/COPY*includes*the*MM*standard*declares:*                       CPK018 CPK019
     D*COPY*ZACPYSRC,STDDECLARE*                                                       CPK018 CPK019
      **--------------------------------------------------------------------------------------CPK018
                                                                                              CPK018
     D*COPY*ZACPYSRC,PSDS*                                                             CPK018 CPK019
     D/COPY GPCPYSRCG,PSDS                                                                    CPK019
                                                                                              CPK018
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C**********         CALLB     'UTC000008'                                         CAP084 CPK022
     C                   CALL      'UTC000008'                                                CPK022
     C                   PARM      '1'           CallCode                                     CAP084
     C                   PARM      *BLANKS       OrigField                                    CAP084
     C                   PARM      *BLANKS       FileName                                     CAP084
                                                                                              CAP084
      * Read the executable file until the /**********/**********'
      * marker is found
 
     C                   READ      UTSQLEXC                               99
      *
     C     *IN99         DOUEQ     '1'
      *
      * When the the /**********/**********' marker is found, replace it
      * with the object and library names.
 
     C     CompareString SCAN      SRCDTA        Position                 90                  CAP084
     C                   If        *IN90 = '1'                                                CAP084
     C                   EVAL      SRCDTA = %SubSt(SRCDTA:1:Position -1) +                    CAP084
     C                             '  ' + ObjectLib + '/' + Object  + '  ' +                  CAP084
     C                             %SubSt(SRCDTA:Position + 23)                               CAP084
     C                   EVAL      *IN90 = '0'                                                CAP084
     C*****SRCDTA        IFEQ      CompareString                                              CAP084
     C*****              EVAL      SRCDTA = '  ' + ObjectLib + '/' + Object                   CAP084
     C                   UPDATE    UTSQLEXF
     C                   ENDIF
                                                                                              CAP084
      * When the the ' * DESCRIBE' marker is found, setup the fields                          CAP084
      * to extract the derived column headings and text.                                      CAP084
                                                                                              CAP084
     C                   IF        DescribeString= %SubSt(SRCDTA:1:16)                        CAP084
      * Count to see how many describe lines there are for comma separation                   CAP084
     C                   Eval      DescCount = DescCount +1                                   CAP084
     C                   EVAL      DescribeDS = SRCDTA                                        CAP084
     C**********         CALLB     'UTC000008'                                         CAP084 CPK022
     C                   CALL      'UTC000008'                                                CPK022
     C                   PARM      '2'           CallCode          1                          CAP084
     C                   PARM                    OrigField                                    CAP084
     C                   PARM                    FileName                                     CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   READ      UTSQLEXC                               99
     C                   ENDDO
                                                                                              CAP084
     C     KeyList       KLIST                                                                CAP084
     C                   KFLD                    OrigField                                    CAP084
     C                   KFLD                    FileName                                     CAP084
                                                                                              CAP084
     C     1             SETLL     UTSQLEXC                                                   CAP084
     C                   READ      UTSQLEXC                               99                  CAP084
      *                                                                                       CAP084
     C     *IN99         DOUEQ     '1'                                                        CAP084
      * When source is ' * DESCRIBESTART' output the beginning for the  olumn                 CAP084
      * labels                                                                                CAP084
     C                   IF        DescListStart= %SubSt(SRCDTA:1:16)                         CAP084
     C                   Eval      SRCDTA = (BeginLabel + ObjectLib + '/' +                   CAP084
     C                             Object + '(')                                              CAP084
     C                   WRITE     UTSQLEXF                                                   CAP084
     C                   EndIf                                                                CAP084
      *                                                                                       CAP084
      * When source is ' * DESCRIBE' find the original field descriptions                     CAP084
      * and output to SRCDTA                                                                  CAP084
     C                   IF        DescribeString= %SubSt(SRCDTA:1:16)                        CAP084
      * Count to see how many describe lines there are for comma separation                   CAP084
     C                   Eval      DescCount2 = DescCount2 +1                                 CAP084
     C                   EVAL      DescribeDS = SRCDTA                                        CAP084
     C     KeyList       CHAIN     UTFLTXD0                                                   CAP084
                                                                                              CAP084
      * Concatenate to output column headings to calculated fields (add base ccy if required) CAP084
     C                   IF        BaseCcy = '(BASECCY)'                                      CAP084
     C                   Eval      ColumnHead = CalcField + ' IS ' +                          CAP084
     C                             '''' + 'Base Ccy ' + %TRIM(LABEL)                          CAP084
     C                   If        DescCount2 <> DescCount                                    CAP084
     C                   Eval      SRCDTA = %TRIM(ColumnHead) + '''' +                        CAP084
     C                             ','                                                        CAP084
     C                   Else                                                                 CAP084
     C                   Eval      SRCDTA = %TRIM(ColumnHead) + ''''                          CAP084
     C                   EndIf                                                                CAP084
     C                   Else                                                                 CAP084
     C                   If        DescCount2 <> DescCount                                    CAP084
     C                   Eval      SRCDTA = CalcField + ' IS ' +                              CAP084
     C                             '''' +  %TRIM(LABEL) + '''' + ','                          CAP084
     C                   Else                                                                 CAP084
     C                   Eval      SRCDTA = CalcField + ' IS ' +                              CAP084
     C                             '''' +  %TRIM(LABEL) + ''''                                CAP084
     C                   EndIf                                                                CAP084
     C                   EndIf                                                                CAP084
     C                   WRITE     UTSQLEXF                                                   CAP084
      * If this is the last describe line, do not separate with a comma                       CAP084
     C*                  If        DescCount2 <> DescCount                                    CAP084
     C*                  Eval      SRCDTA = ','                                               CAP084
     C*                  WRITE     UTSQLEXF                                                   CAP084
     C*                  EndIf                                                                CAP084
                                                                                              CAP084
     C                   EndIf                                                                CAP084
                                                                                              CAP084
      * When source is '/* DESCRIBEEND' output the end for the column                         CAP084
      * labels                                                                                CAP084
     C                   IF        DescListEnd= %SubSt(SRCDTA:1:14)                           CAP084
     C                   Eval      SRCDTA = ('  );')                                          CAP084
     C                   WRITE     UTSQLEXF                                                   CAP084
     C                   EndIf                                                                CAP084
                                                                                              CAP084
     C                   READ      UTSQLEXC                               99                  CAP084
     C                   ENDDO                                                                CAP084
      *                                                                                       CAP084
                                                                                              CAP084
     C     1             SETLL     UTSQLEXC                                                   CAP084
     C                   READ      UTSQLEXC                               99                  CAP084
      *                                                                                       CAP084
     C     *IN99         DOUEQ     '1'                                                        CAP084
      * When source is '/* DESCRIBESTART' output the beginning for the column                 CAP084
      * labels                                                                                CAP084
     C                   IF        DescListStart= %SubSt(SRCDTA:1:16)                         CAP084
     C                   Eval      SRCDTA = (BeginLabel + ObjectLib + '/' +                   CAP084
     C                             Object + '(')                                              CAP084
     C                   WRITE     UTSQLEXF                                                   CAP084
     C                   EndIf                                                                CAP084
      *                                                                                       CAP084
      * When source is ' * DESCRIBE' find the original field descriptions                     CAP084
      * and output to SRCDTA                                                                  CAP084
     C                   IF        DescribeString= %SubSt(SRCDTA:1:16)                        CAP084
      * Count to see how many describe lines there are for comma separation                   CAP084
     C                   Eval      DescCount3 = DescCount3 +1                                 CAP084
     C                   EVAL      DescribeDS = SRCDTA                                        CAP084
     C     KeyList       CHAIN     UTFLTXD0                                                   CAP084
                                                                                              CAP084
      * Concatenate to output column headings to calculated fields                            CAP084
     C                   IF        BaseCcy = '(BASECCY)'                                      CAP084
     C                   Eval      TextDesc =  CalcField + ' TEXT IS '                        CAP084
     C                             + '''' + 'Base Ccy '  + %TRIM(LABELTEXT)                   CAP084
     C                   If        DescCount3 <> DescCount                                    CAP084
     C                   Eval      SRCDTA = %TRIM(TextDesc) + '''' + ','                      CAP084
     C                   Else                                                                 CAP084
     C                   Eval      SRCDTA = %TRIM(TextDesc) + ''''                            CAP084
     C                   EndIf                                                                CAP084
     C                   Else                                                                 CAP084
     C                   If        DescCount3 <> DescCount                                    CAP084
     C                   Eval      SRCDTA = CalcField + ' TEXT IS ' +                         CAP084
     C                             '''' +  %TRIM(LABELTEXT) + '''' + ','                      CAP084
     C                   Else                                                                 CAP084
     C                   Eval      SRCDTA = CalcField + ' TEXT IS ' +                         CAP084
     C                             '''' +  %TRIM(LABELTEXT) + ''''                            CAP084
     C                   Endif                                                                CAP084
     C                   Endif                                                                CAP084
     C                   WRITE     UTSQLEXF                                                   CAP084
      * If this is the last describe line, do not separate with a comma                       CAP084
     C*                  If        DescCount3 <> DescCount                                    CAP084
     C*                  Eval      SRCDTA = ','                                               CAP084
     C*                  WRITE     UTSQLEXF                                                   CAP084
     C*                  EndIf                                                                CAP084
     C                   EndIf                                                                CAP084
                                                                                              CAP084
      * When source is ' * DESCRIBEEND' output the end for the column                         CAP084
      * labels                                                                                CAP084
     C                   IF        DescListEnd= %SubSt(SRCDTA:1:14)                           CAP084
     C                   Eval      SRCDTA = ('  );')                                          CAP084
     C                   WRITE     UTSQLEXF                                                   CAP084
     C                   EndIf                                                                CAP084
                                                                                              CAP084
     C                   READ      UTSQLEXC                               99                  CAP084
     C                   ENDDO                                                                CAP084
      *                                                                                       CAP084
     C     1             SETLL     UTSQLEXC                                                   CAP084
     C                   READ      UTSQLEXC                               99                  CAP084
      *                                                                                       CAP084
     C     *IN99         DOUEQ     '1'                                                        CAP084
      * When source is ' * DESCRIBE' delete the line from the source that                     CAP084
      * will be run by RUNSQLSTMT                                                             CAP084
     C                   IF        %SubSt(SRCDTA:1:11) = ' * DESCRIBE'                        CAP084
     C                   DELETE    UTSQLEXF                                                   CAP084
     C                   EndIf                                                                CAP084
     C                   READ      UTSQLEXC                               99                  CAP084
     C                   ENDDO                                                                CAP084
      *
     C                   CALL      'QCMDEXC'                            91                    CPK018
     C                   PARM                    WCMD                                         CPK018
     C                   PARM      20            WLEN             15 5                        CPK018
      *                                                                                       CPK018
     C                   IF        *IN91 = '1'                                                CPK018
     C                   IF        PSExcpNo <> '9841'                                         CPK018
     C                   EXSR      *PSSR                                                      CPK018
     C                   ENDIF                                                                CPK018
     C                   ENDIF                                                                CPK018
      *                                                                                       CPK018
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ObjectLib
     C                   PARM                    Object
 
      **--------------------------------------------------------------------------------------CPK018
      ** The following /COPY sets the values of program, module and                           CPK018
      ** procedure names for database error processing.                                       CPK018
     C*COPY*ZACPYSRC,DBFIELDS*                                                         CPK018 CPK019
     C                   EVAL      DBPgm  = PSProcPgm                                         CPK019
     C                   EVAL      DBMod  = PSProcMod                                         CPK019
     C                   EVAL      DBProc = PSProcName                                        CPK019
      **--------------------------------------------------------------------------------------CPK018
                                                                                              CPK018
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CPK018
      *****************************************************************                       CPK018
      **--------------------------------------------------------------------------------------CPK018
      ** The following /COPY contains the standard program status                             CPK018
      ** subroutine, including a bound call to the DBERRCTL module.                           CPK018
     C*COPY*ZACPYSRC,PSSR_ILENE*                                                       CPK018 CPK019
     C     *pssr         BEGSR                                                                CPK019
     C                   EVAL       *inu7 = *on                                               CPK019
     C                   EVAL       *inu8 = *on                                               CPK019
     C                   EVAL       *inlr = *on                                               CPK019
      *                                                                                       CPK019
     C                   IF        RunBefore <> 'Y'                                           CPK019
     C                   EVAL      RunBefore = 'Y'                                            CPK019
     C                   DUMP                                                                 CPK019
     C                   ENDIF                                                                CPK019
      *
     C                   RETURN                                                               CPK018
                                                                                              CPK018
     C                   ENDSR                                                                CPK018
      **--------------------------------------------------------------------------------------CPK018
      ********************************************************************                    CPK018
      /EJECT                                                                                  CPK018
      ********************************************************************                    CPK018
**  CPY@                                                                                      CPK018
(c) Finastra International Limited 2003                                                       CPK018
