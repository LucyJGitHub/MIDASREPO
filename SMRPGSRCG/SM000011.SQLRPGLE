     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
 **** *****************************************************************
/*XBI *  OVRDBF FILE(SM000011OF) TOFILE(QAFDMBRL)                     *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Set customer number from 000000 to blank')
 **** *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000011 - Update 000000 customers to blanks                 *
      *                                                               *
      *  Function:  This program will change all customer fields      *
      *  (identified on file SMCNUMPD) that contain six zeroes to     *
      *  blank.  If the update of a field (via SQL) is successful     *
      *  then a status flag on SMCNUMPD is set to 'Y'; if there is an *
      *  error then it is set to 'E'.                                 *
      *                                                               *
      *  Called By: SMC000111                                         *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027  *CREATE    Date 01Nov05               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Change customer number from numeric to alpha.       *
      *                                                               *
      **********************************************************************
      * File Declarations                                                  *
      **********************************************************************
      *
      * PF containing all CNUM Flds along with thier PF Names
     FSMCNUMPD  IF   E           K DISK    INFSR(*PSSR)
      *
     FSM000011OFIF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
      *
      **********************************************************************
      * Variable declaration                                               *
      **********************************************************************
     D WSTRSQL         S           2000A   INZ(*BLANKS)
     D WSTRWHERE       S            500A   INZ(*BLANKS)
     D WFILNAM         S             10A   INZ(*BLANKS)
     D WFILNAM1        S             10A   INZ(*BLANKS)
     D WFLDNAM         S             10A   INZ(*BLANKS)
     D WFLDNAM1        S             10A   INZ(*BLANKS)
     D WFUPDF          S              1A   INZ(*BLANKS)
     D WFERR           S              1A   INZ(*BLANKS)
     D ERROR_FLAG      S              1A   INZ('Y')
     D OKFLG           S              1A   INZ(' ')
     D ACTION          S              7A   INZ(' ')
     D GENPGM          S             10A   INZ(' ')
     D ERRORMSG        S            100A   INZ(' ')
     D AlreadyRun      S              1A
      *
     D WOvrCMDStr      S            100A
     D WDltCMDStr      S             50A
     D WDSPCMDStr      S            150A
     D WCRTFStr        S            100A
     D WCMDLen         S             15  5
     D WErrMsg         S             40A
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              7
      *
     C                   IF        %OPEN(SM000011OF)
     C                   CLOSE     SM000011OF
     C                   ENDIF
      *
      * Set the value of Update Flag to 'N' so that records for the incorrect
      *  layer are not processed.
     C/Exec SQL
     C+ UPDATE SMCNUMPD SET CNUPDF = 'N' WHERE
     C+ CNLAYR <> :Mode
     C/End-Exec
      *
      * Declare Cursor on the Customer No. list file.
     C/Exec SQL
     C+ DECLARE C1 CURSOR FOR
     C+ SELECT CNFILE, CNFLD, CNUPDF FROM SMCNUMPD WHERE
     C+ TRIM(CNUPDF) = '' OR TRIM(CNUPDF) = 'E'
     C/End-Exec
      *
      * Open Cursor
     C/Exec SQL
     C+ OPEN C1
     C/End-Exec
      *
      * Check for record not found.
     C*Exec SQL WHENEVER NOT FOUND GOTO Tag_NotFound
     C*End-Exec
      *
      * Loop for cursor
     C     SQLCOD        DOUNE     0
      *
      * Fetch the values of Cursor into work variables.
     C/Exec SQL
     C+ FETCH C1 INTO :WFILNAM, :WFLDNAM, :WFUPDF
     C/End-Exec
      *
     C                   IF        WFILNAM <> *Blanks AND WFILNAM1 = *Blanks
     C                   EVAL      WSTRSQL = *Blanks
     C                   EVAL      WSTRSQL ='UPDATE '+ %Trim(WFILNAM) +' SET ' +
     C                             %Trim(WFLDNAM) + ' = CASE WHEN ' +
     C                             %Trim(WFLDNAM) + ' = ' + '''' +
     C                             '000000' + '''' +' THEN '+ '''' + '' + '''' +
     C                             ' ELSE ' + %Trim(WFLDNAM) + ' END '
      *
     C                   EVAL      WSTRWHERE = ' WHERE ' + %Trim(WFLDNAM)+ '= '+
     C                             '''' + '000000' + ''''
      *
     C                   ENDIF
      *
     C                   IF        WFILNAM = WFILNAM1 AND WFLDNAM = WFLDNAM1
     C                   GOTO      Tag_NotFound
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        WFILNAM = WFILNAM1 AND WFLDNAM <> WFLDNAM1
     C                   EVAL      WSTRSQL = %Trim(WSTRSQL)+ ', ' +
     C                             %Trim(WFLDNAM) + ' = CASE WHEN ' +
     C                             %Trim(WFLDNAM) + ' = ' + '''' +
     C                             '000000' + '''' +' THEN '+ '''' + '' + '''' +
     C                             ' ELSE ' + %Trim(WFLDNAM) + ' END '
      *
     C                   EVAL      WSTRWHERE = %TrimR(WSTRWHERE) + ' OR ' +
     C                             %Trim(WFLDNAM) + '= '+ '''' + '000000' + ''''
      *
     C                   ENDIF
      *
     C                   IF        WFILNAM <> WFILNAM1 AND WFILNAM1 <> *Blanks
      *
     C                   EXSR      UpdSr
      *
     C                   ENDIF
      *
     C                   EVAL      WFILNAM1 = WFILNAM
     C                   EVAL      WFLDNAM1 = WFLDNAM
      *
     C                   ENDDO
      *
     C     Tag_NotFound  Tag
      *
     C                   EXSR      UpdSr
      *
      * CLOSE the Cursor
     C/Exec SQL
     C+ CLOSE C1
     C/End-Exec
      *
     C                   IF        %OPEN(SM000011OF)
     C                   CLOSE     SM000011OF
     C                   ENDIF
      *
      * Update all Records in PF 'SMCNUMPD' with Blanks if all records
      * either 'Y' or 'N'.Extract from SMCNUMPD, how many records have been
      * successfully updated and how many are not worked upon.
     C                   CALL      'SM000012'
     C                   PARM      *Blank        OKFLG
      *
      * If All Records Updated Successfully Write Success Message in
      * in Error Log File
     C                   IF        OKFLG = 'Y' And WFERR <> 'E'
     C                   EVAL      ERRORMSG = 'All Customer Number Fields in +
     C                             all the Impacted Files Updated Successfully'
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      ACTION
     C                   PARM      'SM000011'    GENPGM
     C                   PARM                    ERRORMSG
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdSr  - Updates zeros to blanks in Customer Number fields.   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ERRHNDL                                                *
      *                                                               *
      *****************************************************************
      *
     C     UpdSr         BEGSR
      *
      * Build dynamic SQL string for update of Customer Number field.
     C                   EVAL      ERROR_FLAG = 'Y'
     C                   EVAL      WFERR = ' '
      *
     C                   EVAL      WSTRSQL=%Trim(WSTRSQL) +' '+ %Trim(WSTRWHERE)
      *
      * Prepare WSQLSTR as evaluated above in dynamic SQL build.
     C/Exec SQL
     C+ PREPARE S1 FROM :WSTRSQL
     C/End-Exec
      *
      * Execute the update statement.
     C                   IF        %OPEN(SM000011OF)
     C                   CLOSE     SM000011OF
     C                   ENDIF
      *
     C                   EVAL      WDSPCMDStr = *Blanks
     C                   EVAL      WDSPCMDStr = 'DSPFD FILE(*LIBL/'+
     C                             %TRIM(WFILNAM1) +
     C                             ') TYPE(*MBRLIST) OUTPUT(*OUTFILE) FILEATR'+
     C                             '(*PF) OUTFILE(QTEMP/SM000011OF)'
      *
     C                   EVAL      WCMDLen = %Len(%Trim(WDSPCMDStr))
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    WDSPCMDStr
     C                   PARM                    WCMDLen
      *
     C                   IF        %ERROR
     C                   EVAL      MLNAME = '*ALL'
     C                   EXSR      ERRHNDL
     C                   ENDIF
      *
     C                   IF        WFERR <> 'E'
      *
     C                   IF        NOT %OPEN(SM000011OF)
     C                   OPEN      SM000011OF
     C                   ENDIF
      *
     C                   READ      SM000011OF
     C                   DOW       Not %EOF(SM000011OF)
      *
      * Only process if file has members.
     C                   IF        MLNOMB <> 0
     C                   EVAL      WOvrCMDStr = *Blanks
     C                   EVAL      WOvrCMDStr='OVRDBF FILE('+%TRIM(WFILNAM1) +
     C                             ') TOFILE(*LIBL/'+%TRIM(WFILNAM1)+') MBR('+
     C                             %Trim(MLNAME)+')'
      *
     C                   EVAL      WCMDLen = %Len(%Trim(WOvrCMDStr))
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    WOvrCMDStr
     C                   PARM                    WCMDLen
      *
     C                   IF        %Error
     C                   EVAL      WErrMsg = 'Error Occurred in SRCMBR Override'
     C                   ENDIF
      *
     C*/Exec SQL WHENEVER SQLERROR GOTO Tag_ERROR
     C*/End-Exec
      *
     C/Exec SQL
     C+ EXECUTE S1
     C/End-Exec
      *
     C                   IF        SQLCOD < 0
     C                   EXSR      ERRHNDL
     C                   ENDIF
      *
     C                   EVAL      WDltCMDStr = *Blanks
     C                   EVAL      WDltCMDStr = 'DLTOVR FILE('+%TRIM(WFILNAM1)+
     C                             ')'
      *
     C                   EVAL      WCMDLen = %Len(%Trim(WDltCMDStr))
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    WDltCMDStr
     C                   PARM                    WCMDLen
      *
     C                   ENDIF
     C                   READ      SM000011OF
     C                   ENDDO
      *
     C                   ENDIF
      *
      * Update the CNUPDF field of SMCNUMPD to 'Y'.
     C                   IF        WFERR <> 'E'
     C/Exec SQL
     C+ UPDATE SMCNUMPD SET CNUPDF = 'Y' WHERE
     C+ CNFILE = :WFILNAM1
     C/End-Exec
     C                   EVAL      ERROR_FLAG = 'N'
     C                   ENDIF
      *
     C                   IF        WFILNAM <> WFILNAM1 AND WFILNAM1 <> *Blanks
     C                   EVAL      WSTRSQL = *Blanks
     C                   EVAL      WSTRSQL ='UPDATE '+ %Trim(WFILNAM) +' SET '+
     C                             %Trim(WFLDNAM) + ' = CASE WHEN ' +
     C                             %Trim(WFLDNAM) + ' = ' + '''' +
     C                             '000000' + '''' +' THEN '+ '''' + '' + '''' +
     C                             ' ELSE ' + %Trim(WFLDNAM) + ' END '
      *
     C                   EVAL      WSTRWHERE = ' WHERE ' + %Trim(WFLDNAM)+ '= '+
     C                             '''' + '000000' + ''''
      *
     C                   ENDIF
      *
     C     UpdSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ERRHNDL - Update the CNUPDF field of SMCNUMPD to 'E' if the   *
      *           update fails.                                       *
      *                                                               *
      * Called by: UpdSr                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ERRHNDL       BEGSR
      *
     C                   IF        ERROR_FLAG <> 'N'
      *
     C/Exec SQL
     C+ UPDATE SMCNUMPD SET CNUPDF = 'E' WHERE
     C+ CNFILE = :WFILNAM1
     C/End-Exec
      *
      * Write Error Message in Error Log File
     C                   EVAL      ERRORMSG = 'Error Occured While Updating +
     C                             File ' + %TRIM(WFILNAM1) + ' Member ' +
     C                             %TRIM(MLNAME)
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      ACTION
     C                   PARM      'SM000011'    GENPGM
     C                   PARM                    ERRORMSG
      *
     C                   EVAL      ERROR_FLAG = 'Y'
     C                   EVAL      WFERR = 'E'
      *
     C                   ENDIF
      *
     C     ERRHNDLE      ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - General Error Handling Subroutine for the Program    *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      * Set Indicator to Prevent Looping
     C     AlreadyRun    IFNE      'Y'
      *
     C                   EVAL      AlreadyRun = 'Y'
      *  Dump program
     C                   DUMP
      *
      * Send a Error Message to the Error Log Report
     C                   EVAL      ERRORMSG = 'A general error occured in +
     C                             program SM000011. Please check the dump +
     C                             and job log.'
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      ACTION
     C                   PARM      'SM000011'    GENPGM
     C                   PARM                    ERRORMSG
      *
     C                   ENDIF
      *
      *  Seton LR and return
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
