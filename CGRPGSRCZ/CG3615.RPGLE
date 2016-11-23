     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Select SQL Requests')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3615 - Select SQL requests                                 *
      *                                                               *
      *  Function:  This module selects authorised SQL requests and   *
      *  executes them.                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CCG016             Date 13Sep16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 230890             Date 25Nov04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015  *CREATE    Date 05Jul01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCG016 - Correspondence Manager for Retail Teller System     *
      *  230890 - Save SchemaName                                     *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CCG015 - Correspondence Manager                              *
      *                                                               *
      *****************************************************************
      /EJECT
      ** Group set files
     FCGUXMGL2  IF   E           K DISK
      ** Request files
     FCGSQLRL0  IF   E           K DISK
      ** Data reference
     FCGUDCRL0  IF   E           K DISK
      /EJECT
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
     DSchemaName       S                   LIKE(DGSHNM)
     DSchemaSav        S                   LIKE(DGSHNM)                                       230890
      ** Request return codes
     DRequestsRC       S             10
 
      ** Select requests
     DSelRequests      PR            10
     D p1                                  VALUE LIKE(DGSHNM)
      ** Log requests being executed
     DLogReq           PR            10
     D p2                                  VALUE LIKE(DGSHNM)
     D p3                                  VALUE LIKE(SQRQNM)
     D p4                                  VALUE LIKE(SQMBNM)
      ** Execute requests
     DExecuteReq       PR            10
     D p5                                  VALUE LIKE(SQMBNM)
 
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCMTSK          S              1A                                                      CSC022
     D PRTCD           S              7A                                                      CSC022
     D POPTN           S              7A                                                      CSC022
     D PSARD           S                   LIKE(SARN)                                         CSC022
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** Externally described DS for SAR Details                                              CSC022
                                                                                              CSC022
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC022
      ** DS for Access Programs - short data structure                                        CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
     C     keyUXMG2      KLIST
     C                   KFLD                    SchemaName
 
     C                   EVAL      RequestsRC = *BLANK
     C                   EVAL      ReturnCode = *BLANK
 
      ** Read the first schema extracted
     C                   EVAL      SchemaName = *LOVAL
     C     keyUXMG2      SETLL     CGUXMGL2
     C                   READ      CGUXMGL2
     C                   DOW       NOT %EOF AND RequestsRC <> '*ERROR'
     C                   EVAL      SchemaSav = DGSHNM                                         230890
      ** For each schema name being extracted
      ** Run a set of extracted request
     C                   EVAL      RequestsRC = SelRequests(DGSHNM)
      ** Read the next schema
     C**********         EVAL      SchemaName = DGSHNM                                        230890
     C                   EVAL      SchemaName = SchemaSav                                     230890
     C     keyUXMG2      SETGT     CGUXMGL2
     C                   READ      CGUXMGL2
     C                   ENDDO
 
     C                   IF        RequestsRC = '*ERROR'
     C                   EVAL      ReturnCode = '*ERROR'
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF
 
     C                   SETON                                        LR                      CCG016
     C                   RETURN
      **********************************************************************
      * INITIALISATION SUBROUTINE
      **********************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode       10
 
     C     keyUXMG1      KLIST
     C                   KFLD                    SchemaName
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 5                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
 
     C                   ENDSR
      *                                                                                       CSC022
      ** The following /COPY contains the standard program status                             CSC022
      ** subroutine, including a bound call to the DBERRCTL module.                           CSC022
      *                                                                                       CSC022
      /COPY ZACPYSRC,PSSR_ILE                                                                 CSC022
      *                                                                                       CSC022
      **********************************************************************
      * Select Requests                                                    *
      **********************************************************************
     PSelRequests      B
     DSelRequests      PI            10
     DSchemaName                           VALUE LIKE(DGSHNM)
 
     DRtnCode          S             10
 
     C     keySQLR0      KLIST
     C                   KFLD                    SchemaName
 
      ** Execute only the requests that are active
     C     keySQLR0      SETLL     CGSQLRL0
     C     keySQLR0      READE     CGSQLRL0
     C                   DOW       NOT %EOF AND RtnCode <> '*ERROR'
     C                   IF        SQACTV = 'Y'
     C                   EVAL      RtnCode = ExecuteReq(SQMBNM)
 
     C                   IF        RtnCode = *BLANK
     C                   EVAL      RtnCode = LogReq(SchemaName:SQRQNM:SQMBNM)
     C                   ENDIF
     C                   IF        RtnCode = *BLANK
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   ENDIF
 
     C                   ENDIF
     C     keySQLR0      READE     CGSQLRL0
     C                   ENDDO
 
     C                   RETURN    RtnCode
     P                 E
      **********************************************************************
      * Execute Requests                                                   *
      **********************************************************************
     PExecuteReq       B
     DExecuteReq       PI            10
     DRequestMbr                           VALUE LIKE(SQMBNM)
 
     DRtnCode          S             10
     DSourceFile       S             10
     DSyntaxCheck      S              1
 
     C                   CALL(E)   'CGC3601'
     C                   PARM                    RtnCode
     C                   PARM      'CGSQLTXT'    SourceFile
     C                   PARM                    RequestMbr
     C                   PARM      'N'           SyntaxCheck
 
     C                   IF        %ERROR OR RtnCode = '*ERROR'
     C                   EVAL      DBFILE = 'CGC3601'
     C                   MOVEL     DGITEM        DBKEY
     C                   EVAL      DBASE = 2
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN    RtnCode
     P                 E
      **********************************************************************
      * Log Requests                                                       *
      **********************************************************************
     PLogReq           B
     DLogReq           PI            10
     DSchemaName                           VALUE LIKE(DGSHNM)
     DRequestName                          VALUE LIKE(SQRQNM)
     DRequestMemb                          VALUE LIKE(SQMBNM)
 
     DFileFormat     E DS                        EXTNAME(CGUDCLPD)
     DRtnCode          S             10
     DItemNo           S                         LIKE(DGITEM)
 
     C     keyUXMG1      KLIST
     C                   KFLD                    SchemaName
     C                   KFLD                    ItemNo
 
     C                   EVAL      ItemNo = *LOVAL
     C     keyUXMG1      SETLL     CGUXMGL2
     C                   READ      CGUXMGL2
     C                   DOW       NOT %EOF AND RtnCode <> '*ERROR'
     C                             AND SchemaName = DGSHNM
     C                   CLEAR                   FileFormat
 
     C     DGITEM        SETLL     CGUDCRL0
     C     DGITEM        READE     CGUDCRL0
     C                   IF        NOT %FOUND(CGUDCRL0)
     C                   EVAL      DBFILE = 'CGUDCRL0'
     C                   MOVEL     DGITEM        DBKEY
     C                   EVAL      DBASE = 4
     C                   EVAL      RtnCode = '*ERROR'
     C                   DUMP
     C                   ELSE
     C                   DOW       NOT %EOF
     C                   EVAL      DLDCOR = DRDCOR
     C                   EVAL      DLITEM = DGITEM
     C                   EVAL      DLMSDT = RequestName + SchemaName
     C                   EVAL      DLMSID = 'CGD2541'
     C                   EVAL      DLRQNM = RequestName
     C                   EVAL      DLCPGM = 'CG3615'
     C                   EVAL      DLRPGM = 'CGCYY10'
 
     C                   CALL(E)   'CG9030'
     C                   PARM                    ReturnCd          7
     C                   PARM      '*WRITE'      ActionCode        8
     C                   PARM                    FileFormat
     C                   PARM      *BLANK        Title             7
     C                   PARM      *BLANK        Line              7
     C                   PARM      'YES'         CommitReq         3
 
     C                   IF        %ERROR OR ReturnCd <> *BLANK
     C                   EVAL      DBFILE = 'CG9030'
     C                   MOVEL     DGITEM        DBKEY
     C                   EVAL      DBASE = 3
     C                   EVAL      RtnCode = '*ERROR'
     C                   DUMP
     C                   ENDIF
 
     C     DGITEM        READE     CGUDCRL0
     C                   ENDDO
 
     C                   ENDIF
 
      ** Read next item number extracted under the same schema name
     C                   EVAL      ItemNo = DGITEM
     C     keyUXMG1      SETGT     CGUXMGL2
     C                   READ      CGUXMGL2
     C                   ENDDO
 
     C                   RETURN    RtnCode
     P                 E
